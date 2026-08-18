package com.oms.servlet;

import com.oms.model.OrderItem;
import com.oms.service.CustomerService;
import com.oms.service.OrderService;
import com.oms.service.ProductService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {
    private final OrderService orderService = new OrderService();
    private final CustomerService customerService = new CustomerService();
    private final ProductService productService = new ProductService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            String view = req.getParameter("view");
            if ("create".equals(view)) {
                req.setAttribute("customers", customerService.findAll());
                req.setAttribute("products", productService.findActive());
                req.getRequestDispatcher("/create-order.jsp").forward(req, resp);
                return;
            }

            String id = req.getParameter("id");
            if (id != null) {
                req.setAttribute("order", orderService.findById(Integer.parseInt(id)));
                req.getRequestDispatcher("/order-details.jsp").forward(req, resp);
                return;
            }

            req.setAttribute("orders", orderService.findAll());
            req.getRequestDispatcher("/orders.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load orders.", e);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            String action = req.getParameter("action");
            if ("status".equals(action)) {
                orderService.updateStatus(Integer.parseInt(req.getParameter("id")),
                        req.getParameter("status"));
            } else {
                int customerId = Integer.parseInt(req.getParameter("customerId"));
                String[] productIds = req.getParameterValues("productId");
                String[] quantities = req.getParameterValues("quantity");

                List<OrderItem> items = new ArrayList<>();
                if (productIds != null) {
                    for (int i = 0; i < productIds.length; i++) {
                        int productId = Integer.parseInt(productIds[i]);
                        int quantity = Integer.parseInt(quantities[i]);
                        if (quantity > 0) items.add(new OrderItem(productId, null, quantity, null));
                    }
                }
                int orderId = orderService.createOrder(customerId, items);
                resp.sendRedirect(req.getContextPath() + "/orders?id=" + orderId);
                return;
            }
            resp.sendRedirect(req.getContextPath() + "/orders");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/orders?error=" +
                    java.net.URLEncoder.encode(e.getMessage(), java.nio.charset.StandardCharsets.UTF_8));
        }
    }
}
