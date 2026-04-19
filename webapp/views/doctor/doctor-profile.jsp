<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Ho so bac si - BV Mat PTIT</title>
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
      <div class="brand-text">BV Mat PTIT<small>Cong Bac Si</small></div>
    </a>
    <nav class="sidebar-nav">
      <div class="nav-item"><a href="${pageContext.request.contextPath}/doctor/dashboard" class="nav-link-h"><span class="nav-icon"><i class="fas fa-house"></i></span><span class="nav-label">Tong quan</span></a></div>
      <div class="nav-section-label">Lich kham</div>
      <div class="nav-item"><a href="${pageContext.request.contextPath}/doctor/schedule" class="nav-link-h"><span class="nav-icon"><i class="fas fa-calendar-days"></i></span><span class="nav-label">Lich theo ngay</span></a></div>
      <div class="nav-item"><a href="${pageContext.request.contextPath}/doctor/patients" class="nav-link-h"><span class="nav-icon"><i class="fas fa-users"></i></span><span class="nav-label">Danh sach benh nhan</span></a></div>
      <div class="nav-section-label">Tai khoan</div>
      <div class="nav-item"><a href="${pageContext.request.contextPath}/doctor/profile" class="nav-link-h active"><span class="nav-icon"><i class="fas fa-user-doctor"></i></span><span class="nav-label">Ho so bac si</span></a></div>
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
        <div><div class="topbar-title">Ho so bac si</div></div>
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
      <c:if test="${param.msg == 'updated'}">
        <div class="alert alert-success" style="margin-bottom:16px">Cap nhat thong tin thanh cong!</div>
      </c:if>
      <c:if test="${param.msg == 'password_changed'}">
        <div class="alert alert-success" style="margin-bottom:16px">Doi mat khau thanh cong!</div>
      </c:if>

      <div class="tab-nav-h">
        <button class="tab-btn active" onclick="switchTab(this,'tabInfo')"><i class="fas fa-id-badge" style="margin-right:6px"></i>Thong tin nghe nghiep</button>
        <button class="tab-btn" onclick="switchTab(this,'tabPassword')"><i class="fas fa-lock" style="margin-right:6px"></i>Doi mat khau</button>
      </div>

      <div class="tab-pane-h active" id="tabInfo">
        <div class="card-hospital" style="max-width:700px">
          <div class="card-header-h">
            <h5>Thong tin bac si</h5>
            <button class="btn-hospital btn-outline-h btn-sm" id="editToggle" onclick="toggleEdit()"><i class="fas fa-pen"></i> Chinh sua</button>
          </div>
          <div class="card-body-h">
            <div style="display:flex;align-items:center;gap:16px;margin-bottom:20px;padding-bottom:20px;border-bottom:1px solid var(--border)">
              <div class="avatar" style="width:72px;height:72px;font-size:24px;background:var(--primary-light)"><c:choose><c:when test="${fn:length(sessionScope.user.fullName) >= 2}">${fn:substring(sessionScope.user.fullName, 0, 2)}</c:when><c:when test="${fn:length(sessionScope.user.fullName) == 1}">${fn:substring(sessionScope.user.fullName, 0, 1)}</c:when><c:otherwise>?</c:otherwise></c:choose></div>
              <div>
                <div style="font-size:var(--font-xl);font-weight:700">${sessionScope.user.fullName}</div>
                <div style="font-size:var(--font-sm);color:var(--text-muted)">${not empty doctor ? doctor.educationDegree : 'Bac si'}</div>
              </div>
            </div>
            <form action="${pageContext.request.contextPath}/doctor/profile" method="post" id="profileForm">
              <div class="row g-3">
                <div class="col-md-6">
                  <label class="form-label-h">Chuyen khoa</label>
                  <select class="form-control-h" id="specialty" name="departmentId" disabled>
                    <c:forEach var="dept" items="${departments}">
                      <option value="${dept.departmentId}" ${not empty doctor && doctor.departmentId == dept.departmentId ? 'selected' : ''}>${dept.departmentName}</option>
                    </c:forEach>
                  </select>
                </div>
                <div class="col-md-6">
                  <label class="form-label-h">Hoc ham / Hoc vi</label>
                  <input class="form-control-h" id="degree" name="educationDegree" value="${not empty doctor ? doctor.educationDegree : ''}" disabled>
                </div>
                <div class="col-md-6">
                  <label class="form-label-h">So dien thoai</label>
                  <input class="form-control-h" name="phone" id="phone" value="${sessionScope.user.phone}" disabled>
                </div>
                <div class="col-md-6">
                  <label class="form-label-h">Email</label>
                  <input class="form-control-h" name="email" id="email" value="${sessionScope.user.email}" disabled>
                </div>
                <div class="col-12">
                  <label class="form-label-h">Kinh nghiem</label>
                  <input class="form-control-h" name="experience" id="experience" value="${not empty doctor ? doctor.experience : ''}" disabled>
                </div>
                <div class="col-12">
                  <label class="form-label-h">Gioi thieu ban than</label>
                  <textarea class="form-control-h" name="description" id="bio" rows="4" disabled>${not empty doctor ? doctor.description : ''}</textarea>
                </div>
              </div>
              <input type="hidden" name="fullName" value="${sessionScope.user.fullName}">
            </form>
          </div>
          <div class="card-footer-h" id="saveFooter" style="display:none">
            <button class="btn-hospital btn-ghost-h btn-sm" onclick="cancelEdit()">Huy</button>
            <button class="btn-hospital btn-primary-h btn-sm" onclick="document.getElementById('profileForm').submit()"><i class="fas fa-check"></i> Luu thay doi</button>
          </div>
        </div>
      </div>

      <div class="tab-pane-h" id="tabPassword">
        <div class="card-hospital" style="max-width:500px">
          <div class="card-header-h"><h5>Doi mat khau</h5></div>
          <div class="card-body-h">
            <form action="${pageContext.request.contextPath}/auth/change-password" method="post">
              <div class="form-group-h">
                <label class="form-label-h">Mat khau hien tai <span class="required">*</span></label>
                <input class="form-control-h" type="password" name="currentPassword" id="oldPwd" placeholder="Nhap mat khau hien tai">
              </div>
              <div class="form-group-h">
                <label class="form-label-h">Mat khau moi <span class="required">*</span></label>
                <input class="form-control-h" type="password" name="newPassword" id="newPwd" placeholder="Toi thieu 8 ky tu">
              </div>
              <div class="form-group-h">
                <label class="form-label-h">Xac nhan mat khau moi <span class="required">*</span></label>
                <input class="form-control-h" type="password" name="confirmPassword" id="confirmPwd" placeholder="Nhap lai mat khau moi">
                <div id="matchHint" style="font-size:12px;margin-top:4px"></div>
              </div>
              <button type="submit" class="btn-hospital btn-primary-h"><i class="fas fa-shield-halved"></i> Cap nhat mat khau</button>
            </form>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>

<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/static/js/doctor-profile.js"></script>
</body>
</html>
