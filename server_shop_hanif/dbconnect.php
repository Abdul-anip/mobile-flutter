<?php
// Development (localhost)
if (!getenv('RAILWAY_ENVIRONMENT')) {
    define('DB_HOST', 'localhost');
    define('DB_USER', 'root');
    define('DB_NAME', 'product_items');
    define('DB_PASS', '');
    define('DB_PORT', 3306);
} else {
    // Production (Railway) - Ambil dari Environment Variables
    define('DB_HOST', getenv('MYSQLHOST') ?: 'mysql.railway.internal');
    define('DB_USER', getenv('MYSQLUSER') ?: 'root');
    define('DB_NAME', getenv('MYSQLDATABASE') ?: 'railway');
    define('DB_PASS', getenv('MYSQLPASSWORD') ?: '');
    define('DB_PORT', getenv('MYSQLPORT') ?: 3306);
}

// Connect ke database
$conn = new mysqli(DB_HOST, DB_USER, DB_PASS, DB_NAME, DB_PORT);

// Error handling
if ($conn->connect_error) {
    header('Content-Type: application/json');
    http_response_code(500);
    echo json_encode([
        'status' => 'error',
        'message' => 'Database connection failed: ' . $conn->connect_error
    ]);
    exit;
}

// Set charset UTF-8
$conn->set_charset("utf8mb4");
?>