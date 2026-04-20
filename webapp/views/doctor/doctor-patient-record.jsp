<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Hồ sơ bệnh án - BV Mắt PTIT</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">

  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
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
      <div class="brand-text">BV Mắt PTIT<small>Cổng Bác Sĩ</small></div>
    </a>
    <nav class="sidebar-nav">
      <div class="nav-item"><a href="${pageContext.request.contextPath}/doctor/dashboard" class="nav-link-h"><span class="nav-icon"><i class="fas fa-house"></i></span><span class="nav-label">Tổng quan</span></a></div>
      <div class="nav-section-label">Lịch khám</div>
      <div class="nav-item"><a href="${pageContext.request.contextPath}/doctor/schedule" class="nav-link-h"><span class="nav-icon"><i class="fas fa-calendar-days"></i></span><span class="nav-label">Lịch theo ngày</span></a></div>
      <div class="nav-item"><a href="${pageContext.request.contextPath}/doctor/patients" class="nav-link-h active"><span class="nav-icon"><i class="fas fa-users"></i></span><span class="nav-label">Danh sách bệnh nhân</span></a></div>
      <div class="nav-section-label">Tài khoản</div>
      <div class="nav-item"><a href="${pageContext.request.contextPath}/doctor/profile" class="nav-link-h"><span class="nav-icon"><i class="fas fa-user-doctor"></i></span><span class="nav-label">Hồ sơ bác sĩ</span></a></div>
    </nav>
    <div class="sidebar-footer">
      <div class="sidebar-user">
        <div class="avatar avatar-md" style="background:var(--primary-light)"><c:choose><c:when test="${fn:length(sessionScope.user.fullName) >= 2}">${fn:substring(sessionScope.user.fullName, 0, 2)}</c:when><c:when test="${fn:length(sessionScope.user.fullName) == 1}">${fn:substring(sessionScope.user.fullName, 0, 1)}</c:when><c:otherwise>?</c:otherwise></c:choose></div>
        <div class="user-info"><div class="user-name">${sessionScope.user.fullName}</div><div class="user-role">Bác sĩ</div></div>
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
          <div class="topbar-title">Hồ sơ bệnh án</div>
          <div style="font-size:12px;color:var(--text-muted)">Cập nhật thông tin khám bệnh</div>
        </div>
      </div>
      <div class="topbar-right">
        <button class="topbar-icon-btn"><i class="fas fa-bell"></i><span class="notif-dot"></span></button>
        <button class="topbar-user">
          <div class="avatar avatar-sm" style="background:var(--primary-light)"><c:choose><c:when test="${fn:length(sessionScope.user.fullName) >= 2}">${fn:substring(sessionScope.user.fullName, 0, 2)}</c:when><c:when test="${fn:length(sessionScope.user.fullName) == 1}">${fn:substring(sessionScope.user.fullName, 0, 1)}</c:when><c:otherwise>?</c:otherwise></c:choose></div>
          <div class="user-details d-none d-md-block"><span class="user-name">${sessionScope.user.fullName}</span><span class="user-role">Bác sĩ</span></div>
        </button>
      </div>
    </header>

    <div class="content-area">
      <div class="breadcrumb-h">
        <a href="${pageContext.request.contextPath}/doctor/schedule">Lịch theo ngày</a>
        <span class="sep"><i class="fas fa-chevron-right"></i></span>
        <a href="${pageContext.request.contextPath}/doctor/patients">Bệnh nhân hôm nay</a>
        <span class="sep"><i class="fas fa-chevron-right"></i></span>
        <span class="current">Hồ sơ bệnh án</span>
      </div>

      <div class="row g-4">
        <!-- Left column -->
        <div class="col-lg-4">
          <!-- Patient info -->
          <div class="card-hospital" style="margin-bottom:16px">
            <div class="card-header-h"><h5>Thông tin bệnh nhân</h5></div>
            <div class="card-body-h">
              <div style="text-align:center;margin-bottom:16px">
                <div class="avatar" style="width:64px;height:64px;font-size:22px;margin:0 auto 8px;background:var(--warning)">${not empty patient ? patient.patientId.substring(0,2) : '--'}</div>
                <div style="font-weight:700;font-size:var(--font-md)">${not empty patient ? patient.patientId : 'N/A'}</div>
                <div style="font-size:12px;color:var(--text-muted)">${not empty patient ? patient.patientId : ''}</div>
              </div>
              <hr style="border-color:var(--border)">
              <div style="display:flex;flex-direction:column;gap:10px;font-size:var(--font-sm)">
                <div style="display:flex;justify-content:space-between">
                  <span style="color:var(--text-muted)">Điện thoại</span>
                  <span>${not empty patient ? patient.patientId : 'N/A'}</span>
                </div>
              </div>
            </div>
          </div>

          <!-- History accordion -->
          <div class="card-hospital">
            <div class="card-header-h"><h5>Lịch sử khám trước</h5></div>
            <div class="card-body-h" style="padding:12px">
              <c:choose>
                <c:when test="${empty listRecords}">
                  <p style="text-align:center;color:var(--text-muted);padding:16px">Chưa có lịch sử khám</p>
                </c:when>
                <c:otherwise>
                  <c:forEach var="rec" items="${listRecords}" varStatus="loop">
                  <div class="accordion-h ${loop.first ? 'open' : ''}" ${loop.index gt 0 ? 'style="margin-top:8px"' : ''}>
                    <div class="accordion-h-header" onclick="toggleAcc(this)">
                      <span>${rec.createdDate} - ${rec.diagnosis}</span>
                      <i class="fas fa-chevron-down acc-chevron"></i>
                    </div>
                    <div class="accordion-h-body">
                      <div style="font-size:12px;color:var(--text-muted);margin-bottom:6px">Bác sĩ: ${sessionScope.user.fullName}</div>
                      <div style="font-size:var(--font-sm)"><strong>Triệu chứng:</strong> ${rec.symptoms}</div>
                      <div style="font-size:var(--font-sm)"><strong>Chẩn đoán:</strong> ${rec.diagnosis}</div>
                      <div style="font-size:var(--font-sm)"><strong>Điều trị:</strong> ${rec.treatment}</div>
                    </div>
                  </div>
                  </c:forEach>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>

        <!-- Right: current exam form -->
        <div class="col-lg-8">
          <div class="card-hospital">
            <div class="card-header-h">
              <h5><i class="fas fa-stethoscope" style="color:var(--primary);margin-right:8px"></i>Phiếu khám hiện tại</h5>
            </div>
            <div class="card-body-h">
              <form action="${pageContext.request.contextPath}/doctor/medical-records" method="post" id="recordForm">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="appointmentId" value="${param.appointmentId}">
                <div class="row g-3">
                  <div class="col-12">
                    <label class="form-label-h">Triệu chứng <span class="required">*</span></label>
                    <textarea class="form-control-h" name="symptoms" id="symptoms" rows="3" placeholder="Mô tả triệu chứng bệnh nhân báo cáo...">${not empty medicalRecord ? medicalRecord.symptoms : ''}</textarea>
                  </div>
                  <div class="col-12">
                    <label class="form-label-h">Kết quả khám lâm sàng <span class="required">*</span></label>
                    <textarea class="form-control-h" name="clinicalFindings" id="clinical" rows="3" placeholder="Kết quả khám mắt, đo thị lực, nhãn áp..."></textarea>
                  </div>
                  <div class="col-12">
                    <label class="form-label-h">Chẩn đoán <span class="required">*</span></label>
                    <textarea class="form-control-h" name="diagnosis" id="diagnosis" rows="2" placeholder="Chẩn đoán bệnh lý...">${not empty medicalRecord ? medicalRecord.diagnosis : ''}</textarea>
                  </div>
                  <div class="col-12">
                    <label class="form-label-h">Phác đồ điều trị <span class="required">*</span></label>
                    <textarea class="form-control-h" name="treatment" id="treatment" rows="3" placeholder="Thuốc, liều dùng, thủ thuật, hướng dẫn...">${not empty medicalRecord ? medicalRecord.treatment : ''}</textarea>
                  </div>
                  <div class="col-12">
                    <label class="form-label-h">Ghi chú thêm</label>
                    <textarea class="form-control-h" name="note" id="notes" rows="2" placeholder="Lưu ý đặc biệt, hẹn tái khám...">${not empty medicalRecord ? medicalRecord.note : ''}</textarea>
                  </div>
                </div>
              </form>
            </div>
            <div class="card-footer-h" style="display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:10px">
              <a href="${pageContext.request.contextPath}/doctor/patients" class="btn-hospital btn-ghost-h btn-sm">
                <i class="fas fa-arrow-left"></i> Quay lại
              </a>
              <div style="display:flex;gap:10px">
                <button class="btn-hospital btn-outline-h" onclick="saveRecord()">
                  <i class="fas fa-save"></i> Lưu hồ sơ
                </button>
                <button class="btn-hospital btn-primary-h" onclick="openComplete()">
                  <i class="fas fa-circle-check"></i> Hoàn tất khám
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>

<!-- Complete confirm modal -->
<div class="confirm-overlay" id="completeOverlay">
  <div class="confirm-box">
    <div class="confirm-icon" style="color:var(--success)"><i class="fas fa-circle-check"></i></div>
    <h5>Hoàn tất buổi khám</h5>
    <p>Xác nhận hoàn tất khám. Hệ thống sẽ tự động tạo hóa đơn thanh toán.</p>
    <div class="confirm-actions">
      <button class="btn-hospital btn-ghost-h" onclick="closeComplete()">Hủy</button>
      <button class="btn-hospital btn-primary-h" onclick="confirmComplete()"><i class="fas fa-check"></i> Xác nhận</button>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/static/js/doctor-patient-record.js"></script>
</body>
</html>
