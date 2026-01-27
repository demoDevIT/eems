import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rajemployment/utils/utility_class.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/global.dart';
import '../../empotr_form/empotr_form.dart';

class SansthaAadhaarFlowProvider with ChangeNotifier {
  final CommonRepo commonRepo;

  SansthaAadhaarFlowProvider({required this.commonRepo});

  /// Controllers
  final TextEditingController sansthaAadhaarController =
  TextEditingController();

  /// BRN Radio
  bool hasBrn = true;

  void setHasBrn(bool value) {
    hasBrn = value;
    notifyListeners();
  }

  /// ===============================
  /// SUBMIT SANSTHA AADHAAR / BRN API
  /// ===============================

  void submitSansthaAadhaarApi(
      BuildContext context,
      String ssoId,
      String userID,
      ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmpOTRFormScreen(
          ssoId: ssoId,
          userID: userID,
        ),
      ),
    );
  }


  // Future<void> submitSansthaAadhaarApi(
  //     BuildContext context,
  //     String ssoId,
  //     String userID,
  //     ) async {
  //   if (sansthaAadhaarController.text.isEmpty) {
  //     showAlertError("Please enter Sanstha Aadhaar / BRN number", context);
  //     return;
  //   }
  //
  //   var isInternet = await UtilityClass.checkInternetConnectivity();
  //   if (!isInternet) {
  //     showAlertError(
  //         AppLocalizations.of(context)!.internet_connection, context);
  //     return;
  //   }
  //
  //   try {
  //     ProgressDialog.showLoadingDialog(context);
  //
  //     /// API params
  //     Map<String, dynamic> body = {};
  //
  //     /// TODO: replace API once final
  //     ApiResponse apiResponse = await commonRepo.post(
  //       "SansthaAadhaar/ValidateSansthaAadhaar"
  //           "?ssoId=$ssoId"
  //           "&userId=$userID"
  //           "&hasBrn=${hasBrn ? "Y" : "N"}"
  //           "&sansthaAadhaar=${sansthaAadhaarController.text}",
  //       body,
  //     );
  //
  //     ProgressDialog.closeLoadingDialog(context);
  //
  //     if (apiResponse.response != null &&
  //         apiResponse.response?.statusCode == 200) {
  //       var responseData = apiResponse.response?.data;
  //       if (responseData is String) {
  //         responseData = jsonDecode(responseData);
  //       }
  //
  //       /// SUCCESS (mock handling for now)
  //       if (responseData['state'] == 1) {
  //         // Navigate to next Employer screen (to be added)
  //         // Navigator.push(...)
  //         notifyListeners();
  //       } else {
  //         showAlertError(
  //             responseData['message'] ?? "Invalid Sanstha Aadhaar", context);
  //       }
  //     } else {
  //       /// TEMP SUCCESS (sandbox / static)
  //       notifyListeners();
  //     }
  //   } catch (e) {
  //     ProgressDialog.closeLoadingDialog(context);
  //     showAlertError(e.toString(), context);
  //   }
  // }

  /// ===============================
  /// CLEAR DATA
  /// ===============================
  void clearData() {
    sansthaAadhaarController.clear();
    hasBrn = true;
    notifyListeners();
  }
}
