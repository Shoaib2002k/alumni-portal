<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.LinkedHashSet" %>
<%@ page import="com.alumni.model.AlumniProfile" %>
<%@ page import="com.alumni.model.User" %>
<%
    User staffUser = (User) session.getAttribute("staffUser");

    List<AlumniProfile> members = (List<AlumniProfile>) request.getAttribute("members");
    int totalMembers = (members != null) ? members.size() : 0;

    /* Build batch and department sets once at top to avoid scriptlet variable conflicts */
    Set<String> batchSet = new LinkedHashSet<>();
    Set<String> deptSet  = new LinkedHashSet<>();
    if (members != null) {
        for (AlumniProfile ap : members) {
            if (ap.getBatchId()  != null) batchSet.add(String.valueOf(ap.getBatchId()));
            if (ap.getDeptId()   != null) deptSet.add(String.valueOf(ap.getDeptId()));
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Alumni Members | Staff Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --brand-maroon: #7a0f1b;
            --brand-green : #0b4b3b;
            --sidebar-w   : 240px;
        }
        body { font-family: 'DM Sans', sans-serif; background: #f4f2ef; margin: 0; }

        /* ── SIDEBAR ── */
        .sidebar {
            position: fixed; top: 0; left: 0;
            width: var(--sidebar-w); height: 100vh;
            background: linear-gradient(180deg, var(--brand-green) 0%, #073327 100%);
            display: flex; flex-direction: column;
            z-index: 200; overflow-y: auto;
        }
        .sidebar-brand {
            padding: 24px 20px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }
        .sidebar-brand .logo-icon {
            width: 44px; height: 44px;
            background: rgba(255,255,255,0.12);
            border-radius: 10px;
            display: flex; align-items: center; justify-content: center;
            font-size: 22px; color: #ffd54f;
            margin-bottom: 10px;
        }
        .sidebar-brand .name {
            font-family: 'Playfair Display', serif;
            font-size: 15px; font-weight: 700; color: #fff; line-height: 1.2;
        }
        .sidebar-brand .sub {
            font-size: 11px; color: rgba(255,255,255,0.5);
            text-transform: uppercase; letter-spacing: 1px;
        }
        .sidebar-nav { padding: 16px 12px; flex: 1; }
        .sidebar-nav .nav-label {
            font-size: 10px; font-weight: 700;
            color: rgba(255,255,255,0.4);
            text-transform: uppercase; letter-spacing: 1.5px;
            padding: 0 8px; margin: 16px 0 6px;
        }
        .nav-link-item {
            display: flex; align-items: center; gap: 10px;
            padding: 10px 12px; border-radius: 10px;
            color: rgba(255,255,255,0.75);
            text-decoration: none; font-size: 14px; font-weight: 500;
            transition: all 0.2s; margin-bottom: 2px;
        }
        .nav-link-item i { font-size: 17px; width: 20px; }
        .nav-link-item:hover, .nav-link-item.active {
            background: rgba(255,255,255,0.12);
            color: #fff;
        }
        .nav-link-item.active { background: rgba(255,213,79,0.15); color: #ffd54f; }
        .sidebar-footer {
            padding: 16px 12px;
            border-top: 1px solid rgba(255,255,255,0.1);
        }
        .staff-info {
            display: flex; align-items: center; gap: 10px;
            padding: 10px 12px; margin-bottom: 8px;
        }
        .staff-avatar {
            width: 36px; height: 36px;
            background: rgba(255,213,79,0.2);
            border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            color: #ffd54f; font-size: 16px; flex-shrink: 0;
        }
        .staff-name { font-size: 13px; font-weight: 600; color: #fff; }
        .staff-role { font-size: 11px; color: rgba(255,255,255,0.5); }

        /* ── MAIN CONTENT ── */
        .main-wrap {
            margin-left: var(--sidebar-w);
            min-height: 100vh;
        }

        /* Top bar */
        .topbar {
            background: #fff;
            border-bottom: 1px solid #e8e3dd;
            padding: 0 28px;
            height: 64px;
            display: flex; align-items: center;
            justify-content: space-between;
            position: sticky; top: 0; z-index: 100;
            box-shadow: 0 2px 12px rgba(0,0,0,0.05);
        }
        .topbar-title {
            font-family: 'Playfair Display', serif;
            font-size: 20px; font-weight: 700; color: #1a1a1a;
        }
        .topbar-right { display: flex; align-items: center; gap: 12px; }

        /* Page hero */
        .page-hero {
            background: linear-gradient(135deg, var(--brand-maroon) 0%, #5a0a13 50%, var(--brand-green) 100%);
            padding: 36px 28px;
            color: #fff; position: relative; overflow: hidden;
        }
        .page-hero::before {
            content: '';
            position: absolute; top: -60px; right: -60px;
            width: 280px; height: 280px; border-radius: 50%;
            background: rgba(255,213,79,0.06);
        }
        .page-hero h2 {
            font-family: 'Playfair Display', serif;
            font-size: 26px; font-weight: 800; margin: 0 0 6px;
        }
        .page-hero p { font-size: 14px; opacity: 0.75; margin: 0; }
        .hero-stats-row {
            display: flex; gap: 20px; margin-top: 24px; flex-wrap: wrap;
        }
        .hero-stat {
            background: rgba(255,255,255,0.12);
            border: 1px solid rgba(255,255,255,0.18);
            border-radius: 12px; padding: 14px 20px; text-align: center;
            min-width: 100px;
        }
        .hero-stat strong {
            display: block; font-size: 26px; font-weight: 800; color: #ffd54f; line-height: 1;
        }
        .hero-stat span { font-size: 11px; opacity: 0.7; text-transform: uppercase; letter-spacing: 0.5px; }

        /* Filter bar */
        .filter-bar {
            background: #fff;
            border-bottom: 1px solid #e8e3dd;
            padding: 14px 28px;
            display: flex; gap: 12px; align-items: center; flex-wrap: wrap;
            position: sticky; top: 64px; z-index: 99;
            box-shadow: 0 2px 10px rgba(0,0,0,0.04);
        }
        .search-wrap { position: relative; flex: 1; min-width: 200px; }
        .search-wrap i {
            position: absolute; left: 12px; top: 50%;
            transform: translateY(-50%); color: #bbb; font-size: 15px;
        }
        .search-wrap input {
            width: 100%; padding: 10px 12px 10px 36px;
            border: 1.5px solid #e0dbd4; border-radius: 10px;
            font-size: 13px; font-family: 'DM Sans', sans-serif;
            background: #faf9f7; outline: none;
            transition: border-color 0.2s;
        }
        .search-wrap input:focus { border-color: var(--brand-maroon); }
        .filter-select {
            padding: 10px 14px;
            border: 1.5px solid #e0dbd4; border-radius: 10px;
            font-size: 13px; font-family: 'DM Sans', sans-serif;
            background: #faf9f7; outline: none; cursor: pointer; min-width: 130px;
        }
        .filter-select:focus { border-color: var(--brand-maroon); }
        .results-label { font-size: 13px; color: #999; margin-left: auto; white-space: nowrap; }
        .results-label b { color: var(--brand-maroon); }

        /* Content area */
        .content-area { padding: 24px 28px 48px; }

        /* Table */
        .members-table-wrap {
            background: #fff; border-radius: 16px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.06);
            overflow: hidden;
        }
        .members-table {
            width: 100%; border-collapse: collapse;
        }
        .members-table thead tr {
            background: #faf9f7;
            border-bottom: 2px solid #f0ece6;
        }
        .members-table thead th {
            padding: 14px 16px;
            font-size: 11px; font-weight: 700;
            color: #888; text-transform: uppercase;
            letter-spacing: 0.8px; white-space: nowrap;
            text-align: left;
        }
        .members-table tbody tr {
            border-bottom: 1px solid #f5f0eb;
            transition: background 0.15s;
            cursor: pointer;
        }
        .members-table tbody tr:hover { background: #fdf9f6; }
        .members-table tbody tr:last-child { border-bottom: none; }
        .members-table td {
            padding: 14px 16px; font-size: 13px; color: #333;
            vertical-align: middle;
        }
        .member-avatar-sm {
            width: 40px; height: 40px; border-radius: 10px;
            object-fit: cover; background: #f0ece6;
            flex-shrink: 0;
        }
        .member-avatar-placeholder {
            width: 40px; height: 40px; border-radius: 10px;
            background: linear-gradient(135deg, #f0ece6, #e0d9d0);
            display: flex; align-items: center; justify-content: center;
            font-size: 18px; color: #c5b9ae; flex-shrink: 0;
        }
        .member-name-cell { display: flex; align-items: center; gap: 12px; }
        .member-name-text { font-weight: 600; color: #1a1a1a; }
        .member-email-text { font-size: 11px; color: #999; margin-top: 2px; }
        .badge-batch {
            background: #eef5f2; color: var(--brand-green);
            font-size: 11px; font-weight: 700;
            padding: 3px 10px; border-radius: 50px;
        }
        .badge-dept {
            background: #f5f0eb; color: #7a5c3b;
            font-size: 11px; font-weight: 700;
            padding: 3px 10px; border-radius: 50px;
        }
        .btn-view {
            display: inline-flex; align-items: center; gap: 5px;
            padding: 6px 14px; border-radius: 8px;
            background: var(--brand-maroon); color: #fff;
            font-size: 12px; font-weight: 600;
            border: none; cursor: pointer;
            transition: background 0.2s;
        }
        .btn-view:hover { background: #5a0a13; }

        /* Empty state */
        .empty-state {
            text-align: center; padding: 80px 20px;
        }
        .empty-state i { font-size: 60px; color: #ddd; margin-bottom: 16px; display: block; }
        .empty-state p { color: #aaa; font-size: 15px; }

        /* No results row */
        #noResultsRow { display: none; }
        #noResultsRow td { text-align: center; padding: 48px; color: #bbb; font-size: 14px; }

        /* ── DETAIL MODAL ── */
        .modal-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,0.5);
            z-index: 9999; align-items: center; justify-content: center;
            padding: 20px; backdrop-filter: blur(3px);
        }
        .modal-overlay.active { display: flex; }
        .modal-box {
            background: #fff; border-radius: 20px;
            width: 100%; max-width: 680px; max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 30px 80px rgba(0,0,0,0.25);
            animation: modalIn 0.25s ease;
        }
        @keyframes modalIn {
            from { transform: translateY(20px); opacity: 0; }
            to   { transform: translateY(0);    opacity: 1; }
        }
        .modal-header-custom {
            background: linear-gradient(135deg, var(--brand-maroon), #5a0a13);
            color: #fff; padding: 28px;
            border-radius: 20px 20px 0 0;
            display: flex; align-items: center; gap: 20px;
            position: relative;
        }
        .modal-close-btn {
            position: absolute; top: 16px; right: 16px;
            width: 36px; height: 36px;
            background: rgba(255,255,255,0.15);
            border: none; border-radius: 50%; cursor: pointer;
            color: #fff; font-size: 16px;
            display: flex; align-items: center; justify-content: center;
            transition: background 0.2s;
        }
        .modal-close-btn:hover { background: rgba(255,255,255,0.28); }
        .modal-avatar {
            width: 80px; height: 80px; border-radius: 14px;
            object-fit: cover;
            border: 3px solid rgba(255,255,255,0.35);
            flex-shrink: 0;
        }
        .modal-avatar-placeholder {
            width: 80px; height: 80px; border-radius: 14px;
            background: rgba(255,255,255,0.15);
            border: 3px solid rgba(255,255,255,0.25);
            display: flex; align-items: center; justify-content: center;
            font-size: 36px; flex-shrink: 0;
        }
        .modal-name { font-family: 'Playfair Display', serif; font-size: 22px; font-weight: 800; }
        .modal-sub  { font-size: 13px; opacity: 0.75; margin-top: 4px; }
        .modal-body-custom { padding: 28px; }
        .section-label {
            font-size: 11px; font-weight: 700;
            color: #aaa; text-transform: uppercase; letter-spacing: 1px;
            margin-bottom: 14px; padding-bottom: 8px;
            border-bottom: 1px solid #f0ece6;
        }
        .detail-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 16px; margin-bottom: 24px; }
        .detail-item label {
            font-size: 11px; font-weight: 700;
            color: #bbb; text-transform: uppercase; letter-spacing: 0.5px;
            display: block; margin-bottom: 4px;
        }
        .detail-item p {
            font-size: 14px; font-weight: 600; color: #1a1a1a; margin: 0;
        }
        .detail-item p.empty { color: #ccc; font-weight: 400; font-style: italic; }

        @media (max-width: 900px) {
            .sidebar { transform: translateX(-100%); }
            .main-wrap { margin-left: 0; }
            .detail-grid { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<!-- ═══ SIDEBAR ═══ -->
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="logo-icon"><i class="bi bi-person-badge"></i></div>
        <div class="name">MEASI Alumni</div>
        <div class="sub">Staff Portal</div>
    </div>

    <nav class="sidebar-nav">
        <div class="nav-label">Navigation</div>
        <a class="nav-link-item" href="<%=request.getContextPath()%>/staff/dashboard.jsp">
            <i class="bi bi-speedometer2"></i> Dashboard
        </a>
        <a class="nav-link-item active" href="<%=request.getContextPath()%>/staff/members">
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

<!-- ═══ MAIN ═══ -->
<div class="main-wrap">

    <!-- Top bar -->
    <div class="topbar">
        <div class="topbar-title">Alumni Members</div>
        <div class="topbar-right">
            <span style="font-size:13px;color:#888;">
                <i class="bi bi-person-circle me-1"></i><%= staffUser.getFullName() %>
            </span>
        </div>
    </div>

    <!-- Page hero -->
    <div class="page-hero">
        <div style="position:relative;z-index:2;">
            <h2>Approved Alumni Members</h2>
            <p>Full member details — visible to authorized staff only.</p>
            <div class="hero-stats-row">
                <div class="hero-stat">
                    <strong><%= totalMembers %></strong>
                    <span>Total</span>
                </div>
                <div class="hero-stat">
                    <strong><%= batchSet.size() %></strong>
                    <span>Batches</span>
                </div>
                <div class="hero-stat">
                    <strong><%= deptSet.size() %></strong>
                    <span>Departments</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Filter bar -->
    <div class="filter-bar">
        <div class="search-wrap">
            <i class="bi bi-search"></i>
            <input type="text" id="searchInput"
                   placeholder="Search name, email, company, reg no..."
                   oninput="filterTable()">
        </div>
        <select class="filter-select" id="batchFilter" onchange="filterTable()">
            <option value="">All Batches</option>
            <% for (String b : batchSet) { %>
                <option value="<%= b %>">Batch <%= b %></option>
            <% } %>
        </select>
        <select class="filter-select" id="deptFilter" onchange="filterTable()">
            <option value="">All Depts</option>
            <% for (String d : deptSet) { %>
                <option value="<%= d %>">Dept <%= d %></option>
            <% } %>
        </select>
        <div class="results-label">
            Showing <b id="visibleCount"><%= totalMembers %></b> of <%= totalMembers %>
        </div>
    </div>

    <!-- Content -->
    <div class="content-area">
        <% if (members != null && !members.isEmpty()) { %>
        <div class="members-table-wrap">
            <table class="members-table">
                <thead>
                    <tr>
                        <th>#</th>
                        <th>Member</th>
                        <th>Phone</th>
                        <th>Batch</th>
                        <th>Dept</th>
                        <th>Reg No</th>
                        <th>Company</th>
                        <th>Role</th>
                        <th>Exp</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody id="membersTableBody">
                <%
                    int rowNum = 1;
                    for (AlumniProfile mem : members) {
                        String mName    = (mem.getUser() != null && mem.getUser().getFullName() != null) ? mem.getUser().getFullName() : "-";
                        String mEmail   = (mem.getUser() != null && mem.getUser().getEmail()    != null) ? mem.getUser().getEmail()    : "-";
                        String mPhone   = (mem.getUser() != null && mem.getUser().getPhone()    != null) ? mem.getUser().getPhone()    : "-";
                        String mPlace   = (mem.getUser() != null && mem.getUser().getPlace()    != null) ? mem.getUser().getPlace()    : "-";
                        String mAge     = (mem.getUser() != null && mem.getUser().getAge()      != null) ? String.valueOf(mem.getUser().getAge()) : "-";
                        String mBatch   = (mem.getBatchId()            != null) ? String.valueOf(mem.getBatchId())            : "-";
                        String mDept    = (mem.getDeptId()             != null) ? String.valueOf(mem.getDeptId())             : "-";
                        String mRegNo   = (mem.getUniversityRegNo()    != null) ? mem.getUniversityRegNo()    : "-";
                        String mCompany = (mem.getCurrentCompany()     != null) ? mem.getCurrentCompany()     : "-";
                        String mRole    = (mem.getCurrentRole()        != null) ? mem.getCurrentRole()        : "-";
                        String mExp     = (mem.getExperienceYears()    != null) ? mem.getExperienceYears() + " yr" : "-";
                        String mSpec    = (mem.getSpecialization()     != null) ? mem.getSpecialization()     : "-";
                        String mCoCnt   = (mem.getCompanyChangesCount()!= null) ? String.valueOf(mem.getCompanyChangesCount()) : "-";
                        String mCoNames = (mem.getCompanyChangesNames()!= null) ? mem.getCompanyChangesNames() : "-";
                        String mPhoto   = (mem.getPhotoPath()          != null && !mem.getPhotoPath().trim().isEmpty()) ? mem.getPhotoPath() : "";
                        String mUserId  = String.valueOf(mem.getUserId());
                %>
                <tr class="member-row"
                    data-name="<%= mName.toLowerCase() %>"
                    data-email="<%= mEmail.toLowerCase() %>"
                    data-company="<%= mCompany.toLowerCase() %>"
                    data-regno="<%= mRegNo.toLowerCase() %>"
                    data-batch="<%= mBatch %>"
                    data-dept="<%= mDept %>"
                    onclick="openModal(
                        '<%= mUserId %>',
                        '<%= mName.replace("'","\\'") %>',
                        '<%= mEmail.replace("'","\\'") %>',
                        '<%= mPhone.replace("'","\\'") %>',
                        '<%= mPlace.replace("'","\\'") %>',
                        '<%= mAge %>',
                        '<%= mBatch %>',
                        '<%= mDept %>',
                        '<%= mRegNo.replace("'","\\'") %>',
                        '<%= mCompany.replace("'","\\'") %>',
                        '<%= mRole.replace("'","\\'") %>',
                        '<%= mExp %>',
                        '<%= mSpec.replace("'","\\'") %>',
                        '<%= mCoCnt %>',
                        '<%= mCoNames.replace("'","\\'") %>',
                        '<%= mPhoto.replace("'","\\'") %>'
                    )">
                    <td><%= rowNum++ %></td>
                    <td>
                        <div class="member-name-cell">
                            <% if (!mPhoto.isEmpty()) { %>
                            <img class="member-avatar-sm"
                                 src="<%=request.getContextPath()%>/<%=mPhoto%>"
                                 alt="<%= mName %>"
                                 onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                            <div class="member-avatar-placeholder" style="display:none"><i class="bi bi-person"></i></div>
                            <% } else { %>
                            <div class="member-avatar-placeholder"><i class="bi bi-person"></i></div>
                            <% } %>
                            <div>
                                <div class="member-name-text"><%= mName %></div>
                                <div class="member-email-text"><%= mEmail %></div>
                            </div>
                        </div>
                    </td>
                    <td><%= mPhone %></td>
                    <td><span class="badge-batch"><%= mBatch %></span></td>
                    <td><span class="badge-dept"><%= mDept %></span></td>
                    <td><%= mRegNo %></td>
                    <td><%= mCompany %></td>
                    <td><%= mRole %></td>
                    <td><%= mExp %></td>
                    <td>
                        <button class="btn-view" onclick="event.stopPropagation();">
                            <i class="bi bi-eye"></i> View
                        </button>
                    </td>
                </tr>
                <%  } %>
                <tr id="noResultsRow">
                    <td colspan="10">
                        <i class="bi bi-search" style="font-size:32px;display:block;margin-bottom:8px;"></i>
                        No members match your search.
                    </td>
                </tr>
                </tbody>
            </table>
        </div>
        <% } else { %>
        <div class="empty-state">
            <i class="bi bi-people"></i>
            <p>No approved alumni members found.</p>
        </div>
        <% } %>
    </div>
</div>

<!-- ═══ DETAIL MODAL ═══ -->
<div class="modal-overlay" id="modalOverlay" onclick="closeModalOnBg(event)">
    <div class="modal-box">
        <div class="modal-header-custom">
            <div id="modalAvatarWrap"></div>
            <div>
                <div class="modal-name" id="modalName"></div>
                <div class="modal-sub" id="modalSub"></div>
            </div>
            <button class="modal-close-btn" onclick="closeModal()">
                <i class="bi bi-x-lg"></i>
            </button>
        </div>
        <div class="modal-body-custom">

            <div class="section-label">Personal Information</div>
            <div class="detail-grid">
                <div class="detail-item">
                    <label>Full Name</label>
                    <p id="dName"></p>
                </div>
                <div class="detail-item">
                    <label>Email</label>
                    <p id="dEmail"></p>
                </div>
                <div class="detail-item">
                    <label>Phone</label>
                    <p id="dPhone"></p>
                </div>
                <div class="detail-item">
                    <label>Place</label>
                    <p id="dPlace"></p>
                </div>
                <div class="detail-item">
                    <label>Age</label>
                    <p id="dAge"></p>
                </div>
                <div class="detail-item">
                    <label>Reg No</label>
                    <p id="dRegNo"></p>
                </div>
            </div>

            <div class="section-label">Academic Details</div>
            <div class="detail-grid">
                <div class="detail-item">
                    <label>Batch</label>
                    <p id="dBatch"></p>
                </div>
                <div class="detail-item">
                    <label>Department ID</label>
                    <p id="dDept"></p>
                </div>
                <div class="detail-item">
                    <label>Specialization</label>
                    <p id="dSpec"></p>
                </div>
            </div>

            <div class="section-label">Professional Details</div>
            <div class="detail-grid">
                <div class="detail-item">
                    <label>Current Company</label>
                    <p id="dCompany"></p>
                </div>
                <div class="detail-item">
                    <label>Current Role</label>
                    <p id="dRole"></p>
                </div>
                <div class="detail-item">
                    <label>Experience</label>
                    <p id="dExp"></p>
                </div>
                <div class="detail-item">
                    <label>Company Changes</label>
                    <p id="dCoCnt"></p>
                </div>
            </div>

            <div class="section-label">Previous Companies</div>
            <div class="detail-item" style="margin-bottom:0;">
                <p id="dCoNames" style="white-space:pre-wrap;font-size:13px;font-weight:500;"></p>
            </div>

        </div>
    </div>
</div>

<script>
/* ── TABLE FILTER ── */
function filterTable() {
    var search = document.getElementById('searchInput').value.toLowerCase();
    var batch  = document.getElementById('batchFilter').value;
    var dept   = document.getElementById('deptFilter').value;
    var rows   = document.querySelectorAll('.member-row');
    var visible = 0;

    rows.forEach(function (row) {
        var nameMatch    = row.dataset.name.includes(search);
        var emailMatch   = row.dataset.email.includes(search);
        var companyMatch = row.dataset.company.includes(search);
        var regnoMatch   = row.dataset.regno.includes(search);
        var textMatch    = nameMatch || emailMatch || companyMatch || regnoMatch;
        var batchMatch   = !batch || row.dataset.batch === batch;
        var deptMatch    = !dept  || row.dataset.dept  === dept;

        if (textMatch && batchMatch && deptMatch) {
            row.style.display = '';
            visible++;
        } else {
            row.style.display = 'none';
        }
    });

    document.getElementById('visibleCount').textContent = visible;
    var noRow = document.getElementById('noResultsRow');
    if (noRow) noRow.style.display = (visible === 0) ? 'table-row' : 'none';
}

/* ── MODAL ── */
var contextPath = '<%=request.getContextPath()%>';

function openModal(userId, name, email, phone, place, age,
                   batch, dept, regNo, company, role, exp,
                   spec, coCnt, coNames, photoPath) {

    /* Avatar */
    var avatarWrap = document.getElementById('modalAvatarWrap');
    if (photoPath && photoPath !== '') {
        avatarWrap.innerHTML =
            '<img class="modal-avatar" src="' + contextPath + '/' + photoPath + '" ' +
            'alt="' + name + '" onerror="this.style.display=\'none\';' +
            'this.nextElementSibling.style.display=\'flex\'">' +
            '<div class="modal-avatar-placeholder" style="display:none"><i class="bi bi-person"></i></div>';
    } else {
        avatarWrap.innerHTML =
            '<div class="modal-avatar-placeholder"><i class="bi bi-person"></i></div>';
    }

    /* Header */
    document.getElementById('modalName').textContent = name;
    document.getElementById('modalSub').textContent  = role + (company !== '-' ? ' at ' + company : '');

    /* Personal */
    setText('dName',  name);
    setText('dEmail', email);
    setText('dPhone', phone);
    setText('dPlace', place);
    setText('dAge',   age !== '-' ? age + ' years' : '-');
    setText('dRegNo', regNo);

    /* Academic */
    setText('dBatch', batch !== '-' ? 'Batch ' + batch : '-');
    setText('dDept',  dept);
    setText('dSpec',  spec);

    /* Professional */
    setText('dCompany', company);
    setText('dRole',    role);
    setText('dExp',     exp);
    setText('dCoCnt',   coCnt !== '-' ? coCnt + ' change(s)' : '-');
    setText('dCoNames', coNames !== '-' ? coNames : 'None recorded');

    document.getElementById('modalOverlay').classList.add('active');
    document.body.style.overflow = 'hidden';
}

function setText(id, val) {
    var el = document.getElementById(id);
    el.textContent = (val && val !== '-' && val !== '') ? val : '-';
    el.className   = (val && val !== '-' && val !== '') ? '' : 'empty';
}

function closeModal() {
    document.getElementById('modalOverlay').classList.remove('active');
    document.body.style.overflow = '';
}
function closeModalOnBg(e) {
    if (e.target === document.getElementById('modalOverlay')) closeModal();
}
document.addEventListener('keydown', function (e) {
    if (e.key === 'Escape') closeModal();
});
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
