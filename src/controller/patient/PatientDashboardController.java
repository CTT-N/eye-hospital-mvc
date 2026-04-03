package controller.patient;

import dao.AppointmentDAO;
import dao.PatientDAO;
import model.Appointment;
import model.Patient;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;

public class PatientDashboardController extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final PatientDAO patientDAO = new PatientDAO();

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        Patient patient = patientDAO.getPatientByUserId(user.getUserId());

        long upcomingCount = 0;
        long pendingCount = 0;
        long totalCount = 0;
        if (patient != null) {
            List<Appointment> appts = appointmentDAO.getAppointmentsByPatientId(patient.getPatientId());
            upcomingCount = appts.stream().filter(a -> "CONFIRMED".equalsIgnoreCase(a.getStatus())).count();
            pendingCount  = appts.stream().filter(a -> "PENDING".equalsIgnoreCase(a.getStatus())).count();
            totalCount    = appts.size();
            req.setAttribute("appointments", appts);
        }
        req.setAttribute("patient", patient);
        req.setAttribute("upcomingCount", upcomingCount);
        req.setAttribute("pendingCount", pendingCount);
        req.setAttribute("totalCount", totalCount);

        req.getRequestDispatcher("/views/patient/patient-dashboard.jsp")
           .forward(req, resp);
    }
}