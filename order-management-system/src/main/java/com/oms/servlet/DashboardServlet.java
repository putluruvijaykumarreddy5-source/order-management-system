package com.oms.servlet;

import com.oms.service.OrderService;
import com.oms.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final ProductService productService = new ProductService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("orders", orderService.findAll());
            req.setAttribute("products", productService.findAll());
            req.getRequestDispatcher("/dashboard.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load dashboard.", e);
        }
    }
}
