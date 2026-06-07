<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.alumni.model.User" %>
<%
    /* If already logged in as staff, redirect straight to dashboard */
    HttpSession existingSession = request.getSession(false);
    if (existingSession != null) {
        User su = (User) existingSession.getAttribute("staffUser");
        if (su != null && "STAFF".equals(su.getRole())) {
            response.sendRedirect(request.getContextPath() + "/staff/dashboard.jsp");
            return;
        }
    }
    String errorMsg = (request.getAttribute("error") != null)
                      ? (String) request.getAttribute("error") : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Staff Login | MEASI Alumni Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --brand-maroon: #7a0f1b;
            --brand-green : #0b4b3b;
        }
        * { box-sizing: border-box; margin: 0; padding: 0; }
        body {
            font-family: 'DM Sans', sans-serif;
            min-height: 100vh;
            display: flex;
            background: linear-gradient(135deg, var(--brand-green) 0%, #073327 50%, #1a0508 100%);
        }

        /* Left panel */
        .brand-panel {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            padding: 60px 40px;
            color: #fff;
            position: relative;
            overflow: hidden;
        }
        .brand-panel::before {
            content: '';
            position: absolute; top: -100px; left: -100px;
            width: 400px; height: 400px; border-radius: 50%;
            background: rgba(255,213,79,0.06);
        }
        .brand-panel::after {
            content: '';
            position: absolute; bottom: -80px; right: -80px;
            width: 300px; height: 300px; border-radius: 50%;
            background: rgba(255,255,255,0.04);
        }
        .brand-logo {
            width: 90px; height: 90px;
            background: rgba(255,255,255,0.12);
            border: 2px solid rgba(255,255,255,0.25);
            border-radius: 20px;
            display: flex; align-items: center; justify-content: center;
            font-size: 40px; margin-bottom: 28px;
        }
        .brand-panel h1 {
            font-family: 'Playfair Display', serif;
            font-size: 32px; font-weight: 800;
            text-align: center; line-height: 1.2; margin-bottom: 14px;
        }
        .brand-panel p {
            font-size: 15px; opacity: 0.7;
            text-align: center; max-width: 300px; line-height: 1.6;
        }
        .feature-list {
            margin-top: 40px; list-style: none;
            display: flex; flex-direction: column; gap: 16px;
        }
        .feature-list li {
            display: flex; align-items: center; gap: 12px;
            font-size: 14px; opacity: 0.85;
        }
        .feature-list li i {
            width: 34px; height: 34px;
            background: rgba(255,213,79,0.15);
            border: 1px solid rgba(255,213,79,0.3);
            border-radius: 8px;
            display: flex; align-items: center; justify-content: center;
            color: #ffd54f; font-size: 15px; flex-shrink: 0;
        }

        /* Right panel - form */
        .form-panel {
            width: 480px; flex-shrink: 0;
            background: #fff;
            display: flex; flex-direction: column;
            justify-content: center;
            padding: 56px 48px;
        }
        .form-eyebrow {
            display: inline-flex; align-items: center; gap: 6px;
            background: #fdf0f1;
            border: 1px solid #f5c6ca;
            color: var(--brand-maroon);
            padding: 5px 14px; border-radius: 50px;
            font-size: 11px; font-weight: 700;
            letter-spacing: 1.5px; text-transform: uppercase;
            margin-bottom: 20px;
        }
        .form-panel h2 {
            font-family: 'Playfair Display', serif;
            font-size: 30px; font-weight: 800;
            color: #1a1a1a; margin-bottom: 8px;
        }
        .form-panel .subtitle {
            font-size: 14px; color: #888; margin-bottom: 36px;
        }
        .form-label-custom {
            font-size: 13px; font-weight: 600;
            color: #444; margin-bottom: 6px; display: block;
        }
        .form-control-custom {
            width: 100%;
            padding: 13px 16px;
            border: 1.5px solid #e0dbd4;
            border-radius: 12px;
            font-size: 14px; font-family: 'DM Sans', sans-serif;
            background: #faf9f7;
            outline: none; transition: border-color 0.2s, box-shadow 0.2s;
            margin-bottom: 20px;
        }
        .form-control-custom:focus {
            border-color: var(--brand-maroon);
            background: #fff;
            box-shadow: 0 0 0 3px rgba(122,15,27,0.08);
        }
        .input-group-custom {
            position: relative;
        }
        .input-group-custom i {
            position: absolute; left: 14px; top: 50%;
            transform: translateY(-50%);
            color: #bbb; font-size: 16px; pointer-events: none;
        }
        .input-group-custom .form-control-custom {
            padding-left: 42px;
        }
        .input-group-custom .toggle-pwd {
            position: absolute; right: 14px; top: 50%;
            transform: translateY(-50%);
            color: #bbb; cursor: pointer; font-size: 16px;
        }
        .btn-login {
            width: 100%; padding: 14px;
            background: var(--brand-maroon);
            color: #fff; border: none;
            border-radius: 12px;
            font-size: 15px; font-weight: 700;
            font-family: 'DM Sans', sans-serif;
            cursor: pointer;
            transition: background 0.2s, transform 0.15s;
            display: flex; align-items: center; justify-content: center; gap: 8px;
            margin-top: 4px;
        }
        .btn-login:hover {
            background: #5a0a13;
            transform: translateY(-1px);
        }
        .error-box {
            background: #fdf0f1;
            border: 1px solid #f5c6ca;
            border-radius: 10px;
            padding: 12px 16px;
            font-size: 13px; color: #a0122a;
            display: flex; align-items: center; gap: 8px;
            margin-bottom: 20px;
        }
        .back-link {
            display: inline-flex; align-items: center; gap: 6px;
            font-size: 13px; color: #888;
            text-decoration: none; margin-top: 28px;
            transition: color 0.2s;
        }
        .back-link:hover { color: var(--brand-maroon); }

        @media (max-width: 900px) {
            body { flex-direction: column; }
            .brand-panel { padding: 40px 24px 30px; }
            .brand-panel h1 { font-size: 24px; }
            .feature-list { display: none; }
            .form-panel { width: 100%; padding: 36px 24px; }
        }
    </style>
</head>
<body>

    <!-- Left brand panel -->
    <div class="brand-panel">
        <div class="brand-logo"><i class="bi bi-person-badge"></i></div>
        <h1>MEASI Alumni<br>Staff Portal</h1>
        <p>Authorized staff access to view and manage alumni member records.</p>

        <ul class="feature-list">
            <li>
                <i class="bi bi-people-fill"></i>
                View all approved alumni members
            </li>
            <li>
                <i class="bi bi-card-list"></i>
                Access full member profiles and details
            </li>
            <li>
                <i class="bi bi-search"></i>
                Search and filter by batch, department, company
            </li>
            <li>
                <i class="bi bi-shield-lock-fill"></i>
                Secure staff-only access
            </li>
        </ul>
    </div>

    <!-- Right form panel -->
    <div class="form-panel">
        <div class="form-eyebrow"><i class="bi bi-person-badge"></i> Staff Access</div>
        <h2>Welcome Back</h2>
        <p class="subtitle">Sign in with your staff credentials to continue.</p>

        <% if (!errorMsg.isEmpty()) { %>
        <div class="error-box">
            <i class="bi bi-exclamation-circle-fill"></i>
            <%= errorMsg %>
        </div>
        <% } %>

        <form method="post" action="<%=request.getContextPath()%>/staff-login">
            <label class="form-label-custom" for="email">Email Address</label>
            <div class="input-group-custom">
                <i class="bi bi-envelope"></i>
                <input class="form-control-custom" type="email"
                       id="email" name="email"
                       placeholder="staff@measiit.edu.in"
                       required autocomplete="email">
            </div>

            <label class="form-label-custom" for="password">Password</label>
            <div class="input-group-custom">
                <i class="bi bi-lock"></i>
                <input class="form-control-custom" type="password"
                       id="password" name="password"
                       placeholder="Enter your password"
                       required autocomplete="current-password">
                <i class="bi bi-eye-slash toggle-pwd" id="togglePwd"></i>
            </div>

            <button type="submit" class="btn-login">
                <i class="bi bi-box-arrow-in-right"></i> Sign In
            </button>
        </form>

        <a class="back-link" href="<%=request.getContextPath()%>/home">
            <i class="bi bi-arrow-left"></i> Back to Alumni Portal
        </a>
    </div>

    <script>
    /* Toggle password visibility */
    var toggleBtn = document.getElementById('togglePwd');
    var pwdInput  = document.getElementById('password');
    toggleBtn.addEventListener('click', function () {
        if (pwdInput.type === 'password') {
            pwdInput.type = 'text';
            toggleBtn.classList.replace('bi-eye-slash', 'bi-eye');
        } else {
            pwdInput.type = 'password';
            toggleBtn.classList.replace('bi-eye', 'bi-eye-slash');
        }
    });
    </script>
</body>
</html>
