package controller.patient;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class PatientDashboardController extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/views/patient/patient-dashboard.jsp")
           .forward(req, resp);
    }
}