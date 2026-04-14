<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đăng Ký Tài Khoản – BV Mắt PTIT</title>

  <!-- Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome 6 -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <!-- Google Fonts -->
  

  <!-- Custom CSS -->
  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/auth.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/register.css" rel="stylesheet">
</head>
<body>

<div class="login-page">
  <!-- Left: Hero Panel -->
  <div class="login-hero">
    <img class="hero-bg" src="${pageContext.request.contextPath}/static/images/clinic-interior.jpg" alt="BV Mắt">
    <div class="hero-content">
      <div class="eyebrow-h">Cổng bệnh nhân</div>
      <h1 class="hero-title">Bệnh Viện Mắt<br>PTIT</h1>
      <p class="hero-subtitle">Hệ thống quản lý y tế thông minh<br>Chăm sóc sức khỏe thị giác cộng đồng</p>
      <div class="hero-features">
        <div class="feature-item">
          <div class="fi-icon"><i class="fas fa-calendar-check"></i></div>
          <span>Đặt lịch khám trực tuyến 24/7</span>
        </div>
        <div class="feature-item">
          <div class="fi-icon"><i class="fas fa-file-medical"></i></div>
          <span>Quản lý hồ sơ bệnh án điện tử</span>
        </div>
        <div class="feature-item">
          <div class="fi-icon"><i class="fas fa-user-doctor"></i></div>
          <span>Đội ngũ bác sĩ chuyên khoa mắt</span>
        </div>
        <div class="feature-item">
          <div class="fi-icon"><i class="fas fa-shield-halved"></i></div>
          <span>Bảo mật thông tin bệnh nhân</span>
        </div>
      </div>
    </div>
  </div>

  <!-- Right: Form Panel -->
  <div class="login-form-panel">
    <div class="login-form-wrap">

      <div class="login-logo">
        <div class="logo-mark">
          <svg viewBox="0 0 24 24" style="width:22px;height:22px;fill:#fff" xmlns="http://www.w3.org/2000/svg">
            <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zm0 12.5a5 5 0 1 1 0-10 5 5 0 0 1 0 10zm0-8a3 3 0 1 0 0 6 3 3 0 0 0 0-6z" />
          </svg>
        </div>
        <div class="logo-name">
          BV Mắt
          <small>Hệ thống Quản lý Bệnh viện</small>
        </div>
      </div>

      <div class="login-heading">
        <h2>Tạo tài khoản</h2>
        <p>Nhập thông tin của bạn để đăng ký</p>
      </div>

      <form action="${pageContext.request.contextPath}/auth/register" method="post" id="regForm" onsubmit="handleReg(event)" novalidate>

        <input type="hidden" name="fullName" id="hiddenFullName">

        <div class="form-group-h">
          <label class="form-label-h" for="username">
            <i class="fas fa-user" style="margin-right:6px;color:var(--text-muted);font-size:12px"></i>
            Tên đăng nhập *
          </label>
          <input type="text" class="form-control-h" id="username" name="username" placeholder="Nhập tên đăng nhập..." required>
          <div class="error" id="errUsername">Vui lòng nhập tên đăng nhập</div>
        </div>

        <div class="form-row2">
          <div class="form-group-h">
            <label class="form-label-h" for="lastName">Họ *</label>
            <input type="text" class="form-control-h" id="lastName" placeholder="Nhập họ..." required>
            <div class="error" id="errLast">Vui lòng nhập họ</div>
          </div>
          <div class="form-group-h">
            <label class="form-label-h" for="firstName">Tên *</label>
            <input type="text" class="form-control-h" id="firstName" placeholder="Nhập tên..." required>
            <div class="error" id="errFirst">Vui lòng nhập tên</div>
          </div>
        </div>

        <div class="form-group-h">
          <label class="form-label-h" for="email">
            <i class="fas fa-envelope" style="margin-right:6px;color:var(--text-muted);font-size:12px"></i>
            Email *
          </label>
          <input type="email" class="form-control-h" id="email" name="email" placeholder="email@example.com" required>
          <div class="error" id="errEmail">Email không hợp lệ</div>
        </div>

        <div class="form-group-h" style="margin-bottom: 24px;">
          <label class="form-label-h" for="password">
            <i class="fas fa-lock" style="margin-right:6px;color:var(--text-muted);font-size:12px"></i>
            Mật khẩu *
          </label>
          <div class="password-group">
            <input type="password" class="form-control-h" id="password" name="password" placeholder="Ít nhất 8 ký tự" oninput="checkStrength()" required>
            <button type="button" class="password-toggle" onclick="togglePw('password', this)">
              <i class="fas fa-eye-slash"></i>
            </button>
          </div>
          <div class="pw-strength"><div class="bar" id="pwBar"></div></div>
          <div class="pw-label" id="pwLabel">Nhập mật khẩu để kiểm tra</div>
          <div class="error" id="errPw" style="margin-top:2px;">Mật khẩu cần ít nhất 8 ký tự</div>
        </div>

        <div class="form-group-h" style="margin-bottom: 24px;">
          <label class="form-label-h" for="confirmPw">
            <i class="fas fa-check-circle" style="margin-right:6px;color:var(--text-muted);font-size:12px"></i>
            Xác nhận mật khẩu *
          </label>
          <div class="password-group">
            <input type="password" class="form-control-h" id="confirmPw" placeholder="Nhập lại mật khẩu" required>
            <button type="button" class="password-toggle" onclick="togglePw('confirmPw', this)">
              <i class="fas fa-eye-slash"></i>
            </button>
          </div>
          <div class="error" id="errConfirm" style="margin-top:2px;">Mật khẩu không khớp</div>
        </div>

        <label class="agreecheck">
          <input type="checkbox" id="agree">
          <span>Tôi đồng ý với <a href="#">Điều khoản sử dụng</a> và <a href="#">Chính sách bảo mật</a> của bệnh viện</span>
        </label>

        <c:if test="${not empty error}">
          <div class="alert alert-danger"><c:out value="${error}"/></div>
        </c:if>
        <c:if test="${not empty success}">
          <div class="alert alert-success"><c:out value="${success}"/></div>
        </c:if>

        <button type="submit" class="login-submit" id="regBtn">
          Tạo tài khoản <i class="fas fa-arrow-right" style="font-size:13px;margin-left:4px"></i>
        </button>
      </form>

      <div class="login-divider">Hoặc làm tiếp với</div>

      <div class="login-footer-text" style="margin-top: 0;">
        Đã có tài khoản? <a href="${pageContext.request.contextPath}/auth/login">Đăng nhập ngay</a>
      </div>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/register.js"></script>
</body>
</html>
