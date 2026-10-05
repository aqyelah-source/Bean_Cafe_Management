<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.beancafe.model.Order" %>
<%@ page import="com.beancafe.model.OrderItem" %>

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
    // GET ORDER
    // ==========================================
    Order order
            = (Order) request.getAttribute(
                    "order");

    if (order == null) {

        response.sendRedirect(
                request.getContextPath()
                + "/order"
        );

        return;
    }

    List<OrderItem> items
            = order.getItems();

    // ==========================================
    // STATUS CLASS
    // ==========================================
    String statusClass
            = "status-pending";

    if ("Preparing".equalsIgnoreCase(
            order.getStatus())) {

        statusClass
                = "status-preparing";

    } else if ("Ready".equalsIgnoreCase(
            order.getStatus())) {

        statusClass
                = "status-ready";

    } else if ("Completed".equalsIgnoreCase(
            order.getStatus())) {

        statusClass
                = "status-completed";

    } else if ("Cancelled".equalsIgnoreCase(
            order.getStatus())) {

        statusClass
                = "status-cancelled";
    }
%>


<!DOCTYPE html>

<html>


    <head>

        <meta charset="UTF-8">

        <title>
            Order Details - Bean Cafe
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

                display:
                    flex;

                justify-content:
                    space-between;

                align-items:
                    center;

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
               BACK BUTTON
               ========================= */

            .btn-back {

                display:
                    inline-flex;

                align-items:
                    center;

                justify-content:
                    center;

                padding:
                    11px 18px;

                background:
                    #eadccc;

                color:
                    #4b2e1e;

                text-decoration:
                    none;

                border-radius:
                    8px;

                font-size:
                    14px;

                font-weight:
                    bold;
            }


            .btn-back:hover {

                background:
                    #d8c4b2;
            }



            /* =========================
               ORDER INFORMATION
               ========================= */

            .order-card {

                background:
                    #fffaf5;

                border:
                    1px solid #e4d7ca;

                border-radius:
                    14px;

                padding:
                    26px;

                margin-bottom:
                    24px;
            }


            .order-card h2 {

                margin:
                    0 0 22px;

                color:
                    #321b0f;

                font-size:
                    22px;
            }


            .info-grid {

                display:
                    grid;

                grid-template-columns:
                    repeat(4, 1fr);

                gap:
                    18px;
            }


            .info-box {

                background:
                    #f8efe5;

                border:
                    1px solid #eadccc;

                border-radius:
                    10px;

                padding:
                    18px;
            }


            .info-label {

                display:
                    block;

                color:
                    #7a573e;

                font-size:
                    12px;

                font-weight:
                    bold;

                text-transform:
                    uppercase;

                margin-bottom:
                    9px;
            }


            .info-value {

                color:
                    #321b0f;

                font-size:
                    17px;

                font-weight:
                    bold;
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
               ORDER ITEMS
               ========================= */

            .items-card {

                background:
                    #fffaf5;

                border:
                    1px solid #e4d7ca;

                border-radius:
                    14px;

                padding:
                    26px;
            }


            .items-card h2 {

                margin:
                    0 0 7px;

                color:
                    #321b0f;

                font-size:
                    22px;
            }


            .items-description {

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
               TOTAL
               ========================= */

            .total-area {

                display:
                    flex;

                justify-content:
                    flex-end;

                margin-top:
                    22px;
            }


            .total-box {

                min-width:
                    270px;

                background:
                    #f8efe5;

                border:
                    1px solid #eadccc;

                border-radius:
                    10px;

                padding:
                    18px 22px;

                display:
                    flex;

                justify-content:
                    space-between;

                align-items:
                    center;
            }


            .total-box span {

                font-size:
                    15px;

                color:
                    #7a573e;

                font-weight:
                    bold;
            }


            .total-box strong {

                font-size:
                    22px;

                color:
                    #321b0f;
            }



            /* =========================
               RESPONSIVE
               ========================= */

            @media (max-width: 1000px) {

                .info-grid {

                    grid-template-columns:
                        repeat(2, 1fr);
                }
            }


            @media (max-width: 700px) {

                .sidebar {

                    width:
                        190px;
                }


                .info-grid {

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


                    <div>


                        <h1>

                            Order Details

                        </h1>


                        <p>

                            View complete customer
                            order information.

                        </p>


                    </div>


                    <a class="btn-back"
                        href="${pageContext.request.contextPath}/admin-order">
                         ← Back to Orders
                     </a>


                </div>




                <!-- =========================
                     ORDER INFORMATION
                     ========================= -->

                <div class="order-card">


                    <h2>

                        Order #<%= order.getOrderId()%>

                    </h2>



                    <div class="info-grid">



                        <!-- ORDER NUMBER -->

                        <div class="info-box">


                            <span class="info-label">

                                Order Number

                            </span>


                            <span class="info-value">

                                #<%= order.getOrderId()%>

                            </span>


                        </div>



                        <!-- DATE -->

                        <div class="info-box">


                            <span class="info-label">

                                Order Date

                            </span>


                            <span class="info-value">

                                <%= order.getOrderDate()%>

                            </span>


                        </div>



                        <!-- STAFF -->

                        <div class="info-box">


                            <span class="info-label">

                                Staff Handling Order

                            </span>


                            <span class="info-value">

                                Staff #<%= order.getStaffId()%>

                            </span>


                        </div>



                        <!-- STATUS -->

                        <div class="info-box">


                            <span class="info-label">

                                Current Status

                            </span>


                            <span class="status <%= statusClass%>">

                                <%= order.getStatus()%>

                            </span>


                        </div>


                    </div>


                </div>




                <!-- =========================
                     ORDERED ITEMS
                     ========================= -->

                <div class="items-card">


                    <h2>

                        Ordered Items

                    </h2>


                    <p class="items-description">

                        Menu items included in
                        this customer order.

                    </p>



                    <table>


                        <thead>


                            <tr>


                                <th>
                                    Menu Item
                                </th>


                                <th>
                                    Quantity
                                </th>


                                <th>
                                    Subtotal (RM)
                                </th>


                            </tr>


                        </thead>



                        <tbody>


                            <%
                                if (items != null
                                        && !items.isEmpty()) {

                                    for (OrderItem item
                                            : items) {

                                        String displayName
                                                = item.getMenuName();

                                        if (displayName == null
                                                || displayName.trim().isEmpty()) {

                                            displayName
                                                    = "Menu #"
                                                    + item.getMenuId();
                                        }
                            %>


                            <tr>


                                <!-- MENU NAME -->

                                <td>

                                    <%= displayName%>

                                </td>



                                <!-- QUANTITY -->

                                <td>

                                    <%= item.getQuantity()%>

                                </td>



                                <!-- SUBTOTAL -->

                                <td>

                                    RM
                                    <%= String.format(
                                            "%.2f",
                                            item.getSubtotal())%>

                                </td>


                            </tr>


                            <%
                                }

                            } else {
                            %>


                            <tr>


                                <td colspan="3"
                                    class="no-data">

                                    No ordered items found.

                                </td>


                            </tr>


                            <%
                                }
                            %>


                        </tbody>


                    </table>



                    <!-- =========================
                         TOTAL PRICE
                         ========================= -->

                    <div class="total-area">


                        <div class="total-box">


                            <span>

                                Total Price

                            </span>


                            <strong>

                                RM
                                <%= String.format(
                                        "%.2f",
                                        order.getTotalPrice())%>

                            </strong>


                        </div>


                    </div>


                </div>


            </main>


        </div>


    </body>

</html>
