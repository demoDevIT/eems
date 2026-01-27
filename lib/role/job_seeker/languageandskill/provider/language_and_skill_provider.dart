import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/role/job_seeker/languageandskill/modal/profile_skill_info_modal.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../modal/delete_language_skills_modal.dart';
import '../modal/profile_language_info_modal.dart';

class LanguageAndSkillProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  LanguageAndSkillProvider({required this.commonRepo});






  List<ProfileLanguageInfoData> languageList = [];
  List<ProfileSkillInfoData> skillList = [];

  Future<ProfileLanguageInfoModal?> profileLanguageInfoApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {
          "UserId": UserData().model.value.userId.toString(),
        };
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post("MobileProfile/ProfileLanguageInfo",body);

        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }

          final sm = ProfileLanguageInfoModal.fromJson(responseData);

          languageList.clear();
          if (sm.state == 200) {
            languageList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = ProfileLanguageInfoModal(state: 0, message: sm.message.toString());
            notifyListeners();
           // showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {

          return ProfileLanguageInfoModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = ProfileLanguageInfoModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  void refreshAll(BuildContext context) {
    print("refreshhhh alllllllll");
    profileSkillInfoApi(context);
    profileLanguageInfoApi(context);
  }

  Future<ProfileSkillInfoModal?> profileSkillInfoApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {
          "UserId": UserData().model.value.userId.toString(),
        };
        //ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post("MobileProfile/ProfileSkillInfo",body);

        print("skill API response=> ${apiResponse.response}");
        //ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }

          final sm = ProfileSkillInfoModal.fromJson(responseData);
          skillList.clear();

          if (sm.state == 200) {

            skillList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = ProfileSkillInfoModal(state: 0, message: sm.message.toString());
            notifyListeners();
            //  showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {

          return ProfileSkillInfoModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //ProgressDialog.closeLoadingDialog(context);
        final sm = ProfileSkillInfoModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }



  Future<DeleteLanguageSkillsModal?> deleteDetailProfileApi(BuildContext context,
      String id) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String ? IpAddress =  await UtilityClass.getIpAddress();

        Map<String, dynamic> bodyy =
        {
          "ID": id,
          "UserID": UserData().model.value.userId.toString(),
          "ProfileSectionId": 3,
          "ActionName": "LanguageDetail"

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
          final sm = DeleteLanguageSkillsModal.fromJson(responseData);
          if (sm.state == 200) {

            successDialog(
              context,sm.message.toString(), (value) {
              print(value);
              if (value.toString() == "success") {
                profileLanguageInfoApi(context);
                //showAlertSuccess(AppLocalizations.of(context)!.login_successfully, context);
              }
            },
            );


            return sm;
          } else {
            final smmm = DeleteLanguageSkillsModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return DeleteLanguageSkillsModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = DeleteLanguageSkillsModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  Future<DeleteLanguageSkillsModal?> deleteSkillsDetailProfileApi(BuildContext context,
      String id) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String ? IpAddress =  await UtilityClass.getIpAddress();

        Map<String, dynamic> bodyy =
        {
          "ID": id,
          "UserID": UserData().model.value.userId.toString(),
          "ProfileSectionId": 3,
          "ActionName": "SkillDetail"

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
          final sm = DeleteLanguageSkillsModal.fromJson(responseData);
          if (sm.state == 200) {

            successDialog(
              context,sm.message.toString(), (value) {
              print(value);
              if (value.toString() == "success") {
                profileSkillInfoApi(context);
                //showAlertSuccess(AppLocalizations.of(context)!.login_successfully, context);
              }
            },
            );


            return sm;
          } else {
            final smmm = DeleteLanguageSkillsModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return DeleteLanguageSkillsModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = DeleteLanguageSkillsModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }



  clearData(){
    languageList.clear();
    skillList.clear();
    notifyListeners();
  }




  @override
  void dispose() {
    super.dispose();
  }




}
