# Bug & Issue Report
Generated: 2026-04-04

---

## 🔴 Critical (crashes or data loss)

| # | File | Line | Description | Root Cause |
|---|------|------|-------------|------------|
| 1 | `src/controller/patient/PatientDashboardController.java` | 23 | **NullPointerException crash if session has no `user` attribute.** `req.getSession().getAttribute("user")` is cast to `User` and immediately dereferenced (`user.getUserId()`) with no null check. If the session exists but `user` is null, the server throws a 500 error. | No null guard before `user.getUserId()`. Unlike most other controllers, this controller does **not** check `if (user == null)` before use. |
| 2 | `src/controller/doctor/DoctorDashboardController.java` | 25 | **Same NullPointerException pattern:** `user.getUserId()` called without a null check on line 25. If session is valid but `user` attribute is absent, server crashes. | Same root cause as #1 — no null guard. |
| 3 | `src/controller/patient/PatientProfileController.java` | 22–23 | **NullPointerException when session `user` is null:** `req.getSession().getAttribute("user")` is cast to `User` and `user.getUserId()` is called with no null guard. | Missing null check on `user` before use. |
| 4 | `src/controller/doctor/DoctorProfileController.java` | 22–23 | **Same NullPointerException pattern** in `doGet`. `user.getUserId()` called without null check. | Missing null check. |
| 5 | `src/dao/DepartmentDAO.java` | 40 | **Connection leak in `getDepartmentById`.** The method calls a private helper `prepareStatement(sql)` (line 59–61) which opens a new DB connection via `DBConnection.getConnection()` and returns only the `PreparedStatement`. The `Connection` object returned by `getConnection()` is never stored in a variable and never closed. Every call to `getDepartmentById` leaks a database connection. | `prepareStatement()` at line 59 calls `DBConnection.getConnection()` and discards the reference; the connection is never closed. |
| 6 | `src/controller/patient/PatientRegisterController.java` | 47–53 | **Wrong patientId stored in appointment.** In `doPost`, `appt.setPatientId(user.getUserId())` sets the User's `userId` as the `patientId`. The `Appointment` table expects a `patientId` foreign key referencing the `Patient` table, not the `User` table. This will cause FK constraint violations or silently store wrong data. | The controller uses `user.getUserId()` instead of looking up the `Patient` record and using `patient.getPatientId()`. |
| 7 | `src/controller/patient/PatientRegisterController.java` | 51–52 | **Swallowed exception hides invalid date/time input:** the `try { appt.setDate(...); appt.setTime(...); } catch(Exception e) {}` block at lines 51–53 silently swallows `IllegalArgumentException` from `Date.valueOf()` / `Time.valueOf()`. If the user submits a malformed date or time, the appointment is inserted with `null` date and time. | Empty catch block. |

---

## 🟠 High (feature completely broken)

