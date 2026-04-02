package controller.manager;

import dao.DepartmentDAO;
import model.Department;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/manager/departments")
public class DepartmentController extends HttpServlet {

    private DepartmentDAO departmentDAO = new DepartmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        List<Department> list = departmentDAO.getAllDepartments();
        request.setAttribute("listDepartments", list);
        request.getRequestDispatcher("/views/manager/departments.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        if ("delete".equals(action)) {
            String id = request.getParameter("departmentId");
            departmentDAO.deleteDepartment(id);
        } else if ("add".equals(action)) {
            Department dept = new Department();
            dept.setDepartmentId(request.getParameter("departmentId"));
            dept.setHospitalId(request.getParameter("hospitalId"));
            dept.setDepartmentName(request.getParameter("departmentName"));
            dept.setDescription(request.getParameter("description"));
            departmentDAO.insertDepartment(dept);
        } else if ("update".equals(action)) {
            Department dept = new Department();
            dept.setDepartmentId(request.getParameter("departmentId"));
            dept.setHospitalId(request.getParameter("hospitalId"));
            dept.setDepartmentName(request.getParameter("departmentName"));
            dept.setDescription(request.getParameter("description"));
            departmentDAO.updateDepartment(dept);
        }

        response.sendRedirect(request.getContextPath() + "/manager/departments?msg=success");
    }
}
