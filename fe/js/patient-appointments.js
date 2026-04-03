// patient-appointments.js — Tab filter and cancel appointment modal

function filterTab(btn, status) {
  document.querySelectorAll('.tab-nav-h .tab-btn').forEach(b => b.classList.remove('active'));
  btn.classList.add('active');
  document.querySelectorAll('#apptTable tbody tr').forEach(row => {
    row.style.display = (status === 'all' || row.dataset.status === status) ? '' : 'none';
  });
}

let cancelTarget = null;

function openCancel(btn) {
  cancelTarget = btn.closest('tr');
  document.getElementById('cancelOverlay').classList.add('open');
}

function closeCancel() {
  document.getElementById('cancelOverlay').classList.remove('open');
  cancelTarget = null;
}

function confirmCancel() {
  if (cancelTarget) {
    const statusCell = cancelTarget.querySelector('.badge-status');
    statusCell.className = 'badge-status badge-cancelled';
    statusCell.textContent = 'Đã huỷ';
    cancelTarget.dataset.status = 'cancelled';
    const actionCell = cancelTarget.querySelector('.action-cell');
    actionCell.innerHTML = '<span style="font-size:12px;color:var(--text-muted)">—</span>';
  }
  closeCancel();
}

document.addEventListener('DOMContentLoaded', function () {
  document.getElementById('cancelOverlay').addEventListener('click', function (e) {
    if (e.target === this) closeCancel();
  });
});
