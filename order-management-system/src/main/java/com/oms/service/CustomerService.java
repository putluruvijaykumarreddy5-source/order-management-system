package com.oms.service;

import com.oms.dao.CustomerDAO;
import com.oms.model.Customer;
import java.sql.SQLException;
import java.util.List;

public class CustomerService {
    private final CustomerDAO dao = new CustomerDAO();
    public List<Customer> findAll() throws SQLException { return dao.findAll(); }
    public void save(Customer c) throws SQLException { validate(c); dao.save(c); }
    public void update(Customer c) throws SQLException { validate(c); dao.update(c); }
    public void delete(int id) throws SQLException { dao.delete(id); }

    private void validate(Customer c) {
        if (c.getName() == null || c.getName().isBlank()) throw new IllegalArgumentException("Name is required.");
        if (c.getEmail() == null || c.getEmail().isBlank()) throw new IllegalArgumentException("Email is required.");
    }
}
