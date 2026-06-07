package com.alumni.servlet;

import com.alumni.dao.UserDao;
import com.alumni.model.AlumniProfile;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/members")
public class MembersServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            UserDao dao = new UserDao();
            List<AlumniProfile> members = dao.getApprovedAlumni();

            request.setAttribute("members", members);
            request.getRequestDispatcher("/portal/members.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading members page", e);
        }
    }
}