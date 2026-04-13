<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản lý lịch khám – BV Mắt PTIT</title>
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
        <a href="${pageContext.request.contextPath}/manager/schedule" class="nav-link-h active">
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
        <div><div class="topbar-title">Quản lý lịch khám</div><div style="font-size:12px;color:var(--text-muted)">Tạo và quản lý lịch khám bác sĩ</div></div>
      </div>
      <div class="topbar-right">
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
      <!-- Filter bar -->
      <div class="filter-bar">
        <div class="search-box" style="flex:1;max-width:280px">
          <span class="search-icon"><i class="fas fa-search"></i></span>
          <input class="form-control-h btn-sm" placeholder="Tìm bác sĩ, bệnh nhân..." id="searchInput" oninput="applyFilters()">
        </div>
        <select class="filter-select" id="filterStatus" onchange="applyFilters()">
          <option value="">Tất cả trạng thái</option>
          <option value="PENDING">Chờ xác nhận</option>
          <option value="CONFIRMED">Đã xác nhận</option>
          <option value="COMPLETED">Hoàn thành</option>
          <option value="CANCELLED">Đã hủy</option>
        </select>
        <input type="date" class="filter-select" id="filterDate" onchange="applyFilters()">
      </div>

      <div class="card-hospital">
        <div class="card-body-h" style="padding:0">
          <table class="data-table" id="schedTable">
            <thead>
              <tr><th>Ngày</th><th>Giờ</th><th>Bác sĩ</th><th>Bệnh nhân</th><th>Phòng</th><th>Trạng thái</th><th class="action-cell">Thao tác</th></tr>
            </thead>
            <tbody id="schedBody">
<c:forEach var="appt" items="${allAppointments}">
<tr>
  <td>${appt.date}</td>
  <td>${appt.time}</td>
  <td>${not empty appt.doctorName ? appt.doctorName : appt.doctorId}</td>
  <td>${not empty appt.patientName ? appt.patientName : appt.patientId}</td>
  <td>${not empty appt.roomId ? appt.roomId : '-'}</td>
  <td data-status="${appt.status}">
    <c:choose>
      <c:when test="${appt.status eq 'COMPLETED'}"><span class="badge-h badge-success">Hoàn thành</span></c:when>
      <c:when test="${appt.status eq 'CONFIRMED'}"><span class="badge-h badge-info">Đã xác nhận</span></c:when>
      <c:when test="${appt.status eq 'PENDING'}"><span class="badge-h badge-gray">Chờ xác nhận</span></c:when>
      <c:when test="${appt.status eq 'CANCELLED'}"><span class="badge-h badge-danger">Đã hủy</span></c:when>
      <c:otherwise><span class="badge-h badge-gray">${appt.status}</span></c:otherwise>
    </c:choose>
  </td>
  <td>
    <c:if test="${appt.status eq 'PENDING'}">
      <form action="${pageContext.request.contextPath}/manager/schedule" method="post" style="display:inline">
        <input type="hidden" name="appointmentId" value="${appt.appointmentId}">
        <input type="hidden" name="action" value="updateStatus">
        <input type="hidden" name="status" value="CONFIRMED">
        <button type="submit" class="btn-hospital btn-sm" title="Xác nhận"><i class="fas fa-check"></i></button>
      </form>
    </c:if>
    <form action="${pageContext.request.contextPath}/manager/schedule" method="post" style="display:inline" onsubmit="return confirm('Xóa lịch hẹn này?')">
      <input type="hidden" name="appointmentId" value="${appt.appointmentId}">
      <input type="hidden" name="action" value="delete">
      <button type="submit" class="btn-hospital btn-danger-h btn-sm" title="Xóa"><i class="fas fa-trash"></i></button>
    </form>
  </td>
</tr>
</c:forEach>
</tbody>
          </table>
        </div>
      </div>
    </div>
  </main>
</div>

<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/static/js/manager-schedules.js"></script>
</body>
</html>
