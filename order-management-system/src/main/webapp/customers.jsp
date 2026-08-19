<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.oms.model.Customer" %>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Customer> customers =
            (List<Customer>) request.getAttribute("customers");

    if (customers == null) {
        customers = java.util.Collections.emptyList();
    }
%>

<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <title>Customers</title>
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

    <div class="header-row">
        <h1>Customers</h1>
    </div>

    <% if (request.getParameter("error") != null) { %>
        <div class="error">
            <%= request.getParameter("error") %>
        </div>
    <% } %>

    <div class="card">

        <h2>Add Customer</h2>

        <form method="post" action="customers">

            <input
                name="name"
                placeholder="Name"
                required>

            <input
                name="email"
                type="email"
                placeholder="Email"
                required>

            <input
                name="phone"
                placeholder="Phone">

            <button type="submit">
                Add
            </button>

        </form>

    </div>

    <br>

    <table>

        <tr>
            <th>ID</th>
            <th>Name</th>
            <th>Email</th>
            <th>Phone</th>
            <th>Action</th>
        </tr>

        <% if (customers.isEmpty()) { %>

            <tr>
                <td colspan="5">
                    No customers found.
                </td>
            </tr>

        <% } else { %>

            <% for (Customer c : customers) { %>

                <tr>

                    <td>
                        <%= c.getId() %>
                    </td>

                    <td>
                        <%= c.getName() %>
                    </td>

                    <td>
                        <%= c.getEmail() %>
                    </td>

                    <td>
                        <%= c.getPhone() %>
                    </td>

                    <td>

                        <form
                            method="post"
                            action="customers"
                            onsubmit="return confirm('Delete customer?')">

                            <input
                                type="hidden"
                                name="action"
                                value="delete">

                            <input
                                type="hidden"
                                name="id"
                                value="<%= c.getId() %>">

                            <button
                                type="submit"
                                class="danger">
                                Delete
                            </button>

                        </form>

                    </td>

                </tr>

            <% } %>

        <% } %>

    </table>

</div>

</body>
</html>