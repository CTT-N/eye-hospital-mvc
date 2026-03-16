package controller;

import dao.LoginDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;

public class LoginController extends HttpServlet {

    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        LoginDAO dao = new LoginDAO();

        User user1 = dao.checkLogin(username, password);

        if (user1 != null) {
            // kiểm tra hiệu quả chạy
            System.out.println("LoginController running");
            System.out.println(username + " " + password);

            HttpSession session = request.getSession();
            session.setAttribute("user", user1);

            response.sendRedirect(request.getContextPath() + "/views/home.jsp");

        } else {

            request.setAttribute("error", "Invalid username or password");

            request.getRequestDispatcher("/views/login.jsp")
                    .forward(request, response);
        }
    }
}