// patient-invoices.js — Invoice detail modal

function openInvoice(id) {
  var inv = invoiceData[id];
  if (!inv) {
    return;
  }

  document.getElementById('modalInvoiceTitle').textContent = 'Hóa đơn #' + id;
  document.getElementById('modalId').textContent     = '#' + id;
  document.getElementById('modalDate').textContent   = inv.date;
  document.getElementById('modalDoctor').textContent = inv.doctor || '—';
  document.getElementById('modalTotal').textContent  = inv.total.toLocaleString('vi-VN') + ' ₫';
  const tbody = document.getElementById('modalServiceBody');
  tbody.innerHTML = inv.services.map(function (service) {
    return '<tr><td>' + service[0] + '</td><td style="text-align:right">' + service[1].toLocaleString('vi-VN') + ' ₫</td></tr>';
  }).join('');
  document.getElementById('invoiceModal').classList.add('open');
}

function closeInvoice() {
  document.getElementById('invoiceModal').classList.remove('open');
}

document.addEventListener('DOMContentLoaded', function () {
  document.getElementById('invoiceModal').addEventListener('click', function (e) {
    if (e.target === this) closeInvoice();
  });
});
