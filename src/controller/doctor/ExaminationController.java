package controller.doctor;

import dao.AppointmentDAO;
import dao.DoctorDAO;
import dao.MedicalRecordDAO;
import model.Appointment;
import model.Doctor;
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

    private static final String CONFIRMED_STATUS = "CONFIRMED";
    private static final String COMPLETED_STATUS = "COMPLETED";
    private static final String COMPLETE_ACTION = "complete";
    private static final String DRAFT_APPOINTMENT_ID = "doctorExamDraftAppointmentId";
    private static final String DRAFT_SYMPTOMS = "doctorExamDraftSymptoms";
    private static final String DRAFT_DIAGNOSIS = "doctorExamDraftDiagnosis";
    private static final String DRAFT_TREATMENT = "doctorExamDraftTreatment";
    private static final String DRAFT_NOTE = "doctorExamDraftNote";

    private MedicalRecordDAO medicalRecordDAO = new MedicalRecordDAO();
    private AppointmentDAO appointmentDAO = new AppointmentDAO();
    private DoctorDAO doctorDAO = new DoctorDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        
        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String appointmentId = request.getParameter("appointmentId");
        if (appointmentId == null || appointmentId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=missing_appointment");
            return;
        }

        Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());
        if (doctor == null) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=forbidden");
            return;
        }

        Appointment appt = appointmentDAO.getAppointmentByIdAndDoctorId(appointmentId, doctor.getDoctorId());
        if (appt == null) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=forbidden");
            return;
        }
        if (!CONFIRMED_STATUS.equals(appt.getStatus()) && !COMPLETED_STATUS.equals(appt.getStatus())) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=forbidden");
            return;
        }
        request.setAttribute("appointment", appt);

        MedicalRecord record = medicalRecordDAO.getRecordByAppointmentId(appointmentId);
        request.setAttribute("medicalRecord", record);
        loadDraftIntoRequest(request, session, appointmentId);

        request.getRequestDispatcher("/views/doctor/doctor-appointment-detail.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect(request.getContextPath() + "/auth/login");
            return;
        }

        String appointmentId = request.getParameter("appointmentId");
        String symptoms = request.getParameter("symptoms");
        String diagnosis = request.getParameter("diagnosis");
        String treatment = request.getParameter("treatment");
        String note = request.getParameter("note");
        String action = request.getParameter("action");

        if (appointmentId == null || appointmentId.trim().isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=missing_appointment");
            return;
        }

        Doctor doctor = doctorDAO.getDoctorByUserId(user.getUserId());
        if (doctor == null) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=forbidden");
            return;
        }

        Appointment appt = appointmentDAO.getAppointmentByIdAndDoctorId(appointmentId, doctor.getDoctorId());
        if (appt == null) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=forbidden");
            return;
        }

        boolean completedAlready = COMPLETED_STATUS.equals(appt.getStatus());
        if (!CONFIRMED_STATUS.equals(appt.getStatus()) && !completedAlready) {
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?error=forbidden");
            return;
        }

        if (isBlank(symptoms) || isBlank(diagnosis) || isBlank(treatment)) {
            storeDraft(session, appointmentId, symptoms, diagnosis, treatment, note);
            response.sendRedirect(request.getContextPath() + "/doctor/examination?appointmentId=" + appointmentId + "&error=missing_fields");
            return;
        }

        MedicalRecord record = medicalRecordDAO.getRecordByAppointmentId(appointmentId);
        boolean existingRecord = record != null;
        if (!existingRecord) {
            record = new MedicalRecord();
            record.setRecordId("MR-" + UUID.randomUUID().toString().substring(0, 8));
            record.setAppointmentId(appointmentId);
            record.setCreatedDate(new Date(System.currentTimeMillis()));
        }
        record.setAppointmentId(appointmentId);
        record.setSymptoms(symptoms != null ? symptoms.trim() : null);
        record.setDiagnosis(diagnosis != null ? diagnosis.trim() : null);
        record.setTreatment(treatment != null ? treatment.trim() : null);
        record.setNote(note != null ? note.trim() : null);
        if (record.getCreatedDate() == null) {
            record.setCreatedDate(new Date(System.currentTimeMillis()));
        }

        boolean completedRequest = COMPLETE_ACTION.equalsIgnoreCase(action);
        boolean saveRequest = !completedRequest;
        boolean saved;
        if (completedRequest) {
            saved = medicalRecordDAO.saveRecordAndCompleteAppointmentForDoctor(record, doctor.getDoctorId());
            if (!saved) {
                storeDraft(session, appointmentId, symptoms, diagnosis, treatment, note);
                response.sendRedirect(request.getContextPath() + "/doctor/examination?appointmentId=" + appointmentId + "&error=save_failed");
                return;
            }

            clearDraft(session);
            response.sendRedirect(request.getContextPath() + "/doctor/schedule?msg=exam_completed");
            return;
        }

        if (saveRequest && !existingRecord) {
            saved = medicalRecordDAO.insertRecord(record);
        } else {
            saved = medicalRecordDAO.updateRecord(record);
        }

        if (!saved) {
            storeDraft(session, appointmentId, symptoms, diagnosis, treatment, note);
            response.sendRedirect(request.getContextPath() + "/doctor/examination?appointmentId=" + appointmentId + "&error=save_failed");
            return;
        }

        clearDraft(session);
        response.sendRedirect(request.getContextPath() + "/doctor/examination?appointmentId=" + appointmentId + "&msg=saved");
    }

    private boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }

    private void storeDraft(HttpSession session, String appointmentId, String symptoms, String diagnosis, String treatment, String note) {
        session.setAttribute(DRAFT_APPOINTMENT_ID, appointmentId);
        session.setAttribute(DRAFT_SYMPTOMS, symptoms);
        session.setAttribute(DRAFT_DIAGNOSIS, diagnosis);
        session.setAttribute(DRAFT_TREATMENT, treatment);
        session.setAttribute(DRAFT_NOTE, note);
    }

    private void loadDraftIntoRequest(HttpServletRequest request, HttpSession session, String appointmentId) {
        String draftAppointmentId = (String) session.getAttribute(DRAFT_APPOINTMENT_ID);
        if (appointmentId != null && appointmentId.equals(draftAppointmentId)) {
            request.setAttribute("draftAppointmentId", draftAppointmentId);
            request.setAttribute("draftSymptoms", session.getAttribute(DRAFT_SYMPTOMS));
            request.setAttribute("draftDiagnosis", session.getAttribute(DRAFT_DIAGNOSIS));
            request.setAttribute("draftTreatment", session.getAttribute(DRAFT_TREATMENT));
            request.setAttribute("draftNote", session.getAttribute(DRAFT_NOTE));
        }
        clearDraft(session);
    }

    private void clearDraft(HttpSession session) {
        session.removeAttribute(DRAFT_APPOINTMENT_ID);
        session.removeAttribute(DRAFT_SYMPTOMS);
        session.removeAttribute(DRAFT_DIAGNOSIS);
        session.removeAttribute(DRAFT_TREATMENT);
        session.removeAttribute(DRAFT_NOTE);
    }
}
