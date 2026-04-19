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

    public Appointment getAppointmentByIdAndDoctorId(String appointmentId, String doctorId) {
        String sql = "SELECT * FROM Appointment WHERE appointmentId = ? AND doctorId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, appointmentId);
            ps.setString(2, doctorId);
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

    public boolean isAppointmentOwnedByDoctor(String appointmentId, String doctorId) {
        return getAppointmentByIdAndDoctorId(appointmentId, doctorId) != null;
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

    /**
     * Returns appointments for a patient with doctor name and department name
     * resolved via JOIN. Used by patient-facing controllers only.
     */
    public List<Appointment> getAppointmentsByPatientIdEnriched(String patientId) {
        List<Appointment> list = new ArrayList<>();
        String sql =
            "SELECT a.*, u.fullName AS doctorName, dep.departmentName " +
            "FROM Appointment a " +
            "JOIN Doctor d ON a.doctorId = d.doctorId " +
            "JOIN user u ON d.userId = u.userId " +
            "LEFT JOIN Department dep ON d.departmentId = dep.departmentId " +
            "WHERE a.patientId = ? " +
            "ORDER BY a.date DESC, a.time DESC";

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
                    appt.setDoctorName(rs.getString("doctorName"));
                    appt.setDepartmentName(rs.getString("departmentName"));
                    list.add(appt);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /** Doctor-facing: resolves patient name via LEFT JOIN to Patient + User. */
    public List<Appointment> getAppointmentsByDoctorIdWithPatientName(String doctorId) {
        List<Appointment> list = new ArrayList<>();
        String sql =
            "SELECT a.*, u.fullName AS patientName " +
            "FROM Appointment a " +
            "LEFT JOIN Patient p ON a.patientId = p.patientId " +
            "LEFT JOIN user u ON p.userId = u.userId " +
            "WHERE a.doctorId = ? " +
            "ORDER BY a.date DESC, a.time DESC";
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
                    appt.setPatientName(rs.getString("patientName"));
                    list.add(appt);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> getPendingAppointmentsByDoctorIdFromDate(String doctorId, java.sql.Date fromDate) {
        List<Appointment> list = new ArrayList<>();
        String sql =
            "SELECT a.*, u.fullName AS patientName " +
            "FROM Appointment a " +
            "LEFT JOIN Patient p ON a.patientId = p.patientId " +
            "LEFT JOIN user u ON p.userId = u.userId " +
            "WHERE a.doctorId = ? AND a.status = 'PENDING' AND a.date >= ? " +
            "ORDER BY a.date ASC, a.time ASC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, doctorId);
            ps.setDate(2, fromDate);

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
                    appt.setPatientName(rs.getString("patientName"));
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

    public int updateAppointmentStatusForDoctor(String appointmentId, String doctorId, String status) {
        String sql = "UPDATE Appointment SET status=? WHERE appointmentId=? AND doctorId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);
            ps.setString(2, appointmentId);
            ps.setString(3, doctorId);

            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int updateAppointmentStatusForDoctorAndCurrentStatus(String appointmentId, String doctorId, String currentStatus, String newStatus) {
        String sql = "UPDATE Appointment SET status=? WHERE appointmentId=? AND doctorId=? AND status=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setString(2, appointmentId);
            ps.setString(3, doctorId);
            ps.setString(4, currentStatus);

            return ps.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return 0;
    }

    /** Manager-facing: all appointments enriched with doctor name and patient name. */
    public List<Appointment> getAllAppointmentsEnrichedForManager() {
        List<Appointment> list = new ArrayList<>();
        String sql =
            "SELECT a.*, " +
            "  du.fullName AS doctorName, " +
            "  pu.fullName AS patientName " +
            "FROM Appointment a " +
            "LEFT JOIN Doctor d ON a.doctorId = d.doctorId " +
            "LEFT JOIN user du ON d.userId = du.userId " +
            "LEFT JOIN Patient p ON a.patientId = p.patientId " +
            "LEFT JOIN user pu ON p.userId = pu.userId " +
            "ORDER BY a.date DESC, a.time DESC";

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
                appt.setDoctorName(rs.getString("doctorName"));
                appt.setPatientName(rs.getString("patientName"));
                list.add(appt);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
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

    public Appointment getAppointmentByIdEnriched(String appointmentId) {
        String sql =
            "SELECT a.*, du.fullName AS doctorName, pu.fullName AS patientName " +
            "FROM Appointment a " +
            "LEFT JOIN Doctor doc ON a.doctorId = doc.doctorId " +
            "LEFT JOIN user du ON doc.userId = du.userId " +
            "LEFT JOIN Patient pat ON a.patientId = pat.patientId " +
            "LEFT JOIN user pu ON pat.userId = pu.userId " +
            "WHERE a.appointmentId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, appointmentId);
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
                    appt.setDoctorName(rs.getString("doctorName"));
                    appt.setPatientName(rs.getString("patientName"));
                    return appt;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
}
