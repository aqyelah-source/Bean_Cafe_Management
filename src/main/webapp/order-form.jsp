<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.beancafe.model.Menu" %>

<%
    // Only Staff can access this page
    if (session.getAttribute("role") == null ||
        !"Staff".equalsIgnoreCase((String) session.getAttribute("role"))) {
        //if not staff it will return login
        response.sendRedirect("login.jsp");
        return;
    }
    
    //take data from menu, then save as menulist
    List<Menu> menuList =
            (List<Menu>) request.getAttribute("menuList");
    
    //check if have any error if have return error
    String error = request.getParameter("error");
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff POS - Bean Cafe</title>

    <style>
        * {
            box-sizing: border-box;
        }

        body {
            margin: 0;
            font-family: "Segoe UI", Arial, sans-serif;
            background: #f3eadf;
            color: #2c1a0e;
        }

        /* ================= HEADER ================= */

        .header {
            height: 70px;
            background: #f8f1e8;
            border-bottom: 1px solid #e2d3c1;
            display: flex;
            align-items: center;
            padding: 0 28px;
            gap: 25px;
        }

        .brand {
            font-size: 22px;
            font-weight: 800;
            color: #3b2314;
        }

        .badge {
            background: #3b2314;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .nav {
            display: flex;
            gap: 8px;
        }

        .nav a {
            text-decoration: none;
            color: #7a6553;
            padding: 9px 17px;
            border-radius: 20px;
            font-weight: 600;
        }

        .nav a.active {
            background: #3b2314;
            color: white;
        }

        .nav a:hover {
            background: #e8dac9;
            color: #3b2314;
        }

        .staff-info {
            margin-left: auto;
            text-align: right;
            font-size: 13px;
            color: #7a6553;
        }

        .staff-info strong {
            display: block;
            color: #2c1a0e;
            font-size: 14px;
        }

        .logout {
            margin-left: 12px;
            text-decoration: none;
            background: #3b2314;
            color: white;
            padding: 9px 16px;
            border-radius: 20px;
            font-size: 13px;
            font-weight: 600;
        }

        /* ================= MAIN ================= */

        .layout {
            display: grid;
            grid-template-columns: 1fr 390px;
            min-height: calc(100vh - 70px);
        }

        /* ================= LEFT ================= */

        .menu-section {
            padding: 24px;
        }

        .section-title {
            margin: 0 0 5px;
            font-size: 23px;
        }

        .subtitle {
            color: #7a6553;
            margin: 0 0 20px;
            font-size: 14px;
        }

        .search-box {
            width: 100%;
            padding: 12px 17px;
            border-radius: 25px;
            border: 1px solid #e2d3c1;
            background: #fffaf3;
            font-size: 14px;
            outline: none;
            margin-bottom: 16px;
        }

        .search-box:focus {
            border-color: #c98a12;
        }

        /* ================= CATEGORY ================= */

        .categories {
            display: flex;
            gap: 9px;
            margin-bottom: 20px;
        }

        .category-btn {
            border: 1px solid #e2d3c1;
            background: #f8f1e8;
            color: #7a6553;
            padding: 9px 18px;
            border-radius: 12px;
            cursor: pointer;
            font-weight: 600;
        }

        .category-btn.active {
            background: #3b2314;
            color: white;
            border-color: #3b2314;
        }

        /* ================= MENU GRID ================= */

        .menu-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(170px, 1fr));
            gap: 14px;
        }

        .menu-card {
            background: #fffaf3;
            border: 1px solid #e2d3c1;
            border-radius: 15px;
            padding: 17px;
            min-height: 135px;
            display: flex;
            flex-direction: column;
            position: relative;
            transition: 0.15s;
        }

        .menu-card.available {
            cursor: pointer;
        }

        .menu-card.available:hover {
            transform: translateY(-3px);
            box-shadow: 0 5px 14px rgba(59, 35, 20, 0.10);
        }

        .menu-card.unavailable {
            opacity: 0.55;
            cursor: not-allowed;
        }
        
        .menu-image {
            width: 100%;
            height: 120px;
            object-fit: cover;
            border-radius: 10px;
            margin-bottom: 12px;
            display: block;
        }

        .menu-name {
            font-weight: 700;
            font-size: 16px;
            margin-bottom: 5px;
        }

        .menu-category {
            font-size: 12px;
            color: #7a6553;
            margin-bottom: 14px;
        }

        .menu-bottom {
            margin-top: auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .menu-price {
            font-weight: 700;
            color: #3b2314;
        }

        .sold-out {
            color: #b3402f;
            font-weight: 700;
            font-size: 13px;
        }

        .add-icon {
            width: 31px;
            height: 31px;
            border-radius: 50%;
            border: none;
            background: #3b2314;
            color: white;
            font-size: 19px;
            cursor: pointer;
        }

        .add-icon:hover {
            background: #6f4e37;
        }

        /* ================= RIGHT / CURRENT ORDER ================= */

        .order-panel {
            background: #f8f1e8;
            border-left: 1px solid #e2d3c1;
            padding: 22px;
            display: flex;
            flex-direction: column;
        }

        .order-panel h2 {
            margin: 0;
            font-size: 20px;
        }

        .order-staff {
            color: #7a6553;
            font-size: 13px;
            margin-top: 5px;
            margin-bottom: 18px;
        }

        .order-items {
            flex: 1;
            max-height: calc(100vh - 310px);
            overflow-y: auto;
        }

        .empty-cart {
            color: #7a6553;
            text-align: center;
            padding: 60px 15px;
            font-size: 14px;
        }

        .cart-item {
            background: #fffaf3;
            border: 1px solid #e2d3c1;
            border-radius: 12px;
            padding: 13px;
            margin-bottom: 9px;
        }

        .cart-top {
            display: flex;
            justify-content: space-between;
            gap: 10px;
            font-weight: 700;
        }

        .cart-price {
            color: #7a6553;
            font-size: 12px;
            margin-top: 3px;
        }

        .cart-bottom {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-top: 11px;
        }

        .quantity-control {
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .quantity-control button {
            width: 29px;
            height: 29px;
            border-radius: 50%;
            border: none;
            background: #3b2314;
            color: white;
            font-size: 17px;
            cursor: pointer;
        }

        .quantity-value {
            min-width: 20px;
            text-align: center;
            font-weight: 700;
        }

        .remove-btn {
            border: none;
            background: none;
            color: #b3402f;
            font-weight: 600;
            cursor: pointer;
            font-size: 12px;
        }

        /* ================= TOTAL ================= */

        .total-area {
            border-top: 1px solid #e2d3c1;
            padding-top: 16px;
            margin-top: 15px;
        }

        .total-row {
            display: flex;
            justify-content: space-between;
            align-items: center;
            font-size: 21px;
            font-weight: 800;
        }

        .action-buttons {
            display: grid;
            grid-template-columns: 1fr 2fr;
            gap: 9px;
            margin-top: 17px;
        }

        .clear-btn,
        .create-btn {
            border: none;
            padding: 13px;
            border-radius: 25px;
            cursor: pointer;
            font-weight: 700;
            font-size: 14px;
        }

        .clear-btn {
            background: #fffaf3;
            border: 1px solid #e2d3c1;
            color: #7a6553;
        }

        .create-btn {
            background: #3b2314;
            color: white;
        }

        .create-btn:hover {
            background: #6f4e37;
        }

        .create-btn:disabled,
        .clear-btn:disabled {
            opacity: 0.45;
            cursor: not-allowed;
        }

        /* ================= MESSAGE ================= */

        .message {
            background: #f8d7da;
            color: #721c24;
            padding: 11px 14px;
            border-radius: 8px;
            margin-bottom: 15px;
            font-size: 13px;
        }

        .no-menu {
            grid-column: 1 / -1;
            text-align: center;
            padding: 40px;
            color: #7a6553;
        }

        /* Hidden inputs used by existing servlet */
        .hidden-quantity {
            display: none;
        }

        @media (max-width: 900px) {
            .layout {
                grid-template-columns: 1fr;
            }

            .order-panel {
                border-left: none;
                border-top: 1px solid #e2d3c1;
            }

            .staff-info {
                display: none;
            }
        }
    </style>
</head>

<body>

<!-- ================= HEADER ================= -->

<header class="header">

    <div class="brand">Bean Cafe!</div>

    <span class="badge">Staff POS</span>

    <nav class="nav">
        <a href="${pageContext.request.contextPath}/order?action=add"
           class="active">
            Take Order
        </a>

        <a href="${pageContext.request.contextPath}/order">
            Manage Orders
        </a>
    </nav>

    <div class="staff-info">
        <strong><%= session.getAttribute("name") %></strong>
        Staff
    </div>

    <a class="logout"
       href="${pageContext.request.contextPath}/LogoutServlet">
        Logout
    </a>

</header>


<form action="${pageContext.request.contextPath}/order"
      method="post"
      id="orderForm"
      onsubmit="return validateOrder();">

    <input type="hidden"
           name="action"
           value="insert">


    <div class="layout">

        <!-- ================= LEFT SIDE ================= -->

        <main class="menu-section">

            <h1 class="section-title">Take Order</h1>

            <p class="subtitle">
                Select menu items for the customer's order.
            </p>

            <!-- if error it will display -->
            <% if ("staff".equals(error)) { %>

                <div class="message">
                    Staff account could not be found.
                </div>

            <% } else if ("items".equals(error)) { %>

                <div class="message">
                    Invalid menu item information.
                </div>

            <% } else if ("noitem".equals(error)) { %>

                <div class="message">
                    Please select at least one menu item.
                </div>

            <% } else if ("number".equals(error)) { %>

                <div class="message">
                    Please enter a valid quantity.
                </div>

            <% } else if ("insert".equals(error)) { %>

                <div class="message">
                    Order could not be created.
                </div>

            <% } %>


            <!-- SEARCH -->

            <input type="text"
                   id="menuSearch"
                   class="search-box"
                   placeholder="Search menu..."
                   oninput="filterMenu()">


            <!-- CATEGORY -->

            <div class="categories">

                <button type="button"
                        class="category-btn active"
                        data-category="Coffee"
                        onclick="selectCategory('Coffee', this)">
                    Coffee
                </button>

                <button type="button"
                        class="category-btn"
                        data-category="Non-Coffee"
                        onclick="selectCategory('Non-Coffee', this)">
                    Non-Coffee
                </button>

                <button type="button"
                        class="category-btn"
                        data-category="Dessert"
                        onclick="selectCategory('Dessert', this)">
                    Dessert
                </button>

            </div>


            <!-- MENU CARDS -->

            <div class="menu-grid" id="menuGrid">

                <%
                    if (menuList != null && !menuList.isEmpty()) {

                        for (Menu menu : menuList) {

                            boolean available =
                                    "Available".equalsIgnoreCase(
                                            menu.getAvailability());

                            String category =
                                    menu.getCategory() == null
                                            ? ""
                                            : menu.getCategory();
                %>
                    
                    <!-- available or unavailable--->
                    <div class="menu-card <%= available ? "available" : "unavailable" %>"
                        data-id="<%= menu.getMenuId() %>"
                        data-name="<%= menu.getMenuName() %>"
                        data-category="<%= category %>"
                        data-price="<%= menu.getPrice() %>"
                        <% if (available) { %>
                        onclick="addItem(<%= menu.getMenuId() %>)"
                        <% } %>>
                        
                        <img class="menu-image"
                             src="${pageContext.request.contextPath}/images/menu/<%= menu.getMenuId() %>.jpg"
                             alt="<%= menu.getMenuName() %>">

                        <div class="menu-name">
                            <%= menu.getMenuName() %>
                        </div>

                        <div class="menu-category">
                            <%= category %>
                        </div>

                        <div class="menu-bottom">

                            <% if (available) { %>

                                <span class="menu-price">
                                    RM <%= String.format("%.2f", menu.getPrice()) %>
                                </span>


                            <% } else { %>

                                <span class="sold-out">
                                    Unavailable
                                </span>

                            <% } %>

                        </div>


                        <!-- Existing servlet still receives menuId + quantity -->

                        <input type="hidden"
                               name="menuId"
                               value="<%= menu.getMenuId() %>">

                        <input type="number"
                               name="quantity"
                               id="qty-<%= menu.getMenuId() %>"
                               class="hidden-quantity"
                               value="0"
                               min="0">

                    </div>

                <%
                        }

                    } else {
                %>

                    <div class="no-menu">
                        No menu items found.
                    </div>

                <%
                    }
                %>

            </div>

        </main>


        <!-- ================= CURRENT ORDER ================= -->

        <aside class="order-panel">

            <h2>Current Order</h2>

            <div class="order-staff">
                Staff:
                <strong><%= session.getAttribute("name") %></strong>
            </div>

            <div class="order-items"
                 id="cartItems">

                <div class="empty-cart">
                    No items selected.<br>
                    Click a menu item to add it.
                </div>

            </div>


            <div class="total-area">

                <div class="total-row">
                    <span>Total</span>

                    <span>
                        RM <span id="totalPrice">0.00</span>
                    </span>
                </div>


                <div class="action-buttons">

                    <button type="button"
                            id="clearButton"
                            class="clear-btn"
                            onclick="clearOrder()"
                            disabled>
                        Clear
                    </button>

                    <button type="submit"
                            id="createButton"
                            class="create-btn"
                            disabled>
                        Create Order
                    </button>

                </div>

            </div>

        </aside>

    </div>

</form>


<script>

    let selectedCategory = "Coffee";


    /* =========================================
       ADD ITEM
       ========================================= */

    function addItem(menuId) {

        const input =
                document.getElementById("qty-" + menuId);

        input.value =
                parseInt(input.value || 0) + 1;

        updateCart();
    }


    /* =========================================
       CHANGE QUANTITY
       ========================================= */

    function changeQuantity(menuId, amount) {

        const input =
                document.getElementById("qty-" + menuId);

        let quantity =
                parseInt(input.value || 0) + amount;

        if (quantity < 0) {
            quantity = 0;
        }

        input.value = quantity;

        updateCart();
    }


    /* =========================================
       REMOVE ITEM
       ========================================= */

    function removeItem(menuId) {

        const input =
                document.getElementById("qty-" + menuId);

        input.value = 0;

        updateCart();
    }


    /* =========================================
       UPDATE CURRENT ORDER
       ========================================= */

    function updateCart() {

        const cards =
                document.querySelectorAll(".menu-card");

        const cart =
                document.getElementById("cartItems");

        let html = "";

        let total = 0;

        let hasItem = false;


        cards.forEach(function(card) {

            const menuId =
                    card.dataset.id;

            const name =
                    card.dataset.name;

            const price =
                    parseFloat(card.dataset.price);

            const quantityInput =
                    document.getElementById(
                            "qty-" + menuId
                    );

            const quantity =
                    parseInt(quantityInput.value || 0);


            if (quantity > 0) {

                hasItem = true;

                const subtotal =
                        price * quantity;

                total += subtotal;


                html +=
                    '<div class="cart-item">' +

                        '<div class="cart-top">' +

                            '<span>' +
                                escapeHtml(name) +
                            '</span>' +

                            '<span>RM ' +
                                subtotal.toFixed(2) +
                            '</span>' +

                        '</div>' +

                        '<div class="cart-price">' +
                            'RM ' +
                            price.toFixed(2) +
                            ' each' +
                        '</div>' +

                        '<div class="cart-bottom">' +

                            '<div class="quantity-control">' +

                                '<button type="button" ' +
                                    'onclick="changeQuantity(' +
                                    menuId +
                                    ', -1)">−</button>' +

                                '<span class="quantity-value">' +
                                    quantity +
                                '</span>' +

                                '<button type="button" ' +
                                    'onclick="changeQuantity(' +
                                    menuId +
                                    ', 1)">+</button>' +

                            '</div>' +

                            '<button type="button" ' +
                                'class="remove-btn" ' +
                                'onclick="removeItem(' +
                                menuId +
                                ')">' +
                                'Remove' +
                            '</button>' +

                        '</div>' +

                    '</div>';
            }

        });


        if (!hasItem) {

            html =
                '<div class="empty-cart">' +
                    'No items selected.<br>' +
                    'Click + on a menu item to add it.' +
                '</div>';
        }


        cart.innerHTML = html;


        document.getElementById("totalPrice")
                .textContent =
                total.toFixed(2);


        document.getElementById("createButton")
                .disabled =
                !hasItem;


        document.getElementById("clearButton")
                .disabled =
                !hasItem;
    }


    /* =========================================
       CLEAR ORDER
       ========================================= */

    function clearOrder() {

        document.querySelectorAll(
                ".hidden-quantity"
        ).forEach(function(input) {

            input.value = 0;

        });

        updateCart();
    }


    /* =========================================
       CATEGORY FILTER
       ========================================= */

    function selectCategory(category, button) {

        selectedCategory = category;

        document.getElementById("menuSearch")
                .value = "";


        document.querySelectorAll(
                ".category-btn"
        ).forEach(function(btn) {

            btn.classList.remove("active");

        });


        button.classList.add("active");

        filterMenu();
    }


    /* =========================================
       SEARCH + FILTER
       ========================================= */

    function filterMenu() {

        const search =
                document.getElementById("menuSearch")
                        .value
                        .trim()
                        .toLowerCase();


        const cards =
                document.querySelectorAll(".menu-card");


        cards.forEach(function(card) {

            const name =
                    card.dataset.name
                        .toLowerCase();

            const category =
                    card.dataset.category
                        .toLowerCase();


            let show;


            if (search !== "") {

                show =
                    name.includes(search) ||
                    category.includes(search);

            } else {

                show =
                    category ===
                    selectedCategory.toLowerCase();
            }


            card.style.display =
                    show ? "flex" : "none";

        });
    }


    /* =========================================
       VALIDATION
       ========================================= */

    function validateOrder() {

        const quantityInputs =
                document.querySelectorAll(
                        ".hidden-quantity"
                );

        let hasItem = false;


        quantityInputs.forEach(function(input) {

            const quantity =
                    parseInt(input.value);

            if (!isNaN(quantity) &&
                quantity > 0) {

                hasItem = true;
            }

        });


        if (!hasItem) {

            alert(
                "Please select at least one menu item."
            );

            return false;
        }


        return true;
    }


    /* =========================================
       SAFE DISPLAY OF MENU NAME
       ========================================= */

    function escapeHtml(text) {

        const div =
                document.createElement("div");

        div.textContent = text;

        return div.innerHTML;
    }


    /* =========================================
       INITIAL DISPLAY
       ========================================= */

    filterMenu();
    updateCart();

</script>

</body>
</html>