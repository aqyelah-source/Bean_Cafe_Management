package com.beancafe.controller;

import com.beancafe.dao.AdminDAO;
import com.beancafe.dao.StaffDAO;
import com.beancafe.model.Staff;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet("/admin-staff")
public class StaffServlet extends HttpServlet {

    private StaffDAO staffDAO;

    @Override
    public void init() {
        staffDAO = new StaffDAO();
    }


    // ==========================================
    // HANDLE GET REQUESTS
    // ==========================================
    @Override
    protected void doGet(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ==========================================
        // ADMIN ONLY
        // ==========================================
        if (session == null
                || session.getAttribute("role") == null
                || !"Admin".equalsIgnoreCase(
                        (String) session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        String action = request.getParameter("action");

        if (action == null) {
            action = "list";
        }

        switch (action) {

            // ==================================
            // SHOW ADD STAFF FORM
            // ==================================
            case "add":

                showAddForm(
                        request,
                        response
                );

                break;


            // ==================================
            // SHOW EDIT STAFF FORM
            // ==================================
            case "edit":

                showEditForm(
                        request,
                        response
                );

                break;
                
            // ==================================
            // SHOW RESET PASSWORD FORM
            // ==================================
            case "reset-password":

                showResetPasswordForm(
                        request,
                        response
                );

                break;


            // ==================================
            // SEARCH STAFF
            // ==================================
            case "search":

                searchStaff(
                        request,
                        response
                );

                break;


            // ==================================
            // DELETE STAFF
            // ==================================
            case "delete":

                deleteStaff(
                        request,
                        response
                );

                break;


            // ==================================
            // DISPLAY ALL STAFF
            // ==================================
            case "list":

            default:

                listStaff(
                        request,
                        response
                );

                break;
        }
    }


    // ==========================================
    // HANDLE POST REQUESTS
    // ==========================================
    @Override
    protected void doPost(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);

        // ==========================================
        // ADMIN ONLY
        // ==========================================
        if (session == null
                || session.getAttribute("role") == null
                || !"Admin".equalsIgnoreCase(
                        (String) session.getAttribute("role"))) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        String action = request.getParameter("action");

        if (action == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-staff"
            );

            return;
        }

        switch (action) {

            // ==================================
            // INSERT NEW STAFF
            // ==================================
            case "insert":

                insertStaff(
                        request,
                        response
                );

                break;


            // ==================================
            // UPDATE STAFF
            // ==================================
            case "update":

                updateStaff(
                        request,
                        response
                );

                break;
                
            // ==================================
            // RESET STAFF PASSWORD
            // ==================================
            case "reset-password":

                resetPassword(
                        request,
                        response
                );

                break;


            // ==================================
            // DEFAULT
            // ==================================
            default:

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-staff"
                );

                break;
        }
    }


    // ==========================================
    // READ - DISPLAY ALL STAFF
    // ==========================================
    private void listStaff(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        List<Staff> staffList
                = staffDAO.getAllStaff();

        request.setAttribute(
                "staffList",
                staffList
        );

        request.getRequestDispatcher(
                "/staff-list.jsp"
        ).forward(
                request,
                response
        );
    }


    // ==========================================
    // SHOW ADD STAFF FORM
    // ==========================================
    private void showAddForm(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher(
                "/staff-form.jsp"
        ).forward(
                request,
                response
        );
    }


    // ==========================================
    // SHOW EDIT STAFF FORM
    // ==========================================
    private void showEditForm(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int staffId
                    = Integer.parseInt(
                            request.getParameter("id")
                    );

            Staff staff
                    = staffDAO.getStaffById(
                            staffId
                    );

            // Staff not found
            if (staff == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-staff?error=notfound"
                );

                return;
            }

            request.setAttribute(
                    "staff",
                    staff
            );

            request.getRequestDispatcher(
                    "/staff-form.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-staff"
            );
        }
    }
    
    // ==========================================
    // SHOW RESET PASSWORD FORM
    // ==========================================
    private void showResetPasswordForm(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        try {

            int staffId =
                    Integer.parseInt(
                            request.getParameter("id")
                    );

            Staff staff =
                    staffDAO.getStaffById(staffId);

            if (staff == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-staff?error=notfound"
                );

                return;
            }

            request.setAttribute(
                    "staff",
                    staff
            );

            request.getRequestDispatcher(
                    "/staff-reset-password.jsp"
            ).forward(
                    request,
                    response
            );

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-staff"
            );
        }
    }


    // ==========================================
    // CREATE - INSERT NEW STAFF
    // ==========================================
    private void insertStaff(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        HttpSession session
                = request.getSession(false);

        if (session == null
                || session.getAttribute("userId") == null) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/login.jsp"
            );

            return;
        }

        try {

            // ==================================
            // GET LOGGED-IN ADMIN USER ID
            // ==================================
            int userId
                    = (Integer) session.getAttribute(
                            "userId"
                    );

            // ==================================
            // GET ADMIN ID
            // ==================================
            AdminDAO adminDAO
                    = new AdminDAO();

            int adminId
                    = adminDAO.getAdminIdByUserId(
                            userId
                    );

            // Admin record not found
            if (adminId == -1) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-staff?action=add"
                        + "&error=admin"
                );

                return;
            }

            // ==================================
            // GET FORM DATA
            // ==================================
            String name
                    = request.getParameter(
                            "name"
                    );

            String username
                    = request.getParameter(
                            "username"
                    );

            String password
                    = request.getParameter(
                            "password"
                    );

            String position
                    = request.getParameter(
                            "position"
                    );

            String shift
                    = request.getParameter(
                            "shift"
                    );

            // ==================================
            // BASIC VALIDATION
            // ==================================
            if (name == null
                    || name.trim().isEmpty()
                    || username == null
                    || username.trim().isEmpty()
                    || password == null
                    || password.trim().isEmpty()
                    || position == null
                    || position.trim().isEmpty()
                    || shift == null
                    || shift.trim().isEmpty()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-staff?action=add"
                        + "&error=empty"
                );

                return;
            }

            // ==================================
            // CREATE STAFF OBJECT
            // ==================================
            Staff staff
                    = new Staff();

            staff.setAdminId(
                    adminId
            );

            staff.setName(
                    name.trim()
            );

            staff.setUsername(
                    username.trim()
            );

            staff.setPassword(
                    password
            );

            // Role is always Staff
            staff.setRole(
                    "Staff"
            );

            staff.setPosition(
                    position
            );

            staff.setShift(
                    shift
            );

            // ==================================
            // INSERT STAFF
            // ==================================
            boolean success
                    = staffDAO.addStaff(
                            staff
                    );

            if (success) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-staff?success=added"
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-staff?action=add"
                        + "&error=insert"
                );
            }

        } catch (Exception e) {

            e.printStackTrace();

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-staff?action=add"
                    + "&error=insert"
            );
        }
    }


    // ==========================================
    // UPDATE - UPDATE STAFF
    // ==========================================
    private void updateStaff(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            // ==================================
            // GET FORM DATA
            // ==================================
            int staffId
                    = Integer.parseInt(
                            request.getParameter(
                                    "staffId"
                            )
                    );

            int userId
                    = Integer.parseInt(
                            request.getParameter(
                                    "userId"
                            )
                    );

            String name
                    = request.getParameter(
                            "name"
                    );

            String username
                    = request.getParameter(
                            "username"
                    );

            String position
                    = request.getParameter(
                            "position"
                    );

            String shift
                    = request.getParameter(
                            "shift"
                    );

            // ==================================
            // VALIDATION
            // ==================================
            if (name == null
                    || name.trim().isEmpty()
                    || username == null
                    || username.trim().isEmpty()
                    || position == null
                    || position.trim().isEmpty()
                    || shift == null
                    || shift.trim().isEmpty()) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-staff?action=edit&id="
                        + staffId
                        + "&error=empty"
                );

                return;
            }

            // ==================================
            // GET EXISTING STAFF
            // ==================================
            Staff existingStaff
                    = staffDAO.getStaffById(
                            staffId
                    );

            if (existingStaff == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-staff?error=notfound"
                );

                return;
            }

            // ==================================
            // UPDATE STAFF OBJECT
            // ==================================
            existingStaff.setStaffId(
                    staffId
            );

            existingStaff.setUserId(
                    userId
            );

            existingStaff.setName(
                    name.trim()
            );

            existingStaff.setUsername(
                    username.trim()
            );

            existingStaff.setPosition(
                    position
            );

            existingStaff.setShift(
                    shift
            );

            // ==================================
            // UPDATE DATABASE
            // ==================================
            boolean success
                    = staffDAO.updateStaff(
                            existingStaff
                    );

            if (success) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-staff?success=updated"
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-staff?action=edit&id="
                        + staffId
                        + "&error=update"
                );
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-staff"
            );
        }
    }
    
    // ==========================================
