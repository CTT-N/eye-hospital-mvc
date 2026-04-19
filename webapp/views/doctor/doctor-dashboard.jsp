<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard Bac Si - BV Mat PTIT</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/doctor-dashboard.css" rel="stylesheet">
</head>
<body>
<div class="app-shell">
  <!-- ==== SIDEBAR ==== -->
  <aside class="sidebar">
    <a href="${pageContext.request.contextPath}/doctor/dashboard" class="sidebar-brand">
      <div class="brand-logo"><svg viewBox="0 0 24 24" style="width:18px;height:18px;fill:#fff" xmlns="http://www.w3.org/2000/svg"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zm0 12.5a5 5 0 1 1 0-10 5 5 0 0 1 0 10zm0-8a3 3 0 1 0 0 6 3 3 0 0 0 0-6z"/></svg></div>
      <div class="brand-text">
        BV Mat PTIT
        <small>Cong Bac Si</small>
      </div>
    </a>

    <nav class="sidebar-nav">
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/doctor/dashboard" class="nav-link-h active">
          <span class="nav-icon"><i class="fas fa-house-medical"></i></span>
          <span class="nav-label">Tong quan</span>
        </a>
      </div>
      <div class="nav-section-label">Lich kham</div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/doctor/schedule" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-calendar-days"></i></span>
          <span class="nav-label">Lich theo ngay</span>
        </a>
      </div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/doctor/patients" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-users"></i></span>
          <span class="nav-label">Danh sach benh nhan</span>
        </a>
      </div>
      <div class="nav-section-label">Tai khoan</div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/doctor/profile" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-user-doctor"></i></span>
          <span class="nav-label">Ho so bac si</span>
        </a>
      </div>
    </nav>

    <div class="sidebar-footer">
      <div class="sidebar-user">
        <div class="avatar avatar-md"><c:choose><c:when test="${fn:length(sessionScope.user.fullName) >= 2}">${fn:substring(sessionScope.user.fullName, 0, 2)}</c:when><c:when test="${fn:length(sessionScope.user.fullName) == 1}">${fn:substring(sessionScope.user.fullName, 0, 1)}</c:when><c:otherwise>?</c:otherwise></c:choose></div>
        <div class="user-info">
          <div class="user-name">${sessionScope.user.fullName}</div>
          <div class="user-role">Chuyen khoa</div>
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
    <header class="topbar">
      <div class="topbar-left">
        <button class="topbar-icon-btn" id="sidebarToggle">
          <i class="fas fa-bars"></i>
        </button>
        <div>
          <div class="topbar-title">Chao buoi sang, ${sessionScope.user.fullName}</div>
          <div style="font-size:12px;color:var(--text-muted)">Trang chu Bac Si</div>
        </div>
      </div>
      <div class="topbar-right">
        <button class="topbar-icon-btn">
          <i class="fas fa-bell"></i>
          <span class="notif-dot"></span>
        </button>
        <button class="topbar-user">
          <div class="avatar avatar-sm"><c:choose><c:when test="${fn:length(sessionScope.user.fullName) >= 2}">${fn:substring(sessionScope.user.fullName, 0, 2)}</c:when><c:when test="${fn:length(sessionScope.user.fullName) == 1}">${fn:substring(sessionScope.user.fullName, 0, 1)}</c:when><c:otherwise>?</c:otherwise></c:choose></div>
          <div class="user-details d-none d-md-block">
            <span class="user-name">${sessionScope.user.fullName}</span>
            <span class="user-role">Bac si</span>
          </div>
        </button>
      </div>
    </header>

    <div class="page-content">

      <!-- Quick stats -->
      <div class="row g-3 mb-4">
        <div class="col-6 col-xl-3">
          <div class="stat-card stat-blue">
            <div class="stat-icon"><i class="fas fa-calendar-day"></i></div>
            <div class="stat-info">
              <div class="label">Lich hen hom nay</div>
              <div class="value">${totalAppointments}</div>
              <div class="trend" style="color:var(--text-muted);font-size:11px">Tong cong hom nay</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-xl-3">
          <div class="stat-card stat-green">
            <div class="stat-icon"><i class="fas fa-user-check"></i></div>
            <div class="stat-info">
              <div class="label">Da kham xong</div>
              <div class="value">${completedTodayCount}</div>
              <div class="trend trend-up" style="font-size:11px">Da hoan thanh</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-xl-3">
          <div class="stat-card stat-orange">
            <div class="stat-icon"><i class="fas fa-hourglass-half"></i></div>
            <div class="stat-info">
              <div class="label">Con cho kham</div>
              <div class="value">${pendingCount}</div>
              <div class="trend" style="color:var(--warning);font-size:11px">Cho xu ly</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-xl-3">
          <div class="stat-card stat-teal">
            <div class="stat-icon"><i class="fas fa-star"></i></div>
            <div class="stat-info">
              <div class="label">Chua kham</div>
              <div class="value">${totalAppointments - completedTodayCount}</div>
              <div class="trend trend-up" style="font-size:11px">Con lai hom nay</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Main grid -->
      <div class="row g-3">
        <!-- Today appointment list (read-only) -->
        <div class="col-lg-4">
          <div class="card-hospital" style="height:100%">
            <div class="card-header-h">
              <div>
                <h5>Lich kham hom nay</h5>
                <p style="font-size:12px;color:var(--text-muted);margin:0">${totalAppointments} lich hen</p>
              </div>
              <span class="badge-h badge-info">Overview</span>
            </div>
            <div class="card-body-h" style="padding:12px;max-height:480px;overflow-y:auto">
              <c:choose>
                <c:when test="${empty todayAppointments}">
                  <div style="text-align:center;padding:40px 20px;color:var(--text-muted)">
                    <i class="fas fa-calendar-xmark" style="font-size:32px;margin-bottom:12px;opacity:0.3"></i>
                    <p>Khong co lich kham hom nay</p>
                  </div>
                </c:when>
                <c:otherwise>
                  <div class="d-flex flex-column gap-2">
                    <c:forEach var="appt" items="${todayAppointments}" varStatus="loop">
                      <div class="patient-item">
                        <div class="patient-num">${loop.count}</div>
                        <div class="avatar avatar-sm">${fn:substring(appt.patientId, 0, 2)}</div>
                        <div class="flex-grow-1">
                          <div class="name" style="font-size:13px;font-weight:600">${appt.patientId}</div>
                          <div style="font-size:11px;color:var(--text-muted)">${appt.time}</div>
                        </div>
                        <c:choose>
                          <c:when test="${appt.status == 'COMPLETED'}"><span class="badge-h badge-success" style="font-size:11px">Xong</span></c:when>
                          <c:when test="${appt.status == 'CONFIRMED'}"><span class="badge-h badge-info" style="font-size:11px">Da xac nhan</span></c:when>
                          <c:otherwise><span class="badge-h badge-warning" style="font-size:11px">Cho</span></c:otherwise>
                        </c:choose>
                      </div>
                    </c:forEach>
                  </div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>

        <!-- Guide panel -->
        <div class="col-lg-8">
          <div class="card-hospital">
            <div class="card-header-h">
              <h5>Kham benh hom nay</h5>
            </div>
            <div class="card-body-h">
              <p style="color:var(--text-muted);margin-bottom:16px">
                Vao trang Lich kham de xac nhan lich hen va bat dau buoi kham. Tat ca chuc nang ghi benh an duoc thuc hien tai do.
              </p>
              <a href="${pageContext.request.contextPath}/doctor/schedule" class="btn-hospital btn-primary-h">
                <i class="fas fa-calendar-days"></i> Mo lich kham
              </a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
</body>
</html>
