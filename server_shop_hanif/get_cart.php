<?php
include_once 'dbconnect.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

$userId = isset($_GET['user_id']) ? intval($_GET['user_id']) : 0;

if ($userId <= 0) {
    echo json_encode(['status' => 'error', 'message' => 'Invalid user ID']);
    exit;
}

try {
    // ✅ VERIFY USER EXISTS
    $userStmt = $conn->prepare("SELECT id FROM users WHERE id = ?");
    $userStmt->bind_param("i", $userId);
    $userStmt->execute();
    $userResult = $userStmt->get_result();
    
    if ($userResult->num_rows === 0) {
        echo json_encode(['status' => 'error', 'message' => 'Unauthorized user']);
        exit;
    }
    $userStmt->close();
    
    // ✅ GET CART dengan validasi stock & price
    $stmt = $conn->prepare("
        SELECT 
            c.id as cart_id,
            c.quantity,
            c.price_snapshot,
            c.added_at,
            p.id as product_id,
            p.name,
            p.price as current_price,
            p.promo as current_promo,
            p.images,
            p.stock,
            p.category,
            p.vendors
        FROM cart c
        JOIN product_items p ON c.product_id = p.id
        WHERE c.user_id = ?
        ORDER BY c.added_at DESC
    ");
    $stmt->bind_param("i", $userId);
    $stmt->execute();
    $result = $stmt->get_result();
    
    $cartItems = [];
    $totalPrice = 0;
    $totalItems = 0;
    $hasIssues = false;
    
    while ($row = $result->fetch_assoc()) {
        // ✅ Check stock availability
        $stockStatus = 'available';
        $stockMessage = null;
        
        if ($row['stock'] <= 0) {
            $stockStatus = 'out_of_stock';
            $stockMessage = 'Out of stock';
            $hasIssues = true;
        } elseif ($row['quantity'] > $row['stock']) {
            $stockStatus = 'insufficient';
            $stockMessage = "Only {$row['stock']} available";
            $hasIssues = true;
        }
        
        // ✅ Check price change
        $currentPrice = $row['current_promo'] > 0 ? $row['current_promo'] : $row['current_price'];
        $priceChanged = abs($currentPrice - $row['price_snapshot']) > 0.01;
        
        // Calculate subtotal using snapshot price
        $subtotal = $row['price_snapshot'] * $row['quantity'];
        
        $cartItems[] = [
            'cart_id' => $row['cart_id'],
            'product_id' => $row['product_id'],
            'name' => $row['name'],
            'price' => floatval($row['current_price']),
            'promo' => floatval($row['current_promo']),
            'price_snapshot' => floatval($row['price_snapshot']),
            'current_price' => $currentPrice,
            'price_changed' => $priceChanged,
            'images' => $row['images'],
            'stock' => intval($row['stock']),
            'stock_status' => $stockStatus,
            'stock_message' => $stockMessage,
            'category' => $row['category'],
            'vendors' => $row['vendors'],
            'quantity' => intval($row['quantity']),
            'subtotal' => $subtotal,
            'added_at' => $row['added_at']
        ];
        
        // Only add to total if available
        if ($stockStatus === 'available') {
            $totalPrice += $subtotal;
            $totalItems += $row['quantity'];
        }
    }
    
    echo json_encode([
        'status' => 'success',
        'data' => [
            'items' => $cartItems,
            'total_price' => $totalPrice,
            'total_items' => $totalItems,
            'item_count' => count($cartItems),
            'has_issues' => $hasIssues
        ]
    ]);
    
    $stmt->close();
} catch (Exception $e) {
    error_log("Get cart error: " . $e->getMessage());
    echo json_encode(['status' => 'error', 'message' => 'Database error']);
}

$conn->close();



?>
