package com.oms.dao;

import com.oms.model.Customer;
import com.oms.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDAO {
    public List<Customer> findAll() throws SQLException {
        String sql = "SELECT id, name, email, phone FROM customers ORDER BY id DESC";
        List<Customer> list = new ArrayList<>();
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) list.add(map(rs));
        }
        return list;
    }

    public Customer findById(int id) throws SQLException {
        String sql = "SELECT id, name, email, phone FROM customers WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                return rs.next() ? map(rs) : null;
            }
        }
    }

    public void save(Customer customer) throws SQLException {
        String sql = "INSERT INTO customers(name,email,phone) VALUES(?,?,?)";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, customer.getName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getPhone());
            ps.executeUpdate();
        }
    }

    public void update(Customer customer) throws SQLException {
        String sql = "UPDATE customers SET name=?, email=?, phone=? WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setString(1, customer.getName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getPhone());
            ps.setInt(4, customer.getId());
            ps.executeUpdate();
        }
    }

    public void delete(int id) throws SQLException {
        String sql = "DELETE FROM customers WHERE id=?";
        try (Connection c = DBConnection.getConnection();
             PreparedStatement ps = c.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        }
    }

    private Customer map(ResultSet rs) throws SQLException {
        return new Customer(rs.getInt("id"), rs.getString("name"),
                rs.getString("email"), rs.getString("phone"));
    }
}
