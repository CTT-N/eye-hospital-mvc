package controller.patient;

import dao.AppointmentDAO;
import dao.MedicalRecordDAO;
import dao.PatientDAO;
import model.Appointment;
import model.MedicalRecord;
import model.Patient;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/patient/medical-records")
public class PatientMedicalRecordController extends HttpServlet {

    private MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
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

        Patient patient = patientDAO.getPatientByUserId(user.getUserId());
        if (patient == null) {
            response.sendRedirect(request.getContextPath() + "/patient/dashboard");
            return;
        }

        String appointmentId = request.getParameter("appointmentId");

        if (appointmentId != null && !appointmentId.isEmpty()) {
            // Detail view: single record for one appointment
            MedicalRecord record = medicalRecordDAO.getRecordByAppointmentId(appointmentId);
            Appointment appt = appointmentDAO.getAppointmentById(appointmentId);
            request.setAttribute("record", record);
            request.setAttribute("appt", appt);
            request.setAttribute("detailMode", true);
        } else {
            // List view: all records for this patient
            List<MedicalRecord> records = medicalRecordDAO.getRecordsByPatientId(patient.getPatientId());
            // Build a map appointmentId → Appointment for the JSP to display date/doctor
            Map<String, Appointment> apptMap = new HashMap<>();
            for (MedicalRecord rec : records) {
                Appointment appt = appointmentDAO.getAppointmentById(rec.getAppointmentId());
                if (appt != null) {
                    apptMap.put(rec.getAppointmentId(), appt);
                }
            }
            request.setAttribute("records", records);
            request.setAttribute("apptMap", apptMap);
            request.setAttribute("detailMode", false);
        }

        request.getRequestDispatcher("/views/patient/patient-medical-records.jsp").forward(request, response);
    }
}