// RESET STAFF PASSWORD
// ==========================================
private void resetPassword(
        HttpServletRequest request,
        HttpServletResponse response)
        throws IOException {

    try {

        // ==================================
        // GET FORM DATA
        // ==================================
        int staffId =
                Integer.parseInt(
                        request.getParameter("staffId")
                );

        int userId =
                Integer.parseInt(
                        request.getParameter("userId")
                );

        String newPassword =
                request.getParameter(
                        "newPassword"
                );

        String confirmPassword =
                request.getParameter(
                        "confirmPassword"
                );


        // ==================================
        // CHECK EMPTY
        // ==================================
        if (newPassword == null
                || newPassword.trim().isEmpty()
                || confirmPassword == null
                || confirmPassword.trim().isEmpty()) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-staff?action=reset-password&id="
                    + staffId
                    + "&error=empty"
            );

            return;
        }


        // ==================================
        // CHECK PASSWORD MATCH
        // ==================================
        if (!newPassword.equals(confirmPassword)) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-staff?action=reset-password&id="
                    + staffId
                    + "&error=mismatch"
            );

            return;
        }


        // ==================================
        // PASSWORD VALIDATION
        // At least 8 characters
        // Must contain letters + numbers
        // ==================================
        if (!newPassword.matches(
                "^(?=.*[A-Za-z])(?=.*[0-9]).{8,}$")) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-staff?action=reset-password&id="
                    + staffId
                    + "&error=invalid"
            );

            return;
        }


        // ==================================
        // VERIFY STAFF EXISTS
        // ==================================
        Staff staff =
                staffDAO.getStaffById(
                        staffId
                );

        if (staff == null
                || staff.getUserId() != userId) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-staff?error=notfound"
            );

            return;
        }


        // ==================================
        // RESET PASSWORD
        // ==================================
                boolean success =
                        staffDAO.resetPassword(
                                userId,
                                newPassword
                        );


                if (success) {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/admin-staff?success=passwordreset"
                    );

                } else {

                    response.sendRedirect(
                            request.getContextPath()
                            + "/admin-staff?action=reset-password&id="
                            + staffId
                            + "&error=reset"
                    );
                }


            } catch (NumberFormatException e) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-staff"
                );
            }
        }

    // ==========================================
    // DELETE - DELETE STAFF
    // ==========================================
    private void deleteStaff(
            HttpServletRequest request,
            HttpServletResponse response)
            throws IOException {

        try {

            int staffId
                    = Integer.parseInt(
                            request.getParameter(
                                    "id"
                            )
                    );

            // ==================================
            // GET STAFF RECORD
            // ==================================
            Staff staff
                    = staffDAO.getStaffById(
                            staffId
                    );

            if (staff == null) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-staff?error=notfound"
                );

                return;
            }

            // ==================================
            // DELETE STAFF + USER ACCOUNT
            // ==================================
            boolean success
                    = staffDAO.deleteStaff(
                            staff.getStaffId(),
                            staff.getUserId()
                    );

            if (success) {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-staff?success=deleted"
                );

            } else {

                response.sendRedirect(
                        request.getContextPath()
                        + "/admin-staff?error=delete"
                );
            }

        } catch (NumberFormatException e) {

            response.sendRedirect(
                    request.getContextPath()
                    + "/admin-staff"
            );
        }
    }


    // ==========================================
    // SEARCH - SEARCH STAFF
    // ==========================================
    private void searchStaff(
            HttpServletRequest request,
            HttpServletResponse response)
            throws ServletException, IOException {

        String keyword
                = request.getParameter(
                        "keyword"
                );

        // If search field is empty,
        // display all staff
        if (keyword == null
                || keyword.trim().isEmpty()) {

            listStaff(
                    request,
                    response
            );

            return;
        }

        List<Staff> staffList
                = staffDAO.searchStaff(
                        keyword.trim()
                );

        request.setAttribute(
                "staffList",
                staffList
        );

        request.setAttribute(
                "keyword",
                keyword.trim()
        );

        request.setAttribute(
                "searchPerformed",
                true
        );

        request.getRequestDispatcher(
                "/staff-list.jsp"
        ).forward(
                request,
                response
        );
    }
}