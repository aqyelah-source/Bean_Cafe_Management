package com.beancafe.model;

public class Menu {

    private int menuId;
    private int adminId;
    private String menuName;
    private String category;
    private double price;
    private String availability;

    public Menu() {
    }

    public Menu(int menuId, int adminId, String menuName,
                String category, double price, String availability) {

        this.menuId = menuId;
        this.adminId = adminId;
        this.menuName = menuName;
        this.category = category;
        this.price = price;
        this.availability = availability;
    }

    public int getMenuId() {
        return menuId;
    }

    public void setMenuId(int menuId) {
        this.menuId = menuId;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getMenuName() {
        return menuName;
    }

    public void setMenuName(String menuName) {
        this.menuName = menuName;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public String getAvailability() {
        return availability;
    }

    public void setAvailability(String availability) {
        this.availability = availability;
    }
}