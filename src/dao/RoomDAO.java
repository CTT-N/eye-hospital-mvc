package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.Room;
import util.DBConnection;

public class RoomDAO {

    public List<Room> getAllRooms() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM Room";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Room room = new Room();
                room.setRoomId(rs.getString("roomId"));
                room.setDepartmentId(rs.getString("departmentId"));
                room.setRoomName(rs.getString("roomName"));
                room.setDescription(rs.getString("description"));
                list.add(room);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Room getRoomById(String id) {
        String sql = "SELECT * FROM Room WHERE roomId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Room room = new Room();
                    room.setRoomId(rs.getString("roomId"));
                    room.setDepartmentId(rs.getString("departmentId"));
                    room.setRoomName(rs.getString("roomName"));
                    room.setDescription(rs.getString("description"));
                    return room;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Room> getRoomsByDepartmentId(String deptId) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM Room WHERE departmentId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, deptId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Room room = new Room();
                    room.setRoomId(rs.getString("roomId"));
                    room.setDepartmentId(rs.getString("departmentId"));
                    room.setRoomName(rs.getString("roomName"));
                    room.setDescription(rs.getString("description"));
                    list.add(room);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertRoom(Room room) {
        String sql = "INSERT INTO Room (roomId, departmentId, roomName, description) VALUES (?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, room.getRoomId());
            ps.setString(2, room.getDepartmentId());
            ps.setString(3, room.getRoomName());
            ps.setString(4, room.getDescription());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateRoom(Room room) {
        String sql = "UPDATE Room SET departmentId=?, roomName=?, description=? WHERE roomId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, room.getDepartmentId());
            ps.setString(2, room.getRoomName());
            ps.setString(3, room.getDescription());
            ps.setString(4, room.getRoomId());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteRoom(String id) {
        String sql = "DELETE FROM Room WHERE roomId=?";

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
