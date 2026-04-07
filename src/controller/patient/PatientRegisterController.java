package controller.patient;

import dao.AppointmentDAO;
import dao.PatientDAO;
import model.Appointment;
import model.Patient;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.UUID;

@WebServlet("/patient/register-exam")
public class PatientRegisterController extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        request.getRequestDispatcher("/views/patient/book-appointment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        Patient patient = patientDAO.getPatientByUserId(user.getUserId());
        if (patient == null) {
            request.setAttribute("error", "Vui lòng cập nhật thông tin bệnh nhân trước khi đặt lịch.");
            request.getRequestDispatcher("/views/patient/book-appointment.jsp").forward(request, response);
            return;
        }

        String dateStr = request.getParameter("date");
        String timeStr = request.getParameter("time");

        if (dateStr == null || dateStr.isEmpty() || timeStr == null || timeStr.isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn ngày và giờ khám.");
            request.getRequestDispatcher("/views/patient/book-appointment.jsp").forward(request, response);
            return;
        }

        Appointment appt = new Appointment();
        appt.setAppointmentId(UUID.randomUUID().toString());
        appt.setPatientId(patient.getPatientId());
        appt.setDoctorId(request.getParameter("doctorId"));

        try {
            appt.setDate(Date.valueOf(dateStr));
            appt.setTime(Time.valueOf(timeStr + ":00"));
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Ngày hoặc giờ không hợp lệ. Vui lòng chọn lại.");
            request.getRequestDispatcher("/views/patient/book-appointment.jsp").forward(request, response);
            return;
        }

        appt.setStatus("PENDING");
        appointmentDAO.insertAppointment(appt);

        response.sendRedirect(request.getContextPath() + "/patient/history?msg=registered");
    }
}
