<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Lịch hẹn của tôi – BV Mắt PTIT</title>
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

  <!-- Sidebar -->
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
        <a href="${pageContext.request.contextPath}/patient/history" class="nav-link-h active">
          <span class="nav-icon"><i class="fas fa-calendar-days"></i></span>
          <span class="nav-label">Lịch hẹn của tôi</span>
          <span class="nav-badge">1</span>
        </a>
      </div>
      <div class="nav-section-label">Hồ sơ</div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/patient/history" class="nav-link-h">
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
        <div class="avatar avatar-md"><c:choose><c:when test="${not empty sessionScope.user.fullName}">${fn:substring(sessionScope.user.fullName, 0, 1)}</c:when><c:otherwise>?</c:otherwise></c:choose></div>
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
          <div class="topbar-title">Lịch hẹn của tôi</div>
          <div style="font-size:12px;color:var(--text-muted)">Quản lý và theo dõi các lịch khám</div>
        </div>
      </div>
      <div class="topbar-right">
        <a href="${pageContext.request.contextPath}/patient/appointment" class="btn-hospital btn-primary-h btn-sm">
          <i class="fas fa-plus"></i> Đặt lịch mới
        </a>
        <button class="topbar-icon-btn">
          <i class="fas fa-bell"></i><span class="notif-dot"></span>
        </button>
        <button class="topbar-user">
          <div class="avatar avatar-sm"><c:choose><c:when test="${not empty sessionScope.user.fullName}">${fn:substring(sessionScope.user.fullName, 0, 1)}</c:when><c:otherwise>?</c:otherwise></c:choose></div>
          <div class="user-details d-none d-md-block">
            <span class="user-name">${sessionScope.user.fullName}</span>
            <span class="user-role">Bệnh nhân</span>
          </div>
        </button>
      </div>
    </header>

    <div class="content-area">
      <!-- Tab filter -->
      <div class="tab-nav-h">
        <button class="tab-btn active" onclick="filterTab(this,'all')">Tất cả</button>
        <button class="tab-btn" onclick="filterTab(this,'pending')">Chờ xác nhận</button>
        <button class="tab-btn" onclick="filterTab(this,'confirmed')">Đã xác nhận</button>
        <button class="tab-btn" onclick="filterTab(this,'done')">Hoàn thành</button>
        <button class="tab-btn" onclick="filterTab(this,'cancelled')">Đã huỷ</button>
      </div>

      <!-- Table -->
      <div class="card-hospital">
        <div class="card-body-h" style="padding:0">
          <div style="overflow-x:auto">
            <table class="data-table" id="apptTable">
              <thead>
                <tr>
                  <th>Ngày & Giờ</th>
                  <th>Bác sĩ</th>
                  <th>Chuyên khoa</th>
                  <th>Phòng</th>
                  <th>Trạng thái</th>
                  <th class="action-cell">Thao tác</th>
                </tr>
              </thead>
              <tbody>
                <c:choose>
                  <c:when test="${empty appointments}">
                    <tr><td colspan="6" style="text-align:center;padding:24px;color:var(--text-muted)">Không có lịch hẹn nào</td></tr>
                  </c:when>
                  <c:otherwise>
                    <c:forEach var="appt" items="${appointments}">
                    <tr data-status="${appt.status}">
                      <td>${appt.date} ${appt.time}</td>
                      <td>${appt.doctorId}</td>
                      <td>${appt.roomId}</td>
                      <td>${appt.roomId}</td>
                      <td><span class="badge-status badge-${appt.status.toLowerCase()}">${appt.status}</span></td>
                      <td class="action-cell">
                        <c:if test="${appt.status == 'PENDING' || appt.status == 'CONFIRMED'}">
                          <button class="btn-hospital btn-danger-h btn-sm" onclick="openCancel(this)">Huỷ</button>
                        </c:if>
                      </td>
                    </tr>
                    </c:forEach>
                  </c:otherwise>
                </c:choose>
              </tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>

<!-- Confirm Cancel Modal -->
<div class="confirm-overlay" id="cancelOverlay">
  <div class="confirm-box">
    <div class="confirm-icon" style="color:var(--danger)"><i class="fas fa-triangle-exclamation"></i></div>
    <h5>Xác nhận huỷ lịch</h5>
    <p>Bạn có chắc muốn huỷ lịch khám này? Hành động không thể hoàn tác.</p>
    <div class="confirm-actions">
      <button class="btn-hospital btn-ghost-h" onclick="closeCancel()">Không, giữ lại</button>
      <button class="btn-hospital btn-danger-h" onclick="confirmCancel()">Huỷ lịch</button>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/static/js/patient-appointments.js"></script>
</body>
</html>
