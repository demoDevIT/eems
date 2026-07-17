import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../repo/common_repo.dart';

class AllotDeptProvider extends ChangeNotifier {
  final CommonRepo commonRepo;
  AllotDeptProvider({required this.commonRepo});

  Future<void> downloadAndOpenPdf(String url) async {
    try {
      debugPrint("PDF URL: $url");

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();

        final filePath =
            "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.pdf";

        final file = File(filePath);

        await file.writeAsBytes(response.bodyBytes);

        await OpenFile.open(filePath);
      } else {
        debugPrint(
          "Failed to download PDF. Status Code: ${response.statusCode}",
        );
      }
    } catch (e) {
      debugPrint("PDF download/open error: $e");
    }
  }
}