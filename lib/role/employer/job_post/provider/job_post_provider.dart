import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/role/job_seeker/grievance/module/grievance_modal.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../../../job_seeker/addjobpreference/modal/sector_modal.dart';
// import '../../../job_seeker/job_fair_event/modal/event_name_modal.dart';
import '../../../job_seeker/job_fair_event/modal/event_name_modal.dart';
import '../modal/job_post_modal.dart';

class JobPostProvider extends ChangeNotifier {

  final CommonRepo commonRepo;

  JobPostProvider({required this.commonRepo});

  List<JobPostData> jobPostList = [];
  List<JobPostData> allJobPostList = [];

  List<EventNameData>  eventNameList = [];
  List<SectorData>  sectorList = [];

  final TextEditingController  eventNameController = TextEditingController();
  final TextEditingController  eventIdController = TextEditingController();
  final TextEditingController  sectorIdController = TextEditingController();
  final TextEditingController  sectorNameController = TextEditingController();

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
        String url = "ProfilJobSeekar/SectorDetailsData";
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

  Future getJobPostList(BuildContext context,
      {String? eventId, String? sectorId}) async {

    try {

      String userId = UserData().model.value.userId.toString();
      String roleId = UserData().model.value.roleId.toString();

      Map<String, dynamic> body = {
        "ActionName": "GetJobPostListbyUserID",
        "UserId": userId,
        "Roleid": roleId,
        "EventId": 0,
        "JobCategoryID": 0,
        "PKID": 0
      };

      String url = "JobFairEvent/GetAllJobPostList";

      ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.post(url, body);

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        final sm = JobPostModal.fromJson(responseData);
        jobPostList.clear();
        allJobPostList.clear();

        if (sm.state == 200 && sm.data != null) {
          jobPostList.addAll(sm.data!);
          allJobPostList.addAll(sm.data!);
        }

        notifyListeners();
        return sm;
      } else {
        notifyListeners();
        return JobPostModal(
            state: 0, message: "Something went wrong");
      }


    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
    }
  }

  void filterJobs({String? eventId, String? sectorId}) {

    jobPostList = allJobPostList.where((job) {

      bool matchEvent = true;
      bool matchSector = true;

      if (eventId != null && eventId.isNotEmpty) {
        matchEvent = job.eventID.toString() == eventId;
      }

      if (sectorId != null && sectorId.isNotEmpty) {
        matchSector = job.sectorID.toString() == sectorId;
      }

      return matchEvent && matchSector;

    }).toList();

    notifyListeners();
  }

  Future deleteJobPost(BuildContext context, int jobPostId) async {
    try {

      String userId = UserData().model.value.userId.toString();

      Map<String, dynamic> body = {
        "ActionName": "DeleteJobPostDetailby_ID",
        "PKID": jobPostId,
        "UserId": userId
      };

      String url = "JobFairEvent/DeleteJobPostDetailbyID";

      ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.post(url, body);

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response?.statusCode == 200) {

        dynamic responseData = apiResponse.response!.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        if (responseData["State"] == 200) {

          showAlertSuccess("Job post deleted successfully", context);

          /// Refresh List
          await getJobPostList(context);

        } else {
          showAlertError(responseData["Message"] ?? "Delete failed", context);
        }

      } else {
        showAlertError("Something went wrong", context);
      }

    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
    }
  }

  void clearData() {
    jobPostList.clear();
    eventNameList.clear();
    sectorList.clear();

    eventNameController.clear();
    eventIdController.clear();
    sectorNameController.clear();
    sectorIdController.clear();

    notifyListeners();
  }
}