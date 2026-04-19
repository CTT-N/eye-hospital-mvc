<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản lý dịch vụ – BV Mắt PTIT</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
</head>
<body>
<div class="app-shell">
  <c:set var="activeManagerNav" value="services" />

  <%@ include file="_sidebar.jspf" %>

  <main class="main-content">
    <header class="topbar">
      <div class="topbar-left">
        <button class="topbar-icon-btn" id="sidebarToggle"><i class="fas fa-bars"></i></button>
        <div>
          <div class="topbar-title">Quản lý dịch vụ</div>
          <div style="font-size:12px;color:var(--text-muted)">Danh sách và quản lý dịch vụ y tế</div>
        </div>
      </div>
      <div class="topbar-right">
        <button class="topbar-icon-btn"><i class="fas fa-bell"></i><span class="notif-dot"></span></button>
        <button class="topbar-user">
          <div class="avatar avatar-sm"><c:choose><c:when test="${fn:length(sessionScope.user.fullName) >= 2}">${fn:substring(sessionScope.user.fullName, 0, 2)}</c:when><c:otherwise>?</c:otherwise></c:choose></div>
          <div class="user-details d-none d-md-block">
            <span class="user-name">${sessionScope.user.fullName}</span>
            <span class="user-role">Manager</span>
          </div>
        </button>
      </div>
    </header>

    <div class="content-area">

      <c:if test="${param.error eq 'inuse'}">
        <div style="background:#FEF2F2;border:1px solid #FECACA;color:#B91C1C;padding:12px 16px;border-radius:6px;margin-bottom:16px">
          <i class="fas fa-exclamation-circle" style="margin-right:8px"></i>Không thể xóa — dịch vụ này đang được sử dụng trong hóa đơn.
        </div>
      </c:if>

      <c:if test="${param.error eq 'invalid'}">
        <div style="background:#FEF2F2;border:1px solid #FECACA;color:#B91C1C;padding:12px 16px;border-radius:6px;margin-bottom:16px">
          <i class="fas fa-exclamation-circle" style="margin-right:8px"></i>Tên dịch vụ và đơn giá không được để trống.
        </div>
      </c:if>

      <c:if test="${param.error eq 'savefail'}">
        <div style="background:#FEF2F2;border:1px solid #FECACA;color:#B91C1C;padding:12px 16px;border-radius:6px;margin-bottom:16px">
          <i class="fas fa-exclamation-circle" style="margin-right:8px"></i>Lỗi khi lưu dịch vụ. Vui lòng thử lại.
        </div>
      </c:if>

      <div style="display:flex;justify-content:flex-end;margin-bottom:16px">
        <button class="btn-hospital" onclick="openAddModal()">
          <i class="fas fa-plus"></i> Thêm dịch vụ
        </button>
      </div>

      <div class="card-hospital">
        <div class="card-body-h" style="padding:0">
          <table class="data-table">
            <thead>
              <tr>
                <th>Mã DV</th>
                <th>Tên dịch vụ</th>
                <th>Mô tả</th>
                <th style="text-align:right">Đơn giá</th>
                <th class="action-cell">Thao tác</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${empty services}">
                  <tr><td colspan="5" style="text-align:center;padding:24px;color:var(--text-muted)">Chưa có dịch vụ nào</td></tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="svc" items="${services}">
                  <tr>
                    <td><strong>${fn:escapeXml(svc.serviceId)}</strong></td>
                    <td>${fn:escapeXml(svc.serviceName)}</td>
                    <td style="color:var(--text-muted);font-size:13px">${not empty svc.description ? fn:escapeXml(svc.description) : '—'}</td>
                    <td style="text-align:right;font-weight:600"><fmt:formatNumber value="${svc.price}" type="number" maxFractionDigits="0" /> ₫</td>
                    <td class="action-cell">
                      <button class="btn-hospital btn-sm" title="Sửa"
                              onclick="openEditModal('${svc.serviceId}')">
                        <i class="fas fa-pen"></i>
                      </button>
                      <form action="${pageContext.request.contextPath}/manager/services" method="post" style="display:inline"
                            data-service-name="${fn:escapeXml(svc.serviceName)}" onsubmit="return confirmDelete(this)">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="serviceId" value="${svc.serviceId}">
                        <button type="submit" class="btn-hospital btn-danger-h btn-sm" title="Xóa">
                          <i class="fas fa-trash"></i>
                        </button>
                      </form>
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
  </main>
</div>

<!-- Add / Edit Modal -->
<div class="modal-overlay" id="serviceModal">
  <div class="modal-box">
    <div class="modal-head">
      <h5 id="modalTitle">Thêm dịch vụ</h5>
      <button class="modal-close" onclick="closeServiceModal()"><i class="fas fa-times"></i></button>
    </div>
    <form action="${pageContext.request.contextPath}/manager/services" method="post">
      <input type="hidden" name="action"    id="modalAction"    value="add">
      <input type="hidden" name="serviceId" id="modalServiceId" value="">
      <div class="modal-body">
        <div style="margin-bottom:14px">
          <div class="form-label-h">Tên dịch vụ <span style="color:#EF4444">*</span></div>
          <input type="text" name="serviceName" id="modalName" required
                 style="width:100%;padding:9px 12px;border:1.5px solid var(--border);border-radius:6px;font-size:14px">
        </div>
        <div style="margin-bottom:14px">
          <div class="form-label-h">Đơn giá (₫) <span style="color:#EF4444">*</span></div>
          <input type="number" name="price" id="modalPrice" required min="0" step="1000"
                 style="width:100%;padding:9px 12px;border:1.5px solid var(--border);border-radius:6px;font-size:14px">
        </div>
        <div>
          <div class="form-label-h">Mô tả</div>
          <textarea name="description" id="modalDesc" rows="3"
                    style="width:100%;padding:9px 12px;border:1.5px solid var(--border);border-radius:6px;font-size:14px;resize:vertical"></textarea>
        </div>
      </div>
      <div class="modal-foot">
        <button type="button" class="btn-hospital btn-ghost-h" onclick="closeServiceModal()">Hủy</button>
        <button type="submit" class="btn-hospital">Lưu</button>
      </div>
    </form>
  </div>
</div>

<script>
var serviceData = {
<c:forEach var="svc" items="${services}" varStatus="st">
  '${svc.serviceId}': { name: '${fn:escapeXml(svc.serviceName)}', price: ${svc.price}, desc: '${fn:escapeXml(not empty svc.description ? svc.description : "")}' }${st.last ? '' : ','}
</c:forEach>
};
</script>
<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/static/js/manager-services.js"></script>
</body>
</html>
