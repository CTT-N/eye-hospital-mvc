package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import model.User;
import util.DBConnection;

public class LoginDAO {

    public User checkLogin(String username, String password) {

        User user = null;

        try {

            Connection conn = DBConnection.getConnection();

            String sql = "SELECT * FROM User WHERE UserName=? AND Password=?";

            PreparedStatement ps = conn.prepareStatement(sql);

            ps.setString(1, username);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {

                user = new User();

                user.setUserId(rs.getString("UserId"));
                user.setUserName(rs.getString("UserName"));
                user.setRole(rs.getString("Role"));

            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return user;
    }
}