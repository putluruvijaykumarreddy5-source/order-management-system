<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.oms.model.Order" %>
<%@ page import="com.oms.model.Product" %>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Order> orders =
            (List<Order>) request.getAttribute("orders");

    List<Product> products =
            (List<Product>) request.getAttribute("products");

    if (orders == null) {
        orders = java.util.Collections.emptyList();
    }

    if (products == null) {
        products = java.util.Collections.emptyList();
    }

    long lowStock = products.stream()
            .filter(p -> p.getStock() < 5 && p.isActive())
            .count();
%>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Dashboard</title>

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

    <h1>Dashboard</h1>

    <div class="card">

        <h2>Order Management System</h2>

        <p>
            Welcome,
            <strong><%= session.getAttribute("username") %></strong>
        </p>

    </div>

    <br>

    <div class="row">

        <div class="card">
            <h3>Total Orders</h3>
            <p><%= orders.size() %></p>
        </div>

        <div class="card">
            <h3>Total Products</h3>
            <p><%= products.size() %></p>
        </div>

        <div class="card">
            <h3>Low Stock</h3>
            <p><%= lowStock %></p>
        </div>

    </div>

    <br>

    <div class="card">

        <h2>Quick Actions</h2>

        <a class="button" href="customers">
            Customers
        </a>

        <a class="button" href="products">
            Products
        </a>

        <a class="button" href="orders">
            Orders
        </a>

        <a class="button" href="orders?view=create">
            Create Order
        </a>

    </div>

</div>

</body>
</html>