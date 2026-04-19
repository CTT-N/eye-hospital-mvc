# Doctor Schedule: Date Navigation + Pending Tab Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:subagent-driven-development` (recommended) or `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Cho bác sĩ xem lịch theo ngày bất kỳ và xác nhận / từ chối lịch PENDING qua tab riêng.

**Architecture:** Thêm date navigation server-side vào tab "Lịch theo ngày" (controller đọc param `date`, tính prev/next), đồng thời thêm tab "Chờ xác nhận" load toàn bộ PENDING từ hôm nay trở đi. `doPost` mở rộng thêm CANCELLED và redirect về đúng tab dựa vào hidden field `returnTab`.

**Tech Stack:** Jakarta Servlet 6.0, JSP/JSTL 3.0, raw JDBC + MySQL 8.0, Bootstrap 5.3.2

---

## File Map

| File | Action | Mô tả |
|------|--------|-------|
| `src/dao/AppointmentDAO.java` | Modify | Thêm `getPendingAppointmentsByDoctorIdFromDate` |
| `src/controller/doctor/DoctorScheduleController.java` | Modify | doGet đọc date param + load pending; doPost hỗ trợ CANCELLED + smart redirect |
| `webapp/views/doctor/doctor-schedule.jsp` | Modify | 2 tab: date navigator + pending table |

---

## Task 1: Thêm query pending vào AppointmentDAO

**Files:**
- Modify: `src/dao/AppointmentDAO.java`

- [ ] **Step 1: Thêm method `getPendingAppointmentsByDoctorIdFromDate`**

Thêm ngay sau method `getAppointmentsByDoctorIdWithPatientName` (khoảng dòng 196):

```java
public List<Appointment> getPendingAppointmentsByDoctorIdFromDate(String doctorId, java.sql.Date fromDate) {
    List<Appointment> list = new ArrayList<>();
    String sql =
        "SELECT a.*, u.fullName AS patientName " +
        "FROM Appointment a " +
        "LEFT JOIN Patient p ON a.patientId = p.patientId " +
        "LEFT JOIN user u ON p.userId = u.userId " +
        "WHERE a.doctorId = ? AND a.status = 'PENDING' AND a.date >= ? " +
        "ORDER BY a.date ASC, a.time ASC";

    try (Connection conn = DBConnection.getConnection();
         PreparedStatement ps = conn.prepareStatement(sql)) {

        ps.setString(1, doctorId);
        ps.setDate(2, fromDate);

        try (ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Appointment appt = new Appointment();
                appt.setAppointmentId(rs.getString("appointmentId"));
                appt.setPatientId(rs.getString("patientId"));
                appt.setDoctorId(rs.getString("doctorId"));
                appt.setRoomId(rs.getString("roomId"));
                appt.setDate(rs.getDate("date"));
                appt.setTime(rs.getTime("time"));
                appt.setStatus(rs.getString("status"));
                appt.setPatientName(rs.getString("patientName"));
                list.add(appt);
            }
        }
    } catch (Exception e) {
        e.printStackTrace();
    }
    return list;
}
```

- [ ] **Step 2: Compile**

```bash
mvn clean compile -q
```

Expected: build thành công, không lỗi.

- [ ] **Step 3: Commit**

```bash
git add src/dao/AppointmentDAO.java
git commit -m "feat: add getPendingAppointmentsByDoctorIdFromDate to AppointmentDAO"
```

---

## Task 2: Cập nhật DoctorScheduleController

**Files:**
- Modify: `src/controller/doctor/DoctorScheduleController.java`

- [ ] **Step 1: Thêm constant CANCELLED và cập nhật `doGet`**

Thay toàn bộ nội dung file bằng:

