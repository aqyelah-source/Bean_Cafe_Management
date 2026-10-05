package com.beancafe.model;

import java.time.LocalDateTime;

public class OrderHistory {

    private int historyId;
    private int orderId;
    private String status;
    private LocalDateTime updatedAt;

    public OrderHistory() {
    }

    public OrderHistory(int historyId, int orderId,
                        String status, LocalDateTime updatedAt) {
        this.historyId = historyId;
        this.orderId = orderId;
        this.status = status;
        this.updatedAt = updatedAt;
    }

    public void recordStatus(String status) {
        this.status = status;
        this.updatedAt = LocalDateTime.now();
    }

    public int getHistoryId() {
        return historyId;
    }

    public void setHistoryId(int historyId) {
        this.historyId = historyId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public LocalDateTime getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(LocalDateTime updatedAt) {
        this.updatedAt = updatedAt;
    }
}