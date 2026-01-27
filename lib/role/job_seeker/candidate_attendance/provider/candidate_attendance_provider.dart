import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../api_service/model/base/api_response.dart';
import '../../../../constants/colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/global.dart';
import '../../../../utils/location_service.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../modal/event_model.dart';
import '../modal/job_preference_model.dart';
import '../modal/job_seeker_model.dart';


class CandidateAttendanceProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  CandidateAttendanceProvider({required this.commonRepo});

  bool isLoading = false;

  JobSeekerModel? jobSeeker;
  List<JobPreferenceModel> jobPreferences = [];

  List<EventModel> eventList = [];
  EventModel? selectedEvent;


  Future<bool> getJobSeekerByRegOrMobile({
    required BuildContext context,
    required int eventId,
    String mobileNo = '',
    String eventRegNo = '',
  }) async {

    isLoading = true;
    notifyListeners();

    try {
      final body = {
        "ActionKey": "GetJobSeekerDetails",
        "MobileNo": mobileNo,
        "EventRegNo": eventRegNo,
        "EventId": eventId.toString(), // ✅ ALWAYS PASS
      };

      apiLog("REQUEST → GetJobSeekerDetailsbyRegMobilNo", body);

      final response =
      await commonRepo.post("MobileProfile/GetJobSeekerDetailsbyRegMobilNo", body);

      /// 🔹 PRINT RAW RESPONSE
      apiLog(
        "RESPONSE → GetJobSeekerDetailsbyRegMobilNo",
        response.response?.data,
      );

      var data = response.response?.data;
      if (data is String) data = jsonDecode(data);

      if (data['State'] == 200 && data['Data'] != null && data['Data'].isNotEmpty) {
        jobSeeker = JobSeekerModel.fromJson(data['Data'][0]);

        apiLog("PARSED USER DATA", jobSeeker);

        // ✅ Call next API immediately
        await getJobPreferences(
          context: context,
          userId: jobSeeker!.userId,
        );

        isLoading = false;
        notifyListeners();
        return true;
      }

      jobSeeker = null;
      jobPreferences.clear();

      isLoading = false;
      notifyListeners();
      return false;
    } catch (e, s) {
      apiLog("ERROR → GetJobSeekerDetailsbyRegMobilNo", e);
      apiLog("STACKTRACE", s);
      isLoading = false;
      notifyListeners();
      return false;
    }

  }

  Future<void> getJobPreferences({
    required BuildContext context,
    required String userId,
  }) async {
    final body = {
      "ActionKey": "GetJobPrefered",
      "UserId": userId, //2023
    };

    apiLog("REQUEST → GetJobPreferedbyJobSeekerId", body);

    try {
      final response = await commonRepo.post(
        "MobileProfile/GetJobPreferedbyJobSeekerId",
        body,
      );

      /// 🔹 PRINT RAW RESPONSE
      apiLog(
        "RESPONSE → GetJobPreferedbyJobSeekerId",
        response.response?.data,
      );

      var data = response.response?.data;
      if (data is String) data = jsonDecode(data);

      if (data['State'] == 200 && data['Data'] != null) {
        jobPreferences = (data['Data'] as List)
            .map((e) => JobPreferenceModel.fromJson(e))
            .toList();

        /// 🔹 PRINT PARSED JOB LIST
        apiLog("PARSED JOB LIST", jobPreferences);
      }
    } catch (e) {
      apiLog("ERROR → GetJobPreferedbyJobSeekerId", e);
    }
  }

  Future<void> getEventList(BuildContext context) async {
    final isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
      return;
    }

    try {
      ProgressDialog.showLoadingDialog(context);

      final response = await commonRepo.get(
        "MobileProfile/EventDetails/0/0/0",
      );

      ProgressDialog.closeLoadingDialog(context);

      if (response.response?.statusCode == 200) {
        var data = response.response?.data;
        if (data is String) data = jsonDecode(data);

        if (data['State'] == 200 && data['Data'] != null) {
          eventList = (data['Data'] as List)
              .map((e) => EventModel.fromJson(e))
              .toList();

          notifyListeners();
        }
      }
    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
    }
  }


  void apiLog(String title, dynamic data) {
    debugPrint("🟦🟦🟦 $title 🟦🟦🟦");
    debugPrint(data.toString());
    debugPrint("🟦🟦🟦 END $title 🟦🟦🟦");
  }


  Future<String?> markAttendance(
      BuildContext context, {
        required int eventId,
      }) async {

    isLoading = true;
    notifyListeners();

    ProgressDialog.showLoadingDialog(context);

    try {
      // 🔐 Device ID
      String? deviceId = await UtilityClass.getDeviceId();

      // 📍 Get location
      final position = await LocationService.getCurrentLocation();
      if (position == null) {
        throw "Unable to get location";
      }

      final double userLatitude = position.latitude;
      final double userLongitude = position.longitude;

      // 🧠 Get user from search result
      if (jobSeeker == null) {
        throw "Job seeker data not found";
      }

      // 🔐 Encrypt sensitive values
      final encryptedRoleId = encrypt(jobSeeker!.roleId.toString());
      final encryptedUserId = encrypt(jobSeeker!.userId.toString());
      final encryptedEventId = encrypt(eventId.toString()); // ✅ FIX
      final encryptedDeviceId = encrypt(deviceId ?? "");

      print("🎯 EventId USED --> $eventId");
      print("🔐 Encrypted EventId --> $encryptedEventId");

      final result = await attendanceApi(
        context,
        userLatitude,
        userLongitude,
        encryptedRoleId,
        encryptedUserId,
        encryptedEventId,
        encryptedDeviceId,
      );

      ProgressDialog.closeLoadingDialog(context);

      if (result != null) {
        await showSuccessDialog(
          context,
          result['message'],
          result['state'],
        );
      }

      //return result;
    } catch (e) {
      return e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }


  Future<Map<String, dynamic>?> attendanceApi(
      BuildContext context,
      double? currentLat,
      double? currentLng,
      String? roleId,
      String? userId,
      String? eventId,
      String? deviceId,
      ) async {

    // final isInternet = await UtilityClass.checkInternetConnectivity();
    // if (!isInternet) {
    //   return AppLocalizations.of(context)!.internet_connection;
    // }

    final isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      return {"state": -1, "message": AppLocalizations.of(context)!.internet_connection};
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

      apiLog("REQUEST → MarkAttendence", body);

      ApiResponse apiResponse =
      await commonRepo.post("MobileProfile/MarkAttendence", body);

      // if (apiResponse.response?.statusCode != 200) {
      //   return "Something went wrong";
      // }

      var responseData = apiResponse.response?.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      //return responseData['Message']?.toString();
      return {
        "state": responseData['State'],
        "message": responseData['Message']
      };

    } catch (e) {
      return {"state": -1, "message": e.toString()};
    }
  }

  Future<void> showSuccessDialog(
      BuildContext context,
      String msg,
      int state,
      ) async {

    final bool isAlreadyMarked = state == 4;

    final IconData icon =
    isAlreadyMarked ? Icons.info : Icons.check_circle;

    final Color iconColor =
    isAlreadyMarked ? Colors.orange : Colors.green;

    final String title =
    isAlreadyMarked ? "Already Marked" : "Successful";

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 8,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ❌ Close icon
                Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () => Navigator.of(dialogContext).pop(),
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.black12,
                      ),
                      padding: const EdgeInsets.all(4),
                      child: const Icon(Icons.close, size: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ✅ Success Icon
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

                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  msg,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, color: Colors.black54),
                ),

                const SizedBox(height: 20),

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
                    onPressed: () {
                      Navigator.of(dialogContext).pop(); // ✅ only close popup
                    },
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


  @override
  void dispose() {
    super.dispose();
  }

  clearData() {

    notifyListeners();
  }
}

String encrypt(String text) {
  final bytes = text.codeUnits.expand((unit) {
    return [
      unit & 0xFF,
      (unit >> 8) & 0xFF
    ];
  }).toList();

  final buffer = StringBuffer();
  for (final b in bytes) {
    buffer.write(b.toRadixString(16).padLeft(2, '0').toUpperCase());
  }

  return buffer.toString();
}