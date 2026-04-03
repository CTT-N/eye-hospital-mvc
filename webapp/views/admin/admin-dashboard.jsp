<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin Panel – BV Mắt PTIT</title>
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
  <aside class="sidebar" style="background:#0F1C2E">
    <a href="" class="sidebar-brand">
      <div class="brand-logo" style="background:rgba(220,38,38,0.25)"><svg viewBox="0 0 24 24" style="width:18px;height:18px;fill:#fff" xmlns="http://www.w3.org/2000/svg"><path d="M12 1L3 5v6c0 5.25 3.83 10.15 9 11.32C17.17 21.15 21 16.25 21 11V5L12 1zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/></svg></div>
      <div class="brand-text">BV Mắt PTIT<small>Admin Panel</small></div>
    </a>
    <nav class="sidebar-nav">
      <div class="nav-item">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-link-h active">
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
        <a href="${pageContext.request.contextPath}/admin/diseases" class="nav-link-h">
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
        <div>
          <div class="topbar-title">Admin Panel</div>
          <div style="font-size:12px;color:var(--text-muted)">Quản trị hệ thống – Toàn quyền</div>
        </div>
      </div>
      <div class="topbar-right">
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

    <div class="page-content">
      <!-- Stats -->
      <div class="row g-3 mb-4">
        <div class="col-6 col-xl-3">
          <div class="stat-card stat-blue">
            <div class="stat-icon"><i class="fas fa-users"></i></div>
            <div class="stat-info">
              <div class="label">Tổng người dùng</div>
              <div class="value">${userCount}</div>
              <div class="trend trend-up" style="font-size:11px">+24 tuần này</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-xl-3">
          <div class="stat-card stat-green">
            <div class="stat-icon"><i class="fas fa-user-injured"></i></div>
            <div class="stat-info">
              <div class="label">Bệnh nhân</div>
              <div class="value">${patientCount}</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-xl-3">
          <div class="stat-card stat-orange">
            <div class="stat-icon"><i class="fas fa-user-doctor"></i></div>
            <div class="stat-info">
              <div class="label">Bác sĩ & Nhân viên</div>
              <div class="value">${doctorCount}</div>
            </div>
          </div>
        </div>
        <div class="col-6 col-xl-3">
          <div class="stat-card stat-red">
            <div class="stat-icon" style="background:#FEE2E2;color:var(--danger)"><i class="fas fa-ban"></i></div>
            <div class="stat-info">
              <div class="label">Tài khoản khóa</div>
              <div class="value">3</div>
              <div class="trend" style="color:var(--danger);font-size:11px">Cần xử lý</div>
            </div>
          </div>
        </div>
      </div>

      <!-- User Management Table -->
      <div class="card-hospital mb-4">
        <div class="card-header-h">
          <div>
            <h5>Quản Lý Người Dùng</h5>
            <p style="font-size:12px;color:var(--text-muted);margin:0">${userCount} tài khoản trong hệ thống</p>
          </div>
          <div class="d-flex gap-2 flex-wrap">
            <div class="search-box" style="width:240px">
              <i class="fas fa-search search-icon"></i>
              <input type="text" class="form-control-h" placeholder="Tìm người dùng..." style="padding-left:36px">
            </div>
            <select class="form-control-h" style="width:140px">
              <option>Tất cả vai trò</option>
              <option>Bệnh nhân</option>
              <option>Bác sĩ</option>
              <option>Admin</option>
              <option>Manager</option>
            </select>
            <button class="btn-hospital btn-primary-h">
              <i class="fas fa-plus"></i> Thêm user
            </button>
          </div>
        </div>
        <div class="card-body-h" style="padding:0">
          <table class="table-hospital">
            <thead>
              <tr>
                <th><input type="checkbox" style="accent-color:var(--primary-light)"></th>
                <th>Người dùng</th>
                <th>Vai trò</th>
                <th>Email</th>
                <th>Ngày tạo</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><input type="checkbox" style="accent-color:var(--primary-light)"></td>
                <td>
                  <div class="d-flex align-items-center gap-2">
                    <div class="avatar avatar-sm">VA</div>
                    <div>
                      <div style="font-size:13px;font-weight:600">Nguyễn Văn An</div>
                      <div style="font-size:11px;color:var(--text-muted)">ID: U-00001</div>
                    </div>
                  </div>
                </td>
                <td><span class="badge-h badge-gray">Bệnh nhân</span></td>
                <td style="font-size:13px">nguyenvanan@email.com</td>
                <td style="font-size:13px">10/01/2024</td>
                <td><span class="badge-h badge-success">Hoạt động</span></td>
                <td>
                  <div class="d-flex gap-1">
                    <button class="topbar-icon-btn" title="Xem chi tiết"><i class="fas fa-eye" style="font-size:13px"></i></button>
                    <button class="topbar-icon-btn" title="Chỉnh sửa"><i class="fas fa-pen" style="font-size:13px;color:var(--primary-light)"></i></button>
                    <button class="topbar-icon-btn" title="Khóa tài khoản"><i class="fas fa-lock" style="font-size:13px;color:var(--warning)"></i></button>
                  </div>
                </td>
              </tr>
              <tr>
                <td><input type="checkbox" style="accent-color:var(--primary-light)"></td>
                <td>
                  <div class="d-flex align-items-center gap-2">
                    <div class="avatar avatar-sm">MT</div>
                    <div>
                      <div style="font-size:13px;font-weight:600">Nguyễn Minh Tuấn</div>
                      <div style="font-size:11px;color:var(--text-muted)">ID: D-00012</div>
                    </div>
                  </div>
                </td>
                <td><span class="badge-h badge-info">Bác sĩ</span></td>
                <td style="font-size:13px">drminhtuab@bvmat.vn</td>
                <td style="font-size:13px">05/09/2023</td>
                <td><span class="badge-h badge-success">Hoạt động</span></td>
                <td>
                  <div class="d-flex gap-1">
                    <button class="topbar-icon-btn" title="Xem"><i class="fas fa-eye" style="font-size:13px"></i></button>
                    <button class="topbar-icon-btn" title="Sửa"><i class="fas fa-pen" style="font-size:13px;color:var(--primary-light)"></i></button>
                    <button class="topbar-icon-btn"><i class="fas fa-lock" style="font-size:13px;color:var(--warning)"></i></button>
                  </div>
                </td>
              </tr>
              <tr style="background:#FFF5F5">
                <td><input type="checkbox" style="accent-color:var(--primary-light)"></td>
                <td>
                  <div class="d-flex align-items-center gap-2">
                    <div class="avatar avatar-sm" style="background:#FEE2E2;color:var(--danger)">XB</div>
                    <div>
                      <div style="font-size:13px;font-weight:600">Lê Văn Xấu</div>
                      <div style="font-size:11px;color:var(--text-muted)">ID: U-00498</div>
                    </div>
                  </div>
                </td>
                <td><span class="badge-h badge-gray">Bệnh nhân</span></td>
                <td style="font-size:13px">levanxau@spam.com</td>
                <td style="font-size:13px">01/03/2025</td>
                <td><span class="badge-h badge-danger">Đã khóa</span></td>
                <td>
                  <div class="d-flex gap-1">
                    <button class="topbar-icon-btn"><i class="fas fa-eye" style="font-size:13px"></i></button>
                    <button class="topbar-icon-btn"><i class="fas fa-lock-open" style="font-size:13px;color:var(--success)"></i></button>
                    <button class="topbar-icon-btn"><i class="fas fa-trash" style="font-size:13px;color:var(--danger)"></i></button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
        <div class="card-footer-h">
          <div class="d-flex align-items-center justify-content-between">
            <span style="font-size:13px;color:var(--text-muted)">Hiển thị 1–3 của ${userCount} người dùng</span>
            <div class="d-flex gap-1">
              <button class="btn-hospital btn-ghost-h btn-sm">Trước</button>
              <button class="btn-hospital btn-primary-h btn-sm">1</button>
              <button class="btn-hospital btn-ghost-h btn-sm">2</button>
              <button class="btn-hospital btn-ghost-h btn-sm">3</button>
              <button class="btn-hospital btn-ghost-h btn-sm">Sau</button>
            </div>
          </div>
        </div>
      </div>

      <!-- Eye Diseases Catalog -->
      <div class="card-hospital">
        <div class="card-header-h">
          <div>
            <h5>Danh Mục Bệnh Mắt</h5>
            <p style="font-size:12px;color:var(--text-muted);margin:0">42 loại bệnh trong hệ thống</p>
          </div>
          <button class="btn-hospital btn-primary-h">
            <i class="fas fa-plus"></i> Thêm bệnh
          </button>
        </div>
        <div class="card-body-h" style="padding:0">
          <table class="table-hospital">
            <thead>
              <tr>
                <th>Mã ICD-10</th>
                <th>Tên bệnh (Việt Nam)</th>
                <th>Tên tiếng Anh</th>
                <th>Khoa điều trị</th>
                <th>Thao tác</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td><code style="background:var(--bg-alt);padding:2px 8px;border-radius:4px;font-size:12px">H26</code></td>
                <td style="font-size:13px;font-weight:500">Cườm đục thủy tinh thể</td>
                <td style="font-size:13px;color:var(--text-muted)">Cataract</td>
                <td><span class="badge-h badge-primary">Cườm mắt</span></td>
                <td>
                  <div class="d-flex gap-1">
                    <button class="topbar-icon-btn"><i class="fas fa-pen" style="font-size:13px;color:var(--primary-light)"></i></button>
                    <button class="topbar-icon-btn"><i class="fas fa-trash" style="font-size:13px;color:var(--danger)"></i></button>
                  </div>
                </td>
              </tr>
              <tr>
                <td><code style="background:var(--bg-alt);padding:2px 8px;border-radius:4px;font-size:12px">H40.1</code></td>
                <td style="font-size:13px;font-weight:500">Glaucoma góc mở nguyên phát</td>
                <td style="font-size:13px;color:var(--text-muted)">Primary open-angle glaucoma</td>
                <td><span class="badge-h badge-primary">Tăng nhãn áp</span></td>
                <td>
                  <div class="d-flex gap-1">
                    <button class="topbar-icon-btn"><i class="fas fa-pen" style="font-size:13px;color:var(--primary-light)"></i></button>
                    <button class="topbar-icon-btn"><i class="fas fa-trash" style="font-size:13px;color:var(--danger)"></i></button>
                  </div>
                </td>
              </tr>
              <tr>
                <td><code style="background:var(--bg-alt);padding:2px 8px;border-radius:4px;font-size:12px">H52.1</code></td>
                <td style="font-size:13px;font-weight:500">Cận thị</td>
                <td style="font-size:13px;color:var(--text-muted)">Myopia</td>
                <td><span class="badge-h badge-primary">Khúc xạ</span></td>
                <td>
                  <div class="d-flex gap-1">
                    <button class="topbar-icon-btn"><i class="fas fa-pen" style="font-size:13px;color:var(--primary-light)"></i></button>
                    <button class="topbar-icon-btn"><i class="fas fa-trash" style="font-size:13px;color:var(--danger)"></i></button>
                  </div>
                </td>
              </tr>
              <tr>
                <td><code style="background:var(--bg-alt);padding:2px 8px;border-radius:4px;font-size:12px">E11.3</code></td>
                <td style="font-size:13px;font-weight:500">Bệnh lý võng mạc đái tháo đường</td>
                <td style="font-size:13px;color:var(--text-muted)">Diabetic retinopathy</td>
                <td><span class="badge-h badge-primary">Võng mạc</span></td>
                <td>
                  <div class="d-flex gap-1">
                    <button class="topbar-icon-btn"><i class="fas fa-pen" style="font-size:13px;color:var(--primary-light)"></i></button>
                    <button class="topbar-icon-btn"><i class="fas fa-trash" style="font-size:13px;color:var(--danger)"></i></button>
                  </div>
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </main>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
</body>
</html>
