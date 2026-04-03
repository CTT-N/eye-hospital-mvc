<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đăng Nhập – Bệnh Viện Mắt Đại Học Y</title>
  <meta name="description" content="Đăng nhập vào hệ thống quản lý Bệnh Viện Mắt">

  <!-- Bootstrap 5 -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome 6 -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <!-- Google Fonts -->
  <link
    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700&display=swap"
    rel="stylesheet">
  <!-- Custom CSS -->
  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/auth.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/login.css" rel="stylesheet">
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
              <path
                d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zm0 12.5a5 5 0 1 1 0-10 5 5 0 0 1 0 10zm0-8a3 3 0 1 0 0 6 3 3 0 0 0 0-6z" />
            </svg>
          </div>
          <div class="logo-name">
            BV Mắt
            <small>Hệ thống quản lý y tế</small>
          </div>
        </div>

        <!-- Heading -->
        <div class="login-heading">
          <h2>Đăng nhập vào hệ thống</h2>
          <p>Chọn vai trò và nhập thông tin đăng nhập của bạn</p>
        </div>

        <!-- Role Tabs -->
        <div class="role-tabs" id="roleTabs">
          <button class="role-tab active" data-role="patient" onclick="selectRole(this, 'patient')">
            <i class="fas fa-user"></i>Bệnh nhân
          </button>
          <button class="role-tab" data-role="doctor" onclick="selectRole(this, 'doctor')">
            <i class="fas fa-user-doctor"></i>Bác sĩ
          </button>
          <button class="role-tab" data-role="admin" onclick="selectRole(this, 'admin')">
            <i class="fas fa-shield-halved"></i>Admin
          </button>
          <button class="role-tab" data-role="manager" onclick="selectRole(this, 'manager')">
            <i class="fas fa-chart-line"></i>Manager
          </button>
        </div>

        <!-- Login Form -->
        <form action="${pageContext.request.contextPath}/auth/login" method="post" id="loginForm">
          <input type="hidden" name="role" id="roleInput" value="patient">

          <div class="form-group-h">
            <label class="form-label-h" for="username">
              <i class="fas fa-user" style="margin-right:6px;color:var(--text-muted);font-size:12px"></i>
              Tên đăng nhập / Email
            </label>
            <input type="text" id="username" name="username" class="form-control-h"
              placeholder="Nhập tên đăng nhập hoặc email" required autocomplete="username">
          </div>

          <div class="form-group-h">
            <label class="form-label-h" for="password">
              <i class="fas fa-lock" style="margin-right:6px;color:var(--text-muted);font-size:12px"></i>
              Mật khẩu
            </label>
            <div class="password-group">
              <input type="password" id="password" name="password" class="form-control-h" placeholder="Nhập mật khẩu"
                required autocomplete="current-password" style="padding-right: 44px">
              <button type="button" class="password-toggle" onclick="togglePassword()" id="eyeBtn">
                <i class="fas fa-eye" id="eyeIcon"></i>
              </button>
            </div>
          </div>

          <div class="d-flex justify-content-between align-items-center mb-4">
            <label class="d-flex align-items-center gap-2"
              style="cursor:pointer;font-size:13px;color:var(--text-secondary)">
              <input type="checkbox" name="rememberMe"
                style="accent-color:var(--primary-light);width:15px;height:15px;">
              Ghi nhớ đăng nhập
            </label>
            <a href="${pageContext.request.contextPath}/auth/login" style="font-size:13px; color:var(--primary-light); font-weight:500">
              Quên mật khẩu?
            </a>
          </div>

          <c:if test="${not empty error}">
            <div class="alert alert-danger" style="margin-bottom:12px">${error}</div>
          </c:if>

          <button type="submit" class="login-submit" id="submitBtn">
            <i class="fas fa-right-to-bracket"></i>
            Đăng nhập
          </button>
        </form>

        <div class="login-divider">hoặc</div>

        <div class="login-footer-text">
          Chưa có tài khoản?
          <a href="${pageContext.request.contextPath}/auth/register">Đăng ký bệnh nhân ngay</a>
        </div>


      </div>
    </div>

  </div>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
  <script src="${pageContext.request.contextPath}/static/js/login.js"></script>
</body>

</html>
