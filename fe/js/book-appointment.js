// book-appointment.js — Date grid, specialty/doctor/time selection, and booking confirmation

const days = ['CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'];
const dateGrid = document.getElementById('dateGrid');
const today = new Date();

for (let i = 0; i < 7; i++) {
  const d = new Date(today);
  d.setDate(today.getDate() + i);
  const btn = document.createElement('div');
  btn.className = 'date-btn' + (i === 1 ? ' selected' : '') + (i === 0 ? ' disabled' : '');
  btn.innerHTML = `<div class="d-day">${days[d.getDay()]}</div><div class="d-num">${d.getDate()}</div>`;
  if (i > 0) {
    btn.onclick = function () {
      document.querySelectorAll('.date-btn').forEach(b => b.classList.remove('selected'));
      this.classList.add('selected');
      updateSummaryDate(d);
    };
  }
  dateGrid.appendChild(btn);
}

const tomorrow = new Date(today);
tomorrow.setDate(today.getDate() + 1);

function updateSummaryDate(d) {
  const dayNames = ['Chủ Nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy'];
  document.getElementById('sumDate').textContent = dayNames[d.getDay()] + ', ' + d.toLocaleDateString('vi-VN');
}

updateSummaryDate(tomorrow);

function selectSpec(el) {
  document.querySelectorAll('.spec-item').forEach(i => i.classList.remove('selected'));
  el.classList.add('selected');
  document.getElementById('sumSpec').textContent = el.querySelector('.si-name').textContent;
}

function selectDoc(el, name) {
  document.querySelectorAll('.doc-pick-item').forEach(i => i.classList.remove('selected'));
  el.classList.add('selected');
  document.getElementById('sumDoc').textContent = name;
}

function selectTime(el) {
  if (el.classList.contains('full')) return;
  document.querySelectorAll('.time-btn').forEach(b => b.classList.remove('selected'));
  el.classList.add('selected');
  document.getElementById('sumTime').textContent = el.textContent.trim();
}

function confirmBooking() {
  alert('✅ Đặt lịch thành công!\n\nXác nhận sẽ được gửi qua SMS và Email của bạn trong vài phút tới.\n\nCảm ơn bạn đã tin tưởng BV Mắt PTIT!');
}
