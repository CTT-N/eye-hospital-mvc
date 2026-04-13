<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Thông tin bệnh viện – BV Mắt PTIT</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
</head>
<body>
<div class="app-shell">

  <aside class="sidebar">
    <a href="" class="sidebar-brand">
      <div class="brand-logo"><svg viewBox="0 0 24 24" style="width:18px;height:18px;fill:#fff" xmlns="http://www.w3.org/2000/svg"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zm0 12.5a5 5 0 1 1 0-10 5 5 0 0 1 0 10zm0-8a3 3 0 1 0 0 6 3 3 0 0 0 0-6z"/></svg></div>
      <div class="brand-text">
        BV Mắt PTIT
        <small>Cổng Quản Lý</small>
      </div>
    </a>

    <nav class="sidebar-nav">
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/manager/dashboard" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-chart-line"></i></span>
          <span class="nav-label">Tổng quan</span>
        </a>
      </div>
      <div class="nav-section-label">Quản lý</div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/manager/schedule" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-calendar-days"></i></span>
          <span class="nav-label">Lịch hẹn</span>
          <span class="nav-badge">${totalAppointments}</span>
        </a>
      </div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/manager/departments" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-building-columns"></i></span>
          <span class="nav-label">Khoa phòng</span>
        </a>
      </div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/manager/rooms" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-door-open"></i></span>
          <span class="nav-label">Phòng khám</span>
        </a>
      </div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/manager/hospital" class="nav-link-h active">
          <span class="nav-icon"><i class="fas fa-hospital"></i></span>
          <span class="nav-label">Thông tin BV</span>
        </a>
      </div>
      <div class="nav-section-label">Báo cáo</div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/manager/report" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-file-chart-column"></i></span>
          <span class="nav-label">Báo cáo doanh thu</span>
        </a>
      </div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/manager/report" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-users"></i></span>
          <span class="nav-label">Báo cáo bệnh nhân</span>
        </a>
      </div>
    </nav>

    <div class="sidebar-footer">
      <div class="sidebar-user">
        <div class="avatar avatar-md"><c:choose><c:when test="${fn:length(sessionScope.user.fullName) >= 2}">${fn:substring(sessionScope.user.fullName, 0, 2)}</c:when><c:when test="${fn:length(sessionScope.user.fullName) == 1}">${fn:substring(sessionScope.user.fullName, 0, 1)}</c:when><c:otherwise>?</c:otherwise></c:choose></div>
        <div class="user-info">
          <div class="user-name">${sessionScope.user.fullName}</div>
          <div class="user-role">Quản lý bệnh viện</div>
        </div>
        <i class="fas fa-ellipsis-v" style="color:rgba(255,255,255,0.4);font-size:13px"></i>
      </div>
      <a href="${pageContext.request.contextPath}/auth/logout" class="nav-link-h" style="margin-top:8px;padding:8px 12px;color:rgba(255,255,255,0.6);font-size:13px">
        <span class="nav-icon"><i class="fas fa-right-from-bracket"></i></span>
        <span class="nav-label">Đăng xuất</span>
      </a>
    </div>
  </aside>

  <main class="main-content">
    <header class="topbar">
      <div class="topbar-left">
        <button class="topbar-icon-btn" id="sidebarToggle"><i class="fas fa-bars"></i></button>
        <div><div class="topbar-title">Thông tin bệnh viện</div><div style="font-size:12px;color:var(--text-muted)">Cập nhật thông tin giới thiệu</div></div>
      </div>
      <div class="topbar-right">
        <button class="btn-hospital btn-outline-h btn-sm" id="editToggle" onclick="toggleEdit()"><i class="fas fa-pen"></i> Chỉnh sửa</button>
        <button class="topbar-icon-btn">
          <i class="fas fa-bell"></i>
          <span class="notif-dot"></span>
        </button>
        <button class="topbar-user">
          <div class="avatar avatar-sm">QT</div>
          <div class="user-details d-none d-md-block">
            <span class="user-name">${sessionScope.user.fullName}</span>
            <span class="user-role">Manager</span>
          </div>
          <i class="fas fa-chevron-down" style="font-size:11px;color:var(--text-muted)"></i>
        </button>
      </div>
    </header>

    <div class="content-area">
      <div class="card-hospital" style="max-width:800px">
        <div class="card-header-h">
          <h5><i class="fas fa-building" style="color:var(--primary);margin-right:8px"></i>Thông tin bệnh viện</h5>
        </div>
        <form action="${pageContext.request.contextPath}/manager/hospital" method="post">
          <input type="hidden" name="hospitalId" value="${hospital.hospitalId}">
          <div class="card-body-h">
            <div class="row g-3">
              <div class="col-12">
                <label class="form-label-h">Tên bệnh viện <span class="required">*</span></label>
                <input class="form-control-h" id="hospName" name="hospitalName" value="${hospital.hospitalName}" disabled>
              </div>
              <div class="col-12">
                <label class="form-label-h">Địa chỉ <span class="required">*</span></label>
                <input class="form-control-h" id="hospAddress" name="address" value="${hospital.address}" disabled>
              </div>
              <div class="col-12">
                <label class="form-label-h">Giới thiệu bệnh viện</label>
                <textarea class="form-control-h" id="hospDesc" name="description" rows="5" disabled>${hospital.description}</textarea>
              </div>
            </div>
          </div>
          <div class="card-footer-h" id="saveFooter" style="display:none">
            <button type="button" class="btn-hospital btn-ghost-h btn-sm" onclick="cancelEdit()">Hủy</button>
            <button type="submit" class="btn-hospital btn-primary-h btn-sm"><i class="fas fa-check"></i> Lưu thay đổi</button>
          </div>
        </form>
      </div>
    </div>
  </main>
</div>

<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/static/js/manager-hospital-info.js"></script>
</body>
</html>
