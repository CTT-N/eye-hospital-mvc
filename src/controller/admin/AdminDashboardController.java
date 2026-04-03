package controller.admin;

import dao.UserDAO;
import dao.DoctorDAO;
import dao.PatientDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class AdminDashboardController extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        req.setAttribute("userCount", new UserDAO().getAllUsers().size());
        req.setAttribute("doctorCount", new DoctorDAO().getAllDoctors().size());
        req.setAttribute("patientCount", new PatientDAO().getAllPatients().size());

        req.getRequestDispatcher("/views/admin/admin-dashboard.jsp")
           .forward(req, resp);
    }
}