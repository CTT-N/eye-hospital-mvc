<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bệnh mắt – BV Mắt PTIT</title>
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

  <aside class="sidebar" style="background:#0F1C2E">
    <a href="" class="sidebar-brand">
      <div class="brand-logo" style="background:rgba(220,38,38,0.25)"><svg viewBox="0 0 24 24" style="width:18px;height:18px;fill:#fff" xmlns="http://www.w3.org/2000/svg"><path d="M12 1L3 5v6c0 5.25 3.83 10.15 9 11.32C17.17 21.15 21 16.25 21 11V5L12 1zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/></svg></div>
      <div class="brand-text">BV Mắt PTIT<small>Admin Panel</small></div>
    </a>
    <nav class="sidebar-nav">
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-gauge-high"></i></span>
          <span class="nav-label">Tổng quan</span>
        </a>
      </div>
      <div class="nav-section-label">Người dùng</div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/admin/users" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-users"></i></span>
          <span class="nav-label">Quản lý người dùng</span>
        </a>
      </div>
      <div class="nav-item">
        <a href="#" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-shield-halved"></i></span>
          <span class="nav-label">Phân quyền</span>
        </a>
      </div>
      <div class="nav-section-label">Danh mục</div>
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/admin/diseases" class="nav-link-h active">
          <span class="nav-icon"><i class="fas fa-eye"></i></span>
          <span class="nav-label">Danh mục bệnh mắt</span>
        </a>
      </div>
      <div class="nav-item">
        <a href="#" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-syringe"></i></span>
          <span class="nav-label">Danh mục dịch vụ</span>
        </a>
      </div>
      <div class="nav-section-label">Hệ thống</div>
      <div class="nav-item">
        <a href="#" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-cog"></i></span>
          <span class="nav-label">Cài đặt hệ thống</span>
        </a>
      </div>
      <div class="nav-item">
        <a href="#" class="nav-link-h">
          <span class="nav-icon"><i class="fas fa-clipboard-list"></i></span>
          <span class="nav-label">Nhật ký hoạt động</span>
        </a>
      </div>
    </nav>
    <div class="sidebar-footer">
      <div class="sidebar-user">
        <div class="avatar avatar-md" style="background:rgba(220,38,38,0.3);color:#FCA5A5">AD</div>
        <div class="user-info">
          <div class="user-name">${sessionScope.user.fullName}</div>
          <div class="user-role">Quản trị hệ thống</div>
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
        <div><div class="topbar-title">Danh mục bệnh mắt</div><div style="font-size:12px;color:var(--text-muted)">Quản lý thông tin bệnh lý nhãn khoa</div></div>
      </div>
      <div class="topbar-right">
        <button class="btn-hospital btn-primary-h btn-sm" onclick="openModal()">
          <i class="fas fa-plus"></i> Thêm bệnh
        </button>
        <button class="topbar-icon-btn">
          <i class="fas fa-bell"></i><span class="notif-dot"></span>
        </button>
        <button class="topbar-user">
          <div class="avatar avatar-sm" style="background:#FEE2E2;color:var(--danger)">AD</div>
          <div class="user-details d-none d-md-block">
            <span class="user-name">${sessionScope.user.fullName}</span>
            <span class="user-role">Administrator</span>
          </div>
        </button>
      </div>
    </header>

    <div class="content-area">
      <div class="filter-bar">
        <div class="search-box" style="flex:1;max-width:280px">
          <span class="search-icon"><i class="fas fa-search"></i></span>
          <input class="form-control-h btn-sm" placeholder="Tìm tên bệnh, mã ICD..." id="searchInput" oninput="applyFilters()">
        </div>
        <select class="filter-select" id="filterCat" onchange="applyFilters()">
          <option value="">Tất cả nhóm</option>
          <option>Giác mạc</option><option>Võng mạc</option><option>Thủy tinh thể</option>
          <option>Nhãn áp</option><option>Tật khúc xạ</option><option>Khác</option>
        </select>
      </div>

      <div class="card-hospital">
        <div class="card-body-h" style="padding:0">
          <div style="overflow-x:auto">
            <table class="data-table" id="diseaseTable">
              <thead>
                <tr><th>Mã ICD</th><th>Tên bệnh</th><th>Nhóm bệnh</th><th>Mô tả ngắn</th><th class="action-cell">Thao tác</th></tr>
              </thead>
              <tbody id="diseaseBody">
