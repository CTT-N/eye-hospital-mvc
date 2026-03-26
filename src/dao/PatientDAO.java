package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Patient;
import util.DBConnection;

public class PatientDAO {

    public List<Patient> getAllPatients() {
        List<Patient> list = new ArrayList<>();
        String sql = "SELECT * FROM Patient";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Patient patient = new Patient();
                patient.setPatientId(rs.getString("patientId"));
                patient.setUserId(rs.getString("userId"));
                patient.setCccd(rs.getString("CCCD"));
                patient.setAddress(rs.getString("address"));
                patient.setBirthday(rs.getDate("birthday"));
                patient.setGender(rs.getString("gender"));
                patient.setNote(rs.getString("note"));
                list.add(patient);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Patient getPatientById(String id) {
        String sql = "SELECT * FROM Patient WHERE patientId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Patient patient = new Patient();
                    patient.setPatientId(rs.getString("patientId"));
                    patient.setUserId(rs.getString("userId"));
                    patient.setCccd(rs.getString("CCCD"));
                    patient.setAddress(rs.getString("address"));
                    patient.setBirthday(rs.getDate("birthday"));
                    patient.setGender(rs.getString("gender"));
                    patient.setNote(rs.getString("note"));
                    return patient;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Patient getPatientByUserId(String userId) {
        String sql = "SELECT * FROM Patient WHERE userId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Patient patient = new Patient();
                    patient.setPatientId(rs.getString("patientId"));
                    patient.setUserId(rs.getString("userId"));
                    patient.setCccd(rs.getString("CCCD"));
                    patient.setAddress(rs.getString("address"));
                    patient.setBirthday(rs.getDate("birthday"));
                    patient.setGender(rs.getString("gender"));
                    patient.setNote(rs.getString("note"));
                    return patient;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertPatient(Patient patient) {
        String sql = "INSERT INTO Patient (patientId, userId, CCCD, address, birthday, gender, note) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, patient.getPatientId());
            ps.setString(2, patient.getUserId());
            ps.setString(3, patient.getCccd());
            ps.setString(4, patient.getAddress());
            ps.setDate(5, patient.getBirthday());
            ps.setString(6, patient.getGender());
            ps.setString(7, patient.getNote());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updatePatient(Patient patient) {
        String sql = "UPDATE Patient SET userId=?, CCCD=?, address=?, birthday=?, gender=?, note=? WHERE patientId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, patient.getUserId());
            ps.setString(2, patient.getCccd());
            ps.setString(3, patient.getAddress());
            ps.setDate(4, patient.getBirthday());
            ps.setString(5, patient.getGender());
            ps.setString(6, patient.getNote());
            ps.setString(7, patient.getPatientId());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deletePatient(String id) {
        String sql = "DELETE FROM Patient WHERE patientId=?";

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
