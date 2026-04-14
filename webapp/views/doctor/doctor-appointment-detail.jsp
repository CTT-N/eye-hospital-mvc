<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Chi tiet lich hen - BV Mat PTIT</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  
  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/doctor-appointment-detail.css" rel="stylesheet">
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
          <div class="topbar-title">Chi tiet lich hen</div>
          <div style="font-size:12px;color:var(--text-muted)">Thong tin chi tiet buoi kham</div>
        </div>
      </div>
      <div class="topbar-right">
        <button class="topbar-icon-btn"><i class="fas fa-bell"></i><span class="notif-dot"></span></button>
        <button class="topbar-user">
          <div class="avatar avatar-sm" style="background:var(--primary-light)"><c:choose><c:when test="${fn:length(sessionScope.user.fullName) >= 2}">${fn:substring(sessionScope.user.fullName, 0, 2)}</c:when><c:when test="${fn:length(sessionScope.user.fullName) == 1}">${fn:substring(sessionScope.user.fullName, 0, 1)}</c:when><c:otherwise>?</c:otherwise></c:choose></div>
          <div class="user-details d-none d-md-block"><span class="user-name">${sessionScope.user.fullName}</span><span class="user-role">Bac si</span></div>
        </button>
      </div>
    </header>

    <div class="content-area">
      <!-- Breadcrumb -->
      <div class="breadcrumb-h">
        <a href="${pageContext.request.contextPath}/doctor/schedule">Lich theo ngay</a>
        <span class="sep"><i class="fas fa-chevron-right"></i></span>
        <span class="current">Chi tiet lich hen</span>
      </div>

      <div class="row g-4">
        <!-- Left: appointment info -->
        <div class="col-lg-6">
          <div class="card-hospital">
            <div class="card-header-h">
              <h5><i class="fas fa-calendar-check" style="color:var(--primary);margin-right:8px"></i>Thong tin lich hen</h5>
              <span class="badge-status badge-${not empty appointment ? appointment.status.toLowerCase() : 'pending'}">${not empty appointment ? appointment.status : 'N/A'}</span>
            </div>
            <div class="card-body-h">
              <div class="info-grid">
                <div class="info-field">
                  <div class="lbl">Ngay kham</div>
                  <div class="val">${not empty appointment ? appointment.date : 'N/A'}</div>
                </div>
                <div class="info-field">
                  <div class="lbl">Gio kham</div>
                  <div class="val">${not empty appointment ? appointment.time : 'N/A'}</div>
                </div>
                <div class="info-field">
                  <div class="lbl">Phong kham</div>
                  <div class="val"><i class="fas fa-door-open" style="margin-right:4px;color:var(--text-muted)"></i>Phong ${not empty appointment ? appointment.roomId : 'N/A'}</div>
                </div>
                <div class="info-field">
                  <div class="lbl">Ma lich hen</div>
                  <div class="val">${not empty appointment ? appointment.appointmentId : 'N/A'}</div>
                </div>
              </div>
            </div>
            <div class="card-footer-h" style="display:flex;gap:10px;justify-content:flex-end">
              <a href="${pageContext.request.contextPath}/doctor/patients" class="btn-hospital btn-outline-h btn-sm">
                <i class="fas fa-users"></i> Danh sach BN
              </a>
              <a href="${pageContext.request.contextPath}/doctor/examination?appointmentId=${not empty appointment ? appointment.appointmentId : ''}" class="btn-hospital btn-primary-h btn-sm">
                <i class="fas fa-notes-medical"></i> Cap nhat ho so
              </a>
            </div>
          </div>
        </div>

        <!-- Right: patient info -->
        <div class="col-lg-6">
          <div class="card-hospital">
            <div class="card-header-h">
              <h5><i class="fas fa-user" style="color:var(--primary);margin-right:8px"></i>Thong tin benh nhan</h5>
            </div>
            <div class="card-body-h">
              <div style="display:flex;align-items:center;gap:14px;margin-bottom:18px">
                <div class="avatar avatar-lg" style="width:52px;height:52px;font-size:18px">${not empty appointment ? appointment.patientId.substring(0,2) : '--'}</div>
                <div>
                  <div style="font-weight:700;font-size:var(--font-md)">${not empty appointment ? appointment.patientId : 'N/A'}</div>
                  <div style="font-size:12px;color:var(--text-muted)">${not empty appointment ? appointment.patientId : ''}</div>
                </div>
              </div>

              <c:if test="${not empty medicalRecord}">
              <div style="margin-top:16px;padding-top:16px;border-top:1px solid var(--border)">
                <h6 style="font-size:13px;font-weight:600;margin-bottom:12px">Ket qua kham</h6>
                <div class="info-grid">
                  <div class="info-field col-span-2">
                    <div class="lbl">Chan doan</div>
                    <div class="val">${medicalRecord.diagnosis}</div>
                  </div>
                  <div class="info-field col-span-2">
                    <div class="lbl">Trieu chung</div>
                    <div class="val">${medicalRecord.symptoms}</div>
                  </div>
                  <div class="info-field col-span-2">
                    <div class="lbl">Dieu tri</div>
                    <div class="val">${medicalRecord.treatment}</div>
                  </div>
                  <c:if test="${not empty medicalRecord.note}">
                  <div class="info-field col-span-2">
                    <div class="lbl">Ghi chu</div>
                    <div class="val">${medicalRecord.note}</div>
                  </div>
                  </c:if>
                </div>
              </div>
              </c:if>
            </div>
          </div>
        </div>

        <!-- Medical Record Form -->
        <div class="col-lg-12">
          <div class="card-hospital">
            <div class="card-header-h">
              <h5><i class="fas fa-notes-medical" style="color:var(--primary);margin-right:8px"></i>
                <c:choose>
                  <c:when test="${not empty medicalRecord}">Cập nhật hồ sơ bệnh án</c:when>
                  <c:otherwise>Nhập hồ sơ bệnh án</c:otherwise>
                </c:choose>
              </h5>
            </div>
            <div class="card-body-h">
              <form action="${pageContext.request.contextPath}/doctor/examination" method="post">
                <input type="hidden" name="appointmentId" value="${not empty appointment ? appointment.appointmentId : ''}">
                <div class="row g-3">
                  <div class="col-md-6">
                    <label class="form-label" style="font-size:13px;font-weight:600">Triệu chứng *</label>
                    <textarea name="symptoms" class="form-control" rows="3" required
                      placeholder="Mô tả triệu chứng bệnh nhân">${not empty medicalRecord ? medicalRecord.symptoms : ''}</textarea>
                  </div>
                  <div class="col-md-6">
                    <label class="form-label" style="font-size:13px;font-weight:600">Chẩn đoán *</label>
                    <textarea name="diagnosis" class="form-control" rows="3" required
                      placeholder="Chẩn đoán bệnh">${not empty medicalRecord ? medicalRecord.diagnosis : ''}</textarea>
                  </div>
                  <div class="col-md-6">
                    <label class="form-label" style="font-size:13px;font-weight:600">Phác đồ điều trị *</label>
                    <textarea name="treatment" class="form-control" rows="3" required
                      placeholder="Phương pháp điều trị">${not empty medicalRecord ? medicalRecord.treatment : ''}</textarea>
                  </div>
                  <div class="col-md-6">
                    <label class="form-label" style="font-size:13px;font-weight:600">Ghi chú</label>
                    <textarea name="note" class="form-control" rows="3"
                      placeholder="Ghi chú thêm (nếu có)">${not empty medicalRecord ? medicalRecord.note : ''}</textarea>
                  </div>
                </div>
                <div style="margin-top:16px;display:flex;gap:10px;justify-content:flex-end">
                  <a href="${pageContext.request.contextPath}/doctor/schedule" class="btn-hospital btn-outline-h btn-sm">Hủy</a>
                  <button type="submit" class="btn-hospital btn-primary-h btn-sm">
                    <i class="fas fa-save"></i>
                    <c:choose>
                      <c:when test="${not empty medicalRecord}">Cập nhật</c:when>
                      <c:otherwise>Lưu hồ sơ</c:otherwise>
                    </c:choose>
                  </button>
                </div>
              </form>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>

<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
</body>
</html>
