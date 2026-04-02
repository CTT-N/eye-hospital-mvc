# Frontend–Backend Integration Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Convert all 25 static HTML pages in `fe/` into live JSP pages wired to real database data via existing Java Servlet controllers.

**Architecture:** Each `fe/*.html` file becomes a `webapp/views/**/*.jsp`. CSS/JS/images move to `webapp/static/`. Controllers load data from DAOs, set request attributes, and forward to the JSP, which renders with JSTL `<c:forEach>` and EL `${...}`.

**Tech Stack:** Jakarta Servlet 6.0, JSP, JSTL 3.0, raw JDBC, MySQL 8.0, Apache Tomcat 10

---

## File Map

**Move (Phase 1):**
- `fe/css/**` → `webapp/static/css/`
- `fe/js/**` → `webapp/static/js/`
- `fe/images/**` → `webapp/static/images/`

**Modify:**
- `src/filter/AuthFilter.java` — update exclusion paths
- `src/dao/UserDAO.java` — fix `login()` to return all User fields
- `webapp/WEB-INF/web.xml` — add 3 new servlet mappings
- All existing controllers — update JSP forward paths and add DAO calls

**Create (JSPs):**
- `webapp/views/auth/login.jsp`, `register.jsp`
- `webapp/views/patient/patient-dashboard.jsp`, `patient-appointments.jsp`, `patient-history.jsp`, `patient-invoices.jsp`, `patient-profile.jsp`, `book-appointment.jsp`
- `webapp/views/doctor/doctor-dashboard.jsp`, `doctor-patient-list.jsp`, `doctor-patient-record.jsp`, `doctor-schedule.jsp`, `doctor-appointment-detail.jsp`, `doctor-profile.jsp`
- `webapp/views/manager/manager-dashboard.jsp`, `manager-departments.jsp`, `manager-rooms.jsp`, `manager-schedules.jsp`, `manager-hospital-info.jsp`, `manager-reports.jsp`
- `webapp/views/admin/admin-dashboard.jsp`, `admin-users.jsp`, `admin-eye-diseases.jsp`
- `webapp/views/common/find-doctor.jsp`
- `webapp/views/home.jsp`

**Create (Controllers):**
- `src/controller/patient/PatientProfileController.java`
- `src/controller/doctor/DoctorProfileController.java`
- `src/controller/common/FindDoctorController.java`

---

## Phase 1 — Foundation

### Task 1: Copy static assets into webapp

**Files:**
- Create: `webapp/static/css/` (copy all files from `fe/css/`)
- Create: `webapp/static/js/` (copy all files from `fe/js/`)
- Create: `webapp/static/images/` (copy all files from `fe/images/`)

- [ ] **Step 1: Copy assets**

```bash
cp -r fe/css  webapp/static/css
cp -r fe/js   webapp/static/js
cp -r fe/images webapp/static/images
```

- [ ] **Step 2: Verify files are in place**

```bash
ls webapp/static/css | head -5
ls webapp/static/js  | head -5
```
Expected: you should see files like `variables.css`, `base.css`, `login.js`, etc.

- [ ] **Step 3: Commit**

```bash
git add webapp/static
git commit -m "feat: copy fe static assets into webapp/static"
```

---

### Task 2: Add JSTL 3.0 to the project

**Files:**
- Add: `webapp/WEB-INF/lib/jakarta.servlet.jsp.jstl-3.0.0.jar`
- Add: `webapp/WEB-INF/lib/jakarta.servlet.jsp.jstl-api-3.0.0.jar`

- [ ] **Step 1: Download JSTL jars**

Download both jars from Maven Central and place them in `webapp/WEB-INF/lib/`:
- `jakarta.servlet.jsp.jstl-3.0.0.jar` — the implementation
- `jakarta.servlet.jsp.jstl-api-3.0.0.jar` — the API

You can find these at: `https://mvnrepository.com/artifact/org.glassfish.web/jakarta.servlet.jsp.jstl`

- [ ] **Step 2: Verify jars are present**

```bash
ls webapp/WEB-INF/lib | grep jstl
```
Expected: two jstl jar files listed.

- [ ] **Step 3: Commit**

```bash
git add webapp/WEB-INF/lib/jakarta.servlet.jsp.jstl-3.0.0.jar
git add webapp/WEB-INF/lib/jakarta.servlet.jsp.jstl-api-3.0.0.jar
git commit -m "feat: add JSTL 3.0 jars for JSP rendering"
```

---

### Task 3: Fix UserDAO.login() to return all User fields

Currently `UserDAO.login()` only populates `userId`, `username`, `role`. This means `user.getFullName()` is null everywhere. Fix it to return all fields.

**Files:**
- Modify: `src/dao/UserDAO.java`

- [ ] **Step 1: Update the login() method**

In `src/dao/UserDAO.java`, replace the `login()` method body:

```java
public User login(String username, String password) {
    String sql = "SELECT * FROM user WHERE username=? AND password=?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, username);
        ps.setString(2, password);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            User user = new User();
            user.setUserId(rs.getString("userId"));
            user.setUsername(rs.getString("username"));
            user.setPassword(rs.getString("password"));
            user.setFullName(rs.getString("fullName"));
            user.setEmail(rs.getString("email"));
            user.setPhone(rs.getString("phone"));
            user.setRole(rs.getString("role"));
            user.setDescription(rs.getString("description"));
            return user;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}
```

Also add a `getUserById()` method at the end of the class (needed by profile controllers):

```java
public User getUserById(String userId) {
    String sql = "SELECT * FROM user WHERE userId=?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, userId);
        ResultSet rs = ps.executeQuery();
        if (rs.next()) {
            User user = new User();
            user.setUserId(rs.getString("userId"));
            user.setUsername(rs.getString("username"));
            user.setFullName(rs.getString("fullName"));
            user.setEmail(rs.getString("email"));
            user.setPhone(rs.getString("phone"));
            user.setRole(rs.getString("role"));
            user.setDescription(rs.getString("description"));
            return user;
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return null;
}

public boolean updateUser(User user) {
    String sql = "UPDATE user SET fullName=?, email=?, phone=? WHERE userId=?";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {
        ps.setString(1, user.getFullName());
        ps.setString(2, user.getEmail());
        ps.setString(3, user.getPhone());
        ps.setString(4, user.getUserId());
        return ps.executeUpdate() > 0;
    } catch (Exception e) {
        e.printStackTrace();
    }
    return false;
}
```

- [ ] **Step 2: Commit**

```bash
git add src/dao/UserDAO.java
git commit -m "fix: UserDAO.login() now populates all User fields; add getUserById, updateUser"
```

---

### Task 4: Update AuthFilter for new paths

**Files:**
- Modify: `src/filter/AuthFilter.java`

- [ ] **Step 1: Replace doFilter logic**

Replace the entire `doFilter` method body in `src/filter/AuthFilter.java`:

```java
@Override
public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
        throws IOException, ServletException {

    HttpServletRequest req = (HttpServletRequest) request;
    HttpServletResponse resp = (HttpServletResponse) response;

    String uri = req.getRequestURI();

    // Allow public paths — no login required
    if (uri.contains("/auth/") ||
        uri.contains("/static/") ||
        uri.contains("/common/find-doctor") ||
        uri.endsWith("home") ||
        uri.equals(req.getContextPath() + "/") ||
        uri.contains("/views")) {
        chain.doFilter(request, response);
        return;
    }

    HttpSession session = req.getSession(false);
    if (session == null || session.getAttribute("user") == null) {
        resp.sendRedirect(req.getContextPath() + "/auth/login");
        return;
    }

    chain.doFilter(request, response);
}
```

