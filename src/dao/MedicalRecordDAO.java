package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

import model.MedicalRecord;
import util.DBConnection;

public class MedicalRecordDAO {

    public List<MedicalRecord> getAllRecords() {
        List<MedicalRecord> list = new ArrayList<>();
        String sql = "SELECT * FROM MedicalRecord";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                MedicalRecord record = new MedicalRecord();
                record.setRecordId(rs.getString("recordId"));
                record.setAppointmentId(rs.getString("appointmentId"));
                record.setSymptoms(rs.getString("symptoms"));
                record.setDiagnosis(rs.getString("diagnosis"));
                record.setTreatment(rs.getString("treatment"));
                record.setCreatedDate(rs.getDate("createdDate"));
                record.setNote(rs.getString("note"));
                list.add(record);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public MedicalRecord getRecordById(String id) {
        String sql = "SELECT * FROM MedicalRecord WHERE recordId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    MedicalRecord record = new MedicalRecord();
                    record.setRecordId(rs.getString("recordId"));
                    record.setAppointmentId(rs.getString("appointmentId"));
                    record.setSymptoms(rs.getString("symptoms"));
                    record.setDiagnosis(rs.getString("diagnosis"));
                    record.setTreatment(rs.getString("treatment"));
                    record.setCreatedDate(rs.getDate("createdDate"));
                    record.setNote(rs.getString("note"));
                    return record;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public MedicalRecord getRecordByAppointmentId(String appointmentId) {
        String sql = "SELECT * FROM MedicalRecord WHERE appointmentId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    MedicalRecord record = new MedicalRecord();
                    record.setRecordId(rs.getString("recordId"));
                    record.setAppointmentId(rs.getString("appointmentId"));
                    record.setSymptoms(rs.getString("symptoms"));
                    record.setDiagnosis(rs.getString("diagnosis"));
                    record.setTreatment(rs.getString("treatment"));
                    record.setCreatedDate(rs.getDate("createdDate"));
                    record.setNote(rs.getString("note"));
                    return record;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    /**
     * Returns all medical records belonging to a patient,
     * ordered newest first. Joins through Appointment to filter by patientId.
     */
    public List<MedicalRecord> getRecordsByPatientId(String patientId) {
        List<MedicalRecord> list = new ArrayList<>();
        String sql =
            "SELECT mr.* FROM MedicalRecord mr " +
            "JOIN Appointment a ON mr.appointmentId = a.appointmentId " +
            "WHERE a.patientId = ? " +
            "ORDER BY mr.createdDate DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    MedicalRecord record = new MedicalRecord();
                    record.setRecordId(rs.getString("recordId"));
                    record.setAppointmentId(rs.getString("appointmentId"));
                    record.setSymptoms(rs.getString("symptoms"));
                    record.setDiagnosis(rs.getString("diagnosis"));
                    record.setTreatment(rs.getString("treatment"));
                    record.setCreatedDate(rs.getDate("createdDate"));
                    record.setNote(rs.getString("note"));
                    list.add(record);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertRecord(MedicalRecord record) {
        String sql = "INSERT INTO MedicalRecord (recordId, appointmentId, symptoms, diagnosis, treatment, createdDate, note) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, record.getRecordId());
            ps.setString(2, record.getAppointmentId());
            ps.setString(3, record.getSymptoms());
            ps.setString(4, record.getDiagnosis());
            ps.setString(5, record.getTreatment());
            ps.setDate(6, record.getCreatedDate());
            ps.setString(7, record.getNote());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateRecord(MedicalRecord record) {
        String sql = "UPDATE MedicalRecord SET appointmentId=?, symptoms=?, diagnosis=?, treatment=?, note=? WHERE recordId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, record.getAppointmentId());
            ps.setString(2, record.getSymptoms());
            ps.setString(3, record.getDiagnosis());
            ps.setString(4, record.getTreatment());
            ps.setString(5, record.getNote());
            ps.setString(6, record.getRecordId());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean saveRecordAndCompleteAppointmentForDoctor(MedicalRecord record, String doctorId) {
        String selectRecordSql = "SELECT recordId FROM MedicalRecord WHERE appointmentId = ?";
        String insertRecordSql = "INSERT INTO MedicalRecord (recordId, appointmentId, symptoms, diagnosis, treatment, createdDate, note) VALUES (?, ?, ?, ?, ?, ?, ?)";
        String updateRecordSql = "UPDATE MedicalRecord SET appointmentId=?, symptoms=?, diagnosis=?, treatment=?, note=? WHERE recordId=?";
        String updateAppointmentSql = "UPDATE Appointment SET status=? WHERE appointmentId=? AND doctorId=? AND status=?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try {
                String existingRecordId = null;
                try (PreparedStatement ps = conn.prepareStatement(selectRecordSql)) {
                    ps.setString(1, record.getAppointmentId());
                    try (ResultSet rs = ps.executeQuery()) {
                        if (rs.next()) {
                            existingRecordId = rs.getString("recordId");
                        }
                    }
                }

                boolean recordSaved;
                if (existingRecordId == null) {
                    try (PreparedStatement ps = conn.prepareStatement(insertRecordSql)) {
                        ps.setString(1, record.getRecordId());
                        ps.setString(2, record.getAppointmentId());
                        ps.setString(3, record.getSymptoms());
                        ps.setString(4, record.getDiagnosis());
                        ps.setString(5, record.getTreatment());
                        ps.setDate(6, record.getCreatedDate() != null ? record.getCreatedDate() : new Date(System.currentTimeMillis()));
                        ps.setString(7, record.getNote());
                        recordSaved = ps.executeUpdate() > 0;
                    }
                } else {
                    try (PreparedStatement ps = conn.prepareStatement(updateRecordSql)) {
                        ps.setString(1, record.getAppointmentId());
                        ps.setString(2, record.getSymptoms());
                        ps.setString(3, record.getDiagnosis());
                        ps.setString(4, record.getTreatment());
                        ps.setString(5, record.getNote());
                        ps.setString(6, existingRecordId);
                        recordSaved = ps.executeUpdate() > 0;
                    }
                }

                if (!recordSaved) {
                    safeRollback(conn);
                    return false;
                }

                try (PreparedStatement ps = conn.prepareStatement(updateAppointmentSql)) {
                    ps.setString(1, "COMPLETED");
                    ps.setString(2, record.getAppointmentId());
                    ps.setString(3, doctorId);
                    ps.setString(4, "CONFIRMED");

                    if (ps.executeUpdate() <= 0) {
                        safeRollback(conn);
                        return false;
                    }
                }

                conn.commit();
                return true;
            } catch (Exception e) {
                e.printStackTrace();
                safeRollback(conn);
            } finally {
                try {
                    conn.setAutoCommit(true);
                } catch (Exception ignore) {
                    // Restore best-effort; connection is closing.
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private void safeRollback(Connection conn) {
        try {
            conn.rollback();
        } catch (Exception ignore) {
            // Best-effort rollback.
        }
    }

    public boolean deleteRecord(String id) {
        String sql = "DELETE FROM MedicalRecord WHERE recordId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
