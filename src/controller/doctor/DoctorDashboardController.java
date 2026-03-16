package controller.doctor;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class DoctorDashboardController extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/views/doctor/doctor-dashboard.jsp")
           .forward(req, resp);
    }
}