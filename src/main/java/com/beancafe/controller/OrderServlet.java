package com.beancafe.controller;

import com.beancafe.dao.MenuDAO;
import com.beancafe.dao.MenuDAOInterface;
import com.beancafe.dao.OrderDAO;
import com.beancafe.dao.OrderDAOInterface;
import com.beancafe.dao.StaffDAO;

import com.beancafe.model.Menu;
import com.beancafe.model.Order;
import com.beancafe.model.OrderItem;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.List;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {

    private OrderDAOInterface orderDAO;
    private MenuDAOInterface menuDAO;
    private StaffDAO staffDAO;

    @Override
    public void init() {

        orderDAO = new OrderDAO();
        menuDAO = new MenuDAO();
        staffDAO = new StaffDAO();
    }


    // ==========================================
    // HANDLE GET REQUESTS (take date)
    // ==========================================
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // User must be logged in
        if (session == null ||
            session.getAttribute("userId") == null ||
            session.getAttribute("role") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {

            case "add":
                showAddOrderForm(request, response);
                break;

            case "view":
                viewOrder(request, response);
                break;

            case "search":
                searchOrder(request, response);
                break;

            case "cancel":
                cancelOrder(request, response);
                break;

            case "list":
            default:
                listOrders(request, response);
                break;
        }
    }


    // ==========================================
    // HANDLE POST REQUESTS (sent data)
    // ==========================================
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // User must be logged in
        if (session == null ||
            session.getAttribute("userId") == null ||
            session.getAttribute("role") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {

            response.sendRedirect(
                    request.getContextPath() + "/order"
            );
            return;
        }

        switch (action) {

            case "insert":
                insertOrder(request, response);
                break;

            case "updateStatus":
                updateOrderStatus(request, response);
                break;

            case "cancel":
                cancelOrder(request, response);
                break;

            default:
                response.sendRedirect(
                        request.getContextPath() + "/order"
                );
                break;
        }
    }


    // ==========================================
    // READ - DISPLAY ALL ORDERS
    // ==========================================
    private void listOrders(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Order> orderList =
                orderDAO.getAllOrders();

        request.setAttribute(
                "orderList",
                orderList
        );

        // If an order is selected, load its full details
        String openId = request.getParameter("open");

        if (openId != null && !openId.trim().isEmpty()) {

            try {

                int orderId = Integer.parseInt(openId);

                Order selectedOrder =
                        orderDAO.getOrderById(orderId);

                request.setAttribute(
                        "selectedOrder",
                        selectedOrder
                );

            } catch (NumberFormatException e) {

                request.setAttribute(
                        "selectedOrder",
                        null
                );
            }
        }

        request.getRequestDispatcher("/order-list.jsp")
               .forward(request, response);
    }


    // ==========================================
    // SHOW CREATE ORDER FORM
    // ==========================================
    private void showAddOrderForm(HttpServletRequest request,
                                  HttpServletResponse response)
            throws ServletException, IOException {

        // Get all menu items
        List<Menu> menuList =
                menuDAO.getAllMenu();

        request.setAttribute(
                "menuList",
                menuList
        );

        request.getRequestDispatcher("/order-form.jsp")
               .forward(request, response);
    }


    // ==========================================
    // CREATE - INSERT NEW ORDER
    // ==========================================
    private void insertOrder(HttpServletRequest request,
                             HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session =
                request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }


        // Only Staff should create orders
        String role =
                (String) session.getAttribute("role");

        if (!"Staff".equalsIgnoreCase(role)) {

            response.sendRedirect(
                    request.getContextPath() + "/order"
            );
            return;
        }


        try {

            // ==================================
            // 1. GET LOGGED-IN STAFF ID
            // ==================================

            int userId =
                    (Integer) session.getAttribute("userId");

            int staffId =
                    staffDAO.getStaffIdByUserId(userId);

            if (staffId == -1) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/order?action=add&error=staff"
                );
                return;
            }


            // ==================================
            // 2. GET SELECTED MENU ITEMS
            // ==================================

            String[] menuIds =
                    request.getParameterValues("menuId");

            String[] quantities =
                    request.getParameterValues("quantity");


            if (menuIds == null ||
                quantities == null ||
                menuIds.length != quantities.length) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/order?action=add&error=items"
                );
                return;
            }


            // ==================================
            // 3. CREATE ORDER OBJECT
            // ==================================

            Order order = new Order();

            order.setStaffId(staffId);

            order.setOrderDate(
                    LocalDateTime.now()
            );

            order.setStatus("Pending");


            // ==================================
            // 4. CREATE ORDER ITEMS
            // ==================================

            boolean hasItem = false;

            for (int i = 0; i < menuIds.length; i++) {

                int menuId =
                        Integer.parseInt(menuIds[i]);

                int quantity =
                        Integer.parseInt(quantities[i]);


                // Ignore quantity 0
                if (quantity <= 0) {
                    continue;
                }


                // Get actual menu information
                // from database
                Menu menu =
                        menuDAO.getMenuById(menuId);


                if (menu == null) {
                    continue;
                }


                // Only allow available items
                if (!"Available".equalsIgnoreCase(
                        menu.getAvailability())) {

                    continue;
                }


                // Create OrderItem
                OrderItem item =
                        new OrderItem();

                item.setMenuId(menuId);

                item.setQuantity(quantity);


                // Calculate:
                // price × quantity
                item.calculateSubtotal(
                        menu.getPrice()
                );


                // Add item to order
                order.addItem(item);

                hasItem = true;
            }


            // No valid menu selected
            if (!hasItem) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/order?action=add&error=noitem"
                );
                return;
            }


            // ==================================
            // 5. CALCULATE TOTAL PRICE
            // ==================================

            order.calculateTotal();


            // ==================================
            // 6. SAVE ORDER
            // ==================================

            boolean success =
                    orderDAO.addOrder(order);


            if (success) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/order?success=created"
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/order?action=add&error=insert"
                );
            }


        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/order?action=add&error=number"
            );
        }
    }


    // ==========================================
    // READ - VIEW ONE ORDER
    // ==========================================
    private void viewOrder(HttpServletRequest request,
                           HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int orderId =
                    Integer.parseInt(
                            request.getParameter("id")
                    );


            Order order =
                    orderDAO.getOrderById(orderId);


            if (order == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/order?error=notfound"
                );

                return;
            }


            request.setAttribute(
                    "order",
                    order
            );


            request.getRequestDispatcher("/order-view.jsp")
                   .forward(request, response);


        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath() + "/order"
            );
        }
    }


    // ==========================================
    // SEARCH - SEARCH ORDER BY ID
    // ==========================================
    private void searchOrder(HttpServletRequest request,
                             HttpServletResponse response)
            throws ServletException, IOException {

        String searchId =
                request.getParameter("orderId");


        if (searchId == null ||
            searchId.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath() + "/order"
            );

            return;
        }


        try {

            int orderId =
                    Integer.parseInt(searchId);


            Order order =
                    orderDAO.getOrderById(orderId);


            request.setAttribute(
                    "searchedOrder",
                    order
            );

            request.setAttribute(
                    "searchPerformed",
                    true
            );


            request.getRequestDispatcher("/order-list.jsp")
                   .forward(request, response);


        } catch (NumberFormatException e) {

            request.setAttribute(
                    "searchedOrder",
                    null
            );

            request.setAttribute(
                    "searchPerformed",
                    true
            );


            request.getRequestDispatcher("/order-list.jsp")
                   .forward(request, response);
        }
    }


    // ==========================================
    // UPDATE - UPDATE ORDER STATUS
    // ==========================================
    private void updateOrderStatus(HttpServletRequest request, HttpServletResponse response)
         throws IOException {

     try {

         int orderId =
                 Integer.parseInt(
                         request.getParameter("orderId")
                 );

         String status =
                 request.getParameter("status");

         if (status == null ||
             status.trim().isEmpty()) {

             response.sendRedirect(
                     request.getContextPath()
                     + "/order?open="
                     + orderId
             );

             return;
         }

         orderDAO.updateOrderStatus(
                 orderId,
                 status
         );

         // Return to Manage Orders and reopen same drawer
         response.sendRedirect(
                 request.getContextPath()
                 + "/order?open="
                 + orderId
         );

     } catch (NumberFormatException e) {

         response.sendRedirect(
                 request.getContextPath() + "/order"
         );
     }
 }


    // ==========================================
    // DELETE / CANCEL ORDER
    // ==========================================
    private void cancelOrder(HttpServletRequest request,
                             HttpServletResponse response)
            throws IOException {

        try {

            int orderId =
                    Integer.parseInt(
                            request.getParameter("id")
                    );


            orderDAO.cancelOrder(orderId);


        } catch (NumberFormatException e) {

            e.printStackTrace();
        }


        response.sendRedirect(
                request.getContextPath() + "/order"
        );
    }
}
