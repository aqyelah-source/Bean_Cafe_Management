package com.beancafe.model;

public class OrderItem {

    private int orderItemId;
    private int orderId;
    private int menuId;
    private String menuName;
    private int quantity;
    private double subtotal;

    public OrderItem() {
    }

    public OrderItem(int orderItemId, int orderId, int menuId,
                     int quantity, double subtotal) {
        this.orderItemId = orderItemId;
        this.orderId = orderId;
        this.menuId = menuId;
        this.quantity = quantity;
        this.subtotal = subtotal;
    }

    public double calculateSubtotal(double price) {
        subtotal = price * quantity;
        return subtotal;
    }

    public void updateQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getOrderItemId() {
        return orderItemId;
    }

    public void setOrderItemId(int orderItemId) {
        this.orderItemId = orderItemId;
    }

    public int getOrderId() {
        return orderId;
    }

    public void setOrderId(int orderId) {
        this.orderId = orderId;
    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public String getMenuName() {
        return menuName;
    }

    public void setMenuName(String menuName) {
        this.menuName = menuName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getSubtotal() {
        return subtotal;
    }

    public void setSubtotal(double subtotal) {
        this.subtotal = subtotal;
    }
}