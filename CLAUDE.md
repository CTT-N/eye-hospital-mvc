# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Eye Hospital Management System — a Java Servlet/JSP MVC web application for managing hospital operations including appointments, medical records, billing, and role-based dashboards.

## Build & Run

**Prerequisites:** JDK 17+, MySQL 8.0+, Apache Tomcat 10

**Database setup:**
```bash
mysql -u root -p < database/database.sql
```

**Database connection** is hardcoded in `src/util/DBConnection.java`:
- URL: `jdbc:mysql://localhost:3306/eye_hospital`
- Username: `root` / Password: `123456`

**Build (VS Code):** `Ctrl + Shift + B`

**Deploy:** Copy project to `apache-tomcat/webapps/`, then restart Tomcat.

**Access:** `http://localhost:8080/webapp/login`

No Maven/Gradle — dependencies are JARs in `webapp/WEB-INF/lib/` (MySQL Connector/J 9.6.0, Jakarta Servlet API 6.0).

## Architecture

**Stack:** Jakarta Servlet 6.0 + JSP + raw JDBC (no ORM) + MySQL

**Request flow:**
```
Browser → AuthFilter/RoleFilter → HttpServlet Controller → DAO → MySQL
                                       ↓
                               JSP View (forward) or redirect
```

**Layers:**
- `src/controller/{auth,admin,doctor,manager,patient,common}/` — Servlets handling HTTP requests; each instantiates DAOs directly (no service layer)
- `src/dao/` — Raw JDBC via `PreparedStatement`; all use `DBConnection.getConnection()`
- `src/model/` — Plain POJOs matching DB tables
- `src/filter/` — `AuthFilter` (checks session on `/*`) and `RoleFilter` (enforces role on `/admin/*`, `/manager/*`, `/doctor/*`, `/patient/*`)
- `webapp/views/{auth,admin,doctor,manager,patient}/` — JSP pages

**URL routing** is defined in `webapp/WEB-INF/web.xml` — all servlet mappings are there (e.g., `/auth/login` → `LoginController`).

**Roles (stored in `User.role` ENUM):** `ADMIN`, `DOCTOR`, `MANAGER`, `PATIENT`

**Key relationships:**
- `Doctor` and `Patient` extend `User` via a FK on `userId` (not Java inheritance — separate DB tables)
- `Appointment` links `Patient` + `Doctor` + `Room`
- `MedicalRecord` is tied 1:1 to an `Appointment`
- `Invoice` → `Invoice_Service` (junction) → `Service` handles billing

## Key Notes

- **No service layer** — controllers call DAOs directly
- **Passwords are stored in plain text** — do not add password hashing without updating all auth-related code
- **Jakarta Servlet 6.0** (not legacy `javax.servlet`) — use `jakarta.*` imports
- The welcome file is `views/home.jsp`; unauthenticated users are redirected to `/auth/login` by `AuthFilter`
