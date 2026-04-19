// manager-invoices.js — invoice detail modal

function openInvoiceModal(id) {
  var inv = invoiceData[id];
  if (!inv) return;

  document.getElementById('modalTitle').textContent = 'Hóa đơn #' + id;
  document.getElementById('mId').textContent         = '#' + id;
  document.getElementById('mDate').textContent       = inv.date;
  document.getElementById('mPatient').textContent    = inv.patient || '—';
  document.getElementById('mDoctor').textContent     = inv.doctor  || '—';
  document.getElementById('mTotal').textContent      = inv.total.toLocaleString('vi-VN') + ' ₫';
  var tbody = document.getElementById('mServiceBody');
  tbody.innerHTML = inv.services.map(function(s) {
    return '<tr><td>' + s[0] + '</td><td>' + s[1] + '</td><td style="text-align:right">' + s[2].toLocaleString('vi-VN') + ' ₫</td></tr>';
  }).join('');
  document.getElementById('invoiceModal').classList.add('open');
}

function closeInvoiceModal() {
  document.getElementById('invoiceModal').classList.remove('open');
}

document.addEventListener('DOMContentLoaded', function() {
  document.getElementById('invoiceModal').addEventListener('click', function(e) {
    if (e.target === this) closeInvoiceModal();
  });
});
