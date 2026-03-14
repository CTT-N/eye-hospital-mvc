package controller;

import dao.LoginDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet("/login")
public class LoginController extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        LoginDAO dao = new LoginDAO();

        User user = dao.checkLogin(username, password);

        if (user != null) {

            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            response.sendRedirect("views/home.jsp");

        } else {

            request.setAttribute("error", "Invalid username or password");

            request.getRequestDispatcher("views/login.jsp")
                    .forward(request, response);
        }
    }
}