<%@ page contentType="text/html;charset=UTF-8" %>
<%
    if (session.getAttribute("username") != null) {
        response.sendRedirect("dashboard");
    } else {
        response.sendRedirect("login.jsp");
    }
%>
