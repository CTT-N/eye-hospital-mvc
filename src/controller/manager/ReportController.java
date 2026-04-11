package controller.manager;

import dao.ReportDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.Map;

@WebServlet("/manager/report")
public class ReportController extends HttpServlet {

    private ReportDAO reportDAO = new ReportDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        Map<String, Integer> statusCounts = reportDAO.getAppointmentCountByStatus();
        Map<String, Integer> doctorCounts = reportDAO.getAppointmentCountByDoctor();
        Map<String, Integer> monthlyCounts = reportDAO.getMonthlyAppointments(6);

        request.setAttribute("statusCounts", statusCounts);
        request.setAttribute("doctorCounts", doctorCounts);
        request.setAttribute("monthlyCounts", monthlyCounts);

        request.getRequestDispatcher("/views/manager/manager-reports.jsp").forward(request, response);
    }
}
