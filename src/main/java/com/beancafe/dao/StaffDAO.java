package com.beancafe.dao;

import com.beancafe.model.Staff;
import com.beancafe.util.DBConnection;
import com.beancafe.util.PasswordUtil;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import java.util.ArrayList;
import java.util.List;

public class StaffDAO {


    // ==========================================
    // READ - Get all staff
    // ==========================================
    public List<Staff> getAllStaff() {

        List<Staff> staffList = new ArrayList<>();

        String sql =
                "SELECT s.staff_id, s.admin_id, s.position, s.shift, "
              + "u.user_id, u.name, u.username, u.password, u.role "
              + "FROM staff s "
              + "JOIN user u ON s.user_id = u.user_id "
              + "ORDER BY s.staff_id";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            while (rs.next()) {

                Staff staff = new Staff();

                staff.setStaffId(rs.getInt("staff_id"));
                staff.setAdminId(rs.getInt("admin_id"));
                staff.setUserId(rs.getInt("user_id"));
                staff.setName(rs.getString("name"));
                staff.setUsername(rs.getString("username"));
                staff.setPassword(rs.getString("password"));
                staff.setRole(rs.getString("role"));
                staff.setPosition(rs.getString("position"));
                staff.setShift(rs.getString("shift"));

                staffList.add(staff);
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return staffList;
    }


    // ==========================================
    // READ - Get staff by staff ID
    // ==========================================
    public Staff getStaffById(int staffId) {

        Staff staff = null;

        String sql =
                "SELECT s.staff_id, s.admin_id, s.position, s.shift, "
              + "u.user_id, u.name, u.username, u.password, u.role "
              + "FROM staff s "
              + "JOIN user u ON s.user_id = u.user_id "
              + "WHERE s.staff_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, staffId);

            try (ResultSet rs = stmt.executeQuery()) {

                if (rs.next()) {

                    staff = new Staff();

                    staff.setStaffId(rs.getInt("staff_id"));
                    staff.setAdminId(rs.getInt("admin_id"));
                    staff.setUserId(rs.getInt("user_id"));
                    staff.setName(rs.getString("name"));
                    staff.setUsername(rs.getString("username"));
                    staff.setPassword(rs.getString("password"));
                    staff.setRole(rs.getString("role"));
                    staff.setPosition(rs.getString("position"));
                    staff.setShift(rs.getString("shift"));
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return staff;
    }


    // ==========================================
    // SEARCH - Search staff
    // ==========================================
    public List<Staff> searchStaff(String keyword) {

        List<Staff> staffList = new ArrayList<>();

        String sql =
                "SELECT s.staff_id, s.admin_id, s.position, s.shift, "
              + "u.user_id, u.name, u.username, u.password, u.role "
              + "FROM staff s "
              + "JOIN user u ON s.user_id = u.user_id "
              + "WHERE u.name LIKE ? "
              + "OR u.username LIKE ? "
              + "OR s.position LIKE ? "
              + "OR s.shift LIKE ? "
              + "ORDER BY s.staff_id";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            String searchKeyword = "%" + keyword + "%";

            stmt.setString(1, searchKeyword);
            stmt.setString(2, searchKeyword);
            stmt.setString(3, searchKeyword);
            stmt.setString(4, searchKeyword);

            try (ResultSet rs = stmt.executeQuery()) {

                while (rs.next()) {

                    Staff staff = new Staff();

                    staff.setStaffId(rs.getInt("staff_id"));
                    staff.setAdminId(rs.getInt("admin_id"));
                    staff.setUserId(rs.getInt("user_id"));
                    staff.setName(rs.getString("name"));
                    staff.setUsername(rs.getString("username"));
                    staff.setPassword(rs.getString("password"));
                    staff.setRole(rs.getString("role"));
                    staff.setPosition(rs.getString("position"));
                    staff.setShift(rs.getString("shift"));

                    staffList.add(staff);
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }

        return staffList;
    }


    // ==========================================
    // CREATE - Add new staff
    // ==========================================
    public boolean addStaff(Staff staff) {

        String userSql =
                "INSERT INTO user "
              + "(name, username, password, role) "
              + "VALUES (?, ?, ?, ?)";

        String staffSql =
                "INSERT INTO staff "
              + "(user_id, admin_id, position, shift) "
              + "VALUES (?, ?, ?, ?)";

        Connection conn = null;

        try {

            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);

            int userId;


            // ======================================
            // Insert into USER table
            // ======================================
            try (PreparedStatement userStmt =
                    conn.prepareStatement(
                            userSql,
                            PreparedStatement.RETURN_GENERATED_KEYS)) {

                userStmt.setString(1, staff.getName());
                userStmt.setString(2, staff.getUsername());

                String hashedPassword =
                        PasswordUtil.hashPassword(staff.getPassword());

                userStmt.setString(3, hashedPassword);
                userStmt.setString(4, staff.getRole());

                userStmt.executeUpdate();


                // Get generated user_id
                try (ResultSet rs =
                        userStmt.getGeneratedKeys()) {

                    if (rs.next()) {

                        userId = rs.getInt(1);

                        staff.setUserId(userId);

                    } else {

                        conn.rollback();
                        return false;
                    }
                }
            }


            // ======================================
            // Insert into STAFF table
            // ======================================
            try (PreparedStatement staffStmt =
                    conn.prepareStatement(staffSql)) {

                staffStmt.setInt(
                        1,
                        userId
                );

                staffStmt.setInt(
                        2,
                        staff.getAdminId()
                );

                staffStmt.setString(
                        3,
                        staff.getPosition()
                );

                staffStmt.setString(
                        4,
                        staff.getShift()
                );

                staffStmt.executeUpdate();
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
    // UPDATE - Update staff
    // ==========================================
    public boolean updateStaff(Staff staff) {

        String userSql =
                "UPDATE user "
              + "SET name = ?, username = ? "
              + "WHERE user_id = ?";

        String staffSql =
                "UPDATE staff "
              + "SET position = ?, shift = ? "
              + "WHERE staff_id = ?";

        Connection conn = null;

        try {

            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);


            // ======================================
            // Update USER table
            // ======================================
            try (PreparedStatement userStmt =
                    conn.prepareStatement(userSql)) {

                userStmt.setString(
                        1,
                        staff.getName()
                );

                userStmt.setString(
                        2,
                        staff.getUsername()
                );

                userStmt.setInt(
                        3,
                        staff.getUserId()
                );

                userStmt.executeUpdate();
            }


            // ======================================
            // Update STAFF table
            // ======================================
            try (PreparedStatement staffStmt =
                    conn.prepareStatement(staffSql)) {

                staffStmt.setString(
                        1,
                        staff.getPosition()
                );

                staffStmt.setString(
                        2,
                        staff.getShift()
                );

                staffStmt.setInt(
                        3,
                        staff.getStaffId()
                );

                staffStmt.executeUpdate();
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
    // RESET - Reset staff password
    // ==========================================
    public boolean resetPassword(
            int userId,
            String newPassword) {

        String sql =
                "UPDATE user "
                + "SET password = ? "
                + "WHERE user_id = ?";

        try (Connection conn =
                DBConnection.getConnection();

             PreparedStatement stmt =
                conn.prepareStatement(sql)) {

            // Hash new password before saving
            String hashedPassword =
                    PasswordUtil.hashPassword(
                            newPassword
                    );

            stmt.setString(
                    1,
                    hashedPassword
            );

            stmt.setInt(
                    2,
                    userId
            );

            int rowsUpdated =
                    stmt.executeUpdate();

            return rowsUpdated > 0;

        } catch (SQLException e) {

            e.printStackTrace();

            return false;
        }
    }


    // ==========================================
    // DELETE - Delete staff
    // ==========================================
    public boolean deleteStaff(
            int staffId,
            int userId) {

        String staffSql =
                "DELETE FROM staff "
              + "WHERE staff_id = ?";

        String userSql =
                "DELETE FROM user "
              + "WHERE user_id = ?";

        Connection conn = null;

        try {

            conn = DBConnection.getConnection();
            conn.setAutoCommit(false);


            // ======================================
            // Delete from STAFF table first
            // ======================================
            try (PreparedStatement staffStmt =
                    conn.prepareStatement(staffSql)) {

                staffStmt.setInt(
                        1,
                        staffId
                );

                staffStmt.executeUpdate();
            }


            // ======================================
            // Delete from USER table
            // ======================================
            try (PreparedStatement userStmt =
                    conn.prepareStatement(userSql)) {

                userStmt.setInt(
                        1,
                        userId
                );

                userStmt.executeUpdate();
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
    // Get staff_id using logged-in user's user_id
    // ==========================================
    public int getStaffIdByUserId(int userId) {

        String sql =
                "SELECT staff_id "
              + "FROM staff "
              + "WHERE user_id = ?";

        try (Connection conn =
                DBConnection.getConnection();

             PreparedStatement stmt =
                conn.prepareStatement(sql)) {

            stmt.setInt(
                    1,
                    userId
            );


            try (ResultSet rs =
                    stmt.executeQuery()) {

                if (rs.next()) {

                    return rs.getInt(
                            "staff_id"
                    );
                }
            }

        } catch (SQLException e) {

            e.printStackTrace();
        }


        // Staff account was not found
        return -1;
    }
}