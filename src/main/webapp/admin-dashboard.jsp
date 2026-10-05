<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.beancafe.model.Order" %>

<%
    if (session.getAttribute("role") == null
            || !"Admin".equalsIgnoreCase(
                    (String) session.getAttribute("role"))) {

        response.sendRedirect("login.jsp");
        return;
    }

    Integer totalStaff
            = (Integer) request.getAttribute("totalStaff");

    Integer totalMenu
            = (Integer) request.getAttribute("totalMenu");

    Integer totalOrders
            = (Integer) request.getAttribute("totalOrders");

    Double totalSales
            = (Double) request.getAttribute("totalSales");

    List<Order> recentOrders
            = (List<Order>) request.getAttribute(
                    "recentOrders");
%>


<!DOCTYPE html>
<html>

    <head>

        <meta charset="UTF-8">

        <title>
            Admin Dashboard - Bean Cafe
        </title>


        <style>

            * {
                box-sizing: border-box;
            }

            body {
                margin: 0;

                font-family:
                    Arial, sans-serif;

                background: #f6ede3;

                color: #2f1b10;
            }


            /* =========================
               HEADER
               ========================= */

            header {

                height: 82px;

                background:
                    #f9f1e7;

                border-top:
                    6px solid #4b2e1e;

                border-bottom:
                    1px solid #dfd1c3;

                padding:
                    0 28px;

                display: flex;

                justify-content:
                    space-between;

                align-items:
                    center;
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

                background:
                    #4b2e1e;

                color: white;

                text-decoration: none;

                padding:
                    11px 22px;

                border-radius:
                    24px;

                font-weight:
                    bold;
            }


            .logout:hover {

                background:
                    #6f4e37;
            }


            /* =========================
               MAIN LAYOUT
               ========================= */

            .main-layout {

                display: flex;

                min-height:
                    calc(100vh - 82px);
            }


            /* =========================
               SIDEBAR
               ========================= */

            .sidebar {

                width: 235px;

                flex-shrink: 0;

                background:
                    #f8efe5;

                border-right:
                    1px solid #dfd1c3;

                padding:
                    28px 16px;
            }


            .sidebar-title {

                color:
                    #7a573e;

                font-size:
                    15px;

                font-weight:
                    bold;

                margin:
                    0 10px 18px;
            }


            .menu-item {

                display: block;

                padding:
                    13px 16px;

                margin-bottom:
                    8px;

                text-decoration:
                    none;

                color:
                    #4b2e1e;

                font-size:
                    15px;

                font-weight:
                    600;

                border-radius:
                    20px;
            }


            .menu-item:hover {

                background:
                    #eadccc;
            }


            .menu-item.active {

                background:
                    #4b2e1e;

                color: white;
            }


            /* =========================
               CONTENT
               ========================= */

            .content {

                flex: 1;

                padding:
                    32px;

                min-width: 0;
            }


            .dashboard-heading {

                margin-bottom:
                    25px;
            }


            .dashboard-heading h1 {

                margin:
                    0 0 8px;

                font-size:
                    28px;

                color:
                    #2f1b10;
            }


            .dashboard-heading p {

                margin: 0;

                color:
                    #7a573e;

                font-size:
                    16px;
            }


            /* =========================
               SUMMARY CARDS
               ========================= */

            .summary-grid {

                display: grid;

                grid-template-columns:
                    repeat(4, 1fr);

                gap: 18px;

                margin-bottom:
                    30px;
            }


            .summary-card {

                background:
                    #fffaf5;

                border:
                    1px solid #e4d7ca;

                border-radius:
                    14px;

                padding:
                    22px;

                min-height:
                    125px;
            }


            .summary-card span {

                color:
                    #7a573e;

                font-size:
                    15px;

                font-weight:
                    bold;
            }


            .summary-card h2 {

                margin:
                    16px 0 0;

                color:
                    #321b0f;

                font-size:
                    30px;
            }


            /* =========================
               RECENT ORDERS
               ========================= */

            .recent-orders {

                background:
                    #fffaf5;

                border:
                    1px solid #e4d7ca;

                border-radius:
                    14px;

                padding:
                    24px;
            }


            .recent-orders h2 {

                margin-top: 0;

                margin-bottom:
                    8px;

                color:
                    #321b0f;
            }


            .recent-orders p {

                margin-top: 0;

                color:
                    #7a573e;
            }


            table {

                width: 100%;

                border-collapse:
                    collapse;

                margin-top:
                    18px;
            }


            th,
            td {

                padding:
                    14px;

                text-align:
                    left;

                border-bottom:
                    1px solid #e4d7ca;
            }


            th {

                background:
                    #4b2e1e;

                color: white;
            }


            th:first-child {

                border-radius:
                    8px 0 0 0;
            }


            th:last-child {

                border-radius:
                    0 8px 0 0;
            }


            tbody tr:hover {

                background:
                    #f8eee5;
            }


            /* =========================
               ORDER STATUS
               ========================= */

            .status {

                display:
                    inline-block;

                padding:
                    6px 12px;

                border-radius:
                    18px;

                font-size:
                    13px;

                font-weight:
                    bold;
            }


            .status-completed {

                background:
                    #dff3e4;

                color:
                    #26743b;
            }


            .status-ready {

                background:
                    #fff0d4;

                color:
                    #a65e00;
            }


            .status-preparing {

                background:
                    #eee2d6;

                color:
                    #6f4e37;
            }


            /* =========================
               RESPONSIVE
               ========================= */

            @media (max-width: 1000px) {

                .summary-grid {

                    grid-template-columns:
                        repeat(2, 1fr);
                }
            }


            @media (max-width: 700px) {

                .sidebar {

                    width: 190px;
                }


                .summary-grid {

                    grid-template-columns:
                        1fr;
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

                        <%= session.getAttribute("name")%>

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
                 SIDEBAR
                 ========================= -->

            <div class="sidebar">


                <div class="sidebar-title">

                    Admin Menu

                </div>


                <a class="menu-item active"
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


                <a class="menu-item"
                   href="${pageContext.request.contextPath}/report">

                    Order Summary & Report

                </a>


            </div>



            <!-- =========================
                 DASHBOARD CONTENT
                 ========================= -->

            <main class="content">


                <div class="dashboard-heading">

                    <h1>
                        Admin Dashboard
                    </h1>

                    <p>
                        Overview of Bean Cafe operations
                        and records.
                    </p>

                </div>



                <!-- =========================
                     SUMMARY CARDS
                     ========================= -->

                <div class="summary-grid">


                    <div class="summary-card">

                        <span>
                            Total Staff
                        </span>

                        <h2>

                            <%= totalStaff != null
                                    ? totalStaff
                                    : 0%>

                        </h2>

                    </div>



                    <div class="summary-card">

                        <span>
                            Menu Items
                        </span>

                        <h2>

                            <%= totalMenu != null
                                    ? totalMenu
                                    : 0%>

                        </h2>

                    </div>



                    <div class="summary-card">

                        <span>
                            Total Orders
                        </span>

                        <h2>

                            <%= totalOrders != null
                                    ? totalOrders
                                    : 0%>

                        </h2>

                    </div>



                    <div class="summary-card">

                        <span>
                            Total Sales
                        </span>

                        <h2>

                            RM
                            <%= String.format(
                                    "%.2f",
                                    totalSales != null
                                            ? totalSales
                                            : 0.0)%>

                        </h2>

                    </div>


                </div>



                <!-- =========================
                     RECENT ORDERS
                     ========================= -->

                <div class="recent-orders">


                    <h2>
                        Recent Orders
                    </h2>


                    <p>
                        Latest customer orders
                        recorded in the system.
                    </p>


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

                                if (recentOrders != null
                                        && !recentOrders.isEmpty()) {

                                    for (Order order
                                            : recentOrders) {

                            %>


                            <tr>


                                <td>

                                    #<%= order.getOrderId()%>

                                </td>


                                <td>

                                    <%= order.getOrderDate()%>

                                </td>


                                <td>

                                    <%= order.getStaffId()%>

                                </td>


                                <td>


                                    <%

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


                                    <span class="status <%= statusClass%>">

                                        <%= order.getStatus()%>

                                    </span>


                                </td>


                                <td>

                                    RM
                                    <%= String.format(
                                            "%.2f",
                                            order.getTotalPrice())%>

                                </td>


                            </tr>


                            <%

                                }

                            } else {

                            %>


                            <tr>

                                <td colspan="5">

                                    No recent orders found.

                                </td>

                            </tr>


                            <%                    }

                            %>


                        </tbody>


                    </table>


                </div>


            </main>


        </div>


    </body>

</html>
