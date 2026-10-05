package com.beancafe.model;

import java.time.LocalDateTime;

public class Report {

    private int reportId;
    private int adminId;
    private int reportMonth;
    private int reportYear;
    private int totalOrders;
    private double totalSales;
    private LocalDateTime generatedAt;

    public Report() {
    }

    public Report(int reportId, int adminId, int reportMonth,
                  int reportYear, int totalOrders, double totalSales,
                  LocalDateTime generatedAt) {

        this.reportId = reportId;
        this.adminId = adminId;
        this.reportMonth = reportMonth;
        this.reportYear = reportYear;
        this.totalOrders = totalOrders;
        this.totalSales = totalSales;
        this.generatedAt = generatedAt;
    }

    public void generateSummary() {
        generatedAt = LocalDateTime.now();
    }

    public int calculateTotalOrders() {
        return totalOrders;
    }

    public double calculateTotalSales() {
        return totalSales;
    }

    public int getReportId() {
        return reportId;
    }

    public void setReportId(int reportId) {
        this.reportId = reportId;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public int getReportMonth() {
        return reportMonth;
    }

    public void setReportMonth(int reportMonth) {
        this.reportMonth = reportMonth;
    }

    public int getReportYear() {
        return reportYear;
    }

    public void setReportYear(int reportYear) {
        this.reportYear = reportYear;
    }

    public int getTotalOrders() {
        return totalOrders;
    }

    public void setTotalOrders(int totalOrders) {
        this.totalOrders = totalOrders;
    }

    public double getTotalSales() {
        return totalSales;
    }

    public void setTotalSales(double totalSales) {
        this.totalSales = totalSales;
    }

    public LocalDateTime getGeneratedAt() {
        return generatedAt;
    }

    public void setGeneratedAt(LocalDateTime generatedAt) {
        this.generatedAt = generatedAt;
    }
}