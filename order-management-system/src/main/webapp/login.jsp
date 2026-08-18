<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head><title>OMS Login</title><link rel="stylesheet" href="css/style.css"></head>
<body class="center">
<div class="card login">
    <h1>Order Management System</h1>
    <p class="muted">Admin Login</p>
    <% if (request.getAttribute("error") != null) { %>
        <div class="error"><%= request.getAttribute("error") %></div>
    <% } %>
    <form method="post" action="login">
        <label>Username</label>
        <input name="username" required>
        <label>Password</label>
        <input type="password" name="password" required>
        <button type="submit">Login</button>
    </form>
    <p class="muted">Demo: admin / admin123</p>
</div>
</body>
</html>
