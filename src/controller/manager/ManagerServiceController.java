package controller.manager;

import dao.ServiceDAO;
import model.Service;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;

public class ManagerServiceController extends HttpServlet {

    private final ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        request.setAttribute("services", serviceDAO.getAllServices());
        request.getRequestDispatcher("/views/manager/manager-services.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String action = request.getParameter("action");

        if ("add".equals(action)) {
            String serviceName = request.getParameter("serviceName");
            String priceParam = request.getParameter("price");
            if (serviceName == null || serviceName.trim().isEmpty() || priceParam == null || priceParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/manager/services?error=invalid");
                return;
            }
            double price;
            try {
                price = Double.parseDouble(priceParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/manager/services?error=invalid");
                return;
            }
            if (price < 0) {
                response.sendRedirect(request.getContextPath() + "/manager/services?error=invalid");
                return;
            }
            Service svc = new Service();
            svc.setServiceId("SVC-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
            svc.setServiceName(serviceName.trim());
            svc.setPrice(price);
            String desc = request.getParameter("description");
            svc.setDescription(desc != null ? desc.trim() : "");
            boolean inserted = serviceDAO.insertService(svc);
            if (!inserted) {
                response.sendRedirect(request.getContextPath() + "/manager/services?error=savefail");
                return;
            }

        } else if ("edit".equals(action)) {
            String serviceName = request.getParameter("serviceName");
            String priceParam = request.getParameter("price");
            if (serviceName == null || serviceName.trim().isEmpty() || priceParam == null || priceParam.trim().isEmpty()) {
                response.sendRedirect(request.getContextPath() + "/manager/services?error=invalid");
                return;
            }
            double price;
            try {
                price = Double.parseDouble(priceParam);
            } catch (NumberFormatException e) {
                response.sendRedirect(request.getContextPath() + "/manager/services?error=invalid");
                return;
            }
            if (price < 0) {
                response.sendRedirect(request.getContextPath() + "/manager/services?error=invalid");
                return;
            }
            Service svc = new Service();
            svc.setServiceId(request.getParameter("serviceId"));
            svc.setServiceName(serviceName.trim());
            svc.setPrice(price);
            String desc = request.getParameter("description");
            svc.setDescription(desc != null ? desc.trim() : "");
            boolean updated = serviceDAO.updateService(svc);
            if (!updated) {
                response.sendRedirect(request.getContextPath() + "/manager/services?error=savefail");
                return;
            }

        } else if ("delete".equals(action)) {
            boolean deleted = serviceDAO.deleteService(request.getParameter("serviceId"));
            if (!deleted) {
                response.sendRedirect(request.getContextPath() + "/manager/services?error=inuse");
                return;
            }
        }

        response.sendRedirect(request.getContextPath() + "/manager/services");
    }
}
