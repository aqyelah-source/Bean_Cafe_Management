<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.beancafe.model.Order" %>
<%@ page import="com.beancafe.model.OrderItem" %>

<%
    // ==============================
    // SESSION CHECK
    // ==============================
    if (session == null || session.getAttribute("userId") == null) {
        response.sendRedirect(request.getContextPath() + "/login.jsp");
        return;
    }

    String name = (String) session.getAttribute("name");
    String role = (String) session.getAttribute("role");

    List<Order> orderList =
            (List<Order>) request.getAttribute("orderList");

    Order selectedOrder =
            (Order) request.getAttribute("selectedOrder");

    Order searchedOrder =
            (Order) request.getAttribute("searchedOrder");

    Boolean searchPerformed =
            (Boolean) request.getAttribute("searchPerformed");

    if (searchPerformed == null) {
        searchPerformed = false;
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bean Cafe - Order Management</title>

    <style>
        * {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: Arial, sans-serif;
            background: #f7f1e8;
            color: #3b2314;
        }

        /* ================= HEADER ================= */

       .header {
            height: 90px;
            background: #fffaf4;
            border-bottom: 1px solid #e3d5c8;
            display: flex;
            align-items: center;
            padding: 0 28px;
            gap: 26px;
        }

        .brand {
            font-size: 24px;
            font-weight: bold;
            color: #2f180c;
        }

        .staff-badge {
            background: #3b2314;
            color: white;
            padding: 6px 13px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: bold;
        }

        .nav {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .nav a {
            color: #6f4e37;
            text-decoration: none;
            font-size: 15px;
            font-weight: 600;
            padding: 12px 17px;
            border-radius: 24px;
            transition: 0.2s;
        }

        .nav a:hover {
            background: #eee3d8;
            color: #3b2314;
        }

        /* Manage Orders is active on this page */
        .nav a.active {
            background: #3b2314;
            color: white;
        }

        .user-area {
            margin-left: auto;
            display: flex;
            align-items: center;
            gap: 25px;
        }

        .user-info {
            display: flex;
            flex-direction: column;
            text-align: center;
            color: #2f180c;
            font-size: 14px;
        }

        .user-info span {
            color: #8b6f5c;
            font-size: 12px;
            margin-top: 2px;
        }

        .logout {
            background: #3b2314;
            color: white;
            text-decoration: none;
            padding: 10px 18px;
            border-radius: 22px;
            font-size: 13px;
            font-weight: bold;
            transition: 0.2s;
        }

        .logout:hover {
            background: #6f4e37;
            color: white;
        }
        /* ================= MAIN ================= */

        .container {
            max-width: 1200px;
            margin: 35px auto;
            padding: 0 25px;
        }

        .page-top {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 25px;
        }

        .page-title h1 {
            font-size: 28px;
            margin-bottom: 6px;
        }

        .page-title p {
            color: #816d60;
            font-size: 14px;
        }

        .new-order-btn {
            display: inline-block;
            text-decoration: none;
            background: #3b2314;
            color: white;
            padding: 11px 20px;
            border-radius: 22px;
            font-size: 14px;
            font-weight: bold;
        }

        .new-order-btn:hover {
            background: #6f4e37;
        }

        /* ================= STATS ================= */

        .stats {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 15px;
            margin-bottom: 25px;
        }

        .stat-card {
            background: white;
            border-radius: 14px;
            padding: 18px;
            border: 1px solid #eadfd3;
        }

        .stat-label {
            color: #8b7769;
            font-size: 12px;
            margin-bottom: 7px;
        }

        .stat-value {
            font-size: 24px;
            font-weight: bold;
        }

        /* ================= FILTER ================= */

        .toolbar {
            background: white;
            border: 1px solid #eadfd3;
            border-radius: 14px;
            padding: 18px;
            margin-bottom: 18px;
        }

        .tabs {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
            margin-bottom: 15px;
        }

        .tab {
            border: 1px solid #dac9bb;
            background: #fff;
            color: #5c4637;
            border-radius: 20px;
            padding: 8px 15px;
            cursor: pointer;
            font-size: 13px;
        }

        .tab:hover,
        .tab.active {
            background: #3b2314;
            color: white;
            border-color: #3b2314;
        }

        .search-row {
            display: flex;
            gap: 10px;
        }

        .search-row input {
            flex: 1;
            padding: 11px 14px;
            border: 1px solid #d9c9bc;
            border-radius: 8px;
            outline: none;
        }

        .search-row input:focus {
            border-color: #6f4e37;
        }

        .search-btn,
        .show-all-btn {
            border: none;
            border-radius: 8px;
            padding: 10px 18px;
            cursor: pointer;
            font-weight: bold;
        }

        .search-btn {
            background: #6f4e37;
            color: white;
        }

        .show-all-btn {
            background: #eee4da;
            color: #3b2314;
            text-decoration: none;
            display: flex;
            align-items: center;
        }

        /* ================= ORDER LIST ================= */

        .orders-card {
            background: white;
            border: 1px solid #eadfd3;
            border-radius: 14px;
            overflow: hidden;
        }

        .orders-heading {
            padding: 18px 20px;
            font-size: 16px;
            font-weight: bold;
            border-bottom: 1px solid #eee4da;
        }

        .order-row {
            display: grid;
            grid-template-columns: 0.8fr 1fr 1.8fr 1fr 1fr;
            align-items: center;
            gap: 10px;
            padding: 17px 20px;
            border-bottom: 1px solid #f0e7df;
            cursor: pointer;
            transition: 0.2s;
        }

        .order-row:last-child {
            border-bottom: none;
        }

        .order-row:hover {
            background: #faf6f1;
        }

        .order-id {
            font-weight: bold;
        }

        .small-text {
            font-size: 13px;
            color: #806d60;
        }

        .price {
            font-weight: bold;
        }

        /* ================= STATUS ================= */

        .status {
            display: inline-block;
            width: fit-content;
            padding: 6px 11px;
            border-radius: 15px;
            font-size: 11px;
            font-weight: bold;
        }

        .pending {
            background: #fff3cd;
            color: #856404;
        }

        .preparing {
            background: #dbeafe;
            color: #1e4f91;
        }

        .ready {
            background: #d1fae5;
            color: #17603a;
        }

        .completed {
            background: #e7e5e4;
            color: #57534e;
        }

        .cancelled {
            background: #fde2e2;
            color: #9b2c2c;
        }
        
        /* ================= PAGINATION ================= */

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 14px;
            padding: 20px;
            border-top: 1px solid #eee4da;
        }

        .page-btn {
            border: none;
            background: #3b2314;
            color: white;
            padding: 9px 16px;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            font-size: 12px;
        }

        .page-btn:hover {
            background: #6f4e37;
        }

        .page-btn:disabled {
            background: #d8cec5;
            color: #8b7769;
            cursor: not-allowed;
        }

        .page-info {
            font-size: 13px;
            font-weight: bold;
            color: #5c4637;
        }

        /* ================= EMPTY ================= */

        .empty {
            text-align: center;
            padding: 45px 20px;
            color: #8b7769;
        }

        /* ================= DRAWER ================= */

        .overlay {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.35);
            z-index: 90;
        }

        .drawer {
            position: fixed;
            top: 0;
            right: 0;
            width: 430px;
            max-width: 92%;
            height: 100vh;
            background: #fffaf4;
            z-index: 100;
            box-shadow: -5px 0 20px rgba(0,0,0,0.18);
            overflow-y: auto;
        }

        .drawer-header {
            background: #3b2314;
            color: white;
            padding: 22px 25px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .drawer-header h2 {
            font-size: 21px;
        }

        .close-btn {
            color: white;
            text-decoration: none;
            font-size: 26px;
            line-height: 1;
        }

        .drawer-content {
            padding: 25px;
        }

        .detail-section {
            background: white;
            border: 1px solid #eadfd3;
            border-radius: 12px;
            padding: 18px;
            margin-bottom: 17px;
        }

        .detail-title {
            font-size: 13px;
            color: #8b7769;
            margin-bottom: 12px;
            font-weight: bold;
            text-transform: uppercase;
        }

        .info-row {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            margin-bottom: 10px;
            font-size: 14px;
        }

        .info-row:last-child {
            margin-bottom: 0;
        }

        .info-label {
            color: #806d60;
        }

        /* ================= ITEMS ================= */

        .item-row {
            display: flex;
            justify-content: space-between;
            gap: 15px;
            padding: 11px 0;
            border-bottom: 1px solid #eee4da;
        }

        .item-row:last-child {
            border-bottom: none;
        }

        .item-name {
            font-weight: bold;
            font-size: 14px;
        }

        .item-qty {
            color: #806d60;
            font-size: 12px;
            margin-top: 4px;
        }

        .item-price {
            font-weight: bold;
            font-size: 14px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            padding-top: 15px;
            margin-top: 5px;
            border-top: 2px solid #3b2314;
            font-size: 18px;
            font-weight: bold;
        }

        /* ================= STATUS PROGRESS ================= */

        .progress {
            display: flex;
            justify-content: space-between;
            margin-top: 15px;
            position: relative;
        }

        .progress-step {
            flex: 1;
            text-align: center;
            font-size: 10px;
            color: #a18e80;
        }

        .progress-dot {
            width: 16px;
            height: 16px;
            border-radius: 50%;
            background: #ddd1c7;
            margin: 0 auto 7px;
        }

        .progress-step.done .progress-dot {
            background: #3b2314;
        }

        .progress-step.done {
            color: #3b2314;
            font-weight: bold;
        }

        /* ================= ACTIONS ================= */

        .status-form select {
            width: 100%;
            padding: 11px;
            border: 1px solid #d9c9bc;
            border-radius: 8px;
            margin-bottom: 10px;
        }

        .update-btn {
            width: 100%;
            padding: 11px;
            background: #3b2314;
            color: white;
            border: none;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
        }

        .update-btn:hover {
            background: #6f4e37;
        }

        .cancel-btn {
            width: 100%;
            padding: 11px;
            background: white;
            color: #a33a3a;
            border: 1px solid #d9a4a4;
            border-radius: 8px;
            cursor: pointer;
            font-weight: bold;
            margin-top: 9px;
        }

        .cancel-btn:hover {
            background: #fff0f0;
        }

        .final-message {
            text-align: center;
            color: #806d60;
            font-size: 13px;
            line-height: 1.5;
        }

        .success-message {
            background: #e8f5e9;
            color: #2e6535;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 18px;
            font-size: 13px;
        }

        /* ================= RESPONSIVE ================= */

        @media (max-width: 800px) {

            .header {
                padding: 0 20px;
            }

            .header-title,
            .nav {
                display: none;
            }

            .stats {
                grid-template-columns: repeat(2, 1fr);
            }

            .order-row {
                grid-template-columns: 1fr 1fr;
            }

            .order-date {
                display: none;
            }
        }
    </style>
</head>

<body>

<!-- ================= HEADER ================= -->

<div class="header">

    <div class="brand">Bean Cafe!</div>

    <div class="staff-badge">
        Staff POS
    </div>

    <div class="nav">

        <a href="<%= request.getContextPath() %>/order?action=add">
            Take Order
        </a>

        <a href="<%= request.getContextPath() %>/order"
           class="active">
            Manage Orders
        </a>

    </div>

    <div class="user-area">

        <div class="user-info">
            <strong><%= name %></strong>
            <span>Staff</span>
        </div>

        <a class="logout"
           href="<%= request.getContextPath() %>/LogoutServlet">
            Logout
        </a>

    </div>

</div>


<!-- ================= MAIN ================= -->

<div class="container">

    <div class="page-top">

        <div class="page-title">
            <h1>Orders</h1>
            <p>Manage and track cafe orders.</p>
        </div>

        <% if ("Staff".equalsIgnoreCase(role)) { %>
            <a class="new-order-btn"
               href="<%= request.getContextPath() %>/order?action=add">
                + New Order
            </a>
        <% } %>

    </div>


    <%
        int totalOrders = 0;
        int pendingCount = 0;
        int preparingCount = 0;
        int readyCount = 0;

        if (orderList != null) {

            totalOrders = orderList.size();

            for (Order o : orderList) {

                if ("Pending".equalsIgnoreCase(o.getStatus())) {
                    pendingCount++;
                }

                if ("Preparing".equalsIgnoreCase(o.getStatus())) {
                    preparingCount++;
                }

                if ("Ready".equalsIgnoreCase(o.getStatus())) {
                    readyCount++;
                }
            }
        }
    %>


    <!-- ================= STATS ================= -->

    <div class="stats">

        <div class="stat-card">
            <div class="stat-label">TOTAL ORDERS</div>
            <div class="stat-value"><%= totalOrders %></div>
        </div>

        <div class="stat-card">
            <div class="stat-label">PENDING</div>
            <div class="stat-value"><%= pendingCount %></div>
        </div>

        <div class="stat-card">
            <div class="stat-label">PREPARING</div>
            <div class="stat-value"><%= preparingCount %></div>
        </div>

        <div class="stat-card">
            <div class="stat-label">READY</div>
            <div class="stat-value"><%= readyCount %></div>
        </div>

    </div>


    <% if ("created".equals(request.getParameter("success"))) { %>

        <div class="success-message">
            Order created successfully.
        </div>

    <% } %>


    <!-- ================= FILTER / SEARCH ================= -->

    <div class="toolbar">

        <div class="tabs">

            <button class="tab active"
                    type="button"
                    onclick="filterOrders('All', this)">
                All
            </button>

            <button class="tab"
                    type="button"
                    onclick="filterOrders('Pending', this)">
                Pending
            </button>

            <button class="tab"
                    type="button"
                    onclick="filterOrders('Preparing', this)">
                Preparing
            </button>

            <button class="tab"
                    type="button"
                    onclick="filterOrders('Ready', this)">
                Ready
            </button>

            <button class="tab"
                    type="button"
                    onclick="filterOrders('Completed', this)">
                Completed
            </button>

            <button class="tab"
                    type="button"
                    onclick="filterOrders('Cancelled', this)">
                Cancelled
            </button>

        </div>


        <form class="search-row"
              method="get"
              action="<%= request.getContextPath() %>/order">

            <input type="hidden"
                   name="action"
                   value="search">

            <input type="number"
                   name="orderId"
                   min="1"
                   placeholder="Search by Order ID..."
                   required>

            <button type="submit"
                    class="search-btn">
                Search
            </button>

            <a href="<%= request.getContextPath() %>/order"
               class="show-all-btn">
                Show All
            </a>

        </form>

    </div>


    <!-- ================= ORDERS ================= -->

    <div class="orders-card">

        <div class="orders-heading">
            Order List
        </div>


        <% if (searchPerformed) { %>

            <% if (searchedOrder != null) { %>

                <div class="order-row"
                     data-status="<%= searchedOrder.getStatus() %>"
                     onclick="openOrder(<%= searchedOrder.getOrderId() %>)">

                    <div class="order-id">
                        #<%= searchedOrder.getOrderId() %>
                    </div>

                    <div class="small-text">
                        Staff #<%= searchedOrder.getStaffId() %>
                    </div>

                    <div class="small-text order-date">
                        <%= searchedOrder.getOrderDate() %>
                    </div>

                    <div class="price">
                        RM <%= String.format("%.2f",
                                searchedOrder.getTotalPrice()) %>
                    </div>

                    <div>
                        <span class="status <%= searchedOrder.getStatus().toLowerCase() %>">
                            <%= searchedOrder.getStatus() %>
                        </span>
                    </div>

                </div>

            <% } else { %>

                <div class="empty">
                    No order found with that Order ID.
                </div>

            <% } %>


        <% } else if (orderList != null && !orderList.isEmpty()) { %>

            <%
                // Newest orders first
                for (int i = orderList.size() - 1; i >= 0; i--) {

                    Order order = orderList.get(i);
            %>

                <div class="order-row"
                     data-status="<%= order.getStatus() %>"
                     onclick="openOrder(<%= order.getOrderId() %>)">

                    <div class="order-id">
                        #<%= order.getOrderId() %>
                    </div>

                    <div class="small-text">
                        Staff #<%= order.getStaffId() %>
                    </div>

                    <div class="small-text order-date">
                        <%= order.getOrderDate() %>
                    </div>

                    <div class="price">
                        RM <%= String.format("%.2f",
                                order.getTotalPrice()) %>
                    </div>

                    <div>
                        <span class="status <%= order.getStatus().toLowerCase() %>">
                            <%= order.getStatus() %>
                        </span>
                    </div>

                </div>

            <%
                }
            %>

            <div id="filterEmpty"
                 class="empty"
                 style="display:none;">
                No orders found for this status.
            </div>

        <% } else { %>

            <div class="empty">
                No orders available.
            </div>

        <% } %>    

        <% if (!searchPerformed
                && orderList != null
                && !orderList.isEmpty()) { %>

            <div class="pagination"
                 id="pagination">

                <button type="button"
                        class="page-btn"
                        id="prevBtn"
                        onclick="changePage(-1)">
                    Previous
                </button>

                <span class="page-info"
                      id="pageInfo">
                    Page 1 of 1
                </span>

                <button type="button"
                        class="page-btn"
                        id="nextBtn"
                        onclick="changePage(1)">
                    Next
                </button>

            </div>

        <% } %>

    </div>

</div>


<!-- ===================================================== -->
<!-- ORDER DETAILS DRAWER                                  -->
<!-- ===================================================== -->

<% if (selectedOrder != null) { %>

<div class="overlay"
     onclick="closeDrawer()">
</div>


<div class="drawer">

    <div class="drawer-header">

        <h2>
            Order #<%= selectedOrder.getOrderId() %>
        </h2>

        <a href="<%= request.getContextPath() %>/order"
           class="close-btn">
            &times;
        </a>

    </div>


    <div class="drawer-content">


        <!-- ORDER INFO -->

        <div class="detail-section">

            <div class="detail-title">
                Order Information
            </div>

            <div class="info-row">
                <span class="info-label">Order ID</span>
                <strong>#<%= selectedOrder.getOrderId() %></strong>
            </div>

            <div class="info-row">
                <span class="info-label">Staff ID</span>
                <span>#<%= selectedOrder.getStaffId() %></span>
            </div>

            <div class="info-row">
                <span class="info-label">Date</span>
                <span><%= selectedOrder.getOrderDate() %></span>
            </div>

            <div class="info-row">

                <span class="info-label">Status</span>

                <span class="status <%= selectedOrder.getStatus().toLowerCase() %>">
                    <%= selectedOrder.getStatus() %>
                </span>

            </div>

        </div>


        <!-- STATUS PROGRESS -->

        <%
            String currentStatus =
                    selectedOrder.getStatus();

            int statusLevel = 0;

            if ("Pending".equalsIgnoreCase(currentStatus)) {
                statusLevel = 1;
            } else if ("Preparing".equalsIgnoreCase(currentStatus)) {
                statusLevel = 2;
            } else if ("Ready".equalsIgnoreCase(currentStatus)) {
                statusLevel = 3;
            } else if ("Completed".equalsIgnoreCase(currentStatus)) {
                statusLevel = 4;
            }
        %>

        <% if (!"Cancelled".equalsIgnoreCase(currentStatus)) { %>

        <div class="detail-section">

            <div class="detail-title">
                Order Progress
            </div>

            <div class="progress">

                <div class="progress-step <%= statusLevel >= 1 ? "done" : "" %>">
                    <div class="progress-dot"></div>
                    Pending
                </div>

                <div class="progress-step <%= statusLevel >= 2 ? "done" : "" %>">
                    <div class="progress-dot"></div>
                    Preparing
                </div>

                <div class="progress-step <%= statusLevel >= 3 ? "done" : "" %>">
                    <div class="progress-dot"></div>
                    Ready
                </div>

                <div class="progress-step <%= statusLevel >= 4 ? "done" : "" %>">
                    <div class="progress-dot"></div>
                    Completed
                </div>

            </div>

        </div>

        <% } %>


        <!-- ORDER ITEMS -->

        <div class="detail-section">

            <div class="detail-title">
                Order Items
            </div>

            <%
                List<OrderItem> items =
                        selectedOrder.getItems();

                if (items != null && !items.isEmpty()) {

                    for (OrderItem item : items) {
            %>

                <div class="item-row">

                    <div>
                        <div class="item-name">
                            <%= item.getMenuName() %>
                        </div>

                        <div class="item-qty">
                            Quantity: <%= item.getQuantity() %>
                        </div>
                    </div>

                    <div class="item-price">
                        RM <%= String.format("%.2f",
                                item.getSubtotal()) %>
                    </div>

                </div>

            <%
                    }

                } else {
            %>

                <div class="small-text">
                    No order items found.
                </div>

            <%
                }
            %>


            <div class="total-row">
                <span>Total</span>

                <span>
                    RM <%= String.format("%.2f",
                            selectedOrder.getTotalPrice()) %>
                </span>
            </div>

        </div>


        <!-- UPDATE STATUS -->

        <%
            boolean finalStatus =
                    "Completed".equalsIgnoreCase(currentStatus)
                    || "Cancelled".equalsIgnoreCase(currentStatus);
        %>


        <% if (!finalStatus) { %>

        <div class="detail-section">

            <div class="detail-title">
                Update Status
            </div>

            <form class="status-form"
                  method="post"
                  action="<%= request.getContextPath() %>/order">

                <input type="hidden"
                       name="action"
                       value="updateStatus">

                <input type="hidden"
                       name="orderId"
                       value="<%= selectedOrder.getOrderId() %>">


                <select name="status" required>

                    <option value="">
                        Select new status
                    </option>

                    <% if ("Pending".equalsIgnoreCase(currentStatus)) { %>

                        <option value="Preparing">
                            Preparing
                        </option>

                    <% } else if ("Preparing".equalsIgnoreCase(currentStatus)) { %>

                        <option value="Ready">
                            Ready
                        </option>

                    <% } else if ("Ready".equalsIgnoreCase(currentStatus)) { %>

                        <option value="Completed">
                            Completed
                        </option>

                    <% } %>

                </select>


                <button type="submit"
                        class="update-btn">
                    Update Order Status
                </button>

            </form>


            <form method="post"
                  action="<%= request.getContextPath() %>/order"
                  onsubmit="return confirm('Cancel this order?');">

                <input type="hidden"
                       name="action"
                       value="cancel">

                <input type="hidden"
                       name="id"
                       value="<%= selectedOrder.getOrderId() %>">

                <button type="submit"
                        class="cancel-btn">
                    Cancel Order
                </button>

            </form>

        </div>

        <% } else { %>

        <div class="detail-section">

            <div class="final-message">

                <% if ("Completed".equalsIgnoreCase(currentStatus)) { %>
                    This order has been completed.
                <% } else { %>
                    This order has been cancelled.
                <% } %>

            </div>

        </div>

        <% } %>

    </div>

</div>

<% } %>


<script>

    // ==============================
    // OPEN ORDER DETAILS
    // ==============================

    function openOrder(orderId) {

        window.location.href =
            "<%= request.getContextPath() %>/order?open="
            + orderId;
    }


    // ==============================
    // CLOSE DRAWER
    // ==============================

    function closeDrawer() {

        window.location.href =
            "<%= request.getContextPath() %>/order";
    }


    // ==============================
    // FILTER + PAGINATION
    // ==============================

    let currentPage = 1;
    let currentFilter = "All";

    const recordsPerPage = 5;


    // ==============================
    // DISPLAY CURRENT PAGE
    // ==============================

    function displayOrders() {

        const rows =
            Array.from(
                document.querySelectorAll(".order-row")
            );

        const empty =
            document.getElementById("filterEmpty");

        const pagination =
            document.getElementById("pagination");

        const prevBtn =
            document.getElementById("prevBtn");

        const nextBtn =
            document.getElementById("nextBtn");

        const pageInfo =
            document.getElementById("pageInfo");


        // Get orders matching selected status
        const filteredRows =
            rows.filter(row => {

                const rowStatus =
                    row.dataset.status;

                return currentFilter === "All"
                    || rowStatus.toLowerCase()
                    === currentFilter.toLowerCase();
            });


        // Calculate pages
        const totalPages =
            Math.ceil(
                filteredRows.length
                / recordsPerPage
            );


        // Prevent invalid page
        if (currentPage > totalPages
                && totalPages > 0) {

            currentPage = totalPages;
        }


        // Hide all rows first
        rows.forEach(row => {
            row.style.display = "none";
        });


        // No matching orders
        if (filteredRows.length === 0) {

            if (empty) {
                empty.style.display = "block";
            }

            if (pagination) {
                pagination.style.display = "none";
            }

            return;
        }


        if (empty) {
            empty.style.display = "none";
        }


        // Determine records for current page
        const start =
            (currentPage - 1)
            * recordsPerPage;

        const end =
            start + recordsPerPage;


        filteredRows
            .slice(start, end)
            .forEach(row => {

                row.style.display = "grid";
            });


        // Pagination controls
        if (pagination) {

            pagination.style.display =
                "flex";
        }


        if (pageInfo) {

            pageInfo.textContent =
                "Page "
                + currentPage
                + " of "
                + totalPages;
        }


        if (prevBtn) {

            prevBtn.disabled =
                currentPage <= 1;
        }


        if (nextBtn) {

            nextBtn.disabled =
                currentPage >= totalPages;
        }
        }


        // ==============================
        // CHANGE PAGE
        // ==============================

        function changePage(direction) {

            currentPage += direction;

            displayOrders();
        }


        // ==============================
        // FILTER ORDERS
        // ==============================

        function filterOrders(status, button) {

            const tabs =
                document.querySelectorAll(".tab");


            tabs.forEach(tab =>
                tab.classList.remove("active")
            );


            button.classList.add("active");


            // Save selected filter
            currentFilter = status;

            // Every new filter starts page 1
            currentPage = 1;


            displayOrders();
        }


    // ==============================
    // INITIAL DISPLAY
    // ==============================

    document.addEventListener(
        "DOMContentLoaded",
        function () {

            displayOrders();
        }
    );

</script>

</body>
</html>