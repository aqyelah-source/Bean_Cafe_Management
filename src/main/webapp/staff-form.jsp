<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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

    // ==========================================
    // GET STAFF FOR EDIT
    // ==========================================
    Staff staff
            = (Staff) request.getAttribute("staff");

    boolean isEdit
            = staff != null;

    String error
            = request.getParameter("error");
%>


<!DOCTYPE html>

<html>


    <head>

        <meta charset="UTF-8">

        <title>
            <%= isEdit
                    ? "Edit Staff"
                    : "Add Staff"%>
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

                background:
                    #fffaf5;

                border:
                    1px solid #e4d7ca;

                border-radius:
                    14px;

                padding:
                    28px;

                max-width:
                    800px;
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

                font-family:
                    Arial, sans-serif;

                font-size:
                    15px;

                background:
                    white;

                outline:
                    none;
            }


            input:focus,
            select:focus {

                border-color:
                    #7a573e;
            }


            /* =========================
               MESSAGE
               ========================= */

            .error-message {

                background:
                    #f7dddd;

                color:
                    #96352e;

                border:
                    1px solid #ebc1bd;

                padding:
                    13px 16px;

                margin-bottom:
                    20px;

                border-radius:
                    8px;

                font-size:
                    14px;
            }


            /* =========================
               BUTTONS
               ========================= */

            .form-actions {

                display:
                    flex;

                align-items:
                    center;

                gap:
                    10px;

                margin-top:
                    25px;
            }


            .btn {

                display:
                    inline-flex;

                align-items:
                    center;

                justify-content:
                    center;

                min-height:
                    44px;

                padding:
                    0 20px;

                border:
                    none;

                border-radius:
                    8px;

                font-family:
                    Arial, sans-serif;

                font-size:
                    14px;

                font-weight:
                    bold;

                cursor:
                    pointer;

                text-decoration:
                    none;
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

                .form-row {

                    grid-template-columns:
                        1fr;
                }


                .sidebar {

                    width:
                        190px;
                }
            }
            
            /* =========================
                PASSWORD SHOW / HIDE
                ========================= */

             .password-wrapper {
                 position: relative;
                 width: 100%;
             }

             .password-wrapper input {
                 width: 100%;
                 padding-right: 50px;
             }

             .password-toggle {
                 position: absolute;
                 right: 14px;
                 top: 50%;
                 transform: translateY(-50%);

                 border: none;
                 background: transparent;
                 padding: 0;

                 font-size: 18px;
                 cursor: pointer;
             }

             .password-toggle:hover {
                 opacity: 0.7;
             }
             
             .field-guide {
                display: block;
                margin-top: 6px;
                color: #7a573e;
                font-size: 12px;
                line-height: 1.4;
            }
            
            .btn-reset {
                background: #7a573e;
                color: white;
            }

            .btn-reset:hover {
                background: #5f402d;
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
                 CONTENT
                 ========================= -->

            <main class="content">


                <!-- =========================
                     PAGE HEADING
                     ========================= -->

                <div class="page-heading">


                    <h1>

                        <%= isEdit
                                ? "Edit Staff"
                                : "Add Staff"%>

                    </h1>


                    <p>

                        <%= isEdit
                                ? "Update the selected staff account information."
                                : "Create a new Bean Cafe staff account."%>

                    </p>


                </div>



                <!-- =========================
                     FORM CARD
                     ========================= -->

                <div class="form-card">


                    <h2>

                        Staff Information

                    </h2>


                    <p class="form-description">

                        Enter the staff account and
                        employment information below.

                    </p>



                    <!-- =========================
                         ERROR MESSAGES
                         ========================= -->

                    <%
                        if ("empty".equals(error)) {
                    %>


                    <div class="error-message">

                        Please complete all required fields.

                    </div>


                    <%
                    } else if ("admin".equals(error)) {
                    %>


                    <div class="error-message">

                        Admin account could not be identified.

                    </div>


                    <%
                    } else if ("insert".equals(error)) {
                    %>


                    <div class="error-message">

                        Staff account could not be added.
                        Please check the information and try again.

                    </div>


                    <%
                    } else if ("update".equals(error)) {
                    %>


                    <div class="error-message">

                        Staff information could not be updated.

                    </div>


                    <%
                        }
                    %>



                    <!-- =========================
                         STAFF FORM
                         ========================= -->

                    <form action="${pageContext.request.contextPath}/admin-staff"
                         method="post">


                        <!-- INSERT / UPDATE -->

                        <input type="hidden"
                               name="action"
                               value="<%= isEdit
                                       ? "update"
                                       : "insert"%>">


                        <%
                            if (isEdit) {
                        %>


                        <!-- STAFF ID -->

                        <input type="hidden"
                               name="staffId"
                               value="<%= staff.getStaffId()%>">


                        <!-- USER ID -->

                        <input type="hidden"
                               name="userId"
                               value="<%= staff.getUserId()%>">


                        <%
                            }
                        %>



                        <!-- =========================
                        NAME + USERNAME
                        ========================= -->

                   <div class="form-row">

                       <!-- STAFF NAME -->
                       <div class="form-group">

                           <label for="name">
                               Staff Name
                           </label>

                           <input type="text"
                                  id="name"
                                  name="name"
                                  placeholder="Enter staff name"
                                  value="<%= isEdit
                                          ? staff.getName()
                                          : ""%>"
                                  required>

                       </div>


                       <!-- USERNAME -->
                       <div class="form-group">

                           <label for="username">
                               Username
                           </label>

                           <input type="text"
                                  id="username"
                                  name="username"
                                  placeholder="e.g. staff01"
                                  value="<%= isEdit
                                          ? staff.getUsername()
                                          : ""%>"
                                  pattern="(?=.*[A-Za-z])(?=.*[0-9])[A-Za-z0-9]{5,}"
                                  title="Username must be at least 5 characters and contain both letters and numbers."
                                  required>

                           <small class="field-guide">
                               At least 5 characters with letters and numbers
                           </small>

                       </div>

                   </div>


                        <!-- =========================
                             PASSWORD
                             ADD ONLY
                             ========================= -->

                        <%
                            if (!isEdit) {
                        %>


                        <div class="form-row">


                            <div class="form-group full">

                                <label for="password">
                                    Password
                                </label>

                                <div class="password-wrapper">

                                    <input type="password"
                                    id="password"
                                    name="password"
                                    placeholder="e.g. bean1234"
                                    autocomplete="new-password"
                                    pattern="(?=.*[A-Za-z])(?=.*[0-9]).{8,}"
                                    title="Password must be at least 8 characters and contain both letters and numbers."
                                    required>

                                    <button type="button"
                                            class="password-toggle"
                                            onclick="togglePassword()"
                                            aria-label="Show or hide password">

                                        <span id="eyeIcon">👁</span>

                                    </button>

                                </div>
                                
                                <small class="field-guide">
                                    At least 8 characters with letters and numbers.
                                </small>

                            </div>


                        </div>


                        <%
                            }
                        %>



                        <!-- =========================
                             POSITION + SHIFT
                             ========================= -->

                        <div class="form-row">


                            <!-- POSITION -->

                            <div class="form-group">


                                <label for="position">

                                    Position

                                </label>


                                <select id="position"
                                        name="position"
                                        required>


                                    <option value="">

                                        Select Position

                                    </option>


                                    <option value="Cashier"
                                            <%= isEdit
                                                    && "Cashier".equalsIgnoreCase(
                                                            staff.getPosition())
                                                    ? "selected"
                                                    : ""%>>

                                        Cashier

                                    </option>


                                    <option value="Barista"
                                            <%= isEdit
                                                    && "Barista".equalsIgnoreCase(
                                                            staff.getPosition())
                                                    ? "selected"
                                                    : ""%>>

                                        Barista

                                    </option>


                                    <option value="Kitchen Staff"
                                            <%= isEdit
                                                    && "Kitchen Staff".equalsIgnoreCase(
                                                            staff.getPosition())
                                                    ? "selected"
                                                    : ""%>>

                                        Kitchen Staff

                                    </option>


                                </select>


                            </div>



                            <!-- SHIFT -->

                            <div class="form-group">


                                <label for="shift">

                                    Shift

                                </label>


                                <select id="shift"
                                        name="shift"
                                        required>


                                    <option value="">

                                        Select Shift

                                    </option>


                                    <option value="Morning"
                                            <%= isEdit
                                                    && "Morning".equalsIgnoreCase(
                                                            staff.getShift())
                                                    ? "selected"
                                                    : ""%>>

                                        Morning

                                    </option>


                                    <option value="Evening"
                                            <%= isEdit
                                                    && "Evening".equalsIgnoreCase(
                                                            staff.getShift())
                                                    ? "selected"
                                                    : ""%>>

                                        Evening

                                    </option>


                                </select>


                            </div>


                        </div>



                        <!-- =========================
                             BUTTONS
                             ========================= -->

                        <div class="form-actions">


                            <button type="submit"
                                    class="btn btn-save">

                                <%= isEdit
                                        ? "Update Staff"
                                        : "Add Staff"%>

                            </button>


                            <% if (isEdit) { %>

                            <a class="btn btn-reset"
                               href="${pageContext.request.contextPath}/admin-staff?action=reset-password&id=<%= staff.getStaffId()%>">
                                Reset Password
                            </a>

                            <% } %>


                            <a class="btn btn-cancel"
                               href="${pageContext.request.contextPath}/admin-staff">
                                Cancel
                            </a>


                        </div>


                    </form>


                </div>


            </main>


        </div>
                               
        <script>
            function togglePassword() {

                const password =
                        document.getElementById("password");

                const eyeIcon =
                        document.getElementById("eyeIcon");

                if (password.type === "password") {

                    password.type = "text";
                    eyeIcon.textContent = "🙈";

                } else {

                    password.type = "password";
                    eyeIcon.textContent = "👁";
                }
            }
        </script>                       
                               

    </body>

</html>
