package com.edustand.util;

import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;

/**
 * QueryUtil — Reusable server-side SQL query helpers.
 *
 * Provides safe, validated helpers for sorting and searching so that
 * user-supplied parameters are NEVER injected directly into SQL.
 *
 * Usage:
 *   String col = QueryUtil.safeSortColumn(req.getParameter("sort"), "created_at", "full_name", "email", "created_at");
 *   String dir = QueryUtil.safeDirection(req.getParameter("dir"));
 *   String q   = QueryUtil.likeWrap(req.getParameter("q"));
 *   // then: "... ORDER BY " + col + " " + dir + " WHERE full_name LIKE ?"
 */
public class QueryUtil {

    /**
     * Returns a validated column name from a whitelist.
     *
     * @param param      The user-supplied sort column name (may be null/unsafe).
     * @param defaultCol The column to use if param is not in the whitelist.
     * @param allowed    Varargs list of allowed column names.
     * @return A safe column name guaranteed to be in the whitelist.
     */
    public static String safeSortColumn(String param, String defaultCol, String... allowed) {
        if (param == null || param.isBlank()) return defaultCol;
        Set<String> whitelist = new HashSet<>(Arrays.asList(allowed));
        String clean = param.trim().toLowerCase();
        return whitelist.contains(clean) ? clean : defaultCol;
    }

    /**
     * Returns "ASC" or "DESC" safely, ignoring any other input.
     *
     * @param param The user-supplied direction parameter.
     * @return "ASC" or "DESC" — never anything else.
     */
    public static String safeDirection(String param) {
        if ("asc".equalsIgnoreCase(param)) return "ASC";
        return "DESC"; // default to DESC (newest first)
    }

    /**
     * Wraps a search term in SQL LIKE wildcards and escapes special LIKE chars.
     * Use this as a PreparedStatement parameter, not directly in the SQL string.
     *
     * @param term The user-supplied search term (may be null).
     * @return A LIKE-safe string like "%search_term%" or null if term is blank.
     */
    public static String likeWrap(String term) {
        if (term == null || term.isBlank()) return null;
        String escaped = term.trim()
                .replace("\\", "\\\\")
                .replace("%", "\\%")
                .replace("_", "\\_");
        return "%" + escaped + "%";
    }

    /**
     * Parses an integer page number from a request parameter.
     *
     * @param param        The raw string parameter value.
     * @param defaultPage  The default page to return if parsing fails.
     * @return A valid page number (>= 1).
     */
    public static int parsePage(String param, int defaultPage) {
        try {
            int page = Integer.parseInt(param);
            return Math.max(1, page);
        } catch (Exception e) {
            return Math.max(1, defaultPage);
        }
    }

    /**
     * Parses a page size from a request parameter, clamped to a max.
     *
     * @param param       The raw string parameter value.
     * @param defaultSize The default page size.
     * @param maxSize     The maximum allowed page size.
     * @return A valid page size.
     */
    public static int parsePageSize(String param, int defaultSize, int maxSize) {
        try {
            int size = Integer.parseInt(param);
            return Math.min(Math.max(1, size), maxSize);
        } catch (Exception e) {
            return defaultSize;
        }
    }

    /**
     * Calculates the SQL OFFSET for pagination.
     *
     * @param page     Current page number (1-indexed).
     * @param pageSize Number of records per page.
     * @return SQL OFFSET value.
     */
    public static int offset(int page, int pageSize) {
        return (page - 1) * pageSize;
    }

    /**
     * Calculates the total number of pages.
     *
     * @param totalRecords Total count of records.
     * @param pageSize     Records per page.
     * @return Total page count.
     */
    public static int totalPages(int totalRecords, int pageSize) {
        if (pageSize <= 0) return 1;
        return (int) Math.ceil((double) totalRecords / pageSize);
    }
}
