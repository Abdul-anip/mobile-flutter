<?php
include 'dbconnect.php';

header('Content-Type: application/json');

$sql = "CREATE TABLE IF NOT EXISTS cart (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT DEFAULT 1,
    price_snapshot DECIMAL(10,2),
    added_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (product_id) REFERENCES product_items(id)
)";

if ($conn->query($sql) === TRUE) {
    echo json_encode(['status' => 'success', 'message' => 'Table `cart` created or checks out.']);
} else {
    echo json_encode(['status' => 'error', 'message' => 'Error creating table: ' . $conn->error]);
}

$conn->close();
?>
