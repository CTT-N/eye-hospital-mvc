// manager-dashboard.js — Revenue and status charts using real DB data

const monthly = window.dashboardMonthly || { labels: [], data: [] };

const ctx1 = document.getElementById('revenueChart').getContext('2d');
new Chart(ctx1, {
  type: 'bar',
  data: {
    labels: monthly.labels,
    datasets: [
      {
        label: 'Số lịch hẹn',
        data: monthly.data,
        backgroundColor: 'rgba(37, 99, 168, 0.85)',
        borderRadius: 6,
        borderSkipped: false,
      },
    ],
  },
  options: {
    responsive: true,
    maintainAspectRatio: false,
    plugins: { legend: { position: 'top', labels: { font: { family: 'Inter', size: 12 }, boxWidth: 12 } } },
    scales: {
      x: { grid: { display: false }, ticks: { font: { family: 'Inter', size: 12 } } },
      y: { grid: { color: '#F1F5F9' }, ticks: { font: { family: 'Inter', size: 12 } }, beginAtZero: true },
    },
  },
});

const ctx2 = document.getElementById('statusChart').getContext('2d');
new Chart(ctx2, {
  type: 'doughnut',
  data: {
    labels: ['Hoàn thành', 'Xác nhận', 'Chờ xác nhận', 'Đã hủy'],
    datasets: [{
      data: window.dashboardStatusData || [0, 0, 0, 0],
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
