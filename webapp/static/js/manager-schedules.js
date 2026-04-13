// manager-schedules.js — filter against server-rendered appointment data

function applyFilters() {
  const q = document.getElementById('searchInput').value.toLowerCase();
  const statusFilter = document.getElementById('filterStatus').value;
  const dateFilter = document.getElementById('filterDate').value;

  const rows = document.querySelectorAll('#schedBody tr');
  rows.forEach(row => {
    const text = row.textContent.toLowerCase();
    const statusCell = row.querySelector('td[data-status]');
    const rowStatus = statusCell ? statusCell.getAttribute('data-status') : '';
    const dateCell = row.cells[0] ? row.cells[0].textContent.trim() : '';

    const matchQ = !q || text.includes(q);
    const matchStatus = !statusFilter || rowStatus === statusFilter;
    const matchDate = !dateFilter || dateCell === dateFilter;

    row.style.display = (matchQ && matchStatus && matchDate) ? '' : 'none';
  });
}
