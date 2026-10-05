package com.beancafe.controller;

import com.beancafe.dao.AdminDAO;
import com.beancafe.dao.MenuDAO;
import com.beancafe.model.Menu;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/menu")
public class MenuServlet extends HttpServlet {

    private MenuDAO menuDAO;

    @Override
    public void init() {
        menuDAO = new MenuDAO();
    }


    // =========================
    // HANDLE GET REQUESTS
    // =========================
    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in and is Admin
        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("role") == null ||
            !"Admin".equalsIgnoreCase(
                    (String) session.getAttribute("role"))) {

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
                showAddForm(request, response);
                break;

            case "edit":
                showEditForm(request, response);
                break;

            case "delete":
                deleteMenu(request, response);
                break;

            case "search":
                searchMenu(request, response);
                break;

            case "list":
            default:
                listMenu(request, response);
                break;
        }
    }


    // =========================
    // HANDLE POST REQUESTS
    // =========================
    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        // Check if user is logged in and is Admin
        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("role") == null ||
            !"Admin".equalsIgnoreCase(
                    (String) session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            response.sendRedirect(
                    request.getContextPath() + "/menu"
            );
            return;
        }

        switch (action) {

            case "insert":
                insertMenu(request, response);
                break;

            case "update":
                updateMenu(request, response);
                break;

            default:
                response.sendRedirect(
                        request.getContextPath() + "/menu"
                );
                break;
        }
    }


    // =========================
    // READ - DISPLAY ALL MENU
    // =========================
    // =========================
