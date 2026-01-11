import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:hanifstore/gridbajupria.dart';
import 'package:hanifstore/gridbajuwanita.dart';
import 'package:hanifstore/gridelectronic.dart';
import 'package:hanifstore/gridsepatupria.dart';
import 'package:hanifstore/gridsepatuwanita.dart';
import 'dart:convert';

import 'package:hanifstore/onboarding.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  void dispose() {
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

      bannerController.animateToPage(indexBanner,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  void initState() {
    super.initState();
    bannerController.addListener(() {
      setState(() {
        indexBanner = bannerController.page?.round() ?? 0;
      });
    });

    bannerOnBoarding();
    getAllProductItem();
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
            Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnBoardingPage()));
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
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.shopping_cart_outlined,
                color: Colors.white,
                size: 22,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const TextField(
              decoration: InputDecoration(
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
                      width: 3, color: Colors.red, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(
                    Radius.circular(25),
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
                            onTap: () {},
                            child: Card(
                              elevation: 5,
                              child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Image.network(
                                      itemProduct['images'],
                                      height: 125,
                                      width: 125,
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
