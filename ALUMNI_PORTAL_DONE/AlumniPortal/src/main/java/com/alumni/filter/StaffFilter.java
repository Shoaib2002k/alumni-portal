package com.alumni.filter;

import com.alumni.model.User;

import javax.servlet.*;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter("/staff/*")
public class StaffFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req = (HttpServletRequest)  request;
        HttpServletResponse res = (HttpServletResponse) response;

        String uri = req.getRequestURI();

        /* Allow login page and login action through without a session */
        if (uri.endsWith("/staff/login.jsp") || uri.endsWith("/staff-login")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);

        if (session == null) {
            res.sendRedirect(req.getContextPath() + "/staff/login.jsp");
            return;
        }

        User staffUser = (User) session.getAttribute("staffUser");

        if (staffUser == null || !"STAFF".equals(staffUser.getRole())) {
            res.sendRedirect(req.getContextPath() + "/staff/login.jsp");
            return;
        }

        chain.doFilter(request, response);
    }

    @Override public void init(FilterConfig filterConfig) {}
    @Override public void destroy() {}
}
