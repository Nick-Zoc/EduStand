<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found | EduStand</title>
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&family=Outfit:wght@400;500;600;700&display=swap" rel="stylesheet">
    <!-- FontAwesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/style.css">
    <style>
        .error-page-container {
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            background-color: var(--surface-bg);
            padding: 2rem;
        }
        .error-card {
            max-width: 500px;
            width: 100%;
            text-align: center;
            padding: 3rem 2rem;
        }
        .error-icon {
            font-size: 5rem;
            color: var(--primary-color);
            margin-bottom: 1.5rem;
            animation: float 3s ease-in-out infinite;
        }
        @keyframes float {
            0% { transform: translateY(0px); }
            50% { transform: translateY(-15px); }
            100% { transform: translateY(0px); }
        }
        .error-title {
            font-family: 'Outfit', sans-serif;
            font-size: 2.5rem;
            font-weight: 700;
            color: var(--on-surface);
            margin-bottom: 0.5rem;
        }
        .error-subtitle {
            color: var(--on-surface-variant);
            margin-bottom: 2rem;
            font-size: 1.1rem;
        }
    </style>
</head>
<body>

<div class="error-page-container">
    <div class="card-sleek-no-hover error-card">
        <i class="fa-solid fa-compass error-icon text-primary"></i>
        <h1 class="error-title">404</h1>
        <h2 class="h4 text-on-surface mb-3">Page Not Found</h2>
        <p class="error-subtitle">Oops! The page you are looking for doesn't exist or has been moved.</p>
        
        <div class="d-flex justify-content-center gap-3 mt-4">
            <button onclick="history.back()" class="btn btn-outline-primary px-4 py-2 rounded-pill fw-medium">
                <i class="fa-solid fa-arrow-left me-2"></i> Go Back
            </button>
            <a href="${pageContext.request.contextPath}/" class="btn btn-primary px-4 py-2 rounded-pill fw-medium text-white shadow-sm hover-lift">
                <i class="fa-solid fa-house me-2"></i> Home
            </a>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
