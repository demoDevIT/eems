import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../constants/colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/global.dart';
import '../../../../utils/utility_class.dart';
import '../modal/all_job_sector_list_modal.dart';
import '../modal/job_matching_list_modal.dart';

class PreferredJobsProvider extends ChangeNotifier {
  final CommonRepo commonRepo;
  PreferredJobsProvider({required this.commonRepo});
  /// =========================
  /// FILTER CONTROLLERS
  /// =========================

  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  /// =========================
  /// SECTOR LIST
  /// =========================

  List<JobSectorData> jobSectorList = [];
  JobSectorData? selectedSector;

  /// =========================
  /// JOB LIST
  /// =========================

  List<JobData> jobList = [];
  bool isLoading = false;

  /// ==========================================================
  /// 1️⃣ GET SECTOR LIST API
  /// ==========================================================

  Future<void> getAllSectorListApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
      return;
    }

    try {
      ApiResponse apiResponse =
      await commonRepo.get("MobileProfile/SectorData");

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        print("Sector API FULL RESPONSE => $responseData");

        final sm = AllJobSectorListModal.fromJson(responseData);

        if (sm.state == 200 && sm.data != null) {
          jobSectorList = sm.data!;
          notifyListeners();
        }
      }
    } catch (e) {
      showAlertError(e.toString(), context);
    }
  }

  List<Map<String, dynamic>> filteredJobs = [];

  /// ==========================================================
  /// 2️⃣ SEARCH JOB API (POST)
  /// ==========================================================

  Future<void> searchJobs(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
      return;
    }

    try {
      isLoading = true;
      notifyListeners();

      Map<String, dynamic> body = {
        "Id": 0,
        "UserId": UserData().model.value.userId,
        "JobSectorId": selectedSector?.id ?? 0,
        "Location": locationController.text,
        "Title": jobTitleController.text
      };

      ApiResponse apiResponse = await commonRepo.post(
        "JobPost/GetAllJobMatchingList",
        body,
      );

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        final sm = JobMatchingListModal.fromJson(responseData);

        jobList.clear();

        if (sm.state == 200 && sm.data?.table != null) {
          jobList.addAll(sm.data!.table!);
        }

        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
      showAlertError(e.toString(), context);
    }
  }

  bool isJobDetailsLoading = false;

  Map<String, dynamic>? selectedJobDetails;

  Future<void> getJobDetailsByPostId(
      BuildContext context,
      int jobPostId,
      ) async {

    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection,
          context);
      return;
    }

    try {

      Map<String, dynamic> body = {
        "ActionName": "",
        "Id": jobPostId,
        "UserId": UserData().model.value.userId,   // logged user id
        "JobSectorId": 0,
        "Location": "",
        "Title": ""
      };

      isJobDetailsLoading = true;
      notifyListeners();

      ApiResponse apiResponse = await commonRepo.post(
        "JobPost/GetAllJobMatchingListByPostId",
        body,
      );

      if (apiResponse.response?.statusCode == 200) {

        dynamic responseData = apiResponse.response!.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        if (responseData["State"] == 200 &&
            responseData["Data"] != null &&
            responseData["Data"]["Table"] != null &&
            responseData["Data"]["Table"].isNotEmpty) {

          selectedJobDetails =
          responseData["Data"]["Table"][0];

          isJobDetailsLoading = false;
          notifyListeners();

          showJobDetailsDialog(
            context,
            selectedJobDetails!,
          );

        } else {
          isJobDetailsLoading = false;
          notifyListeners();
          showAlertError("No Data Found", context);
        }

      } else {
        isJobDetailsLoading = false;
        notifyListeners();
        showAlertError("Something went wrong", context);
      }

    } catch (e) {
      isJobDetailsLoading = false;
      notifyListeners();
      showAlertError(e.toString(), context);
    }
  }

  void showJobDetailsDialog(
      BuildContext context,
      Map<String, dynamic> job,
      ) {

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

                  /// Close Button
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.close),
                    ),
                  ),

                  /// Profile Image
                  CircleAvatar(
                    radius: 35,
                    backgroundColor: Colors.grey.shade200,
                    child: const Icon(Icons.person, size: 40),
                  ),

                  const SizedBox(height: 12),

                  /// Job Title
                  Text(
                    job["JobTitle"] ?? "",
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 6),

                  Text(
                    job["CompanyName"] ?? "",
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 16),

                  Html(
                    data: job["JobStartDate"] ?? "",
                  ),

                  Html(data: job["JobCloseDate"] ?? ""),
                  Html(data: job["SkillNameEn"] ?? ""),
                  Html(data: job["Qualification_ENG"] ?? ""),
                  Html(data: job["JobSector"] ?? ""),
                  Html(data: job["MaleGender"] ?? ""),
                  Html(data: job["FemaleGender"] ?? ""),
                  Html(data: job["AnyGender"] ?? ""),
                  Html(data: job["OtherGender"] ?? ""),

                  const SizedBox(height: 10),

                  /// Salary
                  Row(
                    children: [
                      const Icon(Icons.currency_rupee),
                      Text(job["Salary"].toString()),
                    ],
                  ),

                  const SizedBox(height: 6),

                  /// Location
                  Row(
                    children: [
                      const Icon(Icons.location_on,
                          size: 18, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(job["Locations"] ?? ""),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Apply Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {

                        await showApplyConfirmationDialog(
                          context,
                          job["JobPostId"] ?? 0,
                          job["EmployerUserId"] ?? 0,
                        );

                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        foregroundColor: Colors.white, // 👈 ADD THIS
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        "Apply Now",
                        style: TextStyle(
                          color: Colors.white, // optional (extra safe)
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.star,
              size: 16, color: Colors.teal),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(
                    color: Colors.black, fontSize: 13),
                children: [
                  TextSpan(
                      text: "$title: ",
                      style: const TextStyle(
                          fontWeight: FontWeight.bold)),
                  TextSpan(text: value),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }


  Future<void> applyForJob(
      BuildContext context,
      int jobPostId,
      int employerUserId,
      ) async {

    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection,
          context);
      return;
    }

    try {

      Map<String, dynamic> body = {
        "CreatedBy": UserData().model.value.userId,
        "JobApplyList": [
          {
            "Id": 0,
            "JobPostId": jobPostId,
            "EmployerUserId": employerUserId,
          }
        ]
      };

      isJobDetailsLoading = true;
      notifyListeners();

      ApiResponse apiResponse = await commonRepo.post(
        "JobPost/ApplyForJob",
        body,
      );

      if (apiResponse.response?.statusCode == 200) {

        dynamic responseData = apiResponse.response!.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        isJobDetailsLoading = false;
        notifyListeners();

        successDialog(
          context,
          responseData["Message"]?.toString() ?? "Success",
              (value) async {

            if (value.toString() == "success") {

              /// Close dialog popup
              Navigator.of(context).pop();

              /// Refresh job list
              await searchJobs(context);
            }
          },
        );

      } else {
        isJobDetailsLoading = false;
        notifyListeners();
        showAlertError("Something went wrong", context);
      }

    } catch (e) {
      isJobDetailsLoading = false;
      notifyListeners();
      showAlertError(e.toString(), context);
    }
  }

  Future<void> showApplyConfirmationDialog(
      BuildContext context,
      int jobPostId,
      int employerUserId,
      ) async {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Confirm",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            "Are you sure you want to apply for this job?",
          ),
          actions: [

            /// Cancel
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("No"),
            ),

            /// Yes
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kPrimaryColor,
                foregroundColor: Colors.white,
              ),
              onPressed: () async {

                Navigator.pop(context); // close confirm dialog

                await applyForJob(
                  context,
                  jobPostId,
                  employerUserId,
                );
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  /// =========================
  /// CLEAR
  /// =========================

  void clearFilters() {
    jobTitleController.clear();
    locationController.clear();
    selectedSector = null;
    jobList.clear();
    notifyListeners();
  }
}
