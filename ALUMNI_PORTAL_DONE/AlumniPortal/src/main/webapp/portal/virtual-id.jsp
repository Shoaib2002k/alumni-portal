<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="com.alumni.model.AlumniProfile" %>

<%
    AlumniProfile p = (AlumniProfile) request.getAttribute("profile");

    if (p == null) {
        response.sendRedirect(request.getContextPath() + "/portal/virtual-id");
        return;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Virtual Alumni ID</title>
    <%@ include file="../WEB-INF/views/common-head.jspf" %>

    <style>
        .page-title {
            color: #7a0f1b;
            font-weight: 800;
            text-align: center;
            margin-top: 25px;
        }

        .id-card {
            max-width: 820px;
            margin: 30px auto;
            border-radius: 22px;
            overflow: hidden;
            background: #fff;
            box-shadow: 0 10px 28px rgba(0,0,0,0.15);
        }

        .id-header {
            background: linear-gradient(135deg, #7a0f1b, #a11c2f);
            color: white;
            padding: 20px 24px;
        }

        .id-body {
            padding: 24px;
        }

        .id-photo {
            width: 180px;
            height: 220px;
            object-fit: cover;
            border-radius: 16px;
            border: 4px solid #f1f1f1;
        }

        .label {
            font-weight: 700;
            color: #7a0f1b;
        }
    </style>
</head>

<body class="bg-light">

<div class="container py-4">

    <h2 class="page-title">Virtual Alumni ID</h2>

    <div class="text-center mt-3">
        <a href="<%=request.getContextPath()%>/portal/welcome.jsp" class="btn btn-secondary">
            Back to Welcome
        </a>
    </div>

    <div class="id-card">
        <div class="id-header d-flex justify-content-between align-items-center">
            <div>
                <h3 class="mb-1">MEASI Alumni Virtual ID</h3>
                <div>Approved Alumni Member</div>
            </div>

            <div class="text-end">
                <strong>ID No:</strong> ALU-<%= p.getUserId() %>
            </div>
        </div>

        <div class="id-body">
            <div class="row g-4 align-items-start">

                <div class="col-md-4 text-center">
                    <img src="<%=request.getContextPath()%>/<%=p.getPhotoPath()%>"
                         class="id-photo"
                         alt="Alumni Photo">
                </div>

                <div class="col-md-8">
                    <p><span class="label">Name:</span> <%= p.getUser().getFullName() %></p>
                    <p><span class="label">Email:</span> <%= p.getUser().getEmail() %></p>
                    <p><span class="label">Phone:</span> <%= p.getUser().getPhone() %></p>
                    <p><span class="label">Place:</span> <%= p.getUser().getPlace() %></p>
                    <p><span class="label">Batch ID:</span> <%= p.getBatchId() %></p>
                    <p><span class="label">Department ID:</span> <%= p.getDeptId() %></p>
                    <p><span class="label">University Reg No:</span> <%= p.getUniversityRegNo() %></p>
                    <p><span class="label">Current Company:</span> <%= p.getCurrentCompany() != null ? p.getCurrentCompany() : "-" %></p>
                    <p><span class="label">Current Role:</span> <%= p.getCurrentRole() != null ? p.getCurrentRole() : "-" %></p>
                    <p><span class="label">Specialization:</span> <%= p.getSpecialization() != null ? p.getSpecialization() : "-" %></p>
                </div>

            </div>
        </div>
    </div>

</div>

</body>
</html>