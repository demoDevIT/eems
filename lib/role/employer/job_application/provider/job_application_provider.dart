import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';  // for MediaType
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/role/job_seeker/grievance/module/grievance_modal.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';
import 'package:file_picker/file_picker.dart';
import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../../../department/dept_join_attendance_list/modal/financial_year_modal.dart';
import '../../../job_seeker/add_language_skills/modal/upload_document_modal.dart';
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

  File? selectedDocumentFile;
  String? uploadedDocumentPath;
  String? uploadedDocumentPathDIS;
  int? selectedDocumentMasterId;

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
      {
        int? yearId,
        String? eventId,
        String? jobPostID,
        String? mobile,
        String? registrationNo,
        String? applicantName,

        /// ✅ NEW (for scanner)
        bool isScanner = false,
        String? jobSeekerUserId,
        String? jobSeekerRoleId,
        String? jobSeekerEventId
      }) async {
    try {
      String userId = UserData().model.value.userId.toString();
      String roleId = UserData().model.value.roleId.toString();

      Map<String, dynamic> body = {
        "ActionName": isScanner
            ? "Get_NewAllAppliedApplicationListForScanner"
            : "Get_NewAllAppliedApplicationList",
        "UserId": userId,
        "Roleid": roleId,
        "JobFairEventDetailId": eventId ?? 0,
        "Jobpostid": jobPostID ?? 0,
        "FYID": yearId ?? 0, //16
        "mobileNo": mobile ?? "",
        "candidateName": applicantName ?? "",
        "regNo": registrationNo ?? "",
        "Flag": isScanner ? "Scanner" : "",

        /// ✅ ONLY FOR SCANNER
        "JobSeekerUserId": jobSeekerUserId ?? "", // "3200320036003100360030003500"
        "JobSeekerRoleId": jobSeekerRoleId ?? "", // "3400"
        "JobSeekerEventId": jobSeekerEventId ?? "", // "37003300"

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

  Future<void> pickAndUploadSingleDocument({
    required BuildContext context,
  }) async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return;

    final file = File(result.files.single.path!);

    /// File Size Validation
    final sizeInKB = (await file.length()) / 1024;

    if (sizeInKB > 300) {
      showAlertError("File size must be less than 300 KB", context);
      return;
    }

    /// Preview
    selectedDocumentFile = file;
    notifyListeners();

    String timestamp =
        "${DateTime.now().millisecondsSinceEpoch}.pdf";

    FormData param = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: timestamp,
        contentType: MediaType("application", "pdf"),
      ),
      "FileExtension": "application/pdf",
      "FolderName": "Employer/ApplicantOfferLetterPDF",
      "MaxFileSize": "307200",
      "MinFileSize": "0",
      "Password": "",
    });

    final res = await uploadDocumentApi(context, param);

    if (res != null && res.data != null && res.data!.isNotEmpty) {

      uploadedDocumentPath = res.data![0].fileName;
      uploadedDocumentPathDIS = res.data![0].disFileName;

      debugPrint("Uploaded File: $uploadedDocumentPath");

      notifyListeners();
    }
  }

  Future<UploadDocumentModal?> uploadDocumentApi(
      BuildContext context, FormData inputText) async {

    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
      return null;
    }

    try {
      ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.uploadDocumentRepo(
        "Common/UploadDocument",
        inputText,
      );

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response != null &&
          apiResponse.response?.statusCode == 200) {

        var responseData = apiResponse.response?.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        return UploadDocumentModal.fromJson(responseData);
      } else {
        showAlertError("Something went wrong", context);
        return null;
      }
    } catch (e) {
      showAlertError(e.toString(), context);
      return null;
    }
  }

  Future saveCandidateStatusApi(
      BuildContext context, {
        required dynamic data,
        required int isReached,
        int? isShortlisted,
        int? selectionTypeId,
        String? selectionType,
        String? salary,
        String? joiningDate,
        String? joiningPlace,
        String? remarks,
      }) async {
    try {
      int? userId = UserData().model.value.userId;
      int? roleId = UserData().model.value.roleId;

      Map<String, dynamic> body = {
        "ActionName": "CandidateStatuseNew",
        "UserId": userId,
        "RoleId": roleId,
        "EventId": data.eventId,
        "ApplicantID": 0,
        "JobPostID": data.jobPostId,
        "JobSeekerId": data.jobSeekerId,
        "Flag": data.flag,

        /// REQUIRED CASES
        "IsReached": isReached,
        "IsCandidateShortListed": isShortlisted ?? 0,
        "SlectionTypeID": selectionTypeId ?? 0,
        "SelectionType": selectionType ?? "",

        /// OPTIONAL FIELDS
        "SalaryOffered": salary ?? "",
        "Tentativedatejoining": joiningDate,
        "JoiningPlace": joiningPlace ?? "",
        "Remarks": remarks ?? "",
        "UploadedOfferLetterFileName":
        uploadedDocumentPath != null
            ? "Employer/ApplicantOfferLetterPDF/$uploadedDocumentPath"
            : "",

        "UploadedOfferLetterDis_FileName":
        uploadedDocumentPathDIS != null
            ? "Employer/ApplicantOfferLetterPDF/$uploadedDocumentPathDIS"
            : "",
        "FinyearId": 0,
        "FromDate": null,
        "ToDate": null,
      };

      print("SAVE BODY => $body");
      printFullJson(body);

      ApiResponse apiResponse =
      await commonRepo.post("JobFairEvent/SaveApproveCandidateDetail", body);

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        if (responseData["State"] == 200) {
          // successDialog(
          //   context,
          //   responseData["Message"] ?? "Success",
          //       (value) async {
          //     if (value.toString() == "success") {
          //
          //       /// ✅ CLOSE DIALOG
          //     //  Navigator.of(context).pop("success");
          //
          //       /// ✅ REFRESH LIST API
          //       await getJobApplicationList(
          //         context,
          //         yearId: selectedFinancialYear?.financialYearID,
          //         eventId: eventIdController.text,
          //         jobPostID: postIdController.text,
          //         mobile: mobileController.text,
          //         registrationNo: registrationController.text,
          //         applicantName: applicantNameController.text,
          //       );
          //     }
          //   },
          // );

          return true;
        } else {
          showAlertError(responseData["Message"], context);
          return false;
        }
      } else {
        showAlertError("Something went wrong", context);
        return false;
      }
    } catch (e) {
      showAlertError(e.toString(), context);
      return false;
    }
  }

  void printFullJson(Map<String, dynamic> json) {
    const encoder = JsonEncoder.withIndent('  ');
    final prettyString = encoder.convert(json);
    prettyString.split('\n').forEach((line) => debugPrint(line));
  }

  void clearData() {
    jobApplicationList.clear();
    eventNameList.clear();
    eventNameController.clear();
    eventIdController.clear();

    selectedDocumentFile= null;

    mobileController.clear();
    registrationController.clear();
    applicantNameController.clear();

    notifyListeners();
  }
}