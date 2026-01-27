import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:rajemployment/utils/utility_class.dart';

// class HttpService {
//   late Dio _dio;
//   // , "Authorization" : "Bearer ${StaticVariables.authToken}"
//   HttpService(BuildContext context, String baseUrl) {
//     _dio = Dio(BaseOptions(
//       baseUrl: baseUrl,
//       //  headers: {"Content-Type": "application/json", "Authorization" : "Bearer ${StaticVariables.authToken}"},
//       headers: {"Content-Type": "application/json"},
//       connectTimeout: const Duration(milliseconds: 120000),
//         // receiveTimeout: const Duration(milliseconds: 120000),
//     ));
//
//     (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
//         (HttpClient client) {
//       client.badCertificateCallback =
//           (X509Certificate cert, String host, int port) => true;
//       return client;
//     };
//
//     initializeInterceptors(context);
//   }
//
//   Future<Response> getRequest(String endPoint) async{
//     debugPrint("Call Started!");
//     Response response;
//
//     try {
//       response = await _dio.get(endPoint);
//       debugPrint(response.data.toString());
//     } on DioError catch (e) {
//       debugPrint(e.message);
//       throw Exception(e.message);
//     }
//
//     return response;
//
//   }
//   Future<Response> postRequest(String endpoint, dynamic param) async{
//     debugPrint("Call Started!");
//     Response response;
//     try {
//       response = await _dio.post(endpoint, data: json.encode(param));
//     } on DioError catch (e) {
//       debugPrint(e.message);
//       throw Exception(e.message);
//     }
//     return response;
//
//   }
//   Future<Response> postRequestMultipart(String endpoint, FormData formData,) async{
//     debugPrint("Call Started!");
//     Response response;
//     try {
//       response = await _dio.post(endpoint, data: formData,options: Options(headers: {"Content-Type": "multipart/form-data"}));
//     } on DioError catch (e) {
//       debugPrint(e.message);
//       throw Exception(e.message);
//     }
//     return response;
//
//   }
//
//   Future<Response> postRequest2(String endpoint, String requestBody, String soapAction) async {
//     debugPrint("SOAP Call Started!");
//     debugPrint("SOAP Call Started!${requestBody}");
//     final headers = {
//       "Content-Type": "text/xml; charset=utf-8",
//       "SOAPAction": soapAction,
//     };
//     Response response;
//     try {
//       response = await _dio.post(
//         endpoint,
//         data: requestBody,
//         options: Options(
//           headers: headers,
//           validateStatus: (status) {
//             return status! < 500; // Don't throw errors for 400-series responses
//           },
//         ),
//       );
//       debugPrint("SOAP Response: ${response.data}");
//     } on DioError catch (e) {
//       debugPrint("SOAP Error: ${e.message}");
//       throw Exception(e.message);
//     }
//     return response;
//   }
//
//
//   Future<Response> MultipartFilePostRequest(String endpoint, FormData formData) async{
//     debugPrint("Call Started!, FormData formData");
//      Options options = Options(headers: {'Content-Type': 'multipart/form-data',},);
//     Response response;
//     try {
//       response = await _dio.post(endpoint, data: formData,options:options);
//     } on DioError catch (e) {
//       debugPrint(e.message);
//       throw Exception(e.message);
//     }
//     return response;
//
//   }
//
//
//   Future<Response> ssoRequest(String baseUrl, String endpoint, dynamic param) async{
//     debugPrint("Call Started!");
//     Response response;
//     try {
//       response = await _dio.post(baseUrl+endpoint, data: param, options: Options(
//         // baseUrl: baseurl,
//         headers: {"Content-Type": "RS/x-www-form-urlencoded"},
//       ));
//     } on DioError catch (e) {
//       debugPrint(e.message);
//       throw Exception(e.message);
//     }
//     return response;
//
//   }
//
//   initializeInterceptors(BuildContext context) {
//     _dio.interceptors.add(InterceptorsWrapper(
//         onError: (error, handler){
//           debugPrint('onError: ${error.message}');
//           UtilityClass.dismissProgressDialog();
//           if(error.response?.statusCode == 401) {
//             UtilityClass.askForInput('Alert', 'You are not authorized.', 'Okay', 'Okay', true);
//           } else {
//             UtilityClass.askForInput( 'Alert', 'Some issue occurred while connecting with server. Please try again.', 'Okay', 'Okay', true);
//           }
//           return handler.reject(error); //.next(error);
//         },
//         onRequest: (request, handler){
//           debugPrint("onRequest: ${request.method} ${request.path}");
//           UtilityClass.showProgressDialog(context, 'Please wait...');
//           return handler.next(request);
//         },
//         onResponse: (response, handler){
//           debugPrint('onResponse: ${response.data.toString()}');
//           UtilityClass.dismissProgressDialog();
//           return handler.next(response);
//         }
//     ));
//   }
// }

class HttpService {
  late Dio _dio;

