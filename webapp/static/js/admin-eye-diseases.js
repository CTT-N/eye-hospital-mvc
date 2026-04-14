// admin-eye-diseases.js — Eye disease management CRUD (server-connected)

let deleteTargetId = '';

// ── Modal ──────────────────────────────────────────────────────────────────
function openModal() {
  document.getElementById('modalTitle').textContent = 'Thêm bệnh mắt';
  document.getElementById('modalAction').value = 'add';
  document.getElementById('dCode').readOnly = false;
  ['dCode', 'dName', 'dDesc', 'dSymptoms', 'dTreatment'].forEach(id => document.getElementById(id).value = '');
  document.getElementById('dCat').value = '';
  document.getElementById('formError').style.display = 'none';
  document.getElementById('diseaseModal').classList.add('open');
}

function editDisease(infoId, diseaseName, content, description) {
  document.getElementById('modalTitle').textContent = 'Sửa thông tin bệnh';
  document.getElementById('modalAction').value = 'update';
  document.getElementById('dCode').value = infoId;
  document.getElementById('dCode').readOnly = true;
  document.getElementById('dName').value = diseaseName;
  document.getElementById('dCat').value = content;
  document.getElementById('dDesc').value = description;
  document.getElementById('dSymptoms').value = '';
  document.getElementById('dTreatment').value = '';
  document.getElementById('formError').style.display = 'none';
  document.getElementById('diseaseModal').classList.add('open');
}

function closeModal() { document.getElementById('diseaseModal').classList.remove('open'); }

function saveDisease() {
  const code = document.getElementById('dCode').value.trim();
  const name = document.getElementById('dName').value.trim();
  const cat  = document.getElementById('dCat').value;
  if (!code || !name || !cat) {
    document.getElementById('formError').style.display = '';
    return;
  }
  document.getElementById('formInfoId').value  = code;
  document.getElementById('formName').value    = name;
  document.getElementById('formContent').value = cat;
  document.getElementById('formDesc').value    = document.getElementById('dDesc').value.trim();
  document.getElementById('formAction').value  = document.getElementById('modalAction').value;
  document.getElementById('diseaseForm').submit();
}

// ── Delete ─────────────────────────────────────────────────────────────────
function deleteDisease(infoId, diseaseName) {
  deleteTargetId = infoId;
  document.getElementById('deleteTargetName').textContent = diseaseName;
  document.getElementById('deleteOverlay').classList.add('open');
}

function closeDelete() { document.getElementById('deleteOverlay').classList.remove('open'); }

function confirmDelete() {
  document.getElementById('deleteInfoId').value = deleteTargetId;
  document.getElementById('deleteForm').submit();
}

// ── Client-side filter on server-rendered rows ─────────────────────────────
function applyFilters() {
  const q   = document.getElementById('searchInput').value.toLowerCase();
  const cat = document.getElementById('filterCat').value;
  document.querySelectorAll('#diseaseBody tr').forEach(row => {
    const code    = (row.cells[0]?.textContent || '').toLowerCase();
    const name    = (row.cells[1]?.textContent || '').toLowerCase();
    const rowCat  = (row.cells[2]?.textContent || '').trim();
    const visible = (!q || name.includes(q) || code.includes(q)) && (!cat || rowCat === cat);
    row.style.display = visible ? '' : 'none';
  });
}

// ── Init ───────────────────────────────────────────────────────────────────
document.addEventListener('DOMContentLoaded', function () {
  [document.getElementById('diseaseModal'), document.getElementById('deleteOverlay')].forEach(el => {
    if (el) el.addEventListener('click', e => { if (e.target === el) el.classList.remove('open'); });
  });
});
