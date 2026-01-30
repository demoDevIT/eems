import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rajemployment/utils/global.dart';
import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/user_new.dart';
import '../../../../utils/utility_class.dart';
import '../../addjobpreference/modal/save_data_job_preference_modal.dart';
import '../modal/delete_job_preference_modal.dart';
import '../modal/job_preference_modal.dart';

class JobPreferenceProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  JobPreferenceProvider({required this.commonRepo});
  String internationalJobPreference = "No"; // Yes / No
  String isInternationalJob = "2"; // 1 = Yes, 2 = No



  List<JobPreferenceData> jobPreferenceList = [];

  Future<void> getInternationalJobStatus(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
      return;
    }

    try {
      String userId = UserData().model.value.userId.toString();
      String url =
          "Common/JobSeekerJobStatus/InternationalJobs/$userId";

      ApiResponse apiResponse = await commonRepo.get(url);

      if (apiResponse.response != null &&
          apiResponse.response?.statusCode == 200) {
        var responseData = apiResponse.response?.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        if (responseData["State"] == 200 &&
            responseData["Data"] != null &&
            responseData["Data"].isNotEmpty) {
          int value = responseData["Data"][0]["IsInternationalJobs"];
          isInternationalJob = value.toString(); // "1" or "2"
          internationalJobPreference = value == 1 ? "Yes" : "No";
          notifyListeners();
        }
      }
    } catch (e) {
      showAlertError(e.toString(), context);
    }
  }


  Future<JobPreferenceModal?> getJobPreferenceApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {
          "UserId": UserData().model.value.userId.toString(),
        };
         ProgressDialog.showLoadingDialog(context);
         ApiResponse apiResponse = await commonRepo.post("MobileProfile/GetJobPreferenceData",body);
         ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = JobPreferenceModal.fromJson(responseData);
          jobPreferenceList.clear();
          if (sm.state.toString() == "200") {
            jobPreferenceList.addAll(sm.data!);
            print(jobPreferenceList.length.toString());
            notifyListeners();
            return sm;
          } else {
            final smmm = JobPreferenceModal(state: 0, message: sm.message.toString());
            notifyListeners();
            //showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {

          return JobPreferenceModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = JobPreferenceModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<void> updateInternationalJobPreference(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
      return;
    }

    try {
      // got these parameters from Amit and discussed with him that these parameters will send
      Map<String, dynamic> body = {
        "ActionName": "Job Preference",
        "UserId": UserData().model.value.userId.toString(),
        "JobSeekarId": UserData().model.value.jobSeekerID.toString(),
        "CreatedBy": UserData().model.value.userId.toString(),
        "IsInternationalJob": isInternationalJob, // "1" or "2"

        // rest as 0 / empty
        "Sector": "0",
        "PreRole": "0",
        "PreLocation": "0",
        "Employmenttype": "0",
        "JobType": "0",
        "Shift": "0",
        "NCOCode": "0",
        "PreferredRegion": "0",
        "ForeignLanguageKnown": "0",
        "JobPreferenceID": "0",
        "SalaryEnumValue": "0",
        "IsActive": "1",
        "IPAddress": "",
        "IPAddressv6": ""
      };

      ProgressDialog.showLoadingDialog(context);
      ApiResponse apiResponse =
      await commonRepo.post("MobileProfile/SaveJobPreference", body);
      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response?.statusCode == 200) {
        var responseData = apiResponse.response?.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        final sm = SaveDataJobPreferenceModal.fromJson(responseData);
        if (sm.state == 200) {
          successDialog(context, sm.message.toString(), (_) {});
        } else {
          showAlertError(sm.errorMessage.toString(), context);
        }
      }
    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
    }
  }


  Future<DeleteJobPreferenceModal?> deleteDetailProfileApi(BuildContext context,
      String id) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String ? IpAddress =  await UtilityClass.getIpAddress();

        Map<String, dynamic> bodyy =
        {
          "ID": id,
          "UserID": UserData().model.value.userId.toString(),
          "ProfileSectionId": 7,
          "ActionName": "JobPreferenceDetail"

        };
        String url = "MobileProfile/DeleteDetailProfile";
        ProgressDialog.showLoadingDialog(context);
        // ApiResponse apiResponse = await commonRepo.postArray(url,body);
        ApiResponse apiResponse = await commonRepo.post(url,bodyy);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = DeleteJobPreferenceModal.fromJson(responseData);
          if (sm.state == 200) {

            successDialog(
              context,sm.message.toString(), (value) {
              print(value);
              if (value.toString() == "success") {
                getJobPreferenceApi(context);
                 //showAlertSuccess(AppLocalizations.of(context)!.login_successfully, context);
              }
            },
            );


            return sm;
          } else {
            final smmm = DeleteJobPreferenceModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return DeleteJobPreferenceModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = DeleteJobPreferenceModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }



  clearData(){
    jobPreferenceList.clear();
    notifyListeners();
  }



  @override
  void dispose() {
    super.dispose();
  }


}