  HttpService(BuildContext context, String baseUrl) {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(milliseconds: 120000),
      validateStatus: (status) {
        // Accept all status codes below 500 (includes 302 redirects)
        return status != null && status < 500;
      },
      headers: {
        "Content-Type": "application/json",
      },
    ));

    // Allow self-signed/invalid certificates (for testing only!)
    (_dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate =
        (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      return client;
    };

    initializeInterceptors(context);
  }

  /// GET Request
  Future<Response> getRequest(String endPoint) async {
    debugPrint("GET Request Started: $endPoint");
    try {
      final response = await _dio.get(endPoint);
      return response;
    } on DioError catch (e) {
      debugPrint("GET Error: ${e.message}");
      throw Exception(e.message);
    }
  }

  /// POST Request (application/json)
  // Future<Response> postRequest(String endpoint, dynamic param) async {
  //   debugPrint("POST Request Started: $endpoint");
  //   try {
  //     final response = await _dio.post(endpoint, data: json.encode(param));
  //     return response;
  //   } on DioError catch (e) {
  //     debugPrint("POST Error: ${e.message}");
  //     throw Exception(e.message);
  //   }
  // }

  Future<Response> postRequest(String endpoint, dynamic param) async {
    debugPrint("Call Started!");
    debugPrint("URL: $endpoint");
    debugPrint("Data: ${json.encode(param)}");

    try {
      final response = await _dio.post(
        endpoint,
        data: json.encode(param),
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );
      debugPrint("Response: ${response.data}");
      return response;
    } on DioError catch (e) {
      debugPrint("❌ DioError occurred!");
      debugPrint("Type: ${e.type}");
      debugPrint("Message: ${e.message}");
      debugPrint("Error: ${e.error}");
      debugPrint("URI: ${e.requestOptions.uri}");
      debugPrint("Headers: ${e.requestOptions.headers}");
      debugPrint("Data: ${e.requestOptions.data}");
      debugPrint("Response: ${e.response}");
      throw Exception("Dio error: ${e.message}");
    }
  }

  /// POST Multipart Request
  Future<Response> postRequestMultipart(
      String endpoint, FormData formData) async {
    debugPrint("POST Multipart Started: $endpoint");
    try {
      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );
      return response;
    } on DioError catch (e) {
      debugPrint("Multipart Error: ${e.message}");
      throw Exception(e.message);
    }
  }

  /// POST Multipart Request (Alternate)
  Future<Response> MultipartFilePostRequest(
      String endpoint, FormData formData) async {
    debugPrint("MultipartFilePostRequest Started: $endpoint");
    try {
      final response = await _dio.post(
        endpoint,
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );
      return response;
    } on DioError catch (e) {
      debugPrint("MultipartFilePost Error: ${e.message}");
      throw Exception(e.message);
    }
  }

  /// SOAP Request
  Future<Response> postRequest2(
      String endpoint, String requestBody, String soapAction) async {
    debugPrint("SOAP Request Started: $endpoint");
    try {
      final headers = {
        "Content-Type": "text/xml; charset=utf-8",
        "SOAPAction": soapAction,
      };
      final response = await _dio.post(
        endpoint,
        data: requestBody,
        options: Options(headers: headers),
      );
      return response;
    } on DioError catch (e) {
      debugPrint("SOAP Error: ${e.message}");
      throw Exception(e.message);
    }
  }

  /// SSO Request
  Future<Response> ssoRequest(
      String baseUrl, String endpoint, dynamic param) async {
    debugPrint("SSO Request Started: $endpoint");
    try {
      final response = await _dio.post(
        baseUrl + endpoint,
        data: param,
        options: Options(
          headers: {"Content-Type": "RS/x-www-form-urlencoded"},
        ),
      );
      return response;
    } on DioError catch (e) {
      debugPrint("SSO Error: ${e.message}");
      throw Exception(e.message);
    }
  }

  void initializeInterceptors(BuildContext context) {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          debugPrint("onRequest: ${options.method} ${options.path}");
          UtilityClass.showProgressDialog(context, 'Please wait...');
          // // Add auth token dynamically
          // if (StaticVariables.authToken.isNotEmpty) {
          //   options.headers["Authorization"] = "Bearer ${StaticVariables.authToken}";
          // }
          return handler.next(options);
        },
        onResponse: (response, handler) async {
          UtilityClass.dismissProgressDialog();
          debugPrint('onResponse: ${response.statusCode} ${response.data}');
          // Handle redirect manually (optional)
          if (response.statusCode == 302 &&
              response.headers.value('location') != null) {
            final redirectUrl = response.headers.value('location')!;
            debugPrint('Redirecting to: $redirectUrl');
            final redirectedResponse = await _dio.get(redirectUrl);
            return handler.resolve(redirectedResponse);
          }
          return handler.next(response);
        },
        onError: (DioError error, handler) {
          UtilityClass.dismissProgressDialog();
          debugPrint('onError: ${error.message}');
          return handler.reject(error);
        },
      ),
    );
  }
}
