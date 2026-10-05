package com.beancafe.controller;

import com.beancafe.dao.AdminDashboardDAO;
import com.beancafe.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin-dashboard")
public class AdminDashboardServlet extends HttpServlet {

    private AdminDashboardDAO dashboardDAO;

    @Override
    public void init() {

        dashboardDAO
                = new AdminDashboardDAO();
    }

    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session
                = request.getSession(false);

        // ADMIN ONLY
        if (session == null
                || session.getAttribute("role") == null
                || !"Admin".equalsIgnoreCase(
                        (String) session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp");

            return;
        }

        // GET DASHBOARD INFORMATION
        int totalStaff
                = dashboardDAO.getTotalStaff();

        int totalMenu
                = dashboardDAO.getTotalMenuItems();

        int totalOrders
                = dashboardDAO.getTotalOrders();

        double totalSales
                = dashboardDAO.getTotalSales();

        List<Order> recentOrders
                = dashboardDAO.getRecentOrders();

        // SEND DATA TO JSP
        request.setAttribute(
                "totalStaff",
                totalStaff);

        request.setAttribute(
                "totalMenu",
                totalMenu);

        request.setAttribute(
                "totalOrders",
                totalOrders);

        request.setAttribute(
                "totalSales",
                totalSales);

        request.setAttribute(
                "recentOrders",
                recentOrders);

        request.getRequestDispatcher(
                "/admin-dashboard.jsp")
                .forward(request, response);
    }
}
