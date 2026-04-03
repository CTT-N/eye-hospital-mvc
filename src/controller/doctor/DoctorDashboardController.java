package controller.doctor;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import model.Appointment;
import model.Doctor;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import java.util.stream.Collectors;

public class DoctorDashboardController extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final DoctorDAO doctorDAO = new DoctorDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
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

        req.getRequestDispatcher("/views/doctor/doctor-dashboard.jsp")
           .forward(req, resp);
    }
}