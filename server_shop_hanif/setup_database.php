<?php
include 'dbconnect.php';

header('Content-Type: application/json');

$response = [];

// 1. Create table users
$sqlUsers = "CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)";

if ($conn->query($sqlUsers) === TRUE) {
    $response['users_table'] = 'Created or already exists';
} else {
    $response['users_table'] = 'Error: ' . $conn->error;
}

// 2. Create table cart
$sqlCart = "CREATE TABLE IF NOT EXISTS cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    price_snapshot DECIMAL(10,2),
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES product_items(id) ON DELETE CASCADE
)";

if ($conn->query($sqlCart) === TRUE) {
    $response['cart_table'] = 'Created or already exists';
} else {
    $response['cart_table'] = 'Error: ' . $conn->error;
}

// 3. Insert default user
$checkUser = "SELECT id FROM users WHERE id = 1";
$userResult = $conn->query($checkUser);
if ($userResult->num_rows == 0) {
    $pass = password_hash('password', PASSWORD_BCRYPT);
    $sqlUser = "INSERT INTO users (id, name, email, password) VALUES (1, 'User Lokal', 'user@local.com', '$pass')";
    if ($conn->query($sqlUser) === TRUE) {
        $response['default_user'] = 'Created (ID: 1, Pass: password)';
    } else {
        $response['default_user'] = 'Error: ' . $conn->error;
    }
} else {
    $response['default_user'] = 'Already exists';
}

echo json_encode($response);
$conn->close();
?>