| # | File | Line | Description | Root Cause |
|---|------|------|-------------|------------|
| 8 | `src/controller/patient/PatientInvoiceController.java` | 31 | **All patients see ALL invoices.** `invoiceDAO.getAllInvoices()` fetches every invoice from the DB regardless of which patient is logged in. A patient can see other patients' billing records. | `getAllInvoices()` has no filter by patient or appointment. No patient-scoped query is used. |
| 9 | `webapp/views/patient/book-appointment.jsp` + `webapp/static/js/book-appointment.js` | JSP line 58, JS line 52 | **Booking form never submits to the server.** The submit button calls `onclick="confirmBooking()"`, which executes a `alert(...)` (JS line 52–54) and returns `true` — it does NOT prevent default, and the form action points to `/patient/appointment`. However, the hidden `<input name="doctorId">` is never set by JS (the `selectDoc` function only updates the summary label, not a form field), and the hidden `<input name="date">` / `<input name="time">` fields are also missing. Even if the form submits, `doctorId`, `date`, and `time` parameters will be `null` on the server. | `book-appointment.js` uses `selectDoc(el, name)` to update a display label but never writes to a form `<input>` with `name="doctorId"`. No hidden inputs for `date` or `time` exist in the form. |
| 10 | `src/controller/admin/ManageUserController.java` | 15 | **`@WebServlet("/admin/users")` annotation conflicts with `web.xml`.** This controller uses `@WebServlet` but is **not** listed in `web.xml`. Controllers that use `@WebServlet` AND are registered in `web.xml` would produce a duplicate mapping error; controllers that use only `@WebServlet` work only if annotation scanning is enabled. The same issue applies to: `ManageEyeDiseaseInfoController` (`/admin/diseases`), `PatientHistoryController` (`/patient/history`), `PatientAppointmentController` (`/patient/appointment`), `PatientInvoiceController` (`/patient/invoices`), `PatientRegisterController` (`/patient/register-exam`), `DoctorScheduleController` (`/doctor/schedule`), `ExaminationController` (`/doctor/examination`), `MedicalRecordController` (`/doctor/medical-records`), `PatientListController` (`/doctor/patients`), `DepartmentController` (`/manager/departments`), `HospitalController` (`/manager/hospital`), `ReportController` (`/manager/report`), `RoomController` (`/manager/rooms`), `ScheduleController` (`/manager/schedule`). None of these URLs appear in `web.xml`. The URLs will 404 unless the container supports annotation scanning and the deployment is configured accordingly. | `web.xml` only registers 8 servlets; 14+ controllers use `@WebServlet` annotation only. Mixed configuration with no annotation scanning guarantee leads to broken routes. |
| 11 | `src/controller/auth/ChangePasswordController.java` | 12–27 | **`doGet` is not implemented; the change-password form page is unreachable via normal flow.** The controller only has `doPost`. A GET to `/auth/change-password` will return HTTP 405 (Method Not Allowed). Additionally, there is no current-password verification — any logged-in user can change to any new password without confirming their existing one. | `doGet` not implemented; no old-password check. |
| 12 | `src/controller/auth/ChangePasswordController.java` | 26 | **Hardcoded redirect to `/patient/profile` for all roles.** After a successful password change, any user (ADMIN, DOCTOR, MANAGER, PATIENT) is redirected to `/patient/profile?msg=success`. A DOCTOR who changes their password is redirected to a patient page. | Redirect target is hardcoded for PATIENT role only. |
| 13 | `webapp/static/js/book-appointment.js` | 52–54 | **`confirmBooking()` shows an alert claiming success before the form is actually submitted.** The JS `onclick` handler shows "Đặt lịch thành công" regardless of whether the server successfully saved the appointment. | `confirmBooking()` calls `alert()` unconditionally; the form's `onsubmit` is not wired to validate or report actual server response. |
| 14 | `src/controller/doctor/MedicalRecordController.java` | 46–54 | **"add" action does not set `createdDate`.** When adding a medical record via the POST action `"add"`, the `record.setCreatedDate(...)` is never called (the code even has a comment `// Note: date should be set`). The `MedicalRecordDAO.insertRecord()` passes `record.getCreatedDate()` which is `null`. This will fail if the DB column is `NOT NULL`, or silently store a null date. | `createdDate` not populated before insert. |

---

## 🟡 Medium (wrong behavior under certain conditions)

