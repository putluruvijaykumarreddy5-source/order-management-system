package com.oms.servlet;

import com.oms.model.Customer;
import com.oms.service.CustomerService;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/customers")
public class CustomerServlet extends HttpServlet {
    private final CustomerService service = new CustomerService();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        try {
            req.setAttribute("customers", service.findAll());
            req.getRequestDispatcher("/customers.jsp").forward(req, resp);
        } catch (Exception e) {
            throw new ServletException("Unable to load customers.", e);
        }
    }

    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        try {
            String action = req.getParameter("action");
            if ("delete".equals(action)) {
                service.delete(Integer.parseInt(req.getParameter("id")));
            } else if ("update".equals(action)) {
                service.update(new Customer(
                        Integer.parseInt(req.getParameter("id")),
                        req.getParameter("name"), req.getParameter("email"), req.getParameter("phone")));
            } else {
                service.save(new Customer(req.getParameter("name"),
                        req.getParameter("email"), req.getParameter("phone")));
            }
            resp.sendRedirect(req.getContextPath() + "/customers");
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/customers?error=" +
                    java.net.URLEncoder.encode(e.getMessage(), java.nio.charset.StandardCharsets.UTF_8));
        }
    }
}
