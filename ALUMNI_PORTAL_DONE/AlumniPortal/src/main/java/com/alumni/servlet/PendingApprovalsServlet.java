package com.alumni.servlet;

import com.alumni.dao.UserDao;
import com.alumni.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/admin/pending-approvals")
public class PendingApprovalsServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            UserDao dao = new UserDao();
            List<User> pendingUsers = dao.getPendingAlumniUsers();

            request.setAttribute("pendingUsers", pendingUsers);
            request.getRequestDispatcher("/admin/pending-approvals.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Error loading pending approvals", e);
        }
    }
}