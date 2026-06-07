<%@ page import="java.util.Map"%>
<%@ page import="com.alumni.model.User"%>
<%
    Map<String, String> settings = (Map<String, String>) request.getAttribute("settings");

    String siteName    = "MEASI Alumni Web Portal";
    String aboutText   = "Welcome to the MEASI Alumni Web Portal.";
    String primaryColor = "#7a0f1b";
    String logoPath    = "assets/img/logoonly.PNG";

    if (settings != null) {
        if (settings.get("SITE_NAME")     != null && !settings.get("SITE_NAME").trim().isEmpty())     siteName     = settings.get("SITE_NAME");
        if (settings.get("ABOUT_TEXT")    != null && !settings.get("ABOUT_TEXT").trim().isEmpty())    aboutText    = settings.get("ABOUT_TEXT");
        if (settings.get("PRIMARY_COLOR") != null && !settings.get("PRIMARY_COLOR").trim().isEmpty()) primaryColor = settings.get("PRIMARY_COLOR");
        if (settings.get("LOGO_PATH")     != null && !settings.get("LOGO_PATH").trim().isEmpty())     logoPath     = settings.get("LOGO_PATH");
    }

    /* ── Check login state (session key = "user" from AlumniLoginServlet) ── */
    User currentUser = (User) session.getAttribute("user");
    boolean userLoggedIn = (currentUser != null);
%>
<!DOCTYPE html>
<html lang="en">
<head>
<title><%=siteName%></title>
<%@ include file="WEB-INF/views/common-head.jspf"%>

<style>
.hero-actions {
    display: flex;
    gap: 16px;
    flex-wrap: wrap;
    margin-top: 28px;
}
.hero-btn-primary {
    background: #ffffff !important;
    color: #7a0f1b !important;
    font-weight: 700;
    padding: 12px 28px;
    border-radius: 12px;
    border: none;
    box-shadow: 0 8px 20px rgba(0,0,0,0.16);
    text-decoration: none;
    display: inline-block;
    transition: background 0.2s, transform 0.2s;
}
.hero-btn-primary:hover {
    background: #f3f3f3 !important;
    color: #7a0f1b !important;
    transform: translateY(-2px);
}
.hero-btn-secondary {
    background: transparent !important;
    color: #ffffff !important;
    font-weight: 700;
    padding: 12px 28px;
    border-radius: 12px;
    border: 1.5px solid rgba(255,255,255,0.75);
    text-decoration: none;
    display: inline-block;
    transition: background 0.2s, transform 0.2s;
}
.hero-btn-secondary:hover {
    background: rgba(255,255,255,0.12) !important;
    color: #ffffff !important;
    transform: translateY(-2px);
}
:root {
    --brand-maroon: <%=primaryColor%>;
    --brand-green: #0b4b3b;
}
.hero-banner {
    background:
        linear-gradient(rgba(122,15,27,0.45), rgba(11,75,59,0.30)),
        url('<%=request.getContextPath()%>/assets/img/hero.png') center center/cover no-repeat;
}

/* Hide scrollbar only */
html, body {
    overflow-x: hidden;
    scrollbar-width: none;      /* Firefox */
    -ms-overflow-style: none;   /* IE/Edge */
}

body::-webkit-scrollbar,
html::-webkit-scrollbar {
    display: none;              /* Chrome, Safari */
}

</style>
</head>
<body>

<%@ include file="WEB-INF/views/common-header.jspf"%>

<!-- ── HERO BANNER ── -->
<section id="home" class="hero-banner">
    <div class="hero-overlay"></div>
    <div class="container hero-content-wrap">
        <div class="hero-box">
            <span class="hero-tag">MEASI INSTITUTE OF INFORMATION TECHNOLOGY</span>
            <h1 class="hero-title">Welcome to the <br>Alumni Web Portal</h1>
            <p class="hero-subtitle">
                Connecting alumni, celebrating achievements, and building
                a stronger professional network together.
            </p>
            <div class="hero-actions">
                <% if (!userLoggedIn) { %>
                <!-- Only shown to guests -->
                <a href="<%=request.getContextPath()%>/auth/login.jsp"
                   class="btn hero-btn-primary">
                    Become an Alumni
                </a>
                <% } %>
                <a href="<%=request.getContextPath()%>/members"
                   class="btn hero-btn-secondary">
                    Explore Members
                </a>
            </div>
        </div>
    </div>
