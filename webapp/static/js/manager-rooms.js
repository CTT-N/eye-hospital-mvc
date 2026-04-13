// manager-rooms.js — works with server-rendered data from DB

function filterTable(q) {
  const rows = document.querySelectorAll('#roomBody tr');
  const query = q.toLowerCase();
  rows.forEach(row => {
    row.style.display = row.textContent.toLowerCase().includes(query) ? '' : 'none';
  });
}

function openModal() {
  document.getElementById('formAction').value = 'add';
  document.getElementById('editRoomId').value = '';
  document.getElementById('modalTitle').textContent = 'Thêm phòng khám';
  document.getElementById('roomName').value = '';
  document.getElementById('roomDept').value = '';
  document.getElementById('roomDesc').value = '';
  document.getElementById('nameError').style.display = 'none';
  document.getElementById('roomModal').classList.add('open');
}

function closeModal() {
  document.getElementById('roomModal').classList.remove('open');
}

function editRoom(id, name, deptId, desc) {
  document.getElementById('formAction').value = 'update';
  document.getElementById('editRoomId').value = id;
  document.getElementById('modalTitle').textContent = 'Sửa phòng khám';
  document.getElementById('roomName').value = name;
  document.getElementById('roomDept').value = deptId;
  document.getElementById('roomDesc').value = desc;
  document.getElementById('nameError').style.display = 'none';
  document.getElementById('roomModal').classList.add('open');
}

function deleteRoom(id, name) {
  document.getElementById('deleteRoomId').value = id;
  document.getElementById('deleteTargetName').textContent = name;
  document.getElementById('deleteOverlay').classList.add('open');
}

function closeDelete() {
  document.getElementById('deleteOverlay').classList.remove('open');
}

document.addEventListener('DOMContentLoaded', function () {
  document.getElementById('roomModal').addEventListener('click', e => {
    if (e.target === document.getElementById('roomModal')) closeModal();
  });
  document.getElementById('deleteOverlay').addEventListener('click', e => {
    if (e.target === document.getElementById('deleteOverlay')) closeDelete();
  });
  document.querySelector('#roomModal form').addEventListener('submit', function (e) {
    const name = document.getElementById('roomName').value.trim();
    if (!name) {
      e.preventDefault();
      document.getElementById('nameError').style.display = '';
    }
  });
});
