import 'package:flutter/material.dart';
import 'package:hanifstore/homepage.dart';
import 'package:hanifstore/login_page.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoardingPage> {
  PageController page = PageController();
  int indexPage = 0;
  List<Map<String, String>> onBoardData = [
    {
      "title": "Hanif Ecommerce",
      "subTitle": "Welcome to Our Online Shop",
      "image":
          "https://i.pinimg.com/736x/ba/d4/8b/bad48ba35d8e693333e425ad03f2f1ac.jpg"
    },
    {
      "title": "Many Products for Men or Women",
      "subTitle":
          "Made from high-quality fabric, it feels soft on the skin and is breathable, making it suitable for daily activities.",
      "image":
          "https://epidemicstreetwear.com/wp-content/uploads/2023/08/Untitled-1_0085_ARMLESS-TAMPAK-DEPAN.webp"
    },
    {
      "title": "Find Some Electronics",
      "subTitle":
          "Discover a wide selection of high-quality electronic products designed to make your life easier and more enjoyable.",
      "image":
          "https://assets.bmdstatic.com/web/image?model=product.product&field=image_1024&id=454000&unique=0da8c3f"
    },
    {
      "title": "High-Quality Products You Can Trust",
      "subTitle":
          "Experience the difference with our collection of high-quality products, crafted with premium materials and exceptional attention to detail.",
      "image":
          "https://d29c1z66frfv6c.cloudfront.net/pub/media/catalog/product/large/27f6136dbfe7e8ed18ab466b669c060a4fce230e_xxl-1.jpg"
    },
    {
      "title": "Affordable Prices You'll Love",
      "subTitle":
          "Shop smart with our range of products at unbeatable low prices! We offer budget-friendly deals without compromising on quality, so you can get what you need without breaking the bank.",
      "image":
          "https://epidemicstreetwear.com/wp-content/uploads/2025/06/ZIPPER-SPIRIT-SHAKEN-BLACK-DEPAN-2048x2048.webp"
    }
  ];

  @override
  void initState() {
    super.initState();
    page = PageController();
    page.addListener(() {
      setState(() {
        indexPage = page.page?.round() ?? 0;
      });
    });
  }

  @override
  void dispose() {
    page.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
              child: PageView.builder(
                  controller: page,
                  itemCount: onBoardData.length,
                  itemBuilder: (context, index) {
                    return onBoardingLayout(
                        title: "${onBoardData[index]["title"]}",
                        subTitle: "${onBoardData[index]["subTitle"]}",
                        image: "${onBoardData[index]["image"]}");
                  })),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                indexPage == onBoardData.length - 1
                    ? TextButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()));
                        },
                        child: const Text(
                          "Get Started",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      )
                    : const Text(""),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      onBoardData.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: indexPage == index
                                ? Colors.black54
                                : Colors.blueAccent),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (indexPage == onBoardData.length - 1) {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                    } else {
                      page.nextPage(
                          duration: const Duration(microseconds: 300),
                          curve: Curves.easeIn);
                    }
                  },
                  icon: const Icon(Icons.arrow_forward_ios),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class onBoardingLayout extends StatelessWidget {
  const onBoardingLayout(
      {required this.title, required this.subTitle, required this.image});
  final String title;
  final String subTitle;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          image,
          height: 350,
          width: 300,
          fit: BoxFit.fill,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          title,
          style: const TextStyle(
              fontSize: 25, fontWeight: FontWeight.bold, color: Colors.black),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            subTitle,
            style: const TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
        ),
      ],
    );
  }
}
