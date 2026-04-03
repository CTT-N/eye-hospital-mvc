// manager-departments.js — Department management CRUD

let departments = [
  { id: 'CK001', name: 'Giác mạc',               desc: 'Chuyên điều trị các bệnh lý về giác mạc, ghép giác mạc',      doctors: 4 },
  { id: 'CK002', name: 'Võng mạc',               desc: 'Điều trị các bệnh lý võng mạc, đáy mắt',                      doctors: 3 },
  { id: 'CK003', name: 'Mắt trẻ em',             desc: 'Khám và điều trị các bệnh mắt cho trẻ em',                   doctors: 2 },
  { id: 'CK004', name: 'Nhãn áp - Glaucoma',     desc: 'Chẩn đoán và điều trị glaucoma, tăng nhãn áp',               doctors: 3 },
  { id: 'CK005', name: 'Khúc xạ - Kính tiếp xúc', desc: 'Điều chỉnh tật khúc xạ, cận viễn loạn thị',               doctors: 2 },
  { id: 'CK006', name: 'Phẫu thuật Laser',        desc: 'Phẫu thuật LASIK, PRK và các phẫu thuật laser khác',        doctors: 2 },
];
let deleteIndex = -1;

function renderTable(data) {
  const tbody = document.getElementById('deptBody');
  tbody.innerHTML = data.map(d => `
    <tr>
      <td style="color:var(--text-muted);font-size:12px">${d.id}</td>
      <td><strong>${d.name}</strong></td>
      <td style="max-width:300px;color:var(--text-secondary)">${d.desc}</td>
      <td>${d.doctors}</td>
      <td class="action-cell">
        <button class="btn-icon" title="Sửa" onclick="editDept(${departments.indexOf(d)})"><i class="fas fa-pen"></i></button>
        <button class="btn-icon btn-icon-danger" title="Xóa" onclick="openDelete(${departments.indexOf(d)})"><i class="fas fa-trash"></i></button>
      </td>
    </tr>
  `).join('');
  document.getElementById('deptCount').textContent = departments.length;
}

function filterTable(q) {
  renderTable(departments.filter(d => d.name.toLowerCase().includes(q.toLowerCase())));
}

function openModal(index = -1) {
  document.getElementById('editIndex').value = index;
  document.getElementById('nameError').style.display = 'none';
  if (index === -1) {
    document.getElementById('modalTitle').textContent = 'Thêm chuyên khoa';
    document.getElementById('deptName').value = '';
    document.getElementById('deptDesc').value = '';
  } else {
    document.getElementById('modalTitle').textContent = 'Sửa chuyên khoa';
    document.getElementById('deptName').value = departments[index].name;
    document.getElementById('deptDesc').value = departments[index].desc;
  }
  document.getElementById('deptModal').classList.add('open');
}

function closeModal() { document.getElementById('deptModal').classList.remove('open'); }
function editDept(i)  { openModal(i); }

function saveDept() {
  const name = document.getElementById('deptName').value.trim();
  if (!name) { document.getElementById('nameError').style.display = ''; return; }
  const index = parseInt(document.getElementById('editIndex').value);
  const desc  = document.getElementById('deptDesc').value.trim();
  if (index === -1) {
    departments.push({ id: 'CK00' + (departments.length + 1), name, desc, doctors: 0 });
  } else {
    departments[index].name = name;
    departments[index].desc = desc;
  }
  closeModal();
  renderTable(departments);
}

function openDelete(i) {
  deleteIndex = i;
  document.getElementById('deleteTargetName').textContent = departments[i].name;
  document.getElementById('deleteOverlay').classList.add('open');
}
function closeDelete()   { document.getElementById('deleteOverlay').classList.remove('open'); }
function confirmDelete() { departments.splice(deleteIndex, 1); closeDelete(); renderTable(departments); }

document.addEventListener('DOMContentLoaded', function () {
  [document.getElementById('deptModal'), document.getElementById('deleteOverlay')].forEach(el => {
    el.addEventListener('click', e => { if (e.target === el) el.classList.remove('open'); });
  });
  renderTable(departments);
});
