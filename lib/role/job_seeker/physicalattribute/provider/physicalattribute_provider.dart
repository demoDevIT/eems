import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/role/job_seeker/physicalattribute/modal/profile_physical_attribute_modal.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../modal/delete_physical_attribute_modal.dart';

class PhysicalattributeProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  PhysicalattributeProvider({required this.commonRepo});





  List<ProfilePhysicalAttributeData> physicalattributeList = [];

  Future<ProfilePhysicalAttributeModal?> physicalattributeApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {
          "UserId": UserData().model.value.userId.toString(),
        };
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post("/MobileProfile/ProfilePhysicalAttributeData",body);

        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = ProfilePhysicalAttributeModal.fromJson(responseData);
          physicalattributeList.clear();

          if (sm.state == 200) {

            physicalattributeList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = ProfilePhysicalAttributeModal(state: 0, message: sm.message.toString());
           // showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            notifyListeners();
            return smmm;
          }

        } else {

          return ProfilePhysicalAttributeModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = ProfilePhysicalAttributeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<DeletePhysicalAttributeModal?> deleteDetailProfileApi(BuildContext context,
      String id) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String ? IpAddress =  await UtilityClass.getIpAddress();

        Map<String, dynamic> bodyy =
        {
          "ID": id,
          "UserID": UserData().model.value.userId.toString(),
          "ProfileSectionId": 4,
          "ActionName": "PhysicalDetail"

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
          final sm = DeletePhysicalAttributeModal.fromJson(responseData);
          if (sm.state == 200) {

            successDialog(
              context,sm.message.toString(), (value) {
              print(value);
              if (value.toString() == "success") {
                physicalattributeApi(context);
                //showAlertSuccess(AppLocalizations.of(context)!.login_successfully, context);
              }
            },
            );


            return sm;
          } else {
            final smmm = DeletePhysicalAttributeModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return DeletePhysicalAttributeModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = DeletePhysicalAttributeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  clearData(){
    physicalattributeList.clear();
    notifyListeners();
  }





  @override
  void dispose() {
    super.dispose();
  }


}
