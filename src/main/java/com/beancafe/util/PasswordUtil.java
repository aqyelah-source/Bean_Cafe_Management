package com.beancafe.util;

import org.mindrot.jbcrypt.BCrypt;

/**
 * Handles password hashing and verification using BCrypt.
 * Remember to add the jbcrypt dependency in pom.xml (see notes below).
 */
public class PasswordUtil {

    /**
     * Use this when creating a new user account — hash the plain password
     * before saving it into the database. Never store plain text passwords.
     */
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    }

    /**
     * Use this during login — compares the plain password the user typed
     * against the hashed password stored in the database.
     */
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}
