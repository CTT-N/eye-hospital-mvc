<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Bệnh Viện Mắt PTIT</title>
  <meta name="description" content="Bệnh Viện Mắt PTIT – Chuyên khoa nhãn khoa hàng đầu, đặt lịch khám trực tuyến 24/7">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link
    href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Playfair+Display:ital,wght@0,700;1,600&display=swap"
    rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/index.css" rel="stylesheet">
</head>

<body>

  <!-- ===== NAV ===== -->
  <nav class="pub-nav">
    <div class="nav-inner">
      <a href="${pageContext.request.contextPath}/" class="nav-brand">
        <div class="brand-icon">
          <svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zm0 12.5a5 5 0 1 1 0-10 5 5 0 0 1 0 10zm0-8a3 3 0 1 0 0 6 3 3 0 0 0 0-6z"/></svg>
        </div>
        <div class="brand-name">BV Mắt PTIT<small>Chuyên khoa nhãn khoa</small></div>
      </a>
      <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/" class="active">Trang chủ</a></li>
        <li><a href="#">Dịch vụ</a></li>
        <li><a href="${pageContext.request.contextPath}/common/find-doctor">Bác sĩ</a></li>
        <li><a href="#">Tin tức</a></li>
        <li><a href="#">Liên hệ</a></li>
      </ul>
      <div class="nav-actions">
        <a href="${pageContext.request.contextPath}/auth/login" class="btn-nav-ghost">Đăng nhập</a>
        <a href="${pageContext.request.contextPath}/auth/register" class="btn-nav-cta">Đăng ký</a>
      </div>
    </div>
  </nav>

  <!-- ===== HERO ===== -->
  <section class="hero">
    <div class="hero-left">
      <div class="hero-eyebrow">
        <div class="line"></div>
        <span>Chuyên khoa nhãn khoa · Hà Nội</span>
      </div>
      <h1>Chăm sóc đôi mắt<br>bằng <em>tận tâm</em><br>và chuyên môn cao</h1>
      <p class="hero-desc">Bệnh viện Mắt PTIT — trung tâm điều trị nhãn khoa uy tín 25 năm, nơi hàng trăm nghìn bệnh
        nhân tin tưởng trao gửi sức khỏe thị giác.</p>
      <div class="hero-cta">
        <a href="${pageContext.request.contextPath}/auth/login" class="btn-gold"><i class="fas fa-calendar-check"></i> Đặt lịch khám</a>
        <a href="${pageContext.request.contextPath}/common/find-doctor" class="btn-outline-w"><i class="fas fa-user-doctor"></i> Tìm bác sĩ</a>
      </div>
      <div class="hero-stats">
        <div>
          <div class="stat-val">25+</div>
          <div class="stat-lbl">Năm kinh nghiệm</div>
        </div>
        <div>
          <div class="stat-val">150K+</div>
          <div class="stat-lbl">Bệnh nhân</div>
        </div>
        <div>
          <div class="stat-val">50+</div>
          <div class="stat-lbl">Bác sĩ chuyên khoa</div>
        </div>
      </div>
    </div>
    <div class="hero-right">
      <img src="${pageContext.request.contextPath}/static/images/hero-eye-exam.jpg" alt="Khám mắt tại BV Mắt PTIT" loading="eager">
      <div class="hero-badge">
        <div class="badge-icon"><i class="fas fa-shield-halved"></i></div>
        <div class="badge-text">
          <div class="bv">Đạt chứng nhận ISO 9001</div>
          <div class="bl">Tiêu chuẩn quốc tế về chất lượng</div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== MARQUEE ===== -->
  <div class="marquee-strip">
    <div class="marquee-track">
      <span class="marquee-item">Khám võng mạc</span>
      <span class="marquee-item">Phẫu thuật LASIK</span>
      <span class="marquee-item">Điều trị Glaucoma</span>
      <span class="marquee-item">Phẫu thuật cườm mắt</span>
      <span class="marquee-item">Nhãn nhi</span>
      <span class="marquee-item">Khúc xạ học</span>
      <span class="marquee-item">Laser điều trị võng mạc</span>
      <span class="marquee-item">Đặt lịch trực tuyến 24/7</span>
      <!-- Duplicate for seamless loop -->
      <span class="marquee-item">Khám võng mạc</span>
      <span class="marquee-item">Phẫu thuật LASIK</span>
      <span class="marquee-item">Điều trị Glaucoma</span>
      <span class="marquee-item">Phẫu thuật cườm mắt</span>
      <span class="marquee-item">Nhãn nhi</span>
      <span class="marquee-item">Khúc xạ học</span>
      <span class="marquee-item">Laser điều trị võng mạc</span>
      <span class="marquee-item">Đặt lịch trực tuyến 24/7</span>
    </div>
  </div>

  <!-- ===== BOOKING BAR ===== -->
  <div class="book-bar">
    <div class="inner">
      <div class="book-field">
        <i class="fas fa-stethoscope bf-icon"></i>
        <div class="bf-wrap">
          <div class="bf-label">Chuyên khoa</div>
          <select>
            <option>Tất cả chuyên khoa</option>
            <option>Khám võng mạc</option>
            <option>Phẫu thuật cườm</option>
            <option>Khúc xạ</option>
            <option>Nhãn nhi</option>
            <option>Glaucoma</option>
          </select>
        </div>
      </div>
      <div class="book-field">
        <i class="fas fa-user-doctor bf-icon"></i>
        <div class="bf-wrap">
          <div class="bf-label">Bác sĩ</div>
          <input type="text" placeholder="Tìm theo tên bác sĩ...">
        </div>
      </div>
      <div class="book-field">
        <i class="fas fa-calendar bf-icon"></i>
        <div class="bf-wrap">
          <div class="bf-label">Ngày khám</div>
          <input type="date">
        </div>
      </div>
      <a href="${pageContext.request.contextPath}/auth/login" class="book-btn">
        <i class="fas fa-magnifying-glass"></i> Tìm lịch khám
      </a>
    </div>
  </div>

  <!-- ===== ABOUT SPLIT ===== -->
  <section class="about-section">
    <div class="about-img">
      <img src="${pageContext.request.contextPath}/static/images/clinic-interior.jpg" alt="Không gian bệnh viện hiện đại">
      <div class="img-caption">Khu vực chờ khám — thiết kế tối giản, thoáng rộng và thân thiện</div>
    </div>
    <div class="about-content">
      <div class="section-label">Về chúng tôi</div>
      <h2>25 năm bảo vệ sức khỏe thị giác cộng đồng</h2>
      <p>Bệnh viện Mắt PTIT được thành lập từ năm 1999, là cơ sở khám chữa bệnh nhãn khoa trực thuộc Trường PTIT
        — một trong những cơ sở y tế uy tín hàng đầu miền Bắc.</p>
      <p>Với đội ngũ hơn 50 giáo sư, tiến sĩ, bác sĩ chuyên khoa và hệ thống trang thiết bị hiện đại đạt chuẩn quốc tế,
        chúng tôi điều trị thành công hàng trăm nghìn ca bệnh mỗi năm.</p>
      <div class="about-grid">
        <div class="about-item">
          <div class="val">150,000+</div>
          <div class="lbl">Bệnh nhân mỗi năm</div>
        </div>
        <div class="about-item">
          <div class="val">98.2%</div>
          <div class="lbl">Tỉ lệ hài lòng</div>
        </div>
        <div class="about-item">
          <div class="val">50+</div>
          <div class="lbl">Bác sĩ chuyên khoa</div>
        </div>
        <div class="about-item">
          <div class="val">ISO 9001</div>
          <div class="lbl">Chứng nhận quốc tế</div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== SERVICES ===== -->
  <section class="services-section">
    <div class="container-xl">
      <div class="row align-items-end mb-0">
        <div class="col-lg-6">
          <div class="section-head">
            <div class="section-label">Dịch vụ</div>
            <h2>Đầy đủ dịch vụ<br>chuyên khoa nhãn khoa</h2>
            <p>Từ khám tổng quát đến phẫu thuật phức tạp — tất cả dưới một mái nhà, với đội ngũ chuyên gia hàng đầu.</p>
          </div>
        </div>
        <div class="col-lg-6 text-lg-end mb-5">
          <a href="#" class="btn-outline-dark"
            style="display:inline-flex;align-items:center;gap:8px;padding:12px 24px;border:1px solid var(--border);font-size:13px;font-weight:600;color:var(--navy);border-radius:4px;transition:all .2s">Xem
            tất cả dịch vụ <i class="fas fa-arrow-right"></i></a>
        </div>
      </div>
      <div class="services-grid">
        <div class="svc">
          <div class="svc-num">01</div>
          <div class="svc-title">Khám Mắt Tổng Quát</div>
          <div class="svc-desc">Kiểm tra toàn diện: thị lực, nhãn áp, đáy mắt, phát hiện sớm bệnh lý.</div>
        </div>
        <div class="svc">
          <div class="svc-num">02</div>
          <div class="svc-title">Khám & Điều Trị Võng Mạc</div>
          <div class="svc-desc">Laser quang đông, tiêm nội nhãn, phẫu thuật dịch kính - võng mạc.</div>
        </div>
        <div class="svc">
          <div class="svc-num">03</div>
          <div class="svc-title">Phẫu Thuật Cườm Mắt</div>
          <div class="svc-desc">Phaco siêu âm, cấy thủy tinh thể nhân tạo (IOL) đơn tiêu và đa tiêu.</div>
        </div>
        <div class="svc">
          <div class="svc-num">04</div>
          <div class="svc-title">Phẫu Thuật LASIK / SMILE</div>
          <div class="svc-desc">Chỉnh hình giác mạc bằng laser – chấm dứt phụ thuộc kính.</div>
        </div>
        <div class="svc">
          <div class="svc-num">05</div>
          <div class="svc-title">Điều Trị Glaucoma</div>
          <div class="svc-desc">Tăng nhãn áp góc mở, góc đóng; laser và phẫu thuật dò lọc.</div>
        </div>
        <div class="svc">
          <div class="svc-num">06</div>
          <div class="svc-title">Nhãn Nhi</div>
          <div class="svc-desc">Điều trị lác mắt, nhược thị, ROP, dị tật mắt bẩm sinh ở trẻ em.</div>
        </div>
        <div class="svc">
          <div class="svc-num">07</div>
          <div class="svc-title">Khúc Xạ Học</div>
          <div class="svc-desc">Đo và điều chỉnh tật khúc xạ: cận, viễn, loạn thị một cách chính xác.</div>
        </div>
        <div class="svc">
          <div class="svc-num">08</div>
          <div class="svc-title">Khám Theo Yêu Cầu</div>
          <div class="svc-desc">Dịch vụ VIP — phòng khám riêng, bác sĩ đầu ngành, không chờ đợi.</div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== DOCTORS ===== -->
  <section class="doctors-section">
    <div class="container-xl">
      <div class="row align-items-end mb-5">
        <div class="col-lg-6">
          <div class="section-label">Đội ngũ</div>
          <h2
            style="font-family:'Playfair Display',serif;font-size:clamp(28px,3vw,40px);font-weight:700;color:var(--navy)">
            Gặp gỡ những<br>chuyên gia hàng đầu</h2>
        </div>
        <div class="col-lg-6 text-lg-end">
          <a href="${pageContext.request.contextPath}/common/find-doctor"
            style="display:inline-flex;align-items:center;gap:8px;padding:12px 24px;border:1px solid var(--border);font-size:13px;font-weight:600;color:var(--navy);border-radius:4px;transition:all .2s">Xem
            tất cả bác sĩ <i class="fas fa-arrow-right"></i></a>
        </div>
      </div>
      <div class="doctors-grid">
        <div class="doc-card">
          <div class="doc-img">
            <img src="${pageContext.request.contextPath}/static/images/doctor-1.jpg" alt="TS. BS. Nguyễn Minh Tuấn">
            <div class="doc-overlay"><a href="${pageContext.request.contextPath}/common/find-doctor">Đặt lịch khám →</a></div>
          </div>
          <div class="doc-body">
            <div class="doc-name">TS. BS. Nguyễn Minh Tuấn</div>
            <div class="doc-spec">Chuyên khoa Võng mạc · 15 năm KN</div>
            <span class="doc-tag">★ 4.9 · 2,400 bệnh nhân</span>
          </div>
        </div>
        <div class="doc-card">
          <div class="doc-img">
            <img src="${pageContext.request.contextPath}/static/images/doctor-2.jpg" alt="PGS. BS. Lê Thị Hương">
            <div class="doc-overlay"><a href="${pageContext.request.contextPath}/common/find-doctor">Đặt lịch khám →</a></div>
          </div>
          <div class="doc-body">
            <div class="doc-name">PGS. BS. Lê Thị Hương</div>
            <div class="doc-spec">Phẫu thuật Cườm mắt · 18 năm KN</div>
            <span class="doc-tag">★ 4.8 · 3,100 bệnh nhân</span>
          </div>
        </div>
        <div class="doc-card">
          <div class="doc-img">
            <img src="${pageContext.request.contextPath}/static/images/doctor-3.jpg" alt="GS. BS. Trần Văn Đức">
            <div class="doc-overlay"><a href="${pageContext.request.contextPath}/common/find-doctor">Đặt lịch khám →</a></div>
          </div>
          <div class="doc-body">
            <div class="doc-name">GS. BS. Trần Văn Đức</div>
            <div class="doc-spec">Nhãn nhi & Lác mắt · 25 năm KN</div>
            <span class="doc-tag">★ 5.0 · 5,200 bệnh nhân</span>
          </div>
        </div>
        <div class="doc-card">
          <div class="doc-img">
            <img src="${pageContext.request.contextPath}/static/images/doctor-4.jpg" alt="BS. Phạm Thị Lan">
            <div class="doc-overlay"><a href="${pageContext.request.contextPath}/common/find-doctor">Đặt lịch khám →</a></div>
          </div>
          <div class="doc-body">
            <div class="doc-name">BS. Phạm Thị Lan</div>
            <div class="doc-spec">Khúc xạ học · 10 năm KN</div>
            <span class="doc-tag">★ 4.7 · 1,800 bệnh nhân</span>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== PROCESS ===== -->
  <section class="process-section">
    <div class="container-xl">
      <div class="section-label">Quy trình</div>
      <h2>Đặt lịch khám<br>chỉ trong 4 bước</h2>
      <div class="process-steps">
        <div class="pstep">
          <div class="pstep-num">01</div>
          <div class="pstep-title">Chọn chuyên khoa</div>
          <div class="pstep-desc">Tìm kiếm theo triệu chứng hoặc loại bệnh bạn cần tư vấn</div>
        </div>
        <div class="pstep">
          <div class="pstep-num">02</div>
          <div class="pstep-title">Chọn bác sĩ</div>
          <div class="pstep-desc">Xem hồ sơ, đánh giá từ bệnh nhân và chọn người phù hợp</div>
        </div>
        <div class="pstep">
          <div class="pstep-num">03</div>
          <div class="pstep-title">Chọn lịch hẹn</div>
          <div class="pstep-desc">Chọn ngày và khung giờ thuận tiện, xem slot còn trống theo thời gian thực</div>
        </div>
        <div class="pstep">
          <div class="pstep-num">04</div>
          <div class="pstep-title">Đến khám</div>
          <div class="pstep-desc">Nhận xác nhận qua SMS/email, đến đúng giờ và check-in bằng mã QR</div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== TESTIMONIALS ===== -->
  <section class="testimonials-section">
    <div class="container-xl">
      <div class="section-label">Đánh giá</div>
      <h2
        style="font-family:'Playfair Display',serif;font-size:clamp(26px,2.5vw,38px);font-weight:700;color:var(--navy);margin-bottom:48px">
        Bệnh nhân nói<br>về chúng tôi</h2>
      <div class="testimonials-grid">
        <div class="tcard">
          <div class="tcard-quote">"</div>
          <div class="stars">★★★★★</div>
          <p class="tcard-text">Dịch vụ tuyệt vời, bác sĩ giải thích rõ ràng từng bước điều trị. Đặt lịch online rất
            tiện, không phải xếp hàng chờ đợi lâu như bệnh viện công thông thường.</p>
          <div class="tcard-person">
            <div class="tcard-avatar">NT</div>
            <div>
              <div class="tcard-name">Nguyễn Thị Thanh</div>
              <div class="tcard-meta">Bệnh nhân cườm mắt · Hà Nội</div>
            </div>
          </div>
        </div>
        <div class="tcard">
          <div class="tcard-quote">"</div>
          <div class="stars">★★★★★</div>
          <p class="tcard-text">Con tôi bị lác mắt từ nhỏ, sau 6 tháng điều trị tại đây đã gần như khỏi hoàn toàn. GS.
            Đức rất tận tâm và kiên nhẫn với trẻ em. Tôi thực sự biết ơn.</p>
          <div class="tcard-person">
            <div class="tcard-avatar">TH</div>
            <div>
              <div class="tcard-name">Trần Văn Hùng</div>
              <div class="tcard-meta">Phụ huynh bệnh nhi · Nam Định</div>
            </div>
          </div>
        </div>
        <div class="tcard">
          <div class="tcard-quote">"</div>
          <div class="stars">★★★★★</div>
          <p class="tcard-text">Phẫu thuật LASIK tại đây, chỉ sau 1 tuần tôi đã thấy rõ ràng mà không cần kính. Quy
            trình chuyên nghiệp, trang thiết bị hiện đại, nhân viên thân thiện.</p>
          <div class="tcard-person">
            <div class="tcard-avatar">LP</div>
            <div>
              <div class="tcard-name">Lê Minh Phúc</div>
              <div class="tcard-meta">Bệnh nhân LASIK · TP.HCM</div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== CTA ===== -->
  <section class="cta-banner">
    <div class="container-xl">
      <h2>Bảo vệ thị giác ngay hôm nay</h2>
      <p>Đừng để bệnh mắt tiến triển — đặt lịch khám định kỳ là cách tốt nhất để bảo vệ đôi mắt</p>
      <a href="${pageContext.request.contextPath}/auth/login" class="btn-cta-white"><i class="fas fa-calendar-check"></i> Đặt lịch khám ngay</a>
      <a href="tel:18001234" class="btn-cta-dark"><i class="fas fa-phone"></i> Gọi 1800 1234</a>
    </div>
  </section>

  <!-- ===== FOOTER ===== -->
  <footer>
    <div class="footer-grid">
      <div class="footer-brand">
        <div style="display:flex;align-items:center;gap:10px">
          <div
            style="width:36px;height:36px;background:var(--gold);border-radius:6px;display:flex;align-items:center;justify-content:center">
            <svg viewBox="0 0 24 24" style="width:20px;height:20px;fill:#fff">
              <path
                d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z" />
            </svg>
          </div>
        </div>
        <div class="fb-name">Bệnh Viện Mắt PTIT</div>
        <p>Trung tâm điều trị nhãn khoa hàng đầu miền Bắc, trực thuộc Trường PTIT.</p>
      </div>
      <div class="footer-col">
        <h6>Dịch vụ</h6>
        <ul>
          <li><a href="#">Khám tổng quát</a></li>
          <li><a href="#">Phẫu thuật cườm</a></li>
          <li><a href="#">Điều trị võng mạc</a></li>
          <li><a href="#">Phẫu thuật LASIK</a></li>
          <li><a href="#">Nhãn nhi</a></li>
        </ul>
      </div>
      <div class="footer-col">
        <h6>Thông tin</h6>
        <ul>
          <li><a href="#">Giới thiệu</a></li>
          <li><a href="${pageContext.request.contextPath}/common/find-doctor">Đội ngũ bác sĩ</a></li>
          <li><a href="#">Tin tức y tế</a></li>
          <li><a href="#">Bảng giá</a></li>
          <li><a href="#">Tuyển dụng</a></li>
        </ul>
      </div>
      <div class="footer-col footer-contact">
        <h6>Liên hệ</h6>
        <ul>
          <li><i class="fas fa-location-dot"></i><span>01 Tôn Thất Tùng, Đống Đa, Hà Nội</span></li>
          <li><i class="fas fa-phone"></i><span>1800 1234 (Miễn phí)</span></li>
          <li><i class="fas fa-envelope"></i><span>info@bvmatptit.edu.vn</span></li>
          <li><i class="fas fa-clock"></i><span>7:00 – 17:30 · Thứ 2 – Thứ 7</span></li>
        </ul>
      </div>
    </div>
    <div class="footer-bottom">
      <span>© 2024 Bệnh Viện Mắt PTIT. All rights reserved.</span>
      <span>Phát triển bởi BTL LTW Team</span>
    </div>
  </footer>

  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>

</html>
