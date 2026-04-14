<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Lich kham theo ngay - BV Mat PTIT</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  
  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/doctor-schedule.css" rel="stylesheet">
</head>
<body>
<div class="app-shell">

  <aside class="sidebar">
    <a href="${pageContext.request.contextPath}/doctor/dashboard" class="sidebar-brand">
      <div class="brand-logo">
        <svg viewBox="0 0 24 24" style="width:18px;height:18px;fill:#fff" xmlns="http://www.w3.org/2000/svg">
          <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zm0 12.5a5 5 0 1 1 0-10 5 5 0 0 1 0 10zm0-8a3 3 0 1 0 0 6 3 3 0 0 0 0-6z"/>
        </svg>
      </div>
      <div class="brand-text">BV Mat PTIT<small>Cong Bac Si</small></div>
    </a>
    <nav class="sidebar-nav">
      <div class="nav-item"><a href="${pageContext.request.contextPath}/doctor/dashboard" class="nav-link-h"><span class="nav-icon"><i class="fas fa-house"></i></span><span class="nav-label">Tong quan</span></a></div>
      <div class="nav-section-label">Lich kham</div>
      <div class="nav-item"><a href="${pageContext.request.contextPath}/doctor/schedule" class="nav-link-h active"><span class="nav-icon"><i class="fas fa-calendar-days"></i></span><span class="nav-label">Lich theo ngay</span></a></div>
      <div class="nav-item"><a href="${pageContext.request.contextPath}/doctor/patients" class="nav-link-h"><span class="nav-icon"><i class="fas fa-users"></i></span><span class="nav-label">Danh sach benh nhan</span></a></div>
      <div class="nav-section-label">Tai khoan</div>
      <div class="nav-item"><a href="${pageContext.request.contextPath}/doctor/profile" class="nav-link-h"><span class="nav-icon"><i class="fas fa-user-doctor"></i></span><span class="nav-label">Ho so bac si</span></a></div>
    </nav>
    <div class="sidebar-footer">
      <div class="sidebar-user">
        <div class="avatar avatar-md" style="background:var(--primary-light)"><c:choose><c:when test="${fn:length(sessionScope.user.fullName) >= 2}">${fn:substring(sessionScope.user.fullName, 0, 2)}</c:when><c:when test="${fn:length(sessionScope.user.fullName) == 1}">${fn:substring(sessionScope.user.fullName, 0, 1)}</c:when><c:otherwise>?</c:otherwise></c:choose></div>
        <div class="user-info"><div class="user-name">${sessionScope.user.fullName}</div><div class="user-role">Bac si</div></div>
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
          <div class="topbar-title">Lich kham cua toi</div>
          <div style="font-size:12px;color:var(--text-muted)">Xem lich kham theo ngay</div>
        </div>
      </div>
      <div class="topbar-right">
        <button class="topbar-icon-btn"><i class="fas fa-magnifying-glass"></i></button>
        <button class="topbar-icon-btn"><i class="fas fa-bell"></i><span class="notif-dot"></span></button>
        <button class="topbar-user">
          <div class="avatar avatar-sm" style="background:var(--primary-light)"><c:choose><c:when test="${fn:length(sessionScope.user.fullName) >= 2}">${fn:substring(sessionScope.user.fullName, 0, 2)}</c:when><c:when test="${fn:length(sessionScope.user.fullName) == 1}">${fn:substring(sessionScope.user.fullName, 0, 1)}</c:when><c:otherwise>?</c:otherwise></c:choose></div>
          <div class="user-details d-none d-md-block"><span class="user-name">${sessionScope.user.fullName}</span><span class="user-role">Bac si</span></div>
          <i class="fas fa-chevron-down" style="font-size:11px;color:var(--text-muted)"></i>
        </button>
      </div>
    </header>

    <div class="content-area">
      <!-- Date Navigator -->
      <div class="date-nav">
        <button class="date-nav-btn" onclick="changeDay(-1)"><i class="fas fa-chevron-left"></i></button>
        <div class="date-display">
          <div class="day-label" id="dayLabel">Hom nay</div>
          <div class="date-full" id="dateFull"></div>
        </div>
        <button class="date-nav-btn" onclick="changeDay(1)"><i class="fas fa-chevron-right"></i></button>
        <input type="date" class="form-control-h" id="datePicker" style="width:auto;margin-left:auto" onchange="pickDate(this.value)">
      </div>

      <!-- Summary row -->
      <div style="display:flex;gap:12px;margin-bottom:var(--gap-lg);flex-wrap:wrap">
        <div class="stat-card" style="flex:1;min-width:140px">
          <div class="stat-icon stat-blue"><i class="fas fa-calendar-check"></i></div>
          <div class="stat-info"><div class="label">Tong lich</div><div class="value" id="totalCount">${appointments.size()}</div></div>
        </div>
        <div class="stat-card" style="flex:1;min-width:140px">
          <div class="stat-icon stat-orange"><i class="fas fa-clock"></i></div>
          <div class="stat-info"><div class="label">Cho kham</div><div class="value" id="pendingCount">0</div></div>
        </div>
        <div class="stat-card" style="flex:1;min-width:140px">
          <div class="stat-icon stat-green"><i class="fas fa-circle-check"></i></div>
          <div class="stat-info"><div class="label">Da kham</div><div class="value" id="doneCount">0</div></div>
        </div>
      </div>

      <!-- Schedule list -->
      <div id="scheduleList">
        <c:choose>
          <c:when test="${empty appointments}">
            <p style="text-align:center;padding:24px;color:var(--text-muted)">Khong co lich hen nao</p>
          </c:when>
          <c:otherwise>
            <c:forEach var="appt" items="${appointments}">
            <div class="schedule-card" style="display:flex;align-items:center;gap:12px">
              <div class="schedule-time"><div class="time">${appt.time}</div><div class="dur">30 phut</div></div>
              <div class="schedule-divider"></div>
              <div class="schedule-info" style="flex:1">
                <div class="patient-name">
                  <c:choose>
                    <c:when test="${not empty appt.patientName}">${appt.patientName}</c:when>
                    <c:otherwise>${appt.patientId}</c:otherwise>
                  </c:choose>
                </div>
                <div class="schedule-meta">
                  <c:choose>
                    <c:when test="${not empty appt.roomId}">
                      <span><i class="fas fa-door-open" style="margin-right:4px"></i>Phong ${appt.roomId}</span>
                    </c:when>
                    <c:otherwise>
                      <span style="color:var(--text-muted)">Chua co phong</span>
                    </c:otherwise>
                  </c:choose>
                </div>
              </div>
              <span class="badge-status badge-${fn:toLowerCase(appt.status)}" style="align-self:center">${appt.status}</span>
              <div style="display:flex;gap:6px;align-self:center">
                <c:if test="${appt.status == 'PENDING'}">
                  <form method="post" action="${pageContext.request.contextPath}/doctor/schedule" style="margin:0">
                    <input type="hidden" name="appointmentId" value="${appt.appointmentId}">
                    <input type="hidden" name="status" value="CONFIRMED">
                    <button type="submit" class="btn-hospital btn-primary-h btn-sm">Xac nhan</button>
                  </form>
                </c:if>
                <a href="${pageContext.request.contextPath}/doctor/examination?appointmentId=${appt.appointmentId}"
                   class="btn-hospital btn-ghost-h btn-sm">Kham</a>
              </div>
            </div>
            </c:forEach>
          </c:otherwise>
        </c:choose>
      </div>
    </div>
  </main>
</div>

<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/static/js/doctor-schedule.js"></script>
</body>
</html>
