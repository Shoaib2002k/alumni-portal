<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.alumni.model.User" %>
<%
    response.setHeader("Cache-Control","no-cache, no-store, must-revalidate");
    response.setHeader("Pragma","no-cache");
    response.setDateHeader("Expires", 0);
    User u = (User) session.getAttribute("user");
    if (u == null || !"ADMIN".equals(u.getRole())) {
        response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .quick-card{background:#fff;border-radius:16px;padding:24px;
          box-shadow:0 4px 20px rgba(0,0,0,0.06);border:1px solid rgba(0,0,0,0.04);
          text-decoration:none;color:inherit;display:block;transition:all .3s ease;}
        .quick-card:hover{transform:translateY(-4px);box-shadow:0 14px 36px rgba(0,0,0,0.12);color:inherit;}
        .qc-icon{width:50px;height:50px;border-radius:13px;display:flex;align-items:center;
          justify-content:center;font-size:22px;margin-bottom:14px;}
        .qc-icon.red{background:#fdf0f1;color:#7a0f1b;}
        .qc-icon.green{background:#eef5f2;color:#0b4b3b;}
        .qc-icon.amber{background:#fffbeb;color:#b45309;}
        .qc-icon.blue{background:#eff6ff;color:#1d4ed8;}
        .qc-icon.purple{background:#f5f3ff;color:#6d28d9;}
        .quick-card h5{font-family:'Playfair Display',serif;font-size:16px;font-weight:700;
          color:#1a1a1a;margin:0 0 5px;}
        .quick-card p{font-size:12px;color:#888;margin:0;}
        .qc-arrow{float:right;font-size:16px;color:#ccc;margin-top:-36px;}
        .welcome-hero{background:linear-gradient(135deg,#7a0f1b 0%,#5a0a13 50%,#0b4b3b 100%);
          padding:32px 28px;color:#fff;position:relative;overflow:hidden;}
        .welcome-hero::before{content:'';position:absolute;top:-50px;right:-50px;width:240px;
          height:240px;border-radius:50%;background:rgba(255,213,79,0.06);}
        .welcome-hero h2{font-family:'Playfair Display',serif;font-size:24px;font-weight:800;margin:0 0 4px;}
        .welcome-hero p{font-size:13px;opacity:.72;margin:0;}
        .info-banner{background:#fffbeb;border:1px solid #fde68a;border-radius:12px;
          padding:14px 18px;display:flex;align-items:flex-start;gap:10px;
          font-size:13px;color:#78350f;margin-bottom:22px;}
        .info-banner i{color:#d97706;font-size:17px;flex-shrink:0;margin-top:1px;}
    </style>
</head>
<body>
<%@ include file="admin-sidebar.jspf" %>
<div class="main-wrap">
    <div class="admin-topbar">
        <div class="topbar-title">Dashboard</div>
        <div class="topbar-right">
            <i class="bi bi-person-circle"></i> <%= u.getFullName() %>
        </div>
    </div>

    <div class="welcome-hero">
        <div style="position:relative;z-index:2;">
            <h2>Welcome, <%= u.getFullName() %></h2>
            <p>Administrator &bull; <%= u.getEmail() %></p>
        </div>
    </div>

    <div class="content-area">
        <div class="info-banner">
            <i class="bi bi-info-circle-fill"></i>
            <div>Use the sidebar or the cards below to manage the alumni portal.</div>
        </div>

        <div class="row g-3">
            <div class="col-lg-4 col-md-6">
                <a class="quick-card" href="<%=request.getContextPath()%>/admin/pending-approvals">
                    <div class="qc-icon red"><i class="bi bi-person-check-fill"></i></div>
                    <h5>Pending Approvals</h5>
                    <p>Review and approve alumni registration requests.</p>
                    <span class="qc-arrow"><i class="bi bi-arrow-right"></i></span>
                </a>
            </div>
            <div class="col-lg-4 col-md-6">
                <a class="quick-card" href="<%=request.getContextPath()%>/admin/members">
                    <div class="qc-icon green"><i class="bi bi-people-fill"></i></div>
                    <h5>Members</h5>
                    <p>View, search, and manage all alumni members.</p>
                    <span class="qc-arrow"><i class="bi bi-arrow-right"></i></span>
                </a>
            </div>
            <div class="col-lg-4 col-md-6">
                <a class="quick-card" href="<%=request.getContextPath()%>/admin/events">
                    <div class="qc-icon amber"><i class="bi bi-calendar-event-fill"></i></div>
                    <h5>Events</h5>
                    <p>Add and manage alumni events and gatherings.</p>
                    <span class="qc-arrow"><i class="bi bi-arrow-right"></i></span>
                </a>
            </div>
            <div class="col-lg-4 col-md-6">
                <a class="quick-card" href="<%=request.getContextPath()%>/admin/gallery">
                    <div class="qc-icon blue"><i class="bi bi-images"></i></div>
                    <h5>Gallery</h5>
                    <p>Upload and manage photo gallery images.</p>
                    <span class="qc-arrow"><i class="bi bi-arrow-right"></i></span>
                </a>
            </div>
            <div class="col-lg-4 col-md-6">
                <a class="quick-card" href="<%=request.getContextPath()%>/admin/site-settings">
                    <div class="qc-icon purple"><i class="bi bi-gear-fill"></i></div>
                    <h5>Site Settings</h5>
                    <p>Configure site name, colors, logo and about text.</p>
                    <span class="qc-arrow"><i class="bi bi-arrow-right"></i></span>
                </a>
            </div>
            <div class="col-lg-4 col-md-6">
                <a class="quick-card" href="<%=request.getContextPath()%>/home" target="_blank">
                    <div class="qc-icon green"><i class="bi bi-box-arrow-up-right"></i></div>
                    <h5>View Portal</h5>
                    <p>Open the public alumni portal in a new tab.</p>
                    <span class="qc-arrow"><i class="bi bi-arrow-right"></i></span>
                </a>
            </div>
        </div>
    </div>
</div>
</body>
</html>
