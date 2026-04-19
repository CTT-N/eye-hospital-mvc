package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.InvoiceService;
import util.DBConnection;

public class InvoiceServiceDAO {

    public List<InvoiceService> getServicesByInvoiceId(String invoiceId) {
        List<InvoiceService> list = new ArrayList<>();
        String sql =
            "SELECT inv_svc.*, s.serviceName " +
            "FROM Invoice_Service inv_svc " +
            "JOIN Service s ON inv_svc.serviceId = s.serviceId " +
            "WHERE inv_svc.invoiceId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InvoiceService item = new InvoiceService();
                    item.setInvoiceId(rs.getString("invoiceId"));
                    item.setServiceId(rs.getString("serviceId"));
                    item.setServiceName(rs.getString("serviceName"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setTotalPrice(rs.getDouble("totalPrice"));
                    list.add(item);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertInvoiceService(InvoiceService item) {
        String sql = "INSERT INTO Invoice_Service (invoiceId, serviceId, quantity, totalPrice) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, item.getInvoiceId());
            ps.setString(2, item.getServiceId());
            ps.setInt(3, item.getQuantity());
            ps.setDouble(4, item.getTotalPrice());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteInvoiceService(String invoiceId, String serviceId) {
        String sql = "DELETE FROM Invoice_Service WHERE invoiceId = ? AND serviceId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, invoiceId);
            ps.setString(2, serviceId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteByInvoiceId(String invoiceId) {
        String sql = "DELETE FROM Invoice_Service WHERE invoiceId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, invoiceId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
