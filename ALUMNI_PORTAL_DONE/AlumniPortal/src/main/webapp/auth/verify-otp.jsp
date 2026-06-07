<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Verify OTP</title>
    <%@ include file="../WEB-INF/views/common-head.jspf" %>
    <style>
        .otp-card {
            max-width: 500px;
            margin: 60px auto;
            border-radius: 16px;
            box-shadow: 0 8px 24px rgba(0,0,0,0.08);
        }
        .page-title {
            color: #7a0f1b;
            font-weight: 800;
        }
    </style>
</head>
<body class="bg-light">

<div class="container">
    <div class="card otp-card">
        <div class="card-body p-4">
            <h2 class="page-title mb-4">Verify Email OTP</h2>

            <%
                String error = (String) request.getAttribute("error");
                String success = (String) request.getAttribute("success");
                String email = (String) request.getAttribute("email");
                if (email == null) {
                    email = request.getParameter("email");
                }
            %>

            <% if (error != null) { %>
                <div class="alert alert-danger"><%= error %></div>
            <% } %>

            <% if (success != null) { %>
                <div class="alert alert-success"><%= success %></div>
            <% } %>

            <p class="text-muted">Enter the OTP sent to your email.</p>

            <form method="post" action="<%=request.getContextPath()%>/verify-otp">
                <input type="hidden" name="email" value="<%= email != null ? email : "" %>">

                <div class="mb-3">
                    <label class="form-label">Email</label>
                    <input type="text" class="form-control" value="<%= email != null ? email : "" %>" readonly>
                </div>

                <div class="mb-3">
                    <label class="form-label">OTP Code</label>
                    <input type="text" name="otpCode" class="form-control" required>
                </div>

                <button type="submit" class="btn btn-danger">Verify OTP</button>
            </form>
        </div>
    </div>
</div>

</body>
</html>