<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.alumni.model.User" %>

<%
    User user = (User) session.getAttribute("user");

    if (user == null) {
        response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Alumni Dashboard</title>
    <%@ include file="../WEB-INF/views/common-head.jspf" %>

    <style>
        body {
            background: #f4f6f9;
        }

        .page-title {
            text-align: center;
            color: #7a0f1b;
            font-weight: 800;
            margin-top: 25px;
        }

        .welcome-card {
            max-width: 900px;
            margin: 30px auto;
            border-radius: 20px;
            background: #fff;
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
            overflow: hidden;
        }

        .welcome-header {
            background: linear-gradient(135deg, #7a0f1b, #a11c2f);
            color: white;
            padding: 25px;
        }

        .welcome-body {
            padding: 30px;
        }

        .btn-custom {
            padding: 12px 20px;
            font-weight: 600;
            border-radius: 10px;
        }

        .btn-maroon {
            background: #7a0f1b;
            color: #fff;
        }

        .btn-maroon:hover {
            background: #5e0c14;
            color: #fff;
        }

        .btn-outline-maroon {
            border: 2px solid #7a0f1b;
            color: #7a0f1b;
        }

        .btn-outline-maroon:hover {
            background: #7a0f1b;
            color: #fff;
        }

        .info-box {
            background: #fafafa;
            border-left: 5px solid #7a0f1b;
            padding: 15px;
            border-radius: 10px;
            margin-bottom: 20px;
        }
    </style>
</head>

<body>

<div class="container">

    <h2 class="page-title">Welcome Dashboard</h2>

    <div class="welcome-card">

        <div class="welcome-header">
            <h3>Welcome, <%= user.getFullName() %> 👋</h3>
            <p class="mb-0">Alumni Portal Access Panel</p>
        </div>

        <div class="welcome-body">

            <div class="info-box">
                <strong>Status:</strong> <%= user.getStatus() %><br>
                <strong>Email:</strong> <%= user.getEmail() %>
            </div>

            <div class="row text-center mt-4 g-3">

                <div class="col-md-6">
                    <a href="<%=request.getContextPath()%>/portal/virtual-id"
                       class="btn btn-maroon btn-custom w-100">
                        View Virtual ID
                    </a>
                </div>

                <div class="col-md-6">
                    <a href="<%=request.getContextPath()%>/members"
                       class="btn btn-outline-maroon btn-custom w-100">
                        View Alumni Members
                    </a>
                </div>

                <div class="col-md-6">
                    <a href="<%=request.getContextPath()%>/events"
                       class="btn btn-outline-maroon btn-custom w-100">
                        View Events
                    </a>
                </div>

                <div class="col-md-6">
                    <a href="<%=request.getContextPath()%>/gallery"
                       class="btn btn-outline-maroon btn-custom w-100">
                        View Gallery
                    </a>
                </div>

            </div>

            <div class="text-center mt-4">
                <a href="<%=request.getContextPath()%>/logout"
                   class="btn btn-danger btn-custom">
                    Logout
                </a>
            </div>

        </div>
    </div>

</div>

</body>
</html>