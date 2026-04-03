// patient-invoices.js — Invoice detail modal

function openInvoice(id, date, doctor, services, total) {
  document.getElementById('modalInvoiceTitle').textContent = 'Hóa đơn #' + id;
  document.getElementById('modalId').textContent     = '#' + id;
  document.getElementById('modalDate').textContent   = date;
  document.getElementById('modalDoctor').textContent = doctor;
  document.getElementById('modalTotal').textContent  = total + ' ₫';
  const tbody = document.getElementById('modalServiceBody');
  tbody.innerHTML = services.map(([name, price]) =>
    `<tr><td>${name}</td><td style="text-align:right">${price} ₫</td></tr>`
  ).join('');
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
