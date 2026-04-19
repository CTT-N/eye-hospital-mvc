package controller.manager;

import dao.AppointmentDAO;
import dao.InvoiceDAO;
import dao.InvoiceServiceDAO;
import dao.ServiceDAO;
import model.Appointment;
import model.Invoice;
import model.InvoiceService;
import model.Service;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

public class ManagerInvoiceCreateController extends HttpServlet {

    private final AppointmentDAO appointmentDAO = new AppointmentDAO();
    private final InvoiceDAO invoiceDAO = new InvoiceDAO();
    private final InvoiceServiceDAO invoiceServiceDAO = new InvoiceServiceDAO();
    private final ServiceDAO serviceDAO = new ServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String appointmentId = request.getParameter("appointmentId");
        Appointment appointment = appointmentDAO.getAppointmentByIdEnriched(appointmentId);
        if (appointment == null) {
            response.sendRedirect(request.getContextPath() + "/manager/schedule");
            return;
        }

        List<Service> services = serviceDAO.getAllServices();
        request.setAttribute("appointment", appointment);
        request.setAttribute("services", services);
        request.getRequestDispatcher("/views/manager/manager-invoice-create.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String appointmentId = request.getParameter("appointmentId");
        String[] selectedIds = request.getParameterValues("serviceId");

        if (selectedIds == null || selectedIds.length == 0) {
            response.sendRedirect(request.getContextPath()
                + "/manager/invoices/create?appointmentId=" + appointmentId + "&error=noservice");
            return;
        }

        List<Service> allServices = serviceDAO.getAllServices();
        Map<String, Double> priceMap = new HashMap<>();
        for (Service service : allServices) {
            priceMap.put(service.getServiceId(), service.getPrice());
        }

        double totalAmount = 0;
        for (String serviceId : selectedIds) {
            String qtyParam = request.getParameter("qty_" + serviceId);
            int quantity = 1;
            try {
                quantity = Math.max(1, Integer.parseInt(qtyParam));
            } catch (Exception ignored) {
            }

            Double price = priceMap.get(serviceId);
            if (price != null) {
                totalAmount += price * quantity;
            }
        }

        String invoiceId = "INV-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
        Invoice invoice = new Invoice();
        invoice.setInvoiceId(invoiceId);
        invoice.setAppointmentId(appointmentId);
        invoice.setDate(new Date(System.currentTimeMillis()));
        invoice.setTotalAmount(totalAmount);
        invoice.setStatus("PENDING");
        invoiceDAO.insertInvoice(invoice);

        for (String serviceId : selectedIds) {
            String qtyParam = request.getParameter("qty_" + serviceId);
            int quantity = 1;
            try {
                quantity = Math.max(1, Integer.parseInt(qtyParam));
            } catch (Exception ignored) {
            }

            Double price = priceMap.get(serviceId);
            if (price == null) {
                continue;
            }

            InvoiceService item = new InvoiceService();
            item.setInvoiceId(invoiceId);
            item.setServiceId(serviceId);
            item.setQuantity(quantity);
            item.setTotalPrice(price * quantity);
            invoiceServiceDAO.insertInvoiceService(item);
        }

        response.sendRedirect(request.getContextPath() + "/manager/invoices");
    }
}
