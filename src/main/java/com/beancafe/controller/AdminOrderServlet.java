package com.beancafe.controller;

import com.beancafe.dao.OrderDAO;
import com.beancafe.model.Order;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/admin-order")
public class AdminOrderServlet extends HttpServlet {

    private OrderDAO orderDAO;

    @Override
    public void init() {

        orderDAO = new OrderDAO();
    }

    // ==========================================
    // HANDLE GET REQUEST
    // ==========================================
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session
                = request.getSession(false);

        // ==========================================
        // ADMIN ONLY
        // ==========================================
        if (session == null
                || session.getAttribute("role") == null
                || !"Admin".equalsIgnoreCase(
                        (String) session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        String action
                = request.getParameter("action");

        if (action == null) {

            action = "list";
        }

        switch (action) {

            // ==================================
            // VIEW ORDER DETAILS
            // ==================================
            case "view":

                viewOrder(
                        request,
                        response
                );

                break;

            // ==================================
            // DISPLAY / FILTER / SEARCH ORDERS
            // ==================================
            case "list":

            default:

                listOrders(
                        request,
                        response
                );

                break;
        }
    }

    // ==========================================
    // LIST / FILTER / SEARCH ORDERS
    // ==========================================
    private void listOrders(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        // ==========================================
        // STATUS FILTER
        // ==========================================
        String selectedStatus
                = request.getParameter("status");

        // Default filter = All
        if (selectedStatus == null
                || selectedStatus.trim().isEmpty()) {

            selectedStatus = "All";
        }

        // Only allow valid order status
        if (!selectedStatus.equalsIgnoreCase("All")
                && !selectedStatus.equalsIgnoreCase("Pending")
                && !selectedStatus.equalsIgnoreCase("Preparing")
                && !selectedStatus.equalsIgnoreCase("Ready")
                && !selectedStatus.equalsIgnoreCase("Completed")
                && !selectedStatus.equalsIgnoreCase("Cancelled")) {

            selectedStatus = "All";
        }

        // ==========================================
        // SEARCH BY ORDER ID
        // ==========================================
        String searchText
                = request.getParameter("search");

        if (searchText == null) {

            searchText = "";
        }

        searchText
                = searchText.trim();

        Integer searchOrderId = null;

        boolean invalidSearch = false;

        // Only process search if user typed something
        if (!searchText.isEmpty()) {

            // Allow both:
            // 155
            // #155
            String cleanSearch
                    = searchText
                            .replace("#", "")
                            .trim();

            try {

                searchOrderId
                        = Integer.parseInt(cleanSearch);

                if (searchOrderId <= 0) {

                    invalidSearch = true;
                }

            } catch (NumberFormatException e) {

                invalidSearch = true;
            }
        }

        // ==========================================
        // PAGINATION
        // ==========================================
        int currentPage = 1;

        int recordsPerPage = 5;

        try {

            String pageParam
                    = request.getParameter("page");

            if (pageParam != null) {

                currentPage
                        = Integer.parseInt(pageParam);
            }

            if (currentPage < 1) {

                currentPage = 1;
            }

        } catch (NumberFormatException e) {

            currentPage = 1;
        }

        // ==========================================
        // COUNT FILTERED RECORDS
        // ==========================================
        int totalRecords;

        if (invalidSearch) {

            totalRecords = 0;

        } else {

            totalRecords
                    = orderDAO.getOrderCount(
                            selectedStatus,
                            searchOrderId
                    );
        }

        int totalPages
                = (int) Math.ceil(
                        (double) totalRecords
                        / recordsPerPage
                );

        if (totalPages < 1) {

            totalPages = 1;
        }

        if (currentPage > totalPages) {

            currentPage = totalPages;
        }

        // ==========================================
        // GET ORDERS FOR CURRENT PAGE
        // ==========================================
        List<Order> orderList;

        if (invalidSearch) {

            orderList
                    = new ArrayList<>();

        } else {

            orderList
                    = orderDAO.getOrdersByPage(
                            currentPage,
                            recordsPerPage,
                            selectedStatus,
                            searchOrderId
                    );
        }

        // ==========================================
        // SEND DATA TO JSP
        // ==========================================
        request.setAttribute(
                "orderList",
                orderList
        );

        request.setAttribute(
                "currentPage",
                currentPage
        );

        request.setAttribute(
                "totalPages",
                totalPages
        );

        request.setAttribute(
                "totalRecords",
                totalRecords
        );

        request.setAttribute(
                "selectedStatus",
                selectedStatus
        );

        request.setAttribute(
                "searchOrderId",
                searchText
        );

        request.getRequestDispatcher(
                "/admin-order-list.jsp"
        ).forward(
                request,
                response
        );
    }

    // ==========================================
    // VIEW ORDER DETAILS
    // ==========================================
    private void viewOrder(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int orderId
                    = Integer.parseInt(
                            request.getParameter("id")
                    );

            Order order
                    = orderDAO.getOrderById(
                            orderId
                    );

            // ==================================
            // ORDER NOT FOUND
            // ==================================
            if (order == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-order?error=notfound"
                );

                return;
            }

            request.setAttribute(
                    "order",
                    order
            );

            request.getRequestDispatcher(
                    "/admin-order-view.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-order"
            );
        }
    }
}
