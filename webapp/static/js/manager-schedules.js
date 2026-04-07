// manager-schedules.js — Schedule management CRUD

let schedules = [
  { date: '20/03/2025', time: '08:00', doctor: 'BS. Trần Thị Mai',      room: 'Phòng 103', status: 'confirmed' },
  { date: '20/03/2025', time: '08:30', doctor: 'BS. Trần Thị Mai',      room: 'Phòng 103', status: 'confirmed' },
  { date: '20/03/2025', time: '09:00', doctor: 'BS. Lê Hoàng Nam',      room: 'Phòng 205', status: 'pending' },
  { date: '21/03/2025', time: '10:00', doctor: 'BS. Phạm Thị Lan',      room: 'Phòng 301', status: 'pending' },
  { date: '21/03/2025', time: '14:00', doctor: 'BS. Nguyễn Đức Hùng',   room: 'Phòng 108', status: 'confirmed' },
];
let deleteIndex = -1;
const statusLabel = { confirmed: 'Đã xác nhận', pending: 'Chờ xác nhận', done: 'Hoàn thành' };

function renderTable(data) {
  document.getElementById('schedBody').innerHTML = data.length ? data.map(s => `
    <tr>
      <td>${s.date}</td>
      <td><strong>${s.time}</strong></td>
      <td>${s.doctor}</td>
      <td>${s.room}</td>
      <td><span class="badge-status badge-${s.status}">${statusLabel[s.status]}</span></td>
      <td class="action-cell">
        <button class="btn-icon" title="Sửa" onclick="editSched(${schedules.indexOf(s)})"><i class="fas fa-pen"></i></button>
        <button class="btn-icon btn-icon-danger" title="Xóa" onclick="openDelete(${schedules.indexOf(s)})"><i class="fas fa-trash"></i></button>
      </td>
    </tr>
  `).join('') : '<tr><td colspan="6" style="text-align:center;padding:32px;color:var(--text-muted)">Không có lịch khám nào</td></tr>';
}

function applyFilters() {
  const q    = document.getElementById('searchInput').value.toLowerCase();
  const doc  = document.getElementById('filterDoctor').value;
  const room = document.getElementById('filterRoom').value;
  const filtered = schedules.filter(s =>
    (!q    || s.doctor.toLowerCase().includes(q) || s.room.toLowerCase().includes(q)) &&
    (!doc  || s.doctor === doc) &&
    (!room || s.room   === room)
  );
  renderTable(filtered);
}

function openModal(index = -1) {
  document.getElementById('editIndex').value = index;
  document.getElementById('formError').style.display = 'none';
  if (index === -1) {
    document.getElementById('modalTitle').textContent = 'Tạo lịch khám';
    ['schedDoctor', 'schedRoom'].forEach(id => document.getElementById(id).value = '');
    document.getElementById('schedDate').value = '2025-03-20';
    document.getElementById('schedTime').value = '08:00';
  } else {
    document.getElementById('modalTitle').textContent = 'Sửa lịch khám';
    const s = schedules[index];
    document.getElementById('schedDoctor').value = s.doctor;
    document.getElementById('schedRoom').value   = s.room;
  }
  document.getElementById('schedModal').classList.add('open');
}
function closeModal()  { document.getElementById('schedModal').classList.remove('open'); }
function editSched(i)  { openModal(i); }

function saveSched() {
  const doctor = document.getElementById('schedDoctor').value;
  const room   = document.getElementById('schedRoom').value;
  const date   = document.getElementById('schedDate').value;
  const time   = document.getElementById('schedTime').value;
  if (!doctor || !room || !date || !time) { document.getElementById('formError').style.display = ''; return; }
  const [y, m, d] = date.split('-');
  const obj = { date: `${d}/${m}/${y}`, time, doctor, room, status: 'pending' };
  const index = parseInt(document.getElementById('editIndex').value);
  if (index === -1) schedules.push(obj); else schedules[index] = obj;
  closeModal();
  renderTable(schedules);
}

function openDelete(i) { deleteIndex = i; document.getElementById('deleteOverlay').classList.add('open'); }
function closeDelete()   { document.getElementById('deleteOverlay').classList.remove('open'); }
function confirmDelete() { schedules.splice(deleteIndex, 1); closeDelete(); renderTable(schedules); }

document.addEventListener('DOMContentLoaded', function () {
  [document.getElementById('schedModal'), document.getElementById('deleteOverlay')].forEach(el => {
    el.addEventListener('click', e => { if (e.target === el) el.classList.remove('open'); });
  });
  renderTable(schedules);
});
