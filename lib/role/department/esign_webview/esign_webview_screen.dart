import 'package:flutter/material.dart';
import 'package:rajemployment/utils/utility_class.dart';
import 'package:webview_flutter/webview_flutter.dart';

class EsignWebViewScreen extends StatefulWidget {
  final String htmlData;

  const EsignWebViewScreen({
    super.key,
    required this.htmlData,
  });

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
          onPageStarted: (url) async {
           // await UtilityClass.showProgressDialog(context, "");
          },
          onPageFinished: (url) async {
            debugPrint("Page Finished: $url");
           // await UtilityClass.dismissProgressDialog();

          },
          onNavigationRequest: (NavigationRequest request) {
            debugPrint("Navigation URL: ${request.url}");

            if (request.url.toLowerCase().contains("success")) {
              Future.delayed(const Duration(seconds: 5), () {
                  Navigator.pop(context, request.url);
              });
              return NavigationDecision.navigate;
            }

            if (request.url.toLowerCase().contains("failed")) {
              Future.delayed(const Duration(seconds: 5), () {
                if (mounted) {
                  Navigator.pop(context, request.url);
                }
              });
              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },
          onWebResourceError: (WebResourceError error) async {
            debugPrint("WebView Error: ${error.description}");
          //  await UtilityClass.dismissProgressDialog();

          },
        ),
      )
      ..loadHtmlString(widget.htmlData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("eSign"),
      ),
      body: WebViewWidget(
        controller: controller,
      ),
    );
  }
}