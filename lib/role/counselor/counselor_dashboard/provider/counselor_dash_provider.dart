import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/global.dart';
import '../../../../utils/user_new.dart';
import '../../../../utils/utility_class.dart';
import '../../../job_seeker/job_fair_event/modal/running_event_modal.dart';

class CounselorDashProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  CounselorDashProvider({required this.commonRepo});

  List<RunningEventData> currentEventList = [];

  Future<void> getCurrentEvents(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();

    if (!isInternet) {
      showAlertError(
        AppLocalizations.of(context)!.internet_connection,
        context,
      );
      return;
    }

    try {
      Map<String, dynamic> body = {
        "ActionName": "Running_Events",
        "UserId": UserData().model.value.userId.toString(),
        "RoleId": UserData().model.value.roleId.toString(),
        "FromDate": "",
        "EndDate": "",
        "FinancialYearID": 0
      };

      ApiResponse response = await commonRepo.post(
        "JobFairEvent/GetAllJobFairEventsList",
        body,
      );

      if (response.response?.statusCode == 200) {
        var data = response.response?.data;

        if (data is String) {
          data = jsonDecode(data);
        }

        RunningEventModal modal =
        RunningEventModal.fromJson(data);

        currentEventList.clear();

        if (modal.state == 200) {
          currentEventList.addAll(modal.data ?? []);
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}