- [ ] **Step 2: Commit**

```bash
git add src/filter/AuthFilter.java
git commit -m "fix: AuthFilter allows /static/, /auth/, /common/find-doctor public access"
```

---

### Task 5: Convert login.html → login.jsp

**Files:**
- Modify: `webapp/views/auth/login.jsp` (already used by LoginController — replace contents)

- [ ] **Step 1: Replace login.jsp content**

Copy `fe/login.html` to `webapp/views/auth/login.jsp`, then make these changes at the top of the file:

Add JSP directive after `<!DOCTYPE html>`:
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

Change all `../css/` asset paths to use context path. Replace each `<link href="../css/...">` with:
```jsp
<link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/auth.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/login.css" rel="stylesheet">
```

Fix the form action (find `<form action="LoginServlet"` and replace):
```jsp
<form action="${pageContext.request.contextPath}/auth/login" method="post" id="loginForm">
```

Add error display block just above the form's submit button:
```jsp
<c:if test="${not empty error}">
  <div class="alert alert-danger" style="margin-bottom:12px">${error}</div>
</c:if>
```

Fix the JS script src at the bottom (replace `<script src="../js/login.js">`):
```jsp
<script src="${pageContext.request.contextPath}/static/js/login.js"></script>
```

Fix the register link (find `href="register.html"` and replace):
```jsp
href="${pageContext.request.contextPath}/auth/register"
```

- [ ] **Step 2: Deploy to Tomcat and verify**

Start Tomcat, navigate to `http://localhost:8080/webapp/auth/login`.
Expected: login page renders with correct styling. Try wrong credentials → error message shows. Try correct credentials → redirected to role dashboard.

- [ ] **Step 3: Commit**

```bash
git add webapp/views/auth/login.jsp
git commit -m "feat: login.jsp wired to /auth/login with real auth and error display"
```

---

### Task 6: Convert register.html → register.jsp

**Files:**
- Create: `webapp/views/auth/register.jsp`
- Verify: `src/controller/auth/RegisterController.java` maps to `/auth/register` in web.xml

- [ ] **Step 1: Create register.jsp**

Copy `fe/register.html` to `webapp/views/auth/register.jsp`. Apply same changes as login.jsp:

Add at top:
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

Fix asset paths — replace all `../css/` references:
```jsp
<link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/auth.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/register.css" rel="stylesheet">
```

Fix form action (find `<form` with register action):
```jsp
<form action="${pageContext.request.contextPath}/auth/register" method="post">
```

Add error/success display above submit:
```jsp
<c:if test="${not empty error}">
  <div class="alert alert-danger">${error}</div>
</c:if>
<c:if test="${not empty success}">
  <div class="alert alert-success">${success}</div>
</c:if>
```

Fix login link:
```jsp
href="${pageContext.request.contextPath}/auth/login"
```

Fix JS script src:
```jsp
<script src="${pageContext.request.contextPath}/static/js/register.js"></script>
```

- [ ] **Step 2: Check RegisterController forwards to this JSP**

Open `src/controller/auth/RegisterController.java`. Verify its doGet forwards to `/views/auth/register.jsp`. If it doesn't, update the forward path.

- [ ] **Step 3: Deploy and verify**

Navigate to `http://localhost:8080/webapp/auth/register`. Expected: register form renders with correct styling.

- [ ] **Step 4: Commit**

```bash
git add webapp/views/auth/register.jsp
git commit -m "feat: register.jsp wired to /auth/register"
```

---

## Phase 2 — Patient Role

### Task 7: Patient Dashboard

**Files:**
- Modify: `webapp/views/patient/patient-dashboard.jsp` (replace stub)
- Modify: `src/controller/patient/PatientDashboardController.java`

- [ ] **Step 1: Update PatientDashboardController to load data**

Replace the full content of `src/controller/patient/PatientDashboardController.java`:

```java
package controller.patient;

import dao.AppointmentDAO;
import dao.PatientDAO;
import model.Appointment;
import model.Patient;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class PatientDashboardController extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("user");
        Patient patient = patientDAO.getPatientByUserId(user.getUserId());

        long upcomingCount = 0;
        long pendingCount = 0;
        if (patient != null) {
            List<Appointment> appts = appointmentDAO.getAppointmentsByPatientId(patient.getPatientId());
            upcomingCount = appts.stream().filter(a -> "CONFIRMED".equalsIgnoreCase(a.getStatus())).count();
            pendingCount  = appts.stream().filter(a -> "PENDING".equalsIgnoreCase(a.getStatus())).count();
            req.setAttribute("appointments", appts);
        }
        req.setAttribute("patient", patient);
        req.setAttribute("upcomingCount", upcomingCount);
        req.setAttribute("pendingCount", pendingCount);

        req.getRequestDispatcher("/views/patient/patient-dashboard.jsp").forward(req, resp);
    }
}
```

- [ ] **Step 2: Create patient-dashboard.jsp**

Copy `fe/patient/dashboard.html` to `webapp/views/patient/patient-dashboard.jsp`.

Add at very top of file:
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

Fix all asset paths (replace `../css/` and `../js/`):
```jsp
<link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/patient-dashboard.css" rel="stylesheet">
```

Fix all sidebar navigation links (replace `.html` links):
```jsp
<a href="${pageContext.request.contextPath}/patient/dashboard" class="nav-link-h active">
<a href="${pageContext.request.contextPath}/patient/appointment" class="nav-link-h">
<a href="${pageContext.request.contextPath}/patient/appointments" class="nav-link-h">
<a href="${pageContext.request.contextPath}/patient/history" class="nav-link-h">
<a href="${pageContext.request.contextPath}/patient/invoices" class="nav-link-h">
<a href="${pageContext.request.contextPath}/patient/profile" class="nav-link-h">
```

Fix logout link:
```jsp
<a href="${pageContext.request.contextPath}/auth/logout">Đăng xuất</a>
```

Replace the hardcoded user name in sidebar footer and topbar with real data:
```jsp
<!-- In sidebar-footer -->
<div class="user-name">${sessionScope.user.fullName}</div>
<div class="user-role">Bệnh nhân</div>

<!-- In topbar -->
<span class="user-name">${sessionScope.user.fullName}</span>
```

Replace hardcoded stat numbers with EL:
```jsp
<!-- Find the stat cards and replace the hardcoded numbers -->
<div class="stat-value">${upcomingCount}</div>  <!-- upcoming confirmed -->
<div class="stat-value">${pendingCount}</div>   <!-- pending -->
```

Fix JS script path:
```jsp
<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
```

- [ ] **Step 3: Deploy and verify**

Login as a PATIENT. Should redirect to `/patient/dashboard`. Expected: dashboard renders with real patient name in sidebar and real appointment counts.

- [ ] **Step 4: Commit**

```bash
git add src/controller/patient/PatientDashboardController.java webapp/views/patient/patient-dashboard.jsp
git commit -m "feat: patient dashboard shows real appointment counts and user name"
```

---

### Task 8: Patient Appointments List

**Files:**
- Create: `webapp/views/patient/patient-appointments.jsp`
- Modify: `src/controller/patient/PatientHistoryController.java` (reuse for appointments list — see note)

Note: Currently `PatientAppointmentController` maps to `/patient/appointment` (book appointment form). We need a separate URL `/patient/appointments` for the list view. Add a new doGet to `PatientAppointmentController` that checks a `view` parameter, or create a dedicated `PatientAppointmentListController`. Use the existing `PatientHistoryController` for the list — check what it currently does first, and if empty, use it for the appointments list.

