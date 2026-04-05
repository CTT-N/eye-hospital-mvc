<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard Quản Lý – BV Mắt PTIT</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700;800&display=swap" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/manager-dashboard.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
</head>
<body>
<div class="app-shell">

  <!-- ==== SIDEBAR ==== -->
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
        <a href="${pageContext.request.contextPath}/manager/dashboard" class="nav-link-h active">
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
        <a href="${pageContext.request.contextPath}/manager/hospital" class="nav-link-h">
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

  <!-- ==== MAIN CONTENT ==== -->
  <main class="main-content">
    <!-- Top Bar -->
    <header class="topbar">
      <div class="topbar-left">
        <button class="topbar-icon-btn" id="sidebarToggle">
          <i class="fas fa-bars"></i>
        </button>
        <div>
          <div class="topbar-title">Bảng Điều Khiển</div>
          <div style="font-size:12px;color:var(--text-muted)">
            <i class="fas fa-clock" style="margin-right:4px"></i>
            <%= new java.text.SimpleDateFormat("EEEE, dd/MM/yyyy").format(new java.util.Date()) %>
          </div>
        </div>
      </div>
      <div class="topbar-right">
        <button class="topbar-icon-btn">
          <i class="fas fa-magnifying-glass"></i>
        </button>
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

    <!-- Page Content -->
    <div class="page-content">

      <!-- Page Header -->
      <div class="page-header-h">
        <div>
          <h1 class="page-title">Tổng Quan Hệ Thống</h1>
          <p class="page-subtitle">Báo cáo hoạt động bệnh viện</p>
        </div>
        <div class="d-flex gap-2">
          <select class="form-control-h" style="width:auto">
            <option>Tháng 3/2025</option>
            <option>Tháng 2/2025</option>
            <option>Tháng 1/2025</option>
          </select>
          <button class="btn-hospital btn-outline-h">
            <i class="fas fa-download"></i> Xuất báo cáo
          </button>
          <button class="btn-hospital btn-primary-h">
            <i class="fas fa-plus"></i> Thêm lịch hẹn
          </button>
        </div>
      </div>

      <!-- Stats Row -->
      <div class="row g-3 mb-4">
        <div class="col-xl-3 col-sm-6">
          <div class="stat-card stat-blue">
            <div class="stat-icon"><i class="fas fa-calendar-check"></i></div>
            <div class="stat-info">
              <div class="label">Tổng lịch hẹn</div>
              <div class="value">${totalAppointments}</div>
            </div>
          </div>
        </div>
        <div class="col-xl-3 col-sm-6">
          <div class="stat-card stat-green">
            <div class="stat-icon"><i class="fas fa-user-injured"></i></div>
            <div class="stat-info">
              <div class="label">Bệnh nhân</div>
              <div class="value">${patientCount}</div>
            </div>
          </div>
        </div>
        <div class="col-xl-3 col-sm-6">
          <div class="stat-card stat-orange">
            <div class="stat-icon"><i class="fas fa-user-doctor"></i></div>
            <div class="stat-info">
              <div class="label">Bác sĩ</div>
              <div class="value">${doctorCount}</div>
            </div>
          </div>
        </div>
        <div class="col-xl-3 col-sm-6">
          <div class="stat-card stat-teal">
            <div class="stat-icon"><i class="fas fa-clock"></i></div>
            <div class="stat-info">
              <div class="label">Chờ xác nhận</div>
              <div class="value">${pendingCount}</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Charts Row -->
      <div class="row g-3 mb-4">
        <!-- Revenue Chart -->
        <div class="col-lg-8">
          <div class="card-hospital">
            <div class="card-header-h">
              <div>
                <h5>Doanh Thu Theo Tháng</h5>
                <p style="font-size:12px;color:var(--text-muted);margin:0">6 tháng gần nhất</p>
              </div>
              <div class="d-flex gap-2">
                <button class="btn-hospital btn-ghost-h btn-sm active">Tháng</button>
                <button class="btn-hospital btn-ghost-h btn-sm">Quý</button>
                <button class="btn-hospital btn-ghost-h btn-sm">Năm</button>
              </div>
            </div>
            <div class="card-body-h">
              <div class="chart-container">
                <canvas id="revenueChart"></canvas>
              </div>
            </div>
          </div>
        </div>

        <!-- Appointment Pie -->
        <div class="col-lg-4">
          <div class="card-hospital h-100">
            <div class="card-header-h">
              <h5>Lịch Hẹn Theo Trạng Thái</h5>
            </div>
            <div class="card-body-h">
              <div class="chart-container" style="height:200px">
                <canvas id="statusChart"></canvas>
              </div>
              <div class="mt-3">
                <div class="d-flex justify-content-between align-items-center py-1">
                  <span style="font-size:13px;display:flex;align-items:center;gap:8px">
                    <span style="width:10px;height:10px;border-radius:2px;background:#16A34A;display:inline-block"></span>
                    Hoàn thành
                  </span>
                  <span style="font-size:13px;font-weight:600">${completedCount}</span>
                </div>
                <div class="d-flex justify-content-between align-items-center py-1">
                  <span style="font-size:13px;display:flex;align-items:center;gap:8px">
                    <span style="width:10px;height:10px;border-radius:2px;background:#2563A8;display:inline-block"></span>
                    Đã xác nhận
                  </span>
                  <span style="font-size:13px;font-weight:600">${confirmedCount}</span>
                </div>
                <div class="d-flex justify-content-between align-items-center py-1">
                  <span style="font-size:13px;display:flex;align-items:center;gap:8px">
                    <span style="width:10px;height:10px;border-radius:2px;background:#D97706;display:inline-block"></span>
                    Chờ xác nhận
                  </span>
                  <span style="font-size:13px;font-weight:600">${pendingCount}</span>
                </div>
                <div class="d-flex justify-content-between align-items-center py-1">
                  <span style="font-size:13px;display:flex;align-items:center;gap:8px">
                    <span style="width:10px;height:10px;border-radius:2px;background:#DC2626;display:inline-block"></span>
                    Đã hủy
                  </span>
                  <span style="font-size:13px;font-weight:600">${cancelledCount}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

      <!-- Bottom Row -->
      <div class="row g-3">
        <!-- Recent Appointments -->
        <div class="col-lg-7">
          <div class="card-hospital">
            <div class="card-header-h">
              <h5>Lịch Hẹn Gần Đây</h5>
              <a href="${pageContext.request.contextPath}/manager/schedule" class="btn-hospital btn-ghost-h btn-sm">
                Xem tất cả <i class="fas fa-arrow-right"></i>
              </a>
            </div>
            <div class="card-body-h" style="padding:0">
              <table class="table-hospital">
                <thead>
                  <tr>
                    <th>Mã lịch hẹn</th>
                    <th>Mã bệnh nhân</th>
                    <th>Mã bác sĩ</th>
                    <th>Ngày khám</th>
                    <th>Trạng thái</th>
                  </tr>
                </thead>
                <tbody>
                  <c:forEach var="a" items="${recentAppointments}">
                  <tr class="recent-row">
                    <td style="font-size:13px;font-weight:500">${a.appointmentId}</td>
                    <td style="font-size:13px">${a.patientId}</td>
                    <td style="font-size:13px">${a.doctorId}</td>
                    <td style="font-size:13px">${a.date} ${a.time}</td>
                    <td>
                      <c:choose>
                        <c:when test="${a.status eq 'COMPLETED'}"><span class="badge-h badge-success">Hoàn thành</span></c:when>
                        <c:when test="${a.status eq 'CONFIRMED'}"><span class="badge-h badge-info">Đã xác nhận</span></c:when>
                        <c:when test="${a.status eq 'PENDING'}"><span class="badge-h badge-gray">Chờ xác nhận</span></c:when>
                        <c:when test="${a.status eq 'CANCELLED'}"><span class="badge-h badge-danger">Đã hủy</span></c:when>
                        <c:otherwise><span class="badge-h badge-gray">${a.status}</span></c:otherwise>
                      </c:choose>
                    </td>
                  </tr>
                  </c:forEach>
                </tbody>
              </table>
            </div>
          </div>
        </div>

        <!-- Activity Feed & Quick Stats -->
        <div class="col-lg-5">
          <div class="row g-3">
            <div class="col-12">
              <div class="card-hospital">
                <div class="card-header-h">
                  <h5>Thống kê trạng thái</h5>
                </div>
                <div class="card-body-h">
                  <c:set var="total" value="${totalAppointments > 0 ? totalAppointments : 1}" />
                  <div class="mb-3">
                    <div class="d-flex justify-content-between mb-1" style="font-size:13px">
                      <span>Hoàn thành</span><span class="fw-semibold">${completedCount} (${totalAppointments > 0 ? (completedCount * 100 / total) : 0}%)</span>
                    </div>
                    <div style="height:6px;background:var(--bg-alt);border-radius:100px;overflow:hidden">
                      <div style="height:100%;width:${totalAppointments > 0 ? (completedCount * 100 / total) : 0}%;background:#16A34A;border-radius:100px"></div>
                    </div>
                  </div>
                  <div class="mb-3">
                    <div class="d-flex justify-content-between mb-1" style="font-size:13px">
                      <span>Đã xác nhận</span><span class="fw-semibold">${confirmedCount}</span>
                    </div>
                    <div style="height:6px;background:var(--bg-alt);border-radius:100px;overflow:hidden">
                      <div style="height:100%;width:${totalAppointments > 0 ? (confirmedCount * 100 / total) : 0}%;background:#2563A8;border-radius:100px"></div>
                    </div>
                  </div>
                  <div class="mb-3">
                    <div class="d-flex justify-content-between mb-1" style="font-size:13px">
                      <span>Chờ xác nhận</span><span class="fw-semibold">${pendingCount}</span>
                    </div>
                    <div style="height:6px;background:var(--bg-alt);border-radius:100px;overflow:hidden">
                      <div style="height:100%;width:${totalAppointments > 0 ? (pendingCount * 100 / total) : 0}%;background:#D97706;border-radius:100px"></div>
                    </div>
                  </div>
                  <div>
                    <div class="d-flex justify-content-between mb-1" style="font-size:13px">
                      <span>Đã hủy</span><span class="fw-semibold">${cancelledCount}</span>
                    </div>
                    <div style="height:6px;background:var(--bg-alt);border-radius:100px;overflow:hidden">
                      <div style="height:100%;width:${totalAppointments > 0 ? (cancelledCount * 100 / total) : 0}%;background:#DC2626;border-radius:100px"></div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>

    </div><!-- /page-content -->
  </main>
</div><!-- /app-shell -->

<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/static/js/manager-dashboard.js"></script>
</body>
</html>
