<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Set" %>
<%@ page import="java.util.LinkedHashSet" %>
<%@ page import="com.alumni.model.AlumniProfile" %>
<%@ page import="com.alumni.model.User" %>
<%@ page import="java.util.Map" %>
<%
    Map<String, String> settings = (Map<String, String>) request.getAttribute("settings");
    String siteName     = "MEASI Alumni Web Portal";
    String logoPath     = "assets/img/logoonly.PNG";
    String primaryColor = "#7a0f1b";
    if (settings != null) {
        if (settings.get("SITE_NAME")     != null && !settings.get("SITE_NAME").trim().isEmpty())     siteName     = settings.get("SITE_NAME");
        if (settings.get("LOGO_PATH")     != null && !settings.get("LOGO_PATH").trim().isEmpty())     logoPath     = settings.get("LOGO_PATH");
        if (settings.get("PRIMARY_COLOR") != null && !settings.get("PRIMARY_COLOR").trim().isEmpty()) primaryColor = settings.get("PRIMARY_COLOR");
    }

    List<AlumniProfile> members = (List<AlumniProfile>) request.getAttribute("members");
    int totalMembers = (members != null) ? members.size() : 0;

    /* Build unique batch list once — avoids variable collision in scriptlets */
    Set<String> batchSet = new LinkedHashSet<>();
    if (members != null) {
        for (AlumniProfile ap : members) {
            String bid = (ap.getBatchId() != null) ? String.valueOf(ap.getBatchId()).trim() : "";
            if (!bid.isEmpty()) batchSet.add(bid);
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Alumni Members | <%= siteName %></title>
    <%@ include file="../WEB-INF/views/common-head.jspf" %>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --brand-maroon: <%= primaryColor %>;
            --brand-green : #0b4b3b;
        }
        body { font-family: 'DM Sans', sans-serif; background: #f6f4f1; }

        /* ═══════════════════════════════════════
           PAGE HERO  — same pattern as events.jsp
        ═══════════════════════════════════════ */
        .page-hero {
            background: linear-gradient(135deg, var(--brand-maroon) 0%, #5a0a13 40%, var(--brand-green) 100%);
            padding: 68px 0 80px;
            position: relative;
            overflow: hidden;
        }
        .page-hero::after {
            content: '';
            position: absolute;
            bottom: -2px; left: 0; right: 0;
            height: 60px;
            background: #f6f4f1;
            clip-path: ellipse(60% 100% at 50% 100%);
        }
        .page-hero::before {
            content: '';
            position: absolute;
            top: -80px; left: -80px;
            width: 420px; height: 420px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255,213,79,0.07) 0%, transparent 70%);
            pointer-events: none;
        }
        .hero-content {
            position: relative; z-index: 2;
            text-align: center; color: #fff;
        }
        .hero-eyebrow {
            display: inline-flex;
            align-items: center; gap: 8px;
            background: rgba(255,213,79,0.15);
            border: 1px solid rgba(255,213,79,0.35);
            color: #ffd54f;
            padding: 6px 20px; border-radius: 50px;
            font-size: 12px; font-weight: 700;
            letter-spacing: 2px; text-transform: uppercase;
            margin-bottom: 20px;
        }
        .page-hero h1 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(36px, 6vw, 62px);
            font-weight: 800; margin: 0 0 16px; line-height: 1.1;
        }
        .page-hero > .container > .hero-content > p {
            font-size: 17px; opacity: 0.75;
            max-width: 500px; margin: 0 auto 36px;
        }
        /* stat boxes — identical to events.jsp */
        .hero-stats {
            display: flex; justify-content: center;
            gap: 36px; flex-wrap: wrap;
        }
        .hero-stat-box {
            background: rgba(255,255,255,0.10);
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 14px;
            padding: 18px 28px; text-align: center; min-width: 110px;
        }
        .hero-stat-box strong {
            display: block;
            font-family: 'Playfair Display', serif;
            font-size: 34px; color: #ffd54f; line-height: 1;
        }
        .hero-stat-box span {
            font-size: 12px; opacity: 0.7;
            letter-spacing: 0.5px; text-transform: uppercase;
            margin-top: 4px; display: block;
        }

        /* ═══════════════════════════════════════
           STICKY FILTER BAR — like events tab bar
        ═══════════════════════════════════════ */
        .filter-bar {
            background: #fff;
            border-bottom: 1px solid #e8e3dd;
            position: sticky; top: 100px; z-index: 100;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            padding: 0;
        }
        .filter-bar-inner {
            display: flex; align-items: center;
            gap: 12px; flex-wrap: wrap;
            padding: 14px 0;
        }
        .search-wrap {
            flex: 1; min-width: 220px; position: relative;
        }
        .search-wrap i {
            position: absolute; left: 14px; top: 50%;
            transform: translateY(-50%); color: #aaa; font-size: 15px;
        }
        .search-wrap input {
            width: 100%; padding: 11px 14px 11px 40px;
            border: 1.5px solid #e0dbd4; border-radius: 10px;
            font-size: 14px; font-family: 'DM Sans', sans-serif;
            background: #faf9f7; outline: none;
            transition: border-color 0.2s;
        }
        .search-wrap input:focus { border-color: var(--brand-maroon); background: #fff; }
        .batch-select {
            padding: 11px 16px;
            border: 1.5px solid #e0dbd4; border-radius: 10px;
            font-size: 14px; font-family: 'DM Sans', sans-serif;
            background: #faf9f7; outline: none; cursor: pointer; min-width: 150px;
        }
        .batch-select:focus { border-color: var(--brand-maroon); }
        .results-label {
            font-size: 13px; color: #999; white-space: nowrap; margin-left: auto;
        }
        .results-label b { color: var(--brand-maroon); }

        /* ═══════════════════════════════════════
           MEMBER CARDS — same card style as events
        ═══════════════════════════════════════ */
        .members-section { padding: 48px 0 80px; }

        .member-card {
            background: #fff;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 30px rgba(0,0,0,0.07);
            transition: all 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
            height: 100%; display: flex; flex-direction: column;
            border: 1px solid rgba(0,0,0,0.04);
        }
        .member-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 50px rgba(11,75,59,0.15);
        }

        /* photo area */
        .card-photo-wrap {
            position: relative; overflow: hidden;
            background: linear-gradient(135deg, #f0ece6, #e0d9d0);
        }
        .member-photo {
            width: 100%; height: 220px;
            object-fit: cover; display: block;
            transition: transform 0.5s ease;
        }
        .member-card:hover .member-photo { transform: scale(1.05); }
        .member-photo-placeholder {
            width: 100%; height: 220px;
            display: flex; align-items: center; justify-content: center;
            background: linear-gradient(135deg, #f0ece6, #e0d9d0);
        }
        .member-photo-placeholder i { font-size: 72px; color: #c5b9ae; }

        /* batch badge — top-left, same position as event-date-badge */
        .batch-badge {
            position: absolute; top: 14px; left: 14px;
            background: var(--brand-green);
            color: #fff; font-size: 11px; font-weight: 700;
            padding: 5px 12px; border-radius: 8px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.2);
            letter-spacing: 0.4px;
        }
        /* status ribbon — top-right, like past/upcoming ribbon */
        .status-ribbon {
            position: absolute; top: 14px; right: 14px;
            background: #ffd54f; color: #333;
            font-size: 11px; font-weight: 700;
            padding: 4px 12px; border-radius: 50px;
            letter-spacing: 0.5px;
        }

        /* card body */
        .card-body-custom {
            padding: 20px 22px 22px;
            flex: 1; display: flex; flex-direction: column;
        }
        .member-name {
            font-family: 'Playfair Display', serif;
            font-size: 19px; font-weight: 700;
            color: #1a1a1a; margin-bottom: 10px; line-height: 1.2;
        }
        /* meta rows — same style as event-meta-row */
        .member-meta { display: flex; flex-direction: column; gap: 7px; margin-bottom: 14px; }
        .member-meta-row {
            display: flex; align-items: center; gap: 8px;
            font-size: 13px; color: #666;
        }
        .member-meta-row i { width: 18px; color: var(--brand-green); flex-shrink: 0; }

        /* footer link — same as event-footer */
        .card-footer-custom {
            margin-top: auto; padding-top: 14px;
            border-top: 1px solid #f0ece6;
        }
        .profile-chip {
            display: inline-flex; align-items: center; gap: 6px;
            font-size: 13px; font-weight: 700;
            color: var(--brand-maroon); text-decoration: none;
            transition: gap 0.2s;
        }
        .profile-chip:hover { gap: 10px; color: var(--brand-maroon); }

        /* ── empty / no-results ── */
        .empty-state {
            text-align: center; padding: 60px 20px;
            background: #fff; border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        }
        .empty-state i { font-size: 64px; color: #ddd; margin-bottom: 16px; display: block; }
        .empty-state p { color: #aaa; font-size: 16px; }

        #noResultsMsg {
            display: none; text-align: center; padding: 60px 20px; width: 100%;
        }
        #noResultsMsg i { font-size: 60px; color: #ddd; margin-bottom: 16px; display: block; }
        #noResultsMsg p { color: #999; font-size: 16px; }

        /* ── footer ── */
        .footer { background: var(--brand-green); color: #fff; }
        .footer a { color: #fff; text-decoration: none; }
        .footer a:hover { text-decoration: underline; }
        .footer .social-btn {
            width: 42px; height: 42px; border-radius: 8px;
            display: inline-flex; align-items: center; justify-content: center;
            border: 1px solid rgba(255,255,255,0.35); color: #fff; text-decoration: none;
        }

        @media (max-width: 767px) {
            .filter-bar-inner { flex-direction: column; }
            .search-wrap, .batch-select { width: 100%; }
            .results-label { margin-left: 0; }
        }
    </style>
</head>
<body>

<%@ include file="../WEB-INF/views/common-header.jspf" %>

<!-- ═══ PAGE HERO ═══ -->
<div class="page-hero">
    <div class="container">
        <div class="hero-content">
            <div class="hero-eyebrow"><i class="bi bi-people-fill"></i> Our Community</div>
            <h1>Alumni Members</h1>
            <p>A network of brilliant minds shaping the world from every corner of the industry.</p>
            <div class="hero-stats">
                <div class="hero-stat-box">
                    <strong><%= totalMembers %></strong>
                    <span>Members</span>
                </div>
                <div class="hero-stat-box">
                    <strong><%= batchSet.size() %></strong>
                    <span>Batches</span>
                </div>
                <div class="hero-stat-box">
                    <strong><i class="bi bi-globe2" style="font-size:28px;"></i></strong>
                    <span>Global</span>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- ═══ STICKY FILTER BAR ═══ -->
<div class="filter-bar">
    <div class="container">
        <div class="filter-bar-inner">
            <div class="search-wrap">
                <i class="bi bi-search"></i>
                <input type="text" id="searchInput"
                       placeholder="Search by name, company or role…"
                       oninput="filterMembers()">
            </div>
            <select class="batch-select" id="batchFilter" onchange="filterMembers()">
                <option value="">All Batches</option>
                <% for (String batchOption : batchSet) { %>
                    <option value="<%= batchOption %>"><%= batchOption %></option>
                <% } %>
            </select>
            <div class="results-label">
                Showing <b id="visibleCount"><%= totalMembers %></b> of <%= totalMembers %> members
            </div>
        </div>
    </div>
</div>

<!-- ═══ MEMBERS GRID ═══ -->
<section class="members-section">
    <div class="container">

        <% if (members != null && !members.isEmpty()) { %>
        <div class="row g-4" id="membersGrid">

            <% for (AlumniProfile member : members) {
                String mName    = (member.getUser() != null && member.getUser().getFullName() != null)
                                  ? member.getUser().getFullName() : "Unknown";
                String mEmail   = (member.getUser() != null && member.getUser().getEmail() != null)
                                  ? member.getUser().getEmail() : "";
                String mBatch   = (member.getBatchId() != null)
                                  ? String.valueOf(member.getBatchId()).trim() : "";
                String mRole    = (member.getCurrentRole()    != null) ? member.getCurrentRole()    : "";
                String mCompany = (member.getCurrentCompany() != null) ? member.getCurrentCompany() : "";
                String mPhoto   = (member.getPhotoPath()      != null && !member.getPhotoPath().trim().isEmpty())
                                  ? member.getPhotoPath() : "";
            %>
            <div class="col-xl-3 col-lg-4 col-md-6 member-item"
                 data-name="<%= mName.toLowerCase() %>"
                 data-batch="<%= mBatch.toLowerCase() %>"
                 data-role="<%= mRole.toLowerCase() %>"
                 data-company="<%= mCompany.toLowerCase() %>">
                <div class="member-card">

                    <!-- Photo area -->
                    <div class="card-photo-wrap">
                        <% if (!mPhoto.isEmpty()) { %>
                            <img class="member-photo"
                                 src="<%=request.getContextPath()%>/<%=mPhoto%>"
                                 alt="<%= mName %>"
                                 onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                            <div class="member-photo-placeholder" style="display:none">
                                <i class="bi bi-person-circle"></i>
                            </div>
                        <% } else { %>
                            <div class="member-photo-placeholder">
                                <i class="bi bi-person-circle"></i>
                            </div>
                        <% } %>
                        <% if (!mBatch.isEmpty()) { %>
                            <span class="batch-badge">Batch <%= mBatch %></span>
                        <% } %>
                        <span class="status-ribbon">Alumni</span>
                    </div>

                    <!-- Card body -->
                    <div class="card-body-custom">
                        <div class="member-name"><%= mName %></div>
                        <div class="member-meta">
                            <% if (!mRole.isEmpty()) { %>
                                <div class="member-meta-row">
                                    <i class="bi bi-briefcase-fill"></i><%= mRole %>
                                </div>
                            <% } %>
                            <% if (!mCompany.isEmpty()) { %>
                                <div class="member-meta-row">
                                    <i class="bi bi-building"></i><%= mCompany %>
                                </div>
                            <% } %>
                            <% if (!mEmail.isEmpty()) { %>
                                <div class="member-meta-row">
                                    <i class="bi bi-envelope"></i><%= mEmail %>
                                </div>
                            <% } %>
                        </div>
                        <div class="card-footer-custom">
                            <span class="profile-chip">
                                View Profile <i class="bi bi-arrow-right"></i>
                            </span>
                        </div>
                    </div>

                </div>
            </div>
            <% } /* end for */ %>

            <div id="noResultsMsg">
                <i class="bi bi-search"></i>
                <p>No members match your search. Try different keywords.</p>
            </div>

        </div><!-- /.row -->
        <% } else { %>
        <div class="empty-state">
            <i class="bi bi-people"></i>
            <p>No approved alumni members yet. Check back soon!</p>
        </div>
        <% } %>

    </div>
</section>

<!-- ═══ FOOTER ═══ -->
<footer id="contact" class="footer pt-5 pb-4">
    <div class="container">
        <div class="row g-4">
            <div class="col-md-6">
                <h3 class="fw-bold mb-4">Contact us</h3>
                <p class="fw-semibold mb-2">MEASI INSTITUTE OF INFORMATION TECHNOLOGY</p>
                <p class="mb-1">147 Peters Road, Royapettah, Chennai 600 014</p>
                <p class="mb-1">Mobile: +91 98403 61602 / +91 81229 85395</p>
                <p class="mb-1">Landline: 044 2835 2374</p>
                <p class="mb-1">E-Mail: info@measiit.edu.in</p>
            </div>
            <div class="col-md-6">
                <h3 class="fw-bold mb-4">Quick Links</h3>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="<%=request.getContextPath()%>/home">Home</a></li>
                    <li class="mb-2"><a href="<%=request.getContextPath()%>/home#about">About</a></li>
                    <li class="mb-2"><a href="<%=request.getContextPath()%>/members">Members</a></li>
                    <li class="mb-2"><a href="<%=request.getContextPath()%>/gallery">Gallery</a></li>
                    <li class="mb-2"><a href="<%=request.getContextPath()%>/events">Events</a></li>
                    <li class="mb-2"><a href="<%=request.getContextPath()%>/home#contact">Contact</a></li>
                </ul>
                <div class="mt-4">
                    <h5 class="fw-bold">Follow us on</h5>
                    <div class="d-flex gap-2 mt-2">
                        <a class="social-btn" href="#"><i class="bi bi-facebook"></i></a>
                        <a class="social-btn" href="#"><i class="bi bi-twitter-x"></i></a>
                        <a class="social-btn" href="#"><i class="bi bi-linkedin"></i></a>
                        <a class="social-btn" href="#"><i class="bi bi-youtube"></i></a>
                        <a class="social-btn" href="#"><i class="bi bi-instagram"></i></a>
                    </div>
                </div>
            </div>
        </div>
        <hr class="border-light my-4">
        <div class="text-center">&copy; MEASI Institute of Information Technology 2026</div>
    </div>
</footer>

<script>
function filterMembers() {
    var search  = document.getElementById('searchInput').value.toLowerCase();
    var batch   = document.getElementById('batchFilter').value.toLowerCase();
    var items   = document.querySelectorAll('.member-item');
    var visible = 0;

    items.forEach(function(item) {
        var nameMatch    = item.dataset.name.includes(search);
        var roleMatch    = item.dataset.role.includes(search);
        var companyMatch = item.dataset.company.includes(search);
        var batchMatch   = !batch || item.dataset.batch.toLowerCase() === batch;
        var textMatch    = nameMatch || roleMatch || companyMatch;

        if (textMatch && batchMatch) {
            item.style.display = '';
            visible++;
        } else {
            item.style.display = 'none';
        }
    });

    document.getElementById('visibleCount').textContent = visible;
    var noMsg = document.getElementById('noResultsMsg');
    if (noMsg) noMsg.style.display = (visible === 0) ? 'block' : 'none';
}
</script>
</body>
</html>
