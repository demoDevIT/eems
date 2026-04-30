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
import '../modal/counselor_info_modal.dart';

class CounselorProfileProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  CounselorProfileProvider({required this.commonRepo});

  List<CounselorInfoData> counselorData = [];

  Future<CounselorInfoModal?> getCounselorDetailsApi(
      BuildContext context, String userId, int? roleId) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {
          "ActionName": "CounselorprofileBasicDetails",
          "UserID": userId
        };
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse =
        await commonRepo.post("Employer/GetEmployerDetail", body);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response?.statusCode == 200) {
          dynamic responseData = apiResponse.response!.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }

          final sm = CounselorInfoModal.fromJson(responseData);
          counselorData.clear();

          if (sm.state == 200 && sm.data != null) {
            counselorData.addAll(sm.data!);
          }

          notifyListeners();
          return sm;
        } else {
          notifyListeners();
          return CounselorInfoModal(
              state: 0, message: "Something went wrong");
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = CounselorInfoModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

}
