<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.oms.model.Product" %>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    List<Product> products =
            (List<Product>) request.getAttribute("products");

    if (products == null) {
        products = java.util.Collections.emptyList();
    }
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Products</title>

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

    <h1>Products</h1>


    <% if (request.getParameter("error") != null) { %>

        <div class="error">

            <%= request.getParameter("error") %>

        </div>

    <% } %>


    <!-- ADD PRODUCT -->

    <div class="card">

        <h2>Add Product</h2>

        <form
            method="post"
            action="products"
            class="row"
        >

            <input
                name="name"
                placeholder="Product name"
                required
            >

            <input
                name="price"
                type="number"
                step="0.01"
                min="0"
                placeholder="Price"
                required
            >

            <input
                name="stock"
                type="number"
                min="0"
                placeholder="Stock"
                required
            >

            <button type="submit">
                Add
            </button>

        </form>

    </div>


    <br>


    <!-- PRODUCT TABLE -->

    <table>

        <tr>

            <th>ID</th>

            <th>Name</th>

            <th>Price</th>

            <th>Stock</th>

            <th>Status</th>

            <th>Action</th>

        </tr>


        <% if (products.isEmpty()) { %>

            <tr>

                <td colspan="6">

                    No products found.

                </td>

            </tr>

        <% } else { %>


            <% for (Product p : products) { %>

                <tr>

                    <td>
                        <%= p.getId() %>
                    </td>


                    <td>
                        <%= p.getName() %>
                    </td>


                    <td>
                        ₹<%= p.getPrice() %>
                    </td>


                    <td>
                        <%= p.getStock() %>
                    </td>


                    <td>

                        <% if (p.isActive()) { %>

                            ACTIVE

                        <% } else { %>

                            INACTIVE

                        <% } %>

                    </td>


                    <td>

                        <% if (p.isActive()) { %>

                            <form
                                method="post"
                                action="products"
                                onsubmit="return confirm('Deactivate product?')"
                            >

                                <input
                                    type="hidden"
                                    name="action"
                                    value="delete"
                                >

                                <input
                                    type="hidden"
                                    name="id"
                                    value="<%= p.getId() %>"
                                >

                                <button
                                    type="submit"
                                    class="danger"
                                >
                                    Deactivate
                                </button>

                            </form>

                        <% } else { %>

                            <span>
                                Inactive
                            </span>

                        <% } %>

                    </td>

                </tr>

            <% } %>

        <% } %>

    </table>

</div>

</body>

</html>