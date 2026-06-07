package com.alumni.servlet;

import com.alumni.dao.UserDao;
import com.alumni.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/members")
public class AdminMembersServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String status = request.getParameter("status");

        try {
            UserDao dao = new UserDao();
            List<User> members = dao.getAllAlumniUsers(keyword, status);

            request.setAttribute("members", members);
            request.setAttribute("keyword", keyword);
            request.setAttribute("status", status);

            request.getRequestDispatcher("/admin/members.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading members", e);
        }
    }
}