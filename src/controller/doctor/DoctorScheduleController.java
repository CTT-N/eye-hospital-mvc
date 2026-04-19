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
import java.util.List;

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
        if (doctor != null) {
            List<Appointment> apps = appointmentDAO.getAppointmentsByDoctorIdWithPatientName(doctor.getDoctorId());
            request.setAttribute("appointments", apps);
        }

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
