import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/role/job_seeker/grievance/module/grievance_modal.dart';
import 'package:rajemployment/role/job_seeker/job_fair_event/modal/job_apply_list_modal.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../../addjobpreference/modal/sector_modal.dart';
import '../modal/event_name_modal.dart';
import '../modal/registered_events_modal.dart';

class JobApplyListProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  JobApplyListProvider({required this.commonRepo});

  List<JobApplyListDataTable> jobApplyList = [];
  List<EventNameData>  eventNameList = [];
  List<SectorData>  sectorList = [];
  final TextEditingController  eventNameController = TextEditingController();
  final TextEditingController  eventIdController = TextEditingController();
  final TextEditingController  sectorIdController = TextEditingController();
  final TextEditingController  sectorNameController = TextEditingController();



  Future<JobApplyListModal?> allJobMatchingListApi(BuildContext context,String eventId,String jobCategoryID) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> bodyy =
        {
          "ActionKey": "GetJobSeekerJobPostListbyUserID",
          "UserId": UserData().model.value.userId.toString(),
          "Roleid": UserData().model.value.roleId.toString(),
          "EventId": eventId,
          "JobCategoryID": jobCategoryID,
          "ncoCode": "string",
          "JobPositionTitle": "string"
        };
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post("MobileProfile/GetMatchedJobPostedList",bodyy);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = JobApplyListModal.fromJson(responseData);
          jobApplyList.clear();
          if (sm.state == 200) {
            jobApplyList.addAll(sm.data!.table!);
            notifyListeners();
            return sm;
          } else {
            final smmm = JobApplyListModal(state: 0, message: sm.message.toString());
            notifyListeners();
            //showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return JobApplyListModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = JobApplyListModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }



  Future<EventNameModal?> getEventNameListApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
       // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get("MobileProfile/EventDetails/${UserData().model.value.userId.toString()}/${UserData().model.value.roleId.toString()}/2025");
       // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = EventNameModal.fromJson(responseData);
          eventNameList.clear();
          if (sm.state == 200) {
            eventNameList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = EventNameModal(state: 0, message: sm.message.toString());
            notifyListeners();
            //showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return EventNameModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
       // ProgressDialog.closeLoadingDialog(context);
        final sm = EventNameModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  Future<SectorModal?> sectorListApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "MobileProfile/SectorDetailsData";
       // ProgressDialog.showLoadingDialog(context);
        Map<String, dynamic> body = {};
        ApiResponse apiResponse = await commonRepo.post(url,body);
        //ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = SectorModal.fromJson(responseData);
          sectorList.clear();
          if (sm.state == 200) {

            sectorList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = SectorModal(state: 0, message: sm.message.toString());

            notifyListeners();
            //showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return SectorModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
       // ProgressDialog.closeLoadingDialog(context);
        final sm = SectorModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }



  clearData(){
    jobApplyList.clear();
    eventNameList.clear();
    sectorList.clear();
    notifyListeners();

  }



  @override
  void dispose() {
    super.dispose();
  }


}
