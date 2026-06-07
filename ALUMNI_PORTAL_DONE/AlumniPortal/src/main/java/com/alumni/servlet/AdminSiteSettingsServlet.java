package com.alumni.servlet;

import com.alumni.dao.SiteSettingsDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.Map;

@WebServlet("/admin/site-settings")
public class AdminSiteSettingsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            SiteSettingsDao dao = new SiteSettingsDao();
            Map<String, String> settings = dao.getAllSettings();

            request.setAttribute("settings", settings);
            request.getRequestDispatcher("/admin/site-settings.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading site settings", e);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            String siteName = request.getParameter("siteName");
            String aboutText = request.getParameter("aboutText");
            String primaryColor = request.getParameter("primaryColor");
            String logoPath = request.getParameter("logoPath");

            SiteSettingsDao dao = new SiteSettingsDao();
            dao.saveSetting("SITE_NAME", siteName);
            dao.saveSetting("ABOUT_TEXT", aboutText);
            dao.saveSetting("PRIMARY_COLOR", primaryColor);
            dao.saveSetting("LOGO_PATH", logoPath);

            response.sendRedirect(request.getContextPath() + "/admin/site-settings");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error saving site settings", e);
        }
    }
}