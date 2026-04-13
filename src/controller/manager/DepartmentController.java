package controller.manager;

import dao.DepartmentDAO;
import model.Department;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.util.UUID;

public class DepartmentController extends HttpServlet {

    private DepartmentDAO departmentDAO = new DepartmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        List<Department> list = departmentDAO.getAllDepartments();
        request.setAttribute("listDepartments", list);
        request.getRequestDispatcher("/views/manager/manager-departments.jsp").forward(request, response);
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
            String deptId = request.getParameter("departmentId");
            if (deptId == null || deptId.trim().isEmpty()) {
                deptId = "CK" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            }
            String hospitalId = request.getParameter("hospitalId");
            if (hospitalId == null || hospitalId.trim().isEmpty()) {
                hospitalId = "H001";
            }
            dept.setDepartmentId(deptId);
            dept.setHospitalId(hospitalId);
            dept.setDepartmentName(request.getParameter("departmentName"));
            dept.setDescription(request.getParameter("description"));
            departmentDAO.insertDepartment(dept);
        } else if ("update".equals(action)) {
            Department dept = new Department();
            dept.setDepartmentId(request.getParameter("departmentId"));
            String hospitalId = request.getParameter("hospitalId");
            if (hospitalId == null || hospitalId.trim().isEmpty()) {
                hospitalId = "H001";
            }
            dept.setHospitalId(hospitalId);
            dept.setDepartmentName(request.getParameter("departmentName"));
            dept.setDescription(request.getParameter("description"));
            departmentDAO.updateDepartment(dept);
        }

        response.sendRedirect(request.getContextPath() + "/manager/departments?msg=success");
    }
}