```java
package controller.doctor;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import model.Appointment;
import model.Doctor;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.Calendar;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/doctor/schedule")
public class DoctorScheduleController extends HttpServlet {

    private static final String CONFIRMED_STATUS = "CONFIRMED";
    private static final String CANCELLED_STATUS = "CANCELLED";
    private static final String PENDING_STATUS = "PENDING";

    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private DoctorDAO doctorDAO = new DoctorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        // Parse selected date (default today)
        String dateParam = request.getParameter("date");
        Date selectedDate;
        try {
            selectedDate = (dateParam != null && !dateParam.isBlank())
                ? Date.valueOf(dateParam)
                : new Date(System.currentTimeMillis());
        } catch (IllegalArgumentException e) {
            selectedDate = new Date(System.currentTimeMillis());
        }

        // Compute prev/next dates
        Calendar cal = Calendar.getInstance();
        cal.setTime(selectedDate);
        cal.add(Calendar.DAY_OF_MONTH, -1);
        String prevDate = new Date(cal.getTimeInMillis()).toString();

        cal.setTime(selectedDate);
        cal.add(Calendar.DAY_OF_MONTH, 1);
        String nextDate = new Date(cal.getTimeInMillis()).toString();

        String selectedDateStr = selectedDate.toString();
        String todayStr = new Date(System.currentTimeMillis()).toString();
        boolean isToday = todayStr.equals(selectedDateStr);

        // Active tab
        String activeTab = "today".equals(request.getParameter("tab")) ? "today"
                         : "pending".equals(request.getParameter("tab")) ? "pending"
                         : "today";

        Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());
        List<Appointment> apps = new java.util.ArrayList<>();
        List<Appointment> pendingAppts = new java.util.ArrayList<>();

        if (doctor != null) {
            // Tab 1: appointments for selected date
            final String finalDateStr = selectedDateStr;
            List<Appointment> all = appointmentDAO.getAppointmentsByDoctorIdWithPatientName(doctor.getDoctorId());
            apps = all.stream()
                .filter(a -> finalDateStr.equals(a.getDate() != null ? a.getDate().toString() : ""))
                .collect(Collectors.toList());

            // Tab 2: all PENDING from today onwards
            Date today = new Date(System.currentTimeMillis());
            pendingAppts = appointmentDAO.getPendingAppointmentsByDoctorIdFromDate(doctor.getDoctorId(), today);
        }

        long pendingCount = apps.stream()
            .filter(a -> PENDING_STATUS.equalsIgnoreCase(a.getStatus()) || CONFIRMED_STATUS.equalsIgnoreCase(a.getStatus()))
            .count();
        long doneCount = apps.stream()
            .filter(a -> "COMPLETED".equalsIgnoreCase(a.getStatus()))
            .count();

        request.setAttribute("selectedDate", selectedDateStr);
        request.setAttribute("prevDate", prevDate);
        request.setAttribute("nextDate", nextDate);
        request.setAttribute("isToday", isToday);
        request.setAttribute("activeTab", activeTab);
        request.setAttribute("appointments", apps);
        request.setAttribute("pendingAppointments", pendingAppts);
        request.setAttribute("totalCount", apps.size());
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("doneCount", doneCount);

        request.getRequestDispatcher("/views/doctor/doctor-schedule.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());
        if (doctor == null) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=no_doctor");
            return;
        }

        String appointmentId = request.getParameter("appointmentId");
        String status = request.getParameter("status");

        if (appointmentId == null || status == null) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule");
            return;
        }

        if (!CONFIRMED_STATUS.equals(status) && !CANCELLED_STATUS.equals(status)) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=forbidden");
            return;
        }

        Appointment appt = appointmentDAO.getAppointmentByIdAndDoctorId(appointmentId, doctor.getDoctorId());
        if (appt == null || !PENDING_STATUS.equals(appt.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=forbidden");
            return;
        }

        int updatedRows = appointmentDAO.updateAppointmentStatusForDoctorAndCurrentStatus(
            appointmentId, doctor.getDoctorId(), PENDING_STATUS, status);

        if (updatedRows <= 0) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=forbidden");
            return;
        }

        // Redirect back to origin tab
        String returnTab = request.getParameter("returnTab");
        String returnDate = request.getParameter("returnDate");

        if ("pending".equals(returnTab)) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?tab=pending");
        } else {
            String redirectDate = (returnDate != null && !returnDate.isBlank())
                ? returnDate
                : new Date(System.currentTimeMillis()).toString();
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?date=" + redirectDate);
        }
    }
}
```

- [ ] **Step 2: Compile**

```bash
mvn clean compile -q
```

Expected: build thành công.

- [ ] **Step 3: Commit**

```bash
git add src/controller/doctor/DoctorScheduleController.java
git commit -m "feat: add date navigation and pending tab support to DoctorScheduleController"
```

---

## Task 3: Cập nhật doctor-schedule.jsp

**Files:**
- Modify: `webapp/views/doctor/doctor-schedule.jsp`

- [ ] **Step 1: Thay toàn bộ nội dung JSP**

