package com.alumni.servlet;

import com.alumni.dao.EventDao;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/admin/delete-event")
public class DeleteEventServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String eventIdStr = request.getParameter("eventId");

        try {
            int eventId = Integer.parseInt(eventIdStr);

            EventDao eventDao = new EventDao();
            boolean deleted = eventDao.deleteEvent(eventId);

            response.sendRedirect(request.getContextPath() + "/admin/events");

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/admin/events");
        }
    }
}