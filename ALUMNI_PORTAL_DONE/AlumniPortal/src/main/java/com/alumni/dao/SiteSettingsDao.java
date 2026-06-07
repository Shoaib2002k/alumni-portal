package com.alumni.dao;

import com.alumni.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.HashMap;
import java.util.Map;

public class SiteSettingsDao {

    public Map<String, String> getAllSettings() throws Exception {
        Map<String, String> map = new HashMap<>();

        String sql = "SELECT setting_key, setting_value FROM site_settings";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                map.put(rs.getString("setting_key"), rs.getString("setting_value"));
            }
        }

        return map;
    }

    public void saveSetting(String key, String value) throws Exception {
        String updateSql = "UPDATE site_settings SET setting_value = ?, updated_at = SYSTIMESTAMP WHERE setting_key = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(updateSql)) {

            ps.setString(1, value);
            ps.setString(2, key);

            int rows = ps.executeUpdate();

            if (rows == 0) {
                String insertSql = "INSERT INTO site_settings (setting_key, setting_value, updated_at) VALUES (?, ?, SYSTIMESTAMP)";
                try (PreparedStatement ps2 = con.prepareStatement(insertSql)) {
                    ps2.setString(1, key);
                    ps2.setString(2, value);
                    ps2.executeUpdate();
                }
            }
        }
    }
}