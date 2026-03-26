package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import model.EyeDiseaseInfo;
import util.DBConnection;

public class EyeDiseaseInfoDAO {

    public List<EyeDiseaseInfo> getAllInfos() {
        List<EyeDiseaseInfo> list = new ArrayList<>();
        String sql = "SELECT * FROM EyeDiseaseInfo";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                EyeDiseaseInfo info = new EyeDiseaseInfo();
                info.setInfoId(rs.getString("infoId"));
                info.setUserId(rs.getString("userId"));
                info.setDiseaseName(rs.getString("diseaseName"));
                info.setContent(rs.getString("content"));
                info.setDescription(rs.getString("description"));
                info.setCreatedBy(rs.getString("createdBy"));
                info.setLastUpdate(rs.getDate("lastUpdate"));
                list.add(info);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public EyeDiseaseInfo getInfoById(String id) {
        String sql = "SELECT * FROM EyeDiseaseInfo WHERE infoId = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    EyeDiseaseInfo info = new EyeDiseaseInfo();
                    info.setInfoId(rs.getString("infoId"));
                    info.setUserId(rs.getString("userId"));
                    info.setDiseaseName(rs.getString("diseaseName"));
                    info.setContent(rs.getString("content"));
                    info.setDescription(rs.getString("description"));
                    info.setCreatedBy(rs.getString("createdBy"));
                    info.setLastUpdate(rs.getDate("lastUpdate"));
                    return info;
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean insertInfo(EyeDiseaseInfo info) {
        String sql = "INSERT INTO EyeDiseaseInfo (infoId, userId, diseaseName, content, description, createdBy, lastUpdate) VALUES (?, ?, ?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, info.getInfoId());
            ps.setString(2, info.getUserId());
            ps.setString(3, info.getDiseaseName());
            ps.setString(4, info.getContent());
            ps.setString(5, info.getDescription());
            ps.setString(6, info.getCreatedBy());
            ps.setDate(7, info.getLastUpdate());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean updateInfo(EyeDiseaseInfo info) {
        String sql = "UPDATE EyeDiseaseInfo SET userId=?, diseaseName=?, content=?, description=?, createdBy=?, lastUpdate=? WHERE infoId=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, info.getUserId());
            ps.setString(2, info.getDiseaseName());
            ps.setString(3, info.getContent());
            ps.setString(4, info.getDescription());
            ps.setString(5, info.getCreatedBy());
            ps.setDate(6, info.getLastUpdate());
            ps.setString(7, info.getInfoId());

            int rows = ps.executeUpdate();
            return rows > 0;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }

    public boolean deleteInfo(String id) {
        String sql = "DELETE FROM EyeDiseaseInfo WHERE infoId=?";

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
