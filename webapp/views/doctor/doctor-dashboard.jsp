<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.User" %>

<%
User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html>
<head>
<title>Doctor Dashboard</title>

<style>

body{margin:0;font-family:Arial;}

.header{
background:#16a085;
color:white;
padding:15px;
display:flex;
justify-content:space-between;
}

.container{display:flex;}

.sidebar{
width:220px;
background:#1abc9c;
height:100vh;
}

.sidebar a{
display:block;
padding:12px;
color:white;
text-decoration:none;
}

.sidebar a:hover{
background:#149174;
}

.content{
flex:1;
padding:20px;
}

</style>

</head>

<body>

<div class="header">

<div>Doctor Dashboard</div>

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

<a href="#">My Schedule</a>

<a href="#">Patient Appointments</a>

<a href="#">Medical Records</a>

</div>

<div class="content">

<h2>Doctor Workspace</h2>

<p>Manage appointments and patient records.</p>

</div>

</div>

</body>
</html>