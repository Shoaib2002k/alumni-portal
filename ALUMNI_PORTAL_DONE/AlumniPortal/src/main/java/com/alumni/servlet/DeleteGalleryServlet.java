package com.alumni.servlet;

import com.alumni.dao.GalleryDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/delete-gallery")
public class DeleteGalleryServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String imageIdStr = request.getParameter("imageId");

            if (imageIdStr != null && !imageIdStr.trim().isEmpty()) {
                int imageId = Integer.parseInt(imageIdStr);

                GalleryDao dao = new GalleryDao();
                dao.deleteGallery(imageId);
            } else {
                System.out.println("imageId is missing from request");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/admin/gallery");
    }
}