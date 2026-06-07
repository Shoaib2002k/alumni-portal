package com.alumni.servlet;

import com.alumni.dao.EventDao;
import com.alumni.model.Event;
import com.alumni.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;
import java.util.List;

@WebServlet("/admin/events")
@MultipartConfig
public class AdminEventsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            EventDao dao = new EventDao();
            List<Event> events = dao.getAllEvents();
            request.setAttribute("events", events);
            request.getRequestDispatcher("/admin/events.jsp").forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading events", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String title = request.getParameter("title");
            String description = request.getParameter("description");
            String eventDateStr = request.getParameter("eventDate");
            String location = request.getParameter("location");

            Part imagePart = request.getPart("image");

            HttpSession session = request.getSession(false);
            User admin = (User) session.getAttribute("user");

            String imagePath = null;

            if (imagePart != null && imagePart.getSize() > 0) {
                String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();

                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads" + File.separator + "events";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs();
                }

                String savedFileName = System.currentTimeMillis() + "_" + fileName;
                imagePart.write(uploadPath + File.separator + savedFileName);

                imagePath = "uploads/events/" + savedFileName;
            }

            Event event = new Event();
            event.setTitle(title);
            event.setDescription(description);
            event.setEventDate(Date.valueOf(eventDateStr));
            event.setLocation(location);
            event.setImagePath(imagePath);
            event.setCreatedBy(admin.getUserId());

            EventDao dao = new EventDao();
            dao.addEvent(event);

            response.sendRedirect(request.getContextPath() + "/admin/events");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error adding event", e);
        }
    }
}