package controller.doctor;

import dao.DoctorDAO;
import dao.PatientDAO;
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
import java.util.List;

@WebServlet("/doctor/patients")
public class PatientListController extends HttpServlet {

    private DoctorDAO doctorDAO = new DoctorDAO();
    private PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());
        List<Patient> patients = new ArrayList<>();

        if (doctor != null) {
            java.sql.Date today = new java.sql.Date(System.currentTimeMillis());
            patients = patientDAO.getPatientsByDoctorIdAndDate(doctor.getDoctorId(), today);
        }

        request.setAttribute("patients", patients);
        request.getRequestDispatcher("/views/doctor/doctor-patient-list.jsp").forward(request, response);
    }
}
