<?php
include_once 'dbconnect.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

if (!isset($_GET['search']) || empty(trim($_GET['search']))) {
    echo json_encode([]);
    exit;
}

$search = trim($_GET['search']);
$searchParam = "%$search%";

$stmt = $conn->prepare("SELECT * FROM product_items WHERE name LIKE ? OR category LIKE ? OR vendors LIKE ?");
$stmt->bind_param("sss", $searchParam, $searchParam, $searchParam);
$stmt->execute();
$result = $stmt->get_result();

$itemproduct = array();
while($row = $result->fetch_assoc()){
    $itemproduct[] = $row;
}

echo json_encode($itemproduct);
$stmt->close();
$conn->close();
?>