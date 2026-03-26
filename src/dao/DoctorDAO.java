package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Doctor;
import util.DBConnection;

public class DoctorDAO {

    public List<Doctor> getAllDoctors() {
        List<Doctor> list = new ArrayList<>();
        String sql = "SELECT * FROM Doctor";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Doctor doctor = new Doctor();
                doctor.setDoctorId(rs.getString("doctorId"));
                doctor.setUserId(rs.getString("userId"));
                doctor.setDepartmentId(rs.getString("departmentId"));
                doctor.setEducationDegree(rs.getString("educationDegree"));
                doctor.setExperience(rs.getString("experience"));
                doctor.setDescription(rs.getString("description"));
                list.add(doctor);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Doctor getDoctorById(String id) {
        String sql = "SELECT * FROM Doctor WHERE doctorId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setDoctorId(rs.getString("doctorId"));
                    doctor.setUserId(rs.getString("userId"));
                    doctor.setDepartmentId(rs.getString("departmentId"));
                    doctor.setEducationDegree(rs.getString("educationDegree"));
                    doctor.setExperience(rs.getString("experience"));
                    doctor.setDescription(rs.getString("description"));
                    return doctor;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Doctor getDoctorByUserId(String userId) {
        String sql = "SELECT * FROM Doctor WHERE userId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, userId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Doctor doctor = new Doctor();
                    doctor.setDoctorId(rs.getString("doctorId"));
                    doctor.setUserId(rs.getString("userId"));
                    doctor.setDepartmentId(rs.getString("departmentId"));
                    doctor.setEducationDegree(rs.getString("educationDegree"));
                    doctor.setExperience(rs.getString("experience"));
                    doctor.setDescription(rs.getString("description"));
                    return doctor;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertDoctor(Doctor doctor) {
        String sql = "INSERT INTO Doctor (doctorId, userId, departmentId, educationDegree, experience, description) VALUES (?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, doctor.getDoctorId());
            ps.setString(2, doctor.getUserId());
            ps.setString(3, doctor.getDepartmentId());
            ps.setString(4, doctor.getEducationDegree());
            ps.setString(5, doctor.getExperience());
            ps.setString(6, doctor.getDescription());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateDoctor(Doctor doctor) {
        String sql = "UPDATE Doctor SET userId=?, departmentId=?, educationDegree=?, experience=?, description=? WHERE doctorId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, doctor.getUserId());
            ps.setString(2, doctor.getDepartmentId());
            ps.setString(3, doctor.getEducationDegree());
            ps.setString(4, doctor.getExperience());
            ps.setString(5, doctor.getDescription());
            ps.setString(6, doctor.getDoctorId());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteDoctor(String id) {
        String sql = "DELETE FROM Doctor WHERE doctorId=?";

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
