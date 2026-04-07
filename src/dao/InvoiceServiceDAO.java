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
        String sql = "SELECT * FROM Invoice_Service WHERE invoiceId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, invoiceId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    InvoiceService is = new InvoiceService();
                    is.setInvoiceId(rs.getString("invoiceId"));
                    is.setServiceId(rs.getString("serviceId"));
                    is.setQuanlity(rs.getInt("quantity"));
                    is.setTotalPrice(rs.getFloat("totalPrice"));
                    list.add(is);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertInvoiceService(InvoiceService is) {
        String sql = "INSERT INTO Invoice_Service (invoiceId, serviceId, quantity, totalPrice) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, is.getInvoiceId());
            ps.setString(2, is.getServiceId());
            ps.setInt(3, is.getQuanlity());
            ps.setFloat(4, is.getTotalPrice());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteInvoiceService(String invoiceId, String serviceId) {
        String sql = "DELETE FROM Invoice_Service WHERE invoiceId=? AND serviceId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, invoiceId);
            ps.setString(2, serviceId);

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteByInvoiceId(String invoiceId) {
        String sql = "DELETE FROM Invoice_Service WHERE invoiceId=?";

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
