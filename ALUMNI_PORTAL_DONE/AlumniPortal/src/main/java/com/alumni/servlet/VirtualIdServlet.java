package com.alumni.servlet;

import com.alumni.dao.UserDao;
import com.alumni.model.AlumniProfile;
import com.alumni.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/portal/virtual-id")
public class VirtualIdServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        User loggedInUser = (User) session.getAttribute("user");

        if (loggedInUser == null || loggedInUser.getUserId() <= 0) {
            response.sendRedirect(request.getContextPath() + "/auth/login.jsp");
            return;
        }

        try {
            UserDao dao = new UserDao();
            AlumniProfile profile = dao.getVirtualIdProfile(loggedInUser.getUserId());

            if (profile == null) {
                request.setAttribute("error", "Virtual ID is available only after admin approval.");
                request.getRequestDispatcher("/portal/welcome.jsp").forward(request, response);
                return;
            }

            request.setAttribute("profile", profile);
            request.getRequestDispatcher("/portal/virtual-id.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Unable to load Virtual ID. Please try again.");
            request.getRequestDispatcher("/portal/welcome.jsp").forward(request, response);
        }
    }
}