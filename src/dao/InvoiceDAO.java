package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Invoice;
import util.DBConnection;

public class InvoiceDAO {

    public List<Invoice> getAllInvoices() {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT * FROM Invoice";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Invoice getInvoiceById(String id) {
        String sql = "SELECT * FROM Invoice WHERE invoiceId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) return mapRow(rs);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Invoice> getInvoicesByAppointmentId(String appointmentId) {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT * FROM Invoice WHERE appointmentId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, appointmentId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Invoice> getInvoicesByPatientId(String patientId) {
        List<Invoice> list = new ArrayList<>();
        String sql =
            "SELECT i.* FROM Invoice i " +
            "JOIN Appointment a ON i.appointmentId = a.appointmentId " +
            "WHERE a.patientId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) list.add(mapRow(rs));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Invoice> getInvoicesByPatientIdEnriched(String patientId) {
        List<Invoice> list = new ArrayList<>();
        String sql =
            "SELECT i.*, du.fullName AS doctorName " +
            "FROM Invoice i " +
            "LEFT JOIN Appointment a ON i.appointmentId = a.appointmentId " +
            "LEFT JOIN Doctor doc ON a.doctorId = doc.doctorId " +
            "LEFT JOIN user du ON doc.userId = du.userId " +
            "WHERE a.patientId = ? " +
            "ORDER BY i.date DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice inv = mapRow(rs);
                    inv.setDoctorName(rs.getString("doctorName"));
                    list.add(inv);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Invoice> getAllInvoicesEnrichedForManager(String statusFilter) {
        List<Invoice> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
            "SELECT i.*, pu.fullName AS patientName, du.fullName AS doctorName " +
            "FROM Invoice i " +
            "LEFT JOIN Appointment a ON i.appointmentId = a.appointmentId " +
            "LEFT JOIN Patient pat ON a.patientId = pat.patientId " +
            "LEFT JOIN user pu ON pat.userId = pu.userId " +
            "LEFT JOIN Doctor doc ON a.doctorId = doc.doctorId " +
            "LEFT JOIN user du ON doc.userId = du.userId"
        );
        if (statusFilter != null && !statusFilter.isEmpty()) {
            sql.append(" WHERE i.status = ?");
        }
        sql.append(" ORDER BY i.date DESC");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            if (statusFilter != null && !statusFilter.isEmpty()) {
                ps.setString(1, statusFilter);
            }
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice inv = mapRow(rs);
                    inv.setPatientName(rs.getString("patientName"));
                    inv.setDoctorName(rs.getString("doctorName"));
                    list.add(inv);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertInvoice(Invoice invoice) {
        String sql = "INSERT INTO Invoice (invoiceId, appointmentId, date, totalAmount, status) VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, invoice.getInvoiceId());
            ps.setString(2, invoice.getAppointmentId());
            ps.setDate(3, invoice.getDate());
            ps.setDouble(4, invoice.getTotalAmount());
            ps.setString(5, invoice.getStatus());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateInvoice(Invoice invoice) {
        String sql = "UPDATE Invoice SET appointmentId = ?, date = ?, totalAmount = ?, status = ? WHERE invoiceId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, invoice.getAppointmentId());
            ps.setDate(2, invoice.getDate());
            ps.setDouble(3, invoice.getTotalAmount());
            ps.setString(4, invoice.getStatus());
            ps.setString(5, invoice.getInvoiceId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateInvoiceStatus(String invoiceId, String status) {
        String sql = "UPDATE Invoice SET status = ? WHERE invoiceId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, invoiceId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteInvoice(String invoiceId) {
        String sql = "DELETE FROM Invoice WHERE invoiceId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, invoiceId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    private Invoice mapRow(ResultSet rs) throws Exception {
        Invoice inv = new Invoice();
        inv.setInvoiceId(rs.getString("invoiceId"));
        inv.setAppointmentId(rs.getString("appointmentId"));
        inv.setDate(rs.getDate("date"));
        inv.setTotalAmount(rs.getDouble("totalAmount"));
        inv.setStatus(rs.getString("status"));
        return inv;
    }
}
