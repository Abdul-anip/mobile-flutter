import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentPage extends StatefulWidget {
  final String paymentUrl;

  const PaymentPage({super.key, required this.paymentUrl});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {},
          onPageFinished: (String url) {
            setState(() {
              _isLoading = false;
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            // Deteksi Status Pembayaran dari URL
            // Menambahkan keyword umum yang mungkin muncul saat redirect sukses
            if (request.url.contains('status_code=200') ||
                request.url.contains('transaction_status=settlement') ||
                request.url.contains('transaction_status=capture') ||
                request.url.contains('result_type=success') ||
                request.url.contains('status_code=201') ||
                request.url.contains('transaction_status=pending')) {
              // Pending juga kadang dianggap 'selesai' step pembayaran
              Navigator.pop(context, 'success');
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  // Fungsi untuk menangani tombol Back / Close manual
  Future<bool> _onWillPop() async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Payment Status'),
            content: const Text(
                'Have you completed the payment? If yes, we will process your order and clear your cart.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false), // Stay
                child: const Text('No, Stay Here'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Close Dialog
                  Navigator.of(context)
                      .pop('success'); // Return success to Cart
                },
                child: const Text('Yes, Payment Completed',
                    style: TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold)),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true); // Close Dialog
                  Navigator.of(context).pop(null); // Return null (Cancel)
                },
                child: const Text('Cancel Payment',
                    style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        )) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    // Menggunakan WillPopScope (atau PopScope di project terbaru) untuk menangkap back button device
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment'),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () =>
                _onWillPop(), // Panggil fungsi konfirmasi yang sama
          ),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_isLoading)
              const Center(
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
