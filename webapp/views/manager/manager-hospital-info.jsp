<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Thông tin bệnh viện – BV Mắt PTIT</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  
  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
</head>
<body>
<div class="app-shell">
  <c:set var="activeManagerNav" value="hospital" />
  <%@ include file="_sidebar.jspf" %>

  <main class="main-content">
    <header class="topbar">
      <div class="topbar-left">
        <button class="topbar-icon-btn" id="sidebarToggle"><i class="fas fa-bars"></i></button>
        <div><div class="topbar-title">Thông tin bệnh viện</div><div style="font-size:12px;color:var(--text-muted)">Cập nhật thông tin giới thiệu</div></div>
      </div>
      <div class="topbar-right">
        <button class="btn-hospital btn-outline-h btn-sm" id="editToggle" onclick="toggleEdit()"><i class="fas fa-pen"></i> Chỉnh sửa</button>
        <button class="topbar-icon-btn">
          <i class="fas fa-bell"></i>
          <span class="notif-dot"></span>
        </button>
        <button class="topbar-user">
          <div class="avatar avatar-sm">QT</div>
          <div class="user-details d-none d-md-block">
            <span class="user-name">${sessionScope.user.fullName}</span>
            <span class="user-role">Manager</span>
          </div>
          <i class="fas fa-chevron-down" style="font-size:11px;color:var(--text-muted)"></i>
        </button>
      </div>
    </header>

    <div class="content-area">
      <div class="card-hospital" style="max-width:800px">
        <div class="card-header-h">
          <h5><i class="fas fa-building" style="color:var(--primary);margin-right:8px"></i>Thông tin bệnh viện</h5>
        </div>
        <form action="${pageContext.request.contextPath}/manager/hospital" method="post">
          <input type="hidden" name="hospitalId" value="${hospital.hospitalId}">
          <div class="card-body-h">
            <div class="row g-3">
              <div class="col-12">
                <label class="form-label-h">Tên bệnh viện <span class="required">*</span></label>
                <input class="form-control-h" id="hospName" name="hospitalName" value="${hospital.hospitalName}" disabled>
              </div>
              <div class="col-12">
                <label class="form-label-h">Địa chỉ <span class="required">*</span></label>
                <input class="form-control-h" id="hospAddress" name="address" value="${hospital.address}" disabled>
              </div>
              <div class="col-12">
                <label class="form-label-h">Giới thiệu bệnh viện</label>
                <textarea class="form-control-h" id="hospDesc" name="description" rows="5" disabled>${hospital.description}</textarea>
              </div>
            </div>
          </div>
          <div class="card-footer-h" id="saveFooter" style="display:none">
            <button type="button" class="btn-hospital btn-ghost-h btn-sm" onclick="cancelEdit()">Hủy</button>
            <button type="submit" class="btn-hospital btn-primary-h btn-sm"><i class="fas fa-check"></i> Lưu thay đổi</button>
          </div>
        </form>
      </div>
    </div>
  </main>
</div>

<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/static/js/manager-hospital-info.js"></script>
</body>
</html>
