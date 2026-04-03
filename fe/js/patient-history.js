// patient-history.js — Toggle medical record detail panels

function toggleRecord(id, btn) {
  const content = document.getElementById(id);
  const isOpen  = content.classList.toggle('open');
  btn.innerHTML = isOpen
    ? '<i class="fas fa-chevron-up"></i> Ẩn chi tiết'
    : '<i class="fas fa-chevron-down"></i> Xem chi tiết';
}
