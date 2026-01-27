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
import '../modal/all_job_fair_events_list_modal.dart';
import '../modal/company_list_modal.dart';
import '../modal/job_list_modal.dart';

class HomeScreenProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  HomeScreenProvider({required this.commonRepo});
  List<AllJobFairEventsData>  jobEventList = [];
  List<JobListData>  jobBasedList = [];
  List<CompanyListData>  companyList = [];



  Future<AllJobFairEventsListModal?> getAllJobFairEventsListApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        ProgressDialog.showLoadingDialog(context);
        Map<String, dynamic> body = {
          "ActionName": "Top 3 Events",
          "UserId": UserData().model.value.userId.toString(),
          "RoleId": UserData().model.value.roleId.toString(),
        };
        ApiResponse apiResponse = await commonRepo.post("Dashboard/GetAllJobFairEventsList",body);
        ProgressDialog.closeLoadingDialog(context);
        print("apiResponse--> $apiResponse");
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = AllJobFairEventsListModal.fromJson(responseData);
          if (sm.state == 200) {
            jobEventList.clear();
            jobEventList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = AllJobFairEventsListModal(state: 0, message: sm.message.toString());
           // showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return AllJobFairEventsListModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = AllJobFairEventsListModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<JobListModal?> jobListApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        Map<String, dynamic> body = {
          "ActionName": "JobList",
          "UserId": UserData().model.value.userId.toString(),
          "RoleId": UserData().model.value.roleId.toString(),
        };
        ApiResponse apiResponse = await commonRepo.post("Dashboard/GetAllJobAndCompanyName",body);
       // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = JobListModal.fromJson(responseData);
          if (sm.state == 200) {
            jobBasedList.clear();
            jobBasedList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = JobListModal(state: 0, message: sm.message.toString());
            //showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return JobListModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //ProgressDialog.closeLoadingDialog(context);
        final sm = JobListModal(state: 0, message: err.toString());
        //showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  Future<CompanyListModal?> companyListApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        Map<String, dynamic> body = {
          "ActionName": "CompanyList",
          "UserId": UserData().model.value.userId.toString(),
          "RoleId": UserData().model.value.roleId.toString(),
        };
        ApiResponse apiResponse = await commonRepo.post("Dashboard/GetAllJobAndCompanyName",body);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = CompanyListModal.fromJson(responseData);
          if (sm.state == 200) {
            companyList.clear();
            companyList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = CompanyListModal(state: 0, message: sm.message.toString());
           // showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return CompanyListModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //ProgressDialog.closeLoadingDialog(context);
        final sm = CompanyListModal(state: 0, message: err.toString());
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



  clearData() {

    notifyListeners();
  }
}
