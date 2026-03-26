package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
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
        String sql = "UPDATE MedicalRecord SET appointmentId=?, symptoms=?, diagnosis=?, treatment=?, createdDate=?, note=? WHERE recordId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, record.getAppointmentId());
            ps.setString(2, record.getSymptoms());
            ps.setString(3, record.getDiagnosis());
            ps.setString(4, record.getTreatment());
            ps.setDate(5, record.getCreatedDate());
            ps.setString(6, record.getNote());
            ps.setString(7, record.getRecordId());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
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
