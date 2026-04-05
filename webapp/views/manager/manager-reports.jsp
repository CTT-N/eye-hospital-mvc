<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Báo cáo thống kê – BV Mắt PTIT</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
</head>
<body>
<div class="app-shell">

  <aside class="sidebar">
    <a href="${pageContext.request.contextPath}/manager/dashboard" class="sidebar-brand">
      <div class="brand-logo"><svg viewBox="0 0 24 24" style="width:18px;height:18px;fill:#fff" xmlns="http://www.w3.org/2000/svg"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zm0 12.5a5 5 0 1 1 0-10 5 5 0 0 1 0 10zm0-8a3 3 0 1 0 0 6 3 3 0 0 0 0-6z"/></svg></div>
      <div class="brand-text">BV Mắt PTIT<small>Cổng Quản Lý</small></div>
    </a>
    <nav class="sidebar-nav">
      <div class="nav-item"><a href="${pageContext.request.contextPath}/manager/dashboard" class="nav-link-h"><span class="nav-icon"><i class="fas fa-chart-line"></i></span><span class="nav-label">Tổng quan</span></a></div>
      <div class="nav-section-label">Quản lý</div>
      <div class="nav-item"><a href="${pageContext.request.contextPath}/manager/schedule" class="nav-link-h"><span class="nav-icon"><i class="fas fa-calendar-days"></i></span><span class="nav-label">Lịch hẹn</span></a></div>
      <div class="nav-item"><a href="${pageContext.request.contextPath}/manager/departments" class="nav-link-h"><span class="nav-icon"><i class="fas fa-building-columns"></i></span><span class="nav-label">Khoa phòng</span></a></div>
      <div class="nav-item"><a href="${pageContext.request.contextPath}/manager/rooms" class="nav-link-h"><span class="nav-icon"><i class="fas fa-door-open"></i></span><span class="nav-label">Phòng khám</span></a></div>
      <div class="nav-item"><a href="${pageContext.request.contextPath}/manager/hospital" class="nav-link-h"><span class="nav-icon"><i class="fas fa-hospital"></i></span><span class="nav-label">Thông tin BV</span></a></div>
      <div class="nav-section-label">Báo cáo</div>
      <div class="nav-item"><a href="${pageContext.request.contextPath}/manager/report" class="nav-link-h active"><span class="nav-icon"><i class="fas fa-file-chart-column"></i></span><span class="nav-label">Báo cáo</span></a></div>
    </nav>
    <div class="sidebar-footer">
      <div class="sidebar-user">
        <div class="avatar avatar-md">${fn:substring(sessionScope.user.fullName, 0, 2)}</div>
        <div class="user-info">
          <div class="user-name">${sessionScope.user.fullName}</div>
          <div class="user-role">Quản lý bệnh viện</div>
        </div>
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
        <div>
          <div class="topbar-title">Báo cáo thống kê</div>
          <div style="font-size:12px;color:var(--text-muted)">Dữ liệu từ cơ sở dữ liệu bệnh viện</div>
        </div>
      </div>
    </header>

    <div class="page-content">
      <div class="row g-4">
        <!-- Appointments by Status -->
        <div class="col-lg-4">
          <div class="card-hospital">
            <div class="card-header-h"><h5>Lịch hẹn theo trạng thái</h5></div>
            <div class="card-body-h" style="padding:0">
              <table class="table-hospital">
                <thead><tr><th>Trạng thái</th><th style="text-align:right">Số lượng</th></tr></thead>
                <tbody>
                  <c:forEach var="entry" items="${statusCounts}">
                  <tr>
                    <td style="font-size:13px;font-weight:500">${entry.key}</td>
                    <td style="font-size:13px;text-align:right">${entry.value}</td>
                  </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- Appointments by Doctor -->
        <div class="col-lg-4">
          <div class="card-hospital">
            <div class="card-header-h"><h5>Lịch hẹn theo bác sĩ</h5></div>
            <div class="card-body-h" style="padding:0">
              <table class="table-hospital">
                <thead><tr><th>Bác sĩ</th><th style="text-align:right">Số lịch hẹn</th></tr></thead>
                <tbody>
                  <c:forEach var="entry" items="${doctorCounts}">
                  <tr>
                    <td style="font-size:13px;font-weight:500">${entry.key}</td>
                    <td style="font-size:13px;text-align:right">${entry.value}</td>
                  </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- Monthly Appointments -->
        <div class="col-lg-4">
          <div class="card-hospital">
            <div class="card-header-h"><h5>Lịch hẹn theo tháng</h5></div>
            <div class="card-body-h" style="padding:0">
              <table class="table-hospital">
                <thead><tr><th>Tháng</th><th style="text-align:right">Số lượng</th></tr></thead>
                <tbody>
                  <c:forEach var="entry" items="${monthlyCounts}">
                  <tr>
                    <td style="font-size:13px;font-weight:500">${entry.key}</td>
                    <td style="font-size:13px;text-align:right">${entry.value}</td>
                  </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>
<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
</body>
</html>
