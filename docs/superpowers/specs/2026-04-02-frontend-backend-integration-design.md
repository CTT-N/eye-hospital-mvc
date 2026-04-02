# Frontend–Backend Integration Design

**Date:** 2026-04-02  
**Project:** Eye Hospital Management System (BV Mắt PTIT)  
**Approach:** HTML → JSP Conversion (Server-Side Rendering)

---

## Overview

The `fe/` directory contains 25 polished static HTML pages for all 4 roles (Patient, Doctor, Manager, Admin) plus public pages. The backend is a Jakarta Servlet 6.0 + JSP + raw JDBC application deployed on Tomcat. Integration means converting each HTML page to a JSP, wiring it to its controller, and having controllers load real data from DAOs.

---

## Architecture

### Request Flow

```
Browser → AuthFilter/RoleFilter → HttpServlet Controller → DAO → MySQL
                                          ↓ sets req.setAttribute(...)
                                    JSP (was HTML) renders data
                                          ↓
                                    HTML response → Browser
```

### Static Asset Strategy

All CSS, JS, and images from `fe/` are moved into `webapp/static/` so Tomcat serves them:

| Source | Destination |
|--------|-------------|
| `fe/css/` | `webapp/static/css/` |
| `fe/js/` | `webapp/static/js/` |
| `fe/images/` | `webapp/static/images/` |

All JSPs reference assets using the context path:
```jsp
<link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
```

### JSP/JSTL

JSTL 3.0 (`jakarta.servlet.jsp.jstl-3.0.jar` + `jakarta.servlet.jsp.jstl-api-3.0.jar`) must be added to `webapp/WEB-INF/lib/`. All JSPs use `<%@ taglib uri="jakarta.tags.core" prefix="c" %>` for loops and conditionals.

---

## Page Inventory (25 pages)

### Public / Auth

| HTML Source | JSP Target | Controller | Notes |
|-------------|-----------|------------|-------|
| `fe/login.html` | `webapp/views/auth/login.jsp` | `LoginController` | Fix form action to `/auth/login` |
| `fe/register.html` | `webapp/views/auth/register.jsp` | `RegisterController` | Fix form action to `/auth/register` |
| `fe/index.html` | `webapp/views/home.jsp` | welcome file | Mostly static |
| `fe/find-doctor.html` | `webapp/views/common/find-doctor.jsp` | `FindDoctorController` (new) | Public, no auth |
| `fe/book-appointment.html` | `webapp/views/patient/book-appointment.jsp` | `PatientAppointmentController` | Requires patient session |

### Patient Role (5 pages)

| HTML Source | JSP Target | Controller | Data Needed |
|-------------|-----------|------------|-------------|
| `fe/patient/dashboard.html` | `webapp/views/patient/patient-dashboard.jsp` | `PatientDashboardController` | Upcoming appts count, user name |
| `fe/patient/appointments.html` | `webapp/views/patient/patient-appointments.jsp` | `PatientAppointmentController` | List of appointments |
| `fe/patient/history.html` | `webapp/views/patient/patient-history.jsp` | `PatientHistoryController` | Past medical records |
| `fe/patient/invoices.html` | `webapp/views/patient/patient-invoices.jsp` | `PatientInvoiceController` | Invoice list |
| `fe/patient/profile.html` | `webapp/views/patient/patient-profile.jsp` | `PatientProfileController` (new) | Patient profile data |

### Doctor Role (6 pages)

| HTML Source | JSP Target | Controller | Data Needed |
|-------------|-----------|------------|-------------|
| `fe/doctor/dashboard.html` | `webapp/views/doctor/doctor-dashboard.jsp` | `DoctorDashboardController` | Today's appointments, stats |
| `fe/doctor/patient-list.html` | `webapp/views/doctor/doctor-patient-list.jsp` | `PatientListController` | All patients |
| `fe/doctor/patient-record.html` | `webapp/views/doctor/doctor-patient-record.jsp` | `MedicalRecordController` | Medical record by appointmentId |
| `fe/doctor/schedule.html` | `webapp/views/doctor/doctor-schedule.jsp` | `DoctorScheduleController` | Doctor's schedule |
| `fe/doctor/appointment-detail.html` | `webapp/views/doctor/doctor-appointment-detail.jsp` | `ExaminationController` | Appointment + exam data |
| `fe/doctor/profile.html` | `webapp/views/doctor/doctor-profile.jsp` | `DoctorProfileController` (new) | Doctor profile data |

### Manager Role (6 pages)

