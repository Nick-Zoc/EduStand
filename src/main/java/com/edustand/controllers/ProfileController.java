package com.edustand.controllers;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.time.Instant;

import com.edustand.model.UserModel;
import com.edustand.service.ActivityLogService;
import com.edustand.service.AdminService;
import com.edustand.service.ProfileService;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

@WebServlet(asyncSupported = true, urlPatterns = { "/profile" })
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 100, maxRequestSize = 1024 * 1024
        * 200)
public class ProfileController extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final ProfileService profileService = new ProfileService();
    private final AdminService adminService = new AdminService();
    private final ActivityLogService activityLogService = new ActivityLogService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserModel loggedInUser = resolveLoggedInUser(req, resp);
        if (loggedInUser == null) {
            return;
        }

        UserModel profileUser = profileService.getProfileById(loggedInUser.getUserId());
        if (profileUser == null) {
            profileUser = loggedInUser;
        }

        req.setAttribute("activeSidebar", "profile");
        req.setAttribute("profileUser", profileUser);
        req.setAttribute("userName", profileUser.getFullName());
        req.setAttribute("userRole", profileUser.getRole());
        req.getRequestDispatcher("/WEB-INF/pages/profile/profile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        UserModel loggedInUser = resolveLoggedInUser(req, resp);
        if (loggedInUser == null) {
            return;
        }

        String fullName = trim(req.getParameter("fullName"));
        String email = trim(req.getParameter("email"));
        String phoneNumber = trim(req.getParameter("phoneNumber"));
        String address = trim(req.getParameter("address"));

        if (fullName.isBlank() || email.isBlank()) {
            req.setAttribute("error", "Full name and email are required.");
            doGet(req, resp);
            return;
        }

        if (adminService.emailExistsForOtherUser(email, loggedInUser.getUserId())) {
            req.setAttribute("error", "That email is already used by another account.");
            doGet(req, resp);
            return;
        }

        UserModel currentProfile = profileService.getProfileById(loggedInUser.getUserId());
        if (currentProfile == null) {
            currentProfile = loggedInUser;
        }

        String profilePicturePath = currentProfile.getProfilePicturePath();
        Part profilePicturePart = req.getPart("profilePicture");
        if (profilePicturePart != null && profilePicturePart.getSize() > 0) {
            profilePicturePath = storeProfilePicture(req, loggedInUser.getUserId(), profilePicturePart);
        }

        UserModel updatedUser = new UserModel();
        updatedUser.setUserId(loggedInUser.getUserId());
        updatedUser.setFullName(fullName);
        updatedUser.setEmail(email);
        updatedUser.setPhoneNumber(phoneNumber);
        updatedUser.setAddress(address);
        updatedUser.setProfilePicturePath(profilePicturePath);

        boolean updated = profileService.updateProfile(updatedUser);
        if (updated) {
            loggedInUser.setFullName(fullName);
            loggedInUser.setEmail(email);
            loggedInUser.setPhoneNumber(phoneNumber);
            loggedInUser.setAddress(address);
            loggedInUser.setProfilePicturePath(profilePicturePath);
            HttpSession session = req.getSession(false);
            if (session != null) {
                session.setAttribute("loggedInUser", loggedInUser);
                // Cache-buster to ensure updated profile images are fetched by client
                session.setAttribute("profilePictureCacheBuster", System.currentTimeMillis());
            }
            activityLogService.logActivity(loggedInUser.getUserId(), "PROFILE_UPDATE", "Updated profile details");
            resp.sendRedirect(req.getContextPath() + "/profile?success=Profile updated successfully");
        } else {
            req.setAttribute("error", "Unable to update your profile right now.");
            doGet(req, resp);
        }
    }

    private UserModel resolveLoggedInUser(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        UserModel loggedInUser = session == null ? null : (UserModel) session.getAttribute("loggedInUser");
        if (loggedInUser == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
        }
        return loggedInUser;
    }

    private String storeProfilePicture(HttpServletRequest req, int userId, Part part) throws IOException {
        String submittedName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String safeName = submittedName.replaceAll("[^a-zA-Z0-9._-]", "_");
        String fileName = "profile_" + userId + "_" + Instant.now().toEpochMilli() + "_" + safeName;

        // Organize by role: images/profile/{admin|teacher|student}
        UserModel currentProfile = profileService.getProfileById(userId);
        String userRole = currentProfile != null ? currentProfile.getRole().toLowerCase() : "user";

        // Persist profile images under assets so they survive redeploys to the project
        // layout
        String uploadDirectory = req.getServletContext().getRealPath("/assets/profile/" + userRole);
        Path uploadPath = Paths.get(uploadDirectory);
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        Path target = uploadPath.resolve(fileName);
        try (InputStream inputStream = part.getInputStream()) {
            Files.copy(inputStream, target, StandardCopyOption.REPLACE_EXISTING);
        }

        return "assets/profile/" + userRole + "/" + fileName;
    }

    private String trim(String value) {
        return value == null ? "" : value.trim();
    }
}