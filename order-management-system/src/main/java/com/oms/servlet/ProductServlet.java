package com.oms.servlet;

import com.oms.model.Product;
import com.oms.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/products")
public class ProductServlet extends HttpServlet {
    private final ProductService service = new ProductService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("products", service.findAll());
            req.getRequestDispatcher("/products.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load products.", e);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            String action = req.getParameter("action");
            if ("delete".equals(action)) {
                service.delete(Integer.parseInt(req.getParameter("id")));
            } else if ("update".equals(action)) {
                Product p = new Product(Integer.parseInt(req.getParameter("id")),
                        req.getParameter("name"), new BigDecimal(req.getParameter("price")),
                        Integer.parseInt(req.getParameter("stock")),
                        Boolean.parseBoolean(req.getParameter("active")));
                service.update(p);
            } else {
                service.save(new Product(req.getParameter("name"),
                        new BigDecimal(req.getParameter("price")),
                        Integer.parseInt(req.getParameter("stock"))));
            }
            resp.sendRedirect(req.getContextPath() + "/products");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/products?error=" +
                    java.net.URLEncoder.encode(e.getMessage(), java.nio.charset.StandardCharsets.UTF_8));
        }
    }
}