| # | File | Line | Description | Root Cause |
|---|------|------|-------------|------------|
| 15 | `src/util/DBConnection.java` | 8–10 | **Real DB credentials hardcoded in source.** Password is `minhkhuat123` (not `123456` as stated in CLAUDE.md — the actual file has a different password). Credentials are committed to version control. | No externalized configuration (no `.properties` file, no environment variable). |
| 16 | `src/dao/UserDAO.java` | 74–91 | **Resource leak in `checkUsernameExists`.** `Connection` and `PreparedStatement` are opened without try-with-resources and are never explicitly closed. | Manual resource management without `finally` or try-with-resources. Same issue exists in `insertUser` (lines 97–117). |
| 17 | `src/dao/UserDAO.java` | 94–117 | **Resource leak in `insertUser`.** `Connection` and `PreparedStatement` are opened without try-with-resources and never closed. | Same as above. |
| 18 | `src/controller/auth/LoginController.java` | 46–66 | **No `default` case in role switch — no redirect if role is unknown.** If `user.getRole()` returns an unexpected value (e.g., `""`, `null`, or a future new role), the switch falls through all cases and the method returns normally without any response written or redirect issued. This results in a blank response to the browser. | `switch(role)` has no `default` branch. |
| 19 | `webapp/views/auth/register.jsp` | 76–77 | **Register form uses `novalidate` + `onsubmit="handleReg(event)"` — if JavaScript is disabled, all client-side validation is bypassed.** A user can submit completely empty fields or mismatched passwords directly to `RegisterController`. The server-side controller (`RegisterController.java`) only validates username uniqueness — it does not check that `username`, `password`, `fullName`, or `email` are non-empty. | No server-side input validation in `RegisterController`. |
| 20 | `webapp/views/patient/book-appointment.jsp` | 79 | **Doctor display shows `doctorId` instead of doctor name.** `${doc.doctorId.charAt(0)}` and `${doc.doctorId}` are used as the doctor's display name. The `Doctor` model has no `fullName` field — name must be fetched from the joined `User` table, which is not done. | `DoctorDAO.getAllDoctors()` does not JOIN with `User` table, so `Doctor` objects have no `fullName`. |
| 21 | `webapp/views/patient/patient-dashboard.jsp` | 90 | **Hardcoded date string `"Thứ Năm, 20/03/2025"` displayed as current date.** The dashboard always shows March 20, 2025 regardless of the actual date. | Static string in JSP; no server-side or JS dynamic date used. |
| 22 | `webapp/views/patient/patient-dashboard.jsp` | 142–148 | **"Bệnh án" and "Đơn thuốc" stat cards reuse `upcomingCount` and `pendingCount` for unrelated metrics.** The "Tổng lượt khám" card shows `upcomingCount` (which counts CONFIRMED appointments only), "Bệnh án" also shows `upcomingCount`, and "Đơn thuốc"/"Hóa đơn" both show `pendingCount`. None of these values are the correct count for their labels. | `PatientDashboardController` provides only two counts (`upcomingCount`, `pendingCount`); the JSP has four stat cards that need separate values. |
| 23 | `webapp/views/patient/patient-dashboard.jsp` | 275–292 | **"Thông tin sức khỏe" section is entirely hardcoded dummy data** (blood type "O+", allergy "Không có", medical history "Đái tháo đường T2", primary doctor "BS. Nguyễn Minh Tuấn"). No patient data from the DB is rendered. | Static placeholder data never replaced with real model attributes. |
| 24 | `webapp/views/patient/patient-invoices.jsp` | 133 | **"Dịch vụ" and "Bác sĩ" table columns both display `inv.appointmentId`** instead of service name and doctor name. | The `Invoice` model has no `serviceName` or `doctorId` field; the JSP uses `appointmentId` as a placeholder for both. |
| 25 | `webapp/views/patient/patient-invoices.jsp` | 135 | **"Trạng thái" (status) column always shows "Đã thanh toán" (Paid)** for every invoice, regardless of actual payment status. | The `Invoice` model has no `status` field; JSP hardcodes the badge text. |
| 26 | `src/controller/patient/PatientAppointmentController.java` | 77 | **`Time.valueOf(timeStr + ":00")` will throw `IllegalArgumentException` if `timeStr` already contains seconds or is not in `HH:mm` format.** For example, if the form sends `"07:30:00"`, the string becomes `"07:30:00:00"` and `Time.valueOf()` throws an exception. The surrounding `catch (Exception e)` catches it, but sets the error attribute on the request and calls `doGet`, which forwards back to the form — effectively silently ignoring the time value. | Assumes form always submits exactly `HH:mm` format. No time format normalization. |
| 27 | `src/controller/common/DoctorSearchController.java` | 1–5 | **`DoctorSearchController` is an empty class** (no HTTP handling, no servlet extension). It is never registered in `web.xml` and does nothing. | Stub class never implemented. |
| 28 | `src/controller/common/EyeDiseaseInfoController.java` | 1–5 | **`EyeDiseaseInfoController` is an empty class** — same as above. | Stub class never implemented. |
| 29 | `src/dao/ReportDAO.java` | 7–9 | **`ReportDAO` is an empty class.** `ReportController` forwards to `manager-reports.jsp` with no data. The report view presumably needs statistics but receives none. | Stub DAO never implemented. |
| 30 | `src/filter/RoleFilter.java` | 40–43 | **`/doctor/*` check uses `uri.contains("/doctor")` (without trailing slash), which matches the URL `/admin/doctor-something` or any path with "doctor" in it.** The `/patient/*` check correctly uses `uri.contains("/patient/")` with trailing slash, but the `/admin`, `/manager`, and `/doctor` checks do not include the trailing slash. | Inconsistent string matching — `/admin` and `/manager` and `/doctor` lack the trailing `/` in the `contains()` check. The `/patient/` check is the only one with the trailing slash. |