| HTML Source | JSP Target | Controller | Data Needed |
|-------------|-----------|------------|-------------|
| `fe/manager/dashboard.html` | `webapp/views/manager/manager-dashboard.jsp` | `ManagerDashboardController` | Hospital stats |
| `fe/manager/departments.html` | `webapp/views/manager/manager-departments.jsp` | `DepartmentController` | Department list |
| `fe/manager/rooms.html` | `webapp/views/manager/manager-rooms.jsp` | `RoomController` | Room list |
| `fe/manager/schedules.html` | `webapp/views/manager/manager-schedules.jsp` | `ScheduleController` | All schedules |
| `fe/manager/hospital-info.html` | `webapp/views/manager/manager-hospital-info.jsp` | `HospitalController` | Hospital info |
| `fe/manager/reports.html` | `webapp/views/manager/manager-reports.jsp` | `ReportController` | Report data |

### Admin Role (3 pages)

| HTML Source | JSP Target | Controller | Data Needed |
|-------------|-----------|------------|-------------|
| `fe/admin/dashboard.html` | `webapp/views/admin/admin-dashboard.jsp` | `AdminDashboardController` | System stats |
| `fe/admin/users.html` | `webapp/views/admin/admin-users.jsp` | `ManageUserController` | All users |
| `fe/admin/eye-diseases.html` | `webapp/views/admin/admin-eye-diseases.jsp` | `ManageEyeDiseaseInfoController` | Disease list |

---

## New Controllers Required

Three controllers do not yet exist and must be created:

| Controller | URL Pattern | doGet | doPost |
|------------|------------|-------|--------|
| `PatientProfileController` | `/patient/profile` | Load patient from session, forward to JSP | Save updated profile fields |
| `DoctorProfileController` | `/doctor/profile` | Load doctor from session, forward to JSP | Save updated profile fields |
| `FindDoctorController` | `/common/find-doctor` | Query all active doctors, forward to JSP | — |

These must be registered in `web.xml` with their servlet mappings.

---

## Conversion Pattern (per page)

### Controller (doGet)
```java
// 1. Get user/patient/doctor from session
Patient patient = (Patient) req.getSession().getAttribute("user");

// 2. Load data from DAO
List<Appointment> appts = new AppointmentDAO().getByPatientId(patient.getPatientId());

// 3. Set as request attribute
req.setAttribute("appointments", appts);

// 4. Forward to JSP
req.getRequestDispatcher("/views/patient/patient-appointments.jsp").forward(req, resp);
```

### JSP (data rendering)
```jsp
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<c:forEach var="appt" items="${appointments}">
  <tr data-status="${appt.status}">
    <td>${appt.appointmentDate}</td>
    <td>${appt.doctorName}</td>
    <td><span class="badge-status">${appt.status}</span></td>
  </tr>
</c:forEach>
```

### Form actions and internal links
All `action="..."` and `href="..."` values must use servlet URLs via context path:
```jsp
<!-- Form -->
<form action="${pageContext.request.contextPath}/auth/login" method="post">

<!-- Navigation links -->
<a href="${pageContext.request.contextPath}/patient/appointments">Lịch hẹn</a>
```

---

## AuthFilter Updates Required

The current `AuthFilter` excludes `/css`, `/js`, `/images` from auth. After moving assets to `/static/`, these exclusions break. Also, public pages need to be whitelisted. The filter's exclusion list must be updated to:

```java
if (uri.contains("/auth/") ||          // login, register, logout
    uri.contains("/static/") ||        // css, js, images (new path)
    uri.contains("/views") ||
    uri.endsWith(".jsp") ||
    uri.contains("/common/find-doctor") || // public page
    uri.equals(req.getContextPath() + "/") || // home
    uri.contains("/home")) {
    chain.doFilter(request, response);
    return;
}
```

Note: `/auth/register` is also currently not whitelisted in AuthFilter — this must be fixed too.

---

## Implementation Phases

### Phase 1 — Foundation
1. Copy `fe/css/`, `fe/js/`, `fe/images/` → `webapp/static/`
2. Add JSTL 3.0 jars to `webapp/WEB-INF/lib/`
3. Update `AuthFilter` exclusions (`/css` → `/static/`, add `/auth/register`, `/common/find-doctor`)
4. Convert `login.html` → `login.jsp`, fix form action, verify auth works end-to-end
5. Convert `register.html` → `register.jsp`

### Phase 2 — Patient Role
Convert all 5 patient pages + create `PatientProfileController`.

### Phase 3 — Doctor Role
Convert all 6 doctor pages + create `DoctorProfileController`.

### Phase 4 — Manager Role
Convert all 6 manager pages.

### Phase 5 — Admin + Public
Convert 3 admin pages + create `FindDoctorController` + convert `find-doctor.html`, `book-appointment.html`, `home.jsp`.

---

## Out of Scope

- REST API / JSON endpoints
- Password hashing (per CLAUDE.md: plain text as-is)
- Any new features beyond connecting existing UI to existing data
- Frontend redesign or new pages