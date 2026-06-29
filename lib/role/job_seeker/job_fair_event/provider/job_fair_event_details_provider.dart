import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/utility_class.dart';
import 'package:url_launcher/url_launcher.dart';

class JobFairEventDetailsProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  JobFairEventDetailsProvider({required this.commonRepo});

  bool isLoading = false;

  String apiMessage = "";

  //String apiMessage = "";
  String encEventId = "";
  bool isRegisteredOrAlreadyRegistered = false;

  Future<bool> registerJobFairEvent(
      BuildContext context,
      int eventId,
      ) async {

    apiMessage = "";
    encEventId = "";
    isRegisteredOrAlreadyRegistered = false;
    isLoading = true;
    notifyListeners();

    try {

      /// ✅ Get dynamic userId
      String userId =
      UserData().model.value.userId.toString();
      String roleId =
      UserData().model.value.roleId.toString();
      String? deviceId = await UtilityClass.getDeviceId();

      Map<String, dynamic> body = {
        "UserId": userId,
        "RoleId": roleId,
        "EventId": eventId,
        "DeviceId": deviceId
      };

      /// ✅ Dynamic URL
      String url =
          "JobFairEvent/JobFairEventRegistration/";
        //  "$userId/$roleId/$eventId/$deviceId";

      ApiResponse apiResponse =
      await commonRepo.post(url, body);

      if (apiResponse.response?.statusCode == 200) {

        var responseData =
            apiResponse.response?.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        // bool status = responseData["Status"] ?? false;
        //
        // apiMessage = responseData["Message"] ?? "";
        //
        // isLoading = false;
        // notifyListeners();
        // return true;

        bool status = responseData["Status"] ?? false;

        if (responseData["Data"] != null &&
            responseData["Data"] is List &&
            responseData["Data"].isNotEmpty) {

          apiMessage =
              responseData["Data"][0]["MSG"]?.toString() ?? "";

          encEventId =
              responseData["Data"][0]["EncEventId"]?.toString() ?? "";

          isRegisteredOrAlreadyRegistered = true;
        } else {
          apiMessage = responseData["Message"] ?? "";
        }

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
