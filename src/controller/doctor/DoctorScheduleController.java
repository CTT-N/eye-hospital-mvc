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

    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private DoctorDAO doctorDAO = new DoctorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());
        if (doctor != null) {
            List<Appointment> apps = appointmentDAO.getAppointmentsByDoctorId(doctor.getDoctorId());
            request.setAttribute("appointments", apps);
        }

        request.getRequestDispatcher("/views/doctor/schedule.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Có thể dùng để Cập nhật trạng thái lịch khám (Chấp nhận / Hủy)
        String appointmentId = request.getParameter("appointmentId");
        String status = request.getParameter("status");

        if (appointmentId != null && status != null) {
            appointmentDAO.updateAppointmentStatus(appointmentId, status);
        }

        response.sendRedirect(request.getContextPath() + "/doctor/schedule");
    }
}
