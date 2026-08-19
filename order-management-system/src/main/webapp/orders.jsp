<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List,com.oms.model.Order" %>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Order> orders = (List<Order>) request.getAttribute("orders");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Orders</title>
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
        <h1>Orders</h1>
        <a class="button" href="orders?view=create">Create Order</a>
    </div>

    <% if (request.getParameter("error") != null) { %>
        <div class="error">
            <%= request.getParameter("error") %>
        </div>
    <% } %>

    <table>

        <tr>
            <th>ID</th>
            <th>Customer</th>
            <th>Status</th>
            <th>Total</th>
            <th>Date</th>
            <th>Update</th>
        </tr>

        <% if (orders != null && !orders.isEmpty()) { %>

            <% for (Order o : orders) { %>

                <tr>

                    <td>
                        <a href="orders?id=<%= o.getId() %>">
                            #<%= o.getId() %>
                        </a>
                    </td>

                    <td>
                        <%= o.getCustomerName() %>
                    </td>

                    <td>
                        <span class="badge">
                            <%= o.getStatus() %>
                        </span>
                    </td>

                    <td>
                        ₹<%= o.getTotalAmount() %>
                    </td>

                    <td>
                        <%= o.getOrderDate() %>
                    </td>

                    <td>

                        <form method="post"
                              action="orders"
                              class="row compact">

                            <input type="hidden"
                                   name="action"
                                   value="status">

                            <input type="hidden"
                                   name="id"
                                   value="<%= o.getId() %>">

                            <select name="status">

                                <option value="PENDING"
                                    <%= "PENDING".equals(o.getStatus()) ? "selected" : "" %>>
                                    PENDING
                                </option>

                                <option value="SHIPPED"
                                    <%= "SHIPPED".equals(o.getStatus()) ? "selected" : "" %>>
                                    SHIPPED
                                </option>

                                <option value="DELIVERED"
                                    <%= "DELIVERED".equals(o.getStatus()) ? "selected" : "" %>>
                                    DELIVERED
                                </option>

                                <option value="CANCELLED"
                                    <%= "CANCELLED".equals(o.getStatus()) ? "selected" : "" %>>
                                    CANCELLED
                                </option>

                            </select>

                            <button type="submit">
                                Save
                            </button>

                        </form>

                    </td>

                </tr>

            <% } %>

        <% } else { %>

            <tr>
                <td colspan="6">
                    No orders found.
                </td>
            </tr>

        <% } %>

    </table>

</div>

</body>
</html>