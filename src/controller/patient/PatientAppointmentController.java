package controller.patient;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.PatientDAO;
import model.Appointment;
import model.Doctor;
import model.Patient;
import model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Time;
import java.util.List;
import java.util.UUID;

@WebServlet("/patient/appointment")
public class PatientAppointmentController extends HttpServlet {

    private DoctorDAO doctorDAO = new DoctorDAO();
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

        // Lấy danh sách bác sĩ để hiển thị trên form đặt lịch
        List<Doctor> doctors = doctorDAO.getAllDoctors();
        request.setAttribute("doctors", doctors);

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

        try {
            String doctorId = request.getParameter("doctorId");
            String dateStr = request.getParameter("date");
            String timeStr = request.getParameter("time");
            
            // Lấy thông tin patient từ user map sang; tự tạo nếu chưa có
            Patient patient = patientDAO.getPatientByUserId(user.getUserId());
            if (patient == null) {
                patient = new Patient();
                patient.setPatientId("PAT-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase());
                patient.setUserId(user.getUserId());
                patientDAO.insertPatient(patient);
            }

            // Tạo đối tượng Appointment
            Appointment appt = new Appointment();
            appt.setAppointmentId("APT-" + UUID.randomUUID().toString().substring(0, 8));
            appt.setPatientId(patient.getPatientId());
            appt.setDoctorId(doctorId);
            appt.setDate(Date.valueOf(dateStr));
            appt.setTime(Time.valueOf(timeStr + ":00")); // format HH:mm:ss
            appt.setStatus("PENDING"); // trạng thái chờ duyệt

            boolean success = appointmentDAO.insertAppointment(appt);
            
            if (success) {
                response.sendRedirect(request.getContextPath() + "/patient/history?msg=success");
            } else {
                request.setAttribute("error", "Lỗi khi đặt lịch. Vui lòng thử lại.");
                doGet(request, response);
            }
        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Dữ liệu không hợp lệ.");
            doGet(request, response);
        }
    }
}
