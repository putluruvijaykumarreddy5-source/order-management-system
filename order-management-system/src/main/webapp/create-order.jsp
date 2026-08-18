<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List,com.oms.model.Customer,com.oms.model.Product" %>
<!DOCTYPE html><html><head><title>Create Order</title><link rel="stylesheet" href="css/style.css"></head>
<body><nav><b>OMS</b><a href="dashboard">Dashboard</a><a href="customers">Customers</a><a href="products">Products</a><a href="orders">Orders</a><a href="logout">Logout</a></nav>
<div class="container"><h1>Create Order</h1>
<div class="card"><form method="post" action="orders">
<label>Customer</label><select name="customerId" required>
<% for(Customer c:(List<Customer>)request.getAttribute("customers")) { %><option value="<%=c.getId()%>"><%=c.getName()%> - <%=c.getEmail()%></option><% } %>
</select>
<h2>Products</h2>
<table><tr><th>Product</th><th>Price</th><th>Available</th><th>Quantity</th></tr>
<% for(Product p:(List<Product>)request.getAttribute("products")) { %>
<tr><td><input type="hidden" name="productId" value="<%=p.getId()%>"><%=p.getName()%></td><td>₹<%=p.getPrice()%></td><td><%=p.getStock()%></td><td><input name="quantity" type="number" min="0" max="<%=p.getStock()%>" value="0"></td></tr>
<% } %></table><button type="submit">Place Order</button></form></div></div></body></html>
