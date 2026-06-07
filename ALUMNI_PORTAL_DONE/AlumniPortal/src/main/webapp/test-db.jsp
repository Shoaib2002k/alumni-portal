<%@ page contentType="text/html; charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Test DB</title>
</head>
<body style="font-family: Arial;">
    <h2>Test Oracle DB Connection</h2>

    <p>This page calls a servlet that connects to Oracle using JDBC.</p>

    <a href="<%=request.getContextPath()%>/test-db"
       style="display:inline-block;padding:10px 16px;background:#0d6efd;color:#fff;text-decoration:none;border-radius:6px;">
        Run DB Test
    </a>
</body>
</html>