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
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        List<User> listUsers = userDAO.getAllUsers();
        request.setAttribute("listUsers", listUsers);
        request.getRequestDispatcher("/views/admin/admin-users.jsp").forward(request, response);
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
            User newUser = new User();
            newUser.setFullName(request.getParameter("fullName"));
            newUser.setUsername(request.getParameter("username"));
            newUser.setEmail(request.getParameter("email"));
            newUser.setPassword(request.getParameter("password"));
            newUser.setRole(request.getParameter("role").toUpperCase());
            userDAO.insertUser(newUser);
        }

        response.sendRedirect(request.getContextPath() + "/admin/users?msg=success");
    }
}
