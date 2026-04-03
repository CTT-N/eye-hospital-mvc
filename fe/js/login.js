// login.js — Role selection, password toggle, and form submit state

function selectRole(btn, role) {
  document.querySelectorAll('.role-tab').forEach(t => t.classList.remove('active'));
  btn.classList.add('active');
  document.getElementById('roleInput').value = role;
}

function togglePassword() {
  const pwInput = document.getElementById('password');
  const icon = document.getElementById('eyeIcon');
  if (pwInput.type === 'password') {
    pwInput.type = 'text';
    icon.className = 'fas fa-eye-slash';
  } else {
    pwInput.type = 'password';
    icon.className = 'fas fa-eye';
  }
}

document.addEventListener('DOMContentLoaded', function () {
  document.getElementById('loginForm').addEventListener('submit', function () {
    const btn = document.getElementById('submitBtn');
    btn.innerHTML = '<span class="spinner-h"></span> Đang đăng nhập...';
    btn.disabled = true;
  });
});
