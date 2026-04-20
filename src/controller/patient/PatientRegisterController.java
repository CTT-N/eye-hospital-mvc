package controller.patient;

import dao.AppointmentDAO;
import dao.PatientDAO;
import dao.UserDAO;
import dao.MedicalRecordDAO;
import model.Appointment;
import model.Patient;
import model.User;
import model.MedicalRecord;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.UUID;

@WebServlet("/patient/register-exam")
public class PatientRegisterController extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        request.getRequestDispatcher("/views/patient/book-appointment.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"PATIENT".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        Patient patient = patientDAO.getPatientByUserId(user.getUserId());
        if (patient == null) {
            request.setAttribute("error", "Vui lòng cập nhật thông tin bệnh nhân trước khi đặt lịch.");
            request.getRequestDispatcher("/views/patient/book-appointment.jsp").forward(request, response);
            return;
        }

        request.setCharacterEncoding("UTF-8");

        String dateStr = request.getParameter("date");
        String timeStr = request.getParameter("time");
        String doctorId = request.getParameter("doctorId");

        if (dateStr == null || dateStr.isEmpty() || timeStr == null || timeStr.isEmpty() || doctorId == null || doctorId.isEmpty()) {
            request.setAttribute("error", "Vui lòng chọn ngày, giờ khám và bác sĩ.");
            request.getRequestDispatcher("/views/patient/book-appointment.jsp").forward(request, response);
            return;
        }

        String fullName = request.getParameter("fullName");
        String dobStr = request.getParameter("dob");
        String phone = request.getParameter("phone");
        String email = request.getParameter("email");
        String gender = request.getParameter("gender");
        String insuranceId = request.getParameter("insuranceId");
        String reason = request.getParameter("reason");
        String medicalHistory = request.getParameter("medicalHistory");

        Date apptDate;
        Time apptTime;
        try {
            apptDate = Date.valueOf(dateStr);
            apptTime = Time.valueOf(timeStr + ":00");
        } catch (IllegalArgumentException e) {
            request.setAttribute("error", "Ngày hoặc giờ không hợp lệ. Vui lòng chọn lại.");
            request.getRequestDispatcher("/views/patient/book-appointment.jsp").forward(request, response);
            return;
        }

        if (!appointmentDAO.isDoctorAvailable(doctorId, apptDate, apptTime)) {
            request.setAttribute("error", "Bác sĩ đã có lịch hẹn vào thời gian này. Vui lòng chọn giờ hoặc bác sĩ khác.");
            request.getRequestDispatcher("/views/patient/book-appointment.jsp").forward(request, response);
            return;
        }

        if (fullName != null && !fullName.trim().isEmpty()) {
            user.setFullName(fullName.trim());
        }
        if (phone != null) user.setPhone(phone.trim());
        if (email != null) user.setEmail(email.trim());
        new UserDAO().updateUser(user);
        session.setAttribute("user", user);

        try {
            if (dobStr != null && !dobStr.isEmpty()) patient.setBirthday(Date.valueOf(dobStr));
        } catch (IllegalArgumentException e) {}
        
        if (gender != null) patient.setGender(gender);
        
        String combinedNote = "";
        if (insuranceId != null && !insuranceId.trim().isEmpty()) {
            combinedNote += "BHYT: " + insuranceId.trim() + " | ";
        }
        if (medicalHistory != null && !medicalHistory.trim().isEmpty()) {
            combinedNote += "Tiền sử: " + medicalHistory.trim();
        }
        if (!combinedNote.isEmpty()) patient.setNote(combinedNote);
        
        patientDAO.updatePatient(patient);

        Appointment appt = new Appointment();
        String appointmentId = "APT-" + UUID.randomUUID().toString().substring(0, 5).toUpperCase();
        appt.setAppointmentId(appointmentId);
        appt.setPatientId(patient.getPatientId());
        appt.setDoctorId(doctorId);
        appt.setDate(apptDate);
        appt.setTime(apptTime);
        appt.setStatus("PENDING");
        appointmentDAO.insertAppointment(appt);

        MedicalRecord record = new MedicalRecord();
        record.setRecordId("MR-" + UUID.randomUUID().toString().substring(0, 6).toUpperCase());
        record.setAppointmentId(appointmentId);
        record.setSymptoms(reason != null ? reason.trim() : "");
        record.setDiagnosis("");
        record.setTreatment("");
        record.setNote("");
        record.setCreatedDate(new Date(System.currentTimeMillis()));
        new MedicalRecordDAO().insertRecord(record);

        response.sendRedirect(request.getContextPath() + "/patient/history?msg=registered");
    }
}