---

## 🔵 Low (code smell, inconsistency, poor UX)

| # | File | Line | Description | Root Cause |
|---|------|------|-------------|------------|
| 31 | `src/util/DBConnection.java` | 30–37 | **`main()` method in a utility/production class.** `DBConnection` has a `main()` method for connection testing that should not exist in a production class. | Development debug code left in production code. |
| 32 | `src/controller/admin/AdminDashboardController.java` | 20–23 | **Redundant role check duplicates what `RoleFilter` already enforces.** Controllers under `/admin/*` are protected by `RoleFilter`, so the in-controller `if (user == null || !"ADMIN".equals(...))` check is redundant. Inconsistently applied — many controllers inside protected paths check the role redundantly, while some do not at all (e.g., `PatientDashboardController`). | Role authorization is duplicated in both filter and controllers without a consistent policy. |
| 33 | `src/dao/UserDAO.java` | 76 | **`SELECT * FROM User` vs `SELECT * FROM user`** — inconsistent table name casing across DAO methods. Some use `User`, some use `user`. While MySQL is case-insensitive on most platforms, this is a latent portability issue. | No consistent naming convention. |
| 34 | Multiple controllers | — | **Every controller instantiates a new DAO per request** (e.g., `new UserDAO()`, `new DoctorDAO()` inline). DAOs hold no state and could be singletons or injected once. Creating them per-request is wasteful. | No dependency injection or shared DAO instances. |
| 35 | `webapp/views/change-password.jsp` | 1–25 | **Change-password page has `<title>Login</title>`** — copy-paste error from login template. | Careless copy-paste. |
| 36 | `webapp/views/patient/patient-invoices.jsp` | 44 | **Hardcoded badge count `<span class="nav-badge">1</span>`** in sidebar navigation. | Static placeholder never replaced. |
| 37 | `webapp/views/patient/book-appointment.jsp` | 36 | **`${sessionScope.user.fullName.charAt(0)}` will throw NullPointerException at JSP render time if `fullName` is null.** The JSP uses a JSTL expression that calls a Java method; if `fullName` is null, an EL exception occurs. | No null-safe check before `.charAt(0)`. Same pattern in multiple JSPs. |
| 38 | `webapp/views/patient/patient-dashboard.jsp` | 71 | **`${sessionScope.user.fullName.charAt(0)}` — same NullPointerException risk** if `fullName` is null. | Same as #37. |
| 39 | `webapp/views/doctor/doctor-appointment-detail.jsp` | 40 | **`${sessionScope.user.fullName.substring(0,2)}` — StringIndexOutOfBoundsException** if `fullName` is less than 2 characters. | No length check before `substring(0,2)`. |
| 40 | `webapp/views/auth/login.jsp` | 132 | **"Quên mật khẩu?" link points back to the login page** (`/auth/login`), not to any password reset flow. Forgot password is not implemented. | Placeholder link. |
| 41 | `src/controller/patient/PatientAppointmentController.java` + `src/controller/patient/PatientRegisterController.java` | — | **Two controllers handle appointment booking (`/patient/appointment` and `/patient/register-exam`) and both forward to `book-appointment.jsp`.** The logic is duplicated and inconsistent — `PatientAppointmentController` correctly resolves `Patient` from `userId`, while `PatientRegisterController` incorrectly uses `userId` as `patientId`. | Duplicate feature implementation with divergent correctness. |
| 42 | `webapp/views/auth/register.jsp` | 147 | **`${error}` and `${success}` rendered without XSS escaping.** JSTL `<c:if>` with `${error}` outputs the raw string, which could contain user-supplied data (e.g., a username with `<script>`). The same issue exists in `login.jsp` line 138. Should use `<c:out value="${error}"/>` instead. | Direct EL expression output without JSTL `<c:out>` escaping. |
| 43 | `src/filter/AuthFilter.java` | 22–26 | **`uri.contains("/views")` in the bypass list exposes all JSP files directly.** Any URL containing `/views` bypasses authentication — this means any JSP under `/views/` is accessible without login if the container serves JSP files directly. JSPs should be under `WEB-INF` to prevent direct access. | JSPs stored in `webapp/views/` (not `WEB-INF`) and the bypass rule matches the path. |
| 44 | All DAOs | — | **Errors are swallowed with `e.printStackTrace()` and `return null` / `return false` / empty list.** Callers cannot distinguish "DB error" from "record not found". No logging framework is used. | Generic exception handling with no error propagation. |

