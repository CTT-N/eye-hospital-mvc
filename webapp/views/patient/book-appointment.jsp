<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Đặt Lịch Khám – BV Mắt PTIT</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/book-appointment.css" rel="stylesheet">
</head>
<body class="has-pub-nav">
<nav class="pub-nav">
  <div class="nav-inner">
    <a href="${pageContext.request.contextPath}/patient/dashboard" class="nav-brand">
      <div class="brand-icon">
        <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zm0 12.5a5 5 0 1 1 0-10 5 5 0 0 1 0 10zm0-8a3 3 0 1 0 0 6 3 3 0 0 0 0-6z"/></svg>
      </div>
      <div class="brand-name">BV Mắt PTIT<small>Chuyên khoa nhãn khoa</small></div>
    </a>
    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}/patient/dashboard">Trang chủ</a></li>
      <li><a href="#">Dịch vụ</a></li>
      <li><a href="${pageContext.request.contextPath}/common/find-doctor">Bác sĩ</a></li>
      <li><a href="#">Tin tức</a></li>
      <li><a href="#">Liên hệ</a></li>
    </ul>
    <div class="nav-actions">
      <a href="${pageContext.request.contextPath}/patient/dashboard" style="display:flex; align-items:center; gap:10px; text-decoration:none; background: rgba(255,255,255,0.1); border: 1px solid rgba(255,255,255,0.15); padding: 6px 16px 6px 6px; border-radius: 40px; transition: all 0.2s;" onmouseover="this.style.background='rgba(255,255,255,0.2)'" onmouseout="this.style.background='rgba(255,255,255,0.1)'">
        <div style="width: 32px; height: 32px; background: var(--gold); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 13px; font-weight: 700; color: #fff;"><c:choose><c:when test="${not empty sessionScope.user.fullName}">${fn:substring(sessionScope.user.fullName, 0, 1)}</c:when><c:otherwise>?</c:otherwise></c:choose></div>
        <span style="font-size: 13px; font-weight: 600; color: #fff;" class="d-none d-sm-block">${sessionScope.user.fullName}</span>
      </a>
    </div>
  </div>
</nav>

<div style="max-width:1100px;margin:0 auto;padding:32px 24px 0">
  <!-- Stepper -->
  <div class="stepper">
    <div class="step active" id="step1"><div class="step-num">1</div><span class="d-none d-md-block">Chọn chuyên khoa & bác sĩ</span><span class="d-md-none">Bác sĩ</span></div>
    <div class="step" id="step2"><div class="step-num">2</div><span class="d-none d-md-block">Chọn ngày & giờ</span><span class="d-md-none">Lịch hẹn</span></div>
    <div class="step" id="step3"><div class="step-num">3</div><span class="d-none d-md-block">Thông tin bệnh nhân</span><span class="d-md-none">Thông tin</span></div>
    <div class="step" id="step4"><div class="step-num">4</div><span class="d-none d-md-block">Xác nhận</span><span class="d-md-none">Xác nhận</span></div>
  </div>
</div>

<c:if test="${not empty error}">
  <div class="alert alert-danger" style="max-width:1100px;margin:16px auto 0;padding:0 24px"><c:out value="${error}"/></div>
</c:if>