- [ ] **Step 1: Check PatientHistoryController**

Open `src/controller/patient/PatientHistoryController.java`. If its doGet only forwards to a JSP with no data, update it to load the appointment list.

- [ ] **Step 2: Create patient-appointments.jsp**

Copy `fe/patient/appointments.html` to `webapp/views/patient/patient-appointments.jsp`.

Add at top:
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

Fix asset paths (same pattern as dashboard — replace `../css/` and `../js/`):
```jsp
<link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
```

Fix sidebar nav links (same as dashboard).

Replace the hardcoded `<tbody>` rows with a JSTL loop. Find the `<tbody>` section and replace its contents:
```jsp
<tbody id="apptTable">
<c:choose>
  <c:when test="${empty appointments}">
    <tr><td colspan="5" style="text-align:center;padding:24px;color:var(--text-muted)">Không có lịch hẹn nào</td></tr>
  </c:when>
  <c:otherwise>
    <c:forEach var="appt" items="${appointments}">
    <tr data-status="${appt.status}">
      <td>${appt.appointmentId}</td>
      <td>${appt.date}</td>
      <td>${appt.time}</td>
      <td>${appt.doctorId}</td>
      <td><span class="badge-status badge-${appt.status.toLowerCase()}">${appt.status}</span></td>
      <td class="action-cell">
        <c:if test="${appt.status == 'PENDING' || appt.status == 'CONFIRMED'}">
          <button class="btn-hospital btn-danger-h btn-sm" onclick="openCancel(this)">Huỷ</button>
        </c:if>
      </td>
    </tr>
    </c:forEach>
  </c:otherwise>
</c:choose>
</tbody>
```

Replace user name references with `${sessionScope.user.fullName}`.

Fix JS script path:
```jsp
<script src="${pageContext.request.contextPath}/static/js/patient-appointments.js"></script>
<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
```

- [ ] **Step 3: Update controller to load appointments**

Update the doGet of whichever controller maps to `/patient/appointments` to load and forward appointments:

```java
User user = (User) req.getSession().getAttribute("user");
Patient patient = new PatientDAO().getPatientByUserId(user.getUserId());
List<Appointment> appointments = new ArrayList<>();
if (patient != null) {
    appointments = new AppointmentDAO().getAppointmentsByPatientId(patient.getPatientId());
}
req.setAttribute("appointments", appointments);
req.getRequestDispatcher("/views/patient/patient-appointments.jsp").forward(req, resp);
```

- [ ] **Step 4: Ensure web.xml has `/patient/appointments` mapped**

Check `webapp/WEB-INF/web.xml`. If no mapping for `/patient/appointments` exists, add one pointing to the controller you updated.

- [ ] **Step 5: Deploy and verify**

Login as PATIENT, navigate to `/patient/appointments`. Expected: table shows real appointments from DB, or empty state message.

- [ ] **Step 6: Commit**

```bash
git add webapp/views/patient/patient-appointments.jsp src/controller/patient/
git commit -m "feat: patient appointments list renders real data from DB"
```

---

### Task 9: Patient Medical History

**Files:**
- Create: `webapp/views/patient/patient-history.jsp`
- Modify: relevant controller for `/patient/history`

- [ ] **Step 1: Update controller for /patient/history**

Find which controller handles `/patient/history` in web.xml. Update its doGet:

```java
User user = (User) req.getSession().getAttribute("user");
Patient patient = new PatientDAO().getPatientByUserId(user.getUserId());
List<MedicalRecord> records = new ArrayList<>();
if (patient != null) {
    List<Appointment> appts = new AppointmentDAO().getAppointmentsByPatientId(patient.getPatientId());
    MedicalRecordDAO recordDAO = new MedicalRecordDAO();
    for (Appointment appt : appts) {
        MedicalRecord rec = recordDAO.getRecordByAppointmentId(appt.getAppointmentId());
        if (rec != null) records.add(rec);
    }
}
req.setAttribute("records", records);
req.getRequestDispatcher("/views/patient/patient-history.jsp").forward(req, resp);
```

Add imports: `dao.MedicalRecordDAO`, `model.MedicalRecord`.

- [ ] **Step 2: Create patient-history.jsp**

Copy `fe/patient/history.html` to `webapp/views/patient/patient-history.jsp`.

Add JSP directives at top:
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

Fix asset paths and sidebar links (same pattern as previous JSPs).

Replace hardcoded history rows in `<tbody>`:
```jsp
<tbody>
<c:choose>
  <c:when test="${empty records}">
    <tr><td colspan="5" style="text-align:center;padding:24px;color:var(--text-muted)">Chưa có bệnh án nào</td></tr>
  </c:when>
  <c:otherwise>
    <c:forEach var="rec" items="${records}">
    <tr>
      <td>${rec.recordId}</td>
      <td>${rec.createdDate}</td>
      <td>${rec.diagnosis}</td>
      <td>${rec.treatment}</td>
      <td>${rec.note}</td>
    </tr>
    </c:forEach>
  </c:otherwise>
</c:choose>
</tbody>
```

Replace user name with `${sessionScope.user.fullName}`.

- [ ] **Step 3: Deploy and verify**

Login as PATIENT, navigate to `/patient/history`. Expected: medical records listed or empty state.

- [ ] **Step 4: Commit**

```bash
git add webapp/views/patient/patient-history.jsp src/controller/patient/PatientHistoryController.java
git commit -m "feat: patient history shows real medical records from DB"
```

---

### Task 10: Patient Invoices

**Files:**
- Create: `webapp/views/patient/patient-invoices.jsp`
- Modify: `src/controller/patient/PatientInvoiceController.java`

- [ ] **Step 1: Update PatientInvoiceController doGet**

```java
User user = (User) req.getSession().getAttribute("user");
Patient patient = new PatientDAO().getPatientByUserId(user.getUserId());
List<Invoice> invoices = new ArrayList<>();
if (patient != null) {
    List<Appointment> appts = new AppointmentDAO().getAppointmentsByPatientId(patient.getPatientId());
    InvoiceDAO invoiceDAO = new InvoiceDAO();
    for (Appointment appt : appts) {
        invoices.addAll(invoiceDAO.getInvoicesByAppointmentId(appt.getAppointmentId()));
    }
}
req.setAttribute("invoices", invoices);
req.getRequestDispatcher("/views/patient/patient-invoices.jsp").forward(req, resp);
```

Add imports: `dao.InvoiceDAO`, `dao.AppointmentDAO`, `dao.PatientDAO`, `model.Invoice`, `model.Appointment`, `model.Patient`, `model.User`, `java.util.ArrayList`, `java.util.List`.

- [ ] **Step 2: Create patient-invoices.jsp**

Copy `fe/patient/invoices.html` to `webapp/views/patient/patient-invoices.jsp`.

Add at top:
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

Fix asset paths and sidebar links.

Replace hardcoded invoice rows:
```jsp
<tbody>
<c:choose>
  <c:when test="${empty invoices}">
    <tr><td colspan="4" style="text-align:center;padding:24px;color:var(--text-muted)">Không có hóa đơn nào</td></tr>
  </c:when>
  <c:otherwise>
    <c:forEach var="inv" items="${invoices}">
    <tr>
      <td>${inv.invoiceId}</td>
      <td>${inv.appointmentId}</td>
      <td>${inv.date}</td>
      <td>${inv.totalAmount} VNĐ</td>
    </tr>
    </c:forEach>
  </c:otherwise>
</c:choose>
</tbody>
```

