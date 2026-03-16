<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="model.User" %>

<%
User user = (User) session.getAttribute("user");
%>

<!DOCTYPE html>
<html>
<head>
<title>Patient Dashboard</title>

<style>

body{margin:0;font-family:Arial;}

.header{
background:#2980b9;
color:white;
padding:15px;
display:flex;
justify-content:space-between;
}

.container{display:flex;}

.sidebar{
width:220px;
background:#3498db;
height:100vh;
}

.sidebar a{
display:block;
padding:12px;
color:white;
text-decoration:none;
}

.sidebar a:hover{
background:#21618c;
}

.content{
flex:1;
padding:20px;
}

</style>

</head>

<body>

<div class="header">

<div>Patient Dashboard</div>

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

<a href="#">Book Appointment</a>

<a href="#">My Appointments</a>

<a href="#">Medical History</a>

</div>

<div class="content">

<h2>Patient Area</h2>

<p>Book appointments and view your medical records.</p>

</div>

</div>

</body>
</html>