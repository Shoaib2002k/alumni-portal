package com.alumni.servlet;

import com.alumni.dao.UserDao;
import com.alumni.model.User;
import com.alumni.util.PasswordUtil;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/staff-login")
public class StaffLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email    = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            String hashedPassword = PasswordUtil.hashPassword(password);

            UserDao dao = new UserDao();
            User user   = dao.findStaffLogin(email, hashedPassword);

            if (user == null) {
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("/staff/login.jsp").forward(request, response);
                return;
            }

            HttpSession session = request.getSession(true);
            session.setAttribute("staffUser", user);
            session.setMaxInactiveInterval(30 * 60);

            response.sendRedirect(request.getContextPath() + "/staff/dashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Login failed: " + e.getMessage());
            request.getRequestDispatcher("/staff/login.jsp").forward(request, response);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect(request.getContextPath() + "/staff/login.jsp");
    }
}
