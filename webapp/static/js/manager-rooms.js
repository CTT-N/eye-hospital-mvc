// manager-rooms.js — Room management CRUD

let rooms = [
  { id: 'P101', name: 'Phòng 101', dept: 'Giác mạc',           desc: 'Phòng khám giác mạc A' },
  { id: 'P102', name: 'Phòng 102', dept: 'Giác mạc',           desc: 'Phòng khám giác mạc B' },
  { id: 'P103', name: 'Phòng 103', dept: 'Giác mạc',           desc: 'Phòng khám giác mạc C' },
  { id: 'P201', name: 'Phòng 201', dept: 'Võng mạc',           desc: 'Phòng chụp đáy mắt' },
  { id: 'P205', name: 'Phòng 205', dept: 'Võng mạc',           desc: 'Phòng điều trị laser võng mạc' },
  { id: 'P301', name: 'Phòng 301', dept: 'Mắt trẻ em',         desc: 'Phòng khám nhi mắt' },
  { id: 'P108', name: 'Phòng 108', dept: 'Nhãn áp - Glaucoma', desc: 'Phòng đo nhãn áp' },
  { id: 'P401', name: 'Phòng 401', dept: 'Phẫu thuật Laser',   desc: 'Phòng phẫu thuật LASIK' },
];
let deleteIndex = -1;

function renderTable(data) {
  document.getElementById('roomBody').innerHTML = data.map(r => `
    <tr>
      <td style="color:var(--text-muted);font-size:12px">${r.id}</td>
      <td><strong>${r.name}</strong></td>
      <td>${r.dept}</td>
      <td style="color:var(--text-secondary)">${r.desc}</td>
      <td class="action-cell">
        <button class="btn-icon" title="Sửa" onclick="editRoom(${rooms.indexOf(r)})"><i class="fas fa-pen"></i></button>
        <button class="btn-icon btn-icon-danger" title="Xóa" onclick="openDelete(${rooms.indexOf(r)})"><i class="fas fa-trash"></i></button>
      </td>
    </tr>
  `).join('');
  document.getElementById('roomCount').textContent = rooms.length;
}

function filterTable(q) {
  renderTable(rooms.filter(r =>
    r.name.toLowerCase().includes(q.toLowerCase()) || r.dept.toLowerCase().includes(q.toLowerCase())
  ));
}

function openModal(index = -1) {
  document.getElementById('editIndex').value = index;
  document.getElementById('nameError').style.display = 'none';
  if (index === -1) {
    document.getElementById('modalTitle').textContent = 'Thêm phòng khám';
    document.getElementById('roomName').value = '';
    document.getElementById('roomDept').value = '';
    document.getElementById('roomDesc').value = '';
  } else {
    document.getElementById('modalTitle').textContent = 'Sửa phòng khám';
    document.getElementById('roomName').value = rooms[index].name;
    document.getElementById('roomDept').value = rooms[index].dept;
    document.getElementById('roomDesc').value = rooms[index].desc;
  }
  document.getElementById('roomModal').classList.add('open');
}
function closeModal() { document.getElementById('roomModal').classList.remove('open'); }
function editRoom(i)  { openModal(i); }

function saveRoom() {
  const name = document.getElementById('roomName').value.trim();
  if (!name) { document.getElementById('nameError').style.display = ''; return; }
  const index = parseInt(document.getElementById('editIndex').value);
  const obj = {
    id:   index === -1 ? 'P' + (rooms.length + 1).toString().padStart(3, '0') : rooms[index].id,
    name,
    dept: document.getElementById('roomDept').value,
    desc: document.getElementById('roomDesc').value,
  };
  if (index === -1) rooms.push(obj); else rooms[index] = obj;
  closeModal();
  renderTable(rooms);
}

function openDelete(i) {
  deleteIndex = i;
  document.getElementById('deleteTargetName').textContent = rooms[i].name;
  document.getElementById('deleteOverlay').classList.add('open');
}
function closeDelete()   { document.getElementById('deleteOverlay').classList.remove('open'); }
function confirmDelete() { rooms.splice(deleteIndex, 1); closeDelete(); renderTable(rooms); }

document.addEventListener('DOMContentLoaded', function () {
  [document.getElementById('roomModal'), document.getElementById('deleteOverlay')].forEach(el => {
    el.addEventListener('click', e => { if (e.target === el) el.classList.remove('open'); });
  });
  renderTable(rooms);
});
