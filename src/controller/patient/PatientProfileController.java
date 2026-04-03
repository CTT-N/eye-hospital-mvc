package controller.patient;

import dao.PatientDAO;
import dao.UserDAO;
import model.Patient;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class PatientProfileController extends HttpServlet {

    private final PatientDAO patientDAO = new PatientDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        Patient patient = patientDAO.getPatientByUserId(user.getUserId());
        req.setAttribute("patient", patient);
        req.getRequestDispatcher("/views/patient/patient-profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        user.setFullName(req.getParameter("fullName"));
        user.setEmail(req.getParameter("email"));
        user.setPhone(req.getParameter("phone"));
        userDAO.updateUser(user);

        req.getSession().setAttribute("user", user);

        Patient patient = patientDAO.getPatientByUserId(user.getUserId());
        if (patient != null) {
            patient.setAddress(req.getParameter("address"));
            patient.setGender(req.getParameter("gender"));
            patientDAO.updatePatient(patient);
        }

        resp.sendRedirect(req.getContextPath() + "/patient/profile?msg=updated");
    }
}
