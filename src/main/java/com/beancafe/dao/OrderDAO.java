package com.beancafe.dao;

import com.beancafe.model.Order;
import com.beancafe.model.OrderItem;
import com.beancafe.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.util.ArrayList;
import java.util.List;

public class OrderDAO implements OrderDAOInterface {

    // ==========================================
    // CREATE - CREATE NEW ORDER
    // ==========================================
    @Override
    public boolean addOrder(Order order) {

        String orderSql
                = "INSERT INTO orders "
                + "(staff_id, order_date, total_price, status) "
                + "VALUES (?, ?, ?, ?)";

        String itemSql
                = "INSERT INTO order_items "
                + "(order_id, menu_id, quantity, subtotal) "
                + "VALUES (?, ?, ?, ?)";

        String historySql
                = "INSERT INTO order_history "
                + "(order_id, status, updated_at) "
                + "VALUES (?, ?, ?)";

        Connection conn = null;

        try {

            conn
                    = DBConnection.getConnection();

            conn.setAutoCommit(false);

            int orderId;

            // ==================================
            // 1. INSERT ORDER
            // ==================================
            try (PreparedStatement orderStmt
                    = conn.prepareStatement(
                            orderSql,
                            PreparedStatement.RETURN_GENERATED_KEYS)) {

                orderStmt.setInt(
                        1,
                        order.getStaffId()
                );

                orderStmt.setTimestamp(
                        2,
                        Timestamp.valueOf(
                                order.getOrderDate()
                        )
                );

                orderStmt.setDouble(
                        3,
                        order.getTotalPrice()
                );

                orderStmt.setString(
                        4,
                        order.getStatus()
                );

                orderStmt.executeUpdate();

                try (ResultSet rs
                        = orderStmt.getGeneratedKeys()) {

                    if (rs.next()) {

                        orderId
                                = rs.getInt(1);

                        order.setOrderId(
                                orderId
                        );

                    } else {

                        conn.rollback();

                        return false;
                    }
                }
            }

            // ==================================
            // 2. INSERT ORDER ITEMS
            // ==================================
            for (OrderItem item
                    : order.getItems()) {

                try (PreparedStatement itemStmt
                        = conn.prepareStatement(
                                itemSql)) {

                    itemStmt.setInt(
                            1,
                            orderId
                    );

                    itemStmt.setInt(
                            2,
                            item.getMenuId()
                    );

                    itemStmt.setInt(
                            3,
                            item.getQuantity()
                    );

                    itemStmt.setDouble(
                            4,
                            item.getSubtotal()
                    );

                    itemStmt.executeUpdate();
                }
            }

            // ==================================
            // 3. INSERT INITIAL ORDER HISTORY
            // ==================================
            try (PreparedStatement historyStmt
                    = conn.prepareStatement(
                            historySql)) {

                historyStmt.setInt(
                        1,
                        orderId
                );

                historyStmt.setString(
                        2,
                        order.getStatus()
                );

                historyStmt.setTimestamp(
                        3,
                        Timestamp.valueOf(
                                order.getOrderDate()
                        )
                );

                historyStmt.executeUpdate();
            }

            conn.commit();

            return true;

        } catch (SQLException e) {

            if (conn != null) {

                try {

                    conn.rollback();

                } catch (SQLException ex) {

                    ex.printStackTrace();
                }
            }

            e.printStackTrace();

            return false;

        } finally {

            if (conn != null) {

                try {

                    conn.setAutoCommit(true);

                    conn.close();

                } catch (SQLException e) {

                    e.printStackTrace();
                }
            }
        }
    }

