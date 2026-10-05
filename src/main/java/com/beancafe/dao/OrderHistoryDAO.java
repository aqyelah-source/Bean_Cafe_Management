package com.beancafe.dao;

import com.beancafe.model.OrderHistory;
import com.beancafe.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class OrderHistoryDAO {

    // ==========================================
    // GET ALL HISTORY
    // ==========================================
    public List<OrderHistory> getAllHistory() {

        List<OrderHistory> historyList = new ArrayList<>();

        String sql
                = "SELECT * FROM order_history "
                + "ORDER BY updated_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {

                historyList.add(mapHistory(rs));
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return historyList;
    }


    // ==========================================
    // GET HISTORY BY ORDER ID
    // ==========================================
    public List<OrderHistory> getHistoryByOrderId(int orderId) {

        List<OrderHistory> historyList = new ArrayList<>();

        String sql
                = "SELECT * FROM order_history "
                + "WHERE order_id = ? "
                + "ORDER BY updated_at DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);

            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {

                    historyList.add(mapHistory(rs));
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return historyList;
    }


    // ==========================================
    // GET HISTORY BY PAGE
    // ==========================================
    public List<OrderHistory> getHistoryByPage(
            int page,
            int recordsPerPage) {

        List<OrderHistory> historyList = new ArrayList<>();

        int offset = (page - 1) * recordsPerPage;

        String sql
                = "SELECT * FROM order_history "
                + "ORDER BY updated_at DESC "
                + "LIMIT ? OFFSET ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, recordsPerPage);
            stmt.setInt(2, offset);

            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {

                    historyList.add(mapHistory(rs));
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return historyList;
    }


    // ==========================================
    // COUNT ALL HISTORY
    // ==========================================
    public int getHistoryCount() {

        int count = 0;

        String sql
                = "SELECT COUNT(*) "
                + "FROM order_history";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {

                count = rs.getInt(1);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return count;
    }


    // ==========================================
    // GET SEARCH RESULT BY PAGE
    // ==========================================
    public List<OrderHistory> getHistoryByOrderIdPage(
            int orderId,
            int page,
            int recordsPerPage) {

        List<OrderHistory> historyList = new ArrayList<>();

        int offset = (page - 1) * recordsPerPage;

        String sql
                = "SELECT * FROM order_history "
                + "WHERE order_id = ? "
                + "ORDER BY updated_at DESC "
                + "LIMIT ? OFFSET ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);
            stmt.setInt(2, recordsPerPage);
            stmt.setInt(3, offset);

            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {

                    historyList.add(mapHistory(rs));
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return historyList;
    }


    // ==========================================
    // COUNT SEARCH RESULT
    // ==========================================
    public int getHistoryCountByOrderId(int orderId) {

        int count = 0;

        String sql
                = "SELECT COUNT(*) "
                + "FROM order_history "
                + "WHERE order_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, orderId);

            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {

                    count = rs.getInt(1);
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return count;
    }


    // ==========================================
    // CONVERT RESULTSET TO ORDER HISTORY OBJECT
    // ==========================================
    private OrderHistory mapHistory(ResultSet rs)
            throws SQLException {

        OrderHistory history = new OrderHistory();

        history.setHistoryId(
                rs.getInt("history_id")
        );

        history.setOrderId(
                rs.getInt("order_id")
        );

        history.setStatus(
                rs.getString("status")
        );

        Timestamp timestamp
                = rs.getTimestamp("updated_at");

        if (timestamp != null) {

            history.setUpdatedAt(
                    timestamp.toLocalDateTime()
            );
        }

        return history;
    }
}