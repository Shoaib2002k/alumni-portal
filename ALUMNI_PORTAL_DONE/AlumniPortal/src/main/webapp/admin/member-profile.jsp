<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.alumni.model.AlumniProfile" %>
<%
    AlumniProfile p = (AlumniProfile) request.getAttribute("profile");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Member Profile | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .profile-photo{width:130px;height:130px;border-radius:18px;object-fit:cover;
          border:3px solid #f0ece6;box-shadow:0 8px 24px rgba(0,0,0,0.1);}
        .profile-photo-placeholder{width:130px;height:130px;border-radius:18px;
          background:linear-gradient(135deg,#f0ece6,#e0d9d0);
          display:flex;align-items:center;justify-content:center;font-size:52px;color:#c5b9ae;
          border:3px solid #f0ece6;}
        .section-label{font-size:11px;font-weight:700;color:#aaa;text-transform:uppercase;
          letter-spacing:1px;padding-bottom:8px;border-bottom:1px solid #f0ece6;margin-bottom:16px;}
        .detail-grid{display:grid;grid-template-columns:1fr 1fr;gap:16px;margin-bottom:24px;}
        .detail-item label{font-size:11px;font-weight:700;color:#bbb;text-transform:uppercase;
          letter-spacing:.5px;display:block;margin-bottom:4px;}
        .detail-item p{font-size:14px;font-weight:600;color:#1a1a1a;margin:0;}
        .detail-item p.empty{color:#ccc;font-weight:400;font-style:italic;}
        @media(max-width:600px){.detail-grid{grid-template-columns:1fr;}}
    </style>
</head>
<body>
<%@ include file="admin-sidebar.jspf" %>
<div class="main-wrap">
    <div class="admin-topbar">
        <div class="topbar-title">Member Profile</div>
        <div class="topbar-right">
            <a href="<%=request.getContextPath()%>/admin/members" class="btn-secondary-custom" style="font-size:12px;padding:7px 14px;">
                <i class="bi bi-arrow-left"></i> Back to Members
            </a>
        </div>
    </div>
    <div class="admin-hero">
        <div style="position:relative;z-index:2;">
            <h2>Alumni Profile</h2>
            <p>Full profile details for this alumni member.</p>
        </div>
    </div>
    <div class="content-area">
        <% if (p == null) { %>
        <div class="admin-card">
            <div class="admin-card-body">
                <div class="empty-state">
                    <i class="bi bi-person-x"></i>
                    <p>Profile not found or no longer exists.</p>
                </div>
            </div>
        </div>
        <% } else {
            String pPhoto   = p.getPhotoPath() != null && !p.getPhotoPath().trim().isEmpty() ? p.getPhotoPath() : "";
            String pName    = p.getUser() != null && p.getUser().getFullName() != null ? p.getUser().getFullName() : "-";
            String pEmail   = p.getUser() != null && p.getUser().getEmail()    != null ? p.getUser().getEmail()    : "-";
            String pPhone   = p.getUser() != null && p.getUser().getPhone()    != null ? p.getUser().getPhone()    : "-";
            String pPlace   = p.getUser() != null && p.getUser().getPlace()    != null ? p.getUser().getPlace()    : "-";
            String pStatus  = p.getUser() != null && p.getUser().getStatus()   != null ? p.getUser().getStatus()   : "-";
            String pVerified= p.getUser() != null && p.getUser().getEmailVerified() != null ? p.getUser().getEmailVerified() : "-";
            String pBatch   = p.getBatchId()            != null ? String.valueOf(p.getBatchId())             : "-";
            String pDept    = p.getDeptId()             != null ? String.valueOf(p.getDeptId())              : "-";
            String pRegNo   = p.getUniversityRegNo()    != null ? p.getUniversityRegNo()    : "-";
            String pCompany = p.getCurrentCompany()     != null ? p.getCurrentCompany()     : "-";
            String pRole    = p.getCurrentRole()        != null ? p.getCurrentRole()        : "-";
            String pExp     = p.getExperienceYears()    != null ? p.getExperienceYears() + " year(s)" : "-";
            String pSpec    = p.getSpecialization()     != null ? p.getSpecialization()     : "-";
            String pCoCnt   = p.getCompanyChangesCount()!= null ? String.valueOf(p.getCompanyChangesCount()) : "-";
            String pCoNames = p.getCompanyChangesNames()!= null ? p.getCompanyChangesNames() : "-";
        %>

        <!-- Profile header card -->
        <div class="admin-card" style="margin-bottom:20px;">
            <div class="admin-card-body">
                <div style="display:flex;align-items:center;gap:24px;flex-wrap:wrap;">
                    <% if (!pPhoto.isEmpty()) { %>
                    <img src="<%=request.getContextPath()%>/<%=pPhoto%>" class="profile-photo" alt="<%= pName %>"
                         onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                    <div class="profile-photo-placeholder" style="display:none;"><i class="bi bi-person"></i></div>
                    <% } else { %>
                    <div class="profile-photo-placeholder"><i class="bi bi-person"></i></div>
                    <% } %>
                    <div>
                        <div style="font-family:'Playfair Display',serif;font-size:26px;font-weight:800;color:#1a1a1a;margin-bottom:4px;"><%= pName %></div>
                        <div style="font-size:14px;color:#666;margin-bottom:8px;"><%= pRole %> <% if (!pCompany.equals("-")) { %> at <%= pCompany %><% } %></div>
                        <div style="display:flex;gap:8px;flex-wrap:wrap;">
                            <%
                                String sBadge = "APPROVED".equals(pStatus) ? "badge-approved" : "REJECTED".equals(pStatus) ? "badge-rejected" : "badge-pending";
                                String sLabel = "APPROVED".equals(pStatus) ? "Approved" : "REJECTED".equals(pStatus) ? "Rejected" : "Pending";
                            %>
                            <span class="<%= sBadge %>"><%= sLabel %></span>
                            <% if ("Y".equals(pVerified)) { %>
                            <span class="badge-approved"><i class="bi bi-check-circle me-1"></i>Email Verified</span>
                            <% } %>
                            <% if (!pBatch.equals("-")) { %><span class="badge-pending">Batch <%= pBatch %></span><% } %>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Detail cards -->
        <div class="row g-3">
            <div class="col-lg-6">
                <div class="admin-card" style="height:100%;">
                    <div class="admin-card-header"><h4>Personal Information</h4></div>
                    <div class="admin-card-body">
                        <div class="detail-grid">
                            <div class="detail-item"><label>Full Name</label><p><%= pName %></p></div>
                            <div class="detail-item"><label>Email</label><p><%= pEmail %></p></div>
                            <div class="detail-item"><label>Phone</label><p><%= pPhone %></p></div>
                            <div class="detail-item"><label>Place</label><p><%= pPlace %></p></div>
                            <div class="detail-item"><label>Status</label>
                                <p><span class="<%= sBadge %>"><%= sLabel %></span></p>
                            </div>
                            <div class="detail-item"><label>Email Verified</label>
                                <p><span class="<%= "Y".equals(pVerified) ? "badge-approved" : "badge-rejected" %>"><%= "Y".equals(pVerified) ? "Yes" : "No" %></span></p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-lg-6">
                <div class="admin-card" style="height:100%;">
                    <div class="admin-card-header"><h4>Academic Details</h4></div>
                    <div class="admin-card-body">
                        <div class="detail-grid">
                            <div class="detail-item"><label>Batch</label><p><%= pBatch.equals("-") ? "-" : "Batch " + pBatch %></p></div>
                            <div class="detail-item"><label>Department</label><p><%= pDept %></p></div>
                            <div class="detail-item"><label>Reg Number</label><p><%= pRegNo %></p></div>
                            <div class="detail-item"><label>Specialization</label><p><%= pSpec %></p></div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col-12">
                <div class="admin-card">
                    <div class="admin-card-header"><h4>Professional Details</h4></div>
                    <div class="admin-card-body">
                        <div class="detail-grid">
                            <div class="detail-item"><label>Current Company</label><p><%= pCompany %></p></div>
                            <div class="detail-item"><label>Current Role</label><p><%= pRole %></p></div>
                            <div class="detail-item"><label>Experience</label><p><%= pExp %></p></div>
                            <div class="detail-item"><label>Company Changes</label><p><%= pCoCnt %></p></div>
                        </div>
                        <div class="section-label">Previous Companies</div>
                        <p style="font-size:14px;color:#555;white-space:pre-wrap;margin:0;"><%= pCoNames.equals("-") ? "None recorded" : pCoNames %></p>
                    </div>
                </div>
            </div>
        </div>
        <% } %>
    </div>
</div>
</body>
</html>
