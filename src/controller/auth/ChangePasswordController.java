package controller.auth;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ChangePasswordController extends HttpServlet {

    private final UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }
        request.getRequestDispatcher("/views/auth/change-password.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String currentPassword = request.getParameter("currentPassword");
        String newPassword     = request.getParameter("newPassword");
        String confirmPassword = request.getParameter("confirmPassword");

        // Verify current password
        User verified = userDAO.login(user.getUsername(), currentPassword);
        if (verified == null) {
            request.setAttribute("error", "Mật khẩu hiện tại không đúng.");
            request.getRequestDispatcher("/views/auth/change-password.jsp").forward(request, response);
            return;
        }

        // Confirm new passwords match
        if (!newPassword.equals(confirmPassword)) {
            request.setAttribute("error", "Mật khẩu mới không khớp.");
            request.getRequestDispatcher("/views/auth/change-password.jsp").forward(request, response);
            return;
        }

        boolean updated = userDAO.updatePassword(user.getUserId(), newPassword);

        if (updated) {
            String role = user.getRole();
            String redirect;
            switch (role) {
                case "DOCTOR":  redirect = "/doctor/profile?msg=password_changed";   break;
                case "MANAGER": redirect = "/manager/dashboard?msg=password_changed"; break;
                case "ADMIN":   redirect = "/admin/dashboard?msg=password_changed";   break;
                default:        redirect = "/patient/profile?msg=password_changed";   break;
            }
            response.sendRedirect(request.getContextPath() + redirect);
        } else {
            request.setAttribute("error", "Không thể cập nhật mật khẩu. Vui lòng thử lại.");
            request.getRequestDispatcher("/views/auth/change-password.jsp").forward(request, response);
        }
    }
}
