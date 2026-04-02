package controller.admin;

import model.User;
import dao.UserDAO;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/users")
public class ManageUserController extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<User> listUsers = userDAO.getAllUsers();
        request.setAttribute("listUsers", listUsers);
        request.getRequestDispatcher("/views/admin/manage_users.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        
        if ("delete".equals(action)) {
            String userId = request.getParameter("userId");
            userDAO.deleteUser(userId);
        } else if ("updateRole".equals(action)) {
            String userId = request.getParameter("userId");
            String role = request.getParameter("role");
            userDAO.updateUserRole(userId, role);
        } else if ("add".equals(action)) {
            // ... code for insertUser
        }

        response.sendRedirect(request.getContextPath() + "/admin/users?msg=success");
    }
}
