import 'package:flutter/material.dart';
import 'package:hanifstore/login_page.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoardingPage> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<Map<String, String>> _onBoardData = [
    {
      "title": "Welcome to Hanif Store",
      "subTitle":
          "Discover the best online shopping experience with premium quality products.",
      "image":
          "https://i.pinimg.com/1200x/1d/a7/7a/1da77a25e2147c6b908ccdfe84012bbb.jpg"
    },
    {
      "title": "Fashion for Everyone",
      "subTitle":
          "Find the perfect style for men and women. Comfortable, trendy, and affordable.",
      "image":
          "https://d2kchovjbwl1tk.cloudfront.net/vendor/9549/product/1_1766377279790.jpg"
    },
    {
      "title": "Latest Electronics",
      "subTitle":
          "Upgrade your life with our wide selection of high-quality gadgets and electronics.",
      "image":
          "https://i.pinimg.com/1200x/c2/f9/86/c2f986f00871251bfabe3bb268cd8c53.jpg"
    },
    {
      "title": "Quality You Can Trust",
      "subTitle":
          "We ensure every product meets our high standards of quality and durability.",
      "image":
          "https://i.pinimg.com/1200x/06/03/1d/06031d8ac180c0dd393363aa8c49dcd7.jpg"
    },
    {
      "title": "Best Prices & Deals",
      "subTitle":
          "Get the best value for your money. Shop smart without breaking the bank.",
      "image":
          "https://i.pinimg.com/736x/e6/e2/79/e6e2791b5e7a44301b24fbaf44ace6c2.jpg"
    }
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentIndex < _onBoardData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Skip Button (Top Right)
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Text(
                    "Skip",
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ),
              ),
            ),

            // Page Content
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentIndex = index);
                },
                itemCount: _onBoardData.length,
                itemBuilder: (context, index) {
                  return OnBoardingContent(
                    item: _onBoardData[index],
                  );
                },
              ),
            ),

            // Bottom Section (Indicators & Buttons)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                children: [
                  // Page Indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _onBoardData.length,
                      (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 8,
                        width: _currentIndex == index ? 24 : 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? Colors.green
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Next / Get Started Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        _currentIndex == _onBoardData.length - 1
                            ? "Get Started"
                            : "Next",
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OnBoardingContent extends StatelessWidget {
  final Map<String, String> item;

  const OnBoardingContent({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Image Container with decorative elements
          Expanded(
            flex: 3,
            child: Container(
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  item["image"]!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.image_not_supported,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),

          // Text Content
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  item["title"]!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  item["subTitle"]!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black54,
                    height: 1.5,
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
