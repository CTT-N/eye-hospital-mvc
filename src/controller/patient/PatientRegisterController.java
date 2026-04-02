package controller.patient;

import dao.AppointmentDAO;
import model.Appointment;
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

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        request.getRequestDispatcher("/views/patient/register_exam.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Appointment appt = new Appointment();
        appt.setAppointmentId(UUID.randomUUID().toString()); // Temporary UUID generation
        appt.setPatientId(user.getUserId());
        appt.setDoctorId(request.getParameter("doctorId"));
        try {
            appt.setDate(Date.valueOf(request.getParameter("date")));
            appt.setTime(Time.valueOf(request.getParameter("time") + ":00"));
        } catch(Exception e) {}
        appt.setStatus("PENDING");
        
        appointmentDAO.insertAppointment(appt);
        
        response.sendRedirect(request.getContextPath() + "/patient/appointments?msg=registered");
    }
}
