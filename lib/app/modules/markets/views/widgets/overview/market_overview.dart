import 'package:chartnalyze_apps/app/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MarketOverviewWebView extends StatefulWidget {
  const MarketOverviewWebView({super.key});

  @override
  State<MarketOverviewWebView> createState() => _MarketOverviewWebViewState();
}

class _MarketOverviewWebViewState extends State<MarketOverviewWebView> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller =
        WebViewController()
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (_) {
                setState(() {
                  _isLoading = false;
                });
              },
            ),
          )
          ..loadRequest(Uri.parse('https://crypto-compare.streamlit.app/'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          Colors.grey[100], // optional, make it consistent with app
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: WebViewWidget(controller: _controller),
              ),
            ),
            if (_isLoading)
              const Center(
                child: SpinKitWave(color: AppColors.primaryGreen, size: 25.0),
              ),
          ],
        ),
      ),
    );
  }
}
