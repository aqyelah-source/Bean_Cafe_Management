package com.beancafe.dao;

import com.beancafe.model.Order;
import com.beancafe.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.util.ArrayList;
import java.util.List;

public class AdminDashboardDAO {

    // =========================
    // TOTAL STAFF
    // =========================
    public int getTotalStaff() {

        String sql
                = "SELECT COUNT(*) AS total "
                + "FROM staff";

        try (Connection conn
                = DBConnection.getConnection(); PreparedStatement stmt
                = conn.prepareStatement(sql); ResultSet rs
                = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // =========================
    // TOTAL MENU ITEMS
    // =========================
    public int getTotalMenuItems() {

        String sql
                = "SELECT COUNT(*) AS total "
                + "FROM menu";

        try (Connection conn
                = DBConnection.getConnection(); PreparedStatement stmt
                = conn.prepareStatement(sql); ResultSet rs
                = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // =========================
    // TOTAL ORDERS
    // =========================
    public int getTotalOrders() {

        String sql
                = "SELECT COUNT(*) AS total "
                + "FROM orders";

        try (Connection conn
                = DBConnection.getConnection(); PreparedStatement stmt
                = conn.prepareStatement(sql); ResultSet rs
                = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getInt("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0;
    }

    // =========================
    // TOTAL SALES
    // COMPLETED ORDERS ONLY
    // =========================
    public double getTotalSales() {

        String sql
                = "SELECT COALESCE(SUM(total_price), 0) AS total "
                + "FROM orders "
                + "WHERE status = 'Completed'";

        try (Connection conn
                = DBConnection.getConnection(); PreparedStatement stmt
                = conn.prepareStatement(sql); ResultSet rs
                = stmt.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return 0.0;
    }

    // =========================
    // RECENT 5 ORDERS
    // =========================
    public List<Order> getRecentOrders() {

        List<Order> orderList
                = new ArrayList<>();

        String sql
                = "SELECT * FROM orders "
                + "ORDER BY order_date DESC "
                + "LIMIT 5";

        try (Connection conn
                = DBConnection.getConnection(); PreparedStatement stmt
                = conn.prepareStatement(sql); ResultSet rs
                = stmt.executeQuery()) {

            while (rs.next()) {

                Order order
                        = new Order();

                order.setOrderId(
                        rs.getInt("order_id"));

                order.setStaffId(
                        rs.getInt("staff_id"));

                Timestamp orderDate
                        = rs.getTimestamp("order_date");

                if (orderDate != null) {

                    order.setOrderDate(
                            orderDate.toLocalDateTime());
                }

                order.setTotalPrice(
                        rs.getDouble("total_price"));

                order.setStatus(
                        rs.getString("status"));

                orderList.add(order);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderList;
    }
}
