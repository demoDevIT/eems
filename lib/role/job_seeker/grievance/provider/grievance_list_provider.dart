import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/role/job_seeker/grievance/module/grievance_modal.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';

class GrievanceListProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  GrievanceListProvider({required this.commonRepo});

  List<GrievanceModalData>  grievanceDataList = [];



  Future<GrievanceModal?> getAllGrievanceApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String ? IpAddress =  await UtilityClass.getIpAddress();

        Map<String, dynamic> bodyy =
        {
          "GrievanceID": 0,
          "CategoryID": 0,
          "DepartmentID": 0,
          "ModuleID": 0,
          "RoleID":  UserData().model.value.roleId.toString(),
          "ComplainNo": "string",
          "StatusID": 0,
          "ModifyBy": 0,
          "CreatedBy": UserData().model.value.userId.toString()
        };

        String url = "MobileProfile/GetAllData";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post(url,bodyy);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = GrievanceModal.fromJson(responseData);
          if (sm.state == 200) {
            grievanceDataList.clear();
            grievanceDataList.addAll(sm.data!);

           notifyListeners();
            return sm;
          } else {
            final smmm = GrievanceModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return GrievanceModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = GrievanceModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  clearData(){
    grievanceDataList.clear();
    notifyListeners();
  }



  @override
  void dispose() {
    super.dispose();
  }


}