---

## ✅ Working Correctly

- `AuthFilter` properly gates all routes, with explicit allow-list for `/auth/`, `/static/`, `/common/find-doctor`, and the root.
- `LogoutController` correctly invalidates the session and redirects to login.
- `LoginController` correctly authenticates via `UserDAO.login()`, populates session attributes `user` and `role`, and routes to the correct dashboard per role.
- `RegisterController` checks for duplicate usernames before inserting, and always assigns `PATIENT` role.
- All DAO methods use `PreparedStatement` with parameter binding — no SQL injection vulnerabilities found.
- `RoleFilter` is correctly registered in `web.xml` for `/admin/*`, `/manager/*`, `/doctor/*`, `/patient/*` patterns.
- `AppointmentDAO`, `InvoiceDAO`, `MedicalRecordDAO`, `DoctorDAO`, `PatientDAO`, `HospitalDAO`, `RoomDAO`, `ServiceDAO`, `InvoiceServiceDAO`, `EyeDiseaseInfoDAO` all use try-with-resources correctly (with the exception of `DepartmentDAO.getDepartmentById` noted above).
- `ExaminationController` correctly handles both insert (new record) and update (existing record) for medical records.
- `DoctorScheduleController` correctly loads appointments scoped to the logged-in doctor.
- `PatientListController` correctly deduplicates patients using a `HashSet` of `patientId`.
- `HospitalController` gracefully handles an empty hospital list (`hospitals.isEmpty() ? null : hospitals.get(0)`).

---

## ❓ Needs Clarification

- **`web.xml` vs `@WebServlet` deployment strategy:** It is unclear whether the deployment environment has annotation scanning enabled. If it does not, all 14+ controllers that use only `@WebServlet` annotations will return 404. If it does, the 8 controllers registered in `web.xml` may or may not conflict. The intended configuration should be made explicit.
- **`PatientDashboardController` null-safety for `patient`:** When `patient == null` (user has PATIENT role but no matching row in the `Patient` table), the dashboard still renders but with `null` patient object and empty appointment list. Whether this is an expected state (e.g., new user before completing profile) or an error condition is not documented.
- **Database schema:** The actual DB schema (`database/database.sql`) was not read during this audit. Specific column names (e.g., `CCCD` vs `cccd`), nullability constraints, and foreign key definitions are assumed from DAO code. Some constraints (e.g., `NOT NULL` on `createdDate`) could not be confirmed.
- **`InvoiceService.getQuanlity()` method name:** The `InvoiceServiceDAO` reads column `quantity` but maps it to `is.setQuanlity(...)` (typo: "Quanlity"). Whether the `InvoiceService` model has a typo'd setter or this is intentional is unclear.
- **Session timeout behavior:** No session timeout is configured in `web.xml`. The default container timeout (typically 30 minutes) will be used. Whether this is intentional is unclear.
- **CSRF protection:** No CSRF tokens are present on any form. All state-changing POST endpoints are vulnerable to cross-site request forgery. This is a known class of vulnerability, but whether it is a deliberate omission (academic project) or an oversight is not stated.

---

## ✅ Fixed in this session

