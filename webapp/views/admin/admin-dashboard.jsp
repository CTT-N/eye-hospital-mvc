<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.User" %>

<%
User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html>
<head>
<title>Admin Dashboard</title>

<style>

body{
    margin:0;
    font-family:Arial;
}

.header{
    background:#2c3e50;
    color:white;
    padding:15px;
    display:flex;
    justify-content:space-between;
}

.container{
    display:flex;
}

.sidebar{
    width:220px;
    background:#34495e;
    height:100vh;
}

.sidebar a{
    display:block;
    padding:12px;
    color:white;
    text-decoration:none;
}

.sidebar a:hover{
    background:#1abc9c;
}

.content{
    flex:1;
    padding:20px;
}

</style>

</head>

<body>

<div class="header">
    <div>Admin Dashboard</div>

    <div>
        Welcome <%=user.getUsername()%> |
        <a style="color:white"
           href="${pageContext.request.contextPath}/auth/logout">
           Logout
        </a>
    </div>
</div>

<div class="container">

<div class="sidebar">

<a href="#">Manage Users</a>

<a href="#">View Reports</a>

<a href="#">System Settings</a>

</div>

<div class="content">

<h2>Admin Panel</h2>

<p>Welcome to the admin dashboard.</p>

</div>

</div>

</body>
</html>