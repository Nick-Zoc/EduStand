<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>500 - Internal Server Error | EduStand</title>
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
            border-top: 4px solid var(--danger-color);
        }
        .error-icon {
            font-size: 5rem;
            color: var(--danger-color);
            margin-bottom: 1.5rem;
            animation: pulse 2s infinite;
        }
        @keyframes pulse {
            0% { transform: scale(1); opacity: 1; }
            50% { transform: scale(1.1); opacity: 0.8; }
            100% { transform: scale(1); opacity: 1; }
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
        <i class="fa-solid fa-server error-icon"></i>
        <h1 class="error-title">500</h1>
        <h2 class="h4 text-on-surface mb-3">Internal Server Error</h2>
        <p class="error-subtitle">Oops! Something went wrong on our end. We are working to fix it. Please try again later.</p>
        
        <div class="d-flex justify-content-center gap-3 mt-4">
            <button onclick="location.reload()" class="btn btn-outline-danger px-4 py-2 rounded-pill fw-medium">
                <i class="fa-solid fa-rotate-right me-2"></i> Refresh
            </button>
            <a href="${pageContext.request.contextPath}/" class="btn btn-danger px-4 py-2 rounded-pill fw-medium text-white shadow-sm hover-lift">
                <i class="fa-solid fa-house me-2"></i> Home
            </a>
        </div>
    </div>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
