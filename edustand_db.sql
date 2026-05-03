-- 1. Users Table (Core for Milestone 1)
CREATE TABLE IF NOT EXISTS Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'TEACHER', 'STUDENT') NOT NULL,
    status ENUM('ACTIVE', 'INACTIVE', 'PENDING') DEFAULT 'ACTIVE',
    request_reason TEXT DEFAULT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Resources Table
CREATE TABLE IF NOT EXISTS Resources (
    resource_id INT AUTO_INCREMENT PRIMARY KEY,
    uploader_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    file_path VARCHAR(255) NOT NULL,
    file_type VARCHAR(50),
    category VARCHAR(100),
    upload_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (uploader_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 3. Assignments Table
CREATE TABLE IF NOT EXISTS Assignments (
    assignment_id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    instructions TEXT,
    due_date DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (teacher_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 4. Submissions Table
CREATE TABLE IF NOT EXISTS Submissions (
    submission_id INT AUTO_INCREMENT PRIMARY KEY,
    assignment_id INT NOT NULL,
    student_id INT NOT NULL,
    file_path VARCHAR(255) NOT NULL,
    status ENUM('PENDING', 'GRADED') DEFAULT 'PENDING',
    score DECIMAL(5,2),
    submitted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (assignment_id) REFERENCES Assignments(assignment_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 5. Resource Downloads (For Analytics)
CREATE TABLE IF NOT EXISTS Resource_Downloads (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    resource_id INT NOT NULL,
    student_id INT NOT NULL,
    downloaded_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (resource_id) REFERENCES Resources(resource_id) ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Insert a default admin for testing (Password is: admin123)
INSERT INTO Users (full_name, email, password_hash, role) 
VALUES ('System Admin', 'admin@edustand.edu', 'admin123', 'ADMIN');

CREATE TABLE IF NOT EXISTS RememberMeTokens (
    token_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    token_hash VARCHAR(255) UNIQUE NOT NULL,
    token_expiry DATETIME NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    INDEX idx_user_token (user_id, token_expiry)
);

CREATE TABLE IF NOT EXISTS ContactRequests (
    request_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(180) NOT NULL,
    message TEXT NOT NULL,
    read_status ENUM('UNREAD', 'READ') NOT NULL DEFAULT 'UNREAD',
    request_status ENUM('PENDING', 'FIXED') NOT NULL DEFAULT 'PENDING',
    admin_response TEXT DEFAULT NULL,
    email_notified TINYINT(1) NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE SET NULL,
    INDEX idx_contact_created (created_at),
    INDEX idx_contact_status (read_status, request_status)
);