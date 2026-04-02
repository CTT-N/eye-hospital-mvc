package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import model.Patient;
import util.DBConnection;

public class PatientDAO {
    public void insertPatient(Patient patient) {

        try {
            Connection conn = DBConnection.getConnection();

            String sql = "INSERT INTO Patient (patientId, userId) VALUES (?, ?)";
            
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, patient.getPatientId());
            ps.setString(2, patient.getUserId());

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
