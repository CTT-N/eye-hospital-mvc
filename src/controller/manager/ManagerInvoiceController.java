package controller.manager;

import dao.InvoiceDAO;
import dao.InvoiceServiceDAO;
import model.Invoice;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

public class ManagerInvoiceController extends HttpServlet {

    private final InvoiceDAO invoiceDAO = new InvoiceDAO();
    private final InvoiceServiceDAO invoiceServiceDAO = new InvoiceServiceDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"MANAGER".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String statusFilter = request.getParameter("status");
        List<Invoice> listInvoices = invoiceDAO.getAllInvoicesEnrichedForManager(statusFilter);
        for (Invoice invoice : listInvoices) {
            invoice.setServices(invoiceServiceDAO.getServicesByInvoiceId(invoice.getInvoiceId()));
        }

        request.setAttribute("listInvoices", listInvoices);
        request.setAttribute("statusFilter", statusFilter != null ? statusFilter : "");
        request.getRequestDispatcher("/views/manager/manager-invoices.jsp").forward(request, response);
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
        String invoiceId = request.getParameter("invoiceId");
        String statusFilter = request.getParameter("statusFilter");

        if ("delete".equals(action)) {
            invoiceServiceDAO.deleteByInvoiceId(invoiceId);
            invoiceDAO.deleteInvoice(invoiceId);
        } else if ("updateStatus".equals(action)) {
            invoiceDAO.updateInvoiceStatus(invoiceId, request.getParameter("status"));
        }

        String redirect = request.getContextPath() + "/manager/invoices";
        if (statusFilter != null && !statusFilter.isEmpty()) {
            redirect += "?status=" + statusFilter;
        }
        response.sendRedirect(redirect);
    }
}
