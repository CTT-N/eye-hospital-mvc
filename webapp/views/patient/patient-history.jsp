<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Lịch sử khám bệnh – BV Mắt PTIT</title>
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
      <div class="brand-text">BV Mắt PTIT<small>Cổng Bệnh Nhân</small></div>
    </a>
    <nav class="sidebar-nav">
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/patient/dashboard" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-house"></i></span>
          <span class="nav-label">Tổng quan</span>
        </a>
      </div>
      <div class="nav-section-label">Lịch khám</div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/patient/appointment" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-calendar-plus"></i></span>
          <span class="nav-label">Đặt lịch mới</span>
        </a>
      </div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/patient/history" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-calendar-days"></i></span>
          <span class="nav-label">Lịch hẹn của tôi</span>
          <span class="nav-badge">1</span>
        </a>
      </div>
      <div class="nav-section-label">Hồ sơ</div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/patient/history" class="nav-link-h active">
          <span class="nav-icon"><i class="fas fa-notes-medical"></i></span>
          <span class="nav-label">Bệnh án của tôi</span>
        </a>
      </div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/patient/invoices" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-file-invoice-dollar"></i></span>
          <span class="nav-label">Hóa đơn thanh toán</span>
        </a>
      </div>
      <div class="nav-section-label">Tài khoản</div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/patient/profile" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-user-circle"></i></span>
          <span class="nav-label">Thông tin cá nhân</span>
        </a>
      </div>
    </nav>
    <div class="sidebar-footer">
      <div class="sidebar-user">
        <div class="avatar avatar-md">${sessionScope.user.fullName.charAt(0)}</div>
        <div class="user-info">
          <div class="user-name">${sessionScope.user.fullName}</div>
          <div class="user-role">Bệnh nhân</div>
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
          <div class="topbar-title">Lịch sử khám bệnh</div>
          <div style="font-size:12px;color:var(--text-muted)">Toàn bộ hồ sơ khám bệnh của bạn</div>
        </div>
      </div>
      <div class="topbar-right">
        <button class="topbar-icon-btn">
          <i class="fas fa-bell"></i><span class="notif-dot"></span>
        </button>
        <button class="topbar-user">
          <div class="avatar avatar-sm">${sessionScope.user.fullName.charAt(0)}</div>
          <div class="user-details d-none d-md-block">
            <span class="user-name">${sessionScope.user.fullName}</span>
            <span class="user-role">Bệnh nhân</span>
          </div>
        </button>
      </div>
    </header>

    <div class="content-area">
      <div class="page-header-h">
        <div>
          <h1 class="page-title">Lịch sử khám bệnh</h1>
          <div class="page-subtitle">Nhấn vào từng lần để xem chi tiết</div>
        </div>
      </div>

      <!-- Timeline -->
      <div class="timeline-v" id="historyTimeline">

        <c:choose>
          <c:when test="${empty appointments}">
            <p style="text-align:center;padding:24px;color:var(--text-muted)">Chưa có bệnh án nào</p>
          </c:when>
          <c:otherwise>
            <c:forEach var="appt" items="${appointments}">
            <div class="timeline-v-item">
              <div class="timeline-v-dot" style="background:#DBEAFE;color:#1E40AF">
                <i class="fas fa-stethoscope"></i>
              </div>
              <div class="timeline-v-content">
                <div class="tl-date">${appt.date}</div>
                <div class="tl-title">Lịch hẹn - ${appt.doctorId}</div>
                <div class="tl-sub">Phòng ${appt.roomId} · <span class="badge-status badge-${appt.status.toLowerCase()}" style="font-size:10px">${appt.status}</span></div>
                <button class="btn-hospital btn-ghost-h btn-sm" style="margin-top:8px" onclick="toggleRecord(this)">
                  <i class="fas fa-chevron-down"></i> Xem chi tiết
                </button>
                <div class="tl-body" style="display:none">
                  <div class="card-hospital" style="margin-top:10px">
                    <div class="card-body-h">
                      <div class="row g-3">
                        <div class="col-md-6">
                          <div class="form-label-h">Phòng</div>
                          <p style="font-size:var(--font-sm)">${appt.roomId}</p>
                        </div>
                        <div class="col-md-6">
                          <div class="form-label-h">Trạng thái</div>
                          <p style="font-size:var(--font-sm)">${appt.status}</p>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            </c:forEach>
          </c:otherwise>
        </c:choose>

      </div><!-- end timeline-v -->
    </div>
  </main>
</div>

<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/static/js/patient-history.js"></script>
</body>
</html>
