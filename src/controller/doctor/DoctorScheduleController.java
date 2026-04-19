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
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/doctor/schedule")
public class DoctorScheduleController extends HttpServlet {

    private static final String CONFIRMED_STATUS = "CONFIRMED";
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

        Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());
        List<Appointment> apps = new java.util.ArrayList<>();
        if (doctor != null) {
            Date today = new Date(System.currentTimeMillis());
            List<Appointment> all = appointmentDAO.getAppointmentsByDoctorIdWithPatientName(doctor.getDoctorId());
            apps = all.stream()
                .filter(a -> today.toString().equals(a.getDate() != null ? a.getDate().toString() : ""))
                .collect(Collectors.toList());
        }

        long pendingCount = apps.stream()
            .filter(a -> "PENDING".equalsIgnoreCase(a.getStatus()) || "CONFIRMED".equalsIgnoreCase(a.getStatus()))
            .count();
        long doneCount = apps.stream()
            .filter(a -> "COMPLETED".equalsIgnoreCase(a.getStatus()))
            .count();

        request.setAttribute("appointments", apps);
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

        if (!CONFIRMED_STATUS.equals(status)) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=forbidden");
            return;
        }

        Appointment appt = appointmentDAO.getAppointmentByIdAndDoctorId(appointmentId, doctor.getDoctorId());
        if (appt == null || !PENDING_STATUS.equals(appt.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=forbidden");
            return;
        }

        int updatedRows = appointmentDAO.updateAppointmentStatusForDoctorAndCurrentStatus(appointmentId, doctor.getDoctorId(), PENDING_STATUS, status);
        if (updatedRows <= 0) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=forbidden");
            return;
        }

        response.sendRedirect(request.getContextPath() + "/doctor/schedule");
    }
}
