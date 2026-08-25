import 'package:flutter/material.dart';
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
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            debugPrint('START: $url');
          },
          onPageFinished: (String url) {
            debugPrint('FINISHED: $url');
          },
          onNavigationRequest: (NavigationRequest request) {
            final String url = request.url;

            debugPrint('NAVIGATION URL: $url');

            final String lowerUrl = url.toLowerCase();

            if (lowerUrl.contains('success')) {
              if (mounted) {
                Navigator.pop(context, url);
              }

              return NavigationDecision.prevent;
            }

            if (lowerUrl.contains('failed')) {
              if (mounted) {
                Navigator.pop(context, url);
              }

              return NavigationDecision.prevent;
            }

            return NavigationDecision.navigate;
          },

          onSslAuthError: (SslAuthError error) {
            error.proceed();
          },
          onWebResourceError: (WebResourceError error) {
          },
        ),
      )
      ..loadHtmlString(
        widget.htmlData,
        baseUrl: 'https://esign.rajasthan.gov.in/',
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('eSign'),
      ),
      body: SafeArea(
        child: WebViewWidget(
          controller: controller,
        ),
      ),
    );
  }
}