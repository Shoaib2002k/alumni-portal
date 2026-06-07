package com.alumni.servlet;

import com.alumni.dao.UserDao;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/delete-member")
public class DeleteMemberServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");

        if (idStr != null) {
            int userId = Integer.parseInt(idStr);

            UserDao dao = new UserDao();
            dao.deleteMember(userId);
        }

        // Redirect back to admin members list
        response.sendRedirect(request.getContextPath() + "/admin/members");
    }
}