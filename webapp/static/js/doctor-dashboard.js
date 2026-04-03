// doctor-dashboard.js — Patient item selection

document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('.patient-item').forEach(item => {
    item.addEventListener('click', function () {
      document.querySelectorAll('.patient-item').forEach(i => i.classList.remove('selected'));
      this.classList.add('selected');
    });
  });
});
