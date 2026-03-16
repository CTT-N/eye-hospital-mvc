package controller.auth;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class LoginController extends HttpServlet {

    private UserDAO userDAO;

    @Override
    public void init() {
        userDAO = new UserDAO();
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");

        User user = userDAO.login(username, password);

        if (user == null) {

            req.setAttribute("error", "Invalid username or password");
            req.getRequestDispatcher("/views/auth/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession();
        session.setAttribute("user", user);
        session.setAttribute("role", user.getRole());

        String role = user.getRole();

        switch(role){

            case "ADMIN":
            resp.sendRedirect(req.getContextPath()+"/admin/dashboard");
            break;

            case "DOCTOR":
            resp.sendRedirect(req.getContextPath()+"/doctor/dashboard");
            break;

            case "MANAGER":
            resp.sendRedirect(req.getContextPath()+"/manager/dashboard");
            break;

            case "PATIENT":
            resp.sendRedirect(req.getContextPath()+"/patient/dashboard");
            break;

        }
    }
}