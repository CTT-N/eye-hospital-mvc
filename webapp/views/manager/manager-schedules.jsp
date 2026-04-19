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
  
  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
</head>
<body>
<div class="app-shell">
  <c:set var="activeManagerNav" value="schedule" />
  <%@ include file="_sidebar.jspf" %>

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
    <c:if test="${appt.status eq 'COMPLETED'}">
      <c:choose>
        <c:when test="${invoicedIds.contains(appt.appointmentId)}">
          <span class="badge-h badge-info" style="font-size:11px">Đã xuất HĐ</span>
        </c:when>
        <c:otherwise>
          <a href="${pageContext.request.contextPath}/manager/invoices/create?appointmentId=${appt.appointmentId}"
             class="btn-hospital btn-sm" title="Tạo hóa đơn">
            <i class="fas fa-file-invoice"></i>
          </a>
        </c:otherwise>
      </c:choose>
    </c:if>
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
