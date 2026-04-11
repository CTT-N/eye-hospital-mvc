// admin-users.js — User management CRUD (backend-connected)

let deleteTargetId = '';

function applyFilters() {
  const q = document.getElementById('searchInput').value.toLowerCase();
  const roleFilter = document.getElementById('filterRole').value.toLowerCase();
  document.querySelectorAll('#userBody tr').forEach(row => {
    const text = row.textContent.toLowerCase();
    const badge = row.querySelector('.badge-status');
    const rowRole = badge ? badge.textContent.trim().toLowerCase() : '';
    const matchQ = !q || text.includes(q);
    const matchRole = !roleFilter || rowRole.includes(roleFilter);
    row.style.display = (matchQ && matchRole) ? '' : 'none';
  });
}

function openModal() {
  document.getElementById('editIndex').value = '';
  document.getElementById('modalTitle').textContent = 'Thêm người dùng';
  document.getElementById('formError').style.display = 'none';
  document.getElementById('passwordField').style.display = '';
  ['uName', 'uUsername', 'uEmail', 'uPassword'].forEach(id => document.getElementById(id).value = '');
  document.getElementById('uRole').value = '';
  document.getElementById('userModal').classList.add('open');
}

function editUser(userId, fullName, username, email, role) {
  document.getElementById('editIndex').value = userId;
  document.getElementById('modalTitle').textContent = 'Sửa người dùng';
  document.getElementById('formError').style.display = 'none';
  document.getElementById('passwordField').style.display = 'none';
  document.getElementById('uName').value = fullName;
  document.getElementById('uUsername').value = username;
  document.getElementById('uEmail').value = email;
  document.getElementById('uRole').value = role.toLowerCase();
  document.getElementById('userModal').classList.add('open');
}

function closeModal() { document.getElementById('userModal').classList.remove('open'); }

function saveUser() {
  const name     = document.getElementById('uName').value.trim();
  const username = document.getElementById('uUsername').value.trim();
  const email    = document.getElementById('uEmail').value.trim();
  const role     = document.getElementById('uRole').value;
  const userId   = document.getElementById('editIndex').value;
  const errEl    = document.getElementById('formError');

  if (!name || !username || !email || !role) {
    errEl.textContent = 'Vui lòng điền đầy đủ thông tin bắt buộc.';
    errEl.style.display = '';
    return;
  }

  const params = new URLSearchParams();
  if (!userId) {
    const pwd = document.getElementById('uPassword').value;
    if (!pwd || pwd.length < 6) {
      errEl.textContent = 'Mật khẩu phải có ít nhất 6 ký tự.';
      errEl.style.display = '';
      return;
    }
    params.append('action',   'add');
    params.append('fullName', name);
    params.append('username', username);
    params.append('email',    email);
    params.append('password', pwd);
    params.append('role',     role);
  } else {
    params.append('action', 'updateRole');
    params.append('userId', userId);
    params.append('role',   role);
  }

  closeModal();
  fetch(window.location.pathname, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: params.toString()
  }).then(() => window.location.reload());
}

function deleteUser(userId, fullName) {
  deleteTargetId = userId;
  document.getElementById('deleteTargetName').textContent = fullName;
  document.getElementById('deleteOverlay').classList.add('open');
}

function closeDelete() { document.getElementById('deleteOverlay').classList.remove('open'); }

function confirmDelete() {
  const params = new URLSearchParams();
  params.append('action', 'delete');
  params.append('userId', deleteTargetId);
  closeDelete();
  fetch(window.location.pathname, {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: params.toString()
  }).then(() => window.location.reload());
}

document.addEventListener('DOMContentLoaded', function () {
  [document.getElementById('userModal'), document.getElementById('deleteOverlay')].forEach(el => {
    if (el) el.addEventListener('click', e => { if (e.target === el) el.classList.remove('open'); });
  });
});
