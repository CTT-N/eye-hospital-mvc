package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Department;
import util.DBConnection;

public class DepartmentDAO {

    public List<Department> getAllDepartments() {
        List<Department> list = new ArrayList<>();
        String sql = "SELECT * FROM Department";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Department dept = new Department();
                dept.setDepartmentId(rs.getString("departmentId"));
                dept.setHospitalId(rs.getString("hospitalId"));
                dept.setDepartmentName(rs.getString("departmentName"));
                dept.setDescription(rs.getString("description"));
                list.add(dept);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Department getDepartmentById(String id) {
        String sql = "SELECT * FROM Department WHERE departmentId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Department dept = new Department();
                    dept.setDepartmentId(rs.getString("departmentId"));
                    dept.setHospitalId(rs.getString("hospitalId"));
                    dept.setDepartmentName(rs.getString("departmentName"));
                    dept.setDescription(rs.getString("description"));
                    return dept;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertDepartment(Department dept) {
        String sql = "INSERT INTO Department (departmentId, hospitalId, departmentName, description) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, dept.getDepartmentId());
            ps.setString(2, dept.getHospitalId());
            ps.setString(3, dept.getDepartmentName());
            ps.setString(4, dept.getDescription());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateDepartment(Department dept) {
        String sql = "UPDATE Department SET hospitalId=?, departmentName=?, description=? WHERE departmentId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, dept.getHospitalId());
            ps.setString(2, dept.getDepartmentName());
            ps.setString(3, dept.getDescription());
            ps.setString(4, dept.getDepartmentId());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteDepartment(String id) {
        String sql = "DELETE FROM Department WHERE departmentId=?";

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
