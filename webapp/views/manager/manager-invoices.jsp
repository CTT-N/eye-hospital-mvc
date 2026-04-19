<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Quản lý hóa đơn – BV Mắt PTIT</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
</head>
<body>
<div class="app-shell">
  <c:set var="activeManagerNav" value="invoices" />
  <%@ include file="_sidebar.jspf" %>

  <main class="main-content">
    <header class="topbar">
      <div class="topbar-left">
        <button class="topbar-icon-btn" id="sidebarToggle"><i class="fas fa-bars"></i></button>
        <div>
          <div class="topbar-title">Quản lý hóa đơn</div>
          <div style="font-size:12px;color:var(--text-muted)">Danh sách và quản lý hóa đơn thanh toán</div>
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
      <div class="filter-bar" style="margin-bottom:16px">
        <a href="${pageContext.request.contextPath}/manager/invoices"
           class="btn-hospital btn-sm ${empty statusFilter ? '' : 'btn-ghost-h'}">Tất cả</a>
        <a href="${pageContext.request.contextPath}/manager/invoices?status=PENDING"
           class="btn-hospital btn-sm ${statusFilter eq 'PENDING' ? '' : 'btn-ghost-h'}">Chờ thanh toán</a>
        <a href="${pageContext.request.contextPath}/manager/invoices?status=PAID"
           class="btn-hospital btn-sm ${statusFilter eq 'PAID' ? '' : 'btn-ghost-h'}">Đã thanh toán</a>
      </div>

      <div class="card-hospital">
        <div class="card-body-h" style="padding:0">
          <table class="data-table">
            <thead>
              <tr>
                <th>Mã HĐ</th>
                <th>Ngày</th>
                <th>Bệnh nhân</th>
                <th>Bác sĩ</th>
                <th>Tổng tiền</th>
                <th>Trạng thái</th>
                <th class="action-cell">Thao tác</th>
              </tr>
            </thead>
            <tbody>
              <c:choose>
                <c:when test="${empty listInvoices}">
                  <tr><td colspan="7" style="text-align:center;padding:24px;color:var(--text-muted)">Không có hóa đơn nào</td></tr>
                </c:when>
                <c:otherwise>
                  <c:forEach var="inv" items="${listInvoices}">
                  <tr>
                    <td><strong>#${inv.invoiceId}</strong></td>
                    <td>${inv.date}</td>
                    <td>${not empty inv.patientName ? inv.patientName : '—'}</td>
                    <td>${not empty inv.doctorName ? inv.doctorName : '—'}</td>
                    <td><strong>${inv.totalAmount} ₫</strong></td>
                    <td>
                      <c:choose>
                        <c:when test="${inv.status eq 'PAID'}">
                          <span class="badge-h badge-success">Đã thanh toán</span>
                        </c:when>
                        <c:otherwise>
                          <span class="badge-h badge-gray">Chờ thanh toán</span>
                        </c:otherwise>
                      </c:choose>
                    </td>
                    <td class="action-cell">
                      <button class="btn-hospital btn-sm" title="Chi tiết" onclick="openInvoiceModal('${inv.invoiceId}')">
                        <i class="fas fa-eye"></i>
                      </button>
                      <form action="${pageContext.request.contextPath}/manager/invoices" method="post" style="display:inline">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="invoiceId" value="${inv.invoiceId}">
                        <input type="hidden" name="status" value="${inv.status eq 'PAID' ? 'PENDING' : 'PAID'}">
                        <input type="hidden" name="statusFilter" value="${statusFilter}">
                        <button type="submit" class="btn-hospital btn-sm" title="${inv.status eq 'PAID' ? 'Đánh dấu chờ TT' : 'Đánh dấu đã TT'}">
                          <i class="fas ${inv.status eq 'PAID' ? 'fa-rotate-left' : 'fa-check'}"></i>
                        </button>
                      </form>
                      <form action="${pageContext.request.contextPath}/manager/invoices" method="post" style="display:inline"
                            onsubmit="return confirm('Xóa hóa đơn ${inv.invoiceId}?')">
                        <input type="hidden" name="action" value="delete">
                        <input type="hidden" name="invoiceId" value="${inv.invoiceId}">
                        <input type="hidden" name="statusFilter" value="${statusFilter}">
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

