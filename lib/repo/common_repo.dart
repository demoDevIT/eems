import 'package:dio/dio.dart';

import '../api_service/datasource/remote/dio/dio_client.dart';
import '../api_service/datasource/remote/exception/api_error_handler.dart';
import '../api_service/model/base/api_response.dart';


class CommonRepo {
  final DioClient dioClient;

  CommonRepo({
    required this.dioClient,
  });

  Future<ApiResponse> get(String url) async {
    print("1111==>$url");
    try {
      print("2222==>$url");
      Response response = await dioClient.get(url);
      print("5555==>$response");
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> post(String url,Map<String, dynamic> data) async {
    try {
      Response response = await dioClient.post(url, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }


  Future<ApiResponse> post1(String url,var data) async {
    try {
      Response response = await dioClient.post(url, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
  Future<ApiResponse> postArray(String url,List<Map<String, dynamic>> data) async {
    try {
      Response response = await dioClient.post(url, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> delete(String url,Map<String, dynamic> data) async {
    try {
      Response response = await dioClient.delete(url, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> put(String url,Map<String, dynamic> data) async {
    try {
      Response response = await dioClient.put(url, data: data);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<ApiResponse> uploadDocumentRepo(String url,FormData inputText) async {
    try {
      Response response =
      await dioClient.post(url, data: inputText);
      return ApiResponse.withSuccess(response);
    } catch (e) {
      print(ApiErrorHandler.getMessage(e));
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<Response> postRequestMultipart(
      String endpoint, FormData formData) async {
    print("1122POST Multipart Started: $endpoint");
    try {
      final response = await dioClient.post(
        endpoint,
        data: formData,
        options: Options(headers: {"Content-Type": "multipart/form-data"}),
      );
      print("APIIIIIIIIIIIIIIress->$response");
      return response;
    } on DioError catch (e) {
      print("3344Multipart Error: ${e.message}");
      throw Exception(e.message);
    }
  }
}
