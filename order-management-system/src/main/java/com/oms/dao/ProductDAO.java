package com.oms.dao;

import com.oms.model.Product;
import com.oms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO {
    public List<Product> findAll() throws SQLException {
        String sql = "SELECT id,name,price,stock,active FROM products ORDER BY id DESC";
        List<Product> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public List<Product> findActive() throws SQLException {
        String sql = "SELECT id,name,price,stock,active FROM products WHERE active=true ORDER BY name";
        List<Product> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public Product findById(int id) throws SQLException {
        String sql = "SELECT id,name,price,stock,active FROM products WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public void save(Product p) throws SQLException {
        String sql = "INSERT INTO products(name,price,stock,active) VALUES(?,?,?,true)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setBigDecimal(2, p.getPrice());
            ps.setInt(3, p.getStock());
            ps.executeUpdate();
        }
    }

    public void update(Product p) throws SQLException {
        String sql = "UPDATE products SET name=?,price=?,stock=?,active=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, p.getName());
            ps.setBigDecimal(2, p.getPrice());
            ps.setInt(3, p.getStock());
            ps.setBoolean(4, p.isActive());
            ps.setInt(5, p.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "UPDATE products SET active=false WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private Product map(ResultSet rs) throws SQLException {
        return new Product(rs.getInt("id"), rs.getString("name"),
                rs.getBigDecimal("price"), rs.getInt("stock"), rs.getBoolean("active"));
    }
}
