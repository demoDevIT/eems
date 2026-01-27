import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../../addeducationaldetail/modal/save_data_education_modal.dart';
import '../modal/delete_education_modal.dart';
import '../modal/profile_qualication_info_list_modal.dart';

class EducationDetailsProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  EducationDetailsProvider({required this.commonRepo});



  List<ProfileQualicationInfoData> educationList = [];

  Future<ProfileQualicationInfoListModal?> profileQualicationInfoApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {
          "UserId": UserData().model.value.userId.toString(),
        };
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post("MobileProfile/ProfileQualicationInfo",body);

        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          print("educationList--55->" + educationList.length.toString());

          final sm = ProfileQualicationInfoListModal.fromJson(responseData);
          print("educationList--66->" + educationList.length.toString());

          educationList.clear();
          if (sm.state == 200) {
            educationList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            notifyListeners();
            final smmm = ProfileQualicationInfoListModal(state: 0, message: sm.message.toString());
            //showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {

          return ProfileQualicationInfoListModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = ProfileQualicationInfoListModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  Future<DeleteEducationModal?> deleteEducationDetailsApi(BuildContext context,
      String id) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String ? IpAddress =  await UtilityClass.getIpAddress();

        Map<String, dynamic> bodyy =
        {
          "ID": id,
          "UserID": UserData().model.value.userId.toString(),
          "ProfileSectionId": 5,
          "ActionName": "EducationDetail"

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
          final sm = DeleteEducationModal.fromJson(responseData);
          if (sm.state == 200) {

            successDialog(
              context,sm.message.toString(), (value) {
              print(value);
              if (value.toString() == "success") {
                profileQualicationInfoApi(context);
                //showAlertSuccess(AppLocalizations.of(context)!.login_successfully, context);
              }
            },
            );


            return sm;
          } else {
            final smmm = DeleteEducationModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return DeleteEducationModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = DeleteEducationModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  clearData(){
    educationList.clear();
    notifyListeners();
  }


  @override
  void dispose() {
    super.dispose();
  }


}
