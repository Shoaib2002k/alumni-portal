package com.alumni.servlet;

import com.alumni.dao.GalleryDao;
import com.alumni.model.Gallery;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/gallery")
public class PublicGalleryServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            GalleryDao dao = new GalleryDao();
            List<Gallery> images = dao.getAllImages();

            request.setAttribute("images", images);
            request.getRequestDispatcher("/portal/gallery.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading public gallery", e);
        }
    }
}