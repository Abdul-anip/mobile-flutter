import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hanifstore/homepage.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hanifstore/cart_page.dart';

class GridBajuPria extends StatefulWidget {
  const GridBajuPria({super.key});

  @override
  State<GridBajuPria> createState() => _GridBajuPriaState();
}

class _GridBajuPriaState extends State<GridBajuPria> {
  bool isAddingToCart = false;
  int currentUserId = 1;

  List<dynamic> bajuPriaProduct = [];
  Future<void> getAllBajuPria() async {
    String urlBajuPria =
        "https://servershophanif-production-840f.up.railway.app/gridbajupria.php";
    try {
      var response = await http.get(Uri.parse(urlBajuPria));
      setState(() {
        bajuPriaProduct = jsonDecode(response.body);
      });
    } catch (exc) {
      print(exc);
    }
  }

  @override
  void initState() {
    super.initState();
    getAllBajuPria();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const HomePage()));
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              size: 25,
              color: Colors.white,
            ),
          ),
          title: const Text(
            "Baju Pria Products",
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          centerTitle: true,
          backgroundColor: Colors.green,
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.info_outline,
                  color: Colors.white,
                  size: 22,
                )),
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 22,
                )),
          ],
        ),
        body: Center(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisExtent: 220,
              crossAxisSpacing: 5,
            ),
            itemCount: bajuPriaProduct.length,
            itemBuilder: (context, int index) {
              final item = bajuPriaProduct[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => DetilBajuPria(item: item)));
                },
                child: Card(
                  child: Column(
                    children: <Widget>[
                      Image.network(item['image'], width: 125, height: 125),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: Text(
                          item['name'],
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 5, 0, 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              "harga : Rp." + item['price'].toString(),
                              style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold),
                            ),
                            Row(
                              children: <Widget>[
                                const Icon(
                                  Icons.favorite,
                                  size: 13,
                                  color: Colors.red,
                                ),
                                Text(
                                  item['promo'].toString(),
                                  style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold),
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
        ));
  }
}

class DetilBajuPria extends StatefulWidget {
  final dynamic item;
  const DetilBajuPria({super.key, required this.item});

  @override
  State<DetilBajuPria> createState() => _DetilBajuPriaState();
}

class _DetilBajuPriaState extends State<DetilBajuPria> {
  bool _isAdding = false;

  Future<void> addToCart() async {
    setState(() => _isAdding = true);

    // Get User ID from SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('user_id');

    if (userId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please login first'), backgroundColor: Colors.red),
      );
      setState(() => _isAdding = false);
      return;
    }

    String url =
        "https://servershophanif-production-840f.up.railway.app/add_to_cart.php";

    try {
      var response = await http.post(
        Uri.parse(url),
        body: {
          'user_id': userId.toString(),
          'product_id': widget.item['id'].toString(),
          'quantity': '1',
        },
      );

      var data = jsonDecode(response.body);

      if (!mounted) return;

      if (data['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Added to cart'),
            backgroundColor: Colors.green,
            action: SnackBarAction(
              label: 'VIEW CART',
              textColor: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartPage(userId: userId),
                  ),
                );
              },
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(data['message'] ?? 'Failed to add to cart'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isAdding = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const GridBajuPria()));
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: Colors.black,
          ),
        ),
        title: Text(
          widget.item["name"],
          style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.blueAccent),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shop_outlined,
                color: Colors.white,
                size: 22,
              )),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Image.network(widget.item['image'], width: 400, height: 350),
          ),
          const Padding(
              padding: EdgeInsets.fromLTRB(30, 20, 0, 0),
              child: Text(
                "Product Decription",
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              )),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 5, 0, 30),
            child: Text(
              widget.item['description'],
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "harga : Rp." + widget.item['price'].toString(),
                  style: const TextStyle(
                      fontSize: 13,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  children: <Widget>[
                    const Icon(
                      Icons.favorite,
                      size: 13,
                      color: Colors.red,
                    ),
                    Text(
                      widget.item['promo'].toString(),
                      style: const TextStyle(
                          fontSize: 13,
                          color: Colors.green,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(100, 40, 0, 0),
            child: SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: _isAdding ? null : addToCart, // ✅ Panggil function
                child: _isAdding
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Add to Cart",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
