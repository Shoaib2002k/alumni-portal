package com.alumni.servlet;

import com.alumni.dao.UserDao;
import com.alumni.model.User;
import com.alumni.util.PasswordUtil;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/alumni-login")
public class AlumniLoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        try {
            // ✅ Hash password
            String hashedPassword = PasswordUtil.hashPassword(password);

            UserDao dao = new UserDao();
            User user = dao.findAlumniLogin(email, hashedPassword);

            // ❌ Invalid login
            if (user == null) {
                request.setAttribute("error", "Invalid email or password.");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }

            // ❌ Email not verified
            if (!"Y".equalsIgnoreCase(user.getEmailVerified())) {
                request.setAttribute("error", "Please verify your email using OTP first.");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }

            // ❌ Not approved by admin
            if (!"APPROVED".equalsIgnoreCase(user.getStatus())) {
                request.setAttribute("error", "Your account is waiting for admin approval.");
                request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
                return;
            }

            // ✅ CREATE SESSION (IMPORTANT FIX)
            HttpSession session = request.getSession(true);
            session.setAttribute("user", user);

            // ✅ OPTIONAL: set session timeout (30 mins)
            session.setMaxInactiveInterval(30 * 60);

            // ✅ REDIRECT TO HOME (IMPORTANT CHANGE)
            response.sendRedirect(request.getContextPath() + "/home");

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Login failed: " + e.getMessage());
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);
        }
    }
}