package com.edustand.util;

import org.mindrot.jbcrypt.BCrypt; // Requires the jBcrypt JAR file

/**
 * PasswordUtil handles the secure hashing and verification of user passwords
 * using the Bcrypt algorithm.
 */
public class PasswordUtil {

    /**
     * Hashes a plain-text password using Bcrypt with a generated salt.
     * Use this when REGISTERING a new user or RESETTING a password.
     * * @param plainTextPassword The raw password typed by the user.
     * @return The securely hashed password string.
     */
    public static String hashPassword(String plainTextPassword) {
        // BCrypt.gensalt() generates a random salt to make the hash unique
        return BCrypt.hashpw(plainTextPassword, BCrypt.gensalt());
    }

    /**
     * Checks if a plain-text password matches a stored Bcrypt hash.
     * Use this when a user attempts to LOGIN.
     * * @param plainTextPassword The password typed into the login form.
     * @param hashedPassword The stored hash in the database.
     * @return true if the password matches, false otherwise.
     */
    public static boolean checkPassword(String plainTextPassword, String hashedPassword) {
        // This function automatically extracts the salt from the stored hash 
        // and safely compares it to the plain-text attempt.
        return BCrypt.checkpw(plainTextPassword, hashedPassword);
    }
}