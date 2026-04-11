-- ============================================================
-- SEED DATA — Bệnh Viện Mắt PTIT
-- Run: mysql -u root -p eye_hospital < database/seed_data.sql
-- ============================================================

-- ── Fix garbled names from pre-UTF8 registrations ───────────
UPDATE User SET fullname='Trần Văn Bình'           WHERE userId='U-58326BF8';
UPDATE User SET fullname='Nguyễn Thị Lan'          WHERE userId='U-A78E6551';
UPDATE User SET fullname='Khuất Minh'              WHERE userId='U-C5C5FBAF';
UPDATE User SET fullname='Nguyễn Văn Minh'         WHERE userId='U002';
UPDATE User SET fullname='TS.BS. Nguyễn Văn An'    WHERE userId='U003';

-- ── Hospital ─────────────────────────────────────────────────
INSERT IGNORE INTO Hospital VALUES
('H001','Bệnh Viện Mắt PTIT','01 Tôn Thất Tùng, Đống Đa, HN','BV nhãn khoa hàng đầu miền Bắc');

-- ── Departments ──────────────────────────────────────────────
INSERT IGNORE INTO Department VALUES
('DEP001','H001','Võng mạc',       'Khoa điều trị bệnh võng mạc'),
('DEP002','H001','Cườm mắt',       'Khoa phẫu thuật cườm mắt'),
('DEP003','H001','Nhãn nhi',       'Khoa nhãn khoa nhi'),
('DEP004','H001','Khúc xạ học',    'Khoa khúc xạ và kính tiếp xúc'),
('DEP005','H001','Glaucoma',       'Khoa chẩn đoán và điều trị Glaucoma'),
('DEP006','H001','LASIK',          'Khoa phẫu thuật LASIK & SMILE');

-- ── Rooms ────────────────────────────────────────────────────
INSERT IGNORE INTO Room VALUES
('R001','DEP001','Phòng khám VM-01','Khám và điều trị võng mạc'),
('R002','DEP001','Phòng laser VM-02','Laser quang đông võng mạc'),
('R003','DEP002','Phòng mổ CM-01',  'Phẫu thuật phaco siêu âm'),
('R004','DEP002','Phòng khám CM-02','Khám và tư vấn cườm mắt'),
('R005','DEP003','Phòng khám NN-01','Khám nhãn nhi tổng quát'),
('R006','DEP003','Phòng tập NN-02', 'Điều trị lác và nhược thị'),
('R007','DEP004','Phòng đo KX-01',  'Đo và điều chỉnh tật khúc xạ'),
('R008','DEP004','Phòng KTX-02',    'Kính tiếp xúc và kính áp tròng'),
('R009','DEP005','Phòng đo nhãn áp','Kiểm tra và điều trị Glaucoma'),
('R010','DEP005','Phòng laser GC',  'Laser điều trị Glaucoma'),
('R011','DEP006','Phòng LASIK-01',  'Phẫu thuật LASIK excimer'),
('R012','DEP006','Phòng SMILE-02',  'Phẫu thuật SMILE và ReLEx');

-- ── Assign departments to existing doctors ───────────────────
UPDATE Doctor SET departmentId='DEP001', experience='15 năm kinh nghiệm' WHERE doctorId='D001';
UPDATE Doctor SET departmentId='DEP002'                                   WHERE doctorId='DOC-77E08129';

-- ── New Users — Managers ─────────────────────────────────────
INSERT IGNORE INTO User VALUES
('U004','manager1','123456','Trần Thị Quản Lý','qlsang@bvmatptit.vn', 'MANAGER','0901111101','Quản lý ca sáng'),
('U005','manager2','123456','Lê Văn Quản Lý',  'qlchieu@bvmatptit.vn','MANAGER','0901111102','Quản lý ca chiều');

