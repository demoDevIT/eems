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
    if (isInternet) {
      try {
        Map<String, dynamic> bodyy =
        {
          "ActionName": tab == true ? "Running Events" : "Upcoming Events",
          "UserId": UserData().model.value.userId.toString(),
          "RoleId":  UserData().model.value.roleId.toString(),
          "FromDate": "string",
          "EndDate": "string",
          "FinancialYearID": 0

        };
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post("Dashboard/GetAllJobFairEventsList",bodyy);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = RunningEventModal.fromJson(responseData);
          currentEventList.clear();
          upcomingList.clear();
          if (sm.state == 200) {
            if(tab == true){
              currentEventList.addAll(sm.data!);
            }else{
              upcomingList.addAll(sm.data!);
            }

            notifyListeners();
            return sm;
          } else {
            final smmm = RunningEventModal(state: 0, message: sm.message.toString());
            notifyListeners();
           // showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return RunningEventModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = RunningEventModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
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
