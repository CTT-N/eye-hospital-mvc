package controller.admin;

import dao.EyeDiseaseInfoDAO;
import model.EyeDiseaseInfo;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet("/admin/diseases")
public class ManageEyeDiseaseInfoController extends HttpServlet {

    private EyeDiseaseInfoDAO infoDAO = new EyeDiseaseInfoDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        List<EyeDiseaseInfo> listInfos = infoDAO.getAllInfos();
        request.setAttribute("listInfos", listInfos);
        request.getRequestDispatcher("/views/admin/admin-eye-diseases.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        if ("delete".equals(action)) {
            String id = request.getParameter("infoId");
            infoDAO.deleteInfo(id);
        } else if ("add".equals(action)) {
            EyeDiseaseInfo info = new EyeDiseaseInfo();
            info.setInfoId(request.getParameter("infoId"));
            info.setDiseaseName(request.getParameter("diseaseName"));
            info.setContent(request.getParameter("content"));
            info.setDescription(request.getParameter("description"));
            // Set other fields assuming they are provided or default
            infoDAO.insertInfo(info);
        } else if ("update".equals(action)) {
            // similar update logic
            String id = request.getParameter("infoId");
            EyeDiseaseInfo info = infoDAO.getInfoById(id);
            if(info != null) {
                info.setDiseaseName(request.getParameter("diseaseName"));
                info.setContent(request.getParameter("content"));
                info.setDescription(request.getParameter("description"));
                infoDAO.updateInfo(info);
            }
        }

        response.sendRedirect(request.getContextPath() + "/admin/diseases?msg=success");
    }
}
