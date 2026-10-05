package com.beancafe.dao;

import com.beancafe.model.Menu;
import com.beancafe.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class MenuDAO implements MenuDAOInterface {


    // =====================================================
    // CREATE - Add new menu
    // =====================================================
    @Override
    public boolean addMenu(Menu menu) {

        String sql =
                "INSERT INTO menu "
                + "(admin_id, menu_name, category, price, availability) "
                + "VALUES (?, ?, ?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, menu.getAdminId());
            stmt.setString(2, menu.getMenuName());
            stmt.setString(3, menu.getCategory());
            stmt.setDouble(4, menu.getPrice());
            stmt.setString(5, menu.getAvailability());

            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }


    // =====================================================
    // READ - Get all menu
    // Latest menu first
    // =====================================================
    @Override
    public List<Menu> getAllMenu() {

        List<Menu> menuList = new ArrayList<>();

        String sql =
                "SELECT * FROM menu "
                + "ORDER BY menu_id DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {

                Menu menu = new Menu();

                menu.setMenuId(rs.getInt("menu_id"));
                menu.setAdminId(rs.getInt("admin_id"));
                menu.setMenuName(rs.getString("menu_name"));
                menu.setCategory(rs.getString("category"));
                menu.setPrice(rs.getDouble("price"));
                menu.setAvailability(
                        rs.getString("availability")
                );

                menuList.add(menu);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return menuList;
    }


    // =====================================================
    // READ - Get menu by category with pagination
    // 5 records per page
    // =====================================================
    public List<Menu> getMenuByPage(
            String category,
            int page,
            int recordsPerPage) {

        List<Menu> menuList = new ArrayList<>();

        int offset =
                (page - 1) * recordsPerPage;

        String sql;

        boolean filterCategory =
                category != null
                && !category.trim().isEmpty()
                && !"All".equalsIgnoreCase(category);


        // If category selected
        if (filterCategory) {

            sql =
                    "SELECT * FROM menu "
                    + "WHERE category = ? "
                    + "ORDER BY menu_id DESC "
                    + "LIMIT ? OFFSET ?";

        } else {

            // All categories
            sql =
                    "SELECT * FROM menu "
                    + "ORDER BY menu_id DESC "
                    + "LIMIT ? OFFSET ?";
        }


        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {


            if (filterCategory) {

                stmt.setString(
                        1,
                        category
                );

                stmt.setInt(
                        2,
                        recordsPerPage
                );

                stmt.setInt(
                        3,
                        offset
                );

            } else {

                stmt.setInt(
                        1,
                        recordsPerPage
                );

                stmt.setInt(
                        2,
                        offset
                );
            }


            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {

                    Menu menu = new Menu();

                    menu.setMenuId(
                            rs.getInt("menu_id")
                    );

                    menu.setAdminId(
                            rs.getInt("admin_id")
                    );

                    menu.setMenuName(
                            rs.getString("menu_name")
                    );

                    menu.setCategory(
                            rs.getString("category")
                    );

                    menu.setPrice(
                            rs.getDouble("price")
                    );

                    menu.setAvailability(
                            rs.getString("availability")
                    );

                    menuList.add(menu);
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return menuList;
    }


    // =====================================================
    // COUNT - Count menu for category pagination
    // =====================================================
    public int getMenuCount(String category) {

        int totalRecords = 0;

        String sql;

        boolean filterCategory =
                category != null
                && !category.trim().isEmpty()
                && !"All".equalsIgnoreCase(category);


        if (filterCategory) {

            sql =
                    "SELECT COUNT(*) FROM menu "
                    + "WHERE category = ?";

        } else {

            sql =
                    "SELECT COUNT(*) FROM menu";
        }


        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            if (filterCategory) {

                stmt.setString(
                        1,
                        category
                );
            }


            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {

                    totalRecords =
                            rs.getInt(1);
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return totalRecords;
    }


    // =====================================================
    // SEARCH - Search menu with pagination
    // Menu name = partial search
    // Category = exact search
    // =====================================================
    public List<Menu> searchMenu(
            String keyword,
            int page,
            int recordsPerPage) {

        List<Menu> menuList =
                new ArrayList<>();

        int offset =
                (page - 1) * recordsPerPage;


        String sql =
                "SELECT * FROM menu "
                + "WHERE LOWER(menu_name) LIKE LOWER(?) "
                + "OR LOWER(category) = LOWER(?) "
                + "ORDER BY menu_id DESC "
                + "LIMIT ? OFFSET ?";


        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {


            String searchKeyword =
                    "%" + keyword + "%";


            // Partial search for menu name
            stmt.setString(
                    1,
                    searchKeyword
            );

            // Exact search for category
            stmt.setString(
                    2,
                    keyword
            );

            stmt.setInt(
                    3,
                    recordsPerPage
            );

            stmt.setInt(
                    4,
                    offset
            );


            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {

                    Menu menu = new Menu();

                    menu.setMenuId(
                            rs.getInt("menu_id")
                    );

                    menu.setAdminId(
                            rs.getInt("admin_id")
                    );

                    menu.setMenuName(
                            rs.getString("menu_name")
                    );

                    menu.setCategory(
                            rs.getString("category")
                    );

                    menu.setPrice(
                            rs.getDouble("price")
                    );

                    menu.setAvailability(
                            rs.getString("availability")
                    );

                    menuList.add(menu);
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return menuList;
    }


    // =====================================================
    // COUNT - Count search results
    // =====================================================
    public int getSearchMenuCount(
            String keyword) {

        int totalRecords = 0;


        String sql =
                "SELECT COUNT(*) FROM menu "
                + "WHERE LOWER(menu_name) LIKE LOWER(?) "
                + "OR LOWER(category) = LOWER(?)";


        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {


            String searchKeyword =
                    "%" + keyword + "%";


            stmt.setString(
                    1,
                    searchKeyword
            );

            stmt.setString(
                    2,
                    keyword
            );


            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {

                    totalRecords =
                            rs.getInt(1);
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return totalRecords;
    }


    // =====================================================
    // READ - Get menu by ID
    // =====================================================
    @Override
    public Menu getMenuById(
            int menuId) {

        String sql =
                "SELECT * FROM menu "
                + "WHERE menu_id = ?";


        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {


            stmt.setInt(
                    1,
                    menuId
            );


            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {

                    Menu menu =
                            new Menu();

                    menu.setMenuId(
                            rs.getInt("menu_id")
                    );

                    menu.setAdminId(
                            rs.getInt("admin_id")
                    );

                    menu.setMenuName(
                            rs.getString("menu_name")
                    );

                    menu.setCategory(
                            rs.getString("category")
                    );

                    menu.setPrice(
                            rs.getDouble("price")
                    );

                    menu.setAvailability(
                            rs.getString("availability")
                    );

                    return menu;
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return null;
    }


    // =====================================================
    // UPDATE - Update menu
    // =====================================================
    @Override
    public boolean updateMenu(
            Menu menu) {

        String sql =
                "UPDATE menu SET "
                + "menu_name = ?, "
                + "category = ?, "
                + "price = ?, "
                + "availability = ? "
                + "WHERE menu_id = ?";


        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {


            stmt.setString(
                    1,
                    menu.getMenuName()
            );

            stmt.setString(
                    2,
                    menu.getCategory()
            );

            stmt.setDouble(
                    3,
                    menu.getPrice()
            );

            stmt.setString(
                    4,
                    menu.getAvailability()
            );

            stmt.setInt(
                    5,
                    menu.getMenuId()
            );


            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }


    // =====================================================
    // DELETE - Delete menu
    // =====================================================
    @Override
    public boolean deleteMenu(
            int menuId) {

        String sql =
                "DELETE FROM menu "
                + "WHERE menu_id = ?";


        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {


            stmt.setInt(
                    1,
                    menuId
            );


            return stmt.executeUpdate() > 0;

        } catch (SQLException e) {

            e.printStackTrace();
            return false;
        }
    }
}