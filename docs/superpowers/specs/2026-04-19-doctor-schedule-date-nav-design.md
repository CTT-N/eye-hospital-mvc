# Doctor Schedule: Date Navigation + Pending Confirmation Tab

**Date:** 2026-04-19
**Goal:** Cho phép bác sĩ xem lịch theo ngày bất kỳ và xác nhận / từ chối lịch PENDING qua một tab riêng.

---

## Problem

Sau khi lock schedule về "hôm nay", bác sĩ không còn xem được lịch hẹn của các ngày khác và không thể xác nhận lịch PENDING của bệnh nhân đặt trước.

---

## Design

### UI — 2 tab trên trang `/doctor/schedule`

**Tab 1 — "Lịch theo ngày"** (active mặc định):
- Date navigator: nút `←` / `→` là `<a href="?date=...&tab=today">`, `<input type="date">` với `onchange="location.href='?date='+this.value"`.
- Label "Hôm nay" khi ngày được chọn là ngày hiện tại.
- Danh sách lịch của ngày đó — hiển thị PENDING, CONFIRMED, COMPLETED. Nút "Xác nhận" chỉ xuất hiện với PENDING, nút "Khám" với CONFIRMED/COMPLETED.

**Tab 2 — "Chờ xác nhận (N)"** — badge đếm số lịch PENDING:
- Bảng liệt kê tất cả lịch PENDING từ hôm nay trở đi của doctor, sắp xếp `date ASC, time ASC`.
- Cột: Ngày, Giờ, Bệnh nhân, Phòng, Action.
- Mỗi hàng có 2 nút: **"Xác nhận"** (→ CONFIRMED) và **"Từ chối"** (→ CANCELLED).
- Sau action, redirect về `?tab=pending`.

---

### Controller — `DoctorScheduleController`

**`doGet`:**
1. Đọc param `date` (format `yyyy-MM-dd`), parse thành `java.sql.Date`. Invalid hoặc thiếu → default hôm nay.
2. Tính `prevDate` = date - 1 ngày, `nextDate` = date + 1 ngày. Format lại thành String `yyyy-MM-dd` để dùng trong link JSP.
3. Load `appointments` = lịch của `selectedDate` (dùng method đã có `getAppointmentsByDoctorIdWithPatientName` + filter theo ngày).
4. Load `pendingAppointments` = `getPendingAppointmentsByDoctorIdFromDate(doctorId, today)`.
5. Tính summary: `totalCount`, `pendingCount`, `doneCount` từ `appointments`.
6. Đọc param `tab` (default `"today"`), set attribute `activeTab`.

**`doPost`:**
- Đọc thêm param `returnTab` từ hidden field trong form.
- Allowed statuses mở rộng: `CONFIRMED` và `CANCELLED` (cả 2 đều được phép từ PENDING).
- Ownership check vẫn giữ: `isAppointmentOwnedByDoctor`.
- Sau khi update:
  - Nếu `returnTab=pending` → redirect `?tab=pending`
  - Ngược lại → redirect `?date=<selectedDate>&tab=today`

---

### DAO — `AppointmentDAO`

Thêm method mới:
```java
public List<Appointment> getPendingAppointmentsByDoctorIdFromDate(String doctorId, java.sql.Date fromDate)
```
Query:
```sql
SELECT a.*, u.fullName AS patientName
FROM Appointment a
LEFT JOIN Patient p ON a.patientId = p.patientId
LEFT JOIN user u ON p.userId = u.userId
WHERE a.doctorId = ? AND a.status = 'PENDING' AND a.date >= ?
ORDER BY a.date ASC, a.time ASC
```

---

### Security

- `doPost` chỉ cho phép status = `CONFIRMED` hoặc `CANCELLED` (từ chối), không phải giá trị tùy ý.
- Ownership check `isAppointmentOwnedByDoctor` giữ nguyên cho cả 2 action.
- Chỉ PENDING appointment mới được confirm/cancel (giữ check `appt.getStatus().equals("PENDING")`).

---

## File Map

| File | Action |
|------|--------|
| `src/dao/AppointmentDAO.java` | Thêm `getPendingAppointmentsByDoctorIdFromDate` |
| `src/controller/doctor/DoctorScheduleController.java` | Đọc `date` param, load pending list, mở rộng doPost |
| `webapp/views/doctor/doctor-schedule.jsp` | 2 tab, date navigator server-side, bảng pending |

---

## Out of Scope

- Từ chối với lý do (reason field) — không có trong model
- Phân trang danh sách pending
- Filter pending theo ngày cụ thể
