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
import '../modal/running_event_modal.dart';

class JobsFairEventProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  JobsFairEventProvider({required this.commonRepo});

  bool tab = true;

  final List<Map<String, String>> jobFairList = [
    {
      "name": "Annual District-wide job fair for all sectors",
      "description": "The State Level Job Fair is a large-scale recruitment and networking.....",
      "date": "End On 24-Mar-2026",
      "type": "Current",
    },
    {
      "name": "C.M. Job Fair",
      "description": "The State Level Job Fair is a large-scale recruitment and networking.....",
      "date": "End On 24-Mar-2026",
      "type": "Current",
    },
    {
      "name": "Rajasthan IT Job Fair",
      "description": "The State Level Job Fair is a large-scale recruitment and networking.....",
      "date": "End On 24-Mar-2026",
      "type": "Current",
    },
    {
      "name": "Annual District-wide job fair for all sectors",
      "description": "The State Level Job Fair is a large-scale recruitment and networking.....",
      "date": "End On 24-Mar-2026",
      "type": "Current",
    },
    {
      "name": "C.M. Job Fair",
      "description": "The State Level Job Fair is a large-scale recruitment and networking.....",
      "date": "End On 24-Mar-2026",
      "type": "Current",
    },
    {
      "name": "Rajasthan IT Job Fair",
      "description": "The State Level Job Fair is a large-scale recruitment and networking.....",
      "date": "End On 24-Mar-2026",
      "type": "Current",
    },
    {
      "name": "Annual District-wide job fair for all sectors",
      "description": "The State Level Job Fair is a large-scale recruitment and networking.....",
      "date": "End On 24-Mar-2026",
      "type": "Current",
    },
    {
      "name": "C.M. Job Fair",
      "description": "The State Level Job Fair is a large-scale recruitment and networking.....",
      "date": "End On 24-Mar-2026",
      "type": "Current",
    },
    {
      "name": "Rajasthan IT Job Fair",
      "description": "The State Level Job Fair is a large-scale recruitment and networking.....",
      "date": "End On 24-Mar-2026",
      "type": "Current",
    },
    {
      "name": "Annual District-wide job fair for all sectors",
      "description": "The State Level Job Fair is a large-scale recruitment and networking.....",
      "date": "End On 24-Mar-2026",
      "type": "Current",
    },
    {
      "name": "C.M. Job Fair",
      "description": "The State Level Job Fair is a large-scale recruitment and networking.....",
      "date": "End On 24-Mar-2026",
      "type": "Current",
    },
    {
      "name": "Rajasthan IT Job Fair",
      "description": "The State Level Job Fair is a large-scale recruitment and networking.....",
      "date": "End On 24-Mar-2026",
      "type": "Current",
    },

  ];


  List<RunningEventData> currentEventList = [];
  List<RunningEventData> upcomingList = [];



  Future<RunningEventModal?> allJobMatchingListApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
      return null;
    }

    try {
      String actionName = tab ? "Running_Events" : "Upcoming_Events";

      String userId = UserData().model.value.userId.toString();
      String roleId = UserData().model.value.roleId.toString();

      String url =
          "https://eems.devitsandbox.com/mobileapi/api/JobFairEvent/GetAllJobFairEventsList/"
          "?_actionName=$actionName"
          "&UserId=$userId"
          "&Roleid=$roleId"
          "&FromDate="
          "&EndDate=";

      ProgressDialog.showLoadingDialog(context);

     // ApiResponse apiResponse = await commonRepo.get(url); // <-- use GET
      ApiResponse apiResponse = await commonRepo.post(url,{});

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response != null &&
          apiResponse.response?.statusCode == 200) {

        var responseData = apiResponse.response?.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        final sm = RunningEventModal.fromJson(responseData);

        currentEventList.clear();
        upcomingList.clear();

        if (responseData["State"] == 200) {
          if (tab) {
            currentEventList.addAll(sm.data ?? []);
          } else {
            upcomingList.addAll(sm.data ?? []);
          }

          notifyListeners();
          return sm;
        } else {
          showAlertError(responseData["Message"] ?? "Something went wrong", context);
          return sm;
        }
      } else {
        return RunningEventModal(
          state: 0,
          message: "Something went wrong",
        );
      }
    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
      return RunningEventModal(state: 0, message: e.toString());
    }
  }


  clearData(){
    currentEventList.clear();
    upcomingList.clear();
    notifyListeners();

  }


  @override
  void dispose() {
    super.dispose();
  }


}
