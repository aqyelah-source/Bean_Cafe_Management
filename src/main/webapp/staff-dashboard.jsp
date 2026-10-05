<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    // Only Staff can access this dashboard
    if (session.getAttribute("role") == null ||
        !"Staff".equalsIgnoreCase(
            (String) session.getAttribute("role"))) {

        response.sendRedirect("login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Staff Dashboard - Bean Cafe</title>

    <style>

        body {
            font-family: Arial, sans-serif;
            background: #f5f0eb;
            margin: 0;
        }

        header {
            background: #4b2e1e;
            color: #fff;
            padding: 16px 24px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        header h2 {
            margin: 0;
        }

        header a {
            color: #fff;
            text-decoration: none;
            background: #6f4e37;
            padding: 8px 14px;
            border-radius: 4px;
        }

        .content {
            padding: 24px;
        }

        .content h1 {
            color: #4b2e1e;
        }

        .card-grid {
            display: grid;
            grid-template-columns:
                repeat(auto-fit, minmax(200px, 1fr));
            gap: 16px;
            margin-top: 20px;
        }

        .card-link {
            text-decoration: none;
            color: inherit;
        }

        .card {
            background: #fff;
            padding: 25px;
            border-radius: 8px;
            box-shadow:
                0 2px 6px rgba(0,0,0,0.08);
            text-align: center;
            cursor: pointer;
            transition: 0.2s;
        }

        .card:hover {
            transform: translateY(-3px);
            box-shadow:
                0 4px 10px rgba(0,0,0,0.15);
        }

        .card h3 {
            color: #4b2e1e;
            margin-top: 0;
        }

        .card p {
            color: #666;
            font-size: 14px;
        }

    </style>

</head>


<body>


<!-- ============================== -->
<!-- HEADER                         -->
<!-- ============================== -->

<header>

    <h2>
        Welcome,
        <%= session.getAttribute("name") %>
        (Staff)
    </h2>

    <a href="${pageContext.request.contextPath}/LogoutServlet">
        Logout
    </a>

</header>


<!-- ============================== -->
<!-- DASHBOARD                      -->
<!-- ============================== -->

<div class="content">

    <h1>Staff Dashboard</h1>

    <p>
        Select a function below to manage customer orders.
    </p>


    <div class="card-grid">


        <!-- ========================= -->
        <!-- VIEW MENU                 -->
        <!-- ========================= -->

        <a class="card-link"
           href="${pageContext.request.contextPath}/order?action=add">

            <div class="card">

                <h3>View Menu</h3>

                <p>
                    View available menu items
                    and prices.
                </p>

            </div>

        </a>


        <!-- ========================= -->
        <!-- CREATE ORDER              -->
        <!-- ========================= -->

        <a class="card-link"
           href="${pageContext.request.contextPath}/order?action=add">

            <div class="card">

                <h3>Create Order</h3>

                <p>
                    Select menu items and
                    enter quantities.
                </p>

            </div>

        </a>


        <!-- ========================= -->
        <!-- CALCULATE TOTAL           -->
        <!-- ========================= -->

        <a class="card-link"
           href="${pageContext.request.contextPath}/order?action=add">

            <div class="card">

                <h3>Calculate Order Total</h3>

                <p>
                    Calculate subtotal and
                    total price automatically.
                </p>

            </div>

        </a>


        <!-- ========================= -->
        <!-- MANAGE ORDERS             -->
        <!-- ========================= -->

        <a class="card-link"
           href="${pageContext.request.contextPath}/order">

            <div class="card">

                <h3>Manage Orders</h3>

                <p>
                    View and manage
                    customer orders.
                </p>

            </div>

        </a>


        <!-- ========================= -->
        <!-- UPDATE STATUS             -->
        <!-- ========================= -->

        <a class="card-link"
           href="${pageContext.request.contextPath}/order">

            <div class="card">

                <h3>Update Order Status</h3>

                <p>
                    View an order and
                    update its status.
                </p>

            </div>

        </a>


        <!-- ========================= -->
        <!-- SEARCH ORDER              -->
        <!-- ========================= -->

        <a class="card-link"
           href="${pageContext.request.contextPath}/order">

            <div class="card">

                <h3>Search Order</h3>

                <p>
                    Search for an order
                    using its Order ID.
                </p>

            </div>

        </a>


    </div>

</div>


</body>

</html>
