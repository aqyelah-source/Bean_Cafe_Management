package com.beancafe.controller;

import com.beancafe.dao.OrderHistoryDAO;
import com.beancafe.model.OrderHistory;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/order-history")
public class OrderHistoryServlet extends HttpServlet {

    private OrderHistoryDAO orderHistoryDAO;

    @Override
    public void init() {

        orderHistoryDAO = new OrderHistoryDAO();
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


        // ==========================================
        // PAGINATION SETTINGS
        // ==========================================
        int currentPage = 1;
        int recordsPerPage = 5;


        // Get page number from URL
        String pageParameter
                = request.getParameter("page");


        if (pageParameter != null
                && !pageParameter.trim().isEmpty()) {

            try {

                currentPage
                        = Integer.parseInt(
                                pageParameter
                        );

                if (currentPage < 1) {

                    currentPage = 1;
                }

            } catch (NumberFormatException e) {

                currentPage = 1;
            }
        }


        // ==========================================
        // CHECK SEARCH
        // ==========================================
        String action
                = request.getParameter("action");

        String orderIdParameter
                = request.getParameter("orderId");


        List<OrderHistory> historyList;

        int totalRecords;
        int totalPages;


        // ==========================================
        // SEARCH BY ORDER ID
        // ==========================================
        if ("search".equalsIgnoreCase(action)
                && orderIdParameter != null
                && !orderIdParameter.trim().isEmpty()) {

            try {

                int orderId
                        = Integer.parseInt(
                                orderIdParameter
                        );


                // Count history for searched order
                totalRecords
                        = orderHistoryDAO
                                .getHistoryCountByOrderId(
                                        orderId
                                );


                // Calculate total pages
                totalPages
                        = (int) Math.ceil(
                                (double) totalRecords
                                / recordsPerPage
                        );


                // Prevent page number exceeding total pages
                if (totalPages > 0
                        && currentPage > totalPages) {

                    currentPage = totalPages;
                }


                // Get only 5 searched records
                historyList
                        = orderHistoryDAO
                                .getHistoryByOrderIdPage(
                                        orderId,
                                        currentPage,
                                        recordsPerPage
                                );


                // Keep searched Order ID
                request.setAttribute(
                        "searchedOrderId",
                        orderId
                );


            } catch (NumberFormatException e) {

                // If invalid Order ID,
                // show normal history instead

                totalRecords
                        = orderHistoryDAO
                                .getHistoryCount();


                totalPages
                        = (int) Math.ceil(
                                (double) totalRecords
                                / recordsPerPage
                        );


                if (totalPages > 0
                        && currentPage > totalPages) {

                    currentPage = totalPages;
                }


                historyList
                        = orderHistoryDAO
                                .getHistoryByPage(
                                        currentPage,
                                        recordsPerPage
                                );
            }


        } else {

            // ==========================================
            // SHOW ALL ORDER HISTORY
            // ==========================================

            // Count all history records
            totalRecords
                    = orderHistoryDAO
                            .getHistoryCount();


            // Calculate total pages
            totalPages
                    = (int) Math.ceil(
                            (double) totalRecords
                            / recordsPerPage
                    );


            // Prevent page number exceeding total pages
            if (totalPages > 0
                    && currentPage > totalPages) {

                currentPage = totalPages;
            }


            // Get only 5 records for current page
            historyList
                    = orderHistoryDAO
                            .getHistoryByPage(
                                    currentPage,
                                    recordsPerPage
                            );
        }


        // ==========================================
        // SEND DATA TO JSP
        // ==========================================
        request.setAttribute(
                "historyList",
                historyList
        );


        request.setAttribute(
                "currentPage",
                currentPage
        );


        request.setAttribute(
                "totalPages",
                totalPages
        );


        // ==========================================
        // DISPLAY ORDER HISTORY PAGE
        // ==========================================
        request.getRequestDispatcher(
                "/order-history.jsp"
        ).forward(
                request,
                response
        );
    }
}