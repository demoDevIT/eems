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
import '../../addeducationaldetail/modal/nco_code_modal.dart';

class JobsListProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  JobsListProvider({required this.commonRepo});



  List<NcoCodeData> jobPostList = [];
  List<NcoCodeData> applyJobPostList = [];
  bool tab = false;


  Future<NcoCodeModal?> allJobMatchingListApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> bodyy =
        {
          "ActionName": tab == true ? "JobPostList" : "ApplyJobPostList",

          "Id": 0,

          "UserId": UserData().model.value.userId.toString(),

          "JobSectorId": 0,

          "Location": "",

          "Title": ""

        };
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post("MobileProfile/GetAllJobMatchingList",bodyy);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = NcoCodeModal.fromJson(responseData);
          jobPostList.clear();
          applyJobPostList.clear();
          if (sm.state == 200) {
            if(tab == false){

              jobPostList.addAll(sm.data!);
            }else{

              applyJobPostList.addAll(sm.data!);
            }

              notifyListeners();
            return sm;
          } else {
            final smmm = NcoCodeModal(state: 0, message: sm.message.toString());
            notifyListeners();
            //  showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return NcoCodeModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = NcoCodeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  clearData(){
    jobPostList.clear();
    applyJobPostList.clear();

  }




  @override
  void dispose() {
    super.dispose();
  }


}