<c:forEach var="d" items="${listInfos}">
<tr>
  <td>${d.infoId}</td>
  <td>${d.diseaseName}</td>
  <td>${d.content}</td>
  <td>${d.description}</td>
  <td>
    <button class="btn-hospital btn-sm" onclick="editDisease('${d.infoId}','${d.diseaseName}','${d.content}','${d.description}')"><i class="fas fa-edit"></i></button>
    <button class="btn-hospital btn-danger-h btn-sm" onclick="deleteDisease('${d.infoId}','${d.diseaseName}')"><i class="fas fa-trash"></i></button>
  </td>
</tr>
</c:forEach>
</tbody>
            </table>
          </div>
        </div>
      </div>
    </div>
  </main>
</div>

<!-- Add/Edit Modal -->
<div class="modal-overlay" id="diseaseModal">
  <div class="modal-box" style="max-width:680px">
    <div class="modal-head">
      <h5 id="modalTitle">Thêm bệnh mắt</h5>
      <button class="modal-close" onclick="closeModal()"><i class="fas fa-times"></i></button>
    </div>
    <div class="modal-body">
      <input type="hidden" id="editIndex">
      <div class="row g-3">
        <div class="col-md-4">
          <label class="form-label-h">Mã ICD <span class="required">*</span></label>
          <input class="form-control-h" id="dCode" placeholder="VD: H16.0">
        </div>
        <div class="col-md-8">
          <label class="form-label-h">Tên bệnh <span class="required">*</span></label>
          <input class="form-control-h" id="dName" placeholder="VD: Viêm giác mạc trung tâm">
        </div>
        <div class="col-md-6">
          <label class="form-label-h">Nhóm bệnh <span class="required">*</span></label>
          <select class="form-control-h" id="dCat">
            <option value="">-- Chọn nhóm --</option>
            <option>Giác mạc</option><option>Võng mạc</option><option>Thủy tinh thể</option>
            <option>Nhãn áp</option><option>Tật khúc xạ</option><option>Khác</option>
          </select>
        </div>
        <div class="col-md-6">
          <label class="form-label-h">Mô tả ngắn</label>
          <input class="form-control-h" id="dDesc" placeholder="Tóm tắt bệnh lý...">
        </div>
        <div class="col-12">
          <label class="form-label-h">Triệu chứng</label>
          <textarea class="form-control-h" id="dSymptoms" rows="3" placeholder="Liệt kê các triệu chứng thường gặp..."></textarea>
        </div>
        <div class="col-12">
          <label class="form-label-h">Phác đồ điều trị thường dùng</label>
          <textarea class="form-control-h" id="dTreatment" rows="3" placeholder="Các phương pháp điều trị phổ biến..."></textarea>
        </div>
      </div>
      <div id="formError" style="font-size:12px;color:var(--danger);margin-top:10px;display:none">Vui lòng điền đầy đủ thông tin bắt buộc.</div>
    </div>
    <div class="modal-foot">
      <button class="btn-hospital btn-ghost-h" onclick="closeModal()">Hủy</button>
      <button class="btn-hospital btn-primary-h" onclick="saveDisease()"><i class="fas fa-check"></i> Lưu</button>
    </div>
  </div>
</div>

<!-- Delete confirm -->
<div class="confirm-overlay" id="deleteOverlay">
  <div class="confirm-box">
    <div class="confirm-icon" style="color:var(--danger)"><i class="fas fa-trash"></i></div>
    <h5>Xóa bệnh</h5>
    <p>Bạn có chắc muốn xóa <strong id="deleteTargetName"></strong> khỏi danh mục?</p>
    <div class="confirm-actions">
      <button class="btn-hospital btn-ghost-h" onclick="closeDelete()">Hủy</button>
      <button class="btn-hospital btn-danger-h" onclick="confirmDelete()">Xóa</button>
    </div>
  </div>
</div>

<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/static/js/admin-eye-diseases.js"></script>
</body>
</html>