<div class="book-layout">
  <form action="${pageContext.request.contextPath}/patient/appointment" method="post" id="bookingForm">
  <input type="hidden" name="doctorId" id="hidDoctorId">
  <input type="hidden" name="date"     id="hidDate">
  <input type="hidden" name="time"     id="hidTime">
  <div>
    <!-- STEP 1: Specialty + Doctor -->
    <div class="book-card">
      <h4><div class="num">1</div> Chọn chuyên khoa</h4>
      <div class="spec-grid">
        <div class="spec-item selected" onclick="selectSpec(this)"><div class="si-name">Võng mạc</div><div class="si-desc">Khám & điều trị</div></div>
        <div class="spec-item" onclick="selectSpec(this)"><div class="si-name">Cườm mắt</div><div class="si-desc">Phẫu thuật Phaco</div></div>
        <div class="spec-item" onclick="selectSpec(this)"><div class="si-name">LASIK</div><div class="si-desc">Phẫu thuật khúc xạ</div></div>
        <div class="spec-item" onclick="selectSpec(this)"><div class="si-name">Nhãn nhi</div><div class="si-desc">Cho trẻ em</div></div>
        <div class="spec-item" onclick="selectSpec(this)"><div class="si-name">Glaucoma</div><div class="si-desc">Tăng nhãn áp</div></div>
        <div class="spec-item" onclick="selectSpec(this)"><div class="si-name">Khúc xạ</div><div class="si-desc">Đo kính</div></div>
      </div>
    </div>

    <div class="book-card">
      <h4><div class="num">2</div> Chọn bác sĩ</h4>
      <div class="doc-pick-list">
        <c:forEach var="doc" items="${doctors}">
        <div class="doc-pick-item" onclick="selectDoc(this,'${doc.doctorId}','${doc.fullName}')">
          <div style="width:48px;height:48px;background:var(--bg-alt);border-radius:50%;display:flex;align-items:center;justify-content:center;font-size:18px;font-weight:700;color:var(--primary)">
            <c:choose>
              <c:when test="${not empty doc.fullName}">${fn:substring(doc.fullName, 0, 1)}</c:when>
              <c:otherwise>?</c:otherwise>
            </c:choose>
          </div>
          <div>
            <div class="dpi-name">
              <c:choose>
                <c:when test="${not empty doc.fullName}">${doc.fullName}</c:when>
                <c:otherwise>${doc.doctorId}</c:otherwise>
              </c:choose>
            </div>
            <div class="dpi-spec">${doc.departmentId} · ${doc.experience}</div>
          </div>
          <div class="dpi-radio"></div>
        </div>
        </c:forEach>
      </div>
    </div>

    <!-- STEP 2: Date & Time -->
    <div class="book-card">
      <h4><div class="num">3</div> Chọn ngày khám</h4>
      <div class="date-grid" id="dateGrid"></div>
      <h4 style="margin-top:20px"><div class="num">4</div> Chọn giờ khám</h4>
      <div class="time-grid">
        <div class="time-btn full">07:00</div>
        <div class="time-btn selected" onclick="selectTime(this)">07:30</div>
        <div class="time-btn" onclick="selectTime(this)">08:00</div>
        <div class="time-btn" onclick="selectTime(this)">08:30</div>
        <div class="time-btn" onclick="selectTime(this)">09:00</div>
        <div class="time-btn full">09:30</div>
        <div class="time-btn" onclick="selectTime(this)">10:00</div>
        <div class="time-btn" onclick="selectTime(this)">10:30</div>
        <div class="time-btn" onclick="selectTime(this)">13:30</div>
        <div class="time-btn" onclick="selectTime(this)">14:00</div>
        <div class="time-btn full">14:30</div>
        <div class="time-btn" onclick="selectTime(this)">15:00</div>
      </div>
    </div>

    <!-- STEP 3: Patient Info -->
    <div class="book-card">
      <h4><div class="num">5</div> Thông tin bệnh nhân</h4>
      <div class="form-row">
        <div class="form-group"><label>Họ và tên *</label><input type="text" name="fullName" value="${sessionScope.user.fullName}" required></div>
        <div class="form-group"><label>Ngày sinh *</label><input type="date" name="dob" required></div>
      </div>
      <div class="form-row">
        <div class="form-group"><label>Số điện thoại *</label><input type="tel" name="phone" value="${sessionScope.user.phone}" placeholder="09xxxxxxxx" required></div>
        <div class="form-group"><label>Email</label><input type="email" name="email" value="${sessionScope.user.email}" placeholder="email@example.com"></div>
      </div>
      <div class="form-row">
        <div class="form-group"><label>Giới tính</label><select name="gender"><option>Nam</option><option>Nữ</option></select></div>
        <div class="form-group"><label>Mã BHYT</label><input type="text" name="insuranceId" placeholder="(nếu có)"></div>
      </div>
      <div class="form-group"><label>Lý do khám & triệu chứng</label><textarea name="reason" placeholder="Mô tả triệu chứng hoặc vấn đề về mắt bạn đang gặp phải..."></textarea></div>
      <div class="form-group"><label>Tiền sử bệnh tại BV (nếu có)</label><input type="text" name="medicalHistory" placeholder="Số hồ sơ bệnh án trước đây (nếu là bệnh nhân cũ)"></div>
    </div>
  </div>

  <!-- SUMMARY SIDEBAR -->
  <div>
    <div class="summary-card">
      <div class="sc-head"><h5>Tóm tắt lịch hẹn</h5></div>
      <div class="sc-body">
        <div class="sc-row"><span class="label">Chuyên khoa</span><span class="value" id="sumSpec">Võng mạc</span></div>
        <div class="sc-row"><span class="label">Bác sĩ</span><span class="value" id="sumDoc">-- Chọn bác sĩ --</span></div>
        <div class="sc-row"><span class="label">Ngày khám</span><span class="value" id="sumDate">-- Chọn ngày --</span></div>
        <div class="sc-row"><span class="label">Giờ khám</span><span class="value" id="sumTime">07:30</span></div>
        <div class="sc-divider"></div>
        <div class="price-row"><span class="lbl">Phí khám</span><span class="price">350,000đ</span></div>
        <div style="font-size:11px;color:var(--muted);margin-top:6px">Chưa bao gồm thuốc và xét nghiệm</div>
        <div class="sc-divider"></div>
        <div style="font-size:12px;color:var(--muted);line-height:1.7">
          <i class="fas fa-clock" style="color:var(--gold);margin-right:6px"></i>Vui lòng đến trước 15 phút<br>
          <i class="fas fa-id-card" style="color:var(--gold);margin-right:6px"></i>Mang CMND/CCCD và BHYT (nếu có)<br>
          <i class="fas fa-phone" style="color:var(--gold);margin-right:6px"></i>Hủy/đổi lịch trước 24h: <strong>1800 1234</strong>
        </div>
        <button type="submit" class="btn-confirm" onclick="return confirmBooking()">
          <i class="fas fa-check-circle"></i> Xác nhận đặt lịch
        </button>
        <p class="sc-note">Bạn sẽ nhận xác nhận qua SMS và Email sau khi đặt thành công</p>
      </div>
    </div>
  </div>
  </form>
</div>

<script src="${pageContext.request.contextPath}/static/js/book-appointment.js"></script>
</body>
</html>
