import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../modal/about_app_modal.dart';

class AboutAppProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  AboutAppProvider({required this.commonRepo});

  List<AboutAppModalData>  aboutAppData = [];

  bool isLoading = false;

  Future<AboutAppModal?> getAboutAppApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        isLoading = true;
        notifyListeners(); // 🔥 trigger UI loader

        String ? IpAddress =  await UtilityClass.getIpAddress();

        Map<String, dynamic> bodyy =
        {
          "DynamicTypeID": 27,
          "DynamicUploadContentID": 0
        };

        String url = "Common/GetDynamicContentListAll";

        ApiResponse apiResponse = await commonRepo.post(url,bodyy);

        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = AboutAppModal.fromJson(responseData);
          print("Total records from API: ${sm.data?.length}");
          if (sm.state == 200) {
            aboutAppData.clear();
            aboutAppData.addAll(sm.data!);
            print("Total records in list: ${aboutAppData.length}");

          } else {
            showAlertError(sm.message ?? "Error", context);
          }
          isLoading = false;
          notifyListeners();
          return sm;
        } else {
          isLoading = false;
          notifyListeners();
          return AboutAppModal(state: 0, message: 'Something went wrong',
          );
        }
      }
      catch (err) {
        isLoading = false;
        notifyListeners();
        showAlertError(err.toString(), context);
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  clearData(){
    aboutAppData.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

}
