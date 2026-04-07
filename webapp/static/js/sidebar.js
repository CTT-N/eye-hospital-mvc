// sidebar.js — Shared sidebar toggle for all dashboard pages
document.addEventListener('DOMContentLoaded', function () {
  const toggle = document.getElementById('sidebarToggle');
  if (toggle) {
    toggle.addEventListener('click', function () {
      document.querySelector('.sidebar').classList.toggle('open');
    });
  }
});
