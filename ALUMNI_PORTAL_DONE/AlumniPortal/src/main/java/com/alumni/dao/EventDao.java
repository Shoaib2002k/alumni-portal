package com.alumni.dao;
import java.sql.Connection;
import java.sql.PreparedStatement;

import com.alumni.model.Event;
import com.alumni.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;
import com.alumni.util.DBConnection;
public class EventDao {

	public void addEvent(Event event) throws Exception {
	    String sql = "INSERT INTO events (title, description, event_date, location, image_path, created_by, created_at) " +
	                 "VALUES (?, ?, ?, ?, ?, ?, SYSTIMESTAMP)";

	    try (Connection con = DBConnection.getConnection();
	         PreparedStatement ps = con.prepareStatement(sql)) {

	        ps.setString(1, event.getTitle());
	        ps.setString(2, event.getDescription());
	        ps.setDate(3, event.getEventDate());
	        ps.setString(4, event.getLocation());
	        ps.setString(5, event.getImagePath());
	        ps.setObject(6, event.getCreatedBy());

	        ps.executeUpdate();
	    }
	}

    public List<Event> getAllEvents() throws Exception {
        List<Event> list = new ArrayList<>();

        String sql = "SELECT event_id, title, description, event_date, location, image_path, created_by, created_at " +
                "FROM events ORDER BY event_date DESC";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

        	while (rs.next()) {
        	    Event e = new Event();
        	    e.setEventId(rs.getInt("event_id"));
        	    e.setTitle(rs.getString("title"));
        	    e.setDescription(rs.getString("description"));
        	    e.setEventDate(rs.getDate("event_date"));
        	    e.setLocation(rs.getString("location"));
        	    e.setImagePath(rs.getString("image_path"));
        	    e.setCreatedBy(rs.getInt("created_by"));
        	    e.setCreatedAt(rs.getTimestamp("created_at"));
        	    list.add(e);
        	}
        }

        return list;
    }
    
    public boolean deleteEvent(int eventId) {
        boolean rowDeleted = false;
        String sql = "DELETE FROM events WHERE event_id = ?";

        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setInt(1, eventId);
            rowDeleted = ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }

        return rowDeleted;
    }
}