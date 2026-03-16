package controller.manager;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ManagerDashboardController extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/views/manager/manager-dashboard.jsp")
           .forward(req, resp);
    }
}