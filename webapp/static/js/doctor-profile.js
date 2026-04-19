// doctor-profile.js — Tab switching, profile editing, and password hint

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
  const form = document.getElementById('profileForm');
  form.reset();
  editableIds.forEach(id => document.getElementById(id).disabled = true);
  document.getElementById('saveFooter').style.display = 'none';
  document.getElementById('editToggle').style.display = '';
}

document.addEventListener('DOMContentLoaded', function () {
  const confirmInput = document.getElementById('confirmPwd');
  const newInput = document.getElementById('newPwd');
  const hint = document.getElementById('matchHint');

  if (!confirmInput || !newInput || !hint) return;

  confirmInput.addEventListener('input', function () {
    if (!this.value) {
      hint.textContent = '';
      return;
    }
    if (this.value === newInput.value) {
      hint.textContent = '✓ Mat khau khop';
      hint.style.color = 'var(--success)';
    } else {
      hint.textContent = '✗ Khong khop';
      hint.style.color = 'var(--danger)';
    }
  });
});