Replace user name with `${sessionScope.user.fullName}`.

- [ ] **Step 3: Deploy and verify**

Login as PATIENT, navigate to `/patient/invoices`. Expected: invoice list or empty state.

- [ ] **Step 4: Commit**

```bash
git add webapp/views/patient/patient-invoices.jsp src/controller/patient/PatientInvoiceController.java
git commit -m "feat: patient invoices loads real invoice data from DB"
```

---

### Task 11: Patient Profile — new controller

**Files:**
- Create: `src/controller/patient/PatientProfileController.java`
- Create: `webapp/views/patient/patient-profile.jsp`
- Modify: `webapp/WEB-INF/web.xml`

- [ ] **Step 1: Create PatientProfileController.java**

Create `src/controller/patient/PatientProfileController.java`:

```java
package controller.patient;

import dao.PatientDAO;
import dao.UserDAO;
import model.Patient;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class PatientProfileController extends HttpServlet {

    private final PatientDAO patientDAO = new PatientDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        Patient patient = patientDAO.getPatientByUserId(user.getUserId());
        req.setAttribute("patient", patient);
        req.getRequestDispatcher("/views/patient/patient-profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");

        user.setFullName(req.getParameter("fullName"));
        user.setEmail(req.getParameter("email"));
        user.setPhone(req.getParameter("phone"));
        userDAO.updateUser(user);

        // Update session with new name
        req.getSession().setAttribute("user", user);

        Patient patient = patientDAO.getPatientByUserId(user.getUserId());
        if (patient != null) {
            patient.setAddress(req.getParameter("address"));
            patient.setGender(req.getParameter("gender"));
            patientDAO.updatePatient(patient);
        }

        resp.sendRedirect(req.getContextPath() + "/patient/profile?msg=updated");
    }
}
```

- [ ] **Step 2: Register in web.xml**

Add inside `<web-app>` in `webapp/WEB-INF/web.xml`:

```xml
<servlet>
    <servlet-name>PatientProfileController</servlet-name>
    <servlet-class>controller.patient.PatientProfileController</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>PatientProfileController</servlet-name>
    <url-pattern>/patient/profile</url-pattern>
</servlet-mapping>
```

- [ ] **Step 3: Create patient-profile.jsp**

Copy `fe/patient/profile.html` to `webapp/views/patient/patient-profile.jsp`.

Add at top:
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

Fix asset paths and sidebar links.

Fix the profile form action:
```jsp
<form action="${pageContext.request.contextPath}/patient/profile" method="post">
```

Replace hardcoded field values with real data:
```jsp
<input type="text" name="fullName" value="${sessionScope.user.fullName}" class="form-control-h">
<input type="email" name="email" value="${sessionScope.user.email}" class="form-control-h">
<input type="text" name="phone" value="${sessionScope.user.phone}" class="form-control-h">
<input type="text" name="address" value="${patient.address}" class="form-control-h">
<input type="text" name="gender" value="${patient.gender}" class="form-control-h">
```

Add success message display:
```jsp
<c:if test="${param.msg == 'updated'}">
  <div class="alert alert-success">Cập nhật thành công!</div>
</c:if>
```

- [ ] **Step 4: Deploy and verify**

Login as PATIENT, navigate to `/patient/profile`. Expected: form pre-filled with real data. Submit → success message shown.

- [ ] **Step 5: Commit**

```bash
git add src/controller/patient/PatientProfileController.java webapp/views/patient/patient-profile.jsp webapp/WEB-INF/web.xml
git commit -m "feat: patient profile page with real data and save"
```

---

## Phase 3 — Doctor Role

### Task 12: Doctor Dashboard

**Files:**
- Modify: `src/controller/doctor/DoctorDashboardController.java`
- Modify: `webapp/views/doctor/doctor-dashboard.jsp` (replace stub)

- [ ] **Step 1: Update DoctorDashboardController**

Replace full content of `src/controller/doctor/DoctorDashboardController.java`:

```java
package controller.doctor;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import model.Appointment;
import model.Doctor;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.stream.Collectors;

public class DoctorDashboardController extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final DoctorDAO doctorDAO = new DoctorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());

        List<Appointment> todayAppts = new java.util.ArrayList<>();
        long pendingCount = 0;
        if (doctor != null) {
            List<Appointment> all = appointmentDAO.getAppointmentsByDoctorId(doctor.getDoctorId());
            Date today = new Date(System.currentTimeMillis());
            todayAppts = all.stream()
                .filter(a -> today.toString().equals(a.getDate() != null ? a.getDate().toString() : ""))
                .collect(Collectors.toList());
            pendingCount = all.stream().filter(a -> "PENDING".equalsIgnoreCase(a.getStatus())).count();
            req.setAttribute("totalAppointments", all.size());
        }
        req.setAttribute("doctor", doctor);
        req.setAttribute("todayAppointments", todayAppts);
        req.setAttribute("pendingCount", pendingCount);

        req.getRequestDispatcher("/views/doctor/doctor-dashboard.jsp").forward(req, resp);
    }
}
```

- [ ] **Step 2: Create doctor-dashboard.jsp**

Copy `fe/doctor/dashboard.html` to `webapp/views/doctor/doctor-dashboard.jsp`.

Add at top:
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

Fix asset paths (replace `../css/` → context path):
```jsp
<link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/doctor-dashboard.css" rel="stylesheet">
```

Fix all sidebar nav links (replace `.html` references):
```jsp
<a href="${pageContext.request.contextPath}/doctor/dashboard">
<a href="${pageContext.request.contextPath}/doctor/patient-list">
<a href="${pageContext.request.contextPath}/doctor/schedule">
<a href="${pageContext.request.contextPath}/doctor/profile">
<a href="${pageContext.request.contextPath}/auth/logout">
```

Replace hardcoded user/stat values:
```jsp
${sessionScope.user.fullName}   <!-- doctor name in sidebar/topbar -->
${pendingCount}                 <!-- pending appointments stat -->
${totalAppointments}            <!-- total appointments stat -->
```

Replace today's appointment rows with JSTL loop:
```jsp
<c:forEach var="appt" items="${todayAppointments}">
<tr>
  <td>${appt.appointmentId}</td>
  <td>${appt.time}</td>
  <td>${appt.patientId}</td>
  <td><span class="badge-status badge-${appt.status.toLowerCase()}">${appt.status}</span></td>
  <td><a href="${pageContext.request.contextPath}/doctor/appointment-detail?id=${appt.appointmentId}" class="btn-hospital btn-sm">Xem</a></td>
</tr>
</c:forEach>
```

Fix JS script path:
```jsp
<script src="${pageContext.request.contextPath}/static/js/doctor-dashboard.js"></script>
<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
```

- [ ] **Step 3: Deploy and verify**

Login as DOCTOR. Expected: dashboard shows doctor name, today's appointments from DB.

- [ ] **Step 4: Commit**

```bash
git add src/controller/doctor/DoctorDashboardController.java webapp/views/doctor/doctor-dashboard.jsp
git commit -m "feat: doctor dashboard shows real today appointments and stats"
```

---

### Task 13: Doctor Patient List

**Files:**
- Modify: `src/controller/doctor/PatientListController.java`
- Create: `webapp/views/doctor/doctor-patient-list.jsp`

- [ ] **Step 1: Update PatientListController**

Update doGet to load all patients and forward:

```java
List<Patient> patients = new PatientDAO().getAllPatients();
req.setAttribute("patients", patients);
req.getRequestDispatcher("/views/doctor/doctor-patient-list.jsp").forward(req, resp);
```

