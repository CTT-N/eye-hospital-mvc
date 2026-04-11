<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bệnh án của tôi – BV Mắt PTIT</title>
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
    <a href="${pageContext.request.contextPath}/patient/dashboard" class="sidebar-brand">
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
        </a>
      </div>
      <div class="nav-section-label">Hồ sơ</div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/patient/medical-records" class="nav-link-h active">
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
          <div class="topbar-title">Bệnh án của tôi</div>
          <div style="font-size:12px;color:var(--text-muted)">Hồ sơ bệnh án và kết quả khám</div>
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

    <div class="content-area">

      <c:choose>
        <%-- DETAIL MODE: single appointment's medical record --%>
        <c:when test="${detailMode}">
          <div class="page-header-h">
            <div>
              <h1 class="page-title">Chi tiết bệnh án</h1>
              <div class="page-subtitle">
                <a href="${pageContext.request.contextPath}/patient/medical-records" style="color:var(--primary)">
                  <i class="fas fa-arrow-left"></i> Quay lại danh sách
                </a>
              </div>
            </div>
          </div>

          <c:choose>
            <c:when test="${empty record}">
              <div class="card-hospital">
                <div class="card-body-h" style="text-align:center;padding:40px;color:var(--text-muted)">
                  <i class="fas fa-folder-open" style="font-size:40px;margin-bottom:16px;display:block"></i>
                  Chưa có bệnh án cho lịch hẹn này.
                </div>
              </div>
            </c:when>
            <c:otherwise>
              <div class="card-hospital">
                <div class="card-body-h">
                  <div class="row g-4">
                    <div class="col-md-6">
                      <div class="form-label-h">Ngày khám</div>
                      <p>${appt.date}</p>
                    </div>
                    <div class="col-md-6">
                      <div class="form-label-h">Bác sĩ phụ trách</div>
                      <p>${appt.doctorId}</p>
                    </div>
                    <div class="col-12">
                      <div class="form-label-h">Triệu chứng</div>
                      <p>${record.symptoms}</p>
                    </div>
                    <div class="col-12">
                      <div class="form-label-h">Chẩn đoán</div>
                      <p>${record.diagnosis}</p>
                    </div>
                    <div class="col-12">
                      <div class="form-label-h">Phác đồ điều trị</div>
                      <p>${record.treatment}</p>
                    </div>
                    <c:if test="${not empty record.note}">
                    <div class="col-12">
                      <div class="form-label-h">Ghi chú</div>
                      <p>${record.note}</p>
                    </div>
                    </c:if>
                  </div>
                </div>
              </div>
            </c:otherwise>
          </c:choose>
        </c:when>

        <%-- LIST MODE: all medical records for this patient --%>
        <c:otherwise>
          <div class="page-header-h">
            <div>
              <h1 class="page-title">Bệnh án của tôi</h1>
              <div class="page-subtitle">Toàn bộ hồ sơ bệnh án</div>
            </div>
          </div>

          <c:choose>
            <c:when test="${empty records}">
              <div class="card-hospital">
                <div class="card-body-h" style="text-align:center;padding:40px;color:var(--text-muted)">
                  <i class="fas fa-notes-medical" style="font-size:40px;margin-bottom:16px;display:block"></i>
                  Chưa có bệnh án nào.
                </div>
              </div>
            </c:when>
            <c:otherwise>
              <div class="timeline-v">
                <c:forEach var="rec" items="${records}">
                <c:set var="appt" value="${apptMap[rec.appointmentId]}" />
                <div class="timeline-v-item">
                  <div class="timeline-v-dot" style="background:#DBEAFE;color:#1E40AF">
                    <i class="fas fa-notes-medical"></i>
                  </div>
                  <div class="timeline-v-content">
                    <div class="tl-date">${rec.createdDate}</div>
                    <div class="tl-title">
                      <c:choose>
                        <c:when test="${not empty rec.diagnosis}">${rec.diagnosis}</c:when>
                        <c:otherwise>Bệnh án #${rec.recordId}</c:otherwise>
                      </c:choose>
                    </div>
                    <div class="tl-sub">
                      Lịch hẹn ngày ${appt.date}
                      · <span class="badge-status badge-${fn:toLowerCase(appt.status)}" style="font-size:10px">${appt.status}</span>
                    </div>
                    <a href="${pageContext.request.contextPath}/patient/medical-records?appointmentId=${rec.appointmentId}"
                       class="btn-hospital btn-ghost-h btn-sm" style="margin-top:8px">
                      <i class="fas fa-eye"></i> Xem chi tiết
                    </a>
                  </div>
                </div>
                </c:forEach>
              </div>
            </c:otherwise>
          </c:choose>
        </c:otherwise>
      </c:choose>

    </div>
  </main>
</div>

<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
</body>
</html>
