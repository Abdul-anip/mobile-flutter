<?php
    include_once 'dbconnect.php';
    $stat = $conn -> prepare ("SELECT id, name, price, promo, description, images, stock, vendors, category FROM product_items WHERE category = 'Electronic';");
    $stat -> execute();
    $stat -> bind_result($id, $name, $price, $promo, $description, $image, $stock, $vendors, $category);
    $arrayproduct = array();

    while ($stat -> fetch()){
        $data = array();
        $data['id'] = $id;
        $data['name'] = $name;
        $data['price'] = $price;
        $data['promo'] = $promo;
        $data['description'] = $description;
        $data['image'] = $image;
        $data['stock'] = $stock;
        $data['vendors'] = $vendors;
        $data['category'] = $category;

        array_push($arrayproduct, $data);
    }
    echo json_encode($arrayproduct);
?>