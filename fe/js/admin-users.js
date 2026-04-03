// admin-users.js — User management CRUD

const roleLabel = { admin: 'Admin', manager: 'Manager', doctor: 'Doctor', patient: 'Patient' };
const roleBadge = { admin: 'badge-admin', manager: 'badge-manager', doctor: 'badge-doctor', patient: 'badge-patient' };
const avatarColors = { admin: 'var(--danger)', manager: '#7C3AED', doctor: 'var(--primary)', patient: 'var(--success)' };

let users = [
  { name: 'Admin Hệ thống',     username: 'admin',       email: 'admin@bvmatptit.edu.vn',    role: 'admin',   status: 'active' },
  { name: 'Nguyễn Thị Quỳnh',   username: 'ntquynh',     email: 'ntquynh@bvmatptit.edu.vn',  role: 'manager', status: 'active' },
  { name: 'BS. Trần Thị Mai',   username: 'bs.tranmai',  email: 'bs.tranmai@bvmatptit.edu.vn', role: 'doctor', status: 'active' },
  { name: 'BS. Lê Hoàng Nam',   username: 'bs.lhnam',    email: 'bs.lhnam@bvmatptit.edu.vn', role: 'doctor',  status: 'active' },
  { name: 'BS. Phạm Thị Lan',   username: 'bs.ptlan',    email: 'bs.ptlan@bvmatptit.edu.vn', role: 'doctor',  status: 'active' },
  { name: 'Nguyễn Văn An',       username: 'nguyenvanan', email: 'vanaan@gmail.com',           role: 'patient', status: 'active' },
  { name: 'Phạm Thị Hương',     username: 'phamhuong',   email: 'huong.pham@gmail.com',       role: 'patient', status: 'active' },
  { name: 'Trần Minh Đức',      username: 'tranminhduc', email: 'tduc2020@gmail.com',          role: 'patient', status: 'inactive' },
];
let deleteIndex = -1;

function initials(name) {
  return name.split(' ').slice(-2).map(w => w[0]).join('').toUpperCase();
}

function renderTable(data) {
  document.getElementById('userBody').innerHTML = data.length ? data.map(u => `
    <tr>
      <td>
        <div style="display:flex;align-items:center;gap:10px">
          <div class="avatar avatar-sm" style="background:${avatarColors[u.role]}">${initials(u.name)}</div>
          <div style="font-weight:600">${u.name}</div>
        </div>
      </td>
      <td style="font-family:monospace;font-size:12px">${u.username}</td>
      <td style="color:var(--text-secondary)">${u.email}</td>
      <td><span class="badge-status ${roleBadge[u.role]}">${roleLabel[u.role]}</span></td>
      <td>
        <span class="badge-status ${u.status === 'active' ? 'badge-confirmed' : 'badge-cancelled'}">${u.status === 'active' ? 'Hoạt động' : 'Vô hiệu'}</span>
      </td>
      <td class="action-cell">
        <button class="btn-icon" title="Sửa" onclick="editUser(${users.indexOf(u)})"><i class="fas fa-pen"></i></button>
        <button class="btn-icon btn-icon-danger" title="Xóa" onclick="openDelete(${users.indexOf(u)})"><i class="fas fa-trash"></i></button>
      </td>
    </tr>
  `).join('') : '<tr><td colspan="6" style="text-align:center;padding:32px;color:var(--text-muted)">Không tìm thấy người dùng</td></tr>';
}

function applyFilters() {
  const q    = document.getElementById('searchInput').value.toLowerCase();
  const role = document.getElementById('filterRole').value;
  const filtered = users.filter(u =>
    (!q || u.name.toLowerCase().includes(q) || u.username.toLowerCase().includes(q) || u.email.toLowerCase().includes(q)) &&
    (!role || u.role === role)
  );
  renderTable(filtered);
}

function openModal(index = -1) {
  document.getElementById('editIndex').value = index;
  document.getElementById('formError').style.display = 'none';
  document.getElementById('passwordField').style.display = index === -1 ? '' : 'none';
  if (index === -1) {
    document.getElementById('modalTitle').textContent = 'Thêm người dùng';
    ['uName', 'uUsername', 'uEmail', 'uPassword'].forEach(id => document.getElementById(id).value = '');
    document.getElementById('uRole').value = '';
    document.getElementById('uStatus').value = 'active';
  } else {
    document.getElementById('modalTitle').textContent = 'Sửa người dùng';
    const u = users[index];
    document.getElementById('uName').value = u.name;
    document.getElementById('uUsername').value = u.username;
    document.getElementById('uEmail').value = u.email;
    document.getElementById('uRole').value = u.role;
    document.getElementById('uStatus').value = u.status;
  }
  document.getElementById('userModal').classList.add('open');
}

function closeModal() { document.getElementById('userModal').classList.remove('open'); }
function editUser(i) { openModal(i); }

function saveUser() {
  const name     = document.getElementById('uName').value.trim();
  const username = document.getElementById('uUsername').value.trim();
  const email    = document.getElementById('uEmail').value.trim();
  const role     = document.getElementById('uRole').value;
  const index    = parseInt(document.getElementById('editIndex').value);
  const errEl    = document.getElementById('formError');

  if (!name || !username || !email || !role) {
    errEl.textContent = 'Vui lòng điền đầy đủ thông tin bắt buộc.';
    errEl.style.display = '';
    return;
  }
  if (index === -1) {
    const pwd = document.getElementById('uPassword').value;
    if (!pwd || pwd.length < 8) { errEl.textContent = 'Mật khẩu phải có ít nhất 8 ký tự.'; errEl.style.display = ''; return; }
    const dup = users.some(u => u.username === username || u.email === email);
    if (dup) { errEl.textContent = 'Username hoặc Email đã tồn tại.'; errEl.style.display = ''; return; }
  }

  const obj = { name, username, email, role, status: document.getElementById('uStatus').value };
  if (index === -1) users.push(obj); else users[index] = obj;
  closeModal();
  renderTable(users);
}

function openDelete(i) {
  deleteIndex = i;
  document.getElementById('deleteTargetName').textContent = users[i].name;
  document.getElementById('deleteOverlay').classList.add('open');
}
function closeDelete()    { document.getElementById('deleteOverlay').classList.remove('open'); }
function confirmDelete()  { users.splice(deleteIndex, 1); closeDelete(); renderTable(users); }

document.addEventListener('DOMContentLoaded', function () {
  [document.getElementById('userModal'), document.getElementById('deleteOverlay')].forEach(el => {
    el.addEventListener('click', e => { if (e.target === el) el.classList.remove('open'); });
  });
  renderTable(users);
});
