package com.beancafe.model;

public class Admin extends User {

    private int adminId;

    public Admin() {
    }

    public Admin(int adminId, int userId, String name,
                 String username, String password, String role) {

        super(userId, name, username, password, role);
        this.adminId = adminId;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }
}