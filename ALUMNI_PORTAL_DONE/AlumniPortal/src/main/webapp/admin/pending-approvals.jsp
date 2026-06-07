<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.alumni.model.User" %>
<%
    List<User> pendingUsers = (List<User>) request.getAttribute("pendingUsers");
    int total = (pendingUsers != null) ? pendingUsers.size() : 0;
    String success = request.getParameter("success");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Pending Approvals | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
</head>
<body>
<%@ include file="admin-sidebar.jspf" %>

<div class="main-wrap">
    <div class="admin-topbar">
        <div class="topbar-title">Pending Approvals</div>
        <div class="topbar-right"><i class="bi bi-person-check-fill"></i> <%= total %> pending</div>
    </div>

    <div class="admin-hero">
        <div style="position:relative;z-index:2;">
            <h2>Alumni Approval Requests</h2>
            <p>Approve or reject newly registered alumni users.</p>
        </div>
    </div>

    <div class="content-area">

        <% if ("1".equals(success)) { %>
        <div class="alert-success-custom">
            <i class="bi bi-check-circle-fill"></i> Action completed successfully.
        </div>
        <% } %>

        <div class="admin-card">
            <div class="admin-card-header">
                <h4><i class="bi bi-hourglass-split me-2" style="color:#7a0f1b;"></i>Pending Alumni List</h4>
                <span style="font-size:13px;color:#888;"><%= total %> result<%= total != 1 ? "s" : "" %></span>
            </div>

            <div style="overflow-x:auto;">
            <% if (pendingUsers == null || pendingUsers.isEmpty()) { %>
                <div class="empty-state">
                    <i class="bi bi-person-check"></i>
                    <p>No pending alumni approvals found.</p>
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
                            <th>Email Verified</th>
                            <th>Status</th>
                            <th>Approve</th>
                            <th>Reject</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% int rn = 1; for (User u : pendingUsers) { %>
                        <tr>
                            <td style="color:#aaa;"><%= rn++ %></td>
                            <td><strong><%= u.getFullName() %></strong></td>
                            <td style="color:#666;font-size:12px;"><%= u.getEmail() %></td>
                            <td><%= u.getPhone() != null ? u.getPhone() : "-" %></td>
                            <td><%= u.getPlace() != null ? u.getPlace() : "-" %></td>
                            <td>
                                <% if ("Y".equalsIgnoreCase(u.getEmailVerified())) { %>
                                    <span class="badge-approved">Yes</span>
                                <% } else { %>
                                    <span class="badge-rejected">No</span>
                                <% } %>
                            </td>
                            <td>
                                <span class="badge-pending">Pending</span>
                            </td>
                            <td>
                                <form method="post" action="<%=request.getContextPath()%>/admin/approval-action" style="margin:0;">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <input type="hidden" name="action" value="approve">
                                    <button type="submit" class="btn-success-custom"
                                            onclick="return confirm('Approve this alumni?')">
                                        <i class="bi bi-check-circle"></i> Approve
                                    </button>
                                </form>
                            </td>
                            <td>
                                <form method="post" action="<%=request.getContextPath()%>/admin/approval-action" style="margin:0;">
                                    <input type="hidden" name="userId" value="<%= u.getUserId() %>">
                                    <input type="hidden" name="action" value="reject">
                                    <input type="hidden" name="reason" value="Rejected by admin">
                                    <button type="submit" class="btn-danger-custom"
                                            onclick="return confirm('Reject this alumni?')">
                                        <i class="bi bi-x-circle"></i> Reject
                                    </button>
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