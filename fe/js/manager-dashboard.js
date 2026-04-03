// manager-dashboard.js — Revenue and status charts

const ctx1 = document.getElementById('revenueChart').getContext('2d');
new Chart(ctx1, {
  type: 'bar',
  data: {
    labels: ['T10/24', 'T11/24', 'T12/24', 'T1/25', 'T2/25', 'T3/25'],
    datasets: [
      {
        label: 'Doanh thu (triệu VNĐ)',
        data: [2100, 2350, 2800, 2200, 2780, 3200],
        backgroundColor: 'rgba(37, 99, 168, 0.85)',
        borderRadius: 6,
        borderSkipped: false,
      },
      {
        label: 'Lịch hẹn',
        data: [980, 1100, 1320, 1050, 1240, 1284],
        backgroundColor: 'rgba(14, 165, 233, 0.75)',
        borderRadius: 6,
        borderSkipped: false,
        yAxisID: 'y1',
      },
    ],
  },
  options: {
    responsive: true,
    maintainAspectRatio: false,
    plugins: { legend: { position: 'top', labels: { font: { family: 'Inter', size: 12 }, boxWidth: 12 } } },
    scales: {
      x:  { grid: { display: false }, ticks: { font: { family: 'Inter', size: 12 } } },
      y:  { grid: { color: '#F1F5F9' }, ticks: { font: { family: 'Inter', size: 12 } } },
      y1: { position: 'right', grid: { display: false }, ticks: { font: { family: 'Inter', size: 12 } } },
    },
  },
});

const ctx2 = document.getElementById('statusChart').getContext('2d');
new Chart(ctx2, {
  type: 'doughnut',
  data: {
    labels: ['Hoàn thành', 'Xác nhận', 'Chờ xác nhận', 'Đã hủy'],
    datasets: [{
      data: [698, 321, 183, 84],
      backgroundColor: ['#16A34A', '#2563A8', '#D97706', '#DC2626'],
      borderWidth: 0,
      hoverOffset: 4,
    }],
  },
  options: {
    responsive: true,
    maintainAspectRatio: false,
    plugins: {
      legend: { display: false },
      tooltip: { callbacks: { label: ctx => `${ctx.label}: ${ctx.parsed}` } },
    },
    cutout: '70%',
  },
});
