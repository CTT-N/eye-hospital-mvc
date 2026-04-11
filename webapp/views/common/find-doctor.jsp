<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Tìm Bác Sĩ – BV Mắt PTIT</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:wght@700&display=swap" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/find-doctor.css" rel="stylesheet">
</head>
<body class="has-pub-nav">
<nav class="pub-nav">
  <div class="nav-inner">
    <a href="${pageContext.request.contextPath}/" class="nav-brand">
      <div class="brand-icon">
        <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zm0 12.5a5 5 0 1 1 0-10 5 5 0 0 1 0 10zm0-8a3 3 0 1 0 0 6 3 3 0 0 0 0-6z"/></svg>
      </div>
      <div class="brand-name">BV Mắt PTIT<small>Chuyên khoa nhãn khoa</small></div>
    </a>
    <ul class="nav-links">
      <li><a href="${pageContext.request.contextPath}/">Trang chủ</a></li>
      <li><a href="#">Dịch vụ</a></li>
      <li><a href="${pageContext.request.contextPath}/common/find-doctor" class="active">Bác sĩ</a></li>
      <li><a href="#">Tin tức</a></li>
      <li><a href="#">Liên hệ</a></li>
    </ul>
    <div class="nav-actions">
      <a href="${pageContext.request.contextPath}/auth/login" class="btn-nav-ghost">Đăng nhập</a>
      <a href="${pageContext.request.contextPath}/patient/appointment" class="btn-nav-cta">Đặt lịch khám</a>
    </div>
  </div>
</nav>

<div class="page-hero">
  <div class="container">
    <div class="eyebrow">Đội ngũ chuyên gia</div>
    <h1>Tìm bác sĩ<br>phù hợp với bạn</h1>
    <p>Hơn 50 bác sĩ chuyên khoa nhãn khoa giàu kinh nghiệm, tốt nghiệp các trường y khoa hàng đầu.</p>
  </div>
</div>

<div class="filter-bar">
  <div class="inner">
    <input type="text" id="searchInput" placeholder="🔍 Tìm theo tên bác sĩ..." oninput="filterDoctors()">
    <select id="specFilter" onchange="filterDoctors()">
      <option value="">Tất cả chuyên khoa</option>
      <option value="Võng mạc">Võng mạc</option>
      <option value="Cườm mắt">Cườm mắt</option>
      <option value="Nhãn nhi">Nhãn nhi</option>
      <option value="Khúc xạ">Khúc xạ</option>
      <option value="Glaucoma">Glaucoma</option>
      <option value="LASIK">LASIK</option>
    </select>
    <select id="availFilter" onchange="filterDoctors()">
      <option value="">Tất cả</option>
      <option value="open">Còn lịch trống</option>
    </select>
    <span class="count" id="docCount">Hiển thị 0 bác sĩ</span>
  </div>
</div>

<div class="doctors-main">
  <div class="doc-grid" id="docGrid">
    <c:choose>
      <c:when test="${empty doctors}">
        <div class="no-results" style="grid-column:1/-1;text-align:center;padding:48px;color:#6B7280">
          <i class="fas fa-user-doctor fa-2x" style="margin-bottom:16px;opacity:.3"></i><br>
          Chưa có bác sĩ nào trong hệ thống
        </div>
      </c:when>
      <c:otherwise>
        <c:forEach var="doc" items="${doctors}" varStatus="vs">
          <c:set var="imgNum" value="${vs.index mod 4 + 1}" />
          <c:set var="spec" value="${not empty doc.departmentName ? doc.departmentName : 'Nhãn khoa'}" />
          <c:set var="avatar" value="${not empty doc.avatarUrl ? doc.avatarUrl : pageContext.request.contextPath.concat('/static/images/doctor-').concat(imgNum).concat('.jpg')}" />
          <div class="doc-card-v2"
               data-name="${fn:toLowerCase(fn:escapeXml(doc.fullName))}"
               data-spec="${fn:toLowerCase(fn:escapeXml(spec))}"
               data-avail="open">
            <div class="doc-photo">
              <img src="${avatar}"
                   alt="${fn:escapeXml(doc.fullName)}" loading="lazy">
              <div class="avail-badge open">Còn lịch trống</div>
            </div>
            <div class="doc-info">
              <div class="name">${fn:escapeXml(doc.fullName)}</div>
              <div class="spec">Chuyên khoa ${fn:escapeXml(spec)}</div>
              <div class="tags">
                <span class="tag">${fn:escapeXml(spec)}</span>
                <c:if test="${not empty doc.experience}">
                  <span class="tag">${fn:escapeXml(doc.experience)}</span>
                </c:if>
                <c:if test="${not empty doc.educationDegree}">
                  <span class="tag">${fn:escapeXml(doc.educationDegree)}</span>
                </c:if>
              </div>
              <div class="doc-meta">
                <c:if test="${not empty doc.description}">
                  <div class="patients" style="font-size:12px;color:#6B7280">${fn:escapeXml(doc.description)}</div>
                </c:if>
              </div>
              <a href="${pageContext.request.contextPath}/auth/login" class="btn-book-sm">
                <i class="fas fa-calendar-plus"></i> Đặt lịch ngay
              </a>
            </div>
          </div>
        </c:forEach>
      </c:otherwise>
    </c:choose>
  </div>
</div>

<footer style="background:#060E1A;color:rgba(255,255,255,.45);padding:32px;text-align:center;font-size:13px">
  © 2024 Bệnh Viện Mắt PTIT · <a href="${pageContext.request.contextPath}/" style="color:rgba(255,255,255,.6)">Trang chủ</a>
</footer>

<script src="${pageContext.request.contextPath}/static/js/find-doctor.js"></script>
</body>
</html>
