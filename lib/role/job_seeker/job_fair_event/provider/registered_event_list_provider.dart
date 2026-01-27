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
import '../modal/registered_events_modal.dart';

class RegisteredEventListProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  RegisteredEventListProvider({required this.commonRepo});

  List<RegisteredEventsData> registeredEventListList = [];



  Future<RegisteredEventsModal?> allJobMatchingListApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> bodyy =
        {
          "ActionName": "RegisteredEvents",
          "UserId": UserData().model.value.userId.toString(),
          "RoleId": UserData().model.value.roleId.toString(),
          "FromDate": "string",
          "EndDate": "string",
          "FinancialYearID": 0,
        };
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post("Dashboard/GetAllJobFairEventsList",bodyy);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = RegisteredEventsModal.fromJson(responseData);
          registeredEventListList.clear();
          if (sm.state == 200) {
            registeredEventListList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = RegisteredEventsModal(state: 0, message: sm.message.toString());
            notifyListeners();
            //showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return RegisteredEventsModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = RegisteredEventsModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  clearData(){
    registeredEventListList.clear();
    notifyListeners();

  }



  @override
  void dispose() {
    super.dispose();
  }


}
