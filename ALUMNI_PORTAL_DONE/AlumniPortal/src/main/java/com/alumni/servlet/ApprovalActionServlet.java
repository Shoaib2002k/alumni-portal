package com.alumni.servlet;

import com.alumni.dao.UserDao;
import com.alumni.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/admin/approval-action")
public class ApprovalActionServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String userIdStr = request.getParameter("userId");
        String action = request.getParameter("action");
        String reason = request.getParameter("reason");

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/admin/login.jsp");
            return;
        }

        User admin = (User) session.getAttribute("user");

        try {
            int userId = Integer.parseInt(userIdStr);

            UserDao dao = new UserDao();

            if ("approve".equalsIgnoreCase(action)) {
                dao.approveUser(userId, admin.getUserId());
            } else if ("reject".equalsIgnoreCase(action)) {
                if (reason == null || reason.trim().isEmpty()) {
                    reason = "Rejected by admin";
                }
                dao.rejectUser(userId, admin.getUserId(), reason);
            }

            response.sendRedirect(request.getContextPath() + "/admin/pending-approvals?success=1");

        } catch (Exception e) {
            e.printStackTrace();
            throw new ServletException("Approval action failed", e);
        }
    }
}