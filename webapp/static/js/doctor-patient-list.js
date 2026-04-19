// doctor-patient-list.js — Patient table filter

function filterPatients(q) {
  const keyword = q.trim().toLowerCase();
  const rows = document.querySelectorAll('#patientTable tbody tr');
  rows.forEach(row => {
    const content = row.textContent.toLowerCase();
    row.style.display = content.includes(keyword) ? '' : 'none';
  });
}
