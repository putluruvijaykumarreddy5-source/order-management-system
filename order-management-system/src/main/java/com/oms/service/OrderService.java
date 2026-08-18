package com.oms.service;

import com.oms.dao.OrderDAO;
import com.oms.model.Order;
import com.oms.model.OrderItem;

import java.sql.SQLException;
import java.util.List;

public class OrderService {
    private final OrderDAO dao = new OrderDAO();
    public List<Order> findAll() throws SQLException { return dao.findAll(); }
    public Order findById(int id) throws SQLException { return dao.findById(id); }
    public int createOrder(int customerId, List<OrderItem> items) throws SQLException {
        return dao.createOrder(customerId, items);
    }
    public void updateStatus(int id, String status) throws SQLException {
        dao.updateStatus(id, status);
    }
}
