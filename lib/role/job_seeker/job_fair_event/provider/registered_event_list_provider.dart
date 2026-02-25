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

  String? fromDateApi;
  String? toDateApi;

  Future<RegisteredEventsModal?> allJobMatchingListApi(
      BuildContext context, {
        String? fromDate,
        String? endDate,
      }) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        // Map<String, dynamic> bodyy = {
        //   "ActionName": "RegisteredEvents",
        //   "UserId": UserData().model.value.userId.toString(),
        //   "RoleId": UserData().model.value.roleId.toString(),
        //   "FromDate": fromDate ?? "",
        //   "EndDate": endDate ?? "",
        //   "FinancialYearID": 0,
        // };
        //
        // ProgressDialog.showLoadingDialog(context);
        //
        // ApiResponse apiResponse =
        // await commonRepo.post("Dashboard/GetAllJobFairEventsList", bodyy);

      //  https://eems.devitsandbox.com/mobileapi/api/JobFairEvent/GetAllJobFairEventsList/?_actionName=GetRegisteredEventsByDate&UserId=2261605&Roleid=4&FromDate=&EndDate=

        String userId = UserData().model.value.userId.toString();
        String roleId = UserData().model.value.roleId.toString();

        String url =
            "https://eems.devitsandbox.com/mobileapi/api/JobFairEvent/GetAllJobFairEventsList/"
            "?_actionName=GetRegisteredEventsByDate"
            "&UserId=$userId"
            "&Roleid=$roleId"
            "&FromDate=$fromDate"
            "&EndDate=$endDate";

        ProgressDialog.showLoadingDialog(context);

        ApiResponse apiResponse = await commonRepo.post(url,{});

        ProgressDialog.closeLoadingDialog(context);

        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
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
            notifyListeners();
            return RegisteredEventsModal(
                state: 0, message: sm.message.toString());
          }
        } else {
          return RegisteredEventsModal(
              state: 0, message: 'Something went wrong');
        }
      } catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        showAlertError(err.toString(), context);
        return RegisteredEventsModal(state: 0, message: err.toString());
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
    return null;
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
