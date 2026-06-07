package com.alumni.servlet;

import com.alumni.dao.UserDao;
import com.alumni.model.AlumniProfile;

import java.io.IOException;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/staff/members")
public class StaffMembersServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            UserDao dao = new UserDao();

            /* Reuse existing getApprovedAlumniFullDetails() from UserDao */
            List<AlumniProfile> members = dao.getApprovedAlumniFullDetails();

            request.setAttribute("members", members);
            request.getRequestDispatcher("/staff/members.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading staff members page", e);
        }
    }
}