// READ - DISPLAY MENU
// FILTER + PAGINATION
// =========================
private void listMenu(HttpServletRequest request,
                      HttpServletResponse response)
        throws ServletException, IOException {

    // Get selected category
    String category = request.getParameter("category");

    if (category == null || category.trim().isEmpty()) {
        category = "All";
    }


    // Get current page
    int currentPage = 1;

    try {

        String pageParam = request.getParameter("page");

        if (pageParam != null) {
            currentPage = Integer.parseInt(pageParam);
        }

        if (currentPage < 1) {
            currentPage = 1;
        }

    } catch (NumberFormatException e) {

        currentPage = 1;
    }


    // Show 5 menu records per page
    int recordsPerPage = 5;


    // Count total records
    int totalRecords =
            menuDAO.getMenuCount(category);


    // Calculate total pages
    int totalPages =
            (int) Math.ceil(
                    (double) totalRecords / recordsPerPage
            );

    if (totalPages < 1) {
        totalPages = 1;
    }


    // Prevent invalid page number
    if (currentPage > totalPages) {
        currentPage = totalPages;
    }


    // Get menu records
    List<Menu> menuList =
            menuDAO.getMenuByPage(
                    category,
                    currentPage,
                    recordsPerPage
            );


            // Send data to JSP
            request.setAttribute(
                    "menuList",
                    menuList
            );

            request.setAttribute(
                    "selectedCategory",
                    category
            );

            request.setAttribute(
                    "currentPage",
                    currentPage
            );

            request.setAttribute(
                    "totalPages",
                    totalPages
            );

            request.setAttribute(
                    "totalRecords",
                    totalRecords
            );


            request.getRequestDispatcher(
                    "/menu-list.jsp"
            ).forward(
                    request,
                    response
            );
        }
        
        // =========================
        // SEARCH MENU
        // =========================
        private void searchMenu(
                HttpServletRequest request,
                HttpServletResponse response)
                throws ServletException, IOException {

            String keyword = request.getParameter("keyword");

            if (keyword == null) {
                keyword = "";
            }

            keyword = keyword.trim();


            int currentPage = 1;
            int recordsPerPage = 5;

            try {

                String pageParam = request.getParameter("page");

                if (pageParam != null) {
                    currentPage = Integer.parseInt(pageParam);
                }

                if (currentPage < 1) {
                    currentPage = 1;
                }

            } catch (NumberFormatException e) {
                currentPage = 1;
            }


            int totalRecords =
                    menuDAO.getSearchMenuCount(keyword);

            int totalPages =
                    (int) Math.ceil(
                            (double) totalRecords / recordsPerPage
                    );

            if (totalPages < 1) {
                totalPages = 1;
            }

            if (currentPage > totalPages) {
                currentPage = totalPages;
            }


            List<Menu> menuList =
                    menuDAO.searchMenu(
                            keyword,
                            currentPage,
                            recordsPerPage
                    );


            request.setAttribute(
                    "menuList",
                    menuList
            );

            request.setAttribute(
                    "currentPage",
                    currentPage
            );

            request.setAttribute(
                    "totalPages",
                    totalPages
            );

            request.setAttribute(
                    "totalRecords",
                    totalRecords
            );

            request.setAttribute(
                    "searchMode",
                    true
            );

            request.setAttribute(
                    "searchKeyword",
                    keyword
            );


            request.getRequestDispatcher(
                    "/menu-list.jsp"
            ).forward(
                    request,
                    response
            );
        }

    // =========================
    // SHOW ADD MENU FORM
    // =========================
    private void showAddForm(HttpServletRequest request,
                             HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/menu-form.jsp")
               .forward(request, response);
    }


    // =========================
    // SHOW EDIT MENU FORM
    // =========================
    private void showEditForm(HttpServletRequest request,
                              HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int menuId = Integer.parseInt(
                    request.getParameter("id")
            );

            Menu selectedMenu = null;

            List<Menu> menuList = menuDAO.getAllMenu();

            for (Menu menu : menuList) {

                if (menu.getMenuId() == menuId) {
                    selectedMenu = menu;
                    break;
                }
            }

            // If menu does not exist
            if (selectedMenu == null) {

                response.sendRedirect(
                        request.getContextPath() + "/menu"
                );
                return;
            }

            request.setAttribute(
                    "menu",
                    selectedMenu
            );

            request.getRequestDispatcher("/menu-form.jsp")
                   .forward(request, response);

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath() + "/menu"
            );
        }
    }


    // =========================
    // CREATE - INSERT NEW MENU
    // =========================
    private void insertMenu(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {

        HttpSession session = request.getSession(false);

        if (session == null ||
            session.getAttribute("userId") == null) {

            response.sendRedirect(
                    request.getContextPath() + "/login.jsp"
            );
            return;
        }

        try {

            // Get logged-in user's ID
            int userId =
                    (Integer) session.getAttribute("userId");

            // Find the admin_id connected to user_id
            AdminDAO adminDAO = new AdminDAO();

            int adminId =
                    adminDAO.getAdminIdByUserId(userId);

            // Admin record not found
            if (adminId == -1) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/menu?action=add&error=admin"
                );
                return;
            }

            // Get form information
            String menuName =
                    request.getParameter("menuName");

            String category =
                    request.getParameter("category");

            double price =
                    Double.parseDouble(
                            request.getParameter("price")
                    );

            String availability =
                    request.getParameter("availability");


            // Create Menu object
            Menu menu = new Menu();

            menu.setAdminId(adminId);
            menu.setMenuName(menuName);
            menu.setCategory(category);
            menu.setPrice(price);
            menu.setAvailability(availability);


            // Insert into database
            boolean success =
                    menuDAO.addMenu(menu);


            if (success) {

                response.sendRedirect(
                        request.getContextPath() + "/menu"
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/menu?action=add&error=insert"
                );
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/menu?action=add&error=price"
            );
        }
    }


    // =========================
    // UPDATE - UPDATE MENU
    // =========================
    private void updateMenu(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {

        try {

            int menuId =
                    Integer.parseInt(
                            request.getParameter("menuId")
                    );

            String menuName =
                    request.getParameter("menuName");

            String category =
                    request.getParameter("category");

            double price =
                    Double.parseDouble(
                            request.getParameter("price")
                    );

            String availability =
                    request.getParameter("availability");


            // Create Menu object
            Menu menu = new Menu();

            menu.setMenuId(menuId);
            menu.setMenuName(menuName);
            menu.setCategory(category);
            menu.setPrice(price);
            menu.setAvailability(availability);


            // Update database
            menuDAO.updateMenu(menu);


            response.sendRedirect(
                    request.getContextPath() + "/menu"
            );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath() + "/menu"
            );
        }
    }


    // =========================
    // DELETE - DELETE MENU
    // =========================
    private void deleteMenu(HttpServletRequest request,
                            HttpServletResponse response)
            throws IOException {

        try {

            int menuId =
                    Integer.parseInt(
                            request.getParameter("id")
                    );

            menuDAO.deleteMenu(menuId);

        } catch (NumberFormatException e) {

            e.printStackTrace();
        }

        response.sendRedirect(
                request.getContextPath() + "/menu"
        );
    }
}
