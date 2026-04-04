package dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Time;
import java.util.ArrayList;
import java.util.List;

import model.Appointment;
import util.DBConnection;

public class AppointmentDAO {

    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM Appointment";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Appointment appt = new Appointment();
                appt.setAppointmentId(rs.getString("appointmentId"));
                appt.setPatientId(rs.getString("patientId"));
                appt.setDoctorId(rs.getString("doctorId"));
                appt.setRoomId(rs.getString("roomId"));
                appt.setDate(rs.getDate("date"));
                appt.setTime(rs.getTime("time"));
                appt.setStatus(rs.getString("status"));
                list.add(appt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public Appointment getAppointmentById(String id) {
        String sql = "SELECT * FROM Appointment WHERE appointmentId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Appointment appt = new Appointment();
                    appt.setAppointmentId(rs.getString("appointmentId"));
                    appt.setPatientId(rs.getString("patientId"));
                    appt.setDoctorId(rs.getString("doctorId"));
                    appt.setRoomId(rs.getString("roomId"));
                    appt.setDate(rs.getDate("date"));
                    appt.setTime(rs.getTime("time"));
                    appt.setStatus(rs.getString("status"));
                    return appt;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Appointment> getAppointmentsByPatientId(String patientId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM Appointment WHERE patientId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, patientId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment appt = new Appointment();
                    appt.setAppointmentId(rs.getString("appointmentId"));
                    appt.setPatientId(rs.getString("patientId"));
                    appt.setDoctorId(rs.getString("doctorId"));
                    appt.setRoomId(rs.getString("roomId"));
                    appt.setDate(rs.getDate("date"));
                    appt.setTime(rs.getTime("time"));
                    appt.setStatus(rs.getString("status"));
                    list.add(appt);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> getAppointmentsByDoctorId(String doctorId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT * FROM Appointment WHERE doctorId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, doctorId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Appointment appt = new Appointment();
                    appt.setAppointmentId(rs.getString("appointmentId"));
                    appt.setPatientId(rs.getString("patientId"));
                    appt.setDoctorId(rs.getString("doctorId"));
                    appt.setRoomId(rs.getString("roomId"));
                    appt.setDate(rs.getDate("date"));
                    appt.setTime(rs.getTime("time"));
                    appt.setStatus(rs.getString("status"));
                    list.add(appt);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean insertAppointment(Appointment appt) {
        try (Connection conn = DBConnection.getConnection()) {
            if (appt.getRoomId() != null) {
                String sql = "INSERT INTO Appointment (appointmentId, patientId, doctorId, roomId, date, time, status) VALUES (?, ?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, appt.getAppointmentId());
                    ps.setString(2, appt.getPatientId());
                    ps.setString(3, appt.getDoctorId());
                    ps.setString(4, appt.getRoomId());
                    ps.setDate(5, appt.getDate());
                    ps.setTime(6, appt.getTime());
                    ps.setString(7, appt.getStatus());
                    return ps.executeUpdate() > 0;
                }
            } else {
                String sql = "INSERT INTO Appointment (appointmentId, patientId, doctorId, date, time, status) VALUES (?, ?, ?, ?, ?, ?)";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setString(1, appt.getAppointmentId());
                    ps.setString(2, appt.getPatientId());
                    ps.setString(3, appt.getDoctorId());
                    ps.setDate(4, appt.getDate());
                    ps.setTime(5, appt.getTime());
                    ps.setString(6, appt.getStatus());
                    return ps.executeUpdate() > 0;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAppointment(Appointment appt) {
        String sql = "UPDATE Appointment SET patientId=?, doctorId=?, roomId=?, date=?, time=?, status=? WHERE appointmentId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, appt.getPatientId());
            ps.setString(2, appt.getDoctorId());
            ps.setString(3, appt.getRoomId());
            ps.setDate(4, appt.getDate());
            ps.setTime(5, appt.getTime());
            ps.setString(6, appt.getStatus());
            ps.setString(7, appt.getAppointmentId());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateAppointmentStatus(String appointmentId, String status) {
        String sql = "UPDATE Appointment SET status=? WHERE appointmentId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, appointmentId);

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteAppointment(String appointmentId) {
        String sql = "DELETE FROM Appointment WHERE appointmentId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, appointmentId);

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
