package controller.doctor;

import dao.DoctorDAO;
import dao.UserDAO;
import model.Doctor;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

public class DoctorProfileController extends HttpServlet {

    private final DoctorDAO doctorDAO = new DoctorDAO();
    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        User user = (User) req.getSession().getAttribute("user");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }
        Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());
        req.setAttribute("doctor", doctor);
        req.getRequestDispatcher("/views/doctor/doctor-profile.jsp").forward(req, resp);
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

        Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());
        if (doctor != null) {
            doctor.setExperience(req.getParameter("experience"));
            doctor.setDescription(req.getParameter("description"));
            doctorDAO.updateDoctor(doctor);
        }
        resp.sendRedirect(req.getContextPath() + "/doctor/profile?msg=updated");
    }
}
