import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/api_service/model/base/api_response.dart';
import 'package:rajemployment/l10n/app_localizations.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/progress_dialog.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../repo/common_repo.dart';
import '../../../../utils/location_service.dart';
import '../../../../utils/utility_class.dart';
import '../modal/select_company_page_modal.dart';

class SelectCompanyPageProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  SelectCompanyPageProvider({required this.commonRepo});

  final TextEditingController searchController = TextEditingController();
 // final List<int> selectedCompanies = [];
 final List<AllJobSectorData> jobSectorList = [];
  final List<AllJobTitleData> jobTitleList = [];

  final List<AppliedJobData> appliedJobList = [];
  String? lastApiMessage; // Add this field


  // Example static data (replace with API or DB later)
  final List<Map<String, String>> companies = [
    {
      "name": "Dev It Information Technology Ltd",
      "location": "Jaipur, Rajasthan",
      "logo": "assets/images/coffee.png",
    },
    {
      "name": "Synarion IT Solutions",
      "location": "Jaipur, Rajasthan",
      "logo": "assets/images/synara.png",
    },
    {
      "name": "International Marketing Coordinator",
      "location": "Jaipur, Rajasthan",
      "logo": "assets/images/intermarkcord.png",
    },
  ];

  // sector list dropdown API
  Future<AllJobSectorListModal?> getAllSectorListApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "MobileProfile/SectorData";
        ApiResponse apiResponse = await commonRepo.get(url);
        print("sector statusCode => ${apiResponse.response?.statusCode}");
        print("sector RAW RESPONSE => ${apiResponse.response?.data}");

        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          print("RAW RESPONSE => ${apiResponse.response?.data}");


          final sm = AllJobSectorListModal.fromJson(responseData);
          if (sm.state == 200) {
            jobSectorList.clear();
            jobSectorList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = AllJobSectorListModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalidd", context);
            return smmm;
          }
        } else {
          return AllJobSectorListModal(state: 0, message: 'Somethingg went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = AllJobSectorListModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  // title list dropdown API
  Future<AllJobTitleListModal?> getAllTitleListApi(BuildContext context, int sectorId) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "MobileProfile/JobTitleDetails/$sectorId";
        ApiResponse apiResponse = await commonRepo.get(url);
        print("aaa=>${apiResponse.response?.statusCode}");

        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = AllJobTitleListModal.fromJson(responseData);
          if (sm.state == 200) {
              jobTitleList.clear();
              jobTitleList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = AllJobTitleListModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalidd", context);
            return smmm;
          }
        } else {
          return AllJobTitleListModal(state: 0, message: 'Somethingg went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = AllJobTitleListModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<AppliedJobListModal?> appliedJobMatchingListApi(BuildContext context, {
    required int jobSectorId,
    required int jobTitleId,
  }) async {

    // ✅ CLEAR OLD DATA FIRST
    appliedJobList.clear();
    notifyListeners();

    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> bodyy =
        {
          "ActionKey": "GetJobDetails",
          "UserId": UserData().model.value.userId.toString(),
          "Roleid": UserData().model.value.roleId.toString(),
          "EventId": 38,
          "JobSector": jobSectorId,
          "JobTitle": jobTitleId
        };
        //ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post("MobileProfile/GetMatchedJobPostedList",bodyy);
        print("Applied jobs Status Code --==> : ${apiResponse.response?.statusCode}");
        print("applied JOB response --==> : ${apiResponse.response?.data}");

        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = AppliedJobListModal.fromJson(responseData);

          if (sm.state == 200 && sm.data != null && sm.data!.isNotEmpty) {
            appliedJobList.addAll(sm.data!);
          }
          // ✅ Even if data is empty, list stays empty

          notifyListeners();
          return sm;

        } else {
          return AppliedJobListModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = AppliedJobListModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }finally {
        // ✅ GUARANTEED to close loader
        ProgressDialog.closeLoadingDialog(context);
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  Future<bool> applyJobApi(
      BuildContext context, {
        required AppliedJobData job,
        required bool apply,
      }) async {
    lastApiMessage = null;

    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
        AppLocalizations.of(context)!.internet_connection,
        context,
      );
      return false;
    }

    try {
      Map<String, dynamic> body;

      if (apply) {
        // ✅ CHECK (Apply Job)
        final position = await LocationService.getCurrentLocation();
        if (position == null) {
          throw "Unable to get location";
        }

        body = {
          "ActionName": "Insert",
          "UserId": UserData().model.value.userId,
          "RoleId": UserData().model.value.roleId,
          "EventId": job.eventid,
          "Longitude": position.longitude,
          "Latitude": position.latitude,
          "EmployerUserId": job.employerID,
          "JobPostId": job.jobPostId,
          "IsActive": 1,
        };
      } else {
        // ❌ UNCHECK (Remove Job)
        body = {
          "ActionName": "Uncheck",
          "PreferencesId": job.PreferencesId,
          "UserId": UserData().model.value.userId,
          "RoleId": UserData().model.value.roleId,
          "EventId": job.eventid,
        };
      }

      ApiResponse response = await commonRepo.post(
        "MobileProfile/InsertJobPreference",
        body,
      );

      lastApiMessage =
          response.response?.data["Message"]?.toString() ?? "";

      if (response.response?.statusCode == 200 &&
          response.response?.data["State"] == 200) {
        return true;
      }

      return false;
    } catch (e) {
      lastApiMessage = e.toString();
      return false;
    }
  }




  @override
  void dispose() {
    super.dispose();
  }



  clearData() {
    //selectedCompanies.clear();
    jobSectorList.clear();
    jobTitleList.clear();
    appliedJobList.clear();
    notifyListeners();
  }
}
