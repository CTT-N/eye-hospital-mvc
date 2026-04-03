// patient-profile.js — Tab switching, profile editing, and password change

function switchTab(btn, tabId) {
  document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
  document.querySelectorAll('.tab-pane-h').forEach(p => p.classList.remove('active'));
  btn.classList.add('active');
  document.getElementById(tabId).classList.add('active');
}

let isEditing = false;
const editableIds = ['fullName', 'cccd', 'dob', 'gender', 'phone', 'address', 'notes'];

function toggleEdit() {
  isEditing = true;
  editableIds.forEach(id => document.getElementById(id).disabled = false);
  document.getElementById('saveFooter').style.display = '';
  document.getElementById('editToggle').style.display = 'none';
}

function cancelEdit() {
  isEditing = false;
  editableIds.forEach(id => document.getElementById(id).disabled = true);
  document.getElementById('saveFooter').style.display = 'none';
  document.getElementById('editToggle').style.display = '';
}

function saveInfo() { cancelEdit(); alert('Thông tin đã được lưu thành công!'); }

document.addEventListener('DOMContentLoaded', function () {
  document.getElementById('confirmPwd').addEventListener('input', function () {
    const hint = document.getElementById('matchHint');
    if (this.value === document.getElementById('newPwd').value) {
      hint.textContent = '✓ Mật khẩu khớp'; hint.style.color = 'var(--success)';
    } else {
      hint.textContent = '✗ Mật khẩu không khớp'; hint.style.color = 'var(--danger)';
    }
  });
});

function changePassword() {
  const oldPwd     = document.getElementById('oldPwd').value;
  const newPwd     = document.getElementById('newPwd').value;
  const confirmPwd = document.getElementById('confirmPwd').value;
  if (!oldPwd || !newPwd || !confirmPwd) { alert('Vui lòng điền đầy đủ thông tin.'); return; }
  if (newPwd.length < 8)     { alert('Mật khẩu mới phải có ít nhất 8 ký tự.'); return; }
  if (newPwd !== confirmPwd) { alert('Mật khẩu xác nhận không khớp.'); return; }
  alert('Mật khẩu đã được cập nhật thành công!');
  ['oldPwd', 'newPwd', 'confirmPwd'].forEach(id => document.getElementById(id).value = '');
  document.getElementById('matchHint').textContent = '';
}
