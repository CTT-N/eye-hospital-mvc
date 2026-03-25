<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Đăng ký tài khoản bệnh nhân</title>
</head>
<body>

<h2>Patient Register</h2>

<form action="${pageContext.request.contextPath}/auth/register" method="post">

    <label>Username:</label><br>
    <input type="text" name="username" required><br><br>

    <label>Password:</label><br>
    <input type="password" name="password" required><br><br>

    <label>Full Name:</label><br>
    <input type="text" name="fullName" required><br><br>

    <label>Email:</label><br>
    <input type="email" name="email" required><br><br>

    <button type="submit">Register</button>
</form>

<p style="color:red">${error}</p>

<a href="${pageContext.request.contextPath}/auth/login">Back to Login</a>

</body>
</html>