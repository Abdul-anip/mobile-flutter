import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hanifstore/homepage.dart';
import 'package:http/http.dart' as http;

class GridBajuWanita extends StatefulWidget {
  const GridBajuWanita({super.key});

  @override
  State<GridBajuWanita> createState() => _GridBajuWanitaState();
}

class _GridBajuWanitaState extends State<GridBajuWanita> {
  List<dynamic> bajuWanitaProduct = [];
  Future<void> getAllBajuWanita() async {
    String urlBajuWanita =
        "https://servershophanif-production-840f.up.railway.app/gridbajuwanita.php";
    try {
      var response = await http.get(Uri.parse(urlBajuWanita));
      setState(() {
        bajuWanitaProduct = jsonDecode(response.body);
      });
    } catch (exc) {
      print(exc);
    }
  }

  @override
  void initState() {
    super.initState();
    getAllBajuWanita();
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
            "Baju Wanita Products",
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
            itemCount: bajuWanitaProduct.length,
            itemBuilder: (context, int index) {
              final item = bajuWanitaProduct[index];
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => DetilBajuWanita(item: item)));
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

class DetilBajuWanita extends StatelessWidget {
  final dynamic item;
  const DetilBajuWanita({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const GridBajuWanita()));
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: Colors.black,
          ),
        ),
        title: Text(
          item["name"],
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
            child: Image.network(item['image'], width: 400, height: 350),
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
              item['description'],
              style: const TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  "harga : Rp." + item['price'].toString(),
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
                      item['promo'].toString(),
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
                    shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                )),
                onPressed: () {},
                child: const Text(
                  "Add to Cart",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
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
