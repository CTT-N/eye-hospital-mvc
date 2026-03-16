package controller.auth;

import dao.UserDAO;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;
import java.io.IOException;

public class ChangePasswordController extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession();

        User user = (User) session.getAttribute("user");

        String newPassword = request.getParameter("newPassword");

        UserDAO dao = new UserDAO();

        boolean updated = dao.updatePassword(user.getUserId(), newPassword);

        if(updated){
            response.sendRedirect("profile.jsp?msg=success");
        }else{
            response.sendRedirect("change-password.jsp?error=fail");
        }
    }
}