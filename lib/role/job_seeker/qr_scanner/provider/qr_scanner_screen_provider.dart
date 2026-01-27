import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rajemployment/api_service/model/base/api_response.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/l10n/app_localizations.dart';
import 'package:rajemployment/repo/common_repo.dart';
import 'package:rajemployment/role/job_seeker/qr_scanner/modal/qr_scanner_screen_modal.dart';
import 'package:rajemployment/role/job_seeker/select_company/select_company_page.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/progress_dialog.dart';
import 'package:rajemployment/utils/user_new.dart';
import 'package:rajemployment/utils/utility_class.dart';

class QrScannerScreenProvider extends ChangeNotifier {   

  final CommonRepo commonRepo;
  QrScannerScreenProvider({required this.commonRepo});


  Future<Map<String, dynamic>?> attendanceApi(
      BuildContext context,
      double? currentLat,
      double? currentLng,
      String? roleId,
      String? userId,
      String? eventId,
      String? deviceId,
      ) async {

    final isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      return {
        "message": AppLocalizations.of(context)!.internet_connection,
        "state": -1,
      };
    }

    try {
      Map<String, dynamic> body = {
        "ActionName": "MarkedAttendancebyQR",
        "RoleId": roleId,
        "EventId": eventId,
        "userId": userId,
        "Latitude": currentLat.toString(),
        "Longitude": currentLng.toString(),
        "DeviceID": deviceId,
      };

      ApiResponse apiResponse =
      await commonRepo.post("MobileProfile/MarkAttendence", body);

      if (apiResponse.response?.statusCode != 200) {
        return {
          "message": "Something went wrong",
          "state": -1,
        };
      }

      var responseData = apiResponse.response?.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      // {"State":200,"Status":true,"Message":"..."}
      final sm = qr_scanner_screen_modal.fromJson(responseData);

      // ⭐⭐⭐ THIS IS THE IMPORTANT CHANGE ⭐⭐⭐
      return {
        "message": sm.message?.toString() ?? "Attendance failed",
        "state": sm.state ?? 0,
      };

    } catch (e) {
      return {
        "message": e.toString(),
        "state": -1,
      };
    }
  }



  Future<bool?> showSuccessDialog(
      BuildContext context,
      String msg,
      int state,
      bool isUserID,
      )
  {
    final bool isAlreadyMarked = state == 4;

    final IconData icon =
    isAlreadyMarked ? Icons.info : Icons.check_circle;

    final Color iconColor =
    isAlreadyMarked ? Colors.orange : Colors.green;

    final String title =
    isAlreadyMarked ? "Already Marked" : "Successful";

    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // force user to tap OK or X
      barrierColor: Colors.black.withOpacity(0.5), // dim background
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Close icon (top-right)
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(dialogContext).pop(false),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black12,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.close, size: 16, color: Colors.black87),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Green checkmark
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: iconColor.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 80,
                  ),
                ),

                const SizedBox(height: 16),

                // Title (bold)
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                // Subtitle paragraph
                 Text(
                  msg.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.black54),
                ),

                const SizedBox(height: 20),

                // OK button
                SizedBox(
                  width: 120,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kViewAllColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    // onPressed: () => Navigator.of(dialogContext).pop(true),
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // close dialog
                      if(isUserID == false){
                        Navigator.of(context).pushReplacement( // ✅ replace scanner
                          MaterialPageRoute(builder: (_) => const SelectCompanyPage()),
                        );
                      }else {
                        // 3️⃣ Go back to CandidateAttendancePage
                        Navigator.of(context).pop(); // pop QR scanner page
                      }

                    }, // true = OK pressed
                    child: const Text(
                      'Ok',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }


}

