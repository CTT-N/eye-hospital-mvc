// admin-eye-diseases.js — Eye disease management CRUD

let diseases = [
  { code: 'H16.0', name: 'Viêm giác mạc trung tâm',         cat: 'Giác mạc',      desc: 'Viêm giác mạc vùng trung tâm, thường do virus',          symptoms: 'Đau mắt, sợ ánh sáng, chảy nước mắt, thị lực giảm',          treatment: 'Tobramycin 0.3%, acyclovir nếu nguyên nhân herpes' },
  { code: 'H35.3', name: 'Thoái hóa điểm vàng tuổi già',    cat: 'Võng mạc',      desc: 'AMD – tổn thương điểm vàng do lão hóa',                  symptoms: 'Nhìn mờ trung tâm, méo hình, điểm mù trung tâm',             treatment: 'Tiêm nội nhãn anti-VEGF (ranibizumab, bevacizumab)' },
  { code: 'H26.0', name: 'Đục thủy tinh thể tuổi già',      cat: 'Thủy tinh thể', desc: 'Thủy tinh thể mờ đục theo tuổi tác',                     symptoms: 'Nhìn mờ dần, nhạy sáng, song thị',                           treatment: 'Phẫu thuật phaco thay thủy tinh thể nhân tạo' },
  { code: 'H40.1', name: 'Glaucoma góc mở nguyên phát',     cat: 'Nhãn áp',       desc: 'Tăng nhãn áp mạn tính tổn thương thị thần kinh',         symptoms: 'Thường không có triệu chứng sớm, thu hẹp thị trường',        treatment: 'Thuốc nhỏ mắt hạ nhãn áp, laser trabeculoplasty, phẫu thuật' },
  { code: 'H52.1', name: 'Cận thị',                          cat: 'Tật khúc xạ',  desc: 'Nhìn xa không rõ do trục nhãn cầu dài',                  symptoms: 'Nhìn xa mờ, nheo mắt, nhức đầu',                             treatment: 'Kính gọng, kính áp tròng, phẫu thuật LASIK/PRK' },
  { code: 'H10.0', name: 'Viêm kết mạc dị ứng',             cat: 'Khác',          desc: 'Viêm kết mạc do dị ứng phấn hoa, bụi...',               symptoms: 'Ngứa mắt, đỏ mắt, tiết ghèn, phù kết mạc',                  treatment: 'Kháng histamine tại chỗ, ổn định dưỡng bào, tránh dị nguyên' },
];
let deleteIndex = -1;

function renderTable(data) {
  document.getElementById('diseaseBody').innerHTML = data.length ? data.map(d => `
    <tr>
      <td style="font-family:monospace;font-size:12px;color:var(--primary);font-weight:600">${d.code}</td>
      <td><strong>${d.name}</strong></td>
      <td><span style="font-size:12px;padding:3px 8px;border-radius:4px;background:var(--cream);color:var(--primary);font-weight:500">${d.cat}</span></td>
      <td style="max-width:280px;color:var(--text-secondary);font-size:var(--font-sm)">${d.desc}</td>
      <td class="action-cell">
        <button class="btn-icon" title="Sửa" onclick="editDisease(${diseases.indexOf(d)})"><i class="fas fa-pen"></i></button>
        <button class="btn-icon btn-icon-danger" title="Xóa" onclick="openDelete(${diseases.indexOf(d)})"><i class="fas fa-trash"></i></button>
      </td>
    </tr>
  `).join('') : '<tr><td colspan="5" style="text-align:center;padding:32px;color:var(--text-muted)">Không tìm thấy kết quả</td></tr>';
}

function applyFilters() {
  const q   = document.getElementById('searchInput').value.toLowerCase();
  const cat = document.getElementById('filterCat').value;
  renderTable(diseases.filter(d =>
    (!q || d.name.toLowerCase().includes(q) || d.code.toLowerCase().includes(q)) &&
    (!cat || d.cat === cat)
  ));
}

function openModal(index = -1) {
  document.getElementById('editIndex').value = index;
  document.getElementById('formError').style.display = 'none';
  if (index === -1) {
    document.getElementById('modalTitle').textContent = 'Thêm bệnh mắt';
    ['dCode', 'dName', 'dDesc', 'dSymptoms', 'dTreatment'].forEach(id => document.getElementById(id).value = '');
    document.getElementById('dCat').value = '';
  } else {
    document.getElementById('modalTitle').textContent = 'Sửa thông tin bệnh';
    const d = diseases[index];
    document.getElementById('dCode').value      = d.code;
    document.getElementById('dName').value      = d.name;
    document.getElementById('dCat').value       = d.cat;
    document.getElementById('dDesc').value      = d.desc;
    document.getElementById('dSymptoms').value  = d.symptoms;
    document.getElementById('dTreatment').value = d.treatment;
  }
  document.getElementById('diseaseModal').classList.add('open');
}
function closeModal()       { document.getElementById('diseaseModal').classList.remove('open'); }
function editDisease(i)     { openModal(i); }

function saveDisease() {
  const code = document.getElementById('dCode').value.trim();
  const name = document.getElementById('dName').value.trim();
  const cat  = document.getElementById('dCat').value;
  if (!code || !name || !cat) { document.getElementById('formError').style.display = ''; return; }
  const obj = {
    code, name, cat,
    desc:      document.getElementById('dDesc').value.trim(),
    symptoms:  document.getElementById('dSymptoms').value.trim(),
    treatment: document.getElementById('dTreatment').value.trim(),
  };
  const index = parseInt(document.getElementById('editIndex').value);
  if (index === -1) diseases.push(obj); else diseases[index] = obj;
  closeModal();
  renderTable(diseases);
}

function openDelete(i) {
  deleteIndex = i;
  document.getElementById('deleteTargetName').textContent = diseases[i].name;
  document.getElementById('deleteOverlay').classList.add('open');
}
function closeDelete()   { document.getElementById('deleteOverlay').classList.remove('open'); }
function confirmDelete() { diseases.splice(deleteIndex, 1); closeDelete(); renderTable(diseases); }

document.addEventListener('DOMContentLoaded', function () {
  [document.getElementById('diseaseModal'), document.getElementById('deleteOverlay')].forEach(el => {
    el.addEventListener('click', e => { if (e.target === el) el.classList.remove('open'); });
  });
  renderTable(diseases);
});
