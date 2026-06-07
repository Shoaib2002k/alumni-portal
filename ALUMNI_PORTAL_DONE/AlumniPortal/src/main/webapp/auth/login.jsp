<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Alumni Login - MEASI Alumni Portal</title>
    <%@ include file="/WEB-INF/views/common-head.jspf" %>

    <style>
        :root {
            --brand-maroon: #7a0f1b;
            --brand-green: #0b4b3b;
            --brand-gold: #d8b15a;
            --text-dark: #1f2937;
            --soft-bg: #f6f7f9;
        }

        body {
            margin: 0;
            min-height: 100vh;
            font-family: Arial, sans-serif;
            background:
                linear-gradient(rgba(122, 15, 27, 0.78), rgba(11, 75, 59, 0.72)),
                url('<%=request.getContextPath()%>/assets/img/hero.png') center center/cover no-repeat;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 30px 15px;
        }

        .login-wrapper {
            width: 100%;
            max-width: 1100px;
            display: grid;
            grid-template-columns: 1fr 470px;
            background: rgba(255,255,255,0.08);
            border: 1px solid rgba(255,255,255,0.12);
            border-radius: 24px;
            overflow: hidden;
            box-shadow: 0 20px 50px rgba(0,0,0,0.28);
            backdrop-filter: blur(6px);
        }

        .login-left {
            padding: 60px 50px;
            color: #fff;
            display: flex;
            flex-direction: column;
            justify-content: center;
            background: linear-gradient(135deg, rgba(0,0,0,0.28), rgba(0,0,0,0.08));
        }

        .login-badge {
            display: inline-block;
            align-self: flex-start;
            padding: 8px 18px;
            border-radius: 999px;
            background: rgba(255,255,255,0.12);
            border: 1px solid rgba(255,255,255,0.18);
            font-size: 13px;
            font-weight: 700;
            letter-spacing: 0.6px;
            margin-bottom: 22px;
        }

        .login-left h1 {
            font-size: 52px;
            line-height: 1.08;
            margin: 0 0 18px;
            font-weight: 800;
        }

        .login-left p {
            font-size: 20px;
            line-height: 1.7;
            margin: 0;
            max-width: 520px;
            color: #f3f4f6;
        }

        .login-card {
            background: #ffffff;
            padding: 42px 36px;
            display: flex;
            flex-direction: column;
            justify-content: center;
        }

        .brand-row {
            display: flex;
            align-items: center;
            gap: 14px;
            margin-bottom: 20px;
        }

        .brand-row img {
            height: 52px;
            width: auto;
        }

        .brand-text {
            color: var(--brand-maroon);
            font-weight: 800;
            line-height: 1.15;
            font-size: 20px;
        }

        .login-title {
            font-size: 38px;
            font-weight: 800;
            color: var(--brand-maroon);
            margin-bottom: 8px;
        }

        .login-subtitle {
            color: #6b7280;
            margin-bottom: 28px;
            font-size: 15px;
        }

        .form-label {
            font-weight: 700;
            color: var(--text-dark);
            margin-bottom: 8px;
        }

        .form-control {
            height: 52px;
            border-radius: 12px;
            border: 1px solid #d1d5db;
            box-shadow: none !important;
        }

        .form-control:focus {
            border-color: var(--brand-maroon);
            box-shadow: 0 0 0 0.2rem rgba(122, 15, 27, 0.12) !important;
        }

        .login-btn {
            background: var(--brand-maroon);
            color: #fff;
            border: none;
            border-radius: 12px;
            height: 50px;
            font-weight: 700;
            font-size: 17px;
            transition: 0.25s ease;
        }

        .login-btn:hover {
            background: #5f0c15;
            color: #fff;
        }

        .secondary-btn {
            background: var(--brand-green);
            color: #fff;
            border: none;
            border-radius: 12px;
            height: 50px;
            font-weight: 700;
            font-size: 16px;
            transition: 0.25s ease;
        }

        .secondary-btn:hover {
            background: #08392d;
            color: #fff;
        }

        .helper-links {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            margin-top: 18px;
            flex-wrap: wrap;
        }

        .helper-links a {
            text-decoration: none;
            color: var(--brand-maroon);
            font-weight: 600;
            font-size: 14px;
        }

        .helper-links a:hover {
            text-decoration: underline;
        }

        .alert-box {
            border-radius: 12px;
            padding: 12px 14px;
            margin-bottom: 16px;
            font-size: 14px;
        }

        .alert-error {
            background: #fef2f2;
            color: #991b1b;
            border: 1px solid #fecaca;
        }

        .alert-success {
            background: #ecfdf5;
            color: #065f46;
            border: 1px solid #a7f3d0;
        }

        @media (max-width: 991px) {
            .login-wrapper {
                grid-template-columns: 1fr;
            }

            .login-left {
                padding: 40px 28px 20px;
            }

            .login-left h1 {
                font-size: 38px;
            }

            .login-left p {
                font-size: 17px;
            }

            .login-card {
                padding: 30px 22px;
            }
        }
    </style>
</head>
<body>

<div class="login-wrapper">

    <div class="login-left">
        <div class="login-badge">MEASI INSTITUTE OF INFORMATION TECHNOLOGY</div>
        <h1>Welcome Back,<br>Alumni</h1>
        <p>
            Sign in to reconnect with your alumni network, explore members,
            view updates, and stay engaged with MEASI.
        </p>
    </div>

    <div class="login-card">
        <div class="brand-row">
            <img src="<%=request.getContextPath()%>/assets/img/logo.png" alt="MEASI Logo">
            <div class="brand-text">
                MEASI Alumni Portal<br>
                Information Technology
            </div>
        </div>

        <div class="login-title">Alumni Login</div>
        <div class="login-subtitle">Enter your registered email and password to continue.</div>

        <% if (request.getAttribute("error") != null) { %>
            <div class="alert-box alert-error">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>

        <% if (request.getAttribute("success") != null) { %>
            <div class="alert-box alert-success">
                <%= request.getAttribute("success") %>
            </div>
        <% } %>

        <form action="<%=request.getContextPath()%>/alumni-login" method="post">
            <div class="mb-3">
                <label class="form-label">Email</label>
                <input type="email" name="email" class="form-control" placeholder="Enter your email" required>
            </div>

            <div class="mb-3">
                <label class="form-label">Password</label>
                <input type="password" name="password" class="form-control" placeholder="Enter your password" required>
            </div>

            <div class="d-grid mb-3">
                <button type="submit" class="login-btn">Login</button>
            </div>

            <div class="d-grid">
                <a href="<%=request.getContextPath()%>/auth/register.jsp" class="btn secondary-btn">Register</a>
            </div>

            <div class="helper-links">
                <a href="<%=request.getContextPath()%>/">← Back to Home</a>
                <a href="<%=request.getContextPath()%>/auth/forgot_password.jsp">Forgot Password?</a>
            </div>
        </form>
    </div>

</div>

</body>
</html>