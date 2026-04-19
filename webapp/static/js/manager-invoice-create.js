// manager-invoice-create.js — realtime total calculation

document.addEventListener('DOMContentLoaded', function () {
  function recalc() {
    var total = 0;

    document.querySelectorAll('#svcTable tbody tr').forEach(function (row) {
      var checkbox = row.querySelector('.svc-check');
      var quantity = parseInt(row.querySelector('.svc-qty').value, 10) || 1;
      var price = parseFloat(row.dataset.price) || 0;
      var cell = row.querySelector('.row-total');

      if (checkbox && checkbox.checked) {
        var amount = price * quantity;
        total += amount;
        cell.textContent = amount.toLocaleString('vi-VN') + ' ₫';
      } else {
        cell.textContent = '—';
      }
    });

    document.getElementById('totalDisplay').textContent = total.toLocaleString('vi-VN') + ' ₫';
  }

  document.querySelectorAll('.svc-check').forEach(function (checkbox) {
    checkbox.addEventListener('change', recalc);
  });

  document.querySelectorAll('.svc-qty').forEach(function (input) {
    input.addEventListener('input', function () {
      if (parseInt(this.value, 10) < 1 || isNaN(parseInt(this.value, 10))) {
        this.value = 1;
      }
      recalc();
    });
  });

  document.querySelector('form').addEventListener('submit', function (e) {
    if (!document.querySelector('.svc-check:checked')) {
      e.preventDefault();
      alert('Vui lòng chọn ít nhất một dịch vụ.');
    }
  });
});
