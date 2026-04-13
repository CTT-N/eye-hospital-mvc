package controller.admin;

import model.User;
import model.Doctor;
import model.Patient;
import dao.UserDAO;
import dao.DoctorDAO;
import dao.PatientDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class ManageUserController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();
    private DoctorDAO doctorDAO = new DoctorDAO();
    private PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        List<User> listUsers = userDAO.getAllUsers();
        request.setAttribute("listUsers", listUsers);
        request.getRequestDispatcher("/views/admin/admin-users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        
        if ("delete".equals(action)) {
            String userId = request.getParameter("userId");
            userDAO.deleteUser(userId);
        } else if ("updateRole".equals(action)) {
            String userId = request.getParameter("userId");
            String role = request.getParameter("role");
            userDAO.updateUserRole(userId, role);
        } else if ("add".equals(action)) {
            User newUser = new User();
            newUser.setFullName(request.getParameter("fullName"));
            newUser.setUsername(request.getParameter("username"));
            newUser.setEmail(request.getParameter("email"));
            newUser.setPassword(request.getParameter("password"));
            newUser.setRole(request.getParameter("role").toUpperCase());
            userDAO.insertUser(newUser);
            // If adding a DOCTOR user, also create the Doctor profile record
            if ("DOCTOR".equals(newUser.getRole())) {
                Doctor doctor = new Doctor();
                doctor.setDoctorId("DOC-" + java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                doctor.setUserId(newUser.getUserId());
                doctorDAO.insertDoctor(doctor);
            }
            // If adding a PATIENT user, also create the Patient profile record
            if ("PATIENT".equals(newUser.getRole())) {
                Patient patient = new Patient();
                patient.setPatientId("PAT-" + java.util.UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                patient.setUserId(newUser.getUserId());
                patientDAO.insertPatient(patient);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/users?msg=success");
    }
}
