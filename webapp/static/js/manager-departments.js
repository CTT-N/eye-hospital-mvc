// manager-departments.js — works with server-rendered data from DB

function filterTable(q) {
  const rows = document.querySelectorAll('#deptBody tr');
  const query = q.toLowerCase();
  rows.forEach(row => {
    row.style.display = row.textContent.toLowerCase().includes(query) ? '' : 'none';
  });
}

function openModal() {
  document.getElementById('formAction').value = 'add';
  document.getElementById('editDeptId').value = '';
  document.getElementById('modalTitle').textContent = 'Thêm chuyên khoa';
  document.getElementById('deptName').value = '';
  document.getElementById('deptDesc').value = '';
  document.getElementById('nameError').style.display = 'none';
  document.getElementById('deptModal').classList.add('open');
}

function closeModal() {
  document.getElementById('deptModal').classList.remove('open');
}

function editDept(id, name, desc) {
  document.getElementById('formAction').value = 'update';
  document.getElementById('editDeptId').value = id;
  document.getElementById('modalTitle').textContent = 'Sửa chuyên khoa';
  document.getElementById('deptName').value = name;
  document.getElementById('deptDesc').value = desc;
  document.getElementById('nameError').style.display = 'none';
  document.getElementById('deptModal').classList.add('open');
}

function deleteDept(id, name) {
  document.getElementById('deleteDeptId').value = id;
  document.getElementById('deleteTargetName').textContent = name;
  document.getElementById('deleteOverlay').classList.add('open');
}

function closeDelete() {
  document.getElementById('deleteOverlay').classList.remove('open');
}

document.addEventListener('DOMContentLoaded', function () {
  document.getElementById('deptModal').addEventListener('click', e => {
    if (e.target === document.getElementById('deptModal')) closeModal();
  });
  document.getElementById('deleteOverlay').addEventListener('click', e => {
    if (e.target === document.getElementById('deleteOverlay')) closeDelete();
  });
  document.querySelector('#deptModal form').addEventListener('submit', function (e) {
    const name = document.getElementById('deptName').value.trim();
    if (!name) {
      e.preventDefault();
      document.getElementById('nameError').style.display = '';
    }
  });
});
