<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
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
    // GET MENU LIST
    // ==========================================
    List<Menu> menuList
            = (List<Menu>) request.getAttribute("menuList");

    String keyword
            = request.getParameter("keyword");

    if (keyword == null) {
        keyword = "";
    }
    
        String selectedCategory
            = (String) request.getAttribute("selectedCategory");

        if (selectedCategory == null) {
            selectedCategory = "All";
        }

        Integer currentPageObj
                = (Integer) request.getAttribute("currentPage");

        Integer totalPagesObj
                = (Integer) request.getAttribute("totalPages");

        int currentPage
                = currentPageObj != null ? currentPageObj : 1;

        int totalPages
                = totalPagesObj != null ? totalPagesObj : 1;
        
                
        Boolean searchModeObj
                = (Boolean) request.getAttribute("searchMode");

        boolean searchMode
                = searchModeObj != null && searchModeObj;

        String searchKeyword
                = (String) request.getAttribute("searchKeyword");

        if (searchKeyword == null) {
            searchKeyword = "";
        }
%>


<!DOCTYPE html>

<html>


    <head>

        <meta charset="UTF-8">

        <title>
            Menu Management - Bean Cafe
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
               BUTTONS
               ========================= */

            .btn {

                display:
                    inline-flex;

                align-items:
                    center;

                justify-content:
                    center;

                text-decoration:
                    none;

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
            }


            .btn-add {

                padding:
                    13px 20px;

                background:
                    #4b2e1e;

                color:
                    white;
            }


            .btn-add:hover {

                background:
                    #6f4e37;
            }


            .btn-edit {

                padding:
                    8px 14px;

                background:
                    #eadccc;

                color:
                    #4b2e1e;
            }


            .btn-edit:hover {

                background:
                    #d8c4b2;
            }


            .btn-delete {

                padding:
                    8px 14px;

                margin-left:
                    5px;

                background:
                    #f4d9d5;

                color:
                    #96352e;
            }


            .btn-delete:hover {

                background:
                    #ecc5c0;
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

                color:
                    #321b0f;

                font-size:
                    21px;
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


            .action-column {

                white-space:
                    nowrap;
            }


            .no-data {

                text-align:
                    center;

                color:
                    #7a573e;

                padding:
                    30px;
            }



            /* =========================
               AVAILABILITY STATUS
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


            .available {

                background:
                    #dff3e4;

                color:
                    #26743b;
            }


            .unavailable {

                background:
                    #f4d9d5;

                color:
                    #96352e;
            }



            /* =========================
               RESPONSIVE
               ========================= */

            @media (max-width: 800px) {

                .sidebar {

                    width:
                        190px;
                }


                .page-heading {

                    align-items:
                        flex-start;

                    gap:
                        20px;
                }
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

                padding:
                    0 22px;

                height:
                    44px;

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


            .btn-show:hover {

                background:
                    #ddcabb;
            }
            
            /* =========================
                CATEGORY FILTER
                ========================= */

             .category-filter {
                 display: flex;
                 align-items: center;
                 gap: 10px;
                 margin-bottom: 20px;
             }

             .category-filter label {
                 font-size: 14px;
                 font-weight: bold;
                 color: #4b2e1e;
             }

             .category-filter select {
                 padding: 9px 14px;
                 border: 1px solid #d8c7b7;
                 border-radius: 8px;
                 background: white;
                 color: #4b2e1e;
                 font-size: 14px;
                 outline: none;
                 cursor: pointer;
             }


             /* =========================
                PAGINATION
                ========================= */

             .pagination {
                 display: flex;
                 justify-content: center;
                 align-items: center;
                 gap: 14px;
                 margin-top: 22px;
             }

             .page-btn {
                 padding: 9px 16px;
                 background: #4b2e1e;
                 color: white;
                 text-decoration: none;
                 border-radius: 8px;
                 font-size: 14px;
                 font-weight: bold;
             }

             .page-btn:hover {
                 background: #6f4e37;
             }

             .page-btn.disabled {
                 background: #ddd0c3;
                 color: #927b68;
                 cursor: default;
             }

             .page-info {
                 font-size: 14px;
                 font-weight: bold;
                 color: #4b2e1e;
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
                   href="${pageContext.request.contextPath}/admin-staff">
                    Staff Management
                </a>

                <a class="menu-item active"
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
                 MAIN CONTENT
                 ========================= -->

            <main class="content">



                <!-- =========================
                     PAGE HEADING
                     ========================= -->

                <div class="page-heading">


                    <div>


                        <h1>

                            Menu Management

                        </h1>


                        <p>

                            Manage Bean Cafe menu items,
                            prices and availability.

                        </p>


                    </div>



                    <a class="btn btn-add"
                       href="${pageContext.request.contextPath}/menu?action=add">

                        + Add Menu

                    </a>


                </div>

                <!-- =========================
                     SEARCH MENU
                     ========================= -->

                <div class="search-card">

                    <form class="search-form"
                          action="${pageContext.request.contextPath}/menu"
                          method="get">


                        <input type="hidden"
                               name="action"
                               value="search">


                        <input type="text"
                               name="keyword"
                               placeholder="Search by menu name or category..."
                               value="<%= keyword%>">


                        <button type="submit"
                                class="btn-search">

                            Search

                        </button>


                        <a class="btn-show"
                           href="${pageContext.request.contextPath}/menu">

                            Show All

                        </a>

                    </form>

                </div>


                <!-- =========================
                     MENU TABLE CARD
                     ========================= -->

                <div class="table-card">


                    <h2>

                        Menu Records

                    </h2>


                    <p class="table-description">

                        View, update or delete
                        existing menu items.

                    </p>
                    
                    <form action="${pageContext.request.contextPath}/menu"
                            method="get"
                            class="category-filter">

                          <label for="category">
                              Filter by Category:
                          </label>

                          <select name="category"
                                  id="category"
                                  onchange="this.form.submit()">

                              <option value="All"
                                      <%= "All".equalsIgnoreCase(selectedCategory)
                                              ? "selected" : ""%>>
                                  All Categories
                              </option>

                              <option value="Coffee"
                                      <%= "Coffee".equalsIgnoreCase(selectedCategory)
                                              ? "selected" : ""%>>
                                  Coffee
                              </option>

                              <option value="Non-Coffee"
                                      <%= "Non-Coffee".equalsIgnoreCase(selectedCategory)
                                              ? "selected" : ""%>>
                                  Non-Coffee
                              </option>

                              <option value="Dessert"
                                      <%= "Dessert".equalsIgnoreCase(selectedCategory)
                                              ? "selected" : ""%>>
                                  Dessert
                              </option>

                          </select>

                      </form>



                    <table>



                        <thead>


                            <tr>


                                <th>
                                    ID
                                </th>


                                <th>
                                    Menu Name
                                </th>


                                <th>
                                    Category
                                </th>


                                <th>
                                    Price (RM)
                                </th>


                                <th>
                                    Availability
                                </th>


                                <th>
                                    Action
                                </th>


                            </tr>


                        </thead>




                        <tbody>


                            <%
                                if (menuList != null
                                        && !menuList.isEmpty()) {

                                    for (Menu menu
                                            : menuList) {
                            %>



                            <tr>


                                <!-- MENU ID -->

                                <td>

                                    <%= menu.getMenuId()%>

                                </td>



                                <!-- MENU NAME -->

                                <td>

                                    <%= menu.getMenuName()%>

                                </td>



                                <!-- CATEGORY -->

                                <td>

                                    <%= menu.getCategory()%>

                                </td>



                                <!-- PRICE -->

                                <td>

                                    RM
                                    <%= String.format(
                                            "%.2f",
                                            menu.getPrice())%>

                                </td>



                                <!-- AVAILABILITY -->

                                <td>


                                    <%
                                        if ("Available"
                                                .equalsIgnoreCase(
                                                        menu.getAvailability())) {
                                    %>


                                    <span class="status available">

                                        Available

                                    </span>


                                    <%
                                    } else {
                                    %>


                                    <span class="status unavailable">

                                        Unavailable

                                    </span>


                                    <%
                                        }
                                    %>


                                </td>



                                <!-- ACTION -->

                                <td class="action-column">


                                    <a class="btn btn-edit"
                                       href="${pageContext.request.contextPath}/menu?action=edit&id=<%= menu.getMenuId()%>">

                                        Edit

                                    </a>



                                    <a class="btn btn-delete"
                                       href="${pageContext.request.contextPath}/menu?action=delete&id=<%= menu.getMenuId()%>"
                                       onclick="return confirmDelete('<%= menu.getMenuName()%>');">

                                        Delete

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

                                    No menu items found.

                                </td>


                            </tr>



                            <%
                                }
                            %>


                        </tbody>


                    </table>
                            
                            <div class="pagination">

                                <!-- =========================
                                     PREVIOUS BUTTON
                                     ========================= -->

                                <% if (currentPage > 1) { %>

                                    <% if (searchMode) { %>

                                        <a class="page-btn"
                                           href="${pageContext.request.contextPath}/menu?action=search&keyword=<%= searchKeyword %>&page=<%= currentPage - 1 %>">

                                            &laquo; Previous

                                        </a>

                                    <% } else { %>

                                        <a class="page-btn"
                                           href="${pageContext.request.contextPath}/menu?category=<%= selectedCategory %>&page=<%= currentPage - 1 %>">

                                            &laquo; Previous

                                        </a>

                                    <% } %>

                                <% } else { %>

                                    <span class="page-btn disabled">
                                        &laquo; Previous
                                    </span>

                                <% } %>


                                <!-- =========================
                                     PAGE NUMBER
                                     ========================= -->

                                <span class="page-info">

                                    Page <%= currentPage %> of <%= totalPages %>

                                </span>


                                <!-- =========================
                                     NEXT BUTTON
                                     ========================= -->

                                <% if (currentPage < totalPages) { %>

                                    <% if (searchMode) { %>

                                        <a class="page-btn"
                                           href="${pageContext.request.contextPath}/menu?action=search&keyword=<%= searchKeyword %>&page=<%= currentPage + 1 %>">

                                            Next &raquo;

                                        </a>

                                    <% } else { %>

                                        <a class="page-btn"
                                           href="${pageContext.request.contextPath}/menu?category=<%= selectedCategory %>&page=<%= currentPage + 1 %>">

                                            Next &raquo;

                                        </a>

                                    <% } %>

                                <% } else { %>

                                    <span class="page-btn disabled">
                                        Next &raquo;
                                    </span>

                                <% } %>

                            </div>


                </div>


            </main>


        </div>



        <!-- =========================
             DELETE CONFIRMATION
             ========================= -->

        <script>

            function confirmDelete(menuName) {

                return confirm(
                        "Are you sure you want to delete "
                        + menuName
                        + "?"
                        );
            }

        </script>


    </body>

</html>
