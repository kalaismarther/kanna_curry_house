import 'package:flutter/material.dart';
import 'package:kanna_curry_house/view/widgets/primary_appbar.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PolicyScreen extends StatefulWidget {
  const PolicyScreen({super.key, required this.title, required this.url});

  final String title;
  final String url;

  @override
  State<PolicyScreen> createState() => _PolicyScreenState();
}

class _PolicyScreenState extends State<PolicyScreen> {
  int loadingPercentage = 0;
  late WebViewController _webViewController;

  @override
  void initState() {
    _webViewController = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
      ))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.url));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PrimaryAppbar(title: widget.title),
      body: Stack(
        children: [
          WebViewWidget(
            controller: _webViewController,
          ),
          if (loadingPercentage < 100)
            LinearProgressIndicator(
              value: loadingPercentage / 100.0,
            ),
        ],
      ),
    );
  }
}
