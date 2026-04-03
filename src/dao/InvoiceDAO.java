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
                Invoice invoice = new Invoice();
                invoice.setInvoiceId(rs.getString("invoiceId"));
                invoice.setAppointmentId(rs.getString("appointmentId"));
                invoice.setDate(rs.getDate("date"));
                invoice.setTotalAmount(rs.getDouble("totalAmount"));
                list.add(invoice);
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
                if (rs.next()) {
                    Invoice invoice = new Invoice();
                    invoice.setInvoiceId(rs.getString("invoiceId"));
                    invoice.setAppointmentId(rs.getString("appointmentId"));
                    invoice.setDate(rs.getDate("date"));
                    invoice.setTotalAmount(rs.getDouble("totalAmount"));
                    return invoice;
                }
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
                while (rs.next()) {
                    Invoice invoice = new Invoice();
                    invoice.setInvoiceId(rs.getString("invoiceId"));
                    invoice.setAppointmentId(rs.getString("appointmentId"));
                    invoice.setDate(rs.getDate("date"));
                    invoice.setTotalAmount(rs.getDouble("totalAmount"));
                    list.add(invoice);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Invoice> getInvoicesByPatientId(String patientId) {
        List<Invoice> list = new ArrayList<>();
        String sql = "SELECT i.* FROM Invoice i " +
                     "JOIN Appointment a ON i.appointmentId = a.appointmentId " +
                     "WHERE a.patientId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Invoice invoice = new Invoice();
                    invoice.setInvoiceId(rs.getString("invoiceId"));
                    invoice.setAppointmentId(rs.getString("appointmentId"));
                    invoice.setDate(rs.getDate("date"));
                    invoice.setTotalAmount(rs.getDouble("totalAmount"));
                    list.add(invoice);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertInvoice(Invoice invoice) {
        String sql = "INSERT INTO Invoice (invoiceId, appointmentId, date, totalAmount) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, invoice.getInvoiceId());
            ps.setString(2, invoice.getAppointmentId());
            ps.setDate(3, invoice.getDate());
            ps.setDouble(4, invoice.getTotalAmount());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateInvoice(Invoice invoice) {
        String sql = "UPDATE Invoice SET appointmentId=?, date=?, totalAmount=? WHERE invoiceId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, invoice.getAppointmentId());
            ps.setDate(2, invoice.getDate());
            ps.setDouble(3, invoice.getTotalAmount());
            ps.setString(4, invoice.getInvoiceId());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteInvoice(String invoiceId) {
        String sql = "DELETE FROM Invoice WHERE invoiceId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, invoiceId);

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
