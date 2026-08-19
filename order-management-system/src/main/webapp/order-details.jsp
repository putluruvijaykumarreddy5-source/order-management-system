<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oms.model.Order" %>
<%@ page import="com.oms.model.OrderItem" %>
<%@ page import="java.util.List" %>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    Order order = (Order) request.getAttribute("order");
%>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Order Details</title>
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

<%
    if (order == null) {
%>

    <div class="card">

        <h1>Order Not Found</h1>

        <p>
            The requested order could not be found.
        </p>

        <a class="button" href="orders">
            Back to Orders
        </a>

    </div>

<%
    } else {

        List<OrderItem> items = order.getItems();

        if (items == null) {
            items = java.util.Collections.emptyList();
        }
%>

    <div class="header-row">

        <h1>
            Order #<%= order.getId() %>
        </h1>

        <a class="button" href="orders">
            Back to Orders
        </a>

    </div>


    <div class="card">

        <p>
            <b>Customer:</b>
            <%= order.getCustomerName() %>
        </p>

        <p>
            <b>Status:</b>

            <span class="badge">
                <%= order.getStatus() %>
            </span>
        </p>

        <p>
            <b>Date:</b>
            <%= order.getOrderDate() %>
        </p>

        <p>
            <b>Total:</b>
            ₹<%= order.getTotalAmount() %>
        </p>

    </div>


    <h2>Order Items</h2>

    <table>

        <tr>
            <th>Product</th>
            <th>Quantity</th>
            <th>Price</th>
            <th>Total</th>
        </tr>

<%
        if (items.isEmpty()) {
%>

        <tr>
            <td colspan="4">
                No items found.
            </td>
        </tr>

<%
        } else {

            for (OrderItem item : items) {
%>

        <tr>

            <td>
                <%= item.getProductName() %>
            </td>

            <td>
                <%= item.getQuantity() %>
            </td>

            <td>
                ₹<%= item.getPrice() %>
            </td>

            <td>
                ₹<%= item.getTotal() %>
            </td>

        </tr>

<%
            }
        }
%>

    </table>

<%
    }
%>

</div>

</body>
</html>