    // ==========================================
    // READ - GET ALL ORDERS
    // ==========================================
    @Override
    public List<Order> getAllOrders() {

        List<Order> orderList
                = new ArrayList<>();

        String sql
                = "SELECT * FROM orders "
                + "ORDER BY order_id";

        try (Connection conn
                = DBConnection.getConnection(); PreparedStatement stmt
                = conn.prepareStatement(sql); ResultSet rs
                = stmt.executeQuery()) {

            while (rs.next()) {

                Order order
                        = new Order();

                order.setOrderId(
                        rs.getInt("order_id")
                );

                order.setStaffId(
                        rs.getInt("staff_id")
                );

                Timestamp timestamp
                        = rs.getTimestamp(
                                "order_date"
                        );

                if (timestamp != null) {

                    order.setOrderDate(
                            timestamp.toLocalDateTime()
                    );
                }

                order.setTotalPrice(
                        rs.getDouble(
                                "total_price"
                        )
                );

                order.setStatus(
                        rs.getString(
                                "status"
                        )
                );

                orderList.add(
                        order
                );
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return orderList;
    }

    // ==========================================
    // ADMIN - GET ORDERS WITH PAGINATION
    // ORIGINAL METHOD
    // ==========================================
    public List<Order> getOrdersByPage(
            int page,
            int recordsPerPage) {

        List<Order> orderList
                = new ArrayList<>();

        int offset
                = (page - 1)
                * recordsPerPage;

        String sql
                = "SELECT * FROM orders "
                + "ORDER BY order_id DESC "
                + "LIMIT ? OFFSET ?";

        try (Connection conn
                = DBConnection.getConnection(); PreparedStatement stmt
                = conn.prepareStatement(sql)) {

            stmt.setInt(
                    1,
                    recordsPerPage
            );

            stmt.setInt(
                    2,
                    offset
            );

            try (ResultSet rs
                    = stmt.executeQuery()) {

                while (rs.next()) {

                    Order order
                            = new Order();

                    order.setOrderId(
                            rs.getInt(
                                    "order_id"
                            )
                    );

                    order.setStaffId(
                            rs.getInt(
                                    "staff_id"
                            )
                    );

                    Timestamp timestamp
                            = rs.getTimestamp(
                                    "order_date"
                            );

                    if (timestamp != null) {

                        order.setOrderDate(
                                timestamp
                                        .toLocalDateTime()
                        );
                    }

                    order.setTotalPrice(
                            rs.getDouble(
                                    "total_price"
                            )
                    );

                    order.setStatus(
                            rs.getString(
                                    "status"
                            )
                    );

                    orderList.add(
                            order
                    );
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return orderList;
    }

    // ==========================================
    // ADMIN - COUNT ALL ORDERS
    // ORIGINAL METHOD
    // ==========================================
    public int getOrderCount() {

        int totalRecords = 0;

        String sql
                = "SELECT COUNT(*) "
                + "FROM orders";

        try (Connection conn
                = DBConnection.getConnection(); PreparedStatement stmt
                = conn.prepareStatement(sql); ResultSet rs
                = stmt.executeQuery()) {

            if (rs.next()) {

                totalRecords
                        = rs.getInt(1);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return totalRecords;
    }

    // ==========================================
    // ADMIN - FILTER / SEARCH ORDERS
    // WITH PAGINATION
    // ==========================================
    public List<Order> getOrdersByPage(
            int page,
            int recordsPerPage,
            String status,
            Integer searchOrderId) {

        List<Order> orderList
                = new ArrayList<>();

        int offset
                = (page - 1)
                * recordsPerPage;

        StringBuilder sql
                = new StringBuilder(
                        "SELECT * FROM orders "
                        + "WHERE 1=1 "
                );

        boolean filterStatus
                = status != null
                && !status.equalsIgnoreCase(
                        "All"
                );

        // Add status filter
        if (filterStatus) {

            sql.append(
                    "AND status = ? "
            );
        }

        // Add Order ID search
        if (searchOrderId != null) {

            sql.append(
                    "AND order_id = ? "
            );
        }

        sql.append(
                "ORDER BY order_id DESC "
                + "LIMIT ? OFFSET ?"
        );

        try (Connection conn
                = DBConnection.getConnection(); PreparedStatement stmt
                = conn.prepareStatement(
                        sql.toString())) {

            int parameterIndex = 1;

            // Status parameter
            if (filterStatus) {

                stmt.setString(
                        parameterIndex++,
                        status
                );
            }

            // Order ID parameter
            if (searchOrderId != null) {

                stmt.setInt(
                        parameterIndex++,
                        searchOrderId
                );
            }

            // Pagination parameters
            stmt.setInt(
                    parameterIndex++,
                    recordsPerPage
            );

            stmt.setInt(
                    parameterIndex,
                    offset
            );

            try (ResultSet rs
                    = stmt.executeQuery()) {

                while (rs.next()) {

                    Order order
                            = new Order();

                    order.setOrderId(
                            rs.getInt(
                                    "order_id"
                            )
                    );

                    order.setStaffId(
                            rs.getInt(
                                    "staff_id"
                            )
                    );

                    Timestamp timestamp
                            = rs.getTimestamp(
                                    "order_date"
                            );

                    if (timestamp != null) {

                        order.setOrderDate(
                                timestamp
                                        .toLocalDateTime()
                        );
                    }

                    order.setTotalPrice(
                            rs.getDouble(
                                    "total_price"
                            )
                    );

                    order.setStatus(
                            rs.getString(
                                    "status"
                            )
                    );

                    orderList.add(
                            order
                    );
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return orderList;
    }

    // ==========================================
    // ADMIN - COUNT FILTERED ORDERS
    // ==========================================
    public int getOrderCount(
            String status,
            Integer searchOrderId) {

        int totalRecords = 0;

        StringBuilder sql
                = new StringBuilder(
                        "SELECT COUNT(*) "
                        + "FROM orders "
                        + "WHERE 1=1 "
                );

        boolean filterStatus
                = status != null
                && !status.equalsIgnoreCase(
                        "All"
                );

        // Status filter
        if (filterStatus) {

            sql.append(
                    "AND status = ? "
            );
        }

        // Search by Order ID
        if (searchOrderId != null) {

            sql.append(
                    "AND order_id = ? "
            );
        }

        try (Connection conn
                = DBConnection.getConnection(); PreparedStatement stmt
                = conn.prepareStatement(
                        sql.toString())) {

            int parameterIndex = 1;

            if (filterStatus) {

                stmt.setString(
                        parameterIndex++,
                        status
                );
            }

            if (searchOrderId != null) {

                stmt.setInt(
                        parameterIndex,
                        searchOrderId
                );
            }

            try (ResultSet rs
                    = stmt.executeQuery()) {

                if (rs.next()) {

                    totalRecords
                            = rs.getInt(1);
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return totalRecords;
    }

    // ==========================================
    // READ - GET ONE ORDER BY ID
    // ==========================================
    @Override
    public Order getOrderById(
            int orderId) {

        Order order = null;

        String orderSql
                = "SELECT * FROM orders "
                + "WHERE order_id = ?";

        String itemSql
                = "SELECT oi.*, m.menu_name "
                + "FROM order_items oi "
                + "JOIN menu m "
                + "ON oi.menu_id = m.menu_id "
                + "WHERE oi.order_id = ?";

        try (Connection conn
                = DBConnection.getConnection(); PreparedStatement orderStmt
                = conn.prepareStatement(
                        orderSql)) {

            orderStmt.setInt(
                    1,
                    orderId
            );

            try (ResultSet rs
                    = orderStmt.executeQuery()) {

                if (rs.next()) {

                    order
                            = new Order();

                    order.setOrderId(
                            rs.getInt(
                                    "order_id"
                            )
                    );

                    order.setStaffId(
                            rs.getInt(
                                    "staff_id"
                            )
                    );

                    Timestamp timestamp
                            = rs.getTimestamp(
                                    "order_date"
                            );

                    if (timestamp != null) {

                        order.setOrderDate(
                                timestamp
                                        .toLocalDateTime()
                        );
                    }

                    order.setTotalPrice(
                            rs.getDouble(
                                    "total_price"
                            )
                    );

                    order.setStatus(
                            rs.getString(
                                    "status"
                            )
                    );
                }
            }

            // ==================================
            // GET ORDER ITEMS
            // ==================================
            if (order != null) {

                try (PreparedStatement itemStmt
                        = conn.prepareStatement(
                                itemSql)) {

                    itemStmt.setInt(
                            1,
                            orderId
                    );

                    try (ResultSet rs
                            = itemStmt.executeQuery()) {

                        while (rs.next()) {

                            OrderItem item
                                    = new OrderItem();

                            item.setOrderItemId(
                                    rs.getInt(
                                            "order_item_id"
                                    )
                            );

                            item.setOrderId(
                                    rs.getInt(
                                            "order_id"
                                    )
                            );

                            item.setMenuId(
                                    rs.getInt(
                                            "menu_id"
                                    )
                            );

                            item.setMenuName(
                                    rs.getString(
                                            "menu_name"
                                    )
                            );

                            item.setQuantity(
                                    rs.getInt(
                                            "quantity"
                                    )
                            );

                            item.setSubtotal(
                                    rs.getDouble(
                                            "subtotal"
                                    )
                            );

                            order.addItem(
                                    item
                            );
                        }
                    }
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return order;
    }

    // ==========================================
    // UPDATE ORDER STATUS
    // ==========================================
    @Override
    public boolean updateOrderStatus(
            int orderId,
            String status) {

        String orderSql
                = "UPDATE orders "
                + "SET status = ? "
                + "WHERE order_id = ?";

        String historySql
                = "INSERT INTO order_history "
                + "(order_id, status, updated_at) "
                + "VALUES (?, ?, CURRENT_TIMESTAMP)";

        Connection conn = null;

        try {

            conn
                    = DBConnection.getConnection();

            conn.setAutoCommit(false);

            // ==================================
            // UPDATE CURRENT STATUS
            // ==================================
            try (PreparedStatement orderStmt
                    = conn.prepareStatement(
                            orderSql)) {

                orderStmt.setString(
                        1,
                        status
                );

                orderStmt.setInt(
                        2,
                        orderId
                );

                int affectedRows
                        = orderStmt.executeUpdate();

                if (affectedRows == 0) {

                    conn.rollback();

                    return false;
                }
            }

            // ==================================
            // SAVE STATUS HISTORY
            // ==================================
            try (PreparedStatement historyStmt
                    = conn.prepareStatement(
                            historySql)) {

                historyStmt.setInt(
                        1,
                        orderId
                );

                historyStmt.setString(
                        2,
                        status
                );

                historyStmt.executeUpdate();
            }

            conn.commit();

            return true;

        } catch (SQLException e) {

            if (conn != null) {

                try {

                    conn.rollback();

                } catch (SQLException ex) {

                    ex.printStackTrace();
                }
            }

            e.printStackTrace();

            return false;

        } finally {

            if (conn != null) {

                try {

                    conn.setAutoCommit(true);

                    conn.close();

                } catch (SQLException e) {

                    e.printStackTrace();
                }
            }
        }
    }

    // ==========================================
    // DELETE / CANCEL ORDER
    // ==========================================
    @Override
    public boolean cancelOrder(
            int orderId) {

        return updateOrderStatus(
                orderId,
                "Cancelled"
        );
    }
}
