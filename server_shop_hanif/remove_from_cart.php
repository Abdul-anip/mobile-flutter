<?php

include_once 'dbconnect.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
    exit;
}

$cartId = isset($_POST['cart_id']) ? intval($_POST['cart_id']) : 0;

if ($cartId <= 0) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid cart ID']);
    exit;
}

try {
    $stmt = $conn->prepare("DELETE FROM cart WHERE id = ?");
    $stmt->bind_param("i", $cartId);
    
    if ($stmt->execute()) {
        echo json_encode([
            'status' => 'success',
            'message' => 'Item removed from cart'
        ]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Remove failed']);
    }
    
    $stmt->close();
} catch (Exception $e) {
    error_log("Remove from cart error: " . $e->getMessage());
    echo json_encode(['status' => 'error', 'message' => 'Database error']);
}

$conn->close();





?>