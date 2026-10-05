<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Map" %>
<%@ page import="com.beancafe.model.Report" %>
<%@ page import="com.beancafe.model.Order" %>

<%
    // ==========================================
    // ADMIN ONLY
    // ==========================================
    if (session.getAttribute("role") == null
            || !"Admin".equalsIgnoreCase(
                    (String) session.getAttribute("role"))) {

        response.sendRedirect("login.jsp");
        return;
    }

    // ==========================================
    // REPORT DATA
    // ==========================================
    Report generatedReport
            = (Report) request.getAttribute("generatedReport");

    List<Order> orderList
            = (List<Order>) request.getAttribute("orderList");

    Map<Integer, Double> salesByMonth
            = (Map<Integer, Double>) request.getAttribute("salesByMonth");

    Integer selectedMonth
            = (Integer) request.getAttribute("selectedMonth");

    Integer selectedYear
            = (Integer) request.getAttribute("selectedYear");

    Integer currentPage
            = (Integer) request.getAttribute("currentPage");

    Integer totalPages
            = (Integer) request.getAttribute("totalPages");

    if (currentPage == null) {
        currentPage = 1;
    }

    if (totalPages == null) {
        totalPages = 1;
    }

    String[] monthNames = {
        "",
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December"
    };

    // ==========================================
    // FIND MAXIMUM SALES FOR GRAPH
    // ==========================================
    double maxSales = 0;

    if (salesByMonth != null) {

        for (Double sales : salesByMonth.values()) {

            if (sales != null && sales > maxSales) {

                maxSales = sales;
            }
        }
    }
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>
        Order Summary & Report - Bean Cafe
    </title>

    <style>

        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: Arial, sans-serif;
            background: #f6ede3;
            color: #2f1b10;
        }

        /* =========================
           HEADER
           ========================= */

        header {
            height: 82px;
            background: #f9f1e7;
            border-top: 6px solid #4b2e1e;
            border-bottom: 1px solid #dfd1c3;
            padding: 0 28px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .brand {
            font-size: 25px;
            font-weight: bold;
            color: #321b0f;
        }

        .user-area {
            display: flex;
            align-items: center;
            gap: 24px;
        }

        .user-info {
            text-align: right;
        }

        .user-info strong {
            display: block;
            font-size: 15px;
        }

        .user-info span {
            display: block;
            font-size: 13px;
            color: #7a573e;
            margin-top: 2px;
        }

        .logout {
            background: #4b2e1e;
            color: white;
            text-decoration: none;
            padding: 11px 22px;
            border-radius: 24px;
            font-weight: bold;
        }

        .logout:hover {
            background: #6f4e37;
        }

        /* =========================
           MAIN LAYOUT
           ========================= */

        .main-layout {
            display: flex;
            min-height: calc(100vh - 82px);
        }

        /* =========================
           SIDEBAR
           ========================= */

        .sidebar {
            width: 235px;
            flex-shrink: 0;
            background: #f8efe5;
            border-right: 1px solid #dfd1c3;
            padding: 28px 16px;
        }

        .sidebar-title {
            color: #7a573e;
            font-size: 15px;
            font-weight: bold;
            margin: 0 10px 18px;
        }

        .menu-item {
            display: block;
            padding: 13px 16px;
            margin-bottom: 8px;
            text-decoration: none;
            color: #4b2e1e;
            font-size: 15px;
            font-weight: 600;
            border-radius: 20px;
        }

        .menu-item:hover {
            background: #eadccc;
        }

        .menu-item.active {
            background: #4b2e1e;
            color: white;
        }

        /* =========================
           CONTENT
           ========================= */

        .content {
            flex: 1;
            padding: 32px;
            min-width: 0;
        }

        .page-heading {
            margin-bottom: 25px;
        }

        .page-heading h1 {
            margin: 0 0 8px;
            font-size: 28px;
            color: #2f1b10;
        }

        .page-heading p {
            margin: 0;
            color: #7a573e;
            font-size: 16px;
        }

        /* =========================
           REPORT FORM
           ========================= */

        .report-form {
            background: #fffaf5;
            padding: 22px;
            border: 1px solid #e4d7ca;
            border-radius: 14px;
            display: flex;
            gap: 10px;
            align-items: center;
        }

        .report-form select,
        .report-form input {
            height: 46px;
            padding: 0 14px;
            font-size: 16px;
            border: 1px solid #d8c7b7;
            border-radius: 8px;
            background: white;
            outline: none;
        }

        .report-form select {
            width: 200px;
        }

        .report-form input {
            width: 200px;
        }

        .report-form select:focus,
        .report-form input:focus {
            border-color: #7a573e;
        }

        /* =========================
           BUTTON
           ========================= */

        .btn {
            height: 46px;
            padding: 0 20px;
            border: none;
            border-radius: 8px;
            font-size: 15px;
            font-weight: bold;
            cursor: pointer;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
        }

        .btn-generate {
            background: #4b2e1e;
            color: white;
        }

        .btn-generate:hover {
            background: #6f4e37;
        }

        /* =========================
           SUMMARY CARDS
           ========================= */

        .summary-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 18px;
            margin-top: 24px;
        }

        .summary-card {
            background: #fffaf5;
            padding: 24px;
            border: 1px solid #e4d7ca;
            border-radius: 14px;
        }

        .summary-card h3 {
            margin: 0;
            color: #7a573e;
            font-size: 15px;
        }

        .summary-number {
            margin-top: 18px;
            font-size: 30px;
            font-weight: bold;
            color: #321b0f;
        }

        /* =========================
           GRAPH
           ========================= */

        .graph-container {
            margin-top: 25px;
            background: #fffaf5;
            padding: 25px;
            border: 1px solid #e4d7ca;
            border-radius: 14px;
        }

        .graph-container h2 {
            margin: 0 0 8px;
            color: #321b0f;
        }

        .graph-container p {
            margin: 0;
            color: #7a573e;
        }

        .graph {
            height: 280px;
            margin-top: 20px;
            display: flex;
            align-items: flex-end;
            justify-content: space-around;
            gap: 10px;
            border-bottom: 2px solid #d8c7b7;
            padding: 20px 10px 0 10px;
        }

        .bar-group {
            flex: 1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-end;
            height: 100%;
        }

        .bar-value {
            font-size: 12px;
            margin-bottom: 5px;
            color: #4b2e1e;
        }

        .bar {
            width: 55%;
            max-width: 45px;
            background: #6f4e37;
            border-radius: 5px 5px 0 0;
            min-height: 2px;
        }

        .month-label {
            margin-top: 8px;
            font-size: 13px;
            font-weight: bold;
            color: #4b2e1e;
        }

        /* =========================
           ORDER SUMMARY TABLE
           ========================= */

        .table-container {
            margin-top: 25px;
            background: #fffaf5;
            padding: 25px;
            border: 1px solid #e4d7ca;
            border-radius: 14px;
        }

        .table-container h2 {
            margin: 0 0 8px;
            color: #321b0f;
        }

        .table-container p {
            color: #7a573e;
            margin-top: 0;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin-top: 18px;
        }

        th,
        td {
            padding: 14px;
            text-align: left;
            border-bottom: 1px solid #e4d7ca;
        }

        th {
            background: #4b2e1e;
            color: white;
        }

        th:first-child {
            border-radius: 8px 0 0 0;
        }

        th:last-child {
            border-radius: 0 8px 0 0;
        }

        tbody tr:hover {
            background: #f8eee5;
        }

        .no-data {
            text-align: center;
            color: #7a573e;
            padding: 25px;
        }

        /* =========================
           STATUS
           ========================= */

        .status {
            display: inline-block;
            padding: 6px 12px;
            border-radius: 18px;
            font-size: 13px;
            font-weight: bold;
        }

        .status-completed {
            background: #dff3e4;
            color: #26743b;
        }

        .status-ready {
            background: #fff0d4;
            color: #a65e00;
        }

        .status-preparing {
            background: #eee2d6;
            color: #6f4e37;
        }

        /* =========================
           RESPONSIVE
           ========================= */

        @media (max-width: 1000px) {

            .summary-grid {
                grid-template-columns: 1fr;
            }

            .report-form {
                flex-wrap: wrap;
            }
        }

        @media (max-width: 700px) {

            .sidebar {
                width: 190px;
            }
        }

    </style>

