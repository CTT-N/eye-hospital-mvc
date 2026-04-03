
// find-doctor.js — Doctor data, render, and filter logic

const doctors = [
  { name: 'TS. BS. Nguyễn Minh Tuấn', spec: 'Võng mạc',  years: '15 năm KN', rating: '4.9', patients: '2,400', img: 'images/doctor-1.jpg', avail: 'open' },
  { name: 'PGS. BS. Lê Thị Hương',    spec: 'Cườm mắt',  years: '18 năm KN', rating: '4.8', patients: '3,100', img: 'images/doctor-2.jpg', avail: 'open' },
  { name: 'GS. BS. Trần Văn Đức',      spec: 'Nhãn nhi',  years: '25 năm KN', rating: '5.0', patients: '5,200', img: 'images/doctor-3.jpg', avail: 'full' },
  { name: 'BS. Phạm Thị Lan',          spec: 'Khúc xạ',   years: '10 năm KN', rating: '4.7', patients: '1,800', img: 'images/doctor-4.jpg', avail: 'open' },
  { name: 'TS. BS. Hoàng Minh Đức',    spec: 'Glaucoma',  years: '12 năm KN', rating: '4.8', patients: '2,100', img: 'images/doctor-1.jpg', avail: 'open' },
  { name: 'BS. Vũ Thị Mai',            spec: 'LASIK',     years: '8 năm KN',  rating: '4.9', patients: '1,500', img: 'images/doctor-2.jpg', avail: 'full' },
  { name: 'PGS. BS. Nguyễn Thị Lan',   spec: 'Võng mạc',  years: '20 năm KN', rating: '4.8', patients: '4,000', img: 'images/doctor-3.jpg', avail: 'open' },
  { name: 'TS. BS. Đặng Văn Hùng',     spec: 'Cườm mắt',  years: '14 năm KN', rating: '4.7', patients: '2,600', img: 'images/doctor-4.jpg', avail: 'open' },
];

function renderDoctors(list) {
  const grid = document.getElementById('docGrid');
  document.getElementById('docCount').textContent = 'Hiển thị ' + list.length + ' bác sĩ';
  if (!list.length) {
    grid.innerHTML = '<div class="no-results" style="grid-column:1/-1"><i class="fas fa-user-doctor fa-2x" style="margin-bottom:16px;opacity:.3"></i><br>Không tìm thấy bác sĩ phù hợp</div>';
    return;
  }
  grid.innerHTML = list.map(d => `
    <div class="doc-card-v2">
      <div class="doc-photo">
        <img src="${d.img}" alt="${d.name}" loading="lazy">
        <div class="avail-badge ${d.avail}">${d.avail === 'open' ? 'Còn lịch trống' : 'Hết lịch hôm nay'}</div>
      </div>
      <div class="doc-info">
        <div class="name">${d.name}</div>
        <div class="spec">Chuyên khoa ${d.spec}</div>
        <div class="tags"><span class="tag">${d.spec}</span><span class="tag">${d.years}</span></div>
        <div class="doc-meta">
          <div class="rating"><i class="fas fa-star"></i> ${d.rating}</div>
          <div class="patients">${d.patients} bệnh nhân</div>
        </div>
        ${d.avail === 'open'
          ? `<a href="../auth/login" class="btn-book-sm"><i class="fas fa-calendar-plus"></i> Đặt lịch ngay</a>`
          : `<button class="btn-book-sm" style="background:#9CA3AF;cursor:not-allowed" disabled>Hết lịch hôm nay</button>`
        }
      </div>
    </div>
  `).join('');
}

function filterDoctors() {
  const q     = document.getElementById('searchInput').value.toLowerCase();
  const spec  = document.getElementById('specFilter').value;
  const avail = document.getElementById('availFilter').value;
  const filtered = doctors.filter(d =>
    d.name.toLowerCase().includes(q) &&
    (!spec  || d.spec  === spec) &&
    (!avail || d.avail === avail)
  );
  renderDoctors(filtered);
}

renderDoctors(doctors);