```jsp
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="vi">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Lich kham - BV Mat PTIT</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/variables.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/base.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/components.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/layout.css" rel="stylesheet">
  <link href="${pageContext.request.contextPath}/static/css/doctor-schedule.css" rel="stylesheet">
</head>
<body>
<div class="app-shell">

  <aside class="sidebar">
    <a href="${pageContext.request.contextPath}/doctor/dashboard" class="sidebar-brand">
      <div class="brand-logo">
        <svg viewBox="0 0 24 24" style="width:18px;height:18px;fill:#fff" xmlns="http://www.w3.org/2000/svg">
          <path d="M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zm0 12.5a5 5 0 1 1 0-10 5 5 0 0 1 0 10zm0-8a3 3 0 1 0 0 6 3 3 0 0 0 0-6z"/>
        </svg>
      </div>
      <div class="brand-text">BV Mat PTIT<small>Cong Bac Si</small></div>
    </a>
    <nav class="sidebar-nav">
      <div class="nav-item"><a href="${pageContext.request.contextPath}/doctor/dashboard" class="nav-link-h"><span class="nav-icon"><i class="fas fa-house"></i></span><span class="nav-label">Tong quan</span></a></div>
      <div class="nav-section-label">Lich kham</div>
      <div class="nav-item"><a href="${pageContext.request.contextPath}/doctor/schedule" class="nav-link-h active"><span class="nav-icon"><i class="fas fa-calendar-days"></i></span><span class="nav-label">Lich theo ngay</span></a></div>
      <div class="nav-item"><a href="${pageContext.request.contextPath}/doctor/patients" class="nav-link-h"><span class="nav-icon"><i class="fas fa-users"></i></span><span class="nav-label">Danh sach benh nhan</span></a></div>
      <div class="nav-section-label">Tai khoan</div>
      <div class="nav-item"><a href="${pageContext.request.contextPath}/doctor/profile" class="nav-link-h"><span class="nav-icon"><i class="fas fa-user-doctor"></i></span><span class="nav-label">Ho so bac si</span></a></div>
    </nav>
    <div class="sidebar-footer">
      <div class="sidebar-user">
        <div class="avatar avatar-md" style="background:var(--primary-light)"><c:choose><c:when test="${fn:length(sessionScope.user.fullName) >= 2}">${fn:substring(sessionScope.user.fullName, 0, 2)}</c:when><c:when test="${fn:length(sessionScope.user.fullName) == 1}">${fn:substring(sessionScope.user.fullName, 0, 1)}</c:when><c:otherwise>?</c:otherwise></c:choose></div>
        <div class="user-info"><div class="user-name">${sessionScope.user.fullName}</div><div class="user-role">Bac si</div></div>
      </div>
      <a href="${pageContext.request.contextPath}/auth/logout" class="nav-link-h" style="margin-top:8px;padding:8px 12px;color:rgba(255,255,255,0.6);font-size:13px">
        <span class="nav-icon"><i class="fas fa-right-from-bracket"></i></span>
        <span class="nav-label">Đăng xuất</span>
      </a>
    </div>
  </aside>

  <main class="main-content">
    <header class="topbar">
      <div class="topbar-left">
        <button class="topbar-icon-btn" id="sidebarToggle"><i class="fas fa-bars"></i></button>
        <div>
          <div class="topbar-title">Lich kham</div>
          <div style="font-size:12px;color:var(--text-muted)">Xem lich va xac nhan lich hen</div>
        </div>
      </div>
      <div class="topbar-right">
        <button class="topbar-icon-btn"><i class="fas fa-bell"></i><span class="notif-dot"></span></button>
        <button class="topbar-user">
          <div class="avatar avatar-sm" style="background:var(--primary-light)"><c:choose><c:when test="${fn:length(sessionScope.user.fullName) >= 2}">${fn:substring(sessionScope.user.fullName, 0, 2)}</c:when><c:when test="${fn:length(sessionScope.user.fullName) == 1}">${fn:substring(sessionScope.user.fullName, 0, 1)}</c:when><c:otherwise>?</c:otherwise></c:choose></div>
          <div class="user-details d-none d-md-block"><span class="user-name">${sessionScope.user.fullName}</span><span class="user-role">Bac si</span></div>
        </button>
      </div>
    </header>

    <div class="content-area">

      <!-- Tab navigation -->
      <div class="tab-nav-h" style="margin-bottom:var(--gap-lg)">
        <a href="${pageContext.request.contextPath}/doctor/schedule?date=${selectedDate}&tab=today"
           class="tab-btn ${activeTab == 'today' ? 'active' : ''}" style="text-decoration:none">
          <i class="fas fa-calendar-days" style="margin-right:6px"></i>Lich theo ngay
        </a>
        <a href="${pageContext.request.contextPath}/doctor/schedule?tab=pending"
           class="tab-btn ${activeTab == 'pending' ? 'active' : ''}" style="text-decoration:none">
          <i class="fas fa-clock" style="margin-right:6px"></i>Cho xac nhan
          <c:if test="${pendingAppointments.size() > 0}">
            <span style="background:var(--warning);color:#fff;border-radius:10px;padding:1px 7px;font-size:11px;margin-left:6px">${pendingAppointments.size()}</span>
          </c:if>
        </a>
      </div>

      <!-- ===== TAB 1: Lich theo ngay ===== -->
      <c:if test="${activeTab == 'today'}">

        <!-- Date navigator -->
        <div class="date-nav" style="margin-bottom:var(--gap-lg)">
          <a href="${pageContext.request.contextPath}/doctor/schedule?date=${prevDate}" class="date-nav-btn" style="text-decoration:none">
            <i class="fas fa-chevron-left"></i>
          </a>
          <div class="date-display">
            <div class="day-label">${isToday ? 'Hom nay' : selectedDate}</div>
            <div class="date-full">${selectedDate}</div>
          </div>
          <a href="${pageContext.request.contextPath}/doctor/schedule?date=${nextDate}" class="date-nav-btn" style="text-decoration:none">
            <i class="fas fa-chevron-right"></i>
          </a>
          <input type="date" class="form-control-h" value="${selectedDate}" style="width:auto;margin-left:auto"
                 onchange="location.href='${pageContext.request.contextPath}/doctor/schedule?date='+this.value">
        </div>

        <!-- Summary row -->
        <div style="display:flex;gap:12px;margin-bottom:var(--gap-lg);flex-wrap:wrap">
          <div class="stat-card" style="flex:1;min-width:140px">
            <div class="stat-icon stat-blue"><i class="fas fa-calendar-check"></i></div>
            <div class="stat-info"><div class="label">Tong lich</div><div class="value">${totalCount}</div></div>
          </div>
          <div class="stat-card" style="flex:1;min-width:140px">
            <div class="stat-icon stat-orange"><i class="fas fa-clock"></i></div>
            <div class="stat-info"><div class="label">Cho kham</div><div class="value">${pendingCount}</div></div>
          </div>
          <div class="stat-card" style="flex:1;min-width:140px">
            <div class="stat-icon stat-green"><i class="fas fa-circle-check"></i></div>
            <div class="stat-info"><div class="label">Da kham</div><div class="value">${doneCount}</div></div>
          </div>
        </div>

        <!-- Schedule list -->
        <c:choose>
          <c:when test="${empty appointments}">
            <p style="text-align:center;padding:24px;color:var(--text-muted)">Khong co lich hen nao trong ngay nay</p>
          </c:when>
          <c:otherwise>
            <c:forEach var="appt" items="${appointments}">
            <div class="schedule-card" style="display:flex;align-items:center;gap:12px">
              <div class="schedule-time"><div class="time">${appt.time}</div><div class="dur">30 phut</div></div>
              <div class="schedule-divider"></div>
              <div class="schedule-info" style="flex:1">
                <div class="patient-name">
                  <c:choose>
                    <c:when test="${not empty appt.patientName}">${appt.patientName}</c:when>
                    <c:otherwise>${appt.patientId}</c:otherwise>
                  </c:choose>
                </div>
                <div class="schedule-meta">
                  <c:choose>
                    <c:when test="${not empty appt.roomId}"><span><i class="fas fa-door-open" style="margin-right:4px"></i>Phong ${appt.roomId}</span></c:when>
                    <c:otherwise><span style="color:var(--text-muted)">Chua co phong</span></c:otherwise>
                  </c:choose>
                </div>
              </div>
              <span class="badge-status badge-${fn:toLowerCase(appt.status)}" style="align-self:center">${appt.status}</span>
              <div style="display:flex;gap:6px;align-self:center">
                <c:if test="${appt.status == 'CONFIRMED' || appt.status == 'COMPLETED'}">
                  <a href="${pageContext.request.contextPath}/doctor/examination?appointmentId=${appt.appointmentId}"
                     class="btn-hospital btn-ghost-h btn-sm">Kham</a>
                </c:if>
                <c:if test="${appt.status == 'PENDING'}">
                  <form method="post" action="${pageContext.request.contextPath}/doctor/schedule" style="margin:0">
                    <input type="hidden" name="appointmentId" value="${appt.appointmentId}">
                    <input type="hidden" name="status" value="CONFIRMED">
                    <input type="hidden" name="returnDate" value="${selectedDate}">
                    <button type="submit" class="btn-hospital btn-primary-h btn-sm">Xac nhan</button>
                  </form>
                </c:if>
              </div>
            </div>
            </c:forEach>
          </c:otherwise>
        </c:choose>

      </c:if>

      <!-- ===== TAB 2: Cho xac nhan ===== -->
      <c:if test="${activeTab == 'pending'}">

        <div class="card-hospital">
          <div class="card-header-h">
            <h5>Lich hen cho xac nhan (${pendingAppointments.size()})</h5>
          </div>
          <div class="card-body-h" style="padding:0">
            <c:choose>
              <c:when test="${empty pendingAppointments}">
                <p style="text-align:center;padding:32px;color:var(--text-muted)">
                  <i class="fas fa-check-circle" style="font-size:32px;margin-bottom:12px;opacity:0.3;display:block"></i>
                  Khong con lich hen nao can xac nhan
                </p>
              </c:when>
              <c:otherwise>
                <div style="overflow-x:auto">
                  <table class="data-table">
                    <thead>
                      <tr>
                        <th>Ngay</th>
                        <th>Gio</th>
                        <th>Benh nhan</th>
                        <th>Phong</th>
                        <th class="action-cell">Thao tac</th>
                      </tr>
                    </thead>
                    <tbody>
                      <c:forEach var="appt" items="${pendingAppointments}">
                      <tr>
                        <td>${appt.date}</td>
                        <td>${appt.time}</td>
                        <td>
                          <c:choose>
                            <c:when test="${not empty appt.patientName}">${appt.patientName}</c:when>
                            <c:otherwise>${appt.patientId}</c:otherwise>
                          </c:choose>
                        </td>
                        <td>
                          <c:choose>
                            <c:when test="${not empty appt.roomId}">Phong ${appt.roomId}</c:when>
                            <c:otherwise><span style="color:var(--text-muted)">Chua co</span></c:otherwise>
                          </c:choose>
                        </td>
                        <td class="action-cell">
                          <div style="display:flex;gap:6px">
                            <form method="post" action="${pageContext.request.contextPath}/doctor/schedule" style="margin:0">
                              <input type="hidden" name="appointmentId" value="${appt.appointmentId}">
                              <input type="hidden" name="status" value="CONFIRMED">
                              <input type="hidden" name="returnTab" value="pending">
                              <button type="submit" class="btn-hospital btn-primary-h btn-sm">Xac nhan</button>
                            </form>
                            <form method="post" action="${pageContext.request.contextPath}/doctor/schedule" style="margin:0">
                              <input type="hidden" name="appointmentId" value="${appt.appointmentId}">
                              <input type="hidden" name="status" value="CANCELLED">
                              <input type="hidden" name="returnTab" value="pending">
                              <button type="submit" class="btn-hospital btn-outline-h btn-sm"
                                      style="color:var(--danger);border-color:var(--danger)">Tu choi</button>
                            </form>
                          </div>
                        </td>
                      </tr>
                      </c:forEach>
                    </tbody>
                  </table>
                </div>
              </c:otherwise>
            </c:choose>
          </div>
        </div>

      </c:if>

    </div>
  </main>
</div>

<script src="${pageContext.request.contextPath}/static/js/sidebar.js"></script>
</body>
</html>
```