-- ── New Users — Doctors ──────────────────────────────────────
INSERT IGNORE INTO User VALUES
('U010','doctor2','123456','PGS.BS. Lê Thị Hương',   'lehuong@bvmatptit.vn', 'DOCTOR','0912000002','Phẫu thuật cườm mắt'),
('U011','doctor3','123456','GS.BS. Trần Văn Đức',    'tranduc@bvmatptit.vn', 'DOCTOR','0912000003','Nhãn nhi & lác mắt'),
('U012','doctor4','123456','BS. Phạm Thị Lan',       'phamlan@bvmatptit.vn', 'DOCTOR','0912000004','Khúc xạ học'),
('U013','doctor5','123456','TS.BS. Hoàng Minh Đức',  'hoanhduc@bvmatptit.vn','DOCTOR','0912000005','Glaucoma'),
('U014','doctor6','123456','BS. Vũ Thị Mai',         'vumai@bvmatptit.vn',   'DOCTOR','0912000006','LASIK & SMILE'),
('U015','doctor7','123456','PGS.BS. Nguyễn Lan',     'nguyenlan@bvmatptit.vn','DOCTOR','0912000007','Võng mạc cao cấp');

-- ── New Users — Patients ─────────────────────────────────────
INSERT IGNORE INTO User VALUES
('U020','patient2','123456','Phạm Văn Hùng',    'pvhung@gmail.com',  'PATIENT','0933000001',NULL),
('U021','patient3','123456','Nguyễn Thị Thanh', 'ntthanh@gmail.com', 'PATIENT','0933000002',NULL),
('U022','patient4','123456','Trần Minh Khoa',   'tmkhoa@gmail.com',  'PATIENT','0933000003',NULL),
('U023','patient5','123456','Lê Thị Hoa',       'lthoa@gmail.com',   'PATIENT','0933000004',NULL),
('U024','patient6','123456','Đỗ Văn Long',      'dvlong@gmail.com',  'PATIENT','0933000005',NULL),
('U025','patient7','123456','Bùi Thị Nga',      'btnga@gmail.com',   'PATIENT','0933000006',NULL),
('U026','patient8','123456','Hoàng Văn Tú',     'hvtu@gmail.com',    'PATIENT','0933000007',NULL),
('U027','patient9','123456','Vũ Thị Linh',      'vtlinh@gmail.com',  'PATIENT','0933000008',NULL);

-- ── New Doctors ──────────────────────────────────────────────
INSERT IGNORE INTO Doctor VALUES
('D002','U010','DEP002','Phó Giáo Sư',      '18 năm kinh nghiệm','Chuyên gia phẫu thuật phaco và IOL',NULL),
('D003','U011','DEP003','Giáo Sư Tiến Sĩ',  '25 năm kinh nghiệm','Chuyên gia nhãn nhi hàng đầu',NULL),
('D004','U012','DEP004','Thạc Sĩ Y Khoa',   '10 năm kinh nghiệm','Chuyên gia khúc xạ và kính tiếp xúc',NULL),
('D005','U013','DEP005','Tiến Sĩ Y Khoa',   '12 năm kinh nghiệm','Chuyên gia Glaucoma',NULL),
('D006','U014','DEP006','Thạc Sĩ Y Khoa',   '8 năm kinh nghiệm', 'Chuyên gia LASIK và SMILE',NULL),
('D007','U015','DEP001','Phó Giáo Sư',      '20 năm kinh nghiệm','Chuyên gia võng mạc cao cấp',NULL);

