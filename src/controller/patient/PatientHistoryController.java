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
import java.util.List;

@WebServlet("/patient/history")
public class PatientHistoryController extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Patient patient = patientDAO.getPatientByUserId(user.getUserId());
        if (patient != null) {
            List<Appointment> apps = appointmentDAO.getAppointmentsByPatientId(patient.getPatientId());
            request.setAttribute("appointments", apps);
        }

        request.getRequestDispatcher("/views/patient/history.jsp").forward(request, response);
    }
}