<div class="modal-overlay" id="invoiceModal">
  <div class="modal-box">
    <div class="modal-head">
      <h5 id="modalTitle">Chi tiết hóa đơn</h5>
      <button class="modal-close" onclick="closeInvoiceModal()"><i class="fas fa-times"></i></button>
    </div>
    <div class="modal-body">
      <div style="display:grid;grid-template-columns:1fr 1fr;gap:12px;margin-bottom:18px">
        <div><div class="form-label-h">Mã hóa đơn</div><div id="mId" style="font-weight:600"></div></div>
        <div><div class="form-label-h">Ngày</div><div id="mDate"></div></div>
        <div><div class="form-label-h">Bệnh nhân</div><div id="mPatient"></div></div>
        <div><div class="form-label-h">Bác sĩ</div><div id="mDoctor"></div></div>
      </div>
      <hr style="border-color:var(--border);margin:16px 0">
      <table class="data-table">
        <thead><tr><th>Dịch vụ</th><th>SL</th><th style="text-align:right">Thành tiền</th></tr></thead>
        <tbody id="mServiceBody"></tbody>
        <tfoot>
          <tr style="background:var(--bg-alt)">
            <td colspan="2" style="padding:12px 14px;font-weight:700">Tổng cộng</td>
            <td style="padding:12px 14px;font-weight:700;text-align:right;color:var(--primary)" id="mTotal"></td>
          </tr>
        </tfoot>
      </table>
    </div>
    <div class="modal-foot">
      <button class="btn-hospital btn-ghost-h" onclick="closeInvoiceModal()">Đóng</button>
    </div>
  </div>
</div>

<script>
var invoiceData = {
<c:forEach var="inv" items="${listInvoices}" varStatus="outer">
  '${inv.invoiceId}': {
    date: '${inv.date}',
    patient: '${fn:escapeXml(inv.patientName)}',
    doctor: '${fn:escapeXml(inv.doctorName)}',
    total: ${inv.totalAmount},
    services: [<c:forEach var="s" items="${inv.services}" varStatus="inner">['${fn:escapeXml(s.serviceName)}', ${s.quantity}, ${s.totalPrice}]${inner.last ? '' : ','}</c:forEach>]
  }${outer.last ? '' : ','}
</c:forEach>
};
</script>
<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
<script>
function openInvoiceModal(id) {
  var inv = invoiceData[id];
  if (!inv) {
    return;
  }

  document.getElementById('modalTitle').textContent = 'Hóa đơn #' + id;
  document.getElementById('mId').textContent = '#' + id;
  document.getElementById('mDate').textContent = inv.date;
  document.getElementById('mPatient').textContent = inv.patient || '—';
  document.getElementById('mDoctor').textContent = inv.doctor || '—';
  document.getElementById('mTotal').textContent = inv.total.toLocaleString('vi-VN') + ' ₫';
  var tbody = document.getElementById('mServiceBody');
  tbody.innerHTML = inv.services.map(function (service) {
    return '<tr><td>' + service[0] + '</td><td>' + service[1] + '</td><td style="text-align:right">' + service[2].toLocaleString('vi-VN') + ' ₫</td></tr>';
  }).join('');
  document.getElementById('invoiceModal').classList.add('open');
}

function closeInvoiceModal() {
  document.getElementById('invoiceModal').classList.remove('open');
}

document.addEventListener('DOMContentLoaded', function () {
  document.getElementById('invoiceModal').addEventListener('click', function (e) {
    if (e.target === this) {
      closeInvoiceModal();
    }
  });
});
</script>
</body>
</html>
