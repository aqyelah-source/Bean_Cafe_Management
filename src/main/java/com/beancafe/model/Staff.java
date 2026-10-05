package com.beancafe.model;

public class Staff extends User {

    private int staffId;
    private int adminId;
    private String position;
    private String shift;

    public Staff() {
    }

    public Staff(int staffId, int userId, int adminId,
                 String name, String username, String password,
                 String role, String position, String shift) {

        super(userId, name, username, password, role);
        this.staffId = staffId;
        this.adminId = adminId;
        this.position = position;
        this.shift = shift;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public int getAdminId() {
        return adminId;
    }

    public void setAdminId(int adminId) {
        this.adminId = adminId;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }

    public String getShift() {
        return shift;
    }

    public void setShift(String shift) {
        this.shift = shift;
    }
}