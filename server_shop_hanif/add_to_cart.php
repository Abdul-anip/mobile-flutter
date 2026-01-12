<?php
include_once 'dbconnect.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    echo json_encode(['status' => 'error', 'message' => 'Invalid request method']);
    exit;
}

$userId = isset($_POST['user_id']) ? intval($_POST['user_id']) : 0;
$productId = isset($_POST['product_id']) ? intval($_POST['product_id']) : 0;
$quantity = isset($_POST['quantity']) ? intval($_POST['quantity']) : 1;

// ✅ Validasi
if ($userId <= 0 || $productId <= 0) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid user or product ID']);
    exit;
}

if ($quantity <= 0) {
    echo json_encode(['status' => 'error', 'message' => 'Quantity must be greater than 0']);
    exit;
}

try {
    // ✅ CEK APAKAH USER VALID (Authentication)
    $userStmt = $conn->prepare("SELECT id FROM users WHERE id = ?");
    $userStmt->bind_param("i", $userId);
    $userStmt->execute();
    $userResult = $userStmt->get_result();
    
    if ($userResult->num_rows === 0) {
        echo json_encode(['status' => 'error', 'message' => 'Unauthorized user']);
        exit;
    }
    $userStmt->close();
    
    // ✅ CEK PRODUCT & STOCK
    $productStmt = $conn->prepare("SELECT stock, name, price, promo FROM product_items WHERE id = ?");
    $productStmt->bind_param("i", $productId);
    $productStmt->execute();
    $productResult = $productStmt->get_result();
    
    if ($productResult->num_rows === 0) {
        echo json_encode(['status' => 'error', 'message' => 'Product not found']);
        exit;
    }
    
    $product = $productResult->fetch_assoc();
    $availableStock = $product['stock'];
    $productName = $product['name'];
    $price = $product['promo'] > 0 ? $product['promo'] : $product['price'];
    $productStmt->close();
    
    // ✅ CEK EXISTING CART QUANTITY
    $cartStmt = $conn->prepare("SELECT id, quantity FROM cart WHERE user_id = ? AND product_id = ?");
    $cartStmt->bind_param("ii", $userId, $productId);
    $cartStmt->execute();
    $cartResult = $cartStmt->get_result();
    
    $currentCartQuantity = 0;
    $cartId = null;
    
    if ($cartResult->num_rows > 0) {
        $cartRow = $cartResult->fetch_assoc();
        $currentCartQuantity = $cartRow['quantity'];
        $cartId = $cartRow['id'];
    }
    $cartStmt->close();
    
    // ✅ VALIDASI STOCK
    $newTotalQuantity = $currentCartQuantity + $quantity;
    
    if ($newTotalQuantity > $availableStock) {
        echo json_encode([
            'status' => 'error',
            'message' => "Only {$availableStock} items available in stock",
            'available_stock' => $availableStock,
            'current_in_cart' => $currentCartQuantity
        ]);
        exit;
    }
    
    // ✅ CEK BATAS MAKSIMAL PER ITEM (misalnya max 10)
    $maxPerItem = 10;
    if ($newTotalQuantity > $maxPerItem) {
        echo json_encode([
            'status' => 'error',
            'message' => "Maximum {$maxPerItem} items per product",
            'current_in_cart' => $currentCartQuantity
        ]);
        exit;
    }
    
    // ✅ INSERT/UPDATE CART dengan PRICE SNAPSHOT
    if ($cartId) {
        // Update existing
        $updateStmt = $conn->prepare("UPDATE cart SET quantity = ?, price_snapshot = ? WHERE id = ?");
        $updateStmt->bind_param("idi", $newTotalQuantity, $price, $cartId);
        $updateStmt->execute();
        $updateStmt->close();
        
        echo json_encode([
            'status' => 'success',
            'message' => 'Cart updated successfully',
            'quantity' => $newTotalQuantity,
            'cart_id' => $cartId
        ]);
    } else {
        // Insert new dengan price snapshot
        $insertStmt = $conn->prepare(
            "INSERT INTO cart (user_id, product_id, quantity, price_snapshot, added_at) 
             VALUES (?, ?, ?, ?, NOW())"
        );
        $insertStmt->bind_param("iiid", $userId, $productId, $quantity, $price);
        
        if ($insertStmt->execute()) {
            echo json_encode([
                'status' => 'success',
                'message' => "{$productName} added to cart",
                'cart_id' => $conn->insert_id,
                'quantity' => $quantity
            ]);
        } else {
            echo json_encode(['status' => 'error', 'message' => 'Failed to add item']);
        }
        $insertStmt->close();
    }
    
} catch (Exception $e) {
    error_log("Add to cart error: " . $e->getMessage());
    echo json_encode(['status' => 'error', 'message' => 'Database error']);
}

$conn->close();



?>