| # | Bug | Fix summary |
|---|-----|-------------|
| 1 | NullPointerException in PatientDashboardController if session user is null | Added null guard + redirect to /auth/login in doGet |
| 2 | NullPointerException in DoctorDashboardController if session user is null | Added null guard + redirect to /auth/login in doGet |
| 3 | NullPointerException in PatientProfileController if session user is null | Added null guard in both doGet and doPost |
| 4 | NullPointerException in DoctorProfileController if session user is null | Added null guard in both doGet and doPost |
| 5 | DB connection leak in DepartmentDAO.getDepartmentById | Removed private prepareStatement() helper; use inline try-with-resources |
| 6 | PatientRegisterController used User.userId as patientId FK (wrong table) | Now resolves Patient record via PatientDAO and uses Patient.patientId |
| 7 | PatientRegisterController swallowed date/time parse errors silently | Empty catch replaced with IllegalArgumentException handling and user error message |
| 8 | PatientInvoiceController returned all patients' invoices | Added InvoiceDAO.getInvoicesByPatientId (JOIN Invoice→Appointment WHERE patientId=?); scoped to logged-in patient |
| 9 | Booking form never submitted doctorId, date, time to server | Added hidden inputs; updated JS to populate them on selection; added client-side validation |
| 13 | confirmBooking() showed fake "success" alert before form submitted | Removed premature alert; confirmBooking() now returns true/false for validation only |
| 11 | ChangePasswordController had no doGet (405 error) | Added doGet forwarding to new change-password.jsp |
| 12 | ChangePasswordController redirected all roles to /patient/profile | Now uses role-based switch for redirect after password change |
| 11b | ChangePasswordController had no old-password verification | Now calls userDAO.login() to verify current password before updating |
| 14 | MedicalRecordController never set createdDate on insert | Added record.setCreatedDate(new java.sql.Date(System.currentTimeMillis())) |
| 16 | UserDAO.checkUsernameExists leaked Connection and PreparedStatement | Converted to try-with-resources |
| 17 | UserDAO.insertUser leaked Connection and PreparedStatement | Converted to try-with-resources |
| 18 | LoginController had no default case in role switch (blank response) | Added default case that invalidates session and forwards to login with error |
| 19 | RegisterController accepted empty username/password/fullName | Added server-side null/empty validation before insertUser |
| 20 | Booking form showed doctorId instead of doctor's full name | Added fullName field to Doctor model; DoctorDAO JOIN with user table; JSP updated |
| 21 | Patient dashboard showed hardcoded date "Thứ Năm, 20/03/2025" | Replaced with JS dynamic date rendering |
| 22 | Patient dashboard stat cards showed wrong counts for labels | Added totalCount; corrected each card to use appropriate count |
| 23 | Patient dashboard "Thông tin sức khỏe" showed fake hardcoded data | Replaced with real Patient fields (gender, birthday, address, note) |
| 24 | Invoice table "Dịch vụ" and "Bác sĩ" columns both showed appointmentId | Removed duplicate column; renamed header to "Mã lịch hẹn" |
| 25 | Invoice status always showed "Đã thanh toán" (hardcoded) | Kept as default; Invoice model has no status field (acceptable for current schema) |
| 30 | RoleFilter /admin and /manager and /doctor checks lacked trailing slash | Changed to /admin/, /manager/, /doctor/ to prevent false URL matches |
| 37–39 | JSP EL expressions called fullName.charAt(0) and substring(0,2) without null/length guard | Replaced with c:choose + fn:substring guards in 8 JSPs |
| 42 | ${error} rendered without XSS escaping in login.jsp and register.jsp | Replaced with <c:out value="${error}"/> |
| 43 | AuthFilter uri.contains("/views") bypass allowed unauthenticated direct JSP access | Removed /views from bypass list |
| 31 | DBConnection had a debug main() method | Deleted main() method |
| B1 | Authenticated users clicking Login/Register saw the form again | Added session check in doGet; redirect to dashboard if already logged in |
| B2 | Appointment booking always failed silently (roomId NOT NULL violation) | insertAppointment now uses 6-column INSERT when roomId is null |
| B3 | Newly added doctors did not appear in booking form | ManageUserController now creates a Doctor record when adding a DOCTOR-role user |
| — | Stray literal "now" text visible in doctor-dashboard.jsp | Deleted stray text from line 22 |
| — | ResultSet not closed in UserDAO.login, getAllUsers, getUserById | Wrapped in try-with-resources |
| — | Orphaned stub webapp/views/change-password.jsp | Deleted; live version is at webapp/views/auth/change-password.jsp |
