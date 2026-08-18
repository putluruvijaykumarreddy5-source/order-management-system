package com.oms.dao;

import com.oms.model.Order;
import com.oms.model.OrderItem;
import com.oms.model.Product;
import com.oms.util.DBConnection;

import java.math.BigDecimal;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {
    public List<Order> findAll() throws SQLException {
        String sql = """
            SELECT o.id,o.customer_id,c.name AS customer_name,o.status,o.total_amount,o.order_date
            FROM orders o JOIN customers c ON c.id=o.customer_id
            ORDER BY o.id DESC
            """;
        List<Order> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public Order findById(int id) throws SQLException {
        String sql = """
            SELECT o.id,o.customer_id,c.name AS customer_name,o.status,o.total_amount,o.order_date
            FROM orders o JOIN customers c ON c.id=o.customer_id WHERE o.id=?
            """;
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                Order order = map(rs);
                order.setItems(findItems(c, id));
                return order;
            }
        }
    }

    public int createOrder(int customerId, List<OrderItem> items) throws SQLException {
        if (items == null || items.isEmpty()) throw new SQLException("Order must contain at least one item.");

        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            try {
                BigDecimal total = BigDecimal.ZERO;
                List<OrderItem> verified = new ArrayList<>();

                for (OrderItem item : items) {
                    if (item.getQuantity() <= 0) throw new SQLException("Quantity must be greater than zero.");

                    Product p = getProductForUpdate(c, item.getProductId());
                    if (p == null || !p.isActive()) throw new SQLException("Product not found or inactive: " + item.getProductId());
                    if (p.getStock() < item.getQuantity()) {
                        throw new SQLException("Insufficient stock for " + p.getName() + ". Available: " + p.getStock());
                    }

                    item.setProductName(p.getName());
                    item.setPrice(p.getPrice());
                    total = total.add(p.getPrice().multiply(BigDecimal.valueOf(item.getQuantity())));
                    verified.add(item);
                }

                int orderId;
                String orderSql = "INSERT INTO orders(customer_id,status,total_amount) VALUES(?,'PENDING',?) RETURNING id";
                try (PreparedStatement ps = c.prepareStatement(orderSql)) {
                    ps.setInt(1, customerId);
                    ps.setBigDecimal(2, total);
                    try (ResultSet rs = ps.executeQuery()) {
                        rs.next();
                        orderId = rs.getInt(1);
                    }
                }

                String itemSql = "INSERT INTO order_items(order_id,product_id,quantity,price) VALUES(?,?,?,?)";
                String stockSql = "UPDATE products SET stock=stock-? WHERE id=?";
                try (PreparedStatement itemPs = c.prepareStatement(itemSql);
                     PreparedStatement stockPs = c.prepareStatement(stockSql)) {
                    for (OrderItem item : verified) {
                        itemPs.setInt(1, orderId);
                        itemPs.setInt(2, item.getProductId());
                        itemPs.setInt(3, item.getQuantity());
                        itemPs.setBigDecimal(4, item.getPrice());
                        itemPs.addBatch();

                        stockPs.setInt(1, item.getQuantity());
                        stockPs.setInt(2, item.getProductId());
                        stockPs.addBatch();
                    }
                    itemPs.executeBatch();
                    stockPs.executeBatch();
                }

                c.commit();
                return orderId;
            } catch (Exception e) {
                c.rollback();
                if (e instanceof SQLException se) throw se;
                throw new SQLException("Unable to create order.", e);
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    public void updateStatus(int orderId, String status) throws SQLException {
        if (!List.of("PENDING","SHIPPED","DELIVERED","CANCELLED").contains(status)) {
            throw new SQLException("Invalid order status.");
        }

        try (Connection c = DBConnection.getConnection()) {
            c.setAutoCommit(false);
            try {
                String current = null;
                try (PreparedStatement ps = c.prepareStatement("SELECT status FROM orders WHERE id=? FOR UPDATE")) {
                    ps.setInt(1, orderId);
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) current = rs.getString(1);
                    }
                }
                if (current == null) throw new SQLException("Order not found.");

                if ("CANCELLED".equals(status) && !"CANCELLED".equals(current)) {
                    restoreStock(c, orderId);
                }

                try (PreparedStatement ps = c.prepareStatement("UPDATE orders SET status=? WHERE id=?")) {
                    ps.setString(1, status);
                    ps.setInt(2, orderId);
                    ps.executeUpdate();
                }
                c.commit();
            } catch (Exception e) {
                c.rollback();
                if (e instanceof SQLException se) throw se;
                throw new SQLException("Unable to update order.", e);
            } finally {
                c.setAutoCommit(true);
            }
        }
    }

    private void restoreStock(Connection c, int orderId) throws SQLException {
        String sql = """
            UPDATE products p
            SET stock = p.stock + oi.quantity
            FROM order_items oi
            WHERE oi.product_id=p.id AND oi.order_id=?
            """;
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            ps.executeUpdate();
        }
    }

    private Product getProductForUpdate(Connection c, int id) throws SQLException {
        String sql = "SELECT id,name,price,stock,active FROM products WHERE id=? FOR UPDATE";
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (!rs.next()) return null;
                return new Product(rs.getInt("id"), rs.getString("name"),
                        rs.getBigDecimal("price"), rs.getInt("stock"), rs.getBoolean("active"));
            }
        }
    }

    private List<OrderItem> findItems(Connection c, int orderId) throws SQLException {
        String sql = """
            SELECT oi.id,oi.order_id,oi.product_id,p.name,oi.quantity,oi.price
            FROM order_items oi JOIN products p ON p.id=oi.product_id
            WHERE oi.order_id=? ORDER BY oi.id
            """;
        List<OrderItem> list = new ArrayList<>();
        try (PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, orderId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem(rs.getInt("product_id"), rs.getString("name"),
                            rs.getInt("quantity"), rs.getBigDecimal("price"));
                    item.setId(rs.getInt("id"));
                    item.setOrderId(rs.getInt("order_id"));
                    list.add(item);
                }
            }
        }
        return list;
    }

    private Order map(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setId(rs.getInt("id"));
        o.setCustomerId(rs.getInt("customer_id"));
        o.setCustomerName(rs.getString("customer_name"));
        o.setStatus(rs.getString("status"));
        o.setTotalAmount(rs.getBigDecimal("total_amount"));
        o.setOrderDate(rs.getTimestamp("order_date").toLocalDateTime());
        return o;
    }
}
