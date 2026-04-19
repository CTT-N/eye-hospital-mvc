<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản lý phòng khám – BV Mắt PTIT</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  
  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
</head>
<body>
<div class="app-shell">
  <c:set var="activeManagerNav" value="rooms" />
  <%@ include file="_sidebar.jspf" %>

  <main class="main-content">
    <header class="topbar">
      <div class="topbar-left">
        <button class="topbar-icon-btn" id="sidebarToggle"><i class="fas fa-bars"></i></button>
        <div><div class="topbar-title">Quản lý phòng khám</div><div style="font-size:12px;color:var(--text-muted)">Thêm, sửa, xóa phòng khám</div></div>
      </div>
      <div class="topbar-right">
        <button class="btn-hospital btn-primary-h btn-sm" onclick="openModal()">
          <i class="fas fa-plus"></i> Thêm phòng
        </button>
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
      <div class="card-hospital">
        <div class="card-header-h">
          <h5>Danh sách phòng khám (<span id="roomCount">${not empty listRooms ? listRooms.size() : 0}</span>)</h5>
          <div class="search-box">
            <span class="search-icon"><i class="fas fa-search"></i></span>
            <input class="form-control-h btn-sm" placeholder="Tìm phòng..." id="searchInput" oninput="filterTable(this.value)">
          </div>
        </div>
        <div class="card-body-h" style="padding:0">
          <table class="data-table" id="roomTable">
            <thead>
              <tr><th>Mã</th><th>Tên phòng</th><th>Chuyên khoa</th><th>Mô tả</th><th class="action-cell">Thao tác</th></tr>
            </thead>
            <tbody id="roomBody">
<c:forEach var="room" items="${listRooms}">
<tr>
  <td>${room.roomId}</td>
  <td>${room.roomName}</td>
  <td>${room.departmentId}</td>
  <td>${room.description}</td>
  <td>
    <button class="btn-hospital btn-sm" onclick="editRoom('${room.roomId}','${room.roomName}','${room.departmentId}','${room.description}')"><i class="fas fa-edit"></i></button>
    <button class="btn-hospital btn-danger-h btn-sm" onclick="deleteRoom('${room.roomId}','${room.roomName}')"><i class="fas fa-trash"></i></button>
  </td>
</tr>
</c:forEach>
</tbody>
          </table>
        </div>
      </div>
    </div>
  </main>
</div>

<!-- Add/Edit Modal -->
<div class="modal-overlay" id="roomModal">
  <div class="modal-box">
    <div class="modal-head">
      <h5 id="modalTitle">Thêm phòng khám</h5>
      <button class="modal-close" onclick="closeModal()"><i class="fas fa-times"></i></button>
    </div>
    <form action="${pageContext.request.contextPath}/manager/rooms" method="post">
      <input type="hidden" name="action" id="formAction" value="add">
      <input type="hidden" name="roomId" id="editRoomId" value="">
      <div class="modal-body">
        <div class="form-group-h">
          <label class="form-label-h">Tên phòng <span class="required">*</span></label>
          <input class="form-control-h" id="roomName" name="roomName" placeholder="VD: Phòng 101">
          <div id="nameError" style="font-size:12px;color:var(--danger);margin-top:4px;display:none">Tên phòng không được để trống</div>
        </div>
        <div class="form-group-h">
          <label class="form-label-h">Chuyên khoa <span class="required">*</span></label>
          <select class="form-control-h" id="roomDept" name="departmentId">
            <option value="">-- Chọn chuyên khoa --</option>
            <c:forEach var="dept" items="${listDepartments}">
              <option value="${dept.departmentId}">${dept.departmentName}</option>
            </c:forEach>
          </select>
        </div>
        <div class="form-group-h">
          <label class="form-label-h">Mô tả</label>
          <textarea class="form-control-h" id="roomDesc" name="description" rows="2" placeholder="Mô tả ngắn..."></textarea>
        </div>
      </div>
      <div class="modal-foot">
        <button type="button" class="btn-hospital btn-ghost-h" onclick="closeModal()">Hủy</button>
        <button type="submit" class="btn-hospital btn-primary-h"><i class="fas fa-check"></i> Lưu</button>
      </div>
    </form>
  </div>
</div>

<!-- Delete confirm -->
<div class="confirm-overlay" id="deleteOverlay">
  <div class="confirm-box">
    <div class="confirm-icon" style="color:var(--danger)"><i class="fas fa-trash"></i></div>
    <h5>Xóa phòng khám</h5>
    <p>Bạn có chắc muốn xóa <strong id="deleteTargetName"></strong>?</p>
    <div class="confirm-actions">
      <form action="${pageContext.request.contextPath}/manager/rooms" method="post" id="deleteForm">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="roomId" id="deleteRoomId" value="">
        <button type="button" class="btn-hospital btn-ghost-h" onclick="closeDelete()">Hủy</button>
        <button type="submit" class="btn-hospital btn-danger-h">Xóa</button>
      </form>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/static/js/manager-rooms.js"></script>
</body>
</html>
