package com.alumni.servlet;

import com.alumni.dao.GalleryDao;
import com.alumni.model.Gallery;
import com.alumni.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.util.List;

@WebServlet("/admin/gallery")
@MultipartConfig
public class AdminGalleryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            GalleryDao dao = new GalleryDao();
            List<Gallery> images = dao.getAllImages();
            request.setAttribute("images", images);
            request.getRequestDispatcher("/admin/gallery.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading gallery", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String title = request.getParameter("title");
            Part imagePart = request.getPart("image");

            HttpSession session = request.getSession(false);
            User admin = (User) session.getAttribute("user");

            if (imagePart == null || imagePart.getSize() == 0) {
                throw new ServletException("Please choose an image.");
            }

            String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();

            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "gallery";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }

            String savedFileName = System.currentTimeMillis() + "_" + fileName;
            imagePart.write(uploadPath + File.separator + savedFileName);

            String imagePath = "uploads/gallery/" + savedFileName;

            Gallery gallery = new Gallery();
            gallery.setTitle(title);
            gallery.setImagePath(imagePath);
            gallery.setUploadedBy(admin.getUserId());

            GalleryDao dao = new GalleryDao();
            dao.addImage(gallery);

            response.sendRedirect(request.getContextPath() + "/admin/gallery");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error uploading gallery image", e);
        }
    }
}