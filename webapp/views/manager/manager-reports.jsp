<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Báo cáo thống kê – BV Mắt PTIT</title>
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
          <span class="nav-badge">12</span>
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
        <a href="${pageContext.request.contextPath}/manager/hospital" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-hospital"></i></span>
          <span class="nav-label">Thông tin BV</span>
        </a>
      </div>
      <div class="nav-section-label">Báo cáo</div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/manager/report" class="nav-link-h active">
          <span class="nav-icon"><i class="fas fa-file-chart-column"></i></span>
          <span class="nav-label">Báo cáo doanh thu</span>
        </a>
      </div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/manager/report" class="nav-link-h active">
          <span class="nav-icon"><i class="fas fa-users"></i></span>
          <span class="nav-label">Báo cáo bệnh nhân</span>
        </a>
      </div>
    </nav>

    <div class="sidebar-footer">
      <div class="sidebar-user">
        <div class="avatar avatar-md">QT</div>
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
        <div><div class="topbar-title">Báo cáo thống kê</div><div style="font-size:12px;color:var(--text-muted)">Tháng 3/2025</div></div>
      </div>
      <div class="topbar-right">
        <select class="filter-select" id="periodFilter" onchange="updateCharts()">
          <option value="week">Tuần này</option>
          <option value="month" selected>Tháng này</option>
          <option value="year">Năm nay</option>
        </select>
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
      <!-- Summary stats -->
      <div class="row g-3 mb-4">
        <div class="col-6 col-lg-3">
          <div class="stat-card">
            <div class="stat-icon stat-blue"><i class="fas fa-users"></i></div>
            <div class="stat-info"><div class="label">Bệnh nhân mới</div><div class="value">142</div><div class="trend" style="color:var(--success)">↑ 12% so tháng trước</div></div>
          </div>
        </div>
        <div class="col-6 col-lg-3">
          <div class="stat-card">
            <div class="stat-icon stat-green"><i class="fas fa-calendar-check"></i></div>
            <div class="stat-info"><div class="label">Lượt khám</div><div class="value">318</div><div class="trend" style="color:var(--success)">↑ 8%</div></div>
          </div>
        </div>
        <div class="col-6 col-lg-3">
          <div class="stat-card">
            <div class="stat-icon stat-orange"><i class="fas fa-money-bill-wave"></i></div>
            <div class="stat-info"><div class="label">Doanh thu</div><div class="value">128M</div><div class="trend" style="color:var(--success)">↑ 15%</div></div>
          </div>
        </div>
        <div class="col-6 col-lg-3">
          <div class="stat-card">
            <div class="stat-icon stat-teal"><i class="fas fa-star"></i></div>
            <div class="stat-info"><div class="label">Đánh giá TB</div><div class="value">4.8</div><div class="trend" style="color:var(--text-muted)">/ 5.0 sao</div></div>
          </div>
        </div>
      </div>

      <!-- Tabs -->
      <div class="tab-nav-h">
        <button class="tab-btn active" onclick="switchTab(this,'tabPatient')"><i class="fas fa-users" style="margin-right:6px"></i>Bệnh nhân</button>
        <button class="tab-btn" onclick="switchTab(this,'tabRevenue')"><i class="fas fa-chart-line" style="margin-right:6px"></i>Doanh thu</button>
        <button class="tab-btn" onclick="switchTab(this,'tabDoctor')"><i class="fas fa-user-doctor" style="margin-right:6px"></i>Theo bác sĩ</button>
      </div>

      <!-- Tab: Patients -->
      <div class="tab-pane-h active" id="tabPatient">
        <div class="card-hospital">
          <div class="card-header-h"><h5>Lượt khám theo ngày</h5></div>
          <div class="card-body-h">
            <canvas id="chartPatient" height="100"></canvas>
          </div>
        </div>
      </div>

      <!-- Tab: Revenue -->
      <div class="tab-pane-h" id="tabRevenue">
        <div class="card-hospital">
          <div class="card-header-h"><h5>Doanh thu theo ngày (triệu VNĐ)</h5></div>
          <div class="card-body-h">
            <canvas id="chartRevenue" height="100"></canvas>
          </div>
        </div>
      </div>

      <!-- Tab: By Doctor -->
      <div class="tab-pane-h" id="tabDoctor">
        <div class="row g-4">
          <div class="col-lg-6">
            <div class="card-hospital">
              <div class="card-header-h"><h5>Ca khám theo bác sĩ</h5></div>
              <div class="card-body-h">
                <canvas id="chartDoctor" height="180"></canvas>
              </div>
            </div>
          </div>
          <div class="col-lg-6">
            <div class="card-hospital">
              <div class="card-header-h"><h5>Phân bố theo chuyên khoa</h5></div>
              <div class="card-body-h">
                <canvas id="chartDept" height="180"></canvas>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/static/js/manager-reports.js"></script>
</body>
</html>
