<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.User" %>

<%
User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html>
<head>
<title>Manager Dashboard</title>

<style>

body{margin:0;font-family:Arial;}

.header{
background:#8e44ad;
color:white;
padding:15px;
display:flex;
justify-content:space-between;
}

.container{display:flex;}

.sidebar{
width:220px;
background:#9b59b6;
height:100vh;
}

.sidebar a{
display:block;
padding:12px;
color:white;
text-decoration:none;
}

.sidebar a:hover{
background:#7d3c98;
}

.content{
flex:1;
padding:20px;
}

</style>

</head>

<body>

<div class="header">

<div>Manager Dashboard</div>

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

<a href="#">Manage Departments</a>

<a href="#">Manage Doctors</a>

<a href="#">Statistics</a>

</div>

<div class="content">

<h2>Manager Panel</h2>

<p>Manage hospital departments and doctors.</p>

</div>

</div>

</body>
</html>