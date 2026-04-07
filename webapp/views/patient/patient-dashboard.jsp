<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Cổng Bệnh Nhân – BV Mắt PTIT</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/patient-dashboard.css" rel="stylesheet">

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
        <a href="${pageContext.request.contextPath}/patient/dashboard" class="nav-link-h active">
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
          <span class="nav-badge">${upcomingCount}</span>
        </a>
      </div>
      <div class="nav-section-label">Hồ sơ</div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/patient/medical-records" class="nav-link-h">
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
          <div class="topbar-title">Xin chào, ${sessionScope.user.fullName}!</div>
          <div style="font-size:12px;color:var(--text-muted)" id="currentDate"></div>
<script>
  (function(){
    var now = new Date();
    var days = ['Chủ Nhật','Thứ Hai','Thứ Ba','Thứ Tư','Thứ Năm','Thứ Sáu','Thứ Bảy'];
    document.getElementById('currentDate').textContent = days[now.getDay()] + ', ' + now.toLocaleDateString('vi-VN');
  })();
</script>
        </div>
      </div>
      <div class="topbar-right">
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

    <div class="page-content">
      <!-- Next appointment banner -->
      <c:if test="${not empty appointments}">
      <div style="background:linear-gradient(135deg, var(--primary) 0%, #0F2E4A 100%);border-radius:var(--radius-xl);padding:28px 32px;margin-bottom:24px;color:#fff;display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:16px">
        <div>
          <div style="font-size:12px;font-weight:600;text-transform:uppercase;letter-spacing:0.05em;opacity:0.65;margin-bottom:8px">
            <i class="fas fa-calendar-check" style="margin-right:4px"></i>Lịch hẹn sắp tới
          </div>
          <h2 style="font-size:22px;font-weight:700;color:#fff;margin:0 0 6px">
            Tái khám võng mạc
          </h2>
          <div style="font-size:14px;opacity:0.80;display:flex;flex-wrap:wrap;gap:16px">
            <span><i class="fas fa-clock" style="margin-right:6px"></i>${appointments[0].time}, ${appointments[0].date}</span>
            <span><i class="fas fa-user-doctor" style="margin-right:6px"></i>${appointments[0].doctorId}</span>
            <span><i class="fas fa-location-dot" style="margin-right:6px"></i>Phòng ${appointments[0].roomId}</span>
          </div>
        </div>
        <div class="d-flex gap-2">
          <button class="btn-hospital" style="background:rgba(255,255,255,0.15);color:#fff;border:1px solid rgba(255,255,255,0.25)">
            <i class="fas fa-calendar-xmark"></i> Hủy lịch
          </button>
          <button class="btn-hospital" style="background:#fff;color:var(--primary);font-weight:600">
            <i class="fas fa-qrcode"></i> Xem mã QR
          </button>
        </div>
      </div>
      </c:if>

      <!-- Stats -->
      <div class="row g-3 mb-4">
        <div class="col-6 col-md-3">
          <div class="stat-card stat-blue">
            <div class="stat-icon"><i class="fas fa-calendar"></i></div>
            <div class="stat-info">
              <div class="label">Tổng lượt khám</div>
              <div class="value">${totalCount}</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-md-3">
          <div class="stat-card stat-green">
            <div class="stat-icon"><i class="fas fa-calendar-check"></i></div>
            <div class="stat-info">
              <div class="label">Đã xác nhận</div>
              <div class="value">${upcomingCount}</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-md-3">
          <div class="stat-card stat-orange">
            <div class="stat-icon"><i class="fas fa-clock"></i></div>
            <div class="stat-info">
              <div class="label">Chờ xác nhận</div>
              <div class="value">${pendingCount}</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-md-3">
          <div class="stat-card stat-teal">
            <div class="stat-icon"><i class="fas fa-file-invoice"></i></div>
            <div class="stat-info">
              <div class="label">Hóa đơn</div>
              <div class="value"><a href="${pageContext.request.contextPath}/patient/invoices" style="color:inherit">Xem</a></div>
            </div>
          </div>
        </div>
      </div>

      <div class="row g-3">
        <!-- Appointment History Timeline -->
        <div class="col-lg-7">
          <div class="card-hospital">
            <div class="card-header-h">
              <h5>Lịch sử khám bệnh</h5>
              <a href="${pageContext.request.contextPath}/patient/history" class="btn-hospital btn-ghost-h btn-sm">
                Xem tất cả <i class="fas fa-arrow-right"></i>
              </a>
            </div>
            <div class="card-body-h" style="padding:0">
              <table class="table-hospital">
                <thead>
                  <tr>
                    <th>Ngày khám</th>
                    <th>Bác sĩ / Chuyên khoa</th>
                    <th>Chẩn đoán</th>
                    <th>Hóa đơn</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  <c:choose>
                    <c:when test="${empty appointments}">
                      <tr><td colspan="5" style="text-align:center;padding:24px;color:var(--text-muted)">Không có lịch sử khám bệnh</td></tr>
                    </c:when>
                    <c:otherwise>
                      <c:forEach var="appt" items="${appointments}">
                      <tr>
                        <td>
                          <div style="font-size:13px;font-weight:600">${appt.date}</div>
                          <div style="font-size:11px;color:var(--text-muted)">${appt.time}</div>
                        </td>
                        <td>
                          <div style="font-size:13px;font-weight:500">${appt.doctorId}</div>
                          <div style="font-size:11px;color:var(--text-muted)">${appt.roomId}</div>
                        </td>
                        <td style="font-size:12px;max-width:180px">${appt.status}</td>
                        <td><span class="badge-h badge-success">${appt.status}</span></td>
                        <td>
                          <button class="btn-hospital btn-ghost-h btn-sm">
                            <i class="fas fa-eye"></i>
                          </button>
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

        <!-- Quick Actions + Health Summary -->
        <div class="col-lg-5">
          <div class="row g-3">
            <!-- Quick actions -->
            <div class="col-12">
              <div class="card-hospital">
                <div class="card-header-h"><h5>Thao tác nhanh</h5></div>
                <div class="card-body-h">
                  <div class="row g-2">
                    <div class="col-6">
                      <a href="${pageContext.request.contextPath}/patient/appointment"
                         style="display:flex;flex-direction:column;align-items:center;gap:8px;padding:16px;background:var(--bg-alt);border-radius:12px;border:1px solid var(--border);text-decoration:none;color:var(--text-primary);transition:all 0.15s;text-align:center">
                        <i class="fas fa-calendar-plus" style="font-size:24px;color:var(--primary-light)"></i>
                        <span style="font-size:13px;font-weight:600">Đặt lịch khám</span>
                      </a>
                    </div>
                    <div class="col-6">
                      <a href="${pageContext.request.contextPath}/patient/history"
                         style="display:flex;flex-direction:column;align-items:center;gap:8px;padding:16px;background:var(--bg-alt);border-radius:12px;border:1px solid var(--border);text-decoration:none;color:var(--text-primary);transition:all 0.15s;text-align:center">
                        <i class="fas fa-file-medical" style="font-size:24px;color:var(--success)"></i>
                        <span style="font-size:13px;font-weight:600">Xem bệnh án</span>
                      </a>
                    </div>
                    <div class="col-6">
                      <a href="${pageContext.request.contextPath}/common/find-doctor"
                         style="display:flex;flex-direction:column;align-items:center;gap:8px;padding:16px;background:var(--bg-alt);border-radius:12px;border:1px solid var(--border);text-decoration:none;color:var(--text-primary);transition:all 0.15s;text-align:center">
                        <i class="fas fa-user-doctor" style="font-size:24px;color:var(--accent)"></i>
                        <span style="font-size:13px;font-weight:600">Tìm bác sĩ</span>
                      </a>
                    </div>
                    <div class="col-6">
                      <a href="${pageContext.request.contextPath}/patient/invoices"
                         style="display:flex;flex-direction:column;align-items:center;gap:8px;padding:16px;background:var(--bg-alt);border-radius:12px;border:1px solid var(--border);text-decoration:none;color:var(--text-primary);transition:all 0.15s;text-align:center">
                        <i class="fas fa-file-invoice-dollar" style="font-size:24px;color:var(--warning)"></i>
                        <span style="font-size:13px;font-weight:600">Hóa đơn</span>
                      </a>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <!-- Health info -->
            <div class="col-12">
              <div class="card-hospital">
                <div class="card-header-h"><h5>Thông tin sức khỏe</h5></div>
                <div class="card-body-h">
                  <div class="d-flex flex-column gap-2">
                    <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid var(--border);font-size:13px">
                      <span style="color:var(--text-muted)">Giới tính</span>
                      <span style="font-weight:600">
                        <c:choose>
                          <c:when test="${not empty patient.gender}">${patient.gender}</c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                      </span>
                    </div>
                    <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid var(--border);font-size:13px">
                      <span style="color:var(--text-muted)">Ngày sinh</span>
                      <span style="font-weight:600">
                        <c:choose>
                          <c:when test="${not empty patient.birthday}">${patient.birthday}</c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                      </span>
                    </div>
                    <div style="display:flex;justify-content:space-between;padding:8px 0;border-bottom:1px solid var(--border);font-size:13px">
                      <span style="color:var(--text-muted)">Địa chỉ</span>
                      <span style="font-weight:600">
                        <c:choose>
                          <c:when test="${not empty patient.address}">${patient.address}</c:when>
                          <c:otherwise>—</c:otherwise>
                        </c:choose>
                      </span>
                    </div>
                    <div style="display:flex;justify-content:space-between;padding:8px 0;font-size:13px">
                      <span style="color:var(--text-muted)">Ghi chú</span>
                      <span style="font-weight:600">
                        <c:choose>
                          <c:when test="${not empty patient.note}">${patient.note}</c:when>
                          <c:otherwise>Không có</c:otherwise>
                        </c:choose>
                      </span>
                    </div>
                  </div>
                </div>
              </div>
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
