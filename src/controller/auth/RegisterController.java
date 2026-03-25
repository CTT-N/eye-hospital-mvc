package controller.auth;

import dao.UserDAO;
import model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import java.io.IOException;

public class RegisterController extends HttpServlet {

    // mở trang register
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        req.getRequestDispatcher("/views/auth/register.jsp")
           .forward(req, resp);
    }

    // xử lý submit
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");

        UserDAO dao = new UserDAO();

        // check trùng username
        if(dao.checkUsernameExists(username)){
            req.setAttribute("error", "Username already exists!");
            req.getRequestDispatcher("/views/auth/register.jsp")
               .forward(req, resp);
            return;
        }

        // tạo user (role = patient)
        User user = new User();
        user.setUsername(username);
        user.setPassword(password);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setRole("patient");

        dao.insertUser(user);

        // đăng ký xong → login
        resp.sendRedirect(req.getContextPath() + "/auth/login");
    }
}