<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List,com.oms.model.Order,com.oms.model.Product" %>
<%
if (session.getAttribute("username") == null) { response.sendRedirect("login.jsp"); return; }
List<Order> orders = (List<Order>) request.getAttribute("orders");
List<Product> products = (List<Product>) request.getAttribute("products");
long lowStock = products.stream().filter(p -> p.getStock() < 5 && p.isActive()).count();
%>
<!DOCTYPE html>
<html><head><title>Dashboard</title><link rel="stylesheet" href="css/style.css"></head>
<body>
<nav><b>OMS</b><a href="dashboard">Dashboard</a><a href="customers">Customers</a><a href="products">Products</a><a href="orders">Orders</a><a href="logout">Logout</a></nav>
<div class="container">
<h1>Dashboard</h1>
<div class="stats">
<div class="stat"><span>Total Orders</span><strong><%= orders.size() %></strong></div>
<div class="stat"><span>Total Products</span><strong><%= products.size() %></strong></div>
<div class="stat"><span>Low Stock</span><strong><%= lowStock %></strong></div>
<div class="stat"><span>Delivered</span><strong><%= orders.stream().filter(o -> "DELIVERED".equals(o.getStatus())).count() %></strong></div>
</div>
<h2>Recent Orders</h2>
<table><tr><th>ID</th><th>Customer</th><th>Status</th><th>Total</th><th>Date</th></tr>
<% for (Order o : orders) { %>
<tr><td><a href="orders?id=<%= o.getId() %>">#<%= o.getId() %></a></td><td><%= o.getCustomerName() %></td><td><span class="badge"><%= o.getStatus() %></span></td><td>₹<%= o.getTotalAmount() %></td><td><%= o.getOrderDate() %></td></tr>
<% } %>
</table>
</div></body></html>
