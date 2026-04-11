// manager-hospital-info.js — Hospital info editing

const editableIds = ['hospName', 'hospAddress', 'hospPhone', 'hospEmail', 'hospWeb', 'hospHours', 'hospDesc'];

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

function saveInfo() {
  const name = document.getElementById('hospName').value.trim();
  const addr = document.getElementById('hospAddress').value.trim();
  if (!name || !addr) { alert('Tên và địa chỉ bệnh viện không được để trống.'); return; }
  cancelEdit();
  alert('Thông tin bệnh viện đã được cập nhật!');
}
