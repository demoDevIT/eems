import 'dart:io';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logging_interceptor.dart';

class DioClient {
  final String baseUrl;
  final LoggingInterceptor? loggingInterceptor;
  final SharedPreferences? sharedPreferences;

  late Dio dio;
  late String? token;

  DioClient(
      this.baseUrl,
      this.token,
      Dio dioC, {
        this.loggingInterceptor,
        this.sharedPreferences,
      }) {
    dio = dioC;

    // 🔥 ADD THIS
    (dio.httpClientAdapter as IOHttpClientAdapter).onHttpClientCreate = (HttpClient client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
       // print("⚠️ SSL Certificate bypassed for $host");
        return true; // allow all certificates
      };
      return client;
    };

    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = const Duration(milliseconds: 30000);
    dio.options.receiveTimeout = const Duration(milliseconds: 30000);

    dio.options.headers = {
      "Content-Type": "application/json",
      "Accept": "application/json"
    };

    if (token != null && token!.isNotEmpty) {
      dio.options.headers["X-AuthToken"] = token;
    }

    if (loggingInterceptor != null) {
      dio.interceptors.add(loggingInterceptor!);
    }
  }




  void updateHeader(String updateToken) {
    token = updateToken;
    dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    /*  'Authorization': 'Bearer $updateToken',*/
      'X-AuthToken': token, // 👈 Add here
      'Accept': 'application/json',
    };
  }

  Future<Response> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    print("3333==>$uri");
    try {
      var response = await dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      print("4444==>$response");
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

 /* Future<Response> post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }*/
  /*Future<Response> post(
      String uri, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      return await dio.post(
        uri,
        data: data, // 👈 no jsonEncode
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      rethrow;
    }
  }*/

  Future<Response> post(
      String uri, {
        dynamic data,
        Map<String, dynamic>? queryParameters,
        Options? options,
        CancelToken? cancelToken,
        ProgressCallback? onSendProgress,
        ProgressCallback? onReceiveProgress,
      }) async {
    try {
      return await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
    } catch (e) {
      if (e is DioException) {
        print("🔴 DIO ERROR TYPE: ${e.type}");
        print("🔴 DIO ERROR MESSAGE: ${e.message}");
        print("🔴 DIO ERROR RESPONSE: ${e.response?.data}");
        print("🔴 DIO ERROR STATUS: ${e.response?.statusCode}");
        print("🔴 REQUEST BODY: ${data}");
        print("🔴 REQUEST URL: ${dio.options.baseUrl}$uri");
      } else {
        print("🔴 UNKNOWN ERROR: $e");
      }
      rethrow;
    }
  }



  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      var response = await dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }
}
