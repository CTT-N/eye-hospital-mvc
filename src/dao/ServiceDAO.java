package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Service;
import util.DBConnection;

public class ServiceDAO {

    public List<Service> getAllServices() {
        List<Service> list = new ArrayList<>();
        String sql = "SELECT * FROM Service";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Service service = new Service();
                service.setServiceId(rs.getString("serviceId"));
                service.setServiceName(rs.getString("serviceName"));
                service.setPrice(rs.getDouble("price"));
                service.setDescription(rs.getString("description"));
                list.add(service);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Service getServiceById(String id) {
        String sql = "SELECT * FROM Service WHERE serviceId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Service service = new Service();
                    service.setServiceId(rs.getString("serviceId"));
                    service.setServiceName(rs.getString("serviceName"));
                    service.setPrice(rs.getDouble("price"));
                    service.setDescription(rs.getString("description"));
                    return service;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertService(Service service) {
        String sql = "INSERT INTO Service (serviceId, serviceName, price, description) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, service.getServiceId());
            ps.setString(2, service.getServiceName());
            ps.setDouble(3, service.getPrice());
            ps.setString(4, service.getDescription());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateService(Service service) {
        String sql = "UPDATE Service SET serviceName=?, price=?, description=? WHERE serviceId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, service.getServiceName());
            ps.setDouble(2, service.getPrice());
            ps.setString(3, service.getDescription());
            ps.setString(4, service.getServiceId());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteService(String id) {
        String sql = "DELETE FROM Service WHERE serviceId=?";

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
