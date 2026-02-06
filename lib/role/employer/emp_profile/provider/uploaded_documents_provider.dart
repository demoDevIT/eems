import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../repo/common_repo.dart';
import '../../../../utils/user_new.dart';

class UploadedDocumentsProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  UploadedDocumentsProvider({required this.commonRepo});

  final UserData _userData = UserData();
  get userModel => _userData.model.value;

  /// PDFs
  List<String> pdfUrls = [];

  /// Image
  String? imageUrl;

  bool isLoading = false;
  String? apiMessage;

  Future<void> loadUploadedDocuments({
    required String userId,
  }) async {
    isLoading = true;
    notifyListeners();

    final body = {
      "ActionName": "UploadedDoc",
      "UserID": userId,
    };

    final apiResponse =
    await commonRepo.post("Employer/GetEmployerDetail", body);

    if (apiResponse.response?.statusCode == 200) {
      var responseData = apiResponse.response?.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      final List dataList = responseData["Data"] ?? [];

      pdfUrls.clear();
      imageUrl = null;

      for (var e in dataList) {
        final path = e["DocumentPath"] as String?;

        if (path == null) continue;

        if (path.toLowerCase().endsWith(".pdf")) {
          pdfUrls.add(path);
        } else if (
        path.toLowerCase().endsWith(".jpg") ||
            path.toLowerCase().endsWith(".jpeg") ||
            path.toLowerCase().endsWith(".png")) {
          imageUrl = path; // ✅ only one image expected
        }
      }
    }

    isLoading = false;
    notifyListeners();
  }

  /// 🔽 Download & open PDF
  Future<void> downloadAndOpenPdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();
        final filePath =
            "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.pdf";

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        await OpenFile.open(filePath);
      }
    } catch (e) {
      debugPrint("PDF download error: $e");
    }
  }
}
