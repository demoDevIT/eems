import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/role/job_seeker/workexperience/modal/delete_work_experience_list_modal.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../modal/basic_details_modal.dart';
import '../modal/delete_work_experience_modal.dart';

class WorkExperienceProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  WorkExperienceProvider({required this.commonRepo});
  BasicDetailsData? basicDetails;

  List<WorkExperienceListData> workExperienceList = [];

  Future<WorkExperienceListModal?> profileWorkExperienceDataApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {
          "UserId": UserData().model.value.userId.toString(),
        };
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post("MobileProfile/ProfileWorkExperienceData",body);

        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = WorkExperienceListModal.fromJson(responseData);

          workExperienceList.clear();
          if (sm.state == 200) {

            workExperienceList.addAll(sm.data!);
            debugPrint("WORK EXPERIENCE LIST => ${jsonEncode(workExperienceList.map((e) => e.toJson()).toList())}");

            notifyListeners();
            return sm;
          } else {
            final smmm = WorkExperienceListModal(state: 0, message: sm.message.toString());
            notifyListeners();
            // showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {

          return WorkExperienceListModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = WorkExperienceListModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  clearData(){
    workExperienceList.clear();
    basicDetails = null;
    notifyListeners();
  }

  Future<void> getBasicDetailsApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
      return;
    }

    try {
      Map<String, dynamic> body = {
        "Action": "GetJobseekerBasicInfo",
        "UserId": UserData().model.value.userId.toString(),
      };

      ApiResponse apiResponse =
      await commonRepo.post("Login/GetBasicDetails", body);

      if (apiResponse.response != null &&
          apiResponse.response?.statusCode == 200) {
        var responseData = apiResponse.response?.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        final modal = BasicDetailsModal.fromJson(responseData);

        if (modal.state == 200 &&
            modal.data != null &&
            modal.data!.isNotEmpty) {
          basicDetails = modal.data!.first;
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint("Basic details error: $e");
    }
  }


  Future<DeleteWorkExperienceModal?> deleteEducationDetailsApi(BuildContext context,
      String id) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String ? IpAddress =  await UtilityClass.getIpAddress();

        Map<String, dynamic> bodyy =
        {
          "ID": id,
          "UserID": UserData().model.value.userId.toString(),
          "ProfileSectionId": 6,
          "ActionName": "EmploymentDetail"

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
          final sm = DeleteWorkExperienceModal.fromJson(responseData);
          if (sm.state == 200) {

            successDialog(
              context,sm.message.toString(), (value) {
              print(value);
              if (value.toString() == "success") {
                profileWorkExperienceDataApi(context);
                //showAlertSuccess(AppLocalizations.of(context)!.login_successfully, context);
              }
            },
            );


            return sm;
          } else {
            final smmm = DeleteWorkExperienceModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return DeleteWorkExperienceModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = DeleteWorkExperienceModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }




  @override
  void dispose() {
    super.dispose();
  }


}
