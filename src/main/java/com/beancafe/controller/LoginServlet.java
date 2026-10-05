package com.beancafe.controller;

import com.beancafe.dao.UserDAO;
import com.beancafe.model.User;
import com.beancafe.util.PasswordUtil;

import java.io.IOException;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;


@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        UserDAO userDAO = new UserDAO();
        User user = userDAO.getUserByUsername(username);

        if (user != null && PasswordUtil.checkPassword(password, user.getPassword())) {
            // valid credentials -> create session
            HttpSession session = request.getSession();
            session.setAttribute("userId", user.getUserId());
            session.setAttribute("name", user.getName());
            session.setAttribute("role", user.getRole());

            if ("Admin".equalsIgnoreCase(user.getRole())) {

                response.sendRedirect(
                    request.getContextPath() + "/admin-dashboard"
                );

            } else if ("Staff".equalsIgnoreCase(user.getRole())) {

                response.sendRedirect(
                    request.getContextPath() + "/order?action=add"
                );
            }
        } else {
            // invalid credentials -> show error back on login.jsp
            request.setAttribute("errorMessage", "Invalid username or password.");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
