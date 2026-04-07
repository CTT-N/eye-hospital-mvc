// doctor-patient-list.js — Patient table filter

function filterPatients(q) {
  const rows = document.querySelectorAll('#patientTable tbody tr');
  rows.forEach(row => {
    const name = row.querySelector('div[style*="font-weight"]')?.textContent.toLowerCase() || '';
    row.style.display = name.includes(q.toLowerCase()) ? '' : 'none';
  });
}
