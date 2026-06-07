package com.alumni.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/staff-logout")
public class StaffLogoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute("staffUser");
            session.invalidate();
        }
        response.sendRedirect(request.getContextPath() + "/staff/login.jsp");
    }
}
