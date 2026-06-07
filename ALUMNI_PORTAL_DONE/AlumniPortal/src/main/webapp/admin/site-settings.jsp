<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.Map" %>
<%
    Map<String, String> settings = (Map<String, String>) request.getAttribute("settings");
    String siteName    = (settings != null && settings.get("SITE_NAME")     != null) ? settings.get("SITE_NAME")     : "";
    String aboutText   = (settings != null && settings.get("ABOUT_TEXT")    != null) ? settings.get("ABOUT_TEXT")    : "";
    String primaryColor= (settings != null && settings.get("PRIMARY_COLOR") != null) ? settings.get("PRIMARY_COLOR") : "#7a0f1b";
    String logoPath    = (settings != null && settings.get("LOGO_PATH")     != null) ? settings.get("LOGO_PATH")     : "";
    String successMsg  = request.getAttribute("success") != null ? (String) request.getAttribute("success") : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Site Settings | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .color-preview{width:36px;height:36px;border-radius:8px;border:1.5px solid #e0dbd4;
          flex-shrink:0;transition:background .2s;}
        .color-row{display:flex;align-items:center;gap:10px;}
        .setting-hint{font-size:11px;color:#aaa;margin-top:5px;}
    </style>
</head>
<body>
<%@ include file="admin-sidebar.jspf" %>
<div class="main-wrap">
    <div class="admin-topbar">
        <div class="topbar-title">Site Settings</div>
        <div class="topbar-right"><i class="bi bi-gear"></i></div>
    </div>
    <div class="admin-hero">
        <div style="position:relative;z-index:2;">
            <h2>Site Settings</h2>
            <p>Configure the public alumni portal — name, colors, logo and about section.</p>
        </div>
    </div>
    <div class="content-area">
        <% if (!successMsg.isEmpty()) { %>
        <div class="alert-success-custom"><i class="bi bi-check-circle-fill"></i><%= successMsg %></div>
        <% } %>

        <div class="admin-card" style="max-width:700px;">
            <div class="admin-card-header">
                <h4><i class="bi bi-sliders me-2" style="color:#7a0f1b;"></i>Portal Configuration</h4>
            </div>
            <div class="admin-card-body">
                <form method="post" action="<%=request.getContextPath()%>/admin/site-settings">
                    <div style="margin-bottom:20px;">
                        <label class="form-label-custom">Site Name</label>
                        <input type="text" name="siteName" class="form-ctrl"
                               value="<%= siteName %>" placeholder="MEASI Alumni Web Portal">
                        <div class="setting-hint">Displayed in browser tabs and the portal header.</div>
                    </div>

                    <div style="margin-bottom:20px;">
                        <label class="form-label-custom">About Text</label>
                        <textarea name="aboutText" class="form-ctrl" rows="5"
                                  placeholder="Write a brief description about the alumni portal..."><%= aboutText %></textarea>
                        <div class="setting-hint">Shown in the About Us section of the home page.</div>
                    </div>

                    <div style="margin-bottom:20px;">
                        <label class="form-label-custom">Primary Color</label>
                        <div class="color-row">
                            <input type="text" name="primaryColor" id="colorInput" class="form-ctrl"
                                   value="<%= primaryColor %>" placeholder="#7a0f1b"
                                   oninput="updateColorPreview(this.value)" style="max-width:200px;">
                            <div class="color-preview" id="colorPreview" style="background:<%= primaryColor %>;"></div>
                            <input type="color" id="colorPicker" value="<%= primaryColor %>"
                                   onchange="syncColor(this.value)"
                                   style="width:36px;height:36px;border-radius:8px;border:1.5px solid #e0dbd4;cursor:pointer;padding:2px;">
                        </div>
                        <div class="setting-hint">The main brand color used across the portal (hex code).</div>
                    </div>

                    <div style="margin-bottom:24px;">
                        <label class="form-label-custom">Logo Path</label>
                        <input type="text" name="logoPath" class="form-ctrl"
                               value="<%= logoPath %>" placeholder="assets/img/logoonly.PNG">
                        <div class="setting-hint">Relative path to the logo image inside your webapp folder.</div>
                    </div>

                    <div style="display:flex;gap:10px;">
                        <button type="submit" class="btn-primary-custom">
                            <i class="bi bi-save"></i> Save Settings
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</div>
<script>
function updateColorPreview(val) {
    if (/^#[0-9a-fA-F]{3,6}$/.test(val)) {
        document.getElementById('colorPreview').style.background = val;
        document.getElementById('colorPicker').value = val;
    }
}
function syncColor(val) {
    document.getElementById('colorInput').value = val;
    document.getElementById('colorPreview').style.background = val;
}
</script>
</body>
</html>
