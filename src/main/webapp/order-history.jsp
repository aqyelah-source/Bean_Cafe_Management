<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.beancafe.model.OrderHistory" %>

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
    // GET DATA FROM SERVLET
    // ==========================================
    List<OrderHistory> historyList
            = (List<OrderHistory>) request.getAttribute(
                    "historyList");

    Integer searchedOrderId
            = (Integer) request.getAttribute(
                    "searchedOrderId");

    Integer currentPageObj
            = (Integer) request.getAttribute(
                    "currentPage");

    Integer totalPagesObj
            = (Integer) request.getAttribute(
                    "totalPages");

    int currentPage
            = currentPageObj != null
            ? currentPageObj
            : 1;

    int totalPages
            = totalPagesObj != null
            ? totalPagesObj
            : 0;
%>


<!DOCTYPE html>

<html>

    <head>

        <meta charset="UTF-8">

        <title>
            Order History - Bean Cafe
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
            }


            /* =========================
               SEARCH
               ========================= */

            .search-card {
                background:
                    #fffaf5;

                border:
                    1px solid #e4d7ca;

                border-radius:
                    14px;

                padding:
                    20px;

                margin-bottom:
                    24px;
            }


            .search-form {
                display:
                    flex;

                gap:
                    10px;
            }


            .search-form input {
                flex:
                    1;

                height:
                    44px;

                padding:
                    0 14px;

                border:
                    1px solid #d8c7b7;

                border-radius:
                    8px;

                font-family:
                    Arial, sans-serif;

                font-size:
                    14px;

                outline:
                    none;
            }


            .search-form input:focus {
                border-color:
                    #7a573e;
            }


            .btn-search {
                height:
                    44px;

                padding:
                    0 22px;

                border:
                    none;

                border-radius:
                    8px;

                background:
                    #6f4e37;

                color:
                    white;

                font-size:
                    14px;

                font-weight:
                    bold;

                cursor:
                    pointer;
            }


            .btn-search:hover {
                background:
                    #4b2e1e;
            }


            .btn-show {
                height:
                    44px;

                padding:
                    0 20px;

                background:
                    #eadccc;

                color:
                    #4b2e1e;

                text-decoration:
                    none;

                border-radius:
                    8px;

                display:
                    inline-flex;

                align-items:
                    center;

                justify-content:
                    center;

                font-size:
                    14px;

                font-weight:
                    bold;
            }


            /* =========================
               HISTORY CARD
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

                color:
                    #321b0f;

                font-size:
                    21px;
            }


            .table-card p {
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
                    13px;

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


            .pagination a {
                text-decoration:
                    none;

                background:
                    #4b2e1e;

                color:
                    white;

                padding:
                    9px 18px;

                border-radius:
                    20px;

                font-size:
                    14px;

                font-weight:
                    bold;
            }


            .pagination a:hover {
                background:
                    #6f4e37;
            }


            .pagination .disabled {
                background:
                    #d8c7b7;

                color:
                    #8b7565;

                padding:
                    9px 18px;

                border-radius:
                    20px;

                font-size:
                    14px;

                font-weight:
                    bold;

                cursor:
                    not-allowed;
            }


            .page-info {
                color:
                    #4b2e1e;

                font-size:
                    14px;

                font-weight:
                    bold;
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


                <a class="menu-item"
                   href="${pageContext.request.contextPath}/admin-order">
                    Order Management
                </a>


                <a class="menu-item active"
                   href="${pageContext.request.contextPath}/order-history">
                    Order History
                </a>


                <a class="menu-item"
                   href="${pageContext.request.contextPath}/report">
                    Order Summary & Report
                </a>

            </div>



            <!-- =========================
                 CONTENT
                 ========================= -->

            <main class="content">


                <div class="page-heading">

                    <h1>
                        Order History
                    </h1>

                    <p>
                        View the history of customer
                        order status updates.
                    </p>

                </div>



                <!-- =========================
                     SEARCH
                     ========================= -->

                <div class="search-card">


                    <form class="search-form"
                          action="${pageContext.request.contextPath}/order-history"
                          method="get">


                        <input type="hidden"
                               name="action"
                               value="search">


                        <input type="number"
                               name="orderId"
                               placeholder="Search by Order ID..."
                               min="1"
                               value="<%= searchedOrderId != null
                                       ? searchedOrderId
                                       : ""%>">


                        <button class="btn-search"
                                type="submit">

                            Search

                        </button>


                        <a class="btn-show"
                           href="${pageContext.request.contextPath}/order-history">

                            Show All

                        </a>


                    </form>


                </div>



                <!-- =========================
                     HISTORY TABLE
                     ========================= -->

                <div class="table-card">


                    <h2>
                        Order History Records
                    </h2>


                    <p>
                        View previous status records
                        for customer orders.
                    </p>


                    <table>


                        <thead>

                            <tr>

                                <th>
                                    History ID
                                </th>

                                <th>
                                    Order ID
                                </th>

                                <th>
                                    Status
                                </th>

                                <th>
                                    Updated At
                                </th>

                            </tr>

                        </thead>



                        <tbody>


                            <%
                                if (historyList != null
                                        && !historyList.isEmpty()) {

                                    for (OrderHistory history
                                            : historyList) {

                                        String statusClass
                                                = "status-pending";

                                        if ("Preparing".equalsIgnoreCase(
                                                history.getStatus())) {

                                            statusClass
                                                    = "status-preparing";

                                        } else if ("Ready".equalsIgnoreCase(
                                                history.getStatus())) {

                                            statusClass
                                                    = "status-ready";

                                        } else if ("Completed".equalsIgnoreCase(
                                                history.getStatus())) {

                                            statusClass
                                                    = "status-completed";

                                        } else if ("Cancelled".equalsIgnoreCase(
                                                history.getStatus())) {

                                            statusClass
                                                    = "status-cancelled";
                                        }
                            %>


                            <tr>


                                <td>
                                    <%= history.getHistoryId()%>
                                </td>


                                <td>
                                    #<%= history.getOrderId()%>
                                </td>


                                <td>

                                    <span class="status <%= statusClass%>">

                                        <%= history.getStatus()%>

                                    </span>

                                </td>


                                <td>
                                    <%= history.getUpdatedAt()%>
                                </td>


                            </tr>


                            <%
                                }

                            } else {
                            %>


                            <tr>

                                <td colspan="4"
                                    class="no-data">

                                    No order history found.

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

                    <% if (totalPages > 0) { %>


                    <div class="pagination">


                        <!-- PREVIOUS BUTTON -->

                        <% if (currentPage > 1) { %>


                        <a href="${pageContext.request.contextPath}/order-history?page=<%= currentPage - 1%><%= searchedOrderId != null
                                ? "&action=search&orderId=" + searchedOrderId
                                : ""%>">

                            Previous

                        </a>


                        <% } else { %>


                        <span class="disabled">

                            Previous

                        </span>


                        <% } %>



                        <!-- CURRENT PAGE -->

                        <span class="page-info">

                            Page <%= currentPage%>
                            of <%= totalPages%>

                        </span>



                        <!-- NEXT BUTTON -->

                        <% if (currentPage < totalPages) { %>


                        <a href="${pageContext.request.contextPath}/order-history?page=<%= currentPage + 1%><%= searchedOrderId != null
                                ? "&action=search&orderId=" + searchedOrderId
                                : ""%>">

                            Next

                        </a>


                        <% } else { %>


                        <span class="disabled">

                            Next

                        </span>


                        <% } %>


                    </div>


                    <% } %>


                </div>


            </main>


        </div>


    </body>

</html>