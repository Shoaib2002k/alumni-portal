package com.alumni.dao;

import com.alumni.model.Gallery;
import com.alumni.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

public class GalleryDao {

    public void addImage(Gallery gallery) throws Exception {
        String sql = "INSERT INTO gallery (title, image_path, uploaded_by, uploaded_at) " +
                     "VALUES (?, ?, ?, SYSTIMESTAMP)";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, gallery.getTitle());
            ps.setString(2, gallery.getImagePath());
            ps.setObject(3, gallery.getUploadedBy());

            ps.executeUpdate();
        }
    }

    public List<Gallery> getAllImages() throws Exception {
        List<Gallery> list = new ArrayList<>();

        String sql = "SELECT image_id, title, image_path, uploaded_by, uploaded_at " +
                     "FROM gallery ORDER BY image_id DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Gallery g = new Gallery();
                g.setImageId(rs.getInt("image_id"));
                g.setTitle(rs.getString("title"));
                g.setImagePath(rs.getString("image_path"));

                Object uploadedByObj = rs.getObject("uploaded_by");
                if (uploadedByObj != null) {
                    g.setUploadedBy(rs.getInt("uploaded_by"));
                } else {
                    g.setUploadedBy(null);
                }

                g.setUploadedAt(rs.getTimestamp("uploaded_at"));
                list.add(g);
            }
        }

        return list;
    }

    public boolean deleteGallery(int imageId) {
        boolean status = false;

        String sql = "DELETE FROM gallery WHERE image_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, imageId);

            status = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }
}