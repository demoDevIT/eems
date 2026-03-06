import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/global.dart';
import '../../../../utils/location_service.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../../dept_join_attendance_list/dept_join_attendance_list.dart';
import '../../dept_join_pending_list/dept_join_pending_list.dart';

class DeptQRScanProvider extends ChangeNotifier {

  final CommonRepo commonRepo;

  DeptQRScanProvider({required this.commonRepo});

  Future<void> handleQRCode(BuildContext context, String rawData) async {
    print("QR Raw Data-=======>: $rawData");
    try {

      ProgressDialog.showLoadingDialog(context);

      final decoded = jsonDecode(rawData);

      String userId = decoded['UserId'];
      String jobseekerId = decoded['JobseekerId'];

      print("UserId===>: $userId");
      print("JobseekerId===>: $jobseekerId");

      await getMysyInternStatusApi(context, userId, jobseekerId);

    } catch (e) {

      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);

    }
  }

  Future<void> getMysyInternStatusApi(
      BuildContext context,
      String userId,
      String jobseekerId,
      ) async {

    var isInternet = await UtilityClass.checkInternetConnectivity();

    if (!isInternet) {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
      return;
    }

    try {

      Map<String, dynamic> body = {
        "RegistrationNumber": null,
        "JobSeekerID": jobseekerId, //11309400
        "UserID": userId, //265610
      };

      print("API Request Body: $body");

      ApiResponse apiResponse = await commonRepo.post(
        "Jobseeker/GetMYSYInternStatus",
        body,
      );

      if (apiResponse.response?.statusCode == 200) {

        dynamic responseData = apiResponse.response!.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        print("API Response: $responseData");

        // final state = responseData['State'];
        // final message = responseData['Message'];
        // final status = responseData['Status'];
        //
        // print("State: $state");
        // print("Message: $message");
        // print("Status: $status");
        //
        // if (responseData['Data'] != null) {
        //   print("Intern Status: ${responseData['Data'][0]['Status']}");
        // }

        String status = responseData['Data'][0]['Status'];

        print("Intern Status: $status");

        /// ===== Navigation based on status =====

        if (status == "Get Pending Attendance List") {

          ProgressDialog.closeLoadingDialog(context);

          await Future.delayed(const Duration(milliseconds: 200));

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DeptJoinAttendanceListScreen(
                registrationNumber: null,
                jobSeekerId: jobseekerId,
                userId: userId,
              ),
            ),
          );
        } else if (status == "Pending for Approval") {

          ProgressDialog.closeLoadingDialog(context);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              //builder: (_) => const DeptJoinPendingListScreen(),
              builder: (_) => DeptJoinPendingListScreen(
                registrationNumber: null,
                jobSeekerId: jobseekerId, // 11309400
                userId: userId, //265610
              ),
            ),
          );

        } else {

          ProgressDialog.closeLoadingDialog(context);
          showAlertError("Unknown status: $status", context);

        }

      } else {
        print("API Error: ${apiResponse.response?.statusCode}");
      }

    } catch (e) {
      showAlertError(e.toString(), context);
    }
  }
}