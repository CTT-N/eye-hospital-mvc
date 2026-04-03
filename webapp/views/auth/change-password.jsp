<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <title>Đổi mật khẩu – BV Mắt PTIT</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light d-flex align-items-center justify-content-center" style="min-height:100vh">
  <div class="card shadow" style="width:420px;padding:32px">
    <h4 class="mb-4">Đổi mật khẩu</h4>
    <c:if test="${not empty error}">
      <div class="alert alert-danger"><c:out value="${error}"/></div>
    </c:if>
    <c:if test="${not empty success}">
      <div class="alert alert-success"><c:out value="${success}"/></div>
    </c:if>
    <form action="${pageContext.request.contextPath}/auth/change-password" method="post">
      <div class="mb-3">
        <label class="form-label">Mật khẩu hiện tại</label>
        <input type="password" name="currentPassword" class="form-control" required>
      </div>
      <div class="mb-3">
        <label class="form-label">Mật khẩu mới</label>
        <input type="password" name="newPassword" class="form-control" required minlength="6">
      </div>
      <div class="mb-3">
        <label class="form-label">Xác nhận mật khẩu mới</label>
        <input type="password" name="confirmPassword" class="form-control" required minlength="6">
      </div>
      <button type="submit" class="btn btn-primary w-100">Đổi mật khẩu</button>
    </form>
    <div class="mt-3 text-center">
      <a href="${pageContext.request.contextPath}/" style="font-size:13px">← Quay lại</a>
    </div>
  </div>
</body>
</html>
