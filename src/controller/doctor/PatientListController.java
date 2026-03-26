package controller.doctor;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.PatientDAO;
import model.Appointment;
import model.Doctor;
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
import java.util.HashSet;
import java.util.List;
import java.util.Set;

@WebServlet("/doctor/patients")
public class PatientListController extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private DoctorDAO doctorDAO = new DoctorDAO();
    private PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());
        List<Patient> patients = new ArrayList<>();

        if (doctor != null) {
            List<Appointment> apps = appointmentDAO.getAppointmentsByDoctorId(doctor.getDoctorId());
            Set<String> patientIds = new HashSet<>();
            
            for (Appointment app : apps) {
                if (patientIds.add(app.getPatientId())) {
                    Patient p = patientDAO.getPatientById(app.getPatientId());
                    if (p != null) {
                        patients.add(p);
                    }
                }
            }
        }
        
        request.setAttribute("patients", patients);
        request.getRequestDispatcher("/views/doctor/patient_list.jsp").forward(request, response);
    }
}
