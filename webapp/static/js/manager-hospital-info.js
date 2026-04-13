// manager-hospital-info.js — Hospital info editing

const editableIds = ['hospName', 'hospAddress', 'hospDesc'];

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
