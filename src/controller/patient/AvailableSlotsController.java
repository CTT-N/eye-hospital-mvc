package controller.patient;

import dao.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import model.User;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

public class AvailableSlotsController extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User user = session != null ? (User) session.getAttribute("user") : null;

        if (user == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String doctorId = request.getParameter("doctorId");
        String dateStr  = request.getParameter("date");

        if (doctorId == null || doctorId.isEmpty() || dateStr == null || dateStr.isEmpty()) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("[]");
            return;
        }

        try {
            Date date = Date.valueOf(dateStr);
            List<String> bookedTimes = appointmentDAO.getBookedTimesByDoctorAndDate(doctorId, date);

            StringBuilder json = new StringBuilder("[");
            for (int i = 0; i < bookedTimes.size(); i++) {
                if (i > 0) json.append(",");
                json.append("\"").append(bookedTimes.get(i)).append("\"");
            }
            json.append("]");

            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write(json.toString());
        } catch (Exception e) {
            e.printStackTrace();
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("[]");
        }
    }
}
