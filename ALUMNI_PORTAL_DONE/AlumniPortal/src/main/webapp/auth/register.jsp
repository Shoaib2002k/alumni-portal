<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Alumni Registration | MEASI Alumni Portal</title>
    <%@ include file="../WEB-INF/views/common-head.jspf" %>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800;900&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { box-sizing: border-box; }
        body {
            min-height: 100vh; margin: 0;
            font-family: 'DM Sans', sans-serif;
            background:
                linear-gradient(135deg, rgba(60,0,20,0.65), rgba(255,180,90,0.30), rgba(0,70,60,0.55)),
                url('<%=request.getContextPath()%>/assets/img/register-bg.png') center center/cover no-repeat fixed;
            overflow-x: hidden;
        }
        body::before {
            content: "";
            position: fixed; inset: 0;
            background:
                radial-gradient(circle at 15% 20%, rgba(255,90,90,0.22), transparent 25%),
                radial-gradient(circle at 85% 12%, rgba(255,220,140,0.22), transparent 28%),
                radial-gradient(circle at 70% 85%, rgba(80,255,180,0.18), transparent 25%),
                linear-gradient(120deg, rgba(90,0,25,0.35), rgba(255,190,120,0.10), rgba(0,50,45,0.30));
            z-index: 0;
        }
        .page-shell {
            position: relative; z-index: 1;
            min-height: 100vh;
            display: flex; align-items: center; justify-content: center;
            padding: 32px;
        }
        .main-glass-card {
            width: 100%; max-width: 1300px;
            border-radius: 28px;
            border: 1px solid rgba(255,255,255,0.22);
            background: rgba(255,255,255,0.08);
            backdrop-filter: blur(10px);
            box-shadow: 0 18px 50px rgba(0,0,0,0.22);
            display: grid;
            grid-template-columns: 1fr 1.2fr;
            gap: 28px; padding: 34px;
        }
        /* LEFT PANEL */
        .left-panel {
            color: #fff7f2;
            display: flex; flex-direction: column; justify-content: flex-start;
            padding: 18px 10px 18px 18px;
        }
        .brand-block {
            display: flex; align-items: center; gap: 14px; margin-bottom: 32px;
        }
        .brand-logo-img {
            width: 58px; height: 58px; border-radius: 12px;
            background: rgba(255,255,255,0.92);
            padding: 5px; object-fit: contain;
            box-shadow: 0 6px 18px rgba(0,0,0,0.22);
        }
        .brand-text h4 { margin: 0; font-size: 18px; font-weight: 800; }
        .brand-text p  { margin: 2px 0 0; font-size: 14px; color: rgba(255,255,255,0.8); }
        .hero-title {
            font-family: 'Playfair Display', serif;
            font-size: 56px; line-height: 1.05; font-weight: 900;
            margin-bottom: 18px; color: #fff6f0;
            text-shadow: 0 4px 18px rgba(0,0,0,0.15);
        }
        .hero-subtitle {
            max-width: 440px; font-size: 17px; line-height: 1.7;
            color: rgba(255,247,242,0.9); margin-bottom: 40px;
        }
        .feature-list { display: flex; flex-direction: column; gap: 18px; }
        .feature-item { display: flex; align-items: center; gap: 14px; color: #fff8f5; font-size: 16px; }
        .feature-icon {
            width: 38px; height: 38px; border-radius: 50%;
            background: rgba(255,205,90,0.14);
            border: 2px solid rgba(255,220,120,0.6);
            display: flex; align-items: center; justify-content: center;
            flex-shrink: 0;
        }
        .feature-icon i { color: #f6d84f; font-size: 17px; }
        /* FORM PANEL */
        .form-panel-wrap { display: flex; align-items: center; justify-content: center; }
        .form-panel {
            width: 100%;
            background: rgba(255,248,243,0.82);
            border: 1px solid rgba(255,255,255,0.55);
            border-radius: 26px;
            box-shadow: 0 18px 38px rgba(0,0,0,0.18);
            padding: 24px 26px 28px;
            position: relative; overflow: hidden;
        }
        .form-panel::before {
            content: "";
            position: absolute; left: 0; top: 0;
            width: 100%; height: 4px;
            background: linear-gradient(90deg, #d5892d, #bf2c1f, #dfb057);
        }
        .page-title {
            font-family: 'Playfair Display', serif;
            color: #8a111c; font-weight: 900; font-size: 26px;
            margin-bottom: 20px; text-align: left;
        }
        .form-label { font-weight: 700; color: #4c4c4c; margin-bottom: 5px; font-size: 13px; }

        /* Standard inputs */
        .form-control, .form-select {
            height: 42px; border-radius: 8px;
            border: 1.5px solid #d5d5d5; box-shadow: none;
            background: rgba(255,255,255,0.92);
            font-family: 'DM Sans', sans-serif; font-size: 13px;
        }
        .form-control:focus, .form-select:focus {
            border-color: #b5252f;
            box-shadow: 0 0 0 3px rgba(181,37,47,0.1);
        }
        input[type="file"].form-control { height: auto; padding: 8px 12px; }
        textarea.form-control { height: auto; }

        /* ── SEARCHABLE DROPDOWN COMPONENT ── */
        .dd-wrap { position: relative; }
        .dd-input {
            width: 100%; height: 42px;
            padding: 0 38px 0 12px;
            border: 1.5px solid #d5d5d5; border-radius: 8px;
            background: rgba(255,255,255,0.92);
            font-family: 'DM Sans', sans-serif; font-size: 13px;
            cursor: pointer; outline: none;
            transition: border-color .2s;
        }
        .dd-input:focus { border-color: #b5252f; box-shadow: 0 0 0 3px rgba(181,37,47,0.1); }
        .dd-arrow {
            position: absolute; right: 12px; top: 50%;
            transform: translateY(-50%) rotate(0deg);
            color: #999; font-size: 12px; pointer-events: none;
            transition: transform .2s;
        }
        .dd-wrap.open .dd-arrow { transform: translateY(-50%) rotate(180deg); }
        .dd-list {
            display: none; position: absolute; top: calc(100% + 4px); left: 0; right: 0;
            background: #fff; border: 1.5px solid #d5d5d5; border-radius: 10px;
            box-shadow: 0 8px 28px rgba(0,0,0,0.14); z-index: 9999;
            max-height: 230px; overflow-y: auto;
        }
        .dd-wrap.open .dd-list { display: block; }
        .dd-search {
            padding: 8px 10px; border-bottom: 1px solid #f0ece6;
            position: sticky; top: 0; background: #fff;
        }
        .dd-search input {
            width: 100%; padding: 7px 10px; border: 1.5px solid #e0dbd4;
            border-radius: 7px; font-size: 13px; outline: none;
            font-family: 'DM Sans', sans-serif;
        }
        .dd-search input:focus { border-color: #b5252f; }
        .dd-option {
            padding: 9px 14px; font-size: 13px; cursor: pointer;
            color: #333; transition: background .15s;
        }
        .dd-option:hover { background: #fdf0f1; color: #7a0f1b; }
        .dd-option.selected { background: #fdf0f1; color: #7a0f1b; font-weight: 700; }
        .dd-empty { padding: 12px 14px; color: #aaa; font-size: 13px; }
        /* hidden real select */
        .dd-hidden { display: none !important; }

        /* PASSWORD */
        .password-wrapper { position: relative; }
        .toggle-password {
            position: absolute; top: 50%; right: 12px;
            transform: translateY(-50%); cursor: pointer;
            color: #6c757d; font-size: 17px; z-index: 3;
        }
        .toggle-password:hover { color: #7a0f1b; }

        /* BUTTONS */
        .btn-register {
            background: linear-gradient(180deg, #c42a2e, #9f1822);
            border: none; color: #fff; padding: 11px 24px;
            border-radius: 9px; font-weight: 700; font-size: 14px;
            box-shadow: 0 6px 14px rgba(159,24,34,0.22);
            cursor: pointer; transition: background .2s;
        }
        .btn-register:hover { background: linear-gradient(180deg, #d03338, #8f121b); color: #fff; }
        .btn-login-link {
            background: linear-gradient(180deg, #1f5c57, #14433f);
            border: none; color: #fff; padding: 11px 24px;
            border-radius: 9px; font-weight: 700; font-size: 14px;
            box-shadow: 0 6px 14px rgba(20,67,63,0.22);
            text-decoration: none;
            display: inline-flex; align-items: center; gap: 6px;
            transition: background .2s;
        }
        .btn-login-link:hover { background: linear-gradient(180deg, #266b65, #123a37); color: #fff; }

        .section-divider {
            font-size: 11px; font-weight: 700; color: #aaa;
            text-transform: uppercase; letter-spacing: 1px;
            padding: 6px 0 4px; border-bottom: 1px solid #f0ece6;
            margin-bottom: 12px; margin-top: 4px;
        }

        @media(max-width:1100px){
            .main-glass-card{grid-template-columns:1fr;max-width:760px;}
            .hero-title{font-size:40px;}
            .left-panel{padding-right:0;}
        }
        @media(max-width:768px){
            .page-shell{padding:16px;}
            .main-glass-card{padding:18px;border-radius:20px;}
            .hero-title{font-size:32px;}
        }
    </style>
</head>
<body>
<div class="page-shell">
<div class="main-glass-card">

    <!-- LEFT -->
    <div class="left-panel">
        <div class="brand-block">
            <img src="<%=request.getContextPath()%>/assets/img/logoonly.PNG"
                 alt="MEASI Logo" class="brand-logo-img">
            <div class="brand-text">
                <h4>MEASI Alumni Portal</h4>
                <p>Institute of Information Technology</p>
            </div>
        </div>
        <div class="hero-title">Alumni<br>Registration</div>
        <div class="hero-subtitle">
            Sign up and reconnect with your alumni network.<br>
            Fill in your details to join the MEASI alumni community.
        </div>
        <div class="feature-list">
            <div class="feature-item">
                <div class="feature-icon"><i class="bi bi-check-lg"></i></div>
                <div><strong>Reconnect</strong> with old classmates</div>
            </div>
            <div class="feature-item">
                <div class="feature-icon"><i class="bi bi-check-lg"></i></div>
                <div><strong>Stay updated</strong> on alumni news and events</div>
            </div>
            <div class="feature-item">
                <div class="feature-icon"><i class="bi bi-check-lg"></i></div>
                <div><strong>Expand</strong> your professional network</div>
            </div>
        </div>
    </div>

    <!-- RIGHT FORM -->
    <div class="form-panel-wrap">
    <div class="form-panel">
        <h2 class="page-title">Create Your Account</h2>

        <%
            String errMsg = (String) request.getAttribute("error");
            String sucMsg = (String) request.getAttribute("success");
        %>
        <% if (errMsg != null) { %>
        <div class="alert alert-danger" style="border-radius:10px;font-size:13px;">
            <i class="bi bi-exclamation-circle-fill me-2"></i><%= errMsg %>
        </div>
        <% } %>
        <% if (sucMsg != null) { %>
        <div class="alert alert-success" style="border-radius:10px;font-size:13px;">
            <i class="bi bi-check-circle-fill me-2"></i><%= sucMsg %>
        </div>
        <% } %>

        <form method="post"
              action="<%=request.getContextPath()%>/register"
              enctype="multipart/form-data"
              onsubmit="return validateForm();">

            <!-- PERSONAL INFO -->
            <div class="section-divider"><i class="bi bi-person me-1"></i>Personal Information</div>
            <div class="row g-2">
                <div class="col-md-6">
                    <label class="form-label">Full Name *</label>
                    <input type="text" name="fullName" class="form-control" placeholder="Enter full name" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Age *</label>
                    <input type="number" name="age" class="form-control" min="16" max="100" placeholder="Age" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label">Phone *</label>
                    <input type="text" name="phone" class="form-control" placeholder="Mobile number" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Email *</label>
                    <input type="email" name="email" class="form-control" placeholder="your@email.com" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Place *</label>
                    <input type="text" name="place" class="form-control" placeholder="City / District" required>
                </div>
            </div>

            <!-- ACADEMIC INFO -->
            <div class="section-divider mt-3"><i class="bi bi-mortarboard me-1"></i>Academic Details</div>
            <div class="row g-2">
                <div class="col-md-6">
                    <label class="form-label">University Register No *</label>
                    <input type="text" name="universityRegNo" class="form-control" placeholder="Reg number" required>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Specialization *</label>
                    <select name="specialization" id="specialization" class="form-select"
                            onchange="toggleOtherSpec()" required>
                        <option value="">-- Select --</option>
                        <option>Java Development</option>
                        <option>Full Stack Development</option>
                        <option>Web Development</option>
                        <option>Software Engineering</option>
                        <option>Database Administration</option>
                        <option>Data Analytics</option>
                        <option>Data Science</option>
                        <option>Machine Learning</option>
                        <option>Artificial Intelligence</option>
                        <option>Cloud Computing</option>
                        <option>DevOps</option>
                        <option>Cyber Security</option>
                        <option>Mobile App Development</option>
                        <option>UI/UX Design</option>
                        <option>Testing / QA</option>
                        <option>Networking</option>
                        <option>System Administration</option>
                        <option>ERP / SAP</option>
                        <option>Business Analysis</option>
                        <option>Project Management</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="col-md-6" id="otherSpecBox" style="display:none;">
                    <label class="form-label">Enter Specialization *</label>
                    <input type="text" name="otherSpecialization" id="otherSpecInput"
                           class="form-control" placeholder="Type your specialization">
                </div>
            </div>

            <!-- PROFESSIONAL INFO -->
            <div class="section-divider mt-3"><i class="bi bi-briefcase me-1"></i>Professional Details</div>
            <div class="row g-2">

                <!-- Current Company — searchable dropdown + free text -->
                <div class="col-md-6">
                    <label class="form-label">Current Company</label>
                    <div class="dd-wrap" id="ddCompany">
                        <input type="text" class="dd-input" id="companyDisplay"
                               placeholder="Select or type company..."
                               autocomplete="off"
                               onfocus="openDD('ddCompany')"
                               oninput="filterDD('ddCompany','ddCompanyList',this.value); syncHidden('companyHidden',this.value);">
                        <i class="bi bi-chevron-down dd-arrow"></i>
                        <div class="dd-list" id="ddCompanyList">
                            <div class="dd-search">
                                <input type="text" placeholder="Search company..." id="ddCompanySearch"
                                       oninput="filterDD('ddCompany','ddCompanyList',this.value)">
                            </div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Infosys</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">TCS (Tata Consultancy Services)</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Wipro</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">HCL Technologies</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Tech Mahindra</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Cognizant</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Accenture</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Capgemini</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">IBM India</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Oracle</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">SAP India</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Microsoft</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Amazon (AWS)</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Google India</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Zoho Corporation</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Freshworks</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Hexaware Technologies</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Mphasis</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">L&amp;T Technology Services</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">NIIT Technologies</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Tata Elxsi</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">DXC Technology</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Virtusa</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Persistent Systems</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Mindtree</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">KPIT Technologies</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Sutherland Global Services</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">CSS Corp</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Larsen &amp; Toubro Infotech</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Unisys India</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Photon Infotech</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">EY (Ernst &amp; Young)</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Deloitte India</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">PwC India</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">KPMG India</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Startup / Own Business</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Freelancer</div>
                            <div class="dd-option" onclick="selectDD('ddCompany','companyDisplay','companyHidden',this)">Currently Not Working</div>
                        </div>
                    </div>
                    <input type="hidden" name="currentCompany" id="companyHidden">
                </div>

                <!-- Current Role — searchable dropdown + free text -->
                <div class="col-md-6">
                    <label class="form-label">Current Role</label>
                    <div class="dd-wrap" id="ddRole">
                        <input type="text" class="dd-input" id="roleDisplay"
                               placeholder="Select or type role..."
                               autocomplete="off"
                               onfocus="openDD('ddRole')"
                               oninput="filterDD('ddRole','ddRoleList',this.value); syncHidden('roleHidden',this.value);">
                        <i class="bi bi-chevron-down dd-arrow"></i>
                        <div class="dd-list" id="ddRoleList">
                            <div class="dd-search">
                                <input type="text" placeholder="Search role..." id="ddRoleSearch"
                                       oninput="filterDD('ddRole','ddRoleList',this.value)">
                            </div>
                            <!-- Engineering -->
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Software Engineer</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Senior Software Engineer</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Lead Engineer</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Principal Engineer</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Full Stack Developer</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Frontend Developer</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Backend Developer</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Java Developer</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Python Developer</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">React Developer</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Android Developer</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">iOS Developer</div>
                            <!-- Data -->
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Data Analyst</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Data Scientist</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Data Engineer</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">ML Engineer</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">AI Engineer</div>
                            <!-- DevOps / Cloud -->
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">DevOps Engineer</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Cloud Engineer</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Site Reliability Engineer</div>
                            <!-- QA -->
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">QA Engineer</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Test Lead</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Test Manager</div>
                            <!-- Design -->
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">UI/UX Designer</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Product Designer</div>
                            <!-- Management -->
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Project Manager</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Product Manager</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Scrum Master</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Business Analyst</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">System Analyst</div>
                            <!-- Infra / Network -->
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Network Engineer</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">System Administrator</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Database Administrator</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Cyber Security Analyst</div>
                            <!-- Senior leadership -->
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Technical Architect</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Solutions Architect</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Technology Lead</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Engineering Manager</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">CTO</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">CEO / Founder</div>
                            <!-- Other -->
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">IT Consultant</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">ERP Consultant</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Trainee / Intern</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Fresher</div>
                            <div class="dd-option" onclick="selectDD('ddRole','roleDisplay','roleHidden',this)">Not Currently Working</div>
                        </div>
                    </div>
                    <input type="hidden" name="currentRole" id="roleHidden">
                </div>

                <div class="col-md-4">
                    <label class="form-label">Experience (Years)</label>
                    <input type="number" name="experienceYears" class="form-control" min="0" max="60" placeholder="0">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Company Changes Count</label>
                    <input type="number" name="companyChangesCount" class="form-control" min="0" placeholder="0">
                </div>
                <div class="col-md-4">
                    <label class="form-label">Previous Companies</label>
                    <input type="text" name="companyChangesNames" class="form-control"
                           placeholder="e.g. Infosys, TCS">
                </div>
            </div>

            <!-- ACCOUNT -->
            <div class="section-divider mt-3"><i class="bi bi-shield-lock me-1"></i>Account &amp; Photo</div>
            <div class="row g-2">
                <div class="col-md-6">
                    <label class="form-label">Password *</label>
                    <div class="password-wrapper">
                        <input type="password" name="password" id="password"
                               class="form-control pe-5" required autocomplete="new-password"
                               placeholder="Min 8 characters">
                        <span class="toggle-password" onclick="togglePwd('password','icon1')">
                            <i id="icon1" class="bi bi-eye"></i>
                        </span>
                    </div>
                </div>
                <div class="col-md-6">
                    <label class="form-label">Re-enter Password *</label>
                    <div class="password-wrapper">
                        <input type="password" name="confirmPassword" id="confirmPassword"
                               class="form-control pe-5" required autocomplete="new-password"
                               placeholder="Repeat password">
                        <span class="toggle-password" onclick="togglePwd('confirmPassword','icon2')">
                            <i id="icon2" class="bi bi-eye"></i>
                        </span>
                    </div>
                    <small id="pwdError"   class="text-danger d-none fw-semibold">Passwords do not match</small>
                    <small id="pwdSuccess" class="text-success d-none fw-semibold"><i class="bi bi-check-circle-fill"></i> Passwords match</small>
                </div>
                <div class="col-12">
                    <label class="form-label">Upload Photo *</label>
                    <input type="file" name="photo" class="form-control" accept="image/*" required>
                    <small class="text-muted">Clear face photo, JPG/PNG, max 5MB</small>
                </div>
            </div>

            <div class="mt-4 d-flex gap-2 flex-wrap align-items-center">
                <button type="submit" class="btn-register">
                    <i class="bi bi-person-plus-fill me-1"></i> Register
                </button>
                <a href="<%=request.getContextPath()%>/auth/login.jsp" class="btn-login-link">
                    <i class="bi bi-box-arrow-in-right"></i> Go to Login
                </a>
            </div>

        </form>
    </div>
    </div>

</div>
</div>

<script>
/* ── SPECIALIZATION OTHER BOX ── */
function toggleOtherSpec() {
    var val = document.getElementById('specialization').value;
    var box = document.getElementById('otherSpecBox');
    var inp = document.getElementById('otherSpecInput');
    box.style.display = val === 'Other' ? 'block' : 'none';
    inp.required = (val === 'Other');
}

/* ── PASSWORD TOGGLE ── */
function togglePwd(inputId, iconId) {
    var inp  = document.getElementById(inputId);
    var icon = document.getElementById(iconId);
    if (inp.type === 'password') {
        inp.type = 'text';
        icon.classList.replace('bi-eye', 'bi-eye-slash');
    } else {
        inp.type = 'password';
        icon.classList.replace('bi-eye-slash', 'bi-eye');
    }
}

/* ── PASSWORD MATCH ── */
function checkPwd() {
    var p1 = document.getElementById('password').value;
    var p2 = document.getElementById('confirmPassword').value;
    if (!p2) { document.getElementById('pwdError').classList.add('d-none'); document.getElementById('pwdSuccess').classList.add('d-none'); return; }
    if (p1 !== p2) { document.getElementById('pwdError').classList.remove('d-none'); document.getElementById('pwdSuccess').classList.add('d-none'); }
    else           { document.getElementById('pwdError').classList.add('d-none'); document.getElementById('pwdSuccess').classList.remove('d-none'); }
}

/* ── SEARCHABLE DROPDOWN ── */
function openDD(wrapId) {
    /* close all others */
    document.querySelectorAll('.dd-wrap.open').forEach(function(el){ if(el.id !== wrapId) el.classList.remove('open'); });
    document.getElementById(wrapId).classList.add('open');
}
function closeAllDD() {
    document.querySelectorAll('.dd-wrap.open').forEach(function(el){ el.classList.remove('open'); });
}
function filterDD(wrapId, listId, query) {
    var q = query.toLowerCase();
    document.getElementById(wrapId).classList.add('open');
    var options = document.querySelectorAll('#' + listId + ' .dd-option');
    var anyVisible = false;
    options.forEach(function(opt) {
        var match = opt.textContent.toLowerCase().includes(q);
        opt.style.display = match ? '' : 'none';
        if (match) anyVisible = true;
    });
    /* show/hide empty state */
    var empty = document.querySelector('#' + listId + ' .dd-empty');
    if (empty) empty.style.display = anyVisible ? 'none' : 'block';
}
function selectDD(wrapId, displayId, hiddenId, optEl) {
    var val = optEl.textContent.trim();
    document.getElementById(displayId).value = val;
    document.getElementById(hiddenId).value  = val;
    /* mark selected */
    optEl.closest('.dd-list').querySelectorAll('.dd-option').forEach(function(o){ o.classList.remove('selected'); });
    optEl.classList.add('selected');
    document.getElementById(wrapId).classList.remove('open');
}
function syncHidden(hiddenId, val) {
    document.getElementById(hiddenId).value = val;
}
/* Close dropdowns on outside click */
document.addEventListener('click', function(e) {
    if (!e.target.closest('.dd-wrap')) closeAllDD();
});

/* ── FORM VALIDATE ── */
function validateForm() {
    var p1 = document.getElementById('password').value;
    var p2 = document.getElementById('confirmPassword').value;
    if (p1 !== p2) {
        document.getElementById('pwdError').classList.remove('d-none');
        document.getElementById('confirmPassword').focus();
        return false;
    }
    var spec = document.getElementById('specialization').value;
    if (spec === 'Other') {
        var other = document.getElementById('otherSpecInput').value.trim();
        if (!other) { alert('Please enter your specialization.'); return false; }
    }
    return true;
}

window.onload = function() {
    document.getElementById('password').value = '';
    document.getElementById('confirmPassword').value = '';
    toggleOtherSpec();
    document.getElementById('password').addEventListener('keyup', checkPwd);
    document.getElementById('confirmPassword').addEventListener('keyup', checkPwd);
};
</script>
</body>
</html>
