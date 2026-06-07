<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.alumni.model.User" %>
<%
    response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
    HttpSession s = request.getSession(false);
    if (s != null) {
        User u = (User) s.getAttribute("user");
        if (u != null && "ADMIN".equals(u.getRole())) {
            response.sendRedirect(request.getContextPath() + "/admin/dashboard.jsp");
            return;
        }
    }
    String errorMsg = request.getAttribute("error") != null ? (String) request.getAttribute("error") : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Admin Login | MEASI Alumni Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root { --brand-maroon:#7a0f1b; --brand-green:#0b4b3b; }
        *{box-sizing:border-box;margin:0;padding:0;}
        body{font-family:'DM Sans',sans-serif;min-height:100vh;display:flex;
          background:linear-gradient(135deg,var(--brand-maroon) 0%,#5a0a13 50%,var(--brand-green) 100%);}
        /* LEFT PANEL */
        .brand-panel{flex:1;display:flex;flex-direction:column;align-items:center;
          justify-content:center;padding:60px 40px;color:#fff;position:relative;overflow:hidden;}
        .brand-panel::before{content:'';position:absolute;top:-100px;right:-100px;
          width:380px;height:380px;border-radius:50%;background:rgba(255,213,79,0.06);}
        .brand-panel::after{content:'';position:absolute;bottom:-80px;left:-80px;
          width:280px;height:280px;border-radius:50%;background:rgba(255,255,255,0.04);}
        .brand-logo{width:88px;height:88px;background:rgba(255,255,255,0.12);
          border:2px solid rgba(255,255,255,0.22);border-radius:20px;
          display:flex;align-items:center;justify-content:center;font-size:38px;margin-bottom:26px;}
        .brand-panel h1{font-family:'Playfair Display',serif;font-size:30px;font-weight:800;
          text-align:center;line-height:1.2;margin-bottom:12px;}
        .brand-panel p{font-size:14px;opacity:.7;text-align:center;max-width:280px;line-height:1.6;}
        .feature-list{margin-top:36px;list-style:none;display:flex;flex-direction:column;gap:14px;}
        .feature-list li{display:flex;align-items:center;gap:12px;font-size:13px;opacity:.85;}
        .feature-list li i{width:32px;height:32px;background:rgba(255,213,79,0.15);
          border:1px solid rgba(255,213,79,0.3);border-radius:8px;
          display:flex;align-items:center;justify-content:center;color:#ffd54f;font-size:14px;flex-shrink:0;}
        /* RIGHT PANEL */
        .form-panel{width:460px;flex-shrink:0;background:#fff;
          display:flex;flex-direction:column;justify-content:center;padding:52px 44px;}
        .form-eyebrow{display:inline-flex;align-items:center;gap:6px;background:#fdf0f1;
          border:1px solid #f5c6ca;color:var(--brand-maroon);padding:5px 14px;border-radius:50px;
          font-size:11px;font-weight:700;letter-spacing:1.5px;text-transform:uppercase;margin-bottom:18px;}
        .form-panel h2{font-family:'Playfair Display',serif;font-size:28px;font-weight:800;
          color:#1a1a1a;margin-bottom:6px;}
        .form-panel .subtitle{font-size:14px;color:#888;margin-bottom:32px;}
        .field-label{font-size:12px;font-weight:700;color:#444;text-transform:uppercase;
          letter-spacing:.5px;display:block;margin-bottom:6px;}
        .field-wrap{position:relative;margin-bottom:18px;}
        .field-wrap i.icon{position:absolute;left:13px;top:50%;transform:translateY(-50%);
          color:#bbb;font-size:15px;pointer-events:none;}
        .field-input{width:100%;padding:12px 14px 12px 40px;border:1.5px solid #e0dbd4;
          border-radius:11px;font-size:14px;font-family:'DM Sans',sans-serif;background:#faf9f7;outline:none;
          transition:border-color .2s,box-shadow .2s;}
        .field-input:focus{border-color:var(--brand-maroon);background:#fff;box-shadow:0 0 0 3px rgba(122,15,27,.07);}
        .toggle-eye{position:absolute;right:13px;top:50%;transform:translateY(-50%);
          color:#bbb;cursor:pointer;font-size:15px;}
        .btn-login{width:100%;padding:13px;background:var(--brand-maroon);color:#fff;border:none;
          border-radius:11px;font-size:14px;font-weight:700;font-family:'DM Sans',sans-serif;cursor:pointer;
          transition:background .2s,transform .15s;display:flex;align-items:center;justify-content:center;gap:8px;}
        .btn-login:hover{background:#5a0a13;transform:translateY(-1px);}
        .error-box{background:#fdf0f1;border:1px solid #f5c6ca;border-radius:10px;
          padding:11px 15px;font-size:13px;color:#a0122a;display:flex;align-items:center;gap:8px;margin-bottom:18px;}
        .back-link{display:inline-flex;align-items:center;gap:6px;font-size:12px;color:#aaa;
          text-decoration:none;margin-top:24px;transition:color .2s;}
        .back-link:hover{color:var(--brand-maroon);}
        @media(max-width:860px){
          body{flex-direction:column;}
          .brand-panel{padding:36px 24px 28px;}
          .brand-panel h1{font-size:22px;}
          .feature-list{display:none;}
          .form-panel{width:100%;padding:32px 22px;}
        }
    </style>
</head>
<body>
    <!-- Left -->
    <div class="brand-panel">
        <div class="brand-logo"><i class="bi bi-shield-lock-fill"></i></div>
        <h1>MEASI Alumni<br>Admin Portal</h1>
        <p>Secure administrator access to manage the alumni portal.</p>
        <ul class="feature-list">
            <li><i class="bi bi-person-check-fill"></i> Approve or reject alumni registrations</li>
            <li><i class="bi bi-people-fill"></i> Manage all alumni members</li>
            <li><i class="bi bi-calendar-event-fill"></i> Add and manage events</li>
            <li><i class="bi bi-images"></i> Upload gallery images</li>
            <li><i class="bi bi-gear-fill"></i> Configure site settings</li>
        </ul>
    </div>
    <!-- Right -->
    <div class="form-panel">
        <div class="form-eyebrow"><i class="bi bi-shield-lock"></i> Admin Access</div>
        <h2>Welcome Back</h2>
        <p class="subtitle">Sign in with your admin credentials to continue.</p>
        <% if (!errorMsg.isEmpty()) { %>
        <div class="error-box"><i class="bi bi-exclamation-circle-fill"></i><%= errorMsg %></div>
        <% } %>
        <form method="post" action="<%=request.getContextPath()%>/admin-login">
            <label class="field-label" for="email">Email Address</label>
            <div class="field-wrap">
                <i class="bi bi-envelope icon"></i>
                <input class="field-input" type="email" id="email" name="email"
                       placeholder="admin@measiit.edu.in" required autocomplete="email">
            </div>
            <label class="field-label" for="password">Password</label>
            <div class="field-wrap">
                <i class="bi bi-lock icon"></i>
                <input class="field-input" type="password" id="password" name="password"
                       placeholder="Enter your password" required autocomplete="current-password">
                <i class="bi bi-eye-slash toggle-eye" id="togglePwd"></i>
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
    var t = document.getElementById('togglePwd'), p = document.getElementById('password');
    t.addEventListener('click', function(){
        p.type = p.type === 'password' ? 'text' : 'password';
        t.classList.toggle('bi-eye'); t.classList.toggle('bi-eye-slash');
    });
    </script>
</body>
</html>