</head>

<body>

    <!-- =========================
         HEADER
         ========================= -->

    <header>

        <div class="brand">
            Bean Cafe!
        </div>

        <div class="user-area">

            <div class="user-info">

                <strong>
                    <%= session.getAttribute("name") %>
                </strong>

                <span>
                    Admin
                </span>

            </div>

            <a class="logout"
               href="${pageContext.request.contextPath}/LogoutServlet">
                Logout
            </a>

        </div>

    </header>


    <div class="main-layout">

        <!-- =========================
             ADMIN SIDEBAR
             ========================= -->

        <div class="sidebar">

            <div class="sidebar-title">
                Admin Menu
            </div>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/admin-dashboard">
                Dashboard
            </a>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/admin-staff">
                Staff Management
            </a>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/menu">
                Menu Management
            </a>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/admin-order">
                Order Management
            </a>

            <a class="menu-item"
               href="${pageContext.request.contextPath}/order-history">
                Order History
            </a>

            <a class="menu-item active"
               href="${pageContext.request.contextPath}/report">
                Order Summary & Report
            </a>

        </div>


        <!-- =========================
             REPORT CONTENT
             ========================= -->

        <main class="content">

            <!-- =========================
                 PAGE HEADING
                 ========================= -->

            <div class="page-heading">

                <h1>
                    Monthly Sales Report
                </h1>

                <p>
                    View order summaries and sales information by month and year.
                </p>

            </div>


            <!-- =========================
                 GENERATE REPORT
                 ========================= -->

            <form class="report-form"
                  action="${pageContext.request.contextPath}/report"
                  method="post">

                <input type="hidden"
                       name="action"
                       value="generate">


                <!-- MONTH -->

                <select name="month">

                    <option value="0"
                            <%= selectedMonth != null
                                    && selectedMonth == 0
                                    ? "selected"
                                    : "" %>>

                        All Months

                    </option>

                    <%
                        for (int month = 1;
                                month <= 12;
                                month++) {
                    %>

                    <option value="<%= month %>"
                            <%= selectedMonth != null
                                    && selectedMonth == month
                                    ? "selected"
                                    : "" %>>

                        <%= monthNames[month] %>

                    </option>

                    <%
                        }
                    %>

                </select>


                <!-- YEAR -->

                <input type="number"
                       name="year"
                       placeholder="Year"
                       min="2020"
                       value="<%= selectedYear != null
                               ? selectedYear
                               : "" %>"
                       required>


                <button class="btn btn-generate"
                        type="submit">

                    Generate Report

                </button>

            </form>


            <!-- =========================
                 SUMMARY CARDS
                 ========================= -->

            <div class="summary-grid">


                <!-- TOTAL ORDERS -->

                <div class="summary-card">

                    <h3>
                        Total Orders
                    </h3>

                    <div class="summary-number">

                        <%
                            if (generatedReport != null) {
                        %>

                        <%= generatedReport.getTotalOrders() %>

                        <%
                            } else {
                        %>

                        -

                        <%
                            }
                        %>

                    </div>

                </div>


                <!-- TOTAL SALES -->

                <div class="summary-card">

                    <h3>
                        Total Sales
                    </h3>

                    <div class="summary-number">

                        <%
                            if (generatedReport != null) {
                        %>

                        RM <%= String.format(
                                "%.2f",
                                generatedReport.getTotalSales()) %>

                        <%
                            } else {
                        %>

                        RM 0.00

                        <%
                            }
                        %>

                    </div>

                </div>

            </div>


            <!-- =========================
                 MONTHLY SALES GRAPH
                 ========================= -->

            <div class="graph-container">

                <h2>

                    <%
                        if (selectedMonth != null
                                && selectedMonth != 0) {
                    %>

                    Sales Trend -
                    <%= monthNames[selectedMonth] %>
                    <%= selectedYear %>

                    <%
                        } else {
                    %>

                    Monthly Sales Trend -
                    <%= selectedYear %>

                    <%
                        }
                    %>

                </h2>

                <p>
                    Sales are calculated from completed orders.
                </p>


                <!-- =========================
                     GRAPH
                     ALWAYS SHOW JAN - DEC
                     ========================= -->

                <div class="graph">

                    <%
                        /*
                         * Always loop from January until December.
                         *
                         * If All Months is selected:
                         *     show sales for every month.
                         *
                         * If a specific month is selected:
                         *     show sales only for the selected month,
                         *     but still display all Jan-Dec labels.
                         */

                        for (int month = 1;
                                month <= 12;
                                month++) {

                            double sales = 0;


                            // ==================================
                            // ALL MONTHS
                            // ==================================
                            if (selectedMonth == null
                                    || selectedMonth == 0) {

                                if (salesByMonth != null
                                        && salesByMonth.get(month)
                                        != null) {

                                    sales
                                            = salesByMonth.get(month);
                                }


                            // ==================================
                            // SPECIFIC MONTH
                            // ==================================
                            } else if (month == selectedMonth) {

                                if (salesByMonth != null
                                        && salesByMonth.get(month)
                                        != null) {

                                    sales
                                            = salesByMonth.get(month);
                                }
                            }


                            // ==================================
                            // BAR HEIGHT
                            // ==================================

                            int height = 0;

                            if (maxSales > 0) {

                                height
                                        = (int) ((sales / maxSales)
                                        * 180);
                            }

                            if (sales > 0
                                    && height < 5) {

                                height = 5;
                            }
                    %>


                    <div class="bar-group">


                        <!-- SALES VALUE -->

                        <div class="bar-value">

                            <%
                                if (sales > 0) {
                            %>

                            RM <%= String.format(
                                    "%.0f",
                                    sales) %>

                            <%
                                }
                            %>

                        </div>


                        <!-- BAR -->

                        <div class="bar"
                             style="height:<%= height %>px;">
                        </div>


                        <!-- MONTH LABEL -->

                        <div class="month-label">

                            <%= monthNames[month]
                                    .substring(0, 3) %>

                        </div>

                    </div>


                    <%
                        }
                    %>

                </div>

            </div>


            <!-- =========================
                 ORDER SUMMARY
                 ========================= -->

            <%
                if (generatedReport != null) {
            %>

            <div class="table-container">

                <h2>
                    Order Summary
                </h2>


                <%
                    if (selectedMonth != null
                            && selectedMonth == 0) {
                %>

                <p>
                    Showing all orders for

                    <strong>
                        <%= selectedYear %>
                    </strong>
                </p>

                <%
                    } else {
                %>

                <p>
                    Showing orders for

                    <strong>
                        <%= monthNames[selectedMonth] %>
                        <%= selectedYear %>
                    </strong>
                </p>

                <%
                    }
                %>


                <table>

                    <thead>

                        <tr>

                            <th>
                                Order ID
                            </th>

                            <th>
                                Order Date
                            </th>

                            <th>
                                Staff ID
                            </th>

                            <th>
                                Status
                            </th>

                            <th>
                                Total Price (RM)
                            </th>

                        </tr>

                    </thead>


                    <tbody>

                        <%
                            if (orderList != null
                                    && !orderList.isEmpty()) {

                                for (Order order : orderList) {

                                    String statusClass
                                            = "status-preparing";

                                    if ("Completed"
                                            .equalsIgnoreCase(
                                                    order.getStatus())) {

                                        statusClass
                                            = "status-completed";

                                    } else if ("Ready"
                                            .equalsIgnoreCase(
                                                    order.getStatus())) {

                                        statusClass
                                            = "status-ready";
                                    }
                        %>

                        <tr>

                            <td>
                                #<%= order.getOrderId() %>
                            </td>

                            <td>
                                <%= order.getOrderDate() %>
                            </td>

                            <td>
                                <%= order.getStaffId() %>
                            </td>

                            <td>

                                <span class="status <%= statusClass %>">

                                    <%= order.getStatus() %>

                                </span>

                            </td>

                            <td>

                                RM <%= String.format(
                                        "%.2f",
                                        order.getTotalPrice()) %>

                            </td>

                        </tr>

                        <%
                            }

                        } else {
                        %>

                        <tr>

                            <td colspan="5"
                                class="no-data">

                                No orders found for
                                the selected period.

                            </td>

                        </tr>

                        <%
                            }
                        %>

                    </tbody>

                </table>


                <!-- =========================
                     PAGINATION
                     ========================= -->

                <%
                    if (totalPages > 1) {
                %>

                <div style="
                     display: flex;
                     justify-content: center;
                     align-items: center;
                     gap: 15px;
                     margin-top: 22px;">


                    <!-- PREVIOUS -->

                    <%
                        if (currentPage > 1) {
                    %>

                    <form action="${pageContext.request.contextPath}/report"
                          method="post"
                          style="margin: 0;">

                        <input type="hidden"
                               name="action"
                               value="generate">

                        <input type="hidden"
                               name="month"
                               value="<%= selectedMonth %>">

                        <input type="hidden"
                               name="year"
                               value="<%= selectedYear %>">

                        <input type="hidden"
                               name="page"
                               value="<%= currentPage - 1 %>">

                        <button type="submit"
                                class="btn btn-generate">

                            Previous

                        </button>

                    </form>

                    <%
                        }
                    %>


                    <!-- PAGE NUMBER -->

                    <strong style="color:#4b2e1e;">

                        Page <%= currentPage %>
                        of <%= totalPages %>

                    </strong>


                    <!-- NEXT -->

                    <%
                        if (currentPage < totalPages) {
                    %>

                    <form action="${pageContext.request.contextPath}/report"
                          method="post"
                          style="margin: 0;">

                        <input type="hidden"
                               name="action"
                               value="generate">

                        <input type="hidden"
                               name="month"
                               value="<%= selectedMonth %>">

                        <input type="hidden"
                               name="year"
                               value="<%= selectedYear %>">

                        <input type="hidden"
                               name="page"
                               value="<%= currentPage + 1 %>">

                        <button type="submit"
                                class="btn btn-generate">

                            Next

                        </button>

                    </form>

                    <%
                        }
                    %>

                </div>

                <%
                    }
                %>

            </div>

            <%
                }
            %>

        </main>

    </div>

</body>

</html>
