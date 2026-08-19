package com.oms.servlet;

import com.oms.model.Customer;
import com.oms.model.OrderItem;
import com.oms.model.Product;
import com.oms.service.CustomerService;
import com.oms.service.OrderService;
import com.oms.service.ProductService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/orders")
public class OrderServlet extends HttpServlet {

    private final OrderService orderService = new OrderService();
    private final CustomerService customerService = new CustomerService();
    private final ProductService productService = new ProductService();

    // =========================
    // GET
    // =========================

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        try {

            String view = req.getParameter("view");

            // =========================
            // CREATE ORDER PAGE
            // =========================

            if ("create".equals(view)) {

                List<Customer> customers = customerService.findAll();
                List<Product> products = productService.findActive();

                // Never send null lists to JSP
                if (customers == null) {
                    customers = new ArrayList<>();
                }

                if (products == null) {
                    products = new ArrayList<>();
                }

                req.setAttribute("customers", customers);
                req.setAttribute("products", products);

                req.getRequestDispatcher("/create-order.jsp")
                        .forward(req, resp);

                return;
            }

            // =========================
            // ORDER DETAILS
            // =========================

            String id = req.getParameter("id");

            if (id != null && !id.trim().isEmpty()) {

                int orderId = Integer.parseInt(id);

                req.setAttribute(
                        "order",
                        orderService.findById(orderId)
                );

                req.getRequestDispatcher("/order-details.jsp")
                        .forward(req, resp);

                return;
            }

            // =========================
            // ALL ORDERS
            // =========================

            List<?> orders = orderService.findAll();

            if (orders == null) {
                orders = new ArrayList<>();
            }

            req.setAttribute("orders", orders);

            req.getRequestDispatcher("/orders.jsp")
                    .forward(req, resp);

        } catch (Exception e) {

            e.printStackTrace();

            throw new ServletException(
                    "Unable to load orders.",
                    e
            );
        }
    }

    // =========================
    // POST
    // =========================

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {

        try {

            String action = req.getParameter("action");

            // =========================
            // UPDATE ORDER STATUS
            // =========================

            if ("status".equals(action)) {

                int orderId = Integer.parseInt(
                        req.getParameter("id")
                );

                String status = req.getParameter("status");

                orderService.updateStatus(
                        orderId,
                        status
                );

                resp.sendRedirect(
                        req.getContextPath() + "/orders"
                );

                return;
            }

            // =========================
            // CREATE ORDER
            // =========================

            int customerId = Integer.parseInt(
                    req.getParameter("customerId")
            );

            String[] productIds =
                    req.getParameterValues("productId");

            String[] quantities =
                    req.getParameterValues("quantity");

            List<OrderItem> items = new ArrayList<>();

            if (productIds != null && quantities != null) {

                for (int i = 0; i < productIds.length; i++) {

                    int productId =
                            Integer.parseInt(productIds[i]);

                    int quantity =
                            Integer.parseInt(quantities[i]);

                    if (quantity > 0) {

                        OrderItem item = new OrderItem(
                                productId,
                                null,
                                quantity,
                                null
                        );

                        items.add(item);
                    }
                }
            }

            if (items.isEmpty()) {

                String message =
                        URLEncoder.encode(
                                "Please select at least one product.",
                                StandardCharsets.UTF_8
                        );

                resp.sendRedirect(
                        req.getContextPath()
                                + "/orders?view=create&error="
                                + message
                );

                return;
            }

            int orderId =
                    orderService.createOrder(
                            customerId,
                            items
                    );

            resp.sendRedirect(
                    req.getContextPath()
                            + "/orders?id="
                            + orderId
            );

        } catch (Exception e) {

            e.printStackTrace();

            String message =
                    URLEncoder.encode(
                            e.getMessage() != null
                                    ? e.getMessage()
                                    : "Unable to create order.",
                            StandardCharsets.UTF_8
                    );

            resp.sendRedirect(
                    req.getContextPath()
                            + "/orders?error="
                            + message
            );
        }
    }
}