-- ── New Patients ─────────────────────────────────────────────
INSERT IGNORE INTO Patient VALUES
('P002','U020','045087001234','Hà Nội',        '1990-05-15','Nam', 'Cận thị, theo dõi định kỳ'),
('P003','U021','045087002345','TP. Hồ Chí Minh','1985-08-22','Nữ', 'Đang điều trị Glaucoma'),
('P004','U022','045087003456','Đà Nẵng',       '1995-03-10','Nam', 'Cườm mắt độ 2, cần phẫu thuật'),
('P005','U023','045087004567','Hải Phòng',     '1978-11-30','Nữ', 'Tiền sử gia đình mắc Glaucoma'),
('P006','U024','045087005678','Hà Nội',        '2001-07-04','Nam', 'Cận thị nặng, tư vấn LASIK'),
('P007','U025','045087006789','Hà Nội',        '1992-09-18','Nữ', 'Loạn thị kết hợp cận thị'),
('P008','U026','045087007890','Hưng Yên',      '1988-12-25','Nam', 'Theo dõi võng mạc định kỳ'),
('P009','U027','045087008901','Nam Định',      '2003-02-14','Nữ', 'Lác mắt từ nhỏ, điều trị lâu dài');

-- ── Services ─────────────────────────────────────────────────
INSERT IGNORE INTO Service VALUES
('SVC001','Khám mắt tổng quát',   200000, 'Kiểm tra toàn diện thị lực và sức khỏe mắt'),
('SVC002','Đo thị lực',           100000, 'Đo và đánh giá chính xác chỉ số thị lực'),
('SVC003','Siêu âm mắt B-scan',   350000, 'Siêu âm chẩn đoán bệnh lý nội nhãn'),
('SVC004','Laser võng mạc',      3000000, 'Laser quang đông điều trị và phòng ngừa rách võng mạc'),
('SVC005','Phẫu thuật cườm mắt',12000000, 'Phaco siêu âm cấy thủy tinh thể nhân tạo IOL'),
('SVC006','Điều trị Glaucoma',    500000, 'Đo nhãn áp và điều trị nội khoa Glaucoma'),
('SVC007','Phẫu thuật LASIK',   15000000, 'Phẫu thuật chỉnh hình giác mạc bằng laser excimer'),
('SVC008','Khám nhãn nhi',        250000, 'Khám chuyên khoa mắt cho trẻ em dưới 15 tuổi');

-- ── Appointments ─────────────────────────────────────────────
-- COMPLETED (past)
INSERT IGNORE INTO Appointment VALUES
('APT010','P002','D001','R001','2026-03-10','08:00:00','COMPLETED'),
('APT011','P003','D005','R009','2026-03-12','09:00:00','COMPLETED'),
('APT012','P004','D002','R004','2026-03-15','10:00:00','COMPLETED'),
('APT013','P005','D005','R009','2026-03-18','08:30:00','COMPLETED'),
('APT014','P006','D004','R007','2026-03-20','14:00:00','COMPLETED'),
('APT015','P007','D004','R008','2026-03-22','15:00:00','COMPLETED'),
('APT016','P008','D001','R002','2026-03-25','08:00:00','COMPLETED'),
('APT017','P009','D003','R005','2026-03-28','09:30:00','COMPLETED'),
('APT018','P002','D007','R001','2026-04-01','08:00:00','COMPLETED'),
('APT019','P005','D005','R009','2026-04-03','09:00:00','COMPLETED'),
-- CONFIRMED (upcoming)
('APT020','P002','D007','R001','2026-04-10','08:00:00','CONFIRMED'),
('APT021','P003','D005','R009','2026-04-10','09:00:00','CONFIRMED'),
('APT022','P004','D002','R003','2026-04-11','10:00:00','CONFIRMED'),
('APT023','P006','D006','R011','2026-04-11','14:00:00','CONFIRMED'),
('APT024','P008','D007','R002','2026-04-12','08:00:00','CONFIRMED'),
('APT025','P001','D002','R004','2026-04-14','09:30:00','CONFIRMED'),
-- PENDING
('APT030','P005','D005','R010','2026-04-15','08:30:00','PENDING'),
('APT031','P007','D004','R007','2026-04-15','09:00:00','PENDING'),
('APT032','P009','D003','R006','2026-04-16','10:00:00','PENDING'),
('APT033','P002','D001','R001','2026-04-17','08:00:00','PENDING'),
('APT034','P003','D007','R001','2026-04-18','14:00:00','PENDING'),
('APT035','P006','D006','R012','2026-04-20','08:30:00','PENDING'),
('APT036','P004','D003','R005','2026-04-21','10:00:00','PENDING'),
-- CANCELLED
('APT040','P004','D002','R004','2026-04-05','08:00:00','CANCELLED'),
('APT041','P006','D004','R007','2026-04-06','09:00:00','CANCELLED'),
('APT042','P007','D001','R001','2026-04-07','10:00:00','CANCELLED');

