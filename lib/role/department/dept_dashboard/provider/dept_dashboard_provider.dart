import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/global.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../../dept_join_attendance_list/dept_join_attendance_list.dart';
import '../../dept_join_pending_list/dept_join_pending_list.dart';

class DepartmentDashboardProvider extends ChangeNotifier {
   final CommonRepo commonRepo;
   DepartmentDashboardProvider({required this.commonRepo});
  /// Future use:
  /// - API calls
  /// - Navigation logic
  /// - Badge counts (pending list count)

  bool showRegSearch = false;
  bool showResult = false;

  TextEditingController regNoController = TextEditingController();

   Future<void> searchByRegistration(BuildContext context) async {

     if (regNoController.text.isEmpty) {
       showAlertError("Please enter Registration Number", context);
       return;
     }

     var isInternet = await UtilityClass.checkInternetConnectivity();

     if (!isInternet) {
       showAlertError("No Internet Connection", context);
       return;
     }

     try {

       ProgressDialog.showLoadingDialog(context);

       Map<String, dynamic> body = {
         "RegistrationNumber": regNoController.text,
         "JobSeekerID": null,
         "UserID": null
       };

       print("API Request Body: $body");

       ApiResponse apiResponse = await commonRepo.post(
         "Jobseeker/GetMYSYInternStatus",
         body,
       );

       ProgressDialog.closeLoadingDialog(context);

       if (apiResponse.response?.statusCode == 200) {

         dynamic responseData = apiResponse.response!.data;

         if (responseData is String) {
           responseData = jsonDecode(responseData);
         }

         print("API Response: $responseData");

         String status = responseData['Data'][0]['Status'];

         print("Status: $status");

         /// Navigation based on status
         if (status == "Get Pending Attendance List") {

           Navigator.push(
             context,
             MaterialPageRoute(
               builder: (_) => const DeptJoinAttendanceListScreen(),
             ),
           );

         } else if (status == "Pending for Approval") {

           Navigator.push(
             context,
             MaterialPageRoute(
               builder: (_) => const DeptJoinPendingListScreen(),
             ),
           );

         } else {
           showAlertError("Unknown status: $status", context);
         }

       } else {
         showAlertError("Something went wrong", context);
       }

     } catch (e) {
       ProgressDialog.closeLoadingDialog(context);
       showAlertError(e.toString(), context);
     }
   }

  void openRegSearch() {
    showRegSearch = true;
    showResult = false;
    notifyListeners();
  }

  void submitSearch() {
    if (regNoController.text.isNotEmpty) {
      showResult = true; // static result for now
      notifyListeners();
    }
  }

  void onRegisterMYSY(BuildContext context) {
    debugPrint("Register yourself for MYSY clicked");
    // TODO: Navigate to MYSY registration page
  }

  void onPendingDepartmentJoining(BuildContext context) {
    debugPrint("Pending list for department joining clicked");
    // TODO: Navigate to pending list page
  }
}
