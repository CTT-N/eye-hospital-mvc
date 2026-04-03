// book-appointment.js — Date grid, specialty/doctor/time selection, and booking

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
      const yyyy = d.getFullYear();
      const mm   = String(d.getMonth() + 1).padStart(2, '0');
      const dd   = String(d.getDate()).padStart(2, '0');
      document.getElementById('hidDate').value = `${yyyy}-${mm}-${dd}`;
    };
  }
  dateGrid.appendChild(btn);
}

const tomorrow = new Date(today);
tomorrow.setDate(today.getDate() + 1);

// Pre-select tomorrow's date in hidden input
(function () {
  const d = tomorrow;
  const yyyy = d.getFullYear();
  const mm   = String(d.getMonth() + 1).padStart(2, '0');
  const dd   = String(d.getDate()).padStart(2, '0');
  document.getElementById('hidDate').value = `${yyyy}-${mm}-${dd}`;
})();

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

function selectDoc(el, doctorId, fullName) {
  document.querySelectorAll('.doc-pick-item').forEach(i => i.classList.remove('selected'));
  el.classList.add('selected');
  document.getElementById('sumDoc').textContent = fullName || doctorId;
  document.getElementById('hidDoctorId').value = doctorId;
}

function selectTime(el) {
  if (el.classList.contains('full')) return;
  document.querySelectorAll('.time-btn').forEach(b => b.classList.remove('selected'));
  el.classList.add('selected');
  const t = el.textContent.trim();
  document.getElementById('sumTime').textContent = t;
  document.getElementById('hidTime').value = t;
}

// Pre-select the default time shown as selected in the markup
(function () {
  const defaultTime = document.querySelector('.time-btn.selected');
  if (defaultTime) {
    document.getElementById('hidTime').value = defaultTime.textContent.trim();
  }
})();

function confirmBooking() {
  const doctorId = document.getElementById('hidDoctorId').value;
  const date     = document.getElementById('hidDate').value;
  const time     = document.getElementById('hidTime').value;
  if (!doctorId) {
    alert('Vui lòng chọn bác sĩ.');
    return false;
  }
  if (!date) {
    alert('Vui lòng chọn ngày khám.');
    return false;
  }
  if (!time) {
    alert('Vui lòng chọn giờ khám.');
    return false;
  }
  return true;
}
