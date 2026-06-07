<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.alumni.model.Gallery" %>
<%
    List<Gallery> images = (List<Gallery>) request.getAttribute("images");
    int imgCount = (images != null) ? images.size() : 0;
    String successMsg = request.getAttribute("success") != null ? (String) request.getAttribute("success") : "";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"><meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Gallery | Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800&family=DM+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        .gallery-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(220px,1fr));gap:18px;}
        .gcard{background:#fff;border-radius:16px;overflow:hidden;
          box-shadow:0 4px 18px rgba(0,0,0,0.07);border:1px solid rgba(0,0,0,0.04);
          transition:all .3s ease;}
        .gcard:hover{transform:translateY(-4px);box-shadow:0 12px 32px rgba(0,0,0,0.12);}
        .gcard-img{width:100%;height:170px;object-fit:cover;display:block;}
        .gcard-img-placeholder{width:100%;height:170px;background:linear-gradient(135deg,#f0ece6,#e0d9d0);
          display:flex;align-items:center;justify-content:center;font-size:40px;color:#c5b9ae;}
        .gcard-body{padding:14px 16px 16px;}
        .gcard-title{font-size:14px;font-weight:600;color:#1a1a1a;margin:0 0 10px;
          white-space:nowrap;overflow:hidden;text-overflow:ellipsis;}
    </style>
</head>
<body>
<%@ include file="admin-sidebar.jspf" %>
<div class="main-wrap">
    <div class="admin-topbar">
        <div class="topbar-title">Gallery</div>
        <div class="topbar-right"><i class="bi bi-images"></i> <%= imgCount %> images</div>
    </div>
    <div class="admin-hero">
        <div style="position:relative;z-index:2;">
            <h2>Manage Gallery</h2>
            <p>Upload and manage photo gallery images for the alumni portal.</p>
        </div>
    </div>
    <div class="content-area">
        <% if (!successMsg.isEmpty()) { %>
        <div class="alert-success-custom"><i class="bi bi-check-circle-fill"></i><%= successMsg %></div>
        <% } %>

        <!-- UPLOAD FORM -->
        <div class="admin-card">
            <div class="admin-card-header">
                <h4><i class="bi bi-cloud-upload-fill me-2" style="color:#7a0f1b;"></i>Upload New Image</h4>
            </div>
            <div class="admin-card-body">
                <form method="post" action="<%=request.getContextPath()%>/admin/gallery" enctype="multipart/form-data">
                    <div class="row g-3">
                        <div class="col-md-5">
                            <label class="form-label-custom">Image Title</label>
                            <input type="text" name="title" class="form-ctrl" placeholder="Enter a title for this image">
                        </div>
                        <div class="col-md-5">
                            <label class="form-label-custom">Choose Image *</label>
                            <input type="file" name="image" class="form-ctrl" accept="image/*" required>
                        </div>
                        <div class="col-md-2" style="display:flex;align-items:flex-end;">
                            <button type="submit" class="btn-primary-custom" style="width:100%;">
                                <i class="bi bi-upload"></i> Upload
                            </button>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- GALLERY GRID -->
        <div class="admin-card">
            <div class="admin-card-header">
                <h4><i class="bi bi-grid-3x3-gap-fill me-2" style="color:#7a0f1b;"></i>Gallery Images</h4>
                <span style="font-size:13px;color:#888;"><%= imgCount %> image<%= imgCount != 1 ? "s" : "" %></span>
            </div>
            <div class="admin-card-body">
            <% if (images == null || images.isEmpty()) { %>
            <div class="empty-state">
                <i class="bi bi-images"></i>
                <p>No images uploaded yet. Upload your first image above.</p>
            </div>
            <% } else { %>
            <div class="gallery-grid">
                <% for (Gallery gi : images) {
                    String giPath  = gi.getImagePath() != null ? gi.getImagePath() : "";
                    String giTitle = gi.getTitle() != null && !gi.getTitle().trim().isEmpty() ? gi.getTitle() : "Untitled";
                %>
                <div class="gcard">
                    <% if (!giPath.isEmpty()) { %>
                    <img src="<%=request.getContextPath()%>/<%=giPath%>"
                         class="gcard-img" alt="<%= giTitle %>"
                         onerror="this.style.display='none';this.nextElementSibling.style.display='flex'">
                    <div class="gcard-img-placeholder" style="display:none;"><i class="bi bi-image"></i></div>
                    <% } else { %>
                    <div class="gcard-img-placeholder"><i class="bi bi-image"></i></div>
                    <% } %>
                    <div class="gcard-body">
                        <div class="gcard-title"><%= giTitle %></div>
                        <form method="post" action="<%=request.getContextPath()%>/admin/delete-gallery"
                              onsubmit="return confirm('Delete this image?');" style="margin:0;">
                            <input type="hidden" name="imageId" value="<%= gi.getImageId() %>">
                            <button type="submit" class="btn-danger-custom" style="width:100%;">
                                <i class="bi bi-trash"></i> Delete
                            </button>
                        </form>
                    </div>
                </div>
                <% } %>
            </div>
            <% } %>
            </div>
        </div>
    </div>
</div>
</body>
</html>
