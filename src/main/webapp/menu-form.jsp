<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.beancafe.model.Menu" %>

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
    // GET MENU FOR EDIT
    // ==========================================
    Menu menu
            = (Menu) request.getAttribute("menu");

    boolean editing
            = (menu != null);
%>


<!DOCTYPE html>

<html>


    <head>

        <meta charset="UTF-8">

        <title>
            <%= editing
                    ? "Edit Menu"
                    : "Add Menu"%>
            - Bean Cafe
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
               FORM CARD
               ========================= */

            .form-card {

                max-width:
                    800px;

                background:
                    #fffaf5;

                border:
                    1px solid #e4d7ca;

                border-radius:
                    14px;

                padding:
                    28px;
            }


            .form-card h2 {

                margin:
                    0 0 8px;

                color:
                    #321b0f;

                font-size:
                    22px;
            }


            .form-description {

                margin:
                    0 0 25px;

                color:
                    #7a573e;

                font-size:
                    14px;
            }



            /* =========================
               FORM
               ========================= */

            .form-row {

                display:
                    grid;

                grid-template-columns:
                    repeat(2, 1fr);

                gap:
                    20px;

                margin-bottom:
                    20px;
            }


            .form-group {

                display:
                    flex;

                flex-direction:
                    column;
            }


            .form-group.full {

                grid-column:
                    1 / -1;
            }


            label {

                margin-bottom:
                    8px;

                font-size:
                    14px;

                font-weight:
                    bold;

                color:
                    #4b2e1e;
            }


            input,
            select {

                height:
                    46px;

                padding:
                    0 14px;

                border:
                    1px solid #d8c7b7;

                border-radius:
                    8px;

                background:
                    white;

                font-family:
                    Arial, sans-serif;

                font-size:
                    15px;

                outline:
                    none;
            }


            input:focus,
            select:focus {

                border-color:
                    #7a573e;
            }



            /* =========================
               BUTTONS
               ========================= */

            .button-area {

                display:
                    flex;

                gap:
                    10px;

                margin-top:
                    25px;
            }


            .btn {

                min-height:
                    44px;

                padding:
                    0 20px;

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

                text-decoration:
                    none;

                display:
                    inline-flex;

                align-items:
                    center;

                justify-content:
                    center;
            }


            .btn-save {

                background:
                    #4b2e1e;

                color:
                    white;
            }


            .btn-save:hover {

                background:
                    #6f4e37;
            }


            .btn-cancel {

                background:
                    #eadccc;

                color:
                    #4b2e1e;
            }


            .btn-cancel:hover {

                background:
                    #ddcabb;
            }



            /* =========================
               RESPONSIVE
               ========================= */

            @media (max-width: 800px) {

                .sidebar {

                    width:
                        190px;
                }


                .form-row {

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
                   href="${pageContext.request.contextPath}/staff">

                    Staff Management

                </a>



                <a class="menu-item active"
                   href="${pageContext.request.contextPath}/menu">

                    Menu Management

                </a>



                <a class="menu-item"
                   href="${pageContext.request.contextPath}/order">

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

                        <%= editing
                                ? "Edit Menu"
                                : "Add Menu"%>

                    </h1>


                    <p>

                        <%= editing
                                ? "Update the selected menu item information."
                                : "Add a new item to the Bean Cafe menu."%>

                    </p>


                </div>




                <!-- =========================
                     FORM CARD
                     ========================= -->

                <div class="form-card">


                    <h2>

                        Menu Information

                    </h2>


                    <p class="form-description">

                        Enter the menu name,
                        category, price and availability.

                    </p>



                    <form method="post"
                          action="${pageContext.request.contextPath}/menu">



                        <!-- =========================
                             INSERT / UPDATE ACTION
                             ========================= -->

                        <%
                            if (editing) {
                        %>


                        <input type="hidden"
                               name="action"
                               value="update">


                        <input type="hidden"
                               name="menuId"
                               value="<%= menu.getMenuId()%>">


                        <%
                        } else {
                        %>


                        <input type="hidden"
                               name="action"
                               value="insert">


                        <%
                            }
                        %>



                        <!-- =========================
                             MENU NAME
                             ========================= -->

                        <div class="form-row">


                            <div class="form-group full">


                                <label for="menuName">

                                    Menu Name

                                </label>


                                <input type="text"
                                       id="menuName"
                                       name="menuName"
                                       placeholder="Enter menu name"
                                       value="<%= editing
                                               ? menu.getMenuName()
                                               : ""%>"
                                       required>


                            </div>


                        </div>



                        <!-- =========================
                             CATEGORY + PRICE
                             ========================= -->

                        <div class="form-row">



                            <!-- CATEGORY -->

                            <div class="form-group">


                                <label for="category">

                                    Category

                                </label>


                                <select id="category"
                                        name="category"
                                        required>


                                    <option value="">

                                        Select Category

                                    </option>



                                    <option value="Coffee"
                                            <%= editing
                                                    && "Coffee".equals(
                                                            menu.getCategory())
                                                    ? "selected"
                                                    : ""%>>

                                        Coffee

                                    </option>



                                    <option value="Non-Coffee"
                                            <%= editing
                                                    && "Non-Coffee".equals(
                                                            menu.getCategory())
                                                    ? "selected"
                                                    : ""%>>

                                        Non-Coffee

                                    </option>



                                    <option value="Dessert"
                                            <%= editing
                                                    && "Dessert".equals(
                                                            menu.getCategory())
                                                    ? "selected"
                                                    : ""%>>

                                        Dessert

                                    </option>


                                </select>


                            </div>



                            <!-- PRICE -->

                            <div class="form-group">


                                <label for="price">

                                    Price (RM)

                                </label>


                                <input type="number"
                                       id="price"
                                       name="price"
                                       step="0.01"
                                       min="0"
                                       placeholder="0.00"
                                       value="<%= editing
                                               ? menu.getPrice()
                                               : ""%>"
                                       required>


                            </div>


                        </div>



                        <!-- =========================
                             AVAILABILITY
                             ========================= -->

                        <div class="form-row">


                            <div class="form-group full">


                                <label for="availability">

                                    Availability

                                </label>


                                <select id="availability"
                                        name="availability"
                                        required>


                                    <option value="Available"
                                            <%= editing
                                                    && "Available".equals(
                                                            menu.getAvailability())
                                                    ? "selected"
                                                    : ""%>>

                                        Available

                                    </option>


                                    <option value="Unavailable"
                                            <%= editing
                                                    && "Unavailable".equals(
                                                            menu.getAvailability())
                                                    ? "selected"
                                                    : ""%>>

                                        Unavailable

                                    </option>


                                </select>


                            </div>


                        </div>



                        <!-- =========================
                             BUTTONS
                             ========================= -->

                        <div class="button-area">


                            <button type="submit"
                                    class="btn btn-save">

                                <%= editing
                                        ? "Update Menu"
                                        : "Add Menu"%>

                            </button>


                            <a class="btn btn-cancel"
                               href="${pageContext.request.contextPath}/menu">

                                Cancel

                            </a>


                        </div>


                    </form>


                </div>


            </main>


        </div>


    </body>

</html>
