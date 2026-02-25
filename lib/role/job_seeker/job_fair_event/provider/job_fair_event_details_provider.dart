import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/utility_class.dart';

class JobFairEventDetailsProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  JobFairEventDetailsProvider({required this.commonRepo});

  bool isLoading = false;

  String apiMessage = "";

  Future<bool> registerJobFairEvent(
      BuildContext context,
      int eventId,
      ) async {

    apiMessage = "";
    isLoading = true;
    notifyListeners();

    try {

      /// ✅ Get dynamic userId
      String userId =
      UserData().model.value.userId.toString();
      String roleId =
      UserData().model.value.roleId.toString();
      String? deviceId = await UtilityClass.getDeviceId();

      /// ✅ Dynamic URL
      String url =
          "JobFairEvent/JobFairEventRegistration/"
          "$userId/$roleId/$eventId/$deviceId";

      ApiResponse apiResponse =
      await commonRepo.post(url, {});

      if (apiResponse.response?.statusCode == 200) {

        var responseData =
            apiResponse.response?.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        apiMessage =
            responseData["Message"] ??
                "Registration Successful";

        isLoading = false;
        notifyListeners();
        return true;

      } else { // if response is -2 than msg will be 'already registered'
        apiMessage =
        "Something went wrong. Please try again.";
      }

    } catch (e) {
      apiMessage = e.toString();
    }

    isLoading = false;
    notifyListeners();
    return false;
  }

}
