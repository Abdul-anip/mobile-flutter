import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hanifstore/cart_page.dart';
import 'package:hanifstore/gridbajupria.dart';
import 'package:hanifstore/gridbajuwanita.dart';
import 'package:hanifstore/gridelectronic.dart';
import 'package:hanifstore/gridsepatupria.dart';
import 'package:hanifstore/gridsepatuwanita.dart';
import 'package:hanifstore/onboarding.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int cartCount = 0;
  // Initialize with null or 0, but we will fetch from prefs
  int? currentUserId;

  List<dynamic> allProductList = [];
  TextEditingController searchProduct = TextEditingController();
  PageController bannerController = PageController();
  Timer? bannerTime;
  int indexBanner = 0;

  Future<void> getAllProductItem() async {
    String urlProductItem =
        "https://servershophanif-production-840f.up.railway.app/allproduct.php";
    try {
      var response = await http.get(Uri.parse(urlProductItem));
      setState(() {
        allProductList = jsonDecode(response.body);
      });
    } catch (exc) {
      print(exc);
    }
  }

  Future<void> searchProductItem(String query) async {
    String urlSearch =
        "https://servershophanif-production-840f.up.railway.app/searchproduct.php?search=$query";
    try {
      var response = await http.get(Uri.parse(urlSearch));
      setState(() {
        allProductList = jsonDecode(response.body);
      });
    } catch (exc) {
      print(exc);
    }
  }

  Future<void> getCartCount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    currentUserId = prefs.getInt('user_id');

    if (currentUserId == null) return;

    String url =
        "https://servershophanif-production-840f.up.railway.app/get_cart.php?user_id=$currentUserId";
    try {
      var response = await http.get(Uri.parse(url));
      var data = jsonDecode(response.body);
      if (data['status'] == 'success') {
        setState(() {
          cartCount = data['data']['item_count'] ?? 0;
        });
      }
    } catch (e) {
      print('Error getting cart count: $e');
    }
  }

  @override
  void dispose() {
    searchProduct.dispose(); 
    bannerController.dispose();
    bannerTime?.cancel();
    super.dispose();
  }

  void bannerOnBoarding() {
    bannerTime = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (indexBanner < 2) {
        indexBanner++;
      } else {
        indexBanner = 0;
      }

      if (bannerController.hasClients) {
        bannerController.animateToPage(indexBanner,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    bannerController.addListener(() {
      if (mounted) {
        setState(() {
          indexBanner = bannerController.page?.round() ?? 0;
        });
      }
    });

    bannerOnBoarding();
    getAllProductItem();
    getCartCount();
  }

  @override
  Widget build(BuildContext context) {
    List<String> bannerImage = [
      "lib/image/banner1.jpg",
      "lib/image/banner2.jpg",
      "lib/image/banner3.jpg",
    ];
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => const OnBoardingPage()));
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            size: 25,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "hanif Online Shop",
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
          Stack(
            children: [
              IconButton(
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  int? userId = prefs.getInt('user_id');
                  if (userId != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartPage(userId: userId),
                      ),
                    ).then((_) => getCartCount());
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please login first')),
                    );
                  }
                },
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              if (cartCount > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      cartCount > 99 ? '99+' : cartCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: TextField(
                controller: searchProduct,
                onChanged: (value) {
                  if (value.isEmpty) {
                    getAllProductItem();
                  } else {
                    searchProductItem(value);
                  }
                },
                decoration: const InputDecoration(
                  hintText: 'Search Product',
                  hintStyle: TextStyle(
                      fontSize: 17,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                  suffixIcon: Align(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Icon(
                      Icons.filter_2_outlined,
                      color: Colors.green,
                    ),
                  ),
                  prefixIcon: Align(
                    widthFactor: 1.0,
                    heightFactor: 1.0,
                    child: Icon(
                      Icons.search,
                      color: Colors.green,
                    ),
                  ),
                  filled: true,
                  fillColor: Color.fromARGB(255, 224, 253, 227),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 3,
                        color: Colors.green,
                        style: BorderStyle
                            .solid), // Changed red to green for consistency
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    // Ensure border shows when not focused
                    borderSide: BorderSide(
                        width: 1,
                        color: Colors.green,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    // Consistent color on focus
                    borderSide: BorderSide(
                        width: 2,
                        color: Colors.green,
                        style: BorderStyle.solid),
                    borderRadius: BorderRadius.all(
                      Radius.circular(25),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              height: 150,
              child: PageView.builder(
                controller: bannerController,
                itemCount: bannerImage.length,
                itemBuilder: (context, index) {
                  return Image.asset(bannerImage[index], fit: BoxFit.cover);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: SizedBox(
                height: 100,
                width: double.infinity,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const GridElectronics()));
                        },
                        child: SizedBox(
                          height: 80,
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'lib/image/electronicsIcon.png',
                                width: 45,
                                height: 45,
                              ),
                              const Text(
                                "Electronic",
                                style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const GridSepatuPria()));
                        },
                        child: SizedBox(
                          height: 80,
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'lib/image/shoesIcon.png',
                                width: 45,
                                height: 45,
                              ),
                              const Text(
                                "Sepatu Pria",
                                style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const GridBajuPria()));
                        },
                        child: SizedBox(
                          height: 80,
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'lib/image/shirtIcon.png',
                                width: 45,
                                height: 45,
                              ),
                              const Text(
                                "Baju Pria",
                                style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const GridSepatuWanita()));
                        },
                        child: SizedBox(
                          height: 80,
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'lib/image/heelsIcon.png',
                                width: 45,
                                height: 45,
                              ),
                              const Text(
                                "Sepatu Wanita",
                                style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      elevation: 5,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const GridBajuWanita()));
                        },
                        child: SizedBox(
                          height: 80,
                          width: 60,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                'lib/image/dressIcon.png',
                                width: 45,
                                height: 45,
                              ),
                              const Text(
                                "Baju Wanita",
                                style: TextStyle(
                                    fontSize: 8,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(5),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  const Text(
                    "Our Product List",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                  ),
                  const SizedBox(height: 5),
                  if (allProductList.isEmpty) ...[
                    const Center(
                      child: Text(
                        "Product Not Found",
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                      ),
                    )
                  ] else ...[
                    GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisExtent: 220,
                          crossAxisSpacing: 5,
                        ),
                        itemCount: allProductList.length,
                        itemBuilder: (BuildContext context, int index) {
                          final itemProduct = allProductList[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DetailGenericProduct(item: itemProduct),
                                ),
                              ).then((_) => getCartCount());
                            },
                            child: Card(
                              elevation: 5,
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Image.network(
                                      itemProduct['images'] ??
                                          itemProduct['image'],
                                      height: 125,
                                      width: 125,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          const SizedBox(
                                              height: 125,
                                              width: 125,
                                              child: Icon(Icons.broken_image)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(5),
                                      child: Text(
                                        itemProduct['name'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11,
                                            color: Colors.black),
                                        maxLines: 1,
                                      ),
                                    ),
                                  ]),
                            ),
                          );
                        }),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailGenericProduct extends StatefulWidget {
  final dynamic item;
  const DetailGenericProduct({super.key, required this.item});

  @override
  State<DetailGenericProduct> createState() => _DetailGenericProductState();
}

class _DetailGenericProductState extends State<DetailGenericProduct> {
  bool _isAdding = false;

  Future<void> addToCart() async {
    setState(() => _isAdding = true);

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
            Navigator.pop(context);
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
            onPressed: () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              int? userId = prefs.getInt('user_id');
              if (userId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CartPage(userId: userId)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please login first')),
                );
              }
            },
            icon: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.black, // Color black because app bar is white
              size: 22,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 15),
            child: Image.network(
              widget.item['images'] ?? widget.item['image'],
              width: 400,
              height: 350,
              errorBuilder: (context, error, stackTrace) => const SizedBox(
                  height: 350,
                  width: 400,
                  child: Icon(Icons.broken_image, size: 100)),
            ),
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
                    )),
                onPressed: _isAdding ? null : addToCart,
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
