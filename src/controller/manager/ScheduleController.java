package controller.manager;

import dao.AppointmentDAO;
import model.Appointment;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/manager/schedule")
public class ScheduleController extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        // Quản lý có thể xem toàn bộ lịch khám của bệnh viện
        List<Appointment> allApps = appointmentDAO.getAllAppointments();
        request.setAttribute("allAppointments", allApps);

        request.getRequestDispatcher("/views/manager/schedule.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            String appointmentId = request.getParameter("appointmentId");
            String status = request.getParameter("status");
            appointmentDAO.updateAppointmentStatus(appointmentId, status);
        }
        else if("delete".equals(action)) {
            String appointmentId = request.getParameter("appointmentId");
            appointmentDAO.deleteAppointment(appointmentId);
        }

        response.sendRedirect(request.getContextPath() + "/manager/schedule?msg=updated");
    }
}