</section>

<!-- ── CAROUSEL ── -->
<div class="container my-4">
    <div id="homeCarousel" class="carousel slide" data-bs-ride="carousel">
        <div class="carousel-inner rounded-3 overflow-hidden shadow">
            <div class="carousel-item active">
                <img src="https://picsum.photos/1200/420?random=11" class="d-block w-100" alt="slide1">
            </div>
            <div class="carousel-item">
                <img src="https://picsum.photos/1200/420?random=12" class="d-block w-100" alt="slide2">
            </div>
            <div class="carousel-item">
                <img src="https://picsum.photos/1200/420?random=13" class="d-block w-100" alt="slide3">
            </div>
        </div>
        <button class="carousel-control-prev" type="button" data-bs-target="#homeCarousel" data-bs-slide="prev">
            <span class="carousel-control-prev-icon"></span>
        </button>
        <button class="carousel-control-next" type="button" data-bs-target="#homeCarousel" data-bs-slide="next">
            <span class="carousel-control-next-icon"></span>
        </button>
    </div>
</div>

<!-- ── ABOUT ── -->
<section id="about" class="content-section bg-light">
    <div class="container">
        <h2 class="section-title">About Us</h2>
        <p><%=aboutText%></p>
    </div>
</section>

<!-- ── MEMBERS ── -->
<section id="members" class="content-section">
    <div class="container">
        <h2 class="section-title">Members</h2>
        <p>Approved alumni members will be displayed here in card format.</p>
    </div>
</section>

<!-- ── GALLERY ── -->
<section id="gallery" class="content-section bg-light">
    <div class="container">
        <h2 class="section-title">Gallery</h2>
        <p>Gallery images uploaded by the admin will be displayed here.</p>
    </div>
</section>

<!-- ── EVENTS ── -->
<section id="events" class="content-section">
    <div class="container">
        <h2 class="section-title">Events</h2>
        <p>Upcoming and past alumni events will be shown in this section.</p>
    </div>
</section>

<!-- ── FOOTER ── -->
<footer id="contact" class="footer pt-5 pb-4">
    <div class="container">
        <div class="row g-4">
            <div class="col-md-6">
                <h3 class="fw-bold mb-4">Contact us</h3>
                <p class="fw-semibold mb-2">MEASI INSTITUTE OF INFORMATION TECHNOLOGY</p>
                <p class="mb-1">147 Peters Road, Royapettah</p>
                <p class="mb-1">Chennai 600 014</p>
                <p class="mb-1">Mobile: +91 98403 61602 / +91 81229 85395</p>
                <p class="mb-1">Landline: 044 2835 2374</p>
                <p class="mb-1">E-Mail: info@measiit.edu.in</p>
            </div>
            <div class="col-md-6">
                <h3 class="fw-bold mb-4">Quick Links</h3>
                <ul class="list-unstyled">
                    <li class="mb-2"><a href="#home">Home</a></li>
                    <li class="mb-2"><a href="#about">About</a></li>
                    <li class="mb-2"><a href="<%=request.getContextPath()%>/members">Members</a></li>
                    <li class="mb-2"><a href="<%=request.getContextPath()%>/gallery">Gallery</a></li>
                    <li class="mb-2"><a href="<%=request.getContextPath()%>/events">Events</a></li>
                    <li class="mb-2"><a href="#contact">Contact</a></li>
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
document.querySelectorAll('a[href^="#"]').forEach(function(link) {
    link.addEventListener('click', function(e) {
        var href   = this.getAttribute('href');
        var target = document.querySelector(href);
        if (target) {
            e.preventDefault();
            target.scrollIntoView({ behavior: 'smooth' });
        }
    });
});
window.addEventListener("scroll", function () {
    var navbar = document.getElementById("mainNavbar");
    if (navbar) {
        if (window.scrollY > 60) navbar.classList.add("shrink");
        else                      navbar.classList.remove("shrink");
    }
});
</script>
</body>
</html>
