// doctor-schedule.js — Day navigation for doctor schedule view

const days = ['Chủ Nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy'];
let current = new Date();
current.setHours(0, 0, 0, 0);

function updateDisplay() {
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  const diff  = Math.round((current - today) / 86400000);
  const dayLabel = diff === 0 ? 'Hôm nay' : diff === 1 ? 'Ngày mai' : diff === -1 ? 'Hôm qua' : days[current.getDay()];
  const d = current.getDate().toString().padStart(2, '0');
  const m = (current.getMonth() + 1).toString().padStart(2, '0');
  const y = current.getFullYear();
  document.getElementById('dayLabel').textContent = dayLabel;
  document.getElementById('dateFull').textContent = `${days[current.getDay()]}, ${d}/${m}/${y}`;
  document.getElementById('datePicker').value = `${y}-${m}-${d}`;
}

function changeDay(delta) {
  current.setDate(current.getDate() + delta);
  updateDisplay();
}

function pickDate(val) {
  current = new Date(val);
  updateDisplay();
}
