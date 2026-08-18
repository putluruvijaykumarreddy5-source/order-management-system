package com.oms.service;

import com.oms.dao.ProductDAO;
import com.oms.model.Product;
import java.sql.SQLException;
import java.util.List;

public class ProductService {
    private final ProductDAO dao = new ProductDAO();
    public List<Product> findAll() throws SQLException { return dao.findAll(); }
    public List<Product> findActive() throws SQLException { return dao.findActive(); }
    public void save(Product p) throws SQLException {
        if (p.getName() == null || p.getName().isBlank()) throw new IllegalArgumentException("Product name is required.");
        if (p.getPrice() == null || p.getPrice().signum() < 0) throw new IllegalArgumentException("Price must be valid.");
        if (p.getStock() < 0) throw new IllegalArgumentException("Stock cannot be negative.");
        dao.save(p);
    }
    public void update(Product p) throws SQLException { dao.update(p); }
    public void delete(int id) throws SQLException { dao.delete(id); }
}
