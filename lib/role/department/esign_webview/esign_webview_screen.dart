import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EsignWebViewScreen extends StatefulWidget {
  final String htmlData;

  const EsignWebViewScreen({super.key, required this.htmlData});

  @override
  State<EsignWebViewScreen> createState() => _EsignWebViewScreenState();
}

class _EsignWebViewScreenState extends State<EsignWebViewScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            print("URL => ${request.url}");

            /// 🔥 Step 7 (handle redirect)
            if (request.url.contains("GetESignResponse")) {
              Navigator.pop(context, request.url);
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadHtmlString(widget.htmlData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("eSign")),
      body: WebViewWidget(controller: controller),
    );
  }
}