<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.alumni.model.User" %>
<%
    User staffUser = (User) session.getAttribute("staffUser");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Dashboard | Staff Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --brand-maroon: #7a0f1b; --brand-green: #0b4b3b; --sidebar-w: 240px; }
        body { font-family: 'DM Sans', sans-serif; background: #f4f2ef; margin: 0; }

        /* Sidebar - same as members.jsp */
        .sidebar {
            position: fixed; top: 0; left: 0;
            width: var(--sidebar-w); height: 100vh;
            background: linear-gradient(180deg, var(--brand-green) 0%, #073327 100%);
            display: flex; flex-direction: column; z-index: 200; overflow-y: auto;
        }
        .sidebar-brand { padding: 24px 20px 20px; border-bottom: 1px solid rgba(255,255,255,0.1); }
        .sidebar-brand .logo-icon {
            width: 44px; height: 44px; background: rgba(255,255,255,0.12);
            border-radius: 10px; display: flex; align-items: center;
            justify-content: center; font-size: 22px; color: #ffd54f; margin-bottom: 10px;
        }
        .sidebar-brand .name { font-family: 'Playfair Display', serif; font-size: 15px; font-weight: 700; color: #fff; line-height: 1.2; }
        .sidebar-brand .sub  { font-size: 11px; color: rgba(255,255,255,0.5); text-transform: uppercase; letter-spacing: 1px; }
        .sidebar-nav { padding: 16px 12px; flex: 1; }
        .sidebar-nav .nav-label { font-size: 10px; font-weight: 700; color: rgba(255,255,255,0.4); text-transform: uppercase; letter-spacing: 1.5px; padding: 0 8px; margin: 16px 0 6px; }
        .nav-link-item { display: flex; align-items: center; gap: 10px; padding: 10px 12px; border-radius: 10px; color: rgba(255,255,255,0.75); text-decoration: none; font-size: 14px; font-weight: 500; transition: all 0.2s; margin-bottom: 2px; }
        .nav-link-item i { font-size: 17px; width: 20px; }
        .nav-link-item:hover, .nav-link-item.active { background: rgba(255,255,255,0.12); color: #fff; }
        .nav-link-item.active { background: rgba(255,213,79,0.15); color: #ffd54f; }
        .sidebar-footer { padding: 16px 12px; border-top: 1px solid rgba(255,255,255,0.1); }
        .staff-info { display: flex; align-items: center; gap: 10px; padding: 10px 12px; margin-bottom: 8px; }
        .staff-avatar { width: 36px; height: 36px; background: rgba(255,213,79,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #ffd54f; font-size: 16px; flex-shrink: 0; }
        .staff-name { font-size: 13px; font-weight: 600; color: #fff; }
        .staff-role { font-size: 11px; color: rgba(255,255,255,0.5); }

        /* Main */
        .main-wrap { margin-left: var(--sidebar-w); min-height: 100vh; }
        .topbar { background: #fff; border-bottom: 1px solid #e8e3dd; padding: 0 28px; height: 64px; display: flex; align-items: center; justify-content: space-between; position: sticky; top: 0; z-index: 100; box-shadow: 0 2px 12px rgba(0,0,0,0.05); }
        .topbar-title { font-family: 'Playfair Display', serif; font-size: 20px; font-weight: 700; color: #1a1a1a; }

        /* Welcome hero */
        .welcome-hero {
            background: linear-gradient(135deg, var(--brand-maroon) 0%, #5a0a13 50%, var(--brand-green) 100%);
            padding: 40px 28px; color: #fff; position: relative; overflow: hidden;
        }
        .welcome-hero::before { content: ''; position: absolute; top: -60px; right: -60px; width: 280px; height: 280px; border-radius: 50%; background: rgba(255,213,79,0.06); }
        .welcome-hero h2 { font-family: 'Playfair Display', serif; font-size: 28px; font-weight: 800; margin-bottom: 6px; }
        .welcome-hero p { font-size: 14px; opacity: 0.75; margin: 0; }

        /* Content */
        .content-area { padding: 28px; }

        /* Quick action cards */
        .quick-card {
            background: #fff; border-radius: 16px; padding: 24px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            border: 1px solid rgba(0,0,0,0.04);
            text-decoration: none; color: inherit;
            display: block; transition: all 0.3s ease;
        }
        .quick-card:hover { transform: translateY(-4px); box-shadow: 0 12px 36px rgba(0,0,0,0.12); color: inherit; }
        .quick-card-icon {
            width: 52px; height: 52px; border-radius: 14px;
            display: flex; align-items: center; justify-content: center;
            font-size: 24px; margin-bottom: 16px;
        }
        .quick-card-icon.maroon { background: #fdf0f1; color: var(--brand-maroon); }
        .quick-card-icon.green  { background: #eef5f2; color: var(--brand-green); }
        .quick-card-icon.amber  { background: #fffbeb; color: #b45309; }
        .quick-card h5 { font-family: 'Playfair Display', serif; font-size: 17px; font-weight: 700; margin: 0 0 6px; color: #1a1a1a; }
        .quick-card p  { font-size: 13px; color: #888; margin: 0; }
        .quick-card .card-arrow { font-size: 18px; color: #ccc; float: right; margin-top: -40px; }

        /* Info banner */
        .info-banner {
            background: #fffbeb; border: 1px solid #fde68a;
            border-radius: 12px; padding: 16px 20px;
            display: flex; align-items: flex-start; gap: 12px;
            font-size: 14px; color: #78350f; margin-bottom: 24px;
        }
        .info-banner i { color: #d97706; font-size: 18px; flex-shrink: 0; margin-top: 1px; }
    </style>
</head>
<body>

<!-- SIDEBAR -->
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="logo-icon"><i class="bi bi-person-badge"></i></div>
        <div class="name">MEASI Alumni</div>
        <div class="sub">Staff Portal</div>
    </div>
    <nav class="sidebar-nav">
        <div class="nav-label">Navigation</div>
        <a class="nav-link-item active" href="<%=request.getContextPath()%>/staff/dashboard.jsp">
            <i class="bi bi-speedometer2"></i> Dashboard
        </a>
        <a class="nav-link-item" href="<%=request.getContextPath()%>/staff/members">
            <i class="bi bi-people-fill"></i> All Members
        </a>
        <div class="nav-label">Portal</div>
        <a class="nav-link-item" href="<%=request.getContextPath()%>/home" target="_blank">
            <i class="bi bi-house"></i> Public Portal
        </a>
    </nav>
    <div class="sidebar-footer">
        <div class="staff-info">
            <div class="staff-avatar"><i class="bi bi-person"></i></div>
            <div>
                <div class="staff-name"><%= staffUser.getFullName() %></div>
                <div class="staff-role">Staff</div>
            </div>
        </div>
        <a class="nav-link-item" href="<%=request.getContextPath()%>/staff-logout">
            <i class="bi bi-box-arrow-left"></i> Logout
        </a>
    </div>
</aside>

<!-- MAIN -->
<div class="main-wrap">

    <div class="topbar">
        <div class="topbar-title">Dashboard</div>
        <div style="font-size:13px;color:#888;">
            <i class="bi bi-person-circle me-1"></i><%= staffUser.getFullName() %>
        </div>
    </div>

    <div class="welcome-hero">
        <div style="position:relative;z-index:2;">
            <h2>Welcome, <%= staffUser.getFullName() %></h2>
            <p>You are logged in as Staff. Use the navigation to view alumni member records.</p>
        </div>
    </div>

    <div class="content-area">

        <div class="info-banner">
            <i class="bi bi-info-circle-fill"></i>
            <div>
                <strong>Staff Access Notice:</strong> You have read-only access to approved alumni member records.
                For administrative actions (approvals, deletions), please use the Admin Portal.
            </div>
        </div>

        <div class="row g-3">
            <div class="col-md-4">
                <a class="quick-card" href="<%=request.getContextPath()%>/staff/members">
                    <div class="quick-card-icon maroon"><i class="bi bi-people-fill"></i></div>
                    <h5>All Alumni Members</h5>
                    <p>View full details of all approved alumni members.</p>
                    <span class="card-arrow"><i class="bi bi-arrow-right"></i></span>
                </a>
            </div>
            <div class="col-md-4">
                <a class="quick-card" href="<%=request.getContextPath()%>/gallery" target="_blank">
                    <div class="quick-card-icon green"><i class="bi bi-images"></i></div>
                    <h5>Gallery</h5>
                    <p>Browse alumni event photos and memories.</p>
                    <span class="card-arrow"><i class="bi bi-arrow-right"></i></span>
                </a>
            </div>
            <div class="col-md-4">
                <a class="quick-card" href="<%=request.getContextPath()%>/events" target="_blank">
                    <div class="quick-card-icon amber"><i class="bi bi-calendar-event-fill"></i></div>
                    <h5>Events</h5>
                    <p>View upcoming and past alumni events.</p>
                    <span class="card-arrow"><i class="bi bi-arrow-right"></i></span>
                </a>
            </div>
        </div>

    </div>
</div>

</body>
</html>
