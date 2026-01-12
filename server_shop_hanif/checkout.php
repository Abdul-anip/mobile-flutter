<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

include 'dbconnect.php';

$user_id = $_POST['user_id'] ?? '';

if (empty($user_id)) {
    echo json_encode(['status' => 'error', 'message' => 'User ID is required']);
    exit;
}

// 1. Get User Details
$sqlUser = "SELECT * FROM users WHERE id = '$user_id'";
$resultUser = $conn->query($sqlUser);
$user = $resultUser->fetch_assoc();

if (!$user) {
    echo json_encode(['status' => 'error', 'message' => 'User not found']);
    exit;
}

// 2. Get Cart Items
$sqlCart = "SELECT c.id as cart_id, c.quantity, p.id as product_id, p.name, p.price, p.promo, p.images 
            FROM cart c 
            JOIN product_items p ON c.product_id = p.id 
            WHERE c.user_id = '$user_id'";

$resultCart = $conn->query($sqlCart);

$item_details = [];
$gross_amount = 0;

if ($resultCart->num_rows > 0) {
    while ($row = $resultCart->fetch_assoc()) {
        $price = $row['promo'] > 0 ? $row['promo'] : $row['price'];
        $quantity = $row['quantity'];
        
        $item_details[] = [
            'id' => (string)$row['product_id'],
            'price' => (int)$price,
            'quantity' => (int)$quantity,
            'name' => substr($row['name'], 0, 50)
        ];
        
        $gross_amount += ($price * $quantity);
    }
} else {
    echo json_encode(['status' => 'error', 'message' => 'Cart is empty']);
    exit;
}

// 3. Prepare Payload
$order_id = 'ORDER-' . time() . '-' . $user_id;

$transaction_details = [
    'order_id' => $order_id,
    'gross_amount' => (int)$gross_amount
];

$customer_details = [
    'first_name' => $user['username'] ?? 'Guest',
    'email' => $user['email'] ?? 'guest@example.com',
    'phone' => $user['phone'] ?? '0800000000'
];

$payload = [
    'transaction_details' => $transaction_details,
    'item_details' => $item_details,
    'customer_details' => $customer_details
];

// 4. Send to Midtrans
$server_key = 'Mid-server-6jqvBdRUOQ2EK-1OazwrESoq';
$url = 'https://app.sandbox.midtrans.com/snap/v1/transactions'; // SANDBOX Endpoint

$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, $url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_POST, 1);
curl_setopt($ch, CURLOPT_POSTFIELDS, json_encode($payload));
curl_setopt($ch, CURLOPT_HTTPHEADER, [
    'Content-Type: application/json',
    'Accept: application/json',
    'Authorization: Basic ' . base64_encode($server_key . ':')
]);

$result = curl_exec($ch);
$httpCode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
$curlError = curl_error($ch);
curl_close($ch);

if ($httpCode == 201) {
    // Optional: Clear Cart logic here if needed, but usually done after successful payment
    $response = json_decode($result, true);
    echo json_encode([
        'status' => 'success',
        'token' => $response['token'],
        'redirect_url' => $response['redirect_url']
    ]);
} else {
    echo json_encode([
        'status' => 'error',
        'message' => 'Midtrans Error: ' . $httpCode,
        'details' => $result,
        'curl_error' => $curlError
    ]);
}
?>
