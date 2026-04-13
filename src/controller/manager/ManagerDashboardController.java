package controller.manager;

import dao.DoctorDAO;
import dao.PatientDAO;
import dao.AppointmentDAO;
import dao.ReportDAO;
import model.User;
import java.util.Map;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ManagerDashboardController extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"MANAGER".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        AppointmentDAO appointmentDAO = new AppointmentDAO();
        PatientDAO patientDAO = new PatientDAO();
        DoctorDAO doctorDAO = new DoctorDAO();

        java.util.List<model.Appointment> allAppointments = appointmentDAO.getAllAppointments();

        // Stats
        int totalAppointments = allAppointments.size();
        long completedCount = allAppointments.stream().filter(a -> "COMPLETED".equalsIgnoreCase(a.getStatus())).count();
        long confirmedCount = allAppointments.stream().filter(a -> "CONFIRMED".equalsIgnoreCase(a.getStatus())).count();
        long pendingCount = allAppointments.stream().filter(a -> "PENDING".equalsIgnoreCase(a.getStatus())).count();
        long cancelledCount = allAppointments.stream().filter(a -> "CANCELLED".equalsIgnoreCase(a.getStatus())).count();

        // Recent 5 appointments
        java.util.List<model.Appointment> recentAppointments = allAppointments.stream()
            .sorted((a, b) -> {
                if (a.getDate() == null && b.getDate() == null) return 0;
                if (a.getDate() == null) return 1;
                if (b.getDate() == null) return -1;
                return b.getDate().compareTo(a.getDate());
            })
            .limit(5)
            .collect(java.util.stream.Collectors.toList());

        // Monthly appointment counts for chart (last 6 months, ascending order)
        ReportDAO reportDAO = new ReportDAO();
        Map<String, Integer> monthlyCounts = reportDAO.getMonthlyAppointments(6);
        StringBuilder monthLabels = new StringBuilder("[");
        StringBuilder monthData = new StringBuilder("[");
        // monthlyCounts is DESC by month; reverse for chart display
        java.util.List<Map.Entry<String, Integer>> entries = new java.util.ArrayList<>(monthlyCounts.entrySet());
        java.util.Collections.reverse(entries);
        for (Map.Entry<String, Integer> e : entries) {
            monthLabels.append("'").append(e.getKey()).append("',");
            monthData.append(e.getValue()).append(",");
        }
        if (monthLabels.length() > 1) monthLabels.setLength(monthLabels.length() - 1);
        if (monthData.length() > 1)   monthData.setLength(monthData.length() - 1);
        monthLabels.append("]");
        monthData.append("]");

        req.setAttribute("doctorCount", doctorDAO.getAllDoctors().size());
        req.setAttribute("patientCount", patientDAO.getAllPatients().size());
        req.setAttribute("totalAppointments", totalAppointments);
        req.setAttribute("completedCount", completedCount);
        req.setAttribute("confirmedCount", confirmedCount);
        req.setAttribute("pendingCount", pendingCount);
        req.setAttribute("cancelledCount", cancelledCount);
        req.setAttribute("recentAppointments", recentAppointments);
        req.setAttribute("monthLabels", monthLabels.toString());
        req.setAttribute("monthData", monthData.toString());

        req.getRequestDispatcher("/views/manager/manager-dashboard.jsp")
           .forward(req, resp);
    }
}