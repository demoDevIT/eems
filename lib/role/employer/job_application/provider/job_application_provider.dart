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
import '../../../department/dept_join_attendance_list/modal/financial_year_modal.dart';
import '../../../job_seeker/addjobpreference/modal/sector_modal.dart';
import '../../../job_seeker/job_fair_event/modal/event_name_modal.dart';
import '../modal/job_application_modal.dart';
import '../modal/job_post_list_modal.dart';

class JobApplicationProvider extends ChangeNotifier {

  final CommonRepo commonRepo;

  JobApplicationProvider({required this.commonRepo});

  List<JobApplicationData> jobApplicationList = [];

  /// FINANCIAL YEAR
  bool isFinancialYearLoading = false;
  List<FinancialYearData> financialYearList = [];
  FinancialYearData? selectedFinancialYear;

  List<EventNameData>  eventNameList = [];
  final TextEditingController  eventNameController = TextEditingController();
  final TextEditingController  eventIdController = TextEditingController();

  List<JobPostListData>  postList = [];
  final TextEditingController  postIdController = TextEditingController();
  final TextEditingController  postNameController = TextEditingController();

  TextEditingController mobileController = TextEditingController();
  TextEditingController registrationController = TextEditingController();
  TextEditingController applicantNameController = TextEditingController();

  bool isFilterOpen = false;

  Future<void> getFinancialYearApi(BuildContext context) async {
    isFinancialYearLoading = true;
    financialYearList.clear();
    selectedFinancialYear = null;
    notifyListeners();

    try {
      final apiResponse = await commonRepo.get(
        "Common/GetFinancialYear",
      );

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        if (responseData['Data'] != null) {
          for (var e in responseData['Data']) {
            final fy = FinancialYearData.fromJson(e);
            financialYearList.add(fy);

            /// 🔵 Auto-select current FY
            if (fy.isCurrentFY == 1) {
              selectedFinancialYear = fy;
            }
          }
        }
      }
    } catch (_) {
      financialYearList.clear();
    }

    isFinancialYearLoading = false;
    notifyListeners();
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

  Future<JobPostListModal?> jobPostListApi(BuildContext context,
      {String? eventId}) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        ApiResponse apiResponse = await commonRepo.get("JobFairEvent/GetJobPostList/GetJobPostList/$eventId");
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = JobPostListModal.fromJson(responseData);
          postList.clear();
          if (sm.state == 200) {

            postList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = JobPostListModal(state: 0, message: sm.message.toString());

            notifyListeners();
            //showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return JobPostListModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = JobPostListModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future getJobApplicationList(BuildContext context,
      {String? yearId, String? eventId, String? jobPostID, String? mobile, String? registrationNo, String? applicantName}) async {
    try {
      String userId = UserData().model.value.userId.toString();
      String roleId = UserData().model.value.roleId.toString();

      Map<String, dynamic> body = {
        "ActionName": "Get_NewAllAppliedApplicationList",
        "UserId": userId,
        "Roleid": roleId,
        "JobFairEventDetailId": eventId ?? 0,
        "Jobpostid": jobPostID ?? 0,
        "FYID": 16, //yearId ?? 0,
        "mobileNo": mobile ?? "",
        "candidateName": applicantName ?? "",
        "regNo": registrationNo ?? ""
      };

      print("body => $body");

      String url = "JobFairEvent/GetCandidateAppliedJobList";

      // ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.post(url, body);

      //  ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        final sm = JobApplicationModal.fromJson(responseData);
        jobApplicationList.clear();

        if (sm.state == 200 && sm.data != null) {
          jobApplicationList.addAll(sm.data!);
        }

        notifyListeners();
        return sm;
      } else {
        notifyListeners();
        return JobApplicationModal(
            state: 0, message: "Something went wrong");
      }


    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
    }
  }

  void clearData() {
    jobApplicationList.clear();
    eventNameList.clear();
    eventNameController.clear();
    eventIdController.clear();

    mobileController.clear();
    registrationController.clear();
    applicantNameController.clear();

    notifyListeners();
  }
}