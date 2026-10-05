package com.beancafe.dao;

import com.beancafe.model.Order;
import com.beancafe.model.Report;
import com.beancafe.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Timestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ReportDAO {

    // =========================
    // GENERATE REPORT SUMMARY
    // =========================
    public Report generateMonthlyReport(
            int adminId,
            int month,
            int year) {

        String sql;

        if (month == 0) {

            // All months in selected year
            sql = "SELECT "
                    + "COUNT(*) AS total_orders, "
                    + "COALESCE(SUM(CASE "
                    + "WHEN status = 'Completed' "
                    + "THEN total_price "
                    + "ELSE 0 END), 0) "
                    + "AS total_sales "
                    + "FROM orders "
                    + "WHERE YEAR(order_date) = ?";

        } else {

            // Selected month and year
            sql = "SELECT "
                    + "COUNT(*) AS total_orders, "
                    + "COALESCE(SUM(CASE "
                    + "WHEN status = 'Completed' "
                    + "THEN total_price "
                    + "ELSE 0 END), 0) "
                    + "AS total_sales "
                    + "FROM orders "
                    + "WHERE MONTH(order_date) = ? "
                    + "AND YEAR(order_date) = ?";
        }

        Report report
                = new Report();

        try (Connection conn
                = DBConnection.getConnection(); PreparedStatement stmt
                = conn.prepareStatement(sql)) {

            if (month == 0) {

                stmt.setInt(
                        1,
                        year);

            } else {

                stmt.setInt(
                        1,
                        month);

                stmt.setInt(
                        2,
                        year);
            }

            try (ResultSet rs
                    = stmt.executeQuery()) {

                if (rs.next()) {

                    report.setAdminId(
                            adminId);

                    report.setReportMonth(
                            month);

                    report.setReportYear(
                            year);

                    report.setTotalOrders(
                            rs.getInt(
                                    "total_orders"));

                    report.setTotalSales(
                            rs.getDouble(
                                    "total_sales"));

                    report.setGeneratedAt(
                            LocalDateTime.now());
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return report;
    }

    // =========================
    // MONTHLY SALES FOR GRAPH
    // =========================
    public Map<Integer, Double>
            getMonthlySalesByYear(
                    int year) {

        Map<Integer, Double> salesByMonth
                = new LinkedHashMap<>();

        // January until December
        for (int month = 1;
                month <= 12;
                month++) {

            salesByMonth.put(
                    month,
                    0.0);
        }

        String sql
                = "SELECT "
                + "MONTH(order_date) AS sales_month, "
                + "COALESCE(SUM(total_price), 0) "
                + "AS total_sales "
                + "FROM orders "
                + "WHERE YEAR(order_date) = ? "
                + "AND status = 'Completed' "
                + "GROUP BY MONTH(order_date) "
                + "ORDER BY MONTH(order_date)";

        try (Connection conn
                = DBConnection.getConnection(); PreparedStatement stmt
                = conn.prepareStatement(sql)) {

            stmt.setInt(
                    1,
                    year);

            try (ResultSet rs
                    = stmt.executeQuery()) {

                while (rs.next()) {

                    int month
                            = rs.getInt(
                                    "sales_month");

                    double sales
                            = rs.getDouble(
                                    "total_sales");

                    salesByMonth.put(
                            month,
                            sales);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return salesByMonth;
    }

    // =========================
    // ORDER SUMMARY
    // =========================
    public List<Order> getOrdersForReport(
            int month,
            int year) {

        List<Order> orderList
                = new ArrayList<>();

        String sql;

        if (month == 0) {

            sql = "SELECT * FROM orders "
                    + "WHERE YEAR(order_date) = ? "
                    + "ORDER BY order_date DESC";

        } else {

            sql = "SELECT * FROM orders "
                    + "WHERE MONTH(order_date) = ? "
                    + "AND YEAR(order_date) = ? "
                    + "ORDER BY order_date DESC";
        }

        try (Connection conn
                = DBConnection.getConnection(); PreparedStatement stmt
                = conn.prepareStatement(sql)) {

            if (month == 0) {

                stmt.setInt(
                        1,
                        year);

            } else {

                stmt.setInt(
                        1,
                        month);

                stmt.setInt(
                        2,
                        year);
            }

            try (ResultSet rs
                    = stmt.executeQuery()) {

                while (rs.next()) {

                    Order order
                            = new Order();

                    order.setOrderId(
                            rs.getInt(
                                    "order_id"));

                    order.setStaffId(
                            rs.getInt(
                                    "staff_id"));

                    Timestamp orderDate
                            = rs.getTimestamp(
                                    "order_date");

                    if (orderDate != null) {

                        order.setOrderDate(
                                orderDate
                                        .toLocalDateTime());
                    }

                    order.setTotalPrice(
                            rs.getDouble(
                                    "total_price"));

                    order.setStatus(
                            rs.getString(
                                    "status"));

                    orderList.add(
                            order);
                }
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return orderList;
    }
}
