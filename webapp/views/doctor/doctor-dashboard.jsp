<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Dashboard Bac Si - BV Mat PTIT</title>

  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/doctor-dashboard.css" rel="stylesheet">
</head>
<body>
<div class="app-shell">
now
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
      <div class="nav-section-label">Lam sang</div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/doctor/schedule" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-calendar-week"></i></span>
          <span class="nav-label">Lich lam viec</span>
        </a>
      </div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/doctor/patients" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-users"></i></span>
          <span class="nav-label">Hang cho hom nay</span>
          <span class="nav-badge">${todayAppointments.size()}</span>
        </a>
      </div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/doctor/examination" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-stethoscope"></i></span>
          <span class="nav-label">Phong kham</span>
        </a>
      </div>
      <div class="nav-section-label">Ho so</div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/doctor/medical-records" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-file-medical"></i></span>
          <span class="nav-label">Benh an dien tu</span>
        </a>
      </div>
      <div class="nav-item">
        <a href="#" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-prescription"></i></span>
          <span class="nav-label">Don thuoc</span>
        </a>
      </div>
    </nav>

    <div class="sidebar-footer">
      <div class="sidebar-user">
        <div class="avatar avatar-md">${sessionScope.user.fullName.substring(0,2)}</div>
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
          <div style="font-size:12px;color:var(--text-muted)">
            Trang chu Bac Si
          </div>
        </div>
      </div>
      <div class="topbar-right">
        <button class="topbar-icon-btn">
          <i class="fas fa-bell"></i>
          <span class="notif-dot"></span>
        </button>
        <button class="topbar-user">
          <div class="avatar avatar-sm">${sessionScope.user.fullName.substring(0,2)}</div>
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
              <div class="value">${todayAppointments.size()}</div>
              <div class="trend" style="color:var(--text-muted);font-size:11px">Tong cong hom nay</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-xl-3">
          <div class="stat-card stat-green">
            <div class="stat-icon"><i class="fas fa-user-check"></i></div>
            <div class="stat-info">
              <div class="label">Da kham xong</div>
              <div class="value">${totalAppointments - pendingCount}</div>
              <div class="trend trend-up" style="font-size:11px">Da hoan thanh</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-xl-3">
          <div class="stat-card stat-orange">
            <div class="stat-icon"><i class="fas fa-hourglass-half"></i></div>
            <div class="stat-info">
              <div class="label">Dang cho</div>
              <div class="value">${pendingCount}</div>
              <div class="trend" style="color:var(--warning);font-size:11px">Benh nhan tiep theo</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-xl-3">
          <div class="stat-card stat-teal">
            <div class="stat-icon"><i class="fas fa-star"></i></div>
            <div class="stat-info">
              <div class="label">Tong lich kham</div>
              <div class="value">${totalAppointments}</div>
              <div class="trend trend-up" style="font-size:11px">Tat ca lich hen</div>
            </div>
          </div>
        </div>
      </div>

      <!-- Main grid -->
      <div class="row g-3">
        <!-- Queue / Today Schedule -->
        <div class="col-lg-4">
          <div class="card-hospital" style="height:100%">
            <div class="card-header-h">
              <div>
                <h5>Hang cho hom nay</h5>
                <p style="font-size:12px;color:var(--text-muted);margin:0">${todayAppointments.size()} benh nhan</p>
              </div>
              <span class="badge-h badge-warning">Dang kham</span>
            </div>
            <div class="card-body-h" style="padding:12px;max-height:480px;overflow-y:auto">
              <div class="d-flex flex-column gap-2">

                <c:forEach var="appt" items="${todayAppointments}" varStatus="loop">
                  <c:choose>
                    <c:when test="${appt.status == 'COMPLETED'}">
                      <div class="patient-item" style="opacity:0.55">
                        <div class="patient-num">${loop.count}</div>
                        <div class="avatar avatar-sm">${appt.patientId.substring(0,2)}</div>
                        <div class="flex-grow-1">
                          <div class="name" style="font-size:13px;font-weight:600">${appt.patientId}</div>
                          <div style="font-size:11px;color:var(--text-muted)">${appt.time}</div>
                        </div>
                        <span class="badge-h badge-success">Xong</span>
                      </div>
                    </c:when>
                    <c:when test="${appt.status == 'IN_PROGRESS'}">
                      <div class="patient-item selected">
                        <div class="patient-num active">${loop.count}</div>
                        <div class="avatar avatar-sm" style="background:var(--primary);color:#fff">${appt.patientId.substring(0,2)}</div>
                        <div class="flex-grow-1">
                          <div class="name" style="font-size:13px;font-weight:600">${appt.patientId}</div>
                          <div style="font-size:11px;color:var(--text-muted)">${appt.time}</div>
                        </div>
                        <span class="badge-h badge-warning">Dang kham</span>
                      </div>
                    </c:when>
                    <c:otherwise>
                      <div class="patient-item">
                        <div class="patient-num">${loop.count}</div>
                        <div class="avatar avatar-sm">${appt.patientId.substring(0,2)}</div>
                        <div class="flex-grow-1">
                          <div class="name" style="font-size:13px;font-weight:600">${appt.patientId}</div>
                          <div style="font-size:11px;color:var(--text-muted)">${appt.time}</div>
                        </div>
                        <span class="badge-h badge-gray" style="font-size:11px">${appt.time}</span>
                      </div>
                    </c:otherwise>
                  </c:choose>
                </c:forEach>

              </div>
            </div>
            <div class="card-footer-h">
              <div class="d-flex gap-2">
                <button class="btn-hospital btn-outline-h btn-sm flex-grow-1">
                  <i class="fas fa-arrow-left"></i> Truoc
                </button>
                <button class="btn-hospital btn-primary-h btn-sm flex-grow-1">
                  Goi tiep <i class="fas fa-arrow-right"></i>
                </button>
              </div>
            </div>
          </div>
        </div>

        <!-- Current Patient Examination Panel -->
        <div class="col-lg-8">
          <div class="card-hospital">
            <div class="card-header-h" style="background:var(--primary);border-radius:var(--radius-lg) var(--radius-lg) 0 0">
              <div style="display:flex;align-items:center;gap:12px">
                <div class="avatar avatar-md" style="background:rgba(255,255,255,0.20);color:#fff;font-size:15px">
                  <c:choose>
                    <c:when test="${not empty currentAppointment}">${currentAppointment.patientId.substring(0,2)}</c:when>
                    <c:otherwise>--</c:otherwise>
                  </c:choose>
                </div>
                <div>
                  <h5 style="color:#fff;margin:0">
                    <c:choose>
                      <c:when test="${not empty currentAppointment}">${currentAppointment.patientId}</c:when>
                      <c:otherwise>Khong co benh nhan</c:otherwise>
                    </c:choose>
                  </h5>
                  <p style="color:rgba(255,255,255,0.65);font-size:12px;margin:0">
                    <c:if test="${not empty currentAppointment}">
                      ${currentAppointment.appointmentId} · ${currentAppointment.time}
                    </c:if>
                  </p>
                </div>
              </div>
              <div class="d-flex gap-2">
                <button class="btn-hospital" style="background:rgba(255,255,255,0.15);color:#fff;border:1px solid rgba(255,255,255,0.20);font-size:12px">
                  <i class="fas fa-history"></i> Lich su
                </button>
                <button class="btn-hospital" style="background:rgba(255,255,255,0.15);color:#fff;border:1px solid rgba(255,255,255,0.20);font-size:12px">
                  <i class="fas fa-file-medical"></i> Ho so
                </button>
              </div>
            </div>

            <div class="card-body-h">
              <c:choose>
                <c:when test="${not empty currentAppointment}">
                  <!-- Examination form -->
                  <form action="${pageContext.request.contextPath}/doctor/examination" method="post">
                    <input type="hidden" name="appointmentId" value="${currentAppointment.appointmentId}">
                    <div class="row g-3">
                      <!-- Vital Signs -->
                      <div class="col-12">
                        <h6 style="font-size:13px;font-weight:600;color:var(--text-muted);text-transform:uppercase;letter-spacing:0.05em;margin-bottom:12px">
                          <i class="fas fa-eye" style="margin-right:6px;color:var(--primary-light)"></i>Ket qua thi luc
                        </h6>
                        <div class="row g-2">
                          <div class="col-6 col-sm-3">
                            <label class="form-label-h">Mat phai (khong kinh)</label>
                            <input type="text" class="form-control-h" name="rightEyeNoGlass" placeholder="20/200">
                          </div>
                          <div class="col-6 col-sm-3">
                            <label class="form-label-h">Mat trai (khong kinh)</label>
                            <input type="text" class="form-control-h" name="leftEyeNoGlass" placeholder="20/200">
                          </div>
                          <div class="col-6 col-sm-3">
                            <label class="form-label-h">Mat phai (co kinh)</label>
                            <input type="text" class="form-control-h" name="rightEyeWithGlass" placeholder="20/20">
                          </div>
                          <div class="col-6 col-sm-3">
                            <label class="form-label-h">Mat trai (co kinh)</label>
                            <input type="text" class="form-control-h" name="leftEyeWithGlass" placeholder="20/20">
                          </div>
                        </div>
                      </div>

                      <!-- Diagnosis -->
                      <div class="col-12">
                        <label class="form-label-h">
                          Chan doan <span class="required">*</span>
                        </label>
                        <input type="text" class="form-control-h" name="diagnosis" placeholder="Nhap chan doan...">
                      </div>

                      <!-- Clinical Notes -->
                      <div class="col-12">
                        <label class="form-label-h">Ghi chu lam sang</label>
                        <textarea class="form-control-h" rows="4" name="symptoms" placeholder="Nhap ghi chu kham benh..."></textarea>
                      </div>

                      <!-- Treatment -->
                      <div class="col-12">
                        <label class="form-label-h">Dieu tri</label>
                        <textarea class="form-control-h" rows="3" name="treatment" placeholder="Phac do dieu tri..."></textarea>
                      </div>

                      <!-- Note -->
                      <div class="col-12">
                        <label class="form-label-h">Ghi chu them</label>
                        <textarea class="form-control-h" rows="2" name="note" placeholder="Ghi chu bo sung..."></textarea>
                      </div>

                      <!-- Follow up -->
                      <div class="col-sm-6">
                        <label class="form-label-h">Ngay tai kham</label>
                        <input type="date" class="form-control-h" name="followUpDate">
                      </div>
                    </div>

                    <div class="card-footer-h" style="margin:12px -20px -20px;padding:16px 20px">
                      <div class="d-flex gap-2 justify-content-between">
                        <button type="button" class="btn-hospital btn-ghost-h">
                          <i class="fas fa-arrow-left"></i> Ve truoc
                        </button>
                        <div class="d-flex gap-2">
                          <button type="submit" class="btn-hospital btn-outline-h">
                            <i class="fas fa-floppy-disk"></i> Luu nhap
                          </button>
                          <button type="submit" name="action" value="complete" class="btn-hospital btn-primary-h">
                            <i class="fas fa-check-circle"></i> Hoan thanh kham
                          </button>
                        </div>
                      </div>
                    </div>
                  </form>
                </c:when>
                <c:otherwise>
                  <div style="text-align:center;padding:60px 20px;color:var(--text-muted)">
                    <i class="fas fa-clipboard-list" style="font-size:48px;margin-bottom:16px;opacity:0.3"></i>
                    <h5>Khong co benh nhan dang kham</h5>
                    <p>Vui long chon benh nhan tu hang cho hoac cho benh nhan tiep theo.</p>
                  </div>
                </c:otherwise>
              </c:choose>
            </div>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/static/js/doctor-dashboard.js"></script>
</body>
</html>
