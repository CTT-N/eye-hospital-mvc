// find-doctor.js — Filter doctor cards rendered server-side

function filterDoctors() {
  const q     = document.getElementById('searchInput').value.toLowerCase();
  const spec  = document.getElementById('specFilter').value.toLowerCase();
  const avail = document.getElementById('availFilter').value;

  let count = 0;
  document.querySelectorAll('#docGrid .doc-card-v2').forEach(function(card) {
    const name     = (card.dataset.name  || '');
    const cardSpec = (card.dataset.spec  || '');
    const cardAvail = (card.dataset.avail || '');

    const show = name.includes(q) &&
                 (!spec  || cardSpec.includes(spec)) &&
                 (!avail || cardAvail === avail);

    card.style.display = show ? '' : 'none';
    if (show) count++;
  });

  document.getElementById('docCount').textContent = 'Hiển thị ' + count + ' bác sĩ';
}

document.addEventListener('DOMContentLoaded', function() {
  const total = document.querySelectorAll('#docGrid .doc-card-v2').length;
  document.getElementById('docCount').textContent = 'Hiển thị ' + total + ' bác sĩ';
});
