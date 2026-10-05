package com.beancafe.filter;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

/**
 * Blocks access to anything under /staff/* unless the session role is Staff.
 * Put staff-only JSPs inside a folder called "staff" under Web Pages
 * (e.g. Web Pages/staff/...) for this URL pattern to cover them.
 */
@WebFilter("/staff/*")
public class StaffFilter implements Filter {

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;
        HttpSession session = request.getSession(false);

        if (session != null
                && "Staff".equalsIgnoreCase(
                        (String) session.getAttribute("role"))) {

            chain.doFilter(req, res);

        } else {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
        }
    }
}