Add imports: `dao.PatientDAO`, `model.Patient`, `java.util.List`.

- [ ] **Step 2: Create doctor-patient-list.jsp**

Copy `fe/doctor/patient-list.html` to `webapp/views/doctor/doctor-patient-list.jsp`.

Add at top:
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

Fix asset paths and sidebar links (same pattern).

Replace hardcoded patient rows:
```jsp
<tbody>
<c:forEach var="p" items="${patients}">
<tr>
  <td>${p.patientId}</td>
  <td>${p.userId}</td>
  <td>${p.gender}</td>
  <td>${p.birthday}</td>
  <td>${p.address}</td>
  <td>
    <a href="${pageContext.request.contextPath}/doctor/patient-record?patientId=${p.patientId}" class="btn-hospital btn-sm">Xem hồ sơ</a>
  </td>
</tr>
</c:forEach>
</tbody>
```

Fix JS script path:
```jsp
<script src="${pageContext.request.contextPath}/static/js/doctor-patient-list.js"></script>
```

- [ ] **Step 3: Verify web.xml has /doctor/patient-list mapped**

Check `webapp/WEB-INF/web.xml` for `PatientListController` mapping. Confirm it maps to `/doctor/patient-list`.

- [ ] **Step 4: Deploy and verify**

Login as DOCTOR, navigate to `/doctor/patient-list`. Expected: patient table with real DB data.

- [ ] **Step 5: Commit**

```bash
git add src/controller/doctor/PatientListController.java webapp/views/doctor/doctor-patient-list.jsp
git commit -m "feat: doctor patient list loads real patients from DB"
```

---

### Task 14: Doctor Patient Record

**Files:**
- Modify: `src/controller/doctor/MedicalRecordController.java`
- Create: `webapp/views/doctor/doctor-patient-record.jsp`

- [ ] **Step 1: Update MedicalRecordController doGet**

Load medical record by appointmentId from query param:

```java
String appointmentId = req.getParameter("appointmentId");
MedicalRecord record = null;
Appointment appt = null;
if (appointmentId != null) {
    record = new MedicalRecordDAO().getRecordByAppointmentId(appointmentId);
    appt = new AppointmentDAO().getAppointmentById(appointmentId);
}
req.setAttribute("record", record);
req.setAttribute("appointment", appt);
req.getRequestDispatcher("/views/doctor/doctor-patient-record.jsp").forward(req, resp);
```

- [ ] **Step 2: Create doctor-patient-record.jsp**

Copy `fe/doctor/patient-record.html` to `webapp/views/doctor/doctor-patient-record.jsp`.

Add at top:
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

Fix asset paths and sidebar links.

Replace hardcoded record fields with EL:
```jsp
<div class="detail-value">${record.diagnosis}</div>
<div class="detail-value">${record.symptoms}</div>
<div class="detail-value">${record.treatment}</div>
<div class="detail-value">${record.note}</div>
<div class="detail-value">${record.createdDate}</div>
```

Add null guard around record display:
```jsp
<c:if test="${record == null}">
  <p style="color:var(--text-muted)">Chưa có bệnh án cho lịch hẹn này.</p>
</c:if>
```

Fix JS script path:
```jsp
<script src="${pageContext.request.contextPath}/static/js/doctor-patient-record.js"></script>
```

- [ ] **Step 3: Deploy and verify**

Login as DOCTOR, navigate to `/doctor/patient-record?appointmentId=<valid-id>`. Expected: medical record data shown.

- [ ] **Step 4: Commit**

```bash
git add src/controller/doctor/MedicalRecordController.java webapp/views/doctor/doctor-patient-record.jsp
git commit -m "feat: doctor patient record loads real medical record from DB"
```

---

### Task 15: Doctor Schedule

**Files:**
- Modify: `src/controller/doctor/DoctorScheduleController.java`
- Create: `webapp/views/doctor/doctor-schedule.jsp`

- [ ] **Step 1: Update DoctorScheduleController doGet**

```java
User user = (User) req.getSession().getAttribute("user");
Doctor doctor = new DoctorDAO().getDoctorByUserId(user.getUserId());
List<Appointment> schedule = new java.util.ArrayList<>();
if (doctor != null) {
    schedule = new AppointmentDAO().getAppointmentsByDoctorId(doctor.getDoctorId());
}
req.setAttribute("schedule", schedule);
req.getRequestDispatcher("/views/doctor/doctor-schedule.jsp").forward(req, resp);
```

- [ ] **Step 2: Create doctor-schedule.jsp**

Copy `fe/doctor/schedule.html` to `webapp/views/doctor/doctor-schedule.jsp`.

Add at top:
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

Fix asset paths and sidebar links.

Replace hardcoded schedule rows:
```jsp
<tbody>
<c:forEach var="appt" items="${schedule}">
<tr>
  <td>${appt.date}</td>
  <td>${appt.time}</td>
  <td>${appt.patientId}</td>
  <td>${appt.roomId}</td>
  <td><span class="badge-status badge-${appt.status.toLowerCase()}">${appt.status}</span></td>
  <td>
    <a href="${pageContext.request.contextPath}/doctor/appointment-detail?id=${appt.appointmentId}" class="btn-hospital btn-sm">Chi tiết</a>
  </td>
</tr>
</c:forEach>
</tbody>
```

Fix JS script path:
```jsp
<script src="${pageContext.request.contextPath}/static/js/doctor-schedule.js"></script>
```

- [ ] **Step 3: Deploy and verify**

Login as DOCTOR, navigate to `/doctor/schedule`. Expected: schedule table with real appointments.

- [ ] **Step 4: Commit**

```bash
git add src/controller/doctor/DoctorScheduleController.java webapp/views/doctor/doctor-schedule.jsp
git commit -m "feat: doctor schedule loads real appointments from DB"
```

---

### Task 16: Doctor Appointment Detail

**Files:**
- Modify: `src/controller/doctor/ExaminationController.java`
- Create: `webapp/views/doctor/doctor-appointment-detail.jsp`

- [ ] **Step 1: Update ExaminationController doGet**

```java
String id = req.getParameter("id");
Appointment appt = new AppointmentDAO().getAppointmentById(id);
MedicalRecord record = new MedicalRecordDAO().getRecordByAppointmentId(id);
req.setAttribute("appointment", appt);
req.setAttribute("record", record);
req.getRequestDispatcher("/views/doctor/doctor-appointment-detail.jsp").forward(req, resp);
```

- [ ] **Step 2: Create doctor-appointment-detail.jsp**

Copy `fe/doctor/appointment-detail.html` to `webapp/views/doctor/doctor-appointment-detail.jsp`.

Add at top:
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

Fix asset paths and sidebar links.

Replace hardcoded appointment detail fields:
```jsp
<div class="detail-value">${appointment.appointmentId}</div>
<div class="detail-value">${appointment.date} ${appointment.time}</div>
<div class="detail-value">${appointment.patientId}</div>
<div class="detail-value">${appointment.roomId}</div>
<div class="detail-value">${appointment.status}</div>
```

Fix any form action for saving examination results:
```jsp
<form action="${pageContext.request.contextPath}/doctor/examination" method="post">
  <input type="hidden" name="appointmentId" value="${appointment.appointmentId}">
  <textarea name="symptoms">${record.symptoms}</textarea>
  <textarea name="diagnosis">${record.diagnosis}</textarea>
  <textarea name="treatment">${record.treatment}</textarea>
  <textarea name="note">${record.note}</textarea>
</form>
```

Fix JS script path:
```jsp
<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
```

