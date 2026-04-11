// manager-reports.js — Tab switching and Chart.js report charts

function switchTab(btn, tabId) {
  document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
  document.querySelectorAll('.tab-pane-h').forEach(p => p.classList.remove('active'));
  btn.classList.add('active');
  document.getElementById(tabId).classList.add('active');
}

const labels = ['1/3', '5/3', '10/3', '15/3', '20/3', '25/3', '30/3'];
const colors = { navy: '#1B3A6B', gold: '#C9A227', teal: '#0D9488', green: '#16A34A' };

Chart.defaults.font.family = 'Inter, sans-serif';
Chart.defaults.color = '#6B7280';

const chartPatient = new Chart(document.getElementById('chartPatient'), {
  type: 'bar',
  data: {
    labels,
    datasets: [{ label: 'Lượt khám', data: [12, 19, 15, 25, 22, 30, 18], backgroundColor: colors.navy + 'CC', borderRadius: 6 }],
  },
  options: { responsive: true, plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true } } },
});

const chartRevenue = new Chart(document.getElementById('chartRevenue'), {
  type: 'line',
  data: {
    labels,
    datasets: [{
      label: 'Doanh thu (triệu)',
      data: [4.5, 7.2, 5.8, 9.6, 8.2, 12.4, 6.9],
      borderColor: colors.gold, backgroundColor: colors.gold + '22',
      fill: true, tension: 0.4, pointRadius: 5, pointBackgroundColor: colors.gold,
    }],
  },
  options: { responsive: true, plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true } } },
});

const chartDoctor = new Chart(document.getElementById('chartDoctor'), {
  type: 'bar',
  data: {
    labels: ['BS. Trần Thị Mai', 'BS. Lê Hoàng Nam', 'BS. Phạm Thị Lan', 'BS. Nguyễn Đ. Hùng'],
    datasets: [{
      label: 'Ca khám',
      data: [95, 72, 63, 88],
      backgroundColor: [colors.navy + 'CC', colors.gold + 'CC', colors.teal + 'CC', colors.green + 'CC'],
      borderRadius: 6,
    }],
  },
  options: { indexAxis: 'y', responsive: true, plugins: { legend: { display: false } }, scales: { x: { beginAtZero: true } } },
});

const chartDept = new Chart(document.getElementById('chartDept'), {
  type: 'doughnut',
  data: {
    labels: ['Giác mạc', 'Võng mạc', 'Mắt trẻ em', 'Nhãn áp', 'Khúc xạ', 'Laser'],
    datasets: [{ data: [38, 22, 15, 12, 8, 5], backgroundColor: ['#1B3A6B', '#C9A227', '#0D9488', '#16A34A', '#7C3AED', '#EA580C'] }],
  },
  options: { responsive: true, plugins: { legend: { position: 'right' } } },
});

function updateCharts() {
  const mult = { week: 0.25, month: 1, year: 12 };
  const m = mult[document.getElementById('periodFilter').value];
  chartPatient.data.datasets[0].data = [12, 19, 15, 25, 22, 30, 18].map(v => Math.round(v * m));
  chartPatient.update();
  chartRevenue.data.datasets[0].data = [4.5, 7.2, 5.8, 9.6, 8.2, 12.4, 6.9].map(v => +(v * m).toFixed(1));
  chartRevenue.update();
}
