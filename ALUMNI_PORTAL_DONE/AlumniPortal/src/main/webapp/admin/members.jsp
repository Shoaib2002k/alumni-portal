<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.alumni.model.User" %>
<%
    List<User> members = (List<User>) request.getAttribute("members");
    String keyword = request.getAttribute("keyword") != null ? (String) request.getAttribute("keyword") : "";
    String status  = request.getAttribute("status")  != null ? (String) request.getAttribute("status")  : "";
    int total = (members != null) ? members.size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Members | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<%@ include file="admin-sidebar.jspf" %>
<div class="main-wrap">
    <div class="admin-topbar">
        <div class="topbar-title">Members</div>
        <div class="topbar-right"><i class="bi bi-people"></i> <%= total %> records</div>
    </div>
    <div class="admin-hero">
        <div style="position:relative;z-index:2;">
            <h2>All Alumni Members</h2>
            <p>Search, view profiles, and manage all registered alumni.</p>
        </div>
    </div>
    <div class="content-area">
        <!-- Search form -->
        <div class="admin-card">
            <div class="admin-card-body">
                <form method="get" action="<%=request.getContextPath()%>/admin/members">
                    <div style="display:flex;gap:12px;flex-wrap:wrap;align-items:flex-end;">
                        <div style="flex:1;min-width:200px;">
                            <label class="form-label-custom">Search</label>
                            <div style="position:relative;">
                                <i class="bi bi-search" style="position:absolute;left:12px;top:50%;transform:translateY(-50%);color:#bbb;font-size:14px;"></i>
                                <input type="text" name="keyword" class="form-ctrl" style="padding-left:36px;"
                                       placeholder="Name or email..." value="<%= keyword %>">
                            </div>
                        </div>
                        <div style="min-width:160px;">
                            <label class="form-label-custom">Status</label>
                            <select name="status" class="form-ctrl">
                                <option value="">All Status</option>
                                <option value="PENDING_APPROVAL" <%= "PENDING_APPROVAL".equals(status) ? "selected" : "" %>>Pending</option>
                                <option value="APPROVED" <%= "APPROVED".equals(status) ? "selected" : "" %>>Approved</option>
                                <option value="REJECTED" <%= "REJECTED".equals(status) ? "selected" : "" %>>Rejected</option>
                            </select>
                        </div>
                        <div style="display:flex;gap:8px;">
                            <button type="submit" class="btn-primary-custom"><i class="bi bi-search"></i> Search</button>
                            <a href="<%=request.getContextPath()%>/admin/members" class="btn-secondary-custom"><i class="bi bi-arrow-clockwise"></i> Reset</a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Table -->
        <div class="admin-card">
            <div class="admin-card-header">
                <h4><i class="bi bi-people-fill me-2" style="color:#7a0f1b;"></i>Alumni List</h4>
                <span style="font-size:13px;color:#888;"><%= total %> result<%= total != 1 ? "s" : "" %></span>
            </div>
            <div style="overflow-x:auto;">
            <% if (members == null || members.isEmpty()) { %>
            <div class="empty-state">
                <i class="bi bi-people"></i>
                <p>No alumni found matching your search.</p>
            </div>
            <% } else { %>
            <table class="admin-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Place</th>
                        <th>Verified</th>
                        <th>Status</th>
                        <th>Profile</th>
                        <th>Delete</th>
                    </tr>
                </thead>
                <tbody>
                <% int rn = 1; for (User mu : members) { %>
                <tr>
                    <td style="color:#aaa;"><%= rn++ %></td>
                    <td><strong><%= mu.getFullName() %></strong></td>
                    <td style="color:#666;font-size:12px;"><%= mu.getEmail() %></td>
                    <td><%= mu.getPhone() != null ? mu.getPhone() : "-" %></td>
                    <td><%= mu.getPlace() != null ? mu.getPlace() : "-" %></td>
                    <td>
                        <% if ("Y".equals(mu.getEmailVerified())) { %>
                        <span class="badge-approved">Yes</span>
                        <% } else { %>
                        <span class="badge-rejected">No</span>
                        <% } %>
                    </td>
                    <td>
                        <%
                            String st = mu.getStatus() != null ? mu.getStatus() : "";
                            String badgeCls = "APPROVED".equals(st) ? "badge-approved" : "REJECTED".equals(st) ? "badge-rejected" : "badge-pending";
                            String stLabel  = "APPROVED".equals(st) ? "Approved" : "REJECTED".equals(st) ? "Rejected" : "Pending";
                        %>
                        <span class="<%= badgeCls %>"><%= stLabel %></span>
                    </td>
                    <td>
                        <a class="btn-success-custom"
                           href="<%=request.getContextPath()%>/admin/member-profile?userId=<%= mu.getUserId() %>">
                            <i class="bi bi-eye"></i> View
                        </a>
                    </td>
                    <td>
                        <a href="<%=request.getContextPath()%>/admin/delete-member?id=<%= mu.getUserId() %>"
                           onclick="return confirm('Delete this member permanently?')"
                           class="btn-danger-custom">
                            <i class="bi bi-trash"></i> Delete
                        </a>
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