- [ ] **Step 3: Verify web.xml mapping for /doctor/appointment-detail**

Add mapping if missing:
```xml
<servlet-mapping>
    <servlet-name>ExaminationController</servlet-name>
    <url-pattern>/doctor/appointment-detail</url-pattern>
</servlet-mapping>
```

- [ ] **Step 4: Deploy and verify**

Login as DOCTOR, navigate to `/doctor/appointment-detail?id=<valid-id>`. Expected: appointment details shown.

- [ ] **Step 5: Commit**

```bash
git add src/controller/doctor/ExaminationController.java webapp/views/doctor/doctor-appointment-detail.jsp
git commit -m "feat: doctor appointment detail loads real appointment and record"
```

---

### Task 17: Doctor Profile — new controller

**Files:**
- Create: `src/controller/doctor/DoctorProfileController.java`
- Create: `webapp/views/doctor/doctor-profile.jsp`
- Modify: `webapp/WEB-INF/web.xml`

- [ ] **Step 1: Create DoctorProfileController.java**

Create `src/controller/doctor/DoctorProfileController.java`:

```java
package controller.doctor;

import dao.DoctorDAO;
import dao.UserDAO;
import model.Doctor;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DoctorProfileController extends HttpServlet {

    private final DoctorDAO doctorDAO = new DoctorDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());
        req.setAttribute("doctor", doctor);
        req.getRequestDispatcher("/views/doctor/doctor-profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        user.setFullName(req.getParameter("fullName"));
        user.setEmail(req.getParameter("email"));
        user.setPhone(req.getParameter("phone"));
        userDAO.updateUser(user);
        req.getSession().setAttribute("user", user);

        Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());
        if (doctor != null) {
            doctor.setExperience(req.getParameter("experience"));
            doctor.setDescription(req.getParameter("description"));
            doctorDAO.updateDoctor(doctor);
        }
        resp.sendRedirect(req.getContextPath() + "/doctor/profile?msg=updated");
    }
}
```

- [ ] **Step 2: Register in web.xml**

```xml
<servlet>
    <servlet-name>DoctorProfileController</servlet-name>
    <servlet-class>controller.doctor.DoctorProfileController</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>DoctorProfileController</servlet-name>
    <url-pattern>/doctor/profile</url-pattern>
</servlet-mapping>
```

- [ ] **Step 3: Create doctor-profile.jsp**

Copy `fe/doctor/profile.html` to `webapp/views/doctor/doctor-profile.jsp`.

Add at top:
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

Fix asset paths and sidebar links. Fix form action:
```jsp
<form action="${pageContext.request.contextPath}/doctor/profile" method="post">
```

Replace hardcoded values:
```jsp
<input type="text" name="fullName" value="${sessionScope.user.fullName}">
<input type="email" name="email" value="${sessionScope.user.email}">
<input type="text" name="phone" value="${sessionScope.user.phone}">
<textarea name="experience">${doctor.experience}</textarea>
<textarea name="description">${doctor.description}</textarea>
```

Add success message:
```jsp
<c:if test="${param.msg == 'updated'}">
  <div class="alert alert-success">Cập nhật thành công!</div>
</c:if>
```

Fix JS script path:
```jsp
<script src="${pageContext.request.contextPath}/static/js/doctor-profile.js"></script>
```

- [ ] **Step 4: Deploy and verify**

Login as DOCTOR, navigate to `/doctor/profile`. Expected: form pre-filled with real doctor data.

- [ ] **Step 5: Commit**

```bash
git add src/controller/doctor/DoctorProfileController.java webapp/views/doctor/doctor-profile.jsp webapp/WEB-INF/web.xml
git commit -m "feat: doctor profile page with real data and save"
```

---

## Phase 4 — Manager Role

### Task 18: Manager Dashboard

**Files:**
- Modify: `src/controller/manager/ManagerDashboardController.java`
- Create: `webapp/views/manager/manager-dashboard.jsp`

- [ ] **Step 1: Update ManagerDashboardController doGet**

```java
List<Doctor> doctors = new DoctorDAO().getAllDoctors();
List<Patient> patients = new PatientDAO().getAllPatients();
List<Appointment> appointments = new AppointmentDAO().getAllAppointments();
req.setAttribute("doctorCount", doctors.size());
req.setAttribute("patientCount", patients.size());
req.setAttribute("appointmentCount", appointments.size());
req.getRequestDispatcher("/views/manager/manager-dashboard.jsp").forward(req, resp);
```

- [ ] **Step 2: Create manager-dashboard.jsp**

Copy `fe/manager/dashboard.html` to `webapp/views/manager/manager-dashboard.jsp`.

Add at top:
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

Fix asset paths (replace `../css/`):
```jsp
<link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/manager-dashboard.css" rel="stylesheet">
```

Fix sidebar links:
```jsp
<a href="${pageContext.request.contextPath}/manager/dashboard">
<a href="${pageContext.request.contextPath}/manager/departments">
<a href="${pageContext.request.contextPath}/manager/rooms">
<a href="${pageContext.request.contextPath}/manager/schedules">
<a href="${pageContext.request.contextPath}/manager/hospital-info">
<a href="${pageContext.request.contextPath}/manager/reports">
<a href="${pageContext.request.contextPath}/auth/logout">
```

Replace stat values:
```jsp
${doctorCount}      <!-- number of doctors -->
${patientCount}     <!-- number of patients -->
${appointmentCount} <!-- number of appointments -->
${sessionScope.user.fullName}
```

Fix JS script path:
```jsp
<script src="${pageContext.request.contextPath}/static/js/manager-dashboard.js"></script>
<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
```

- [ ] **Step 3: Deploy and verify**

Login as MANAGER, navigate to `/manager/dashboard`. Expected: real counts shown.

- [ ] **Step 4: Commit**

```bash
git add src/controller/manager/ManagerDashboardController.java webapp/views/manager/manager-dashboard.jsp
git commit -m "feat: manager dashboard shows real doctor/patient/appointment counts"
```

---

### Task 19: Manager Departments, Rooms, Schedules, Hospital Info, Reports

Each of these follows the same pattern. For each one:
1. Update the controller's doGet to call the DAO and set attributes
2. Copy the HTML to a JSP, fix paths, replace hardcoded rows with JSTL loops
3. Commit

**Files for all 5:**
- `src/controller/manager/DepartmentController.java` + `webapp/views/manager/manager-departments.jsp`
- `src/controller/manager/RoomController.java` + `webapp/views/manager/manager-rooms.jsp`
- `src/controller/manager/ScheduleController.java` + `webapp/views/manager/manager-schedules.jsp`
- `src/controller/manager/HospitalController.java` + `webapp/views/manager/manager-hospital-info.jsp`
- `src/controller/manager/ReportController.java` + `webapp/views/manager/manager-reports.jsp`

- [ ] **Step 1: DepartmentController — load departments**

Update `DepartmentController.java` doGet:
```java
List<Department> departments = new DepartmentDAO().getAllDepartments();
req.setAttribute("departments", departments);
req.getRequestDispatcher("/views/manager/manager-departments.jsp").forward(req, resp);
```

- [ ] **Step 2: Create manager-departments.jsp**

Copy `fe/manager/departments.html` to `webapp/views/manager/manager-departments.jsp`. Add JSP directives, fix asset paths and sidebar links. Replace table body:
```jsp
<tbody>
<c:forEach var="dept" items="${departments}">
<tr>
  <td>${dept.departmentId}</td>
  <td>${dept.departmentName}</td>
  <td>${dept.description}</td>
</tr>
</c:forEach>
</tbody>
```