-- Medical record for existing APT002
INSERT IGNORE INTO MedicalRecord VALUES
('MR000','APT002','Mắt mờ, nhức đầu','Cận thị nhẹ 1.5 độ','Kính -1.50, nghỉ ngơi mắt','2026-03-20','Tái khám sau 6 tháng');

-- ── Medical Records (for COMPLETED appointments) ─────────────
INSERT IGNORE INTO MedicalRecord VALUES
('MR001','APT010','Mờ mắt, khó nhìn xa',      'Cận thị -3.0, loạn thị nhẹ -0.75',       'Kính gọng -3.00/-0.75x180',                   '2026-03-10','Tái khám sau 6 tháng'),
('MR002','APT011','Đau mắt, nhức đầu sáng',   'Glaucoma góc mở giai đoạn sớm',           'Thuốc nhỏ Timolol 0.5% ngày 2 lần',           '2026-03-12','Đo nhãn áp hàng tháng'),
('MR003','APT012','Nhìn mờ, chói sáng',        'Cườm mắt nhân cứng độ 2',                 'Phẫu thuật Phaco - IOL đơn tiêu +21.5D',      '2026-03-15','Tái khám 1 tuần sau mổ'),
('MR004','APT013','Tiền sử gia đình Glaucoma', 'Nhãn áp cao 24 mmHg, thị trường bình thường','Latanoprost 0.005% nhỏ mắt tối',           '2026-03-18','Thị trường 3D, đĩa thị 6T'),
('MR005','APT014','Không nhìn rõ bảng xe',     'Cận thị -8.0 hai mắt, giác mạc dày đủ',  'Kính -8.00, tư vấn phẫu thuật LASIK',         '2026-03-20','Đánh giá giác mạc trước LASIK'),
('MR006','APT015','Nhức mắt khi đọc sách',     'Loạn thị -2.5 kết hợp cận thị -4.0',     'Kính tiếp xúc toric, bỏ kính 2 tuần trước KX','2026-03-22','Tái khám 3 tháng'),
('MR007','APT016','Ruồi bay, tia sáng nhấp nháy','Rách võng mạc nhỏ vùng ngoại vi 10 giờ','Laser quang đông phòng ngừa 3 hàng',        '2026-03-25','Tái khám 1 tháng, tránh va đập mạnh'),
('MR008','APT017','Mắt trái lác vào trong',    'Lác trong 18 prism diopters',              'Điều trị che mắt phải 3h/ngày + tập thị giác','2026-03-28','Đo góc lác 2 tuần, cân nhắc phẫu thuật'),
('MR009','APT018','Theo dõi sau điều trị',     'Cận thị ổn định, không tiến triển',        'Tiếp tục đeo kính, bổ sung vitamin A',        '2026-04-01','Tái khám 1 năm'),
('MR010','APT019','Kiểm tra nhãn áp định kỳ',  'Nhãn áp 18 mmHg - ổn định với thuốc',     'Duy trì Latanoprost, không thay đổi phác đồ', '2026-04-03','Theo dõi 3 tháng');

-- ── Invoices ─────────────────────────────────────────────────
INSERT IGNORE INTO Invoice VALUES
('INV000','APT002','2026-03-20', 300000),
('INV001','APT010','2026-03-10', 300000),
('INV002','APT011','2026-03-12', 700000),
('INV003','APT012','2026-03-15',12300000),
('INV004','APT013','2026-03-18', 700000),
('INV005','APT014','2026-03-20', 300000),
('INV006','APT015','2026-03-22', 300000),
('INV007','APT016','2026-03-25',3200000),
('INV008','APT017','2026-03-28', 250000),
('INV009','APT018','2026-04-01', 300000),
('INV010','APT019','2026-04-03', 700000);

