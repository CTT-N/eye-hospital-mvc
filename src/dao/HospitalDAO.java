package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Hospital;
import util.DBConnection;

public class HospitalDAO {

    public List<Hospital> getAllHospitals() {
        List<Hospital> list = new ArrayList<>();
        String sql = "SELECT * FROM Hospital";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Hospital hospital = new Hospital();
                hospital.setHospitalId(rs.getString("hospitalId"));
                hospital.setHospitalName(rs.getString("hospitalName"));
                hospital.setAddress(rs.getString("address"));
                hospital.setDescription(rs.getString("description"));
                list.add(hospital);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Hospital getHospitalById(String id) {
        String sql = "SELECT * FROM Hospital WHERE hospitalId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Hospital hospital = new Hospital();
                    hospital.setHospitalId(rs.getString("hospitalId"));
                    hospital.setHospitalName(rs.getString("hospitalName"));
                    hospital.setAddress(rs.getString("address"));
                    hospital.setDescription(rs.getString("description"));
                    return hospital;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertHospital(Hospital hospital) {
        String sql = "INSERT INTO Hospital (hospitalId, hospitalName, address, description) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, hospital.getHospitalId());
            ps.setString(2, hospital.getHospitalName());
            ps.setString(3, hospital.getAddress());
            ps.setString(4, hospital.getDescription());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateHospital(Hospital hospital) {
        String sql = "UPDATE Hospital SET hospitalName=?, address=?, description=? WHERE hospitalId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, hospital.getHospitalName());
            ps.setString(2, hospital.getAddress());
            ps.setString(3, hospital.getDescription());
            ps.setString(4, hospital.getHospitalId());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteHospital(String id) {
        String sql = "DELETE FROM Hospital WHERE hospitalId=?";

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
