<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List,com.oms.model.Customer" %>
<% if (session.getAttribute("username") == null) { response.sendRedirect("login.jsp"); return; } %>
<!DOCTYPE html><html><head><title>Customers</title><link rel="stylesheet" href="css/style.css"></head>
<body><nav><b>OMS</b><a href="dashboard">Dashboard</a><a href="customers">Customers</a><a href="products">Products</a><a href="orders">Orders</a><a href="logout">Logout</a></nav>
<div class="container"><h1>Customers</h1>
<% if(request.getParameter("error") != null) { %><div class="error"><%= request.getParameter("error") %></div><% } %>
<div class="card"><h2>Add Customer</h2><form method="post" action="customers" class="row">
<input name="name" placeholder="Name" required><input name="email" type="email" placeholder="Email" required><input name="phone" placeholder="Phone"><button>Add</button>
</form></div>
<table><tr><th>ID</th><th>Name</th><th>Email</th><th>Phone</th><th>Action</th></tr>
<% for(Customer c:(List<Customer>)request.getAttribute("customers")) { %>
<tr><td><%=c.getId()%></td><td><%=c.getName()%></td><td><%=c.getEmail()%></td><td><%=c.getPhone()%></td><td>
<form method="post" action="customers" onsubmit="return confirm('Delete customer?')"><input type="hidden" name="action" value="delete"><input type="hidden" name="id" value="<%=c.getId()%>"><button class="danger">Delete</button></form>
</td></tr>
<% } %></table></div></body></html>
