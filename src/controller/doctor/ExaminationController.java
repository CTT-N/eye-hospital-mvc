package controller.doctor;

import dao.AppointmentDAO;
import dao.MedicalRecordDAO;
import model.Appointment;
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
import java.util.UUID;

@WebServlet("/doctor/examination")
public class ExaminationController extends HttpServlet {

    private MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String appointmentId = request.getParameter("appointmentId");
        if (appointmentId != null) {
            Appointment appt = appointmentDAO.getAppointmentById(appointmentId);
            request.setAttribute("appointment", appt);

            MedicalRecord record = medicalRecordDAO.getRecordByAppointmentId(appointmentId);
            request.setAttribute("medicalRecord", record);
        }

        request.getRequestDispatcher("/views/doctor/doctor-appointment-detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String appointmentId = request.getParameter("appointmentId");
        String symptoms = request.getParameter("symptoms");
        String diagnosis = request.getParameter("diagnosis");
        String treatment = request.getParameter("treatment");
        String note = request.getParameter("note");

        MedicalRecord record = medicalRecordDAO.getRecordByAppointmentId(appointmentId);
        if (record == null) {
            // Nhập mới bệnh án
            record = new MedicalRecord();
            record.setRecordId("MR-" + UUID.randomUUID().toString().substring(0, 8));
            record.setAppointmentId(appointmentId);
            record.setSymptoms(symptoms);
            record.setDiagnosis(diagnosis);
            record.setTreatment(treatment);
            record.setNote(note);
            record.setCreatedDate(new Date(System.currentTimeMillis()));

            medicalRecordDAO.insertRecord(record);
        } else {
            // Cập nhật bệnh án
            record.setSymptoms(symptoms);
            record.setDiagnosis(diagnosis);
            record.setTreatment(treatment);
            record.setNote(note);

            medicalRecordDAO.updateRecord(record);
        }

        // Đánh dấu cuộc hẹn đã khám xong
        appointmentDAO.updateAppointmentStatus(appointmentId, "COMPLETED");

        response.sendRedirect(request.getContextPath() + "/doctor/schedule?msg=exam_success");
    }
}
