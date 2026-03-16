<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>

<h2>Login</h2>

<form action="${pageContext.request.contextPath}/auth/change-password" method="post">

    <label>New Password</label>
    <input type="password" name="newPassword" required>

    <button type="submit">Update Password</button>

</form>

<p style="color:red">
    ${error}
</p>

</body>
</html>