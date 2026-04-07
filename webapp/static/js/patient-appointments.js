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
    const appointmentId = cancelTarget.dataset.id;
    if (appointmentId) {
      const form = document.createElement('form');
      form.method = 'post';
      form.action = document.querySelector('base')
        ? document.querySelector('base').href.replace(/\/$/, '') + '/patient/history'
        : window.location.pathname.replace(/\/patient\/.*/, '') + '/patient/history';
      const actionInput = document.createElement('input');
      actionInput.type = 'hidden';
      actionInput.name = 'action';
      actionInput.value = 'cancel';
      const idInput = document.createElement('input');
      idInput.type = 'hidden';
      idInput.name = 'appointmentId';
      idInput.value = appointmentId;
      form.appendChild(actionInput);
      form.appendChild(idInput);
      document.body.appendChild(form);
      form.submit();
      return;
    }
  }
  closeCancel();
}

document.addEventListener('DOMContentLoaded', function () {
  document.getElementById('cancelOverlay').addEventListener('click', function (e) {
    if (e.target === this) closeCancel();
  });
});
