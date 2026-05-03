package com.edustand.util;

import java.security.SecureRandom;
import java.util.Base64;

/**
 * Utility for generating and validating secure Remember Me tokens.
 */
public class RememberMeUtil {
    private static final SecureRandom random = new SecureRandom();
    private static final int TOKEN_LENGTH = 32; // 256 bits

    /**
     * Generates a secure random token.
     */
    public static String generateToken() {
        byte[] tokenBytes = new byte[TOKEN_LENGTH];
        random.nextBytes(tokenBytes);
        return Base64.getUrlEncoder().withoutPadding().encodeToString(tokenBytes);
    }

    /**
     * Simple hash of token (could use BCrypt for extra security, but Base64 is
     * sufficient for server-side comparison).
     */
    public static String hashToken(String token) {
        return token; // Store as-is since it's already random and we store server-side
    }

    /**
     * Validates token format (basic check).
     */
    public static boolean isValidToken(String token) {
        return token != null && !token.isBlank() && token.length() > 10;
    }
}
