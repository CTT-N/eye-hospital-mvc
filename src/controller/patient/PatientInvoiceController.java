package controller.patient;

import dao.InvoiceDAO;
import dao.PatientDAO;
import model.Invoice;
import model.Patient;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;

@WebServlet("/patient/invoices")
public class PatientInvoiceController extends HttpServlet {

    private InvoiceDAO invoiceDAO = new InvoiceDAO();
    private PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        Patient patient = patientDAO.getPatientByUserId(user.getUserId());
        List<Invoice> list = (patient != null)
            ? invoiceDAO.getInvoicesByPatientId(patient.getPatientId())
            : new java.util.ArrayList<>();
        request.setAttribute("listInvoices", list);
        request.getRequestDispatcher("/views/patient/patient-invoices.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/patient/invoices");
    }
}
