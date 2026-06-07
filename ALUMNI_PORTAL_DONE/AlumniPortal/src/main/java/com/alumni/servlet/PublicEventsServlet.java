package com.alumni.servlet;

import com.alumni.dao.EventDao;
import com.alumni.model.Event;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/events")
public class PublicEventsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            EventDao dao = new EventDao();
            List<Event> events = dao.getAllEvents();

            request.setAttribute("events", events);
            request.getRequestDispatcher("/portal/events.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading public events", e);
        }
    }
}