<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.oms.model.Customer" %>
<%@ page import="com.oms.model.Product" %>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Customer> customers =
            (List<Customer>) request.getAttribute("customers");

    List<Product> products =
            (List<Product>) request.getAttribute("products");

    if (customers == null) {
        customers = java.util.Collections.emptyList();
    }

    if (products == null) {
        products = java.util.Collections.emptyList();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Create Order</title>
    <link rel="stylesheet" href="css/style.css">
</head>

<body>

<nav>
    <b>OMS</b>
    <a href="dashboard">Dashboard</a>
    <a href="customers">Customers</a>
    <a href="products">Products</a>
    <a href="orders">Orders</a>
    <a href="logout">Logout</a>
</nav>

<div class="container">

    <h1>Create Order</h1>

    <% if (request.getParameter("error") != null) { %>
        <div class="error">
            <%= request.getParameter("error") %>
        </div>
    <% } %>

    <div class="card">

        <form method="post" action="orders">

            <label>Customer</label>

            <select name="customerId" required>

                <option value="">Select Customer</option>

                <% for (Customer c : customers) { %>

                    <option value="<%= c.getId() %>">
                        <%= c.getName() %> - <%= c.getEmail() %>
                    </option>

                <% } %>

            </select>


            <h2>Products</h2>

            <% if (products.isEmpty()) { %>

                <p>No active products available.</p>

            <% } else { %>

                <table>

                    <tr>
                        <th>Product</th>
                        <th>Price</th>
                        <th>Available</th>
                        <th>Quantity</th>
                    </tr>

                    <% for (Product p : products) { %>

                    <tr>

                        <td>
                            <%= p.getName() %>

                            <input
                                type="hidden"
                                name="productId"
                                value="<%= p.getId() %>">
                        </td>

                        <td>
                            ₹<%= p.getPrice() %>
                        </td>

                        <td>
                            <%= p.getStock() %>
                        </td>

                        <td>
                            <input
                                type="number"
                                name="quantity"
                                min="0"
                                max="<%= p.getStock() %>"
                                value="0">
                        </td>

                    </tr>

                    <% } %>

                </table>

                <br>

                <button type="submit">
                    Create Order
                </button>

                <a class="button" href="orders">
                    Cancel
                </a>

            <% } %>

        </form>

    </div>

</div>

</body>
</html>