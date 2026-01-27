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



  Future<AllCVTemplateListModal?> getAllCVTemplateListApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String ? IpAddress =  await UtilityClass.getIpAddress();

        Map<String, dynamic> bodyy =
        {
          "TemplateId":0,
          "HeadshotType":0,
          "ColumnsType":0,
          "ClourId":0,
          "TradeId":0,
          "UserID":324
        };

        String url = "https://eems.devitsandbox.com/api/api/CVTemplate/GetAllCVTemplateList";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post(url,bodyy);
       ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = AllCVTemplateListModal.fromJson(responseData);
          if (sm.state == 1) {
            allCvList.clear();
            allCvList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = AllCVTemplateListModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return AllCVTemplateListModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = AllCVTemplateListModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<ColorCodeModal?> getColorCodeListApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String ? IpAddress =  await UtilityClass.getIpAddress();
        String url = "https://eems.devitsandbox.com/api/api/CVTemplate/GetAllColourCode";
        //ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
       // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = ColorCodeModal.fromJson(responseData);
          if (sm.state == 1) {
            colorCodeList.clear();
            colorCodeList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = ColorCodeModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return ColorCodeModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //ProgressDialog.closeLoadingDialog(context);
        final sm = ColorCodeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }



  updateTemplate(int index, String oldColourCode, String newColor) {
    // Clean values (remove # if present)
    final oldClean = oldColourCode.replaceAll("", "");
    final newClean = newColor.replaceAll("", "");

    final html = allCvList[index].templateHtml.replaceAll(oldClean, newClean);

    // Save updated html
    allCvList[index].templateHtml = html;
    // IMPORTANT: Update the stored colour
    allCvList[index].colourCode = newClean;

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
