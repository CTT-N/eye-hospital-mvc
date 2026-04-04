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
        // If already logged in, redirect to dashboard
        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("user") != null) {
            User user = (User) session.getAttribute("user");
            String role = user.getRole() != null ? user.getRole() : "";
            switch (role) {
                case "ADMIN":   resp.sendRedirect(req.getContextPath() + "/admin/dashboard");   return;
                case "DOCTOR":  resp.sendRedirect(req.getContextPath() + "/doctor/dashboard");  return;
                case "MANAGER": resp.sendRedirect(req.getContextPath() + "/manager/dashboard"); return;
                default:        resp.sendRedirect(req.getContextPath() + "/patient/dashboard"); return;
            }
        }
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

        // Server-side validation
        if (username == null || username.trim().isEmpty() ||
            password == null || password.trim().isEmpty() ||
            fullName == null || fullName.trim().isEmpty()) {
            req.setAttribute("error", "Vui lòng điền đầy đủ thông tin bắt buộc.");
            req.getRequestDispatcher("/views/auth/register.jsp").forward(req, resp);
            return;
        }

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
        user.setUsername(username.trim());
        user.setPassword(password);
        user.setFullName(fullName.trim());
        user.setEmail(email != null ? email.trim() : "");
        user.setRole("PATIENT");

        dao.insertUser(user);

        // đăng ký xong → login
        resp.sendRedirect(req.getContextPath() + "/auth/login");
    }
}