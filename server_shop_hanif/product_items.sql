-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 16, 2025 at 02:07 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `db_ecommerce`
--

-- --------------------------------------------------------

--
-- Table structure for table `product_items`
--

CREATE TABLE `product_items` (
  `id` int(11) NOT NULL,
  `name` varchar(40) NOT NULL,
  `price` double NOT NULL,
  `promo` double NOT NULL,
  `description` varchar(150) NOT NULL,
  `images` varchar(255) NOT NULL,
  `stock` int(11) NOT NULL,
  `vendors` varchar(30) NOT NULL,
  `category` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `product_items`
--

INSERT INTO `product_items` (`id`, `name`, `price`, `promo`, `description`, `images`, `stock`, `vendors`, `category`) VALUES
(1, 'APPLE Iphone 16', 23349000, 2000000, 'Chipset Apple A16 Bionic Kamera Belakang', 'https://assets.bmdstatic.com/web/image?model=product.product&field=image_1024&id=300362&unique=69845a3', 30, 'Apple', 'Electronic'),
(2, 'TV For Business', 5000000, 4500000, 'UHD 4K TV untuk kebutuhan bisnis', 'https://assets.bmdstatic.com/web/image?model=product.product&field=image_1024&id=301200&unique=e65dc4e', 10, 'Samsung', 'Electronic'),
(3, 'APPLE MacBook Pro', 25400000, 23500000, 'Laptop kencang untuk profesional', 'https://assets.bmdstatic.com/web/image?model=product.product&field=image_1024&id=302269&unique=374c755', 25, 'TechMaster', 'Electronic'),
(4, 'Smart Watch Series 5', 7890000, 6288000, 'Jam tangan pintar fitur kesehatan', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/MTA-180434485/apple_apple_watch_series_10_-46mm-_full24_kxw7d8ph.jpeg', 50, 'Apple', 'Electronic'),
(5, 'Headphone Wireless', 1500000, 1200000, 'Noise cancelling active', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//catalog-image/98/MTA-98661301/br-m036969-03060_sony-wh-ch720-wireless-headphone-sony-whch720-ch-720-headphones_full01.jpg', 40, 'Sony', 'Electronic'),
(6, 'Bluetooth Speaker', 800000, 750000, 'Suara bass mantap tahan air', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/103/MTA-179428350/jbl_jbl_charge_5_portable_bluetooth_speaker_-_wireless_speaker_-_speaker_jbl_charge_5_waterproof_bluetooth_speaker_full01_j4vzttt.jpg', 60, 'JBL', 'Electronic'),
(7, 'Adidas Men Training Shoes', 3000000, 2700000, 'Material Mesh dan karet, Warna Abu-abu', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/MTA-182312610/adidas_adidas_men_training_shoes_rapidmove_adv_2_trainer_m_sepatu_fitness_pria_-ih5242-_full03_uai9op2f.jpeg', 50, 'Adidas', 'Sepatu Pria'),
(8, 'Marelli Sepatu Formal Pria', 1290000, 780000, 'Material Kulit sintetis berkualitas, Warna Hitam', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/97/MTA-183272280/marelli_marelli_sepatu_formal_pria_kulit_dt_121_black_full08_epia27r6.webp', 89, 'Fashion Hub', 'Sepatu Pria'),
(9, 'Jim Joker Road Boots Kulit', 1099000, 597000, 'Boots kulit asli tahan lama', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//catalog-image/93/MTA-143442462/jim_joker_jim_joker_road_1bg_sepatu_boots_pria_full27_tatkfvh3.jpg', 20, 'Footwear Pro', 'Sepatu Pria'),
(10, 'Jim Joker Rick 1FA', 899000, 487000, 'Slip on santai bahan suede', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/95/MTA-157001690/jim_joker_jim_joker_rick_1fa_-_sepatu_slip_on_kulit_pria_full01_ceqvayr4.jpg', 35, 'Fashion Hub', 'Sepatu Pria'),
(11, 'Sepatu Lari Pria NIKE', 4329000, 3988000, 'Ringan dan empuk untuk lari', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/111/MTA-183457488/nike_sepatu-lari-pria-nike-air-zoom-alphafly-next-3-international-running-ih3575999-original_full01.webp', 40, 'Sporty', 'Sepatu Pria'),
(12, 'CROCS Classic Unisex Clog', 150000, 130000, 'Sandal casual bahan kulit', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/91/MTA-181560023/no_brand_crocs_classic_unisex_clog_100012q9-sepatu_sendal_pria_wanita_full02_nt07ece.jpg', 60, 'Crocs', 'Sepatu Pria'),
(13, 'H&M Divided Parker Hood Hoodie Wanita', 200000, 100000, 'Material Baby Terry, Warna Pink Pastel', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/MTA-181617274/divided_-pre_order-_h-m_divided_parker_hood_hoodie_wanita_-_beige_-1087259003-_full08_fuax427t.jpeg', 30, 'H&M', 'Baju Wanita'),
(14, 'Hush Puppies Tygena Cropped Denim', 759000, 432000, 'Material: Denim Premium, Warna: Biru Tua', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/98/MTA-180704634/hush-puppies_hush-puppies-tygena-cropped-denim-jacket-wanita_full01.jpg', 15, 'Fashion Hub', 'Baju Wanita'),
(15, 'UNIQLO Kaos Polo Shirt', 350000, 259000, 'Material Katun Combed 24s Warna Putih', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/99/MTA-183231468/uniqlo_uniqlo_kaos_polo_shirt_katun_wanita_cotton_washed_lengan_pendek_garis_dark_brown_full01_uxenmj6c.webp', 80, 'Footwear Pro', 'Baju Wanita'),
(16, 'Heaven Lights - Shirt', 375000, 299000, 'Material Katun Rayon, Warna: Biru Muda', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/MTA-183430775/heaven_lights_heaven_lights_-_rayla_shirt_-_kemeja_blouse_wanita_full01_n4wrmv6m.webp', 40, 'Fashion Hub', 'Baju Wanita'),
(17, 'Dress Floral Pink', 280000, 255000, 'Material Chiffon dengan Lining', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//107/MTA-60778276/fame_fame_-_dress_wanita_floral_print_pink_-_9510938_full01_2tt3plb.jpg', 25, 'Elegance Apparel', 'Baju Wanita'),
(18, 'VALINO LADIES Polo', 120000, 100000, 'Rok panjang model plisket warna mocca', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/87/MTA-183151311/valino_valino-ladies-polo-shirt-coklat-wanita-d-dcgf28-k5_full01.webp', 50, 'Fashion Hub', 'Baju Wanita'),
(19, 'Adidas Men Polo Shirts', 650000, 625000, 'Material Fleece Premium, Warna Abu-abu', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/MTA-182555325/adidas_adidas_men_polo_shirts_m_sl_pq_ps_baju_polo_pria_-je9020-_full02_e3f8mhjo.jpeg', 30, 'Fashion Hub', 'Baju Pria'),
(20, 'PUMA Men Training Essential Hoodie', 1230000, 945000, 'PUMA Men Training Wardrobe Essential Hoodie adalah hoodie klasik yang dirancang untuk kenyamanan maksimal dalam aktivitas sehari-hari maupun sesi lati', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/MTA-182224212/puma_puma_men_training_wardrobe_essential_hoodie_jaket_pria_-62964734-_full02_bccg55uu.jpeg', 20, 'Footwear Pro', 'Baju Pria'),
(21, 'Kaos Pria polo Ferrari Race', 729000, 328000, 'Material 100% Katun Combed 30s, Hitam', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/MTA-145429241/puma_kaos_pria_polo_ferrari_race_black_535835_01_full01_uh4xekhp.webp', 100, 'Fashion Hub', 'Baju Pria'),
(22, 'Platini Kemeja Pria Polos ', 200000, 180000, 'Material Katun Stretch Warna Putih', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//99/MTA-24641694/platini_platini_kemeja_pria_polos_polinosic_panjang_white_66014_full01_ihtqxsd1.jpg', 40, 'Elegance Apparel', 'Baju Pria'),
(23, 'UNIQLO Kemeja Utilitas pria', 566000, 499000, 'Material Katun Premium, Kombinasi Biru', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/102/MTA-183386811/uniqlo_uniqlo_kemeja_utilitas_pria_utility_shirt_lengan_pendek_beige_full01_q8l33jyv.webp', 50, 'Fashion Hub', 'Baju Pria'),
(24, 'Adidas Men Running Vest Jaket', 512000, 435000, 'Rompi parasut 100% poliester', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/MTA-179060632/adidas_adidas_men_running_own_the_run_vest_jaket_lari_pria_-iw0025-_full01_hue9anw3.jpg', 25, 'Elegance Apparel', 'Baju Pria'),
(25, 'Christian Louboutin Kate 85', 12790000, 8939000, 'Heels 5cm cocok untuk kantor', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/MTA-33594431/christian_louboutin_christian_louboutin_kate_85_patent_leather_pumps_black_full07_npf1yomt.jpeg', 30, 'Footwear Pro', 'Sepatu Wanita'),
(26, 'Posie Laser Cut Flat Shoes', 533000, 395000, 'Nyaman dipakai sehari-hari', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/102/MTA-183433638/brd-126851_posie-laser-cut-flat-shoes-genuine-leather-brown_full01-d471943e.webp', 45, 'Elegance Apparel', 'Sepatu Wanita'),
(27, 'Sneakers Wanita NIKE DUNK', 1729000, 1171000, 'Sneakers trendy warna putih bersih', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/93/MTA-183401291/nike_sepatu-sneakers-wanita-nike-dunk-low-next-nature-hj7673002-original_full01.webp', 40, 'Sporty', 'Sepatu Wanita'),
(28, 'YSL Nu Pied Tribute Sandals', 7300000, 6950000, 'Sandal wedges tinggi 7cm', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/90/MTA-181602600/saint_laurent_ysl_nu_pied_tribute_sandals_black_patent_full01_d24aa479.jpg', 20, 'Fashion Hub', 'Sepatu Wanita'),
(29, 'Melissa Courtney Boot', 1750000, 1137000, 'Boots style korea bahan kulit sintesis', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full/catalog-image/MTA-167389584/melissa_melissa_courtney_boot_ad_sepatu_boots_wanita_-_beige_full02_jwm1xoxv.jpeg', 15, 'Footwear Pro', 'Sepatu Wanita'),
(30, 'SEIS Zica Sandal Wanita', 235000, 167000, 'Sandal santai', 'https://www.static-src.com/wcsstore/Indraprastha/images/catalog/full//catalog-image/106/MTA-148765525/seis_seis_zica_sandal_wanita_-_sandal_teplek_wanita_full05_snwt2kmd.jpg', 60, 'Elegance Apparel', 'Sepatu Wanita');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `product_items`
--
ALTER TABLE `product_items`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `product_items`
--
ALTER TABLE `product_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=31;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
