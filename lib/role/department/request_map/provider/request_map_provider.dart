import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../repo/common_repo.dart';
import '../../../../utils/global.dart';
import '../../../../utils/progress_dialog.dart';

class RequestMapProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  RequestMapProvider({required this.commonRepo});


  final TextEditingController ssoIdController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController aadhaarNameController = TextEditingController();
  final TextEditingController presentDeptController = TextEditingController();
  final TextEditingController internshipDeptController = TextEditingController();

  final TextEditingController remarksController = TextEditingController();

  bool isSubmitEnabled = true;
  String statusMessage = "";

  Future<void> getDMapRequestStatus(BuildContext context) async {
    try {
      Map<String, dynamic> body = {
        "UserRoleRightID": UserData().model.value.userRoleRightID,
        "UserID": UserData().model.value.userId,
        "RoleID": UserData().model.value.roleId,
        "remarks": "",
      };

      final apiResponse = await commonRepo.post(
        "Common/GetDMapUserRequest",
        body,
      );

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response?.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        if (responseData["Data"] != null &&
            responseData["Data"] is List &&
            responseData["Data"].isNotEmpty) {

          final data = responseData["Data"][0];

          // statusMessage = data["StatusMessage"] ?? "";
          //
          // if (statusMessage == "User D-Mapped Request Sent") {
          //   isSubmitEnabled = false;
          // } else {
          //   isSubmitEnabled = true;
          //   statusMessage = "";
          // }

          final int dmapUserFlag = data["DmapUserFlag"] ?? 0;

          if (dmapUserFlag == 1) {
            statusMessage = data["StatusMessage"] ?? "";
            isSubmitEnabled = false;
          } else {
            statusMessage = "";
            isSubmitEnabled = true;
          }

        } else {
          isSubmitEnabled = true;
          statusMessage = "";
        }

        notifyListeners();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> getRequestMapDetails(BuildContext context) async {
    try {
      // API Call

      ssoIdController.text = UserData().model.value.sso; //"SSO123";
      nameController.text = UserData().model.value.displayName; //"Test User";
      mobileController.text = UserData().model.value.mobileNo; //"9876543210";
      aadhaarNameController.text = UserData().model.value.nameAsPerAadhar; //"Test User";
      presentDeptController.text = UserData().model.value.deptNameEn; //"IT Department";
      internshipDeptController.text = UserData().model.value.office; // "Employment Department";

      notifyListeners();
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> submitRequest(BuildContext context) async {

    if (remarksController.text.trim().isEmpty) {
      showAlertError("Please enter remark", context);
      return;
    }

    try {
      Map<String, dynamic> body = {
        "UserRoleRightID": UserData().model.value.userRoleRightID,
        "UserID": UserData().model.value.userId,
        "RoleID": UserData().model.value.roleId,
        "remarks": remarksController.text.trim(),
      };

      print("========== DMAP REQUEST PAYLOAD ==========");
      print(body);
      print("==========================================");

      ProgressDialog.showLoadingDialog(context);

      final apiResponse = await commonRepo.post(
        "Common/DmapUser",
        body,
      );

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response?.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        print("========== DMAP REQUEST RESPONSE ==========");
        print(responseData);
        print("===========================================");

        String message = responseData["Data"] != null &&
            responseData["Data"] is List &&
            responseData["Data"].isNotEmpty
            ? responseData["Data"][0]["Message"] ?? "Success"
            : responseData["Message"] ?? "Success";

        await getDMapRequestStatus(context);

        showAlertSuccess(
          "Request Submitted Successfully",
          context,
        );
      } else {
        showAlertError("Something went wrong", context);
      }
    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
    }
  }

  @override
  void clearData() {
    remarksController.clear();
  }
}