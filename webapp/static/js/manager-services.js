// manager-services.js — service add/edit modal

function openAddModal() {
  document.getElementById('modalTitle').textContent  = 'Thêm dịch vụ';
  document.getElementById('modalAction').value       = 'add';
  document.getElementById('modalServiceId').value    = '';
  document.getElementById('modalName').value         = '';
  document.getElementById('modalPrice').value        = '';
  document.getElementById('modalDesc').value         = '';
  document.getElementById('serviceModal').classList.add('open');
}

function openEditModal(id) {
  var svc = serviceData[id];
  if (!svc) return;
  document.getElementById('modalTitle').textContent  = 'Sửa dịch vụ';
  document.getElementById('modalAction').value       = 'edit';
  document.getElementById('modalServiceId').value    = id;
  document.getElementById('modalName').value         = svc.name;
  document.getElementById('modalPrice').value        = svc.price;
  document.getElementById('modalDesc').value         = svc.desc;
  document.getElementById('serviceModal').classList.add('open');
}

function closeServiceModal() {
  document.getElementById('serviceModal').classList.remove('open');
}

function confirmDelete(form) {
  var name = form.dataset.serviceName || '';
  return confirm('Xóa dịch vụ ' + name + '?');
}

document.addEventListener('DOMContentLoaded', function() {
  document.getElementById('serviceModal').addEventListener('click', function(e) {
    if (e.target === this) closeServiceModal();
  });
});
