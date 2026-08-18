<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.oms.model.Order,com.oms.model.OrderItem" %>
<% Order o=(Order)request.getAttribute("order"); %>
<!DOCTYPE html><html><head><title>Order Details</title><link rel="stylesheet" href="css/style.css"></head>
<body><nav><b>OMS</b><a href="dashboard">Dashboard</a><a href="customers">Customers</a><a href="products">Products</a><a href="orders">Orders</a><a href="logout">Logout</a></nav>
<div class="container"><h1>Order #<%=o.getId()%></h1><div class="card">
<p><b>Customer:</b> <%=o.getCustomerName()%></p><p><b>Status:</b> <%=o.getStatus()%></p><p><b>Date:</b> <%=o.getOrderDate()%></p><p><b>Total:</b> ₹<%=o.getTotalAmount()%></p>
</div><table><tr><th>Product</th><th>Quantity</th><th>Price</th><th>Total</th></tr>
<% for(OrderItem i:o.getItems()) { %><tr><td><%=i.getProductName()%></td><td><%=i.getQuantity()%></td><td>₹<%=i.getPrice()%></td><td>₹<%=i.getTotal()%></td></tr><% } %>
</table></div></body></html>
