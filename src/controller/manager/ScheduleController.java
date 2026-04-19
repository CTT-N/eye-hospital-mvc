package controller.manager;

import dao.AppointmentDAO;
import dao.InvoiceDAO;
import model.Appointment;
import model.Invoice;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

public class ScheduleController extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private InvoiceDAO invoiceDAO = new InvoiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        // Quản lý có thể xem toàn bộ lịch khám của bệnh viện (enriched with names)
        List<Appointment> allApps = appointmentDAO.getAllAppointmentsEnrichedForManager();
        List<Invoice> allInvoices = invoiceDAO.getAllInvoices();
        Set<String> invoicedIds = new HashSet<>();
        for (Invoice invoice : allInvoices) {
            invoicedIds.add(invoice.getAppointmentId());
        }

        request.setAttribute("allAppointments", allApps);
        request.setAttribute("invoicedIds", invoicedIds);
        request.setAttribute("totalAppointments", allApps.size());

        request.getRequestDispatcher("/views/manager/manager-schedules.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("updateStatus".equals(action)) {
            String appointmentId = request.getParameter("appointmentId");
            String status = request.getParameter("status");
            appointmentDAO.updateAppointmentStatus(appointmentId, status);
        }
        else if("delete".equals(action)) {
            String appointmentId = request.getParameter("appointmentId");
            appointmentDAO.deleteAppointment(appointmentId);
        }

        response.sendRedirect(request.getContextPath() + "/manager/schedule?msg=updated");
    }
}
