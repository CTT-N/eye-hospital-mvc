package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import util.DBConnection;

public class ReportDAO {

    /**
     * Returns a map of status -> count for all appointments.
     */
    public Map<String, Integer> getAppointmentCountByStatus() {
        Map<String, Integer> result = new LinkedHashMap<>();
        String sql = "SELECT status, COUNT(*) as cnt FROM Appointment GROUP BY status ORDER BY cnt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                String status = rs.getString("status");
                int count = rs.getInt("cnt");
                result.put(status != null ? status : "N/A", count);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * Returns a map of doctorId -> appointment count.
     */
    public Map<String, Integer> getAppointmentCountByDoctor() {
        Map<String, Integer> result = new LinkedHashMap<>();
        String sql = "SELECT doctorId, COUNT(*) as cnt FROM Appointment WHERE doctorId IS NOT NULL GROUP BY doctorId ORDER BY cnt DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                result.put(rs.getString("doctorId"), rs.getInt("cnt"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    /**
     * Returns a map of YYYY-MM -> appointment count for recent months.
     */
    public Map<String, Integer> getMonthlyAppointments(int months) {
        Map<String, Integer> result = new LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(date, '%Y-%m') as month, COUNT(*) as cnt " +
                     "FROM Appointment WHERE date IS NOT NULL " +
                     "GROUP BY DATE_FORMAT(date, '%Y-%m') " +
                     "ORDER BY month DESC LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, months);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.put(rs.getString("month"), rs.getInt("cnt"));
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }
}
