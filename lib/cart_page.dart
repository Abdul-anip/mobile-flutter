import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'payment_page.dart';

class CartPage extends StatefulWidget {
  final int userId;

  const CartPage({super.key, required this.userId});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<dynamic> cartItems = [];
  bool isLoading = true;
  double totalPrice = 0;
  int totalItems = 0;

  @override
  void initState() {
    super.initState();
    loadCart();
  }

  // Load cart dari server
  Future<void> loadCart() async {
    setState(() => isLoading = true);

    String url =
        "https://servershophanif-production-840f.up.railway.app/get_cart.php?user_id=${widget.userId}";

    try {
      var response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        setState(() {
          cartItems = data['data']['items'];
          totalPrice = double.parse(data['data']['total_price'].toString());
          totalItems = data['data']['total_items'];
          isLoading = false;
        });
      } else {
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Error loading cart: $e');
      setState(() => isLoading = false);
    }
  }

  // Update quantity item
  Future<void> updateQuantity(int cartId, int newQuantity) async {
    String url =
        "https://servershophanif-production-840f.up.railway.app/update_cart.php";

    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'cart_id': cartId.toString(),
          'quantity': newQuantity.toString(),
        },
      );

      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        loadCart(); // Reload cart
      }
    } catch (e) {
      print('Error updating cart: $e');
    }
  }

  // Hapus item dari cart
  Future<void> removeItem(int cartId) async {
    String url =
        "https://servershophanif-production-840f.up.railway.app/remove_from_cart.php";

    try {
      var response = await http.post(
        Uri.parse(url),
        body: {'cart_id': cartId.toString()},
      );

      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item removed from cart'),
            backgroundColor: Colors.green,
          ),
        );
        loadCart(); // Reload cart
      }
    } catch (e) {
      print('Error removing item: $e');
    }
  }

  // Konfirmasi hapus
  void confirmRemove(int cartId, String productName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Remove Item'),
        content: Text('Remove "$productName" from cart?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              removeItem(cartId);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Remove'),
          ),
        ],
      ),
    );
  }

  // Clear cart after successful payment
  Future<void> clearCartAfterPayment() async {
    String url =
        "https://servershophanif-production-840f.up.railway.app/clear_cart.php";
    try {
      await http.post(
        Uri.parse(url),
        body: {'user_id': widget.userId.toString()},
      );
    } catch (e) {
      print("Error clearing cart: $e");
    }
  }

  // Proses Pembayaran ke Midtrans
  Future<void> processPayment() async {
    String paymentUrl =
        "https://servershophanif-production-840f.up.railway.app/payment_midtrans.php";

    setState(() => isLoading = true);

    try {
      var response = await http.post(
        Uri.parse(paymentUrl),
        body: {'user_id': widget.userId.toString()},
      );

      print("Payment Response: ${response.body}"); // Debugging

      var data = jsonDecode(response.body);

      if (data['status'] == 'success') {
        String redirectUrl = data['redirect_url'];

        setState(() => isLoading = false);

        // Buka Halaman Pembayaran
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PaymentPage(paymentUrl: redirectUrl),
          ),
        );

        // Cek hasil balik dari PaymentPage
        if (result == 'success') {
          // Clear cart on server
          await clearCartAfterPayment();

          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Payment Successful! Cart Cleared.'),
              backgroundColor: Colors.green,
            ),
          );
          loadCart(); // Reload (Cart harusnya kosong sekarang)
        }
      } else {
        setState(() => isLoading = false);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Payment Failed'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() => isLoading = false);
      print("Payment Error: $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Colors.green,
        actions: [
          if (cartItems.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep),
              onPressed: () {
                // TODO: Clear all cart
              },
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.shopping_cart_outlined,
                        size: 100,
                        color: Colors.grey.shade300,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Your cart is empty',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Start adding items to your cart',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : Column(
                  children: [
                    // Cart Items List
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.all(10),
                        itemCount: cartItems.length,
                        itemBuilder: (context, index) {
                          final item = cartItems[index];
                          final price =
                              item['promo'] > 0 ? item['promo'] : item['price'];

                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Row(
                                children: [
                                  // Product Image
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.network(
                                      item['images'],
                                      width: 80,
                                      height: 80,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stack) {
                                        return Container(
                                          width: 80,
                                          height: 80,
                                          color: Colors.grey.shade200,
                                          child: const Icon(Icons.image),
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 15),

                                  // Product Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item['name'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          'Rp ${price.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                          ),
                                        ),
                                        const SizedBox(height: 10),

                                        // Quantity Controls
                                        Row(
                                          children: [
                                            // Decrease button
                                            Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: const Icon(Icons.remove,
                                                    size: 16),
                                                onPressed: () {
                                                  if (item['quantity'] > 1) {
                                                    updateQuantity(
                                                      item['cart_id'],
                                                      item['quantity'] - 1,
                                                    );
                                                  }
                                                },
                                              ),
                                            ),

                                            // Quantity
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              child: Text(
                                                '${item['quantity']}',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),

                                            // Increase button
                                            Container(
                                              width: 30,
                                              height: 30,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Colors.grey),
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                              ),
                                              child: IconButton(
                                                padding: EdgeInsets.zero,
                                                icon: const Icon(Icons.add,
                                                    size: 16),
                                                onPressed: () {
                                                  if (item['quantity'] <
                                                      item['stock']) {
                                                    updateQuantity(
                                                      item['cart_id'],
                                                      item['quantity'] + 1,
                                                    );
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Maximum stock reached'),
                                                        backgroundColor:
                                                            Colors.orange,
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),

                                            const Spacer(),

                                            // Delete button
                                            IconButton(
                                              icon: const Icon(
                                                Icons.delete_outline,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                confirmRemove(
                                                  item['cart_id'],
                                                  item['name'],
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Bottom Summary
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 10,
                            offset: const Offset(0, -5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Items:',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '$totalItems items',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Total Price:',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Rp ${totalPrice.toStringAsFixed(0)}',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: processPayment,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: const Text(
                                'CHECKOUT',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
