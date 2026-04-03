// register.js — Password toggle, strength check, and registration form handler

function togglePw(id, btn) {
  const inp = document.getElementById(id);
  const isText = inp.type === 'text';
  inp.type = isText ? 'password' : 'text';
  btn.innerHTML = `<i class="fas fa-eye${isText ? '-slash' : ''}"></i>`;
}

function checkStrength() {
  const pw = document.getElementById('password').value;
  const bar = document.getElementById('pwBar');
  const lbl = document.getElementById('pwLabel');
  let score = 0;
  if (pw.length >= 8)          score++;
  if (/[A-Z]/.test(pw))        score++;
  if (/[0-9]/.test(pw))        score++;
  if (/[^A-Za-z0-9]/.test(pw)) score++;

  const levels = [
    { w: '0%',   c: '#EF4444', t: 'Quá yếu' },
    { w: '25%',  c: '#F97316', t: 'Yếu' },
    { w: '50%',  c: '#EAB308', t: 'Trung bình' },
    { w: '75%',  c: '#3B82F6', t: 'Khá mạnh' },
    { w: '100%', c: '#22C55E', t: 'Mạnh' },
  ];

  if (!pw) {
    bar.style.width = '0';
    lbl.textContent = 'Nhập mật khẩu để kiểm tra';
    lbl.style.color = 'var(--text-muted)';
    return;
  }

  bar.style.width = levels[score].w;
  bar.style.background = levels[score].c;
  lbl.textContent = levels[score].t;
  lbl.style.color = levels[score].c;
}

function handleReg(e) {
  e.preventDefault();
  let ok = true;
  const show = (id, visible) => { document.getElementById(id).style.display = visible ? 'block' : 'none'; };

  const last  = document.getElementById('lastName').value.trim();
  const first = document.getElementById('firstName').value.trim();
  const phone = document.getElementById('phone').value.trim();
  const email = document.getElementById('email').value.trim();
  const pw    = document.getElementById('password').value;
  const cpw   = document.getElementById('confirmPw').value;
  const agree = document.getElementById('agree').checked;

  show('errLast',  !last);  if (!last)  ok = false;
  show('errFirst', !first); if (!first) ok = false;

  const phoneRegex = /^[0-9]{10,11}$/;
  show('errPhone', !phoneRegex.test(phone)); if (!phoneRegex.test(phone)) ok = false;

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  show('errEmail', !emailRegex.test(email)); if (!emailRegex.test(email)) ok = false;

  show('errPw', pw.length < 8); if (pw.length < 8) ok = false;
  show('errConfirm', pw !== cpw || !cpw); if (pw !== cpw || !cpw) ok = false;

  if (!agree) {
    alert('Vui lòng đồng ý với Điều khoản sử dụng.');
    ok = false;
  }

  if (ok) {
    const btn = document.getElementById('regBtn');
    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
    btn.disabled = true;
    setTimeout(() => {
      alert('Đăng ký thành công! Vui lòng đăng nhập.');
      window.location.href = 'login.html';
    }, 1500);
  }
}
