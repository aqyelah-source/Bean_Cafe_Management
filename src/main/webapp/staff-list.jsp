<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.beancafe.model.Staff" %>

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

    List<Staff> staffList
            = (List<Staff>) request.getAttribute("staffList");

    String keyword
            = (String) request.getAttribute("keyword");

    if (keyword == null) {
        keyword = "";
    }

    String success
            = request.getParameter("success");

    String error
            = request.getParameter("error");
%>


<!DOCTYPE html>
<html>

    <head>

        <meta charset="UTF-8">

        <title>
            Staff Management - Bean Cafe
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
               SAME AS ADMIN DASHBOARD
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
               SAME AS ADMIN DASHBOARD
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


            .menu-item.disabled {

                color:
                    #b49c89;

                cursor:
                    default;
            }


            .menu-item.disabled:hover {

                background:
                    transparent;
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
                    inline-block;

                border:
                    none;

                text-decoration:
                    none;

                font-family:
                    Arial, sans-serif;

                font-size:
                    14px;

                font-weight:
                    bold;

                cursor:
                    pointer;

                border-radius:
                    8px;
            }


            .btn-add {

                background:
                    #4b2e1e;

                color:
                    white;

                padding:
                    13px 20px;
            }


            .btn-add:hover {

                background:
                    #6f4e37;
            }


            .btn-search {

                height:
                    46px;

                padding:
                    0 22px;

                background:
                    #4b2e1e;

                color:
                    white;
            }


            .btn-search:hover {

                background:
                    #6f4e37;
            }


            .btn-show {

                height:
                    46px;

                padding:
                    0 22px;

                background:
                    #eadccc;

                color:
                    #4b2e1e;

                display:
                    flex;

                align-items:
                    center;
            }


            .btn-show:hover {

                background:
                    #ddcabb;
            }


            .btn-edit {

                background:
                    #eadccc;

                color:
                    #4b2e1e;

                padding:
                    8px 14px;
            }


            .btn-edit:hover {

                background:
                    #d8c4b2;
            }


            .btn-delete {

                background:
                    #f4d9d5;

                color:
                    #96352e;

                padding:
                    8px 14px;

                margin-left:
                    5px;
            }


            .btn-delete:hover {

                background:
                    #ecc5c0;
            }


            /* =========================
               MESSAGES
               ========================= */

            .message {

                padding:
                    14px 16px;

                border-radius:
                    8px;

                margin-bottom:
                    20px;

                font-size:
                    14px;
            }


            .success-message {

                background:
                    #e2f2e4;

                color:
                    #26743b;

                border:
                    1px solid #bee0c3;
            }


            .error-message {

                background:
                    #f7dddd;

                color:
                    #96352e;

                border:
                    1px solid #ebc1bd;
            }


            /* =========================
               SEARCH
               ========================= */

            .search-box {

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

                align-items:
                    center;

                gap:
                    10px;
            }


            .search-form input {

                flex:
                    1;

                height:
                    46px;

                border:
                    1px solid #d8c7b7;

                border-radius:
                    8px;

                padding:
                    0 15px;

                background:
                    white;

                font-size:
                    16px;

                outline:
                    none;
            }


            .search-form input:focus {

                border-color:
                    #7a573e;
            }


            /* =========================
               STAFF TABLE
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

                padding:
                    30px;

                color:
                    #7a573e;
            }


            /* =========================
               RESPONSIVE
               ========================= */

            @media (max-width: 1000px) {

                .sidebar {

                    width:
                        200px;
                }

            }


            @media (max-width: 800px) {

                .search-form {

                    flex-wrap:
                        wrap;
                }


                .page-heading {

                    gap:
                        20px;

                    align-items:
                        flex-start;
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

                <a class="menu-item active"
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
                 MAIN CONTENT
                 ========================= -->

            <main class="content">


                <!-- =========================
                     PAGE TITLE
                     ========================= -->

                <div class="page-heading">


                    <div>


                        <h1>

                            Staff Management

                        </h1>


                        <p>

                            Manage and search Bean Cafe
                            staff accounts.

                        </p>


                    </div>


                    <a class="btn btn-add"
                        href="${pageContext.request.contextPath}/admin-staff?action=add">
                         + Add Staff
                     </a>


                </div>



                <!-- =========================
                     SUCCESS MESSAGES
                     ========================= -->

                <%
                    if ("added".equals(success)) {
                %>


                <div class="message success-message">

                    Staff account added successfully.

                </div>


                <%
                } else if ("updated".equals(success)) {
                %>


                <div class="message success-message">

                    Staff information updated successfully.

                </div>


                <%
                } else if ("deleted".equals(success)) {
                %>


                <div class="message success-message">

                    Staff account deleted successfully.

                </div>


                <%
                    }
                %>



                <!-- =========================
                     ERROR MESSAGES
                     ========================= -->

                <%
                    if ("notfound".equals(error)) {
                %>


                <div class="message error-message">

                    Staff record was not found.

                </div>


                <%
                } else if ("delete".equals(error)) {
                %>


                <div class="message error-message">

                    Staff account could not be deleted.

                </div>


                <%
                    }
                %>



                <!-- =========================
                     SEARCH STAFF
                     ========================= -->

                <div class="search-box">


                    <form class="search-form"
                          action="${pageContext.request.contextPath}/admin-staff"
                          method="get">


                        <input type="hidden"
                               name="action"
                               value="search">


                        <input type="text"
                               name="keyword"
                               value="<%= keyword%>"
                               placeholder="Search by staff name or username">


                        <button type="submit"
                                class="btn btn-search">

                            Search

                        </button>


                        <a class="btn btn-show"
                            href="${pageContext.request.contextPath}/admin-staff">
                             Show All
                         </a>


                    </form>


                </div>



                <!-- =========================
                     STAFF RECORDS
                     ========================= -->

                <div class="table-card">


                    <h2>

                        Staff Records

                    </h2>


                    <p class="table-description">

                        View, update or delete existing
                        Bean Cafe staff accounts.

                    </p>



                    <table>


                        <thead>


                            <tr>


                                <th>
                                    Staff ID
                                </th>


                                <th>
                                    Name
                                </th>


                                <th>
                                    Username
                                </th>


                                <th>
                                    Position
                                </th>


                                <th>
                                    Shift
                                </th>


                                <th>
                                    Action
                                </th>


                            </tr>


                        </thead>



                        <tbody>


                            <%
                                if (staffList != null
                                        && !staffList.isEmpty()) {

                                    for (Staff staff : staffList) {
                            %>


                            <tr>


                                <td>

                                    <%= staff.getStaffId()%>

                                </td>


                                <td>

                                    <%= staff.getName()%>

                                </td>


                                <td>

                                    <%= staff.getUsername()%>

                                </td>


                                <td>

                                    <%= staff.getPosition()%>

                                </td>


                                <td>

                                    <%= staff.getShift()%>

                                </td>


                                <td class="action-column">


                                    <!-- EDIT STAFF -->

                                    <a class="btn btn-edit"
                                        href="${pageContext.request.contextPath}/admin-staff?action=edit&id=<%= staff.getStaffId()%>">
                                         Edit
                                     </a>



                                    <!-- DELETE STAFF -->

                                    <a class="btn btn-delete"
                                       href="${pageContext.request.contextPath}/admin-staff?action=delete&id=<%= staff.getStaffId()%>"
                                       onclick="return confirmDelete('<%= staff.getName()%>');">

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

                                    No staff records found.

                                </td>


                            </tr>


                            <%
                                }
                            %>


                        </tbody>


                    </table>


                </div>


            </main>


        </div>



        <script>

            function confirmDelete(name) {

                return confirm(
                        "Are you sure you want to delete staff "
                        + name
                        + "?"
                        );
            }

        </script>


    </body>

</html>

