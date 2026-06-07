package com.alumni.servlet;

import com.alumni.dao.UserDao;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/verify-otp")
public class VerifyOtpServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String otpCode = request.getParameter("otpCode");

        try {
            UserDao dao = new UserDao();

            boolean valid = dao.verifyOtp(email, otpCode);

            if (!valid) {
                request.setAttribute("error", "Invalid or expired OTP.");
                request.setAttribute("email", email);
                request.getRequestDispatcher("/auth/verify-otp.jsp").forward(request, response);
                return;
            }

            dao.markEmailVerified(email);
            dao.markOtpUsed(email, otpCode);

            request.setAttribute("success", "Email verified successfully. Please login.");
            request.getRequestDispatcher("/auth/login.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "OTP verification failed: " + e.getMessage());
            request.setAttribute("email", email);
            request.getRequestDispatcher("/auth/verify-otp.jsp").forward(request, response);
        }
    }
}