- [ ] **Step 2: Compile**

```bash
mvn clean compile -q
```

Expected: build thành công.

- [ ] **Step 3: Manual verification**

1. Đăng nhập với tài khoản doctor.
2. Vào `/doctor/schedule` — xác nhận thấy tab "Lịch theo ngày" active, hiển thị lịch hôm nay.
3. Bấm nút `←` — xác nhận chuyển sang ngày hôm qua, URL có `?date=<ngày hôm qua>`.
4. Bấm nút `→` — xác nhận quay lại hôm nay.
5. Chọn ngày khác qua date picker — xác nhận trang reload đúng ngày.
6. Bấm tab "Chờ xác nhận" — xác nhận hiển thị danh sách PENDING từ hôm nay trở đi.
7. Bấm "Xác nhận" một lịch — xác nhận nó biến mất khỏi danh sách, tab vẫn là "Chờ xác nhận".
8. Bấm "Từ chối" một lịch — xác nhận nó biến mất khỏi danh sách.
9. Quay lại tab "Lịch theo ngày", xác nhận lịch vừa xác nhận hiển thị với status CONFIRMED đúng ngày của nó.

- [ ] **Step 4: Commit**

```bash
git add webapp/views/doctor/doctor-schedule.jsp
git commit -m "feat: add date navigation and pending confirmation tab to doctor schedule"
```

---

## Final: Build + merge

- [ ] **Step 1: Full build**

```bash
mvn clean package -q
```

Expected: WAR build thành công.

- [ ] **Step 2: Commit nếu còn file chưa commit**

```bash
git status
```

Nếu clean thì không cần commit thêm.
