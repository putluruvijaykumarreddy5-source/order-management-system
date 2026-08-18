<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List,com.oms.model.Product" %>
<% if (session.getAttribute("username") == null) { response.sendRedirect("login.jsp"); return; } %>
<!DOCTYPE html><html><head><title>Products</title><link rel="stylesheet" href="css/style.css"></head>
<body><nav><b>OMS</b><a href="dashboard">Dashboard</a><a href="customers">Customers</a><a href="products">Products</a><a href="orders">Orders</a><a href="logout">Logout</a></nav>
<div class="container"><h1>Products</h1>
<% if(request.getParameter("error") != null) { %><div class="error"><%= request.getParameter("error") %></div><% } %>
<div class="card"><h2>Add Product</h2><form method="post" action="products" class="row">
<input name="name" placeholder="Product name" required><input name="price" type="number" step="0.01" placeholder="Price" required><input name="stock" type="number" min="0" placeholder="Stock" required><button>Add</button>
</form></div>
<table><tr><th>ID</th><th>Name</th><th>Price</th><th>Stock</th><th>Status</th><th>Action</th></tr>
<% for(Product p:(List<Product>)request.getAttribute("products")) { %>
<tr><td><%=p.getId()%></td><td><%=p.getName()%></td><td>₹<%=p.getPrice()%></td><td><%=p.getStock()%></td><td><%=p.isActive()?"ACTIVE":"INACTIVE"%></td><td>
<form method="post" action="products"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%=p.getId()%>"><button class="danger">Deactivate</button></form>
</td></tr>
<% } %></table></div></body></html>
