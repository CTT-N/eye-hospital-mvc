<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tạo hóa đơn – BV Mắt PTIT</title>
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
          <div class="topbar-title">Tạo hóa đơn</div>
          <div style="font-size:12px;color:var(--text-muted)">Chọn dịch vụ cho lịch hẹn</div>
        </div>
      </div>
      <div class="topbar-right">
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
      <c:if test="${param.error eq 'noservice'}">
        <div style="background:#FEF2F2;border:1px solid #FECACA;color:#B91C1C;padding:12px 16px;border-radius:6px;margin-bottom:16px">
          <i class="fas fa-exclamation-circle" style="margin-right:8px"></i>Vui lòng chọn ít nhất một dịch vụ.
        </div>
      </c:if>

      <form action="${pageContext.request.contextPath}/manager/invoices/create" method="post">
        <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">

        <div class="card-hospital" style="margin-bottom:20px">
          <div class="card-body-h">
            <div style="font-size:13px;font-weight:700;color:var(--text-muted);text-transform:uppercase;letter-spacing:.04em;margin-bottom:12px">Thông tin lịch hẹn</div>
            <div style="display:grid;grid-template-columns:1fr 1fr;gap:14px">
              <div>
                <div class="form-label-h">Bệnh nhân</div>
                <div style="font-weight:600">${not empty appointment.patientName ? appointment.patientName : appointment.patientId}</div>
              </div>
              <div>
                <div class="form-label-h">Bác sĩ</div>
                <div style="font-weight:600">${not empty appointment.doctorName ? appointment.doctorName : appointment.doctorId}</div>
              </div>
              <div>
                <div class="form-label-h">Ngày khám</div>
                <div>${appointment.date}</div>
              </div>
              <div>
                <div class="form-label-h">Giờ</div>
                <div>${appointment.time}</div>
              </div>
            </div>
          </div>
        </div>

        <div class="card-hospital" style="margin-bottom:20px">
          <div class="card-body-h" style="padding:0">
            <table class="data-table" id="svcTable">
              <thead>
                <tr>
                  <th style="width:44px;text-align:center"></th>
                  <th>Dịch vụ</th>
                  <th>Mô tả</th>
                  <th>Đơn giá</th>
                  <th style="width:110px">Số lượng</th>
                  <th style="text-align:right">Thành tiền</th>
                </tr>
              </thead>
              <tbody>
                <c:forEach var="svc" items="${services}">
                <tr data-price="${svc.price}">
                  <td style="text-align:center">
                    <input type="checkbox" class="svc-check" name="serviceId" value="${svc.serviceId}">
                  </td>
                  <td style="font-weight:500">${svc.serviceName}</td>
                  <td style="color:var(--text-muted);font-size:12px">${svc.description}</td>
                  <td>${svc.price} ₫</td>
                  <td>
                    <input type="number" class="svc-qty" name="qty_${svc.serviceId}"
                           value="1" min="1"
                           style="width:72px;padding:5px 8px;border:1.5px solid var(--border);border-radius:5px;font-size:13px">
                  </td>
                  <td style="text-align:right" class="row-total">—</td>
                </tr>
                </c:forEach>
              </tbody>
              <tfoot>
                <tr style="background:var(--bg-alt)">
                  <td colspan="5" style="padding:14px;font-weight:700">Tổng cộng</td>
                  <td style="padding:14px;font-weight:700;text-align:right;font-size:16px;color:var(--primary)" id="totalDisplay">0 ₫</td>
                </tr>
              </tfoot>
            </table>
          </div>
        </div>

        <div style="display:flex;gap:12px;justify-content:flex-end">
          <a href="${pageContext.request.contextPath}/manager/invoices" class="btn-hospital btn-ghost-h">
            <i class="fas fa-arrow-left"></i> Hủy
          </a>
          <button type="submit" class="btn-hospital">
            <i class="fas fa-save"></i> Lưu hóa đơn
          </button>
        </div>
      </form>
    </div>
  </main>
</div>

<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
<script src="${pageContext.request.contextPath}/static/js/manager-invoice-create.js"></script>
</body>
</html>
