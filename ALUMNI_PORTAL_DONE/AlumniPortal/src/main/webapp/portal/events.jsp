<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.util.List, java.util.ArrayList" %>
<%@ page import="com.alumni.model.Event" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.time.LocalDate, java.time.format.DateTimeFormatter" %>
<%
    Map<String, String> settings = (Map<String, String>) request.getAttribute("settings");
    String siteName = "MEASI Alumni Web Portal";
    String logoPath = "assets/img/logoonly.PNG";
    String primaryColor = "#7a0f1b";
    if (settings != null) {
        if (settings.get("SITE_NAME") != null && !settings.get("SITE_NAME").trim().isEmpty()) siteName = settings.get("SITE_NAME");
        if (settings.get("LOGO_PATH") != null && !settings.get("LOGO_PATH").trim().isEmpty()) logoPath = settings.get("LOGO_PATH");
        if (settings.get("PRIMARY_COLOR") != null && !settings.get("PRIMARY_COLOR").trim().isEmpty()) primaryColor = settings.get("PRIMARY_COLOR");
    }
    List<Event> events = (List<Event>) request.getAttribute("events");
    List<Event> upcomingEvents = new ArrayList<>();
    List<Event> pastEvents     = new ArrayList<>();
    LocalDate today = LocalDate.now();
    if (events != null) {
        for (Event e : events) {
            boolean isPast = false;
            try {
                if (e.getEventDate() != null) {
                    // eventDate may be a java.sql.Date or a String; handle both
                    LocalDate eventDate = e.getEventDate().toLocalDate();
                    isPast = eventDate.isBefore(today);
                }
            } catch (Exception ex) { /* fallback: treat as upcoming */ }
            if (isPast) pastEvents.add(e);
            else upcomingEvents.add(e);
        }
    }
    int totalEvents    = (events != null) ? events.size() : 0;
    int upcomingCount  = upcomingEvents.size();
    int pastCount      = pastEvents.size();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Events | <%= siteName %></title>
    <%@ include file="../WEB-INF/views/common-head.jspf" %>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --brand-maroon: <%= primaryColor %>;
            --brand-green: #0b4b3b;
        }
        body { font-family: 'DM Sans', sans-serif; background: #f6f4f1; }

        /* ── PAGE HERO ── */
        .page-hero {
            background: linear-gradient(135deg, var(--brand-green) 0%, #073327 40%, #1a0508 100%);
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
            top: -80px; right: -80px;
            width: 420px; height: 420px;
            border-radius: 50%;
            background: radial-gradient(circle, rgba(255,213,79,0.08) 0%, transparent 70%);
            pointer-events: none;
        }
        .hero-content {
            position: relative;
            z-index: 2;
            text-align: center;
            color: #fff;
        }
        .hero-eyebrow {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: rgba(255,213,79,0.15);
            border: 1px solid rgba(255,213,79,0.35);
            color: #ffd54f;
            padding: 6px 20px;
            border-radius: 50px;
            font-size: 12px;
            font-weight: 700;
            letter-spacing: 2px;
            text-transform: uppercase;
            margin-bottom: 20px;
        }
        .page-hero h1 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(36px, 6vw, 62px);
            font-weight: 800;
            margin: 0 0 16px;
            line-height: 1.1;
        }
        .page-hero p {
            font-size: 17px;
            opacity: 0.75;
            max-width: 500px;
            margin: 0 auto 36px;
        }
        .hero-stats {
            display: flex;
            justify-content: center;
            gap: 36px;
            flex-wrap: wrap;
        }
        .hero-stat-box {
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 14px;
            padding: 18px 28px;
            text-align: center;
            min-width: 110px;
        }
        .hero-stat-box strong {
            display: block;
            font-family: 'Playfair Display', serif;
            font-size: 34px;
            color: #ffd54f;
            line-height: 1;
        }
        .hero-stat-box span {
            font-size: 12px;
            opacity: 0.7;
            letter-spacing: 0.5px;
            text-transform: uppercase;
            margin-top: 4px;
            display: block;
        }

        /* ── TABS ── */
        .events-tabs-wrap {
            background: #fff;
            border-bottom: 1px solid #e8e3dd;
            position: sticky;
            top: 100px;
            z-index: 100;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        }
        .events-tabs {
            display: flex;
            gap: 0;
        }
        .tab-btn {
            padding: 18px 32px;
            font-family: 'DM Sans', sans-serif;
            font-size: 15px;
            font-weight: 600;
            color: #888;
            background: none;
            border: none;
            border-bottom: 3px solid transparent;
            cursor: pointer;
            display: flex;
            align-items: center;
            gap: 8px;
            transition: color 0.2s, border-color 0.2s;
            white-space: nowrap;
        }
        .tab-btn:hover { color: var(--brand-maroon); }
        .tab-btn.active {
            color: var(--brand-maroon);
            border-bottom-color: var(--brand-maroon);
        }
        .tab-count {
            background: #f0ece6;
            color: #888;
            font-size: 12px;
            font-weight: 700;
            padding: 2px 9px;
            border-radius: 50px;
        }
        .tab-btn.active .tab-count {
            background: var(--brand-maroon);
            color: #fff;
        }

        /* ── EVENTS SECTION ── */
        .events-section { padding: 48px 0 80px; }

        /* ── SECTION HEADER ── */
        .section-hdr {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 32px;
        }
        .section-hdr-line {
            flex: 1;
            height: 1px;
            background: #e0dbd4;
        }
        .section-hdr h3 {
            font-family: 'Playfair Display', serif;
            font-size: 22px;
            color: var(--brand-maroon);
            font-weight: 700;
            margin: 0;
            white-space: nowrap;
        }

        /* ── EVENT CARD ── */
        .event-card {
            background: #fff;
            border-radius: 20px;
            overflow: hidden;
            box-shadow: 0 8px 30px rgba(0,0,0,0.07);
            transition: all 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
            height: 100%;
            display: flex;
            flex-direction: column;
            border: 1px solid rgba(0,0,0,0.04);
        }
        .event-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 50px rgba(11,75,59,0.15);
        }

        .event-img-wrap {
            position: relative;
            overflow: hidden;
        }
        .event-img-wrap img {
            width: 100%;
            height: 200px;
            object-fit: cover;
            display: block;
            transition: transform 0.5s ease;
        }
        .event-card:hover .event-img-wrap img { transform: scale(1.05); }
        .event-img-placeholder {
            width: 100%;
            height: 200px;
            background: linear-gradient(135deg, #f0ece6 0%, #e0d9d0 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 56px;
            color: #c5b9ae;
        }

        .event-date-badge {
            position: absolute;
            top: 14px;
            left: 14px;
            background: var(--brand-green);
            color: #fff;
            border-radius: 10px;
            padding: 8px 12px;
            text-align: center;
            min-width: 54px;
            box-shadow: 0 4px 16px rgba(0,0,0,0.25);
        }
        .event-date-badge .day   { font-size: 22px; font-weight: 800; line-height: 1; }
        .event-date-badge .month { font-size: 11px; font-weight: 600; letter-spacing: 0.5px; text-transform: uppercase; opacity: 0.85; }

        .past-ribbon {
            position: absolute;
            top: 14px;
            right: 14px;
            background: rgba(0,0,0,0.55);
            color: #fff;
            font-size: 11px;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 50px;
            letter-spacing: 0.5px;
        }
        .upcoming-ribbon {
            position: absolute;
            top: 14px;
            right: 14px;
            background: #ffd54f;
            color: #333;
            font-size: 11px;
            font-weight: 700;
            padding: 4px 12px;
            border-radius: 50px;
            letter-spacing: 0.5px;
        }

        .event-body {
            padding: 22px;
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        .event-title {
            font-family: 'Playfair Display', serif;
            font-size: 20px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 10px;
            line-height: 1.3;
        }
        .event-meta {
            display: flex;
            flex-direction: column;
            gap: 7px;
            margin-bottom: 14px;
        }
        .event-meta-row {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: #666;
        }
        .event-meta-row i {
            width: 18px;
            color: var(--brand-green);
            flex-shrink: 0;
        }
        .event-desc {
            font-size: 14px;
            color: #777;
            line-height: 1.6;
            flex: 1;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        .event-footer {
            margin-top: 18px;
            padding-top: 14px;
            border-top: 1px solid #f0ece6;
        }
        .event-cta-btn {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            font-size: 13px;
            font-weight: 700;
            color: var(--brand-maroon);
            text-decoration: none;
            transition: gap 0.2s;
        }
        .event-cta-btn:hover { gap: 10px; color: var(--brand-maroon); }

        /* Empty state */
        .empty-events {
            text-align: center;
            padding: 60px 20px;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        }
        .empty-events i { font-size: 64px; color: #ddd; margin-bottom: 16px; display: block; }
        .empty-events p { color: #aaa; font-size: 16px; }

        /* Tab content show/hide */
        .tab-pane { display: none; }
        .tab-pane.active { display: block; }

        /* Footer */
        .footer { background: var(--brand-green); color: #fff; }
        .footer a { color: #fff; text-decoration: none; }
        .footer a:hover { text-decoration: underline; }
    </style>
</head>
<body>

<%@ include file="../WEB-INF/views/common-header.jspf" %>

<!-- PAGE HERO -->
<div class="page-hero">
    <div class="container hero-content">
        <div class="hero-eyebrow"><i class="bi bi-calendar3"></i> Events &amp; Gatherings</div>
        <h1>Alumni Events</h1>
        <p>Reunions, seminars, and milestones that bring our community together.</p>
        <div class="hero-stats">
            <div class="hero-stat-box">
                <strong><%= totalEvents %></strong>
                <span>Total Events</span>
            </div>
            <div class="hero-stat-box">
                <strong><%= upcomingCount %></strong>
                <span>Upcoming</span>
            </div>
            <div class="hero-stat-box">
                <strong><%= pastCount %></strong>
                <span>Past</span>
            </div>
        </div>
    </div>
</div>

<!-- TABS -->
<div class="events-tabs-wrap">
    <div class="container">
        <div class="events-tabs">
            <button class="tab-btn active" onclick="switchTab('all', this)">
                <i class="bi bi-calendar-range"></i> All Events
                <span class="tab-count"><%= totalEvents %></span>
            </button>
            <button class="tab-btn" onclick="switchTab('upcoming', this)">
                <i class="bi bi-calendar-check"></i> Upcoming
                <span class="tab-count"><%= upcomingCount %></span>
            </button>
            <button class="tab-btn" onclick="switchTab('past', this)">
                <i class="bi bi-calendar-x"></i> Past Events
                <span class="tab-count"><%= pastCount %></span>
            </button>
        </div>
    </div>
</div>

<!-- EVENTS CONTENT -->
<section class="events-section">
    <div class="container">

        <!-- ALL TAB -->
        <div class="tab-pane active" id="tab-all">
            <% if (events != null && !events.isEmpty()) { %>
            <div class="row g-4">
                <%
                    for (Event e : events) {
                        String title = (e.getTitle() != null) ? e.getTitle() : "Untitled Event";
                        String desc  = (e.getDescription() != null) ? e.getDescription() : "";
                        String loc   = (e.getLocation() != null && !e.getLocation().isEmpty()) ? e.getLocation() : "TBD";
                        String imgPth= (e.getImagePath() != null && !e.getImagePath().isEmpty()) ? e.getImagePath() : "";
                        String dateStr  = (e.getEventDate() != null) ? e.getEventDate().toString() : "";
                        String dayNum   = "", monthStr = "", isPastCls = "upcoming-ribbon", isPastLbl = "Upcoming";
                        try {
                            if (e.getEventDate() != null) {
                                LocalDate ed = e.getEventDate().toLocalDate();
                                dayNum   = String.valueOf(ed.getDayOfMonth());
                                monthStr = ed.getMonth().toString().substring(0,3);
                                if (ed.isBefore(today)) { isPastCls = "past-ribbon"; isPastLbl = "Past"; }
                            }
                        } catch (Exception ex2) {}
                %>
                <div class="col-lg-4 col-md-6">
                    <div class="event-card">
                        <div class="event-img-wrap">
                            <% if (!imgPth.isEmpty()) { %>
                            <img src="<%=request.getContextPath()%>/<%=imgPth%>" alt="<%= title %>"
                                 onerror="this.parentElement.innerHTML='<div class=\'event-img-placeholder\'><i class=\'bi bi-calendar-event\'></i></div>'">
                            <% } else { %>
                            <div class="event-img-placeholder"><i class="bi bi-calendar-event"></i></div>
                            <% } %>
                            <% if (!dayNum.isEmpty()) { %>
                            <div class="event-date-badge">
                                <div class="day"><%= dayNum %></div>
                                <div class="month"><%= monthStr %></div>
                            </div>
                            <% } %>
                            <span class="<%= isPastCls %>"><%= isPastLbl %></span>
                        </div>
                        <div class="event-body">
                            <div class="event-title"><%= title %></div>
                            <div class="event-meta">
                                <% if (!dateStr.isEmpty()) { %>
                                <div class="event-meta-row"><i class="bi bi-calendar3"></i><%= dateStr %></div>
                                <% } %>
                                <div class="event-meta-row"><i class="bi bi-geo-alt"></i><%= loc %></div>
                            </div>
                            <% if (!desc.isEmpty()) { %>
                            <div class="event-desc"><%= desc %></div>
                            <% } %>
                            <div class="event-footer">
                                <span class="event-cta-btn">View Details <i class="bi bi-arrow-right"></i></span>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <% } else { %>
            <div class="empty-events">
                <i class="bi bi-calendar2-x"></i>
                <p>No events available yet. Stay tuned!</p>
            </div>
            <% } %>
        </div>

        <!-- UPCOMING TAB -->
        <div class="tab-pane" id="tab-upcoming">
            <% if (!upcomingEvents.isEmpty()) { %>
            <div class="row g-4">
                <%
                    for (Event e : upcomingEvents) {
                        String title = (e.getTitle() != null) ? e.getTitle() : "Untitled Event";
                        String desc  = (e.getDescription() != null) ? e.getDescription() : "";
                        String loc   = (e.getLocation() != null && !e.getLocation().isEmpty()) ? e.getLocation() : "TBD";
                        String imgPth= (e.getImagePath() != null && !e.getImagePath().isEmpty()) ? e.getImagePath() : "";
                        String dateStr  = (e.getEventDate() != null) ? e.getEventDate().toString() : "";
                        String dayNum = "", monthStr = "";
                        try {
                            if (e.getEventDate() != null) {
                                LocalDate ed = e.getEventDate().toLocalDate();
                                dayNum = String.valueOf(ed.getDayOfMonth());
                                monthStr = ed.getMonth().toString().substring(0,3);
                            }
                        } catch (Exception ex3) {}
                %>
                <div class="col-lg-4 col-md-6">
                    <div class="event-card">
                        <div class="event-img-wrap">
                            <% if (!imgPth.isEmpty()) { %>
                            <img src="<%=request.getContextPath()%>/<%=imgPth%>" alt="<%= title %>"
                                 onerror="this.parentElement.innerHTML='<div class=\'event-img-placeholder\'><i class=\'bi bi-calendar-event\'></i></div>'">
                            <% } else { %>
                            <div class="event-img-placeholder"><i class="bi bi-calendar-event"></i></div>
                            <% } %>
                            <% if (!dayNum.isEmpty()) { %>
                            <div class="event-date-badge">
                                <div class="day"><%= dayNum %></div>
                                <div class="month"><%= monthStr %></div>
                            </div>
                            <% } %>
                            <span class="upcoming-ribbon">Upcoming</span>
                        </div>
                        <div class="event-body">
                            <div class="event-title"><%= title %></div>
                            <div class="event-meta">
                                <% if (!dateStr.isEmpty()) { %>
                                <div class="event-meta-row"><i class="bi bi-calendar3"></i><%= dateStr %></div>
                                <% } %>
                                <div class="event-meta-row"><i class="bi bi-geo-alt"></i><%= loc %></div>
                            </div>
                            <% if (!desc.isEmpty()) { %>
                            <div class="event-desc"><%= desc %></div>
                            <% } %>
                            <div class="event-footer">
                                <span class="event-cta-btn">View Details <i class="bi bi-arrow-right"></i></span>
                            </div>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <% } else { %>
            <div class="empty-events">
                <i class="bi bi-calendar-check"></i>
                <p>No upcoming events at the moment. Check back soon!</p>
            </div>
            <% } %>
        </div>

        <!-- PAST TAB -->
        <div class="tab-pane" id="tab-past">
            <% if (!pastEvents.isEmpty()) { %>
            <div class="row g-4">
                <%
                    for (Event e : pastEvents) {
                        String title = (e.getTitle() != null) ? e.getTitle() : "Untitled Event";
                        String desc  = (e.getDescription() != null) ? e.getDescription() : "";
                        String loc   = (e.getLocation() != null && !e.getLocation().isEmpty()) ? e.getLocation() : "TBD";
                        String imgPth= (e.getImagePath() != null && !e.getImagePath().isEmpty()) ? e.getImagePath() : "";
                        String dateStr = (e.getEventDate() != null) ? e.getEventDate().toString() : "";
                        String dayNum = "", monthStr = "";
                        try {
                            if (e.getEventDate() != null) {
                                LocalDate ed = e.getEventDate().toLocalDate();
                                dayNum = String.valueOf(ed.getDayOfMonth());
                                monthStr = ed.getMonth().toString().substring(0,3);
                            }
                        } catch (Exception ex4) {}
                %>
                <div class="col-lg-4 col-md-6" style="opacity:0.85;">
                    <div class="event-card" style="filter:grayscale(15%)">
                        <div class="event-img-wrap">
                            <% if (!imgPth.isEmpty()) { %>
                            <img src="<%=request.getContextPath()%>/<%=imgPth%>" alt="<%= title %>"
                                 onerror="this.parentElement.innerHTML='<div class=\'event-img-placeholder\'><i class=\'bi bi-calendar-event\'></i></div>'">
                            <% } else { %>
                            <div class="event-img-placeholder"><i class="bi bi-calendar-event"></i></div>
                            <% } %>
                            <% if (!dayNum.isEmpty()) { %>
                            <div class="event-date-badge" style="background:#555">
                                <div class="day"><%= dayNum %></div>
                                <div class="month"><%= monthStr %></div>
                            </div>
                            <% } %>
                            <span class="past-ribbon">Past</span>
                        </div>
                        <div class="event-body">
                            <div class="event-title"><%= title %></div>
                            <div class="event-meta">
                                <% if (!dateStr.isEmpty()) { %>
                                <div class="event-meta-row"><i class="bi bi-calendar3"></i><%= dateStr %></div>
                                <% } %>
                                <div class="event-meta-row"><i class="bi bi-geo-alt"></i><%= loc %></div>
                            </div>
                            <% if (!desc.isEmpty()) { %>
                            <div class="event-desc"><%= desc %></div>
                            <% } %>
                        </div>
                    </div>
                </div>
                <% } %>
            </div>
            <% } else { %>
            <div class="empty-events">
                <i class="bi bi-calendar-x"></i>
                <p>No past events recorded yet.</p>
            </div>
            <% } %>
        </div>

    </div>
</section>

<!-- FOOTER -->
<footer id="contact" class="footer pt-5 pb-4">
    <div class="container">
        <div class="row g-4">
            <div class="col-md-6">
                <h3 class="fw-bold mb-4">Contact us</h3>
                <p class="fw-semibold mb-2">MEASI INSTITUTE OF INFORMATION TECHNOLOGY</p>
                <p class="mb-1">147 Peters Road, Royapettah, Chennai 600 014</p>
                <p class="mb-1">Mobile: +91 98403 61602 / +91 81229 85395</p>
                <p class="mb-1">E-Mail: info@measiit.edu.in</p>
            </div>
            <div class="col-md-6">
                <h3 class="fw-bold mb-4">Quick Links</h3>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="<%=request.getContextPath()%>/home">Home</a></li>
                    <li class="mb-2"><a href="<%=request.getContextPath()%>/members">Members</a></li>
                    <li class="mb-2"><a href="<%=request.getContextPath()%>/gallery">Gallery</a></li>
                    <li class="mb-2"><a href="<%=request.getContextPath()%>/events">Events</a></li>
                </ul>
            </div>
        </div>
        <hr class="border-light my-4">
        <div class="text-center">&copy; MEASI Institute of Information Technology 2026</div>
    </div>
</footer>

<script>
function switchTab(tabId, btn) {
    document.querySelectorAll('.tab-pane').forEach(p => p.classList.remove('active'));
    document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
    document.getElementById('tab-' + tabId).classList.add('active');
    btn.classList.add('active');
    window.scrollTo({ top: document.querySelector('.events-tabs-wrap').offsetTop - 20, behavior: 'smooth' });
}
</script>
</body>
</html>
