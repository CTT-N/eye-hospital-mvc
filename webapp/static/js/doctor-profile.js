// doctor-profile.js — Tab switching, profile editing, and password change

function switchTab(btn, tabId) {
  document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
  document.querySelectorAll('.tab-pane-h').forEach(p => p.classList.remove('active'));
  btn.classList.add('active');
  document.getElementById(tabId).classList.add('active');
}

const editableIds = ['specialty', 'degree', 'phone', 'email', 'experience', 'bio'];

function toggleEdit() {
  editableIds.forEach(id => document.getElementById(id).disabled = false);
  document.getElementById('saveFooter').style.display = '';
  document.getElementById('editToggle').style.display = 'none';
}

function cancelEdit() {
  editableIds.forEach(id => document.getElementById(id).disabled = true);
  document.getElementById('saveFooter').style.display = 'none';
  document.getElementById('editToggle').style.display = '';
}

function saveInfo() { cancelEdit(); alert('Thông tin đã được lưu!'); }

document.addEventListener('DOMContentLoaded', function () {
  document.getElementById('confirmPwd').addEventListener('input', function () {
    const hint = document.getElementById('matchHint');
    if (this.value === document.getElementById('newPwd').value) {
      hint.textContent = '✓ Mật khẩu khớp'; hint.style.color = 'var(--success)';
    } else {
      hint.textContent = '✗ Không khớp'; hint.style.color = 'var(--danger)';
    }
  });
});

function changePassword() {
  const o = document.getElementById('oldPwd').value;
  const n = document.getElementById('newPwd').value;
  const c = document.getElementById('confirmPwd').value;
  if (!o || !n || !c) { alert('Vui lòng điền đầy đủ.'); return; }
  if (n.length < 8)  { alert('Mật khẩu mới phải có ít nhất 8 ký tự.'); return; }
  if (n !== c)       { alert('Mật khẩu xác nhận không khớp.'); return; }
  alert('Mật khẩu đã được cập nhật!');
}
