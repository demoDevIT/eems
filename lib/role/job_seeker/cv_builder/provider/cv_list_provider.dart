import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:rajemployment/role/job_seeker/grievance/module/grievance_modal.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../modal/all_cv_template_list_modal.dart';
import '../modal/color_code_modal.dart';

class CvListProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  CvListProvider({required this.commonRepo});

  List<AllCVTemplateListData>  allCvList = [];
  List<ColorCodeData>  colorCodeList = [];
  String templateHtml = "";

  bool isLoading = false;
  String apiMessage = "";

  Future<void> downloadCvByUserId(BuildContext context) async {
    apiMessage = "";
    isLoading = true;
    notifyListeners();

    try {
      String url =
          "https://eems.devitsandbox.com/mobileapi/api/CvTemplate/CvBuilderDownloadByUserid";

      Map<String, dynamic> body = {
        "UserID": UserData().model.value.userId.toString(), //8253
      };

      ApiResponse apiResponse = await commonRepo.post(url, body);

      isLoading = false;

      if (apiResponse.response != null &&
          apiResponse.response?.statusCode == 200) {

        var responseData = apiResponse.response?.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        final dataList = responseData["Data"] as List;

        if (dataList.isNotEmpty) {
          final cvPath = dataList[0]["CVPath"] ?? "";
          final message = dataList[0]["Message"] ?? "";

          if (cvPath.toString().isNotEmpty) {
            /// OPEN PDF
            final fullUrl =
                "https://eems.devitsandbox.com$cvPath";
            await OpenFile.open(fullUrl);
          } else {
            /// SHOW MESSAGE
            apiMessage = message;
          }
        }
      } else {
        apiMessage = "Something went wrong. Please try again.";
      }
    } catch (e) {
      isLoading = false;
      apiMessage = e.toString();
    }

    notifyListeners();
  }

  String htmlToBase64(String html) {
    final bytes = utf8.encode(html);
    return base64.encode(bytes);
  }

  Future<void> saveAndOpenPdf(BuildContext context, String base64String, String fileName) async {
    try {
      print(fileName);
      print(base64String);
      // Decode base64 string
      final bytes = base64Decode(base64String);

      // Get temporary directory
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');

      // Write the PDF bytes to the file
      await file.writeAsBytes(bytes);
      // Open the PDF
      // openPdfFile(context,file.path + ".pdf");
      await OpenFile.open(file.path);
    } catch (e) {
      print('Error saving/opening PDF: $e');
    }
  }


  void openHtmlAsPdf(String htmlContent) async {
    try {
      // Directly opens the PDF in a preview
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async {
          return await Printing.convertHtml(
            html: htmlContent,
            format: format,
          );
        },
      );
    } catch (e) {
      print("Error generating PDF: $e");
    }
  }

  clearData(){
    allCvList.clear();
    colorCodeList.clear();
    notifyListeners();
  }



  @override
  void dispose() {
    super.dispose();
  }


}