- [ ] **Step 3: RoomController — load rooms**

Update `RoomController.java` doGet:
```java
List<Room> rooms = new RoomDAO().getAllRooms();
req.setAttribute("rooms", rooms);
req.getRequestDispatcher("/views/manager/manager-rooms.jsp").forward(req, resp);
```

- [ ] **Step 4: Create manager-rooms.jsp**

Copy `fe/manager/rooms.html` to `webapp/views/manager/manager-rooms.jsp`. Fix paths. Replace table body:
```jsp
<tbody>
<c:forEach var="room" items="${rooms}">
<tr>
  <td>${room.roomId}</td>
  <td>${room.roomName}</td>
  <td>${room.departmentId}</td>
  <td>${room.description}</td>
</tr>
</c:forEach>
</tbody>
```

- [ ] **Step 5: ScheduleController — load all appointments as schedule**

Update `ScheduleController.java` doGet:
```java
List<Appointment> schedule = new AppointmentDAO().getAllAppointments();
req.setAttribute("schedule", schedule);
req.getRequestDispatcher("/views/manager/manager-schedules.jsp").forward(req, resp);
```

- [ ] **Step 6: Create manager-schedules.jsp**

Copy `fe/manager/schedules.html` to `webapp/views/manager/manager-schedules.jsp`. Fix paths. Replace table body:
```jsp
<tbody>
<c:forEach var="appt" items="${schedule}">
<tr>
  <td>${appt.appointmentId}</td>
  <td>${appt.date}</td>
  <td>${appt.time}</td>
  <td>${appt.doctorId}</td>
  <td>${appt.patientId}</td>
  <td><span class="badge-status badge-${appt.status.toLowerCase()}">${appt.status}</span></td>
</tr>
</c:forEach>
</tbody>
```

- [ ] **Step 7: HospitalController — load hospital info**

Update `HospitalController.java` doGet:
```java
// HospitalDAO.getAllHospitals() returns a List; take the first entry
List<Hospital> hospitals = new HospitalDAO().getAllHospitals();
Hospital hospital = hospitals.isEmpty() ? null : hospitals.get(0);
req.setAttribute("hospital", hospital);
req.getRequestDispatcher("/views/manager/manager-hospital-info.jsp").forward(req, resp);
```

- [ ] **Step 8: Create manager-hospital-info.jsp**

Copy `fe/manager/hospital-info.html` to `webapp/views/manager/manager-hospital-info.jsp`. Fix paths. Replace hardcoded hospital name/address/phone with EL:
```jsp
${hospital.hospitalName}
${hospital.address}
${hospital.phone}
```

- [ ] **Step 9: ReportController — load report data**

Update `ReportController.java` doGet:
```java
List<Appointment> appointments = new AppointmentDAO().getAllAppointments();
List<Invoice> invoices = new InvoiceDAO().getAllInvoices();
double totalRevenue = invoices.stream().mapToDouble(i -> i.getTotalAmount()).sum();
req.setAttribute("totalRevenue", totalRevenue);
req.setAttribute("appointmentCount", appointments.size());
req.getRequestDispatcher("/views/manager/manager-reports.jsp").forward(req, resp);
```

- [ ] **Step 10: Create manager-reports.jsp**

Copy `fe/manager/reports.html` to `webapp/views/manager/manager-reports.jsp`. Fix paths. Replace stat values:
```jsp
${appointmentCount}
${totalRevenue}
```

- [ ] **Step 11: Deploy and verify all 5 pages**

Login as MANAGER, visit each page in turn. Expected: real data from DB shown in all tables.

- [ ] **Step 12: Commit**

```bash
git add src/controller/manager/ webapp/views/manager/
git commit -m "feat: all manager pages (departments, rooms, schedules, hospital, reports) show real data"
```

---

## Phase 5 — Admin Role + Public Pages

### Task 20: Admin Dashboard

**Files:**
- Modify: `src/controller/admin/AdminDashboardController.java`
- Modify: `webapp/views/admin/admin-dashboard.jsp`

- [ ] **Step 1: Update AdminDashboardController doGet**

```java
List<User> users = new UserDAO().getAllUsers(); // check method exists; add if needed
List<Doctor> doctors = new DoctorDAO().getAllDoctors();
List<Patient> patients = new PatientDAO().getAllPatients();
req.setAttribute("userCount", users != null ? users.size() : 0);
req.setAttribute("doctorCount", doctors.size());
req.setAttribute("patientCount", patients.size());
req.getRequestDispatcher("/views/admin/admin-dashboard.jsp").forward(req, resp);
```

Note: check if `UserDAO.getAllUsers()` exists. If not, add it:
```java
public List<User> getAllUsers() {
    List<User> list = new ArrayList<>();
    String sql = "SELECT * FROM user";
    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql);
         ResultSet rs = ps.executeQuery()) {
        while (rs.next()) {
            User u = new User();
            u.setUserId(rs.getString("userId"));
            u.setUsername(rs.getString("username"));
            u.setFullName(rs.getString("fullName"));
            u.setEmail(rs.getString("email"));
            u.setPhone(rs.getString("phone"));
            u.setRole(rs.getString("role"));
            list.add(u);
        }
    } catch (Exception e) { e.printStackTrace(); }
    return list;
}
```

- [ ] **Step 2: Create admin-dashboard.jsp**

Copy `fe/admin/dashboard.html` to `webapp/views/admin/admin-dashboard.jsp`.

Add at top:
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

Fix asset paths (replace `../css/`):
```jsp
<link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
```

Fix sidebar links:
```jsp
<a href="${pageContext.request.contextPath}/admin/dashboard">
<a href="${pageContext.request.contextPath}/admin/users">
<a href="${pageContext.request.contextPath}/admin/eye-diseases">
<a href="${pageContext.request.contextPath}/auth/logout">
```

Replace stat values with EL:
```jsp
${userCount}
${doctorCount}
${patientCount}
${sessionScope.user.fullName}
```

- [ ] **Step 3: Deploy and verify**

Login as ADMIN, navigate to `/admin/dashboard`. Expected: real counts shown.

- [ ] **Step 4: Commit**

```bash
git add src/controller/admin/AdminDashboardController.java webapp/views/admin/admin-dashboard.jsp src/dao/UserDAO.java
git commit -m "feat: admin dashboard shows real user/doctor/patient counts"
```

---

### Task 21: Admin Users and Eye Diseases

**Files:**
- Modify: `src/controller/admin/ManageUserController.java`
- Create: `webapp/views/admin/admin-users.jsp`
- Modify: `src/controller/admin/ManageEyeDiseaseInfoController.java`
- Create: `webapp/views/admin/admin-eye-diseases.jsp`

- [ ] **Step 1: ManageUserController doGet — load users**

```java
List<User> users = new UserDAO().getAllUsers();
req.setAttribute("users", users);
req.getRequestDispatcher("/views/admin/admin-users.jsp").forward(req, resp);
```

- [ ] **Step 2: Create admin-users.jsp**

Copy `fe/admin/users.html` to `webapp/views/admin/admin-users.jsp`. Add directives, fix paths and sidebar links. Replace table body:
```jsp
<tbody id="userBody">
<c:forEach var="u" items="${users}">
<tr>
  <td>${u.userId}</td>
  <td>${u.username}</td>
  <td>${u.fullName}</td>
  <td>${u.email}</td>
  <td>${u.role}</td>
  <td>${u.phone}</td>
</tr>
</c:forEach>
</tbody>
```