-- ── Invoice_Service ──────────────────────────────────────────
INSERT IGNORE INTO Invoice_Service VALUES
('INV000','SVC001',1, 200000),
('INV000','SVC002',1, 100000),
('INV001','SVC001',1, 200000),
('INV001','SVC002',1, 100000),
('INV002','SVC001',1, 200000),
('INV002','SVC006',1, 500000),
('INV003','SVC001',1, 200000),
('INV003','SVC002',1, 100000),
('INV003','SVC005',1,12000000),
('INV004','SVC001',1, 200000),
('INV004','SVC006',1, 500000),
('INV005','SVC001',1, 200000),
('INV005','SVC002',1, 100000),
('INV006','SVC001',1, 200000),
('INV006','SVC002',1, 100000),
('INV007','SVC001',1, 200000),
('INV007','SVC004',1,3000000),
('INV008','SVC008',1, 250000),
('INV009','SVC001',1, 200000),
('INV009','SVC002',1, 100000),
('INV010','SVC001',1, 200000),
('INV010','SVC006',1, 500000);

-- ── Eye Disease Info ─────────────────────────────────────────
INSERT IGNORE INTO EyeDiseaseInfo VALUES
('EDI001','U003','Glaucoma (Tăng nhãn áp)',
 'Glaucoma là bệnh thị thần kinh gây mất thị trường không hồi phục, thường liên quan đến nhãn áp cao.',
 'Nguyên nhân: tắc nghẽn lưu thông thủy dịch khiến nhãn áp tăng cao, tổn thương dây thần kinh thị giác.',
 'U003','2026-01-15'),
('EDI002','U003','Cườm mắt (Đục thủy tinh thể)',
 'Cườm mắt là tình trạng thủy tinh thể mắt bị đục dần, gây giảm thị lực nghiêm trọng nếu không điều trị.',
 'Phổ biến ở người trên 60 tuổi. Phẫu thuật Phaco là phương pháp điều trị hiệu quả duy nhất.',
 'U003','2026-01-20'),
('EDI003','U003','Bong võng mạc',
 'Bong võng mạc xảy ra khi lớp võng mạc tách khỏi lớp biểu mô sắc tố, cần cấp cứu nhãn khoa.',
 'Triệu chứng: ruồi bay tăng đột ngột, tia sáng nhấp nháy, màn che thị trường.',
 'U003','2026-02-01'),
('EDI004','U011','Lác mắt ở trẻ em',
 'Lác mắt (strabismus) là tình trạng hai mắt không nhìn cùng một điểm, gây nhược thị nếu không điều trị sớm.',
 'Điều trị: che mắt, kính, botulinum toxin, hoặc phẫu thuật tùy mức độ.',
 'U011','2026-02-10'),
('EDI005','U012','Cận thị (Myopia)',
 'Cận thị là tật khúc xạ phổ biến nhất, đặc biệt tăng nhanh ở trẻ em trong độ tuổi học đường.',
 'Phòng ngừa: hạn chế màn hình, tăng thời gian ngoài trời. Điều trị: kính, orthokeratology, LASIK.',
 'U012','2026-02-15'),
('EDI006','U005','Thoái hóa điểm vàng',
 'Thoái hóa điểm vàng (AMD) là nguyên nhân hàng đầu gây mù lòa ở người cao tuổi trên 50 tuổi.',
 'Thể khô: bổ sung AREDS2. Thể ướt: tiêm anti-VEGF định kỳ. Khám định kỳ mỗi 6 tháng.',
 'U003','2026-03-01');

SELECT 'Seed data inserted successfully!' AS status;
