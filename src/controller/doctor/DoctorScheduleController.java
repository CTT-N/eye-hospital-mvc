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