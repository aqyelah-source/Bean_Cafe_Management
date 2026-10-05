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
    // GET STAFF
    // ==========================================
    Staff staff =
            (Staff) request.getAttribute("staff");

    if (staff == null) {
        response.sendRedirect(
                request.getContextPath()
                + "/admin-staff"
        );
        return;
    }

    String error =
            request.getParameter("error");
%>

<!DOCTYPE html>

<html>

<head>

    <meta charset="UTF-8">

    <title>
        Reset Password - Bean Cafe
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
            height: 82px;

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
            font-size: 25px;

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
           STAFF INFORMATION
           ========================= */

        .staff-info {
            background:
                #f8efe5;

            border:
                1px solid #e4d7ca;

            border-radius:
                10px;

            padding:
                16px 18px;

            margin-bottom:
                24px;
        }


        .staff-info strong {
            display:
                block;

            color:
                #321b0f;

            font-size:
                16px;

            margin-bottom:
                4px;
        }


        .staff-info span {
            color:
                #7a573e;

            font-size:
                14px;
        }


        /* =========================
           FORM
           ========================= */

        .form-group {
            display:
                flex;

            flex-direction:
                column;

            margin-bottom:
                20px;
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


        input {
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


        input:focus {
            border-color:
                #7a573e;
        }


        .field-guide {
            display:
                block;

            margin-top:
                6px;

            color:
                #7a573e;

            font-size:
                12px;

            line-height:
                1.4;
        }


        /* =========================
           PASSWORD SHOW / HIDE
           ========================= */

        .password-wrapper {
            position:
                relative;

            width:
                100%;
        }


        .password-wrapper input {
            width:
                100%;

            padding-right:
                50px;
        }


        .password-toggle {
            position:
                absolute;

            right:
                14px;

            top:
                50%;

            transform:
                translateY(-50%);

            border:
                none;

            background:
                transparent;

            padding:
                0;

            font-size:
                18px;

            cursor:
                pointer;
        }


        .password-toggle:hover {
            opacity:
                0.7;
        }


        /* =========================
           ERROR MESSAGE
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


        .btn-reset {
            background:
                #4b2e1e;

            color:
                white;
        }


        .btn-reset:hover {
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


            <div class="page-heading">

                <h1>
                    Reset Password
                </h1>

                <p>
                    Create a new password for the selected staff account.
                </p>

            </div>


            <div class="form-card">

                <h2>
                    Reset Staff Password
                </h2>

                <p class="form-description">
                    The current password cannot be viewed.
                    Enter a new password for this staff account.
                </p>


                <!-- =========================
                     STAFF INFORMATION
                     ========================= -->

                <div class="staff-info">

                    <strong>
                        <%= staff.getName()%>
                    </strong>

                    <span>
                        Username:
                        <%= staff.getUsername()%>
                    </span>

                </div>


                <!-- =========================
                     ERROR MESSAGES
                     ========================= -->

                <%
                    if ("empty".equals(error)) {
                %>

                <div class="error-message">
                    Please enter and confirm the new password.
                </div>

                <%
                    } else if ("mismatch".equals(error)) {
                %>

                <div class="error-message">
                    New password and confirm password do not match.
                </div>

                <%
                    } else if ("invalid".equals(error)) {
                %>

                <div class="error-message">
                    Password must be at least 8 characters
                    and contain both letters and numbers.
                </div>

                <%
                    } else if ("reset".equals(error)) {
                %>

                <div class="error-message">
                    Password could not be reset.
                    Please try again.
                </div>

                <%
                    }
                %>


                <!-- =========================
                     RESET PASSWORD FORM
                     ========================= -->

                <form action="${pageContext.request.contextPath}/admin-staff"
                      method="post">


                    <input type="hidden"
                           name="action"
                           value="reset-password">


                    <input type="hidden"
                           name="staffId"
                           value="<%= staff.getStaffId()%>">


                    <input type="hidden"
                           name="userId"
                           value="<%= staff.getUserId()%>">


                    <!-- NEW PASSWORD -->

                    <div class="form-group">

                        <label for="newPassword">
                            New Password
                        </label>


                        <div class="password-wrapper">

                            <input type="password"
                                   id="newPassword"
                                   name="newPassword"
                                   placeholder="Enter new password"
                                   autocomplete="new-password"
                                   pattern="(?=.*[A-Za-z])(?=.*[0-9]).{8,}"
                                   title="Password must be at least 8 characters and contain both letters and numbers."
                                   required>


                            <button type="button"
                                    class="password-toggle"
                                    onclick="togglePassword(
                                            'newPassword',
                                            'newEye'
                                    )"
                                    aria-label="Show or hide new password">

                                <span id="newEye">
                                    👁
                                </span>

                            </button>

                        </div>


                        <small class="field-guide">
                            At least 8 characters with letters and numbers.
                            Example: bean1234
                        </small>

                    </div>


                    <!-- CONFIRM PASSWORD -->

                    <div class="form-group">

                        <label for="confirmPassword">
                            Confirm New Password
                        </label>


                        <div class="password-wrapper">

                            <input type="password"
                                   id="confirmPassword"
                                   name="confirmPassword"
                                   placeholder="Confirm new password"
                                   autocomplete="new-password"
                                   pattern="(?=.*[A-Za-z])(?=.*[0-9]).{8,}"
                                   title="Password must be at least 8 characters and contain both letters and numbers."
                                   required>


                            <button type="button"
                                    class="password-toggle"
                                    onclick="togglePassword(
                                            'confirmPassword',
                                            'confirmEye'
                                    )"
                                    aria-label="Show or hide confirm password">

                                <span id="confirmEye">
                                    👁
                                </span>

                            </button>

                        </div>

                    </div>


                    <!-- BUTTONS -->

                    <div class="form-actions">

                        <button type="submit"
                                class="btn btn-reset">

                            Reset Password

                        </button>


                        <a class="btn btn-cancel"
                           href="${pageContext.request.contextPath}/admin-staff?action=edit&id=<%= staff.getStaffId()%>">

                            Cancel

                        </a>

                    </div>

                </form>

            </div>

        </main>

    </div>


    <!-- =========================
         SHOW / HIDE PASSWORD
         ========================= -->

    <script>

        function togglePassword(
                inputId,
                eyeId) {

            const password =
                    document.getElementById(inputId);

            const eye =
                    document.getElementById(eyeId);


            if (password.type === "password") {

                password.type = "text";
                eye.textContent = "🙈";

            } else {

                password.type = "password";
                eye.textContent = "👁";

            }
        }

    </script>


</body>

</html>