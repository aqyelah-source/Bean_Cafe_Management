package com.beancafe.controller;

import com.beancafe.dao.AdminDAO;
import com.beancafe.dao.ReportDAO;
import com.beancafe.model.Order;
import com.beancafe.model.Report;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.ArrayList;

@WebServlet("/report")
public class ReportServlet extends HttpServlet {

    private ReportDAO reportDAO;

    @Override
    public void init() {
        reportDAO = new ReportDAO();
    }


    // ==========================================
    // DEFAULT REPORT
    // Automatically display current year
    // ==========================================
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        // =========================
        // ADMIN SECURITY CHECK
        // =========================
        if (session == null
                || session.getAttribute("role") == null
                || !"Admin".equalsIgnoreCase(
                        (String) session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp");

            return;
        }


        // =========================
        // DEFAULT FILTER
        // =========================
        int currentYear =
                LocalDate.now().getYear();

        int month = 0; // All Months
        int year = currentYear;


        // =========================
        // GET ADMIN ID
        // =========================
        int userId =
                (Integer) session.getAttribute(
                        "userId");

        AdminDAO adminDAO =
                new AdminDAO();

        int adminId =
                adminDAO.getAdminIdByUserId(
                        userId);
        
        


        // =========================
        // REPORT SUMMARY
        // =========================
        Report generatedReport =
                reportDAO.generateMonthlyReport(
                        adminId,
                        month,
                        year);


        // =========================
        // ORDER SUMMARY
        // Latest -> Oldest
        // =========================
        List<Order> orderList =
                reportDAO.getOrdersForReport(
                        month,
                        year);
        
        int recordsPerPage = 5;
        int currentPage = 1;

        int totalRecords =
                orderList.size();

        int totalPages =
                (int) Math.ceil(
                        (double) totalRecords
                        / recordsPerPage);

        List<Order> paginatedOrders =
                paginateOrders(
                        orderList,
                        currentPage,
                        recordsPerPage);
        
        


        // =========================
        // SALES GRAPH
        // =========================
        Map<Integer, Double> salesByMonth =
                reportDAO.getMonthlySalesByYear(
                        year);


        // =========================
        // SEND DATA TO JSP
        // =========================
        request.setAttribute(
                "generatedReport",
                generatedReport);

        request.setAttribute(
        "orderList",
        paginatedOrders);

        request.setAttribute(
                "currentPage",
                currentPage);

        request.setAttribute(
                "totalPages",
                totalPages);

        request.setAttribute(
                "salesByMonth",
                salesByMonth);

        request.setAttribute(
                "selectedMonth",
                month);

        request.setAttribute(
                "selectedYear",
                year);


        request.getRequestDispatcher(
                "/report.jsp")
                .forward(
                        request,
                        response);
    }


    // ==========================================
    // POST - GENERATE REPORT
    // ==========================================
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);


        // =========================
        // ADMIN SECURITY CHECK
        // =========================
        if (session == null
                || session.getAttribute("role") == null
                || !"Admin".equalsIgnoreCase(
                        (String) session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp");

            return;
        }


        String action =
                request.getParameter(
                        "action");


        if ("generate".equals(action)) {

            generateReport(
                    request,
                    response);

        } else {

            response.sendRedirect(
                    request.getContextPath()
                    + "/report");
        }
    }
    
    // ==========================================
    // ORDER PAGINATION
    // ==========================================
    private List<Order> paginateOrders(
            List<Order> orderList,
            int currentPage,
            int recordsPerPage) {

        if (orderList == null
                || orderList.isEmpty()) {

            return new ArrayList<>();
        }

        int start =
                (currentPage - 1)
                * recordsPerPage;

        if (start >= orderList.size()) {
            start = 0;
        }

        int end =
                Math.min(
                        start + recordsPerPage,
                        orderList.size());

        return new ArrayList<>(
                orderList.subList(
                        start,
                        end));
    }


    // ==========================================
    // GENERATE REPORT BASED ON FILTER
    // ==========================================
    private void generateReport(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            // =========================
            // GET FILTER
            // =========================
            int month =
                    Integer.parseInt(
                            request.getParameter(
                                    "month"));

            int year =
                    Integer.parseInt(
                            request.getParameter(
                                    "year"));


            // =========================
            // GET ADMIN ID
            // =========================
            HttpSession session =
                    request.getSession(false);

            int userId =
                    (Integer) session.getAttribute(
                            "userId");

            AdminDAO adminDAO =
                    new AdminDAO();

            int adminId =
                    adminDAO.getAdminIdByUserId(
                            userId);


            // =========================
            // REPORT SUMMARY
            // =========================
            Report generatedReport =
                    reportDAO.generateMonthlyReport(
                            adminId,
                            month,
                            year);


            // =========================
            // ORDERS BASED ON FILTER
            // =========================
            List<Order> orderList =
                    reportDAO.getOrdersForReport(
                            month,
                            year);
            
            // =========================
            // PAGINATION
            // =========================
            int recordsPerPage = 5;
            int currentPage = 1;

            String pageParam =
                    request.getParameter("page");

            if (pageParam != null) {

                try {
                    currentPage =
                            Integer.parseInt(pageParam);

                } catch (NumberFormatException e) {
                    currentPage = 1;
                }
            }

            int totalRecords =
                    orderList.size();

            int totalPages =
                    (int) Math.ceil(
                            (double) totalRecords
                            / recordsPerPage);

            if (currentPage < 1) {
                currentPage = 1;
            }

            if (totalPages > 0
                    && currentPage > totalPages) {

                currentPage = totalPages;
            }

            List<Order> paginatedOrders =
                    paginateOrders(
                            orderList,
                            currentPage,
                            recordsPerPage);


            // =========================
            // SALES DATA
            // JSP decides whether to show
            // all months or selected month
            // =========================
            Map<Integer, Double> salesByMonth =
                    reportDAO.getMonthlySalesByYear(
                            year);


            // =========================
            // SEND DATA TO JSP
            // =========================
            request.setAttribute(
                    "generatedReport",
                    generatedReport);

            request.setAttribute(
                    "orderList",
                    paginatedOrders);

            request.setAttribute(
                    "currentPage",
                    currentPage);

            request.setAttribute(
                    "totalPages",
                    totalPages);

            request.setAttribute(
                    "salesByMonth",
                    salesByMonth);

            request.setAttribute(
                    "selectedMonth",
                    month);

            request.setAttribute(
                    "selectedYear",
                    year);


            request.getRequestDispatcher(
                    "/report.jsp")
                    .forward(
                            request,
                            response);


        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/report");
        }
    }
}