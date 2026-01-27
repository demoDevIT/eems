import 'dart:io';

import 'package:http/http.dart' as flutter_http;

class ServiceClass {
  static Future<void> getRequest() async {
    // Set the HttpOverrides before making the request
    // HttpOverrides.global = MyHttpOverrides();
    // await Future.delayed(const Duration(seconds: 1));
    final response = await flutter_http.get(Uri.parse('http://10.130.19.44/api/values'));
    //headers: {'Access-Control-Allow-Origin': '*'}
    if (response.statusCode == 200) {
      print(response.body.toString());
    } else {
      print(response.reasonPhrase);
    }
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    final client = super.createHttpClient(context);
    client.badCertificateCallback = (cert, host, port) => true;
    return client;
  }
}