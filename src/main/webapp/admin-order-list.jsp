<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
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
    // GET ORDER LIST
    // ==========================================
    List<Order> orderList
            = (List<Order>) request.getAttribute(
                    "orderList"
            );

    Integer currentPageObj
            = (Integer) request.getAttribute(
                    "currentPage"
            );

    Integer totalPagesObj
            = (Integer) request.getAttribute(
                    "totalPages"
            );

    int currentPage
            = currentPageObj != null
                    ? currentPageObj
                    : 1;

    int totalPages
            = totalPagesObj != null
                    ? totalPagesObj
                    : 1;

    // ==========================================
    // GET CURRENT FILTER
    // ==========================================
    String selectedStatus
            = (String) request.getAttribute(
                    "selectedStatus"
            );

    if (selectedStatus == null) {

        selectedStatus = "All";
    }

    // ==========================================
    // GET CURRENT SEARCH
    // ==========================================
    String searchOrderId
            = (String) request.getAttribute(
                    "searchOrderId"
            );

    if (searchOrderId == null) {

        searchOrderId = "";
    }
%>


<!DOCTYPE html>

<html>

    <head>

        <meta charset="UTF-8">

        <title>
            Order Management - Bean Cafe
        </title>


        <style>

            * {
                box-sizing: border-box;
            }


            body {

                margin: 0;

                font-family:
                    Arial, sans-serif;

                background:
                    #f6ede3;

                color:
                    #2f1b10;
            }


            /* =========================
               HEADER
               ========================= */

            header {

                height:
                    82px;

                background:
                    #f9f1e7;

                border-top:
                    6px solid #4b2e1e;

                border-bottom:
                    1px solid #dfd1c3;

                padding:
                    0 28px;

                display:
                    flex;

                justify-content:
                    space-between;

                align-items:
                    center;
            }


            .brand {

                font-size:
                    25px;

                font-weight:
                    bold;

                color:
                    #321b0f;
            }


            .user-area {

                display:
                    flex;

                align-items:
                    center;

                gap:
                    24px;
            }


            .user-info {

                text-align:
                    right;
            }


            .user-info strong {

                display:
                    block;

                font-size:
                    15px;
            }


            .user-info span {

                display:
                    block;

                font-size:
                    13px;

                color:
                    #7a573e;

                margin-top:
                    2px;
            }


            .logout {

                background:
                    #4b2e1e;

                color:
                    white;

                text-decoration:
                    none;

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

                display:
                    flex;

                min-height:
                    calc(100vh - 82px);
            }


            /* =========================
               SIDEBAR
               ========================= */

            .sidebar {

                width:
                    235px;

                flex-shrink:
                    0;

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

                display:
                    block;

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

                color:
                    white;
            }


            /* =========================
               CONTENT
               ========================= */

            .content {

                flex:
                    1;

                padding:
                    32px;

                min-width:
                    0;
            }


            .page-heading {

                margin-bottom:
                    25px;
            }


            .page-heading h1 {

                margin:
                    0 0 8px;

                font-size:
                    28px;

                color:
                    #2f1b10;
            }


            .page-heading p {

                margin:
                    0;

                color:
                    #7a573e;

                font-size:
                    16px;

                line-height:
                    1.5;
            }


            /* =========================
               FILTER AND SEARCH
               ========================= */

            .filter-card {

                background:
                    #fffaf5;

                border:
                    1px solid #e4d7ca;

                border-radius:
                    14px;

                padding:
                    20px;

                margin-bottom:
                    22px;
            }


            .status-filter {

                display:
                    flex;

                flex-wrap:
                    wrap;

                gap:
                    10px;

                margin-bottom:
                    18px;
            }


            .filter-btn {

                display:
                    inline-flex;

                align-items:
                    center;

                justify-content:
                    center;

                min-width:
                    74px;

                padding:
                    10px 18px;

                border:
                    1px solid #d8c7b7;

                border-radius:
                    24px;

                background:
                    white;

                color:
                    #4b2e1e;

                text-decoration:
                    none;

                font-size:
                    14px;
            }


            .filter-btn:hover {

                background:
                    #f1e3d6;
            }


            .filter-btn.active {

                background:
                    #4b2e1e;

                color:
                    white;

                border-color:
                    #4b2e1e;
            }


            .search-form {

                display:
                    flex;

                gap:
                    10px;
            }


            .search-input {

                flex:
                    1;

                min-width:
                    0;

                height:
                    46px;

                padding:
                    0 16px;

                border:
                    1px solid #d8c7b7;

                border-radius:
                    8px;

                background:
                    white;

                color:
                    #2f1b10;

                font-size:
                    15px;

                outline:
                    none;
            }


            .search-input:focus {

                border-color:
                    #7a573e;
            }


            .btn-search,
            .btn-show-all {

                height:
                    46px;

                padding:
                    0 22px;

                border:
                    none;

                border-radius:
                    8px;

                font-size:
                    14px;

                font-weight:
                    bold;

                cursor:
                    pointer;

                display:
                    inline-flex;

                align-items:
                    center;

                justify-content:
                    center;

                text-decoration:
                    none;
            }


            .btn-search {

                background:
                    #6f4e37;

                color:
                    white;
            }


            .btn-search:hover {

                background:
                    #4b2e1e;
            }


            .btn-show-all {

                background:
                    #eadccc;

                color:
                    #321b0f;
            }


            .btn-show-all:hover {

                background:
                    #d8c4b2;
            }


            /* =========================
               TABLE CARD
               ========================= */

            .table-card {

                background:
                    #fffaf5;

                border:
                    1px solid #e4d7ca;

                border-radius:
                    14px;

                padding:
                    24px;
            }


            .table-card h2 {

                margin:
                    0 0 7px;

                font-size:
                    21px;

                color:
                    #321b0f;
            }


            .table-description {

                margin:
                    0 0 20px;

                color:
                    #7a573e;

                font-size:
                    14px;
            }


            /* =========================
               TABLE
               ========================= */

            table {

                width:
                    100%;

                border-collapse:
                    collapse;
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

                color:
                    white;

                font-size:
                    14px;
            }


            th:first-child {

                border-radius:
                    8px 0 0 0;
            }


            th:last-child {

                border-radius:
                    0 8px 0 0;
            }


            td {

                font-size:
                    14px;
            }


            tbody tr:hover {

                background:
                    #f8eee5;
            }


            .no-data {

                text-align:
                    center;

                color:
                    #7a573e;

                padding:
                    28px;
            }


            /* =========================
               STATUS
               ========================= */

            .status {

                display:
                    inline-block;

                padding:
                    6px 12px;

                border-radius:
                    18px;

                font-size:
                    12px;

                font-weight:
                    bold;
            }


            .status-pending {

                background:
                    #f1e3d6;

                color:
                    #7a573e;
            }


            .status-preparing {

                background:
                    #fff0d4;

                color:
                    #a65e00;
            }


            .status-ready {

                background:
                    #dcecf6;

                color:
                    #2f6688;
            }


            .status-completed {

                background:
                    #dff3e4;

                color:
                    #26743b;
            }


            .status-cancelled {

                background:
                    #f4d9d5;

                color:
                    #96352e;
            }


            /* =========================
               VIEW DETAILS BUTTON
               ========================= */

            .btn-view {

                display:
                    inline-flex;

                align-items:
                    center;

                justify-content:
                    center;

                background:
                    #eadccc;

                color:
                    #4b2e1e;

                text-decoration:
                    none;

                padding:
                    8px 14px;

                border-radius:
                    8px;

                font-size:
                    13px;

                font-weight:
                    bold;
            }


            .btn-view:hover {

                background:
                    #d8c4b2;
            }


            /* =========================
               PAGINATION
               ========================= */

            .pagination {

                display:
                    flex;

                justify-content:
                    center;

                align-items:
                    center;

                gap:
                    14px;

                margin-top:
                    22px;
            }


            .page-btn {

                padding:
                    9px 16px;

                background:
                    #4b2e1e;

                color:
                    white;

                text-decoration:
                    none;

                border-radius:
                    8px;

                font-size:
                    14px;

                font-weight:
                    bold;
            }


            .page-btn:hover {

                background:
                    #6f4e37;
            }


            .page-btn.disabled {

                background:
                    #ddd0c3;

                color:
                    #927b68;

                cursor:
                    default;
            }


            .page-info {

                font-size:
                    14px;

                font-weight:
                    bold;

                color:
                    #4b2e1e;
            }


            /* =========================
               RESPONSIVE
               ========================= */

            @media (max-width: 850px) {

                .sidebar {

                    width:
                        190px;
                }


                .search-form {

                    flex-wrap:
                        wrap;
                }


                .search-input {

                    flex-basis:
                        100%;
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


                <a class="menu-item active"
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
                 MAIN CONTENT
                 ========================= -->

            <main class="content">


                <!-- =========================
                     PAGE HEADING
                     ========================= -->

                <div class="page-heading">


                    <h1>

                        Order Management

                    </h1>


                    <p>

                        View customer order details,
                        including the order number,
                        total price, staff handling the order
                        and current order status.

                    </p>


                </div>


                <!-- =========================
                     FILTER AND SEARCH
                     ========================= -->

                <div class="filter-card">


                    <!-- STATUS FILTER -->

                    <div class="status-filter">


                        <!-- ALL -->

                        <a class="filter-btn
                           <%= "All".equalsIgnoreCase(
                                   selectedStatus)
                                           ? "active"
                                           : ""%>"
                           href="${pageContext.request.contextPath}/admin-order?status=All">

                            All

                        </a>


                        <!-- PENDING -->

                        <a class="filter-btn
                           <%= "Pending".equalsIgnoreCase(
                                   selectedStatus)
                                           ? "active"
                                           : ""%>"
                           href="${pageContext.request.contextPath}/admin-order?status=Pending">

                            Pending

                        </a>


                        <!-- PREPARING -->

                        <a class="filter-btn
                           <%= "Preparing".equalsIgnoreCase(
                                   selectedStatus)
                                           ? "active"
                                           : ""%>"
                           href="${pageContext.request.contextPath}/admin-order?status=Preparing">

                            Preparing

                        </a>


                        <!-- READY -->

                        <a class="filter-btn
                           <%= "Ready".equalsIgnoreCase(
                                   selectedStatus)
                                           ? "active"
                                           : ""%>"
                           href="${pageContext.request.contextPath}/admin-order?status=Ready">

                            Ready

                        </a>


                        <!-- COMPLETED -->

                        <a class="filter-btn
                           <%= "Completed".equalsIgnoreCase(
                                   selectedStatus)
                                           ? "active"
                                           : ""%>"
                           href="${pageContext.request.contextPath}/admin-order?status=Completed">

                            Completed

                        </a>


                        <!-- CANCELLED -->

                        <a class="filter-btn
                           <%= "Cancelled".equalsIgnoreCase(
                                   selectedStatus)
                                           ? "active"
                                           : ""%>"
                           href="${pageContext.request.contextPath}/admin-order?status=Cancelled">

                            Cancelled

                        </a>


                    </div>


                    <!-- =========================
                         SEARCH FORM
                         ========================= -->

                    <form class="search-form"
                          action="${pageContext.request.contextPath}/admin-order"
                          method="get">


                        <!-- KEEP SELECTED STATUS -->

                        <input type="hidden"
                               name="status"
                               value="<%= selectedStatus%>">


                        <!-- ORDER ID -->

                        <input class="search-input"
                               type="text"
                               name="search"
                               value="<%= searchOrderId%>"
                               placeholder="Search by Order No...">


                        <!-- SEARCH -->

                        <button class="btn-search"
                                type="submit">

                            Search

                        </button>


                        <!-- SHOW ALL -->

                        <a class="btn-show-all"
                           href="${pageContext.request.contextPath}/admin-order">

                            Show All

                        </a>


                    </form>


                </div>


                <!-- =========================
                     ORDER TABLE
                     ========================= -->

                <div class="table-card">


                    <h2>

                        Customer Orders

                    </h2>


                    <p class="table-description">

                        Select View Details to see
                        the complete information for an order.

                    </p>


                    <table>


                        <thead>


                            <tr>


                                <th>

                                    Order No.

                                </th>


                                <th>

                                    Order Date

                                </th>


                                <th>

                                    Staff

                                </th>


                                <th>

                                    Total Price

                                </th>


                                <th>

                                    Status

                                </th>


                                <th>

                                    Action

                                </th>


                            </tr>


                        </thead>


                        <tbody>


                            <%
                                if (orderList != null
                                        && !orderList.isEmpty()) {

                                    for (Order order
                                            : orderList) {

                                        String statusClass
                                                = "status-pending";

                                        if ("Preparing"
                                                .equalsIgnoreCase(
                                                        order.getStatus())) {

                                            statusClass
                                                    = "status-preparing";

                                        } else if ("Ready"
                                                .equalsIgnoreCase(
                                                        order.getStatus())) {

                                            statusClass
                                                    = "status-ready";

                                        } else if ("Completed"
                                                .equalsIgnoreCase(
                                                        order.getStatus())) {

                                            statusClass
                                                    = "status-completed";

                                        } else if ("Cancelled"
                                                .equalsIgnoreCase(
                                                        order.getStatus())) {

                                            statusClass
                                                    = "status-cancelled";
                                        }
                            %>


                            <tr>


                                <!-- ORDER NUMBER -->

                                <td>

                                    #<%= order.getOrderId()%>

                                </td>


                                <!-- ORDER DATE -->

                                <td>

                                    <%= order.getOrderDate()%>

                                </td>


                                <!-- STAFF -->

                                <td>

                                    Staff #<%= order.getStaffId()%>

                                </td>


                                <!-- TOTAL PRICE -->

                                <td>

                                    RM
                                    <%= String.format(
                                            "%.2f",
                                            order.getTotalPrice())%>

                                </td>


                                <!-- STATUS -->

                                <td>


                                    <span class="status <%= statusClass%>">

                                        <%= order.getStatus()%>

                                    </span>


                                </td>


                                <!-- ACTION -->

                                <td>


                                    <a class="btn-view"
                                       href="${pageContext.request.contextPath}/admin-order?action=view&id=<%= order.getOrderId()%>">

                                        View Details

                                    </a>


                                </td>


                            </tr>


                            <%
                                }

                            } else {
                            %>


                            <tr>


                                <td colspan="6"
                                    class="no-data">

                                    No orders found.

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

                    <div class="pagination">


                        <!-- PREVIOUS -->

                        <%
                            if (currentPage > 1) {
                        %>


                        <a class="page-btn"
                           href="${pageContext.request.contextPath}/admin-order?page=<%= currentPage - 1%>&amp;status=<%= selectedStatus%>&amp;search=<%= searchOrderId%>">

                            &laquo; Previous

                        </a>


                        <%
                        } else {
                        %>


                        <span class="page-btn disabled">

                            &laquo; Previous

                        </span>


                        <%
                            }
                        %>


                        <!-- PAGE INFORMATION -->

                        <span class="page-info">

                            Page <%= currentPage%>
                            of <%= totalPages%>

                        </span>


                        <!-- NEXT -->

                        <%
                            if (currentPage < totalPages) {
                        %>


                        <a class="page-btn"
                           href="${pageContext.request.contextPath}/admin-order?page=<%= currentPage + 1%>&amp;status=<%= selectedStatus%>&amp;search=<%= searchOrderId%>">

                            Next &raquo;

                        </a>


                        <%
                        } else {
                        %>


                        <span class="page-btn disabled">

                            Next &raquo;

                        </span>


                        <%
                            }
                        %>


                    </div>


                </div>


            </main>


        </div>


    </body>

</html>