<?php
include_once 'dbconnect.php';

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');

$stat = $conn->prepare("SELECT id, name, price, promo, description, images, stock, vendors, category FROM product_items");
$stat->execute();
$result = $stat->get_result();

$arrayproduct = array();
while ($row = $result->fetch_assoc()) {
    $arrayproduct[] = $row;
}

echo json_encode($arrayproduct);
$stat->close();
$conn->close();
?>