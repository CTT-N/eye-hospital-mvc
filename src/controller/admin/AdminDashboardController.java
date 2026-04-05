package controller.admin;

import dao.EyeDiseaseInfoDAO;
import dao.UserDAO;
import dao.DoctorDAO;
import dao.PatientDAO;
import java.util.List;
import model.EyeDiseaseInfo;
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

        UserDAO userDAO = new UserDAO();
        List<User> listUsers = userDAO.getAllUsers();
        EyeDiseaseInfoDAO diseaseDAO = new EyeDiseaseInfoDAO();
        List<EyeDiseaseInfo> listDiseases = diseaseDAO.getAllInfos();

        req.setAttribute("userCount", listUsers.size());
        req.setAttribute("doctorCount", new DoctorDAO().getAllDoctors().size());
        req.setAttribute("patientCount", new PatientDAO().getAllPatients().size());
        req.setAttribute("listUsers", listUsers);
        req.setAttribute("listDiseases", listDiseases);

        long lockedCount = listUsers.stream().filter(u -> "LOCKED".equals(u.getDescription())).count();
        req.setAttribute("lockedCount", lockedCount);

        req.getRequestDispatcher("/views/admin/admin-dashboard.jsp")
           .forward(req, resp);
    }
}