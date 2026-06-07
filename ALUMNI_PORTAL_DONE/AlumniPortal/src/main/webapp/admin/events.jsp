<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.alumni.model.Event" %>
<%
    List<Event> events = (List<Event>) request.getAttribute("events");
    int evCount = (events != null) ? events.size() : 0;
    String successMsg = request.getAttribute("success") != null ? (String) request.getAttribute("success") : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Events | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .event-img-thumb{width:70px;height:52px;object-fit:cover;border-radius:8px;border:1px solid #f0ece6;}
        .event-img-placeholder{width:70px;height:52px;border-radius:8px;background:#f5f0eb;
          display:flex;align-items:center;justify-content:center;font-size:20px;color:#c5b9ae;}
    </style>
</head>
<body>
<%@ include file="admin-sidebar.jspf" %>
<div class="main-wrap">
    <div class="admin-topbar">
        <div class="topbar-title">Events</div>
        <div class="topbar-right"><i class="bi bi-calendar-event"></i> <%= evCount %> events</div>
    </div>
    <div class="admin-hero">
        <div style="position:relative;z-index:2;">
            <h2>Manage Events</h2>
            <p>Add new events and manage existing alumni events.</p>
        </div>
    </div>
    <div class="content-area">
        <% if (!successMsg.isEmpty()) { %>
        <div class="alert-success-custom"><i class="bi bi-check-circle-fill"></i><%= successMsg %></div>
        <% } %>

        <!-- ADD EVENT FORM -->
        <div class="admin-card">
            <div class="admin-card-header">
                <h4><i class="bi bi-plus-circle-fill me-2" style="color:#7a0f1b;"></i>Add New Event</h4>
            </div>
            <div class="admin-card-body">
                <form method="post" action="<%=request.getContextPath()%>/admin/events" enctype="multipart/form-data">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label-custom">Title *</label>
                            <input type="text" name="title" class="form-ctrl" placeholder="Event title" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Event Date *</label>
                            <input type="date" name="eventDate" class="form-ctrl" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Location</label>
                            <input type="text" name="location" class="form-ctrl" placeholder="Venue or city">
                        </div>
                        <div class="col-md-6">
                            <label class="form-label-custom">Event Image</label>
                            <input type="file" name="image" class="form-ctrl" accept="image/*">
                        </div>
                        <div class="col-12">
                            <label class="form-label-custom">Description</label>
                            <textarea name="description" class="form-ctrl" rows="3" placeholder="Describe the event..."></textarea>
                        </div>
                    </div>
                    <div style="margin-top:18px;display:flex;gap:10px;">
                        <button type="submit" class="btn-primary-custom"><i class="bi bi-plus-lg"></i> Add Event</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- EVENTS TABLE -->
        <div class="admin-card">
            <div class="admin-card-header">
                <h4><i class="bi bi-calendar-range me-2" style="color:#7a0f1b;"></i>All Events</h4>
                <span style="font-size:13px;color:#888;"><%= evCount %> event<%= evCount != 1 ? "s" : "" %></span>
            </div>
            <div style="overflow-x:auto;">
            <% if (events == null || events.isEmpty()) { %>
            <div class="empty-state">
                <i class="bi bi-calendar-x"></i>
                <p>No events added yet. Add your first event above.</p>
            </div>
            <% } else { %>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Title</th>
                        <th>Date</th>
                        <th>Location</th>
                        <th>Description</th>
                        <th>Delete</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Event ev : events) {
                    String evImg = ev.getImagePath() != null && !ev.getImagePath().trim().isEmpty() ? ev.getImagePath() : "";
                %>
                <tr>
                    <td>
                        <% if (!evImg.isEmpty()) { %>
                        <img src="<%=request.getContextPath()%>/<%=evImg%>" class="event-img-thumb" alt="Event"
                             onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                        <div class="event-img-placeholder" style="display:none;"><i class="bi bi-image"></i></div>
                        <% } else { %>
                        <div class="event-img-placeholder"><i class="bi bi-image"></i></div>
                        <% } %>
                    </td>
                    <td><strong><%= ev.getTitle() %></strong></td>
                    <td style="white-space:nowrap;color:#666;"><%= ev.getEventDate() %></td>
                    <td><%= ev.getLocation() != null ? ev.getLocation() : "-" %></td>
                    <td style="max-width:220px;font-size:12px;color:#777;">
                        <%= ev.getDescription() != null && ev.getDescription().length() > 80
                            ? ev.getDescription().substring(0, 80) + "..."
                            : (ev.getDescription() != null ? ev.getDescription() : "-") %>
                    </td>
                    <td>
                        <form method="post" action="<%=request.getContextPath()%>/admin/delete-event"
                              onsubmit="return confirm('Delete this event?');" style="margin:0;">
                            <input type="hidden" name="eventId" value="<%= ev.getEventId() %>">
                            <button type="submit" class="btn-danger-custom"><i class="bi bi-trash"></i> Delete</button>
                        </form>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
            <% } %>
            </div>
        </div>
    </div>
</div>
</body>
</html>
