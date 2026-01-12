<?php


include_once 'dbconnect.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
    exit;
}

$cartId = isset($_POST['cart_id']) ? intval($_POST['cart_id']) : 0;
$quantity = isset($_POST['quantity']) ? intval($_POST['quantity']) : 1;

if ($cartId <= 0) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid cart ID']);
    exit;
}

if ($quantity <= 0) {
    echo json_encode(['status' => 'error', 'message' => 'Quantity must be greater than 0']);
    exit;
}

try {
    $stmt = $conn->prepare("UPDATE cart SET quantity = ? WHERE id = ?");
    $stmt->bind_param("ii", $quantity, $cartId);
    
    if ($stmt->execute()) {
        echo json_encode([
            'status' => 'success',
            'message' => 'Cart updated successfully'
        ]);
    } else {
        echo json_encode(['status' => 'error', 'message' => 'Update failed']);
    }
    
    $stmt->close();
} catch (Exception $e) {
    error_log("Update cart error: " . $e->getMessage());
    echo json_encode(['status' => 'error', 'message' => 'Database error']);
}

$conn->close();



?>