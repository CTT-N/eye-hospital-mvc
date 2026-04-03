// doctor-patient-record.js — Accordion toggle, save, and complete consultation modal

function toggleAcc(header) {
  header.parentElement.classList.toggle('open');
}

function saveRecord() {
  const required = ['symptoms', 'clinical', 'diagnosis', 'treatment'];
  const empty = required.filter(id => !document.getElementById(id).value.trim());
  if (empty.length) { alert('Vui lòng điền đầy đủ các trường bắt buộc.'); return; }
  alert('Hồ sơ đã được lưu thành công!');
}

function openComplete() {
  const required = ['symptoms', 'clinical', 'diagnosis', 'treatment'];
  const empty = required.filter(id => !document.getElementById(id).value.trim());
  if (empty.length) { alert('Vui lòng điền đầy đủ phiếu khám trước khi hoàn tất.'); return; }
  document.getElementById('completeOverlay').classList.add('open');
}

function closeComplete() {
  document.getElementById('completeOverlay').classList.remove('open');
}

function confirmComplete() {
  closeComplete();
  alert('Buổi khám đã hoàn tất. Hóa đơn đã được tạo!');
  window.location.href = 'patients';
}

document.addEventListener('DOMContentLoaded', function () {
  document.getElementById('completeOverlay').addEventListener('click', function (e) {
    if (e.target === this) closeComplete();
  });
});
