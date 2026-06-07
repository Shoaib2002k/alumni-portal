<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.alumni.model.Gallery" %>
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
    List<Gallery> images = (List<Gallery>) request.getAttribute("images");
    int totalImages = (images != null) ? images.size() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Gallery | <%= siteName %></title>
    <%@ include file="../WEB-INF/views/common-head.jspf" %>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --brand-maroon: <%= primaryColor %>;
            --brand-green : #0b4b3b;
        }
        body { font-family: 'DM Sans', sans-serif; background: #f6f4f1; }

        /* PAGE HERO - same pattern as events.jsp */
        .page-hero {
            background: linear-gradient(135deg, var(--brand-green) 0%, #073327 40%, #1a0508 100%);
            padding: 68px 0 80px;
            position: relative; overflow: hidden;
        }
        .page-hero::after {
            content: '';
            position: absolute; bottom: -2px; left: 0; right: 0;
            height: 60px; background: #f6f4f1;
            clip-path: ellipse(60% 100% at 50% 100%);
        }
        .page-hero::before {
            content: '';
            position: absolute; top: -80px; right: -80px;
            width: 420px; height: 420px; border-radius: 50%;
            background: radial-gradient(circle, rgba(255,213,79,0.08) 0%, transparent 70%);
            pointer-events: none;
        }
        .hero-content {
            position: relative; z-index: 2;
            text-align: center; color: #fff;
        }
        .hero-eyebrow {
            display: inline-flex; align-items: center; gap: 8px;
            background: rgba(255,213,79,0.15);
            border: 1px solid rgba(255,213,79,0.35);
            color: #ffd54f; padding: 6px 20px; border-radius: 50px;
            font-size: 12px; font-weight: 700;
            letter-spacing: 2px; text-transform: uppercase;
            margin-bottom: 20px;
        }
        .page-hero h1 {
            font-family: 'Playfair Display', serif;
            font-size: clamp(36px, 6vw, 62px);
            font-weight: 800; margin: 0 0 16px; line-height: 1.1;
        }
        .hero-subtitle {
            font-size: 17px; opacity: 0.75;
            max-width: 500px; margin: 0 auto 36px;
        }
        /* stat boxes - identical to events.jsp */
        .hero-stats {
            display: flex; justify-content: center;
            gap: 36px; flex-wrap: wrap;
        }
        .hero-stat-box {
            background: rgba(255,255,255,0.10);
            border: 1px solid rgba(255,255,255,0.15);
            border-radius: 14px; padding: 18px 28px;
            text-align: center; min-width: 110px;
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

        /* STICKY TOOLBAR - mirrors events tab bar */
        .gallery-toolbar {
            background: #fff;
            border-bottom: 1px solid #e8e3dd;
            position: sticky; top: 100px; z-index: 100;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        }
        .toolbar-inner {
            display: flex; align-items: center;
            gap: 12px; flex-wrap: wrap;
            padding: 14px 0;
            justify-content: space-between;
        }
        .search-wrap {
            position: relative; flex: 1;
            min-width: 220px; max-width: 360px;
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
        .view-toggle { display: flex; gap: 6px; }
        .view-btn {
            width: 38px; height: 38px; border-radius: 8px;
            background: #f5f0eb; border: 1.5px solid #e0dbd4;
            color: #999; display: flex; align-items: center;
            justify-content: center; cursor: pointer;
            transition: all 0.2s; font-size: 16px;
        }
        .view-btn.active, .view-btn:hover {
            background: var(--brand-maroon);
            border-color: var(--brand-maroon); color: #fff;
        }

        /* GALLERY GRID - same card style as events */
        .gallery-section { padding: 48px 0 80px; }

        .gallery-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(280px, 1fr));
            gap: 20px;
        }
        /* list view */
        .gallery-grid.list-view { grid-template-columns: 1fr; }
        .gallery-grid.list-view .gallery-card { display: flex; flex-direction: row; height: 140px; }
        .gallery-grid.list-view .gallery-img-wrap { width: 200px; flex-shrink: 0; height: 100%; aspect-ratio: unset; }
        .gallery-grid.list-view .gallery-img-wrap img { height: 100%; }
        .gallery-grid.list-view .gallery-card-body { display: flex; align-items: center; }
        .gallery-grid.list-view .gallery-card-body h6 { font-size: 17px; }

        /* gallery card - same radius/shadow/hover as event-card */
        .gallery-card {
            background: #fff;
            border-radius: 20px; overflow: hidden;
            box-shadow: 0 8px 30px rgba(0,0,0,0.07);
            transition: all 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
            border: 1px solid rgba(0,0,0,0.04); cursor: pointer;
        }
        .gallery-card:hover {
            transform: translateY(-6px);
            box-shadow: 0 20px 50px rgba(11,75,59,0.15);
        }
        .gallery-img-wrap { overflow: hidden; aspect-ratio: 4/3; position: relative; }
        .gallery-img-wrap img {
            width: 100%; height: 100%; object-fit: cover;
            display: block; transition: transform 0.5s ease;
        }
        .gallery-card:hover .gallery-img-wrap img { transform: scale(1.05); }

        /* hover overlay */
        .gallery-overlay {
            position: absolute; inset: 0;
            background: linear-gradient(to top, rgba(0,0,0,0.7) 0%, transparent 60%);
            opacity: 0; transition: opacity 0.35s ease;
            display: flex; align-items: center; justify-content: center;
        }
        .gallery-card:hover .gallery-overlay { opacity: 1; }
        .zoom-btn {
            width: 52px; height: 52px;
            background: rgba(255,255,255,0.15);
            backdrop-filter: blur(8px);
            border: 1px solid rgba(255,255,255,0.3);
            border-radius: 50%; display: flex;
            align-items: center; justify-content: center;
            color: #fff; font-size: 22px;
            transform: scale(0.8); opacity: 0;
            transition: all 0.3s ease;
        }
        .gallery-card:hover .zoom-btn { transform: scale(1); opacity: 1; }

        .gallery-card-body { padding: 16px 20px 20px; }
        .gallery-card-body h6 {
            font-family: 'Playfair Display', serif;
            font-size: 16px; font-weight: 700;
            color: #1a1a1a; margin: 0 0 6px;
            white-space: nowrap; overflow: hidden; text-overflow: ellipsis;
        }
        /* same as event-cta-btn */
        .gallery-cta {
            display: inline-flex; align-items: center; gap: 6px;
            font-size: 13px; font-weight: 700;
            color: var(--brand-maroon); transition: gap 0.2s;
            text-decoration: none;
        }
        .gallery-cta:hover { gap: 10px; color: var(--brand-maroon); }

        /* empty state - same as events */
        .empty-gallery {
            text-align: center; padding: 60px 20px;
            background: #fff; border-radius: 20px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
        }
        .empty-gallery i { font-size: 64px; color: #ddd; margin-bottom: 16px; display: block; }
        .empty-gallery p { color: #aaa; font-size: 16px; }

        #noGalleryMsg { display: none; text-align: center; padding: 24px 0; color: #999; font-size: 15px; }

        /* LIGHTBOX */
        .lightbox-overlay {
            display: none; position: fixed; inset: 0;
            background: rgba(0,0,0,0.93); z-index: 9999;
            align-items: center; justify-content: center;
            padding: 20px; backdrop-filter: blur(4px);
        }
        .lightbox-overlay.active { display: flex; }
        .lightbox-inner {
            position: relative; max-width: 92vw; max-height: 90vh;
            display: flex; flex-direction: column; align-items: center;
        }
        .lightbox-img {
            max-width: 90vw; max-height: 78vh;
            border-radius: 12px; object-fit: contain;
            box-shadow: 0 30px 80px rgba(0,0,0,0.8);
            transition: opacity 0.3s;
        }
        .lightbox-caption {
            margin-top: 18px; font-size: 17px; font-weight: 600;
            color: #e0e0e0; text-align: center;
            font-family: 'Playfair Display', serif;
        }
        .lightbox-close {
            position: fixed; top: 20px; right: 24px;
            width: 46px; height: 46px;
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 50%; display: flex;
            align-items: center; justify-content: center;
            color: #fff; font-size: 20px; cursor: pointer;
            transition: background 0.2s; z-index: 10000;
        }
        .lightbox-close:hover { background: rgba(255,255,255,0.22); }
        .lightbox-nav {
            position: fixed; top: 50%; transform: translateY(-50%);
            width: 50px; height: 50px;
            background: rgba(255,255,255,0.1);
            border: 1px solid rgba(255,255,255,0.2);
            border-radius: 50%; display: flex;
            align-items: center; justify-content: center;
            color: #fff; font-size: 20px; cursor: pointer;
            transition: background 0.2s; z-index: 10000;
        }
        .lightbox-nav:hover { background: rgba(255,255,255,0.22); }
        .lightbox-prev { left: 16px; }
        .lightbox-next { right: 16px; }
        .lightbox-counter {
            position: fixed; bottom: 24px; left: 50%; transform: translateX(-50%);
            background: rgba(0,0,0,0.5);
            border: 1px solid rgba(255,255,255,0.15);
            padding: 6px 18px; border-radius: 50px;
            font-size: 13px; color: #ccc; z-index: 10000;
        }

        /* FOOTER */
        .footer { background: var(--brand-green); color: #fff; }
        .footer a { color: #fff; text-decoration: none; }
        .footer a:hover { text-decoration: underline; }
        .footer .social-btn {
            width: 42px; height: 42px; border-radius: 8px;
            display: inline-flex; align-items: center; justify-content: center;
            border: 1px solid rgba(255,255,255,0.35); color: #fff; text-decoration: none;
        }

        @media (max-width: 767px) {
            .gallery-grid { grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); gap: 12px; }
            .lightbox-nav { display: none; }
            .toolbar-inner { flex-direction: column; align-items: stretch; }
            .search-wrap { max-width: 100%; }
        }
    </style>
</head>
<body>

<%@ include file="../WEB-INF/views/common-header.jspf" %>

<!-- PAGE HERO -->
<div class="page-hero">
    <div class="container">
        <div class="hero-content">
            <div class="hero-eyebrow"><i class="bi bi-images"></i> Memories &amp; Moments</div>
            <h1>Photo Gallery</h1>
            <p class="hero-subtitle">Relive the moments that define the MEASI alumni spirit — events, reunions, and milestones.</p>
            <div class="hero-stats">
                <div class="hero-stat-box">
                    <strong><%= totalImages %></strong>
                    <span>Photos</span>
                </div>
                <div class="hero-stat-box">
                    <strong><i class="bi bi-calendar-event" style="font-size:28px;"></i></strong>
                    <span>Events</span>
                </div>
                <div class="hero-stat-box">
                    <strong><i class="bi bi-heart-fill" style="font-size:26px;"></i></strong>
                    <span>Memories</span>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- STICKY TOOLBAR -->
<div class="gallery-toolbar">
    <div class="container">
        <div class="toolbar-inner">
            <div class="search-wrap">
                <i class="bi bi-search"></i>
                <input type="text" id="gallerySearch"
                       placeholder="Search photos by title..."
                       oninput="filterGallery()">
            </div>
            <div class="view-toggle">
                <div class="view-btn active" id="gridViewBtn"
                     onclick="setView('grid')" title="Grid View">
                    <i class="bi bi-grid-3x3-gap-fill"></i>
                </div>
                <div class="view-btn" id="listViewBtn"
                     onclick="setView('list')" title="List View">
                    <i class="bi bi-list-ul"></i>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- GALLERY GRID -->
<section class="gallery-section">
    <div class="container">

        <% if (images != null && !images.isEmpty()) { %>
        <div class="gallery-grid" id="galleryGrid">
            <%
                int gIdx = 0;
                for (Gallery g : images) {
                    String gTitle = "Untitled";
                    if (g.getTitle() != null && !g.getTitle().trim().isEmpty()) {
                        gTitle = g.getTitle();
                    }
                    String gImgPath = "";
                    if (g.getImagePath() != null) {
                        gImgPath = g.getImagePath();
                    }
                    String gFullSrc = request.getContextPath() + "/" + gImgPath;
            %>
            <div class="gallery-card"
                 data-index="<%= gIdx %>"
                 data-title="<%= gTitle.toLowerCase() %>"
                 onclick="openLightbox(<%= gIdx %>)">
                <div class="gallery-img-wrap">
                    <img src="<%= gFullSrc %>"
                         alt="<%= gTitle %>"
                         loading="lazy"
                         onerror="this.src='https://placehold.co/400x300/f0ece6/c5b9ae?text=No+Image'">
                    <div class="gallery-overlay">
                        <div class="zoom-btn"><i class="bi bi-zoom-in"></i></div>
                    </div>
                </div>
                <div class="gallery-card-body">
                    <h6><%= gTitle %></h6>
                    <span class="gallery-cta">View Full <i class="bi bi-arrow-right"></i></span>
                </div>
            </div>
            <%
                    gIdx++;
                }
            %>
        </div>
        <p id="noGalleryMsg">No photos match your search.</p>

        <% } else { %>
        <div class="empty-gallery">
            <i class="bi bi-images"></i>
            <p>No gallery images available yet. Check back soon!</p>
        </div>
        <% } %>

    </div>
</section>

<!-- LIGHTBOX -->
<div class="lightbox-overlay" id="lightboxOverlay" onclick="closeLightboxOnBg(event)">
    <div class="lightbox-close" onclick="closeLightbox()"><i class="bi bi-x-lg"></i></div>
    <div class="lightbox-nav lightbox-prev" onclick="navigateLightbox(-1)"><i class="bi bi-chevron-left"></i></div>
    <div class="lightbox-nav lightbox-next" onclick="navigateLightbox(1)"><i class="bi bi-chevron-right"></i></div>
    <div class="lightbox-inner">
        <img class="lightbox-img" id="lightboxImg" src="" alt="">
        <div class="lightbox-caption" id="lightboxCaption"></div>
    </div>
    <div class="lightbox-counter" id="lightboxCounter"></div>
</div>

<!-- FOOTER -->
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

<!-- JAVASCRIPT -->
<script>
/*
 * Build galleryData array from server-side image list.
 * Each entry: { src: "...", title: "..." }
 * All string building is done inside JSP scriptlets so variables
 * never cross scriptlet block boundaries.
 */
var galleryData = [
<%
    if (images != null && !images.isEmpty()) {
        int jsLen = images.size();
        int jsI   = 0;
        for (Gallery jsG : images) {
            String jsSrc   = request.getContextPath() + "/";
            if (jsG.getImagePath() != null) {
                jsSrc += jsG.getImagePath();
            }
            String jsLabel = "Untitled";
            if (jsG.getTitle() != null && !jsG.getTitle().trim().isEmpty()) {
                /* Escape single quotes and backslashes to keep JS string safe */
                jsLabel = jsG.getTitle()
                             .replace("\\", "\\\\")
                             .replace("'",  "\\'");
            }
            jsI++;
%>
    { src: '<%= jsSrc %>', title: '<%= jsLabel %>' }<%= (jsI < jsLen) ? "," : "" %>
<%
        }
    }
%>
];

var currentIdx = 0;

function openLightbox(idx) {
    currentIdx = idx;
    updateLightbox();
    document.getElementById('lightboxOverlay').classList.add('active');
    document.body.style.overflow = 'hidden';
}
function closeLightbox() {
    document.getElementById('lightboxOverlay').classList.remove('active');
    document.body.style.overflow = '';
}
function closeLightboxOnBg(e) {
    if (e.target === document.getElementById('lightboxOverlay')) {
        closeLightbox();
    }
}
function navigateLightbox(dir) {
    currentIdx = (currentIdx + dir + galleryData.length) % galleryData.length;
    updateLightbox();
}
function updateLightbox() {
    var item = galleryData[currentIdx];
    var img  = document.getElementById('lightboxImg');
    img.style.opacity = 0;
    setTimeout(function () {
        img.src = item.src;
        img.onload = function () { img.style.opacity = 1; };
    }, 120);
    document.getElementById('lightboxCaption').textContent = item.title;
    document.getElementById('lightboxCounter').textContent =
        (currentIdx + 1) + ' / ' + galleryData.length;
}

/* Keyboard navigation */
document.addEventListener('keydown', function (e) {
    var lb = document.getElementById('lightboxOverlay');
    if (!lb.classList.contains('active')) return;
    if (e.key === 'ArrowLeft')  navigateLightbox(-1);
    if (e.key === 'ArrowRight') navigateLightbox(1);
    if (e.key === 'Escape')     closeLightbox();
});

/* View toggle: grid / list */
function setView(mode) {
    var grid = document.getElementById('galleryGrid');
    if (!grid) return;
    if (mode === 'list') {
        grid.classList.add('list-view');
        document.getElementById('listViewBtn').classList.add('active');
        document.getElementById('gridViewBtn').classList.remove('active');
    } else {
        grid.classList.remove('list-view');
        document.getElementById('gridViewBtn').classList.add('active');
        document.getElementById('listViewBtn').classList.remove('active');
    }
}

/* Search / filter */
function filterGallery() {
    var q       = document.getElementById('gallerySearch').value.toLowerCase();
    var cards   = document.querySelectorAll('.gallery-card');
    var visible = 0;
    cards.forEach(function (card) {
        var match = card.dataset.title.includes(q);
        card.style.display = match ? '' : 'none';
        if (match) visible++;
    });
    var msg = document.getElementById('noGalleryMsg');
    if (msg) msg.style.display = (visible === 0 && q !== '') ? 'block' : 'none';
}
</script>
</body>
</html>
