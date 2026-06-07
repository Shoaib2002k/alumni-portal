package com.alumni.servlet;

import com.alumni.dao.UserDao;
import com.alumni.model.AlumniProfile;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/member-profile")
public class AdminMemberProfileServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userIdStr = request.getParameter("userId");

        try {
            int userId = Integer.parseInt(userIdStr);

            UserDao dao = new UserDao();
            AlumniProfile profile = dao.getAlumniProfileByUserId(userId);

            request.setAttribute("profile", profile);
            request.getRequestDispatcher("/admin/member-profile.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading member profile", e);
        }
    }
}