Fix JS script path:
```jsp
<script src="${pageContext.request.contextPath}/static/js/admin-users.js"></script>
```

- [ ] **Step 3: ManageEyeDiseaseInfoController doGet — load diseases**

```java
List<EyeDiseaseInfo> diseases = new EyeDiseaseInfoDAO().getAllInfos();
req.setAttribute("diseases", diseases);
req.getRequestDispatcher("/views/admin/admin-eye-diseases.jsp").forward(req, resp);
```

- [ ] **Step 4: Create admin-eye-diseases.jsp**

Copy `fe/admin/eye-diseases.html` to `webapp/views/admin/admin-eye-diseases.jsp`. Add directives, fix paths and sidebar links. Replace hardcoded disease rows:
```jsp
<tbody id="diseaseBody">
<c:forEach var="d" items="${diseases}">
<tr>
  <td>${d.infoId}</td>
  <td>${d.diseaseName}</td>
  <td>${d.content}</td>
  <td>${d.description}</td>
  <td>${d.lastUpdate}</td>
</tr>
</c:forEach>
</tbody>
```

Fix JS script path:
```jsp
<script src="${pageContext.request.contextPath}/static/js/admin-eye-diseases.js"></script>
```

- [ ] **Step 5: Deploy and verify both pages**

Login as ADMIN, visit `/admin/users` and `/admin/eye-diseases`. Expected: real data in tables.

- [ ] **Step 6: Commit**

```bash
git add src/controller/admin/ webapp/views/admin/ src/dao/UserDAO.java
git commit -m "feat: admin users and eye diseases show real data from DB"
```

---

### Task 22: FindDoctorController (public page)

**Files:**
- Create: `src/controller/common/FindDoctorController.java`
- Create: `webapp/views/common/find-doctor.jsp`
- Modify: `webapp/WEB-INF/web.xml`

- [ ] **Step 1: Create FindDoctorController.java**

Create `src/controller/common/FindDoctorController.java`:

```java
package controller.common;

import dao.DoctorDAO;
import dao.UserDAO;
import model.Doctor;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.List;

public class FindDoctorController extends HttpServlet {

    private final DoctorDAO doctorDAO = new DoctorDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        req.setAttribute("doctors", doctors);
        req.getRequestDispatcher("/views/common/find-doctor.jsp").forward(req, resp);
    }
}
```

- [ ] **Step 2: Register in web.xml**

```xml
<servlet>
    <servlet-name>FindDoctorController</servlet-name>
    <servlet-class>controller.common.FindDoctorController</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>FindDoctorController</servlet-name>
    <url-pattern>/common/find-doctor</url-pattern>
</servlet-mapping>
```

- [ ] **Step 3: Create find-doctor.jsp**

Copy `fe/find-doctor.html` to `webapp/views/common/find-doctor.jsp`. 

Create the `webapp/views/common/` directory first:
```bash
mkdir -p webapp/views/common
```

Add at top:
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

Fix asset paths (this page is at a different depth — it was in `fe/` root, now in `webapp/views/common/`):
```jsp
<link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/find-doctor.css" rel="stylesheet">
```

Fix nav links (login, book appointment):
```jsp
<a href="${pageContext.request.contextPath}/auth/login" class="btn-nav-ghost">Đăng nhập</a>
<a href="${pageContext.request.contextPath}/patient/appointment" class="btn-nav-cta">Đặt lịch khám</a>
```

Replace hardcoded doctor cards with JSTL loop:
```jsp
<c:forEach var="doc" items="${doctors}">
<div class="doctor-card">
  <div class="doctor-name">${doc.doctorId}</div>
  <div class="doctor-dept">${doc.departmentId}</div>
  <div class="doctor-exp">${doc.experience}</div>
  <div class="doctor-desc">${doc.description}</div>
  <a href="${pageContext.request.contextPath}/patient/appointment?doctorId=${doc.doctorId}" class="btn-hospital btn-sm">Đặt lịch</a>
</div>
</c:forEach>
```

Fix JS script path:
```jsp
<script src="${pageContext.request.contextPath}/static/js/find-doctor.js"></script>
```

- [ ] **Step 4: Deploy and verify (no login required)**

Navigate to `http://localhost:8080/webapp/common/find-doctor` without logging in. Expected: doctor list shown. Not redirected to login.

- [ ] **Step 5: Commit**

```bash
git add src/controller/common/ webapp/views/common/ webapp/WEB-INF/web.xml
git commit -m "feat: public find-doctor page lists all doctors from DB"
```

---

### Task 23: Home page and Book Appointment

**Files:**
- Modify: `webapp/views/home.jsp`
- Create: `webapp/views/patient/book-appointment.jsp`

- [ ] **Step 1: Update home.jsp**

Copy `fe/index.html` to `webapp/views/home.jsp`.

Add at top:
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

Fix asset paths:
```jsp
<link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/static/css/index.css" rel="stylesheet">
```

Fix nav links:
```jsp
<a href="${pageContext.request.contextPath}/auth/login" class="btn-nav-ghost">Đăng nhập</a>
<a href="${pageContext.request.contextPath}/patient/appointment" class="btn-nav-cta">Đặt lịch khám</a>
<a href="${pageContext.request.contextPath}/common/find-doctor">Tìm bác sĩ</a>
```

Fix image paths:
```jsp
<img src="${pageContext.request.contextPath}/static/images/clinic-interior.jpg">
```

Fix JS script paths:
```jsp
<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
```

- [ ] **Step 2: Create book-appointment.jsp**

Copy `fe/book-appointment.html` to `webapp/views/patient/book-appointment.jsp`.

Add at top:
```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
```

Fix asset paths and nav links.

Fix form action:
```jsp
<form action="${pageContext.request.contextPath}/patient/appointment" method="post">
```

Populate doctor dropdown with real data:
```jsp
<select name="doctorId" class="form-select">
  <option value="">-- Chọn bác sĩ --</option>
  <c:forEach var="doc" items="${doctors}">
    <option value="${doc.doctorId}">${doc.doctorId} — ${doc.experience}</option>
  </c:forEach>
</select>
```

Fix JS:
```jsp
<script src="${pageContext.request.contextPath}/static/js/book-appointment.js"></script>
```

- [ ] **Step 3: Check PatientAppointmentController still forwards to correct JSP**

Verify its doGet forwards to `/views/patient/book-appointment.jsp` (not the old path).

- [ ] **Step 4: Deploy and verify**

Visit home page, click "Đặt lịch khám" → should go to book appointment form with real doctor list.

- [ ] **Step 5: Commit**

```bash
git add webapp/views/home.jsp webapp/views/patient/book-appointment.jsp
git commit -m "feat: home page and book-appointment wired with real doctor list"
```

---

## Final Verification

- [ ] **Login as each role and navigate all pages:**
  - PATIENT: dashboard → appointments → history → invoices → profile → book appointment
  - DOCTOR: dashboard → patient list → schedule → appointment detail → profile
  - MANAGER: dashboard → departments → rooms → schedules → hospital info → reports
  - ADMIN: dashboard → users → eye diseases
  - Public: home → find doctor

- [ ] **Check no hardcoded names remain** (search for "Nguyễn Văn An" in all JSPs):
```bash
grep -r "Nguyễn Văn An" webapp/views/
```
Expected: no results.

- [ ] **Check no `.html` links remain in JSPs:**
```bash
grep -r '\.html"' webapp/views/
```
Expected: no results.

- [ ] **Final commit**

```bash
git add -A
git commit -m "feat: frontend-backend integration complete — all 25 pages live"
```
