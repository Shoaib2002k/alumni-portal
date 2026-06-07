package com.alumni.servlet;

import com.alumni.dao.SiteSettingsDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/home")
public class HomeServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            SiteSettingsDao dao = new SiteSettingsDao();
            Map<String, String> settings = dao.getAllSettings();

            request.setAttribute("settings", settings);
            request.getRequestDispatcher("/index.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading homepage settings", e);
        }
    }
}