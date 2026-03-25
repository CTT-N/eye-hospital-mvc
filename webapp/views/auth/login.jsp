<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>

<h2>Login</h2>

<form action="${pageContext.request.contextPath}/auth/login" method="post">

    <label>Username:</label><br>
    <input type="text" name="username" required>
    <br><br>

    <label>Password:</label><br>
    <input type="password" name="password" required>
    <br><br>

    <button type="submit">Login</button>
    <a href="${pageContext.request.contextPath}/auth/register">Register</a>
</form>

<p style="color:red">
    ${error}
</p>

</body>
</html>