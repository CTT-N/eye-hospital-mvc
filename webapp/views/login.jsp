<%@ page contentType="text/html;charset=UTF-8" %>

<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
</head>
<body>
<h2>Login</h2>

<form action="${pageContext.request.contextPath}/login" method="post">
    Tên đăng nhập: <input type="text" name="username"/><br>
    Mật khẩu: <input type="password" name="password"/><br>
    <button type="submit">Login</button>
</form>

</body>
</html>