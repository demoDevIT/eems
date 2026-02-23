import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/global.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../modal/dept_join_pending_modal.dart';
import '../modal/financial_year_modal.dart';
import '../modal/level_name_modal.dart';
import '../../register_form/modal/district_modal.dart';

class DeptJoinPendingListProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  DeptJoinPendingListProvider({required this.commonRepo});

  bool isPageLoading = false;

  /// LEVEL
  // bool isLevelLoading = false;
  // List<LevelData> levelList = [];
  // LevelData? selectedLevel;

  /// DISTRICT
  // bool isDistrictLoading = false;
  // List<DistrictData> districtList = [];
  // DistrictData? selectedDistrict;
  // TextEditingController districtController = TextEditingController();
  // TextEditingController districtIdController = TextEditingController();

  /// DATE
  // String? fromDate;
  // String? endDate;

  // TextEditingController fromDateController = TextEditingController();
  // TextEditingController endDateController = TextEditingController();

  /// FINANCIAL YEAR
  // bool isFinancialYearLoading = false;
  // List<FinancialYearData> financialYearList = [];
  // FinancialYearData? selectedFinancialYear;

  // Future<void> initPageApis(BuildContext context) async {
  //   isPageLoading = true;
  //   notifyListeners();
  //
  //   try {
  //     await Future.wait([
  //       getLevelApi(context),
  //       getFinancialYearApi(context),
  //       getDistrictApi(context, 1),
  //     ]);
  //   } catch (e) {
  //     debugPrint("Init API error: $e");
  //   }
  //
  //   isPageLoading = false;
  //   notifyListeners();
  // }
  //
  // Future<void> getLevelApi(BuildContext context) async {
  //   isLevelLoading = true;
  //   levelList.clear();
  //   selectedLevel = null;
  //   notifyListeners();
  //
  //   try {
  //     final apiResponse = await commonRepo.get(
  //       "Common/CommonMasterDataByCode/DDLLevelList_jobFair/0/0",
  //     );
  //
  //     if (apiResponse.response?.statusCode == 200) {
  //       dynamic responseData = apiResponse.response!.data;
  //       if (responseData is String) {
  //         responseData = jsonDecode(responseData);
  //       }
  //
  //       if (responseData['Data'] != null) {
  //         for (var e in responseData['Data']) {
  //           levelList.add(LevelData.fromJson(e));
  //         }
  //       }
  //     }
  //   } catch (_) {
  //     levelList.clear();
  //   }
  //
  //   isLevelLoading = false;
  //   notifyListeners();
  // }
  //
  // Future<void> getDistrictApi(BuildContext context, int stateId) async {
  //   isDistrictLoading = true;
  //   selectedDistrict = null;
  //   districtController.clear();
  //   districtIdController.clear();
  //   notifyListeners();
  //
  //   try {
  //     final apiResponse =
  //     await commonRepo.get("Common/DistrictMaster_StateIDWise/$stateId");
  //
  //     if (apiResponse.response?.statusCode == 200) {
  //       dynamic responseData = apiResponse.response!.data;
  //       if (responseData is String) {
  //         responseData = jsonDecode(responseData);
  //       }
  //
  //       districtList.clear();
  //
  //       if (responseData['Data'] != null) {
  //         for (var e in responseData['Data']) {
  //           districtList.add(DistrictData.fromJson(e));
  //         }
  //       }
  //     }
  //   } catch (_) {
  //     districtList.clear();
  //   }
  //
  //   isDistrictLoading = false;
  //   notifyListeners();
  // }
  //
  // Future<void> getFinancialYearApi(BuildContext context) async {
  //   isFinancialYearLoading = true;
  //   financialYearList.clear();
  //   selectedFinancialYear = null;
  //   notifyListeners();
  //
  //   try {
  //     final apiResponse = await commonRepo.get(
  //       "Common/GetFinancialYear",
  //     );
  //
  //     if (apiResponse.response?.statusCode == 200) {
  //       dynamic responseData = apiResponse.response!.data;
  //       if (responseData is String) {
  //         responseData = jsonDecode(responseData);
  //       }
  //
  //       if (responseData['Data'] != null) {
  //         for (var e in responseData['Data']) {
  //           final fy = FinancialYearData.fromJson(e);
  //           financialYearList.add(fy);
  //
  //           /// 🔵 Auto-select current FY
  //           if (fy.isCurrentFY == 1) {
  //             selectedFinancialYear = fy;
  //           }
  //         }
  //       }
  //     }
  //   } catch (_) {
  //     financialYearList.clear();
  //   }
  //
  //   isFinancialYearLoading = false;
  //   notifyListeners();
  // }
  //
  //
  // Future<void> pickFromDate(BuildContext context) async {
  //   final picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2100),
  //   );
  //
  //   if (picked != null) {
  //     fromDateController.text =
  //         picked.toString().split(" ").first;
  //     notifyListeners();
  //   }
  // }
  //
  // Future<void> pickEndDate(BuildContext context) async {
  //   final picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     firstDate: DateTime(2000),
  //     lastDate: DateTime(2100),
  //   );
  //
  //   if (picked != null) {
  //     endDateController.text =
  //         picked.toString().split(" ").first;
  //     notifyListeners();
  //   }
  // }

  bool isPendingListLoading = false;
  List<DeptJoinPendingItem> pendingList = [];

  Future<DeptJoinPendingModal?> getDeptJoinPendingListApi(
      BuildContext context,
      ) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
      return null;
    }

    try {
      // Map<String, dynamic> body = {
      //   "ActionName": "RSLDCTrainingApprovedApplications",
      //   "DDLLevelID": selectedLevel?.levelID ?? 0,
      //   "UserID": 1820, //UserData().model.value.userId,
      //   "RoleId": 6, //UserData().model.value.roleId,
      //   "DistrictCode": 108, //districtIdController.text, //108
      //   "FinancialYearName": selectedFinancialYear?.financialYearName ?? "",
      //   "FromDate": fromDateController.text,
      //   "EndDate": endDateController.text,
      // };

      Map<String, dynamic> body = {
        "ActionName": "PendingList",
        "DepartmentID": "1",
      };

     // isPendingListLoading = true;
      notifyListeners();

      ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.post(
        // "Common/GetRSLDCTrainingApplicationsList",
        "Common/GetAllotedtraining",
        body,
      );

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        final sm = DeptJoinPendingModal.fromJson(responseData);
        pendingList.clear();

        if (sm.state == 200 && sm.data != null) {
          pendingList.addAll(sm.data!);
        }

        isPendingListLoading = false;
        notifyListeners();
        return sm;
      } else {
        isPendingListLoading = false;
        notifyListeners();
        return DeptJoinPendingModal(
            state: 0, message: "Something went wrong");
      }
    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      isPendingListLoading = false;
      notifyListeners();
      showAlertError(e.toString(), context);
      return DeptJoinPendingModal(state: 0, message: e.toString());
    }
  }

  void onApproveJoining(BuildContext context, DeptJoinPendingItem item) {
    debugPrint(
      "Approve Joining clicked for ${item.nameEng}",
    );

    // 🔜 Future API call
    // approveJoiningApi(item.id);
  }

  Future<void> generateAndOpenInternshipPdf(
      BuildContext context,
      int internshipId,
      ) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
      return;
    }

    try {
      ProgressDialog.showLoadingDialog(context);

      /// 🔹 Call GET API
      ApiResponse apiResponse = await commonRepo.get(
        "Common/GetOrGenerateInternshipCertificatePdf/$internshipId",
      );

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        final String? fileUrl = responseData["FilePath"];
        print("fileURL=> $fileUrl");

        if (fileUrl != null && fileUrl.isNotEmpty) {
          await downloadAndOpenPdf(fileUrl);
        } else {
          showAlertError("File not found", context);
        }
      } else {
        showAlertError("Something went wrong", context);
      }
    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
    }
  }

  Future<void> downloadAndOpenPdf(String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final dir = await getApplicationDocumentsDirectory();

        final filePath =
            "${dir.path}/${DateTime.now().millisecondsSinceEpoch}.pdf";

        final file = File(filePath);

        await file.writeAsBytes(response.bodyBytes);

        await OpenFile.open(filePath);
      }
    } catch (e) {
      debugPrint("PDF download error: $e");
    }
  }



  void onViewJoiningLetter(BuildContext context, DeptJoinPendingItem item) {
    debugPrint(
      "View Joining Letter for ${item.nameEng}",
    );

    // 🔜 Future:
    // open PDF / WebView
  }

  void approveJoining(BuildContext context, DeptJoinPendingItem item) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
        AppLocalizations.of(context)!.internet_connection,
        context,
      );
      return;
    }

    String? deviceId = await UtilityClass.getDeviceId();

    try {
      Map<String, dynamic> data = {
        "JobSeekerUserId": item.jobSeekerUserId,
        "PrivateDepartmentID": 1,
        "DeviceId": deviceId,
        "ApprovedByUserId": UserData().model.value.userId, //1234,
        "InternshipPdfPath": "",
      };

      /// ✅ PRINT FULL REQUEST DATA
      print("========== approve joining API PAYLOAD ==========");
      print(const JsonEncoder.withIndent('  ').convert(data));
      print("=========================================");

      ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.post(
        "Common/ApproveMYSYInternship",
        data,
      );

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response != null &&
          apiResponse.response?.statusCode == 200) {

        var responseData = apiResponse.response?.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        /// ✅ Directly read JSON
        if (responseData["State"] == 200) {
          successDialog(
            context,
            responseData["Message"] ?? "Success",
                (value) {
              if (value.toString() == "success") {
                Navigator.pop(context, true); // return true to previous page
              }
            },
          );
        } else {
          showAlertError(
            responseData["Message"] ?? "Something went wrong",
            context,
          );
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
    /// dropdown selections
    // selectedLevel = null;
    // selectedDistrict = null;
    // selectedFinancialYear = null;
    //
    // districtController.clear();
    // districtIdController.clear();
    //
    // financialYearList.clear();
    //
    // fromDateController.clear();
    // endDateController.clear();

    /// clear list
    pendingList.clear();

    notifyListeners();
  }

}
