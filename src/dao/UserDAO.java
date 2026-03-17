package dao;

import model.User;
import util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class UserDAO {

    public User login(String username, String password) {

        String sql = "SELECT * FROM user WHERE username=? AND password=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                User user = new User();
                user.setUserId(rs.getString("userId"));
                user.setUsername(rs.getString("username"));
                user.setRole(rs.getString("role"));

                return user;
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    public boolean updatePassword(String userId, String newPassword) {

        String sql = "UPDATE user SET password = ? WHERE userId = ?";

        try (Connection conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newPassword);
            ps.setString(2, userId);

            int rows = ps.executeUpdate();

            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return false;
    }
}