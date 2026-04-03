package controller.manager;

import dao.DoctorDAO;
import dao.PatientDAO;
import dao.AppointmentDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ManagerDashboardController extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"MANAGER".equals(user.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/auth/login");
            return;
        }

        req.setAttribute("doctorCount", new DoctorDAO().getAllDoctors().size());
        req.setAttribute("patientCount", new PatientDAO().getAllPatients().size());
        req.setAttribute("appointmentCount", new AppointmentDAO().getAllAppointments().size());

        req.getRequestDispatcher("/views/manager/manager-dashboard.jsp")
           .forward(req, resp);
    }
}