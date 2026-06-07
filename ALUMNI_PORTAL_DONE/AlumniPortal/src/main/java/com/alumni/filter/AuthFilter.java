package com.alumni.filter;

import com.alumni.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/portal/*")
public class AuthFilter implements Filter {

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse res = (HttpServletResponse) response;

        HttpSession session = req.getSession(false);

        if (session == null) {
            res.sendRedirect(req.getContextPath() + "/auth/login.jsp");
            return;
        }

        User user = (User) session.getAttribute("user");

        if (user == null) {
            res.sendRedirect(req.getContextPath() + "/auth/login.jsp");
            return;
        }

        chain.doFilter(request, response);
    }
}