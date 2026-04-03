package controller.doctor;

import dao.MedicalRecordDAO;
import model.MedicalRecord;
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

@WebServlet("/doctor/medical-records")
public class MedicalRecordController extends HttpServlet {

    private MedicalRecordDAO recordDAO = new MedicalRecordDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        List<MedicalRecord> list = recordDAO.getAllRecords();
        request.setAttribute("listRecords", list);
        request.getRequestDispatcher("/views/doctor/doctor-patient-record.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) action = "";

        if ("delete".equals(action)) {
            String id = request.getParameter("recordId");
            recordDAO.deleteRecord(id);
        } else if ("add".equals(action)) {
            MedicalRecord record = new MedicalRecord();
            record.setRecordId(request.getParameter("recordId"));
            record.setAppointmentId(request.getParameter("appointmentId"));
            record.setSymptoms(request.getParameter("symptoms"));
            record.setDiagnosis(request.getParameter("diagnosis"));
            record.setTreatment(request.getParameter("treatment"));
            record.setNote(request.getParameter("note"));
            record.setCreatedDate(new java.sql.Date(System.currentTimeMillis()));
            recordDAO.insertRecord(record);
        } else if ("update".equals(action)) {
            MedicalRecord record = new MedicalRecord();
            record.setRecordId(request.getParameter("recordId"));
            record.setAppointmentId(request.getParameter("appointmentId"));
            record.setSymptoms(request.getParameter("symptoms"));
            record.setDiagnosis(request.getParameter("diagnosis"));
            record.setTreatment(request.getParameter("treatment"));
            record.setNote(request.getParameter("note"));
            recordDAO.updateRecord(record);
        }

        response.sendRedirect(request.getContextPath() + "/doctor/medical-records?msg=success");
    }
}
