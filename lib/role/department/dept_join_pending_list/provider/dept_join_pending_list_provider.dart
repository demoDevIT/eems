import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rajemployment/role/job_seeker/loginscreen/modal/temp_login_modal.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/global.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../../esign_webview/esign_webview_screen.dart';
import '../modal/dept_join_pending_modal.dart';
import '../modal/financial_year_modal.dart';
import '../modal/level_name_modal.dart';
import '../../register_form/modal/district_modal.dart';

class DeptJoinPendingListProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  DeptJoinPendingListProvider({required this.commonRepo});

  bool isPageLoading = false;

  String? registrationNumber;
  String? jobSeekerId;
  String? userId;

  TextEditingController regNoController = TextEditingController();

  // Map<String, dynamic> staticEsignResponse = {
  //   "status": "SUCCESS",
  //   "message": "Signed XML generated successfully",
  //   "data": {
  //     "responseCode": "E_0002",
  //     "responseMsg": "XML Generated Successful, PDF Signing Pending",
  //     "signedXMLData": "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+PEVzaWduIEF1dGhNb2RlPSIxIiBhc3BJZD0idldnQjhxSHNLbjNZNHRiVEF1UG45NEhBQlMxUEdKUEMiIGVreWNJZD0iIiBla3ljSWRUeXBlPSJBIiByZXNwb25zZVNpZ1R5cGU9InBrY3M3IiByZXNwb25zZVVybD0iaHR0cHM6Ly9yYWplbXBsb3ltZW50YXBpLnJhamFzdGhhbi5nb3YuaW4vV2ViQVBJL2FwaS9FU2lnbi9HZXRFU2lnblJlc3BvbnNlIiBzYz0iWSIgdHM9IjIwMjYtMDUtMDRUMTk6NTM6NTEiIHR4bj0iRUVNUzJQUk9EMDQwNTIwMjYxOTUzNTE3MDgxNCIgdmVyPSIyLjEiPgogICAgPERvY3M+CiAgICAgICAgPElucHV0SGFzaCBkb2NJbmZvPSJUZXN0IiBoYXNoQWxnb3JpdGhtPSJTSEEyNTYiIGlkPSIxIj40YWNmYmE5OGFlZDEwNjVmNjAzM2ViZDE4YTBjODYxNzgxMjQzZTA2YmQwOTgxOGQ1NGM5Mjk3YjU2NzFjMGIwPC9JbnB1dEhhc2g+CiAgICA8L0RvY3M+CjxTaWduYXR1cmUgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyMiPjxTaWduZWRJbmZvPjxDYW5vbmljYWxpemF0aW9uTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvVFIvMjAwMS9SRUMteG1sLWMxNG4tMjAwMTAzMTUiLz48U2lnbmF0dXJlTWV0aG9kIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI3JzYS1zaGExIi8+PFJlZmVyZW5jZSBVUkk9IiI+PFRyYW5zZm9ybXM+PFRyYW5zZm9ybSBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyNlbnZlbG9wZWQtc2lnbmF0dXJlIi8+PFRyYW5zZm9ybSBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnL1RSLzIwMDEvUkVDLXhtbC1jMTRuLTIwMDEwMzE1Ii8+PC9UcmFuc2Zvcm1zPjxEaWdlc3RNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjc2hhMSIvPjxEaWdlc3RWYWx1ZT5VenU3UEdZbGF5c2t4TlNHR0JYaTRXMm82ems9PC9EaWdlc3RWYWx1ZT48L1JlZmVyZW5jZT48L1NpZ25lZEluZm8+PFNpZ25hdHVyZVZhbHVlPk93UzJzdWpKazhZRXBWS29pRmVwak92TnVZOW9sMEFobU91RXhRMFEydzl6cldhdE82Vlk1Rm9IK2UzQ0pGVGdRNjFyR0VHV3RYZ3MKYzNnVGxzcUVRVEFSWDh6b3NtL3hmSnVaRlMwOWFtQTZySnp2VWFtOEJtZncxRE13UUE1dEFMQUVYeVZjYW1FTm9pN0VFRFo1aHo0RwpLVFpRcFFOWGRaVjJzVlppLzlVTWxUM2hBbGJoTjBuMWQ3bGdkZk9heFRGOHcyWXhiRjdoK01tVWpYWkVueTI5TVRiUW85c3p6a2lrCkZSY2dtdnRBMUZFcnNKUVJIa1pCQjNLZWxaU1ZuL2FkUlZGTUlVZDBtc3hiUVZYMEtFQVpyU2lGZWtjODM1T1VaWDEzNTRGWGp0OXQKbUpHRTNsYVhvN1h4dENIb2pjRVdia2dXSk54UnYwMW1QcmlNR1E9PTwvU2lnbmF0dXJlVmFsdWU+PEtleUluZm8+PFg1MDlEYXRhPjxYNTA5Q2VydGlmaWNhdGU+TUlJRlZqQ0NCRDZnQXdJQkFnSUdaN1VKR2hmSE1BMEdDU3FHU0liM0RRRUJDd1VBTUhReEN6QUpCZ05WQkFZVEFrbE9NU0l3SUFZRApWUVFLRXhsU1lXcERUMDFRSUVsdVptOGdVMlZ5ZG1salpYTWdUSFJrTVE4d0RRWURWUVFMRXdaVGRXSXRRMEV4TURBdUJnTlZCQU1UCkoxSmhha05QVFZBZ2MzVmlMVU5CSUdadmNpQkViMk4xYldWdWRDQlRhV2R1WlhJZ01qQXlNakFlRncweU5UQXpNamd3TlRNM05USmEKRncweU9EQXpNamd3TlRNM05USmFNSUdoTVFzd0NRWURWUVFHRXdKSlRqRW1NQ1FHQTFVRUNoTWRVa0ZLUTA5TlVDQkpUa1pQSUZORgpVbFpKUTBWVElFeEpUVWxVUlVReEZ6QVZCZ05WQkFzVERrRlZWRWdnVTBsSFRrRlVUMUpaTVE4d0RRWURWUVFSRXdZek1ESXdNRFV4CkVqQVFCZ05WQkFnVENWSkJTa0ZUVkVoQlRqRXNNQ29HQTFVRUF4TWpSRk1nVWtGS1EwOU5VQ0JKVGtaUElGTkZVbFpKUTBWVElFeEoKVFVsVVJVUWdNVEF3Z2dFaU1BMEdDU3FHU0liM0RRRUJBUVVBQTRJQkR3QXdnZ0VLQW9JQkFRQ3d3Qzh6eWRxU3F3SU5DSnVOenZwbQpGYytLaVVoVGxZeFlna0lhQ0poQkhvNWM5eTlVNm8rT3ZFQUp3MVRmdk1HNjVFNHlHemJOYTRBL3hhSzhXaTBmbFdBeSs3SUVMamNECkpkNXVWRFBYdzBKMnNzVUYxMW5uWHpSV1hKL0VxSWhGTzAzS0NiWXFXczJHS2p6WllCcURrNnVHY254T1IxQ2FXL2xRbEthaFlocngKNFkwVk16bEZUeUxmOW1vUis2U2FZMC9mUGFoMnEyaWsrU0N2S2xCTktXUFJaNEUydUtvenh6VEFPYldyMXFzVnVFM1lweDROWU9tdwpXSVgweGNPbWUyclFCUitnQm9VRGs2eFVDVjJrenc1eGZ6YWtRYTd4dm44UkhJeEpJMDJPUzRxTGZnNHFQbWYxcVRtejhpNi9yWWRjClRabUY4dTFIa05ORzMxSXRBZ01CQUFHamdnRytNSUlCdWpBVEJnTlZIU01FRERBS2dBaEtmQzRTSGZ3a0Z6QVJCZ05WSFE0RUNnUUkKUjh0ek9Kc0JacWd3Z1p3R0NDc0dBUVVGQndFQkJJR1BNSUdNTUV3R0NDc0dBUVVGQnpBQ2hrQm9kSFJ3T2k4dmNtVndiM05wZEc5eQplUzV5WVdwaGMzUm9ZVzR1WjI5MkxtbHVMMk5sY25ScFptbGpZWFJsTDBSdlkxTnBaMjVsY2pJd01qSXVZMlZ5TUR3R0NDc0dBUVVGCkJ6QUJoakJvZEhSd09pOHZiMk56Y0M1eVlXcGhjM1JvWVc0dVoyOTJMbWx1TDBSdlkzVnRaVzUwVTJsbmJtVnlNakF5TWk4d1VnWUQKVlIwZkJFc3dTVEJIb0VXZ1E0WkJhSFIwY0RvdkwzSmxjRzl6YVhSdmNua3VjbUZxWVhOMGFHRnVMbWR2ZGk1cGJpOWpjbXd2VWtsVApURVJ2WTNWdFpXNTBVMmxuYm1WeU1qQXlNaTVqY213d0p3WURWUjBnQkNBd0hqQUlCZ1pnZ21Sa0FnTXdDQVlHWUlKa1pBSUNNQWdHCkJtQ0NaR1FLQVRBTUJnTlZIUk1CQWY4RUFqQUFNQ29HQTFVZEpRUWpNQ0VHQ0NzR0FRVUZCd01FQmdrcWhraUc5eThCQVFVR0Npc0cKQVFRQmdqY0tBd3d3S2dZRFZSMFJCQ013SVlFZllXNXBiSE5wYm1kb0xuSnBjMnhBY21GcVlYTjBhR0Z1TG1kdmRpNXBiakFPQmdOVgpIUThCQWY4RUJBTUNCc0F3RFFZSktvWklodmNOQVFFTEJRQURnZ0VCQUpNWThLVkVnd2EreVJtSERLS1U0UjlZSXBkTTNKaTR5RkZFClM0SHphbC9KcHJDZHJhRE1NdVdZdEF0ZmNFakNvT21PYXlVMGdlbERUNGN1Mi9kQzV2b29qazJSZVBDTmw3TWpzb2pUM0dWT0VFT1cKN2Y4dnpWcTgxQmdXa1BaMTl1a2lQVk5WRHJ5dzNqYk5ZQXE3cXhBWHRjYlIyOEJOSGRhQUpncXFJNFZaUG5oUTZON1gxaDlZblhacQowOHlnWklralI4MWVGMUxOeUN2MUhKQ2JweWNvRHpaMVArWWUyY0hVY0UyR1RCTVk4UldtYk5QVUg0Wk44dFRSQ1hTY24rd1IvVVFOCmpyNHVkRjhXWXdUSlJDZlhyRFdOSTBmQXBTWDBjeTc0YlhIcTNZaVB5SGpBNXgwWlV1emxyVjZLZ0FTVUtiYnNDbk9UZXQ2TEZtUDEKVE5rPTwvWDUwOUNlcnRpZmljYXRlPjxYNTA5SXNzdWVyU2VyaWFsPjxYNTA5SXNzdWVyTmFtZT5DTj1lc2lnbiwgT1U9ZXNpZ24sIE89ZXNpZ24sIEw9SW5kaWEsIEM9OTE8L1g1MDlJc3N1ZXJOYW1lPjxYNTA5U2VyaWFsTnVtYmVyPjExNDAyNzIzOTQ0NjQ3MTwvWDUwOVNlcmlhbE51bWJlcj48L1g1MDlJc3N1ZXJTZXJpYWw+PC9YNTA5RGF0YT48L0tleUluZm8+PC9TaWduYXR1cmU+PC9Fc2lnbj4=",
  //     "prn": "EEMS2UAT0204202612040437988",
  //     "txnId": "27603"
  //   }
  // };
  //
  // String get base64Xml =>
  //     staticEsignResponse["data"]["signedXMLData"];
  //
  // String get decodedXml =>
  //     utf8.decode(base64Decode(base64Xml));


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

  Future<void> search(BuildContext context) async {
    if (regNoController.text.trim().isEmpty) {
      showAlertError("Please enter registration number", context);
      return;
    }

    await getDeptJoinPendingListApi(
      context,
      registrationNumber: regNoController.text.trim(),
      jobSeekerId: null,
      userId: null,
    );
  }

  void clearSearch() {
    regNoController.clear();
    pendingList.clear();
    notifyListeners();
  }

  bool isPendingListLoading = false;
  List<DeptJoinPendingItem> pendingList = [];

  Future<DeptJoinPendingModal?> getDeptJoinPendingListApi(
      BuildContext context, {
        String? registrationNumber,
        String? jobSeekerId,
        String? userId,
      }) async {

    final nameAsAdhar = UserData().model.value.NameAsjanAdhar;
    print("nameAsAdhar=> $nameAsAdhar");

    final DistrictEn = UserData().model.value.DistrictEn;
    print("DistrictEn=> $DistrictEn");

    final dept1 = UserData().model.value.departmentId;
    final dept2 = UserData().model.value.deptID;
    print("dept1=> $dept1");
    print("dept2=> $dept2");


    /// Save parameters for future refresh
    this.registrationNumber = registrationNumber ?? this.registrationNumber;
    this.jobSeekerId = jobSeekerId ?? this.jobSeekerId;
    this.userId = userId ?? this.userId;

    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
      return null;
    }

    try {
      Map<String, dynamic> body = {
        "ActionName": "PendingList",
        "DepartmentID": UserData().model.value.deptID,
        "RegistrationNumber": this.registrationNumber, //this.regNoController.text, //this.regNoController.text, //"22092120948", //this.registrationNumber,
        "JobSeekerID": this.jobSeekerId,
        "UserId": UserData().model.value.userId, //"2261663", //UserData().model.value.userId,
        "RoleId": UserData().model.value.roleId,
        "intenjoinned": null,
        "AllotmentDeptId": null
      };

      isPendingListLoading = true;
      notifyListeners();

     // ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.post(
        // "Common/GetRSLDCTrainingApplicationsList",
        "Common/GetAllotedtraining",
        body,
      );

     // ProgressDialog.closeLoadingDialog(context);

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
      // ProgressDialog.closeLoadingDialog(context);
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

  Future<void> approveJoining(
      BuildContext context,
      DeptJoinPendingItem item,
      DateTime joiningDate,
      ) async {
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
        "PrivateDepartmentID": UserData().model.value.deptID,
        "DeviceId": deviceId,
        "NameAsAdhar": UserData().model.value.NameAsjanAdhar, //"Mahesh Saini",
        "ApprovedByUserId": UserData().model.value.userId,
        "Designation": UserData().model.value.designation, //"Education Intern",
        "DeptName": "",
        "Location": UserData().model.value.DistrictEn, //"Barmer",
        "InternshipPdfPath": "",
        "JoiningDate": DateTime(
          joiningDate.year,
          joiningDate.month,
          joiningDate.day,
        ).toIso8601String(),
      };

      /// ✅ PRINT FULL REQUEST DATA
      print("========== approve joining API PAYLOAD ==========");
      print(const JsonEncoder.withIndent('  ').convert(data));
      print("=========================================");

      // return null;
      ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.post(
        // "Common/ApproveMYSYInternship",
        "Common/StartInternshipEsign",
        data,
      );

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response?.statusCode == 200) {
        var responseData = apiResponse.response!.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        /// ✅ Directly read JSON
        if (responseData["State"] == 200) {

          // final staticEsignResponse = {
          //   "status": "SUCCESS",
          //   "message": responseData["Message"],
          //   "data": {
          //     "responseCode": responseData["Data"]["responseCode"],
          //     "responseMsg": responseData["Data"]["responseMsg"],
          //     "signedXMLData": responseData["Data"]["signedXMLData"],
          //     "prn": responseData["Data"]["prn"],
          //     "txnId": responseData["Data"]["txnId"],
          //   }
          // };
          //
          // final base64Xml = staticEsignResponse["data"]["signedXMLData"];

          final base64Xml = responseData["Data"]["signedXMLData"];

          final decodedXml = utf8.decode(base64Decode(base64Xml)).trim();

          /// ✅ STEP 2: DECODE XML
         // String xml = decodedXml;

          /// ✅ STEP 3: CREATE HTML FORM
          String html = """
        <html>
          <body onload="document.forms[0].submit()">
            <form method="POST"
                  action="https://esign.rajasthan.gov.in/esign/2.1/signdoc/"
                  enctype="multipart/form-data">

              <textarea name="esignData">
                ${decodedXml.replaceAll("'", "&apos;")}
              </textarea>

            </form>
          </body>
        </html>
        """;

          /// ✅ STEP 4: OPEN WEBVIEW
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => EsignWebViewScreen(htmlData: html),
            ),
          );

          /// ✅ STEP 5: HANDLE RESULT
          if (result != null) {
            print("✅ eSign Completed: $result");

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("eSign Completed")),
            );

            /// 🔄 REFRESH LIST
            await getDeptJoinPendingListApi(
              context,
              registrationNumber: null,
              jobSeekerId: null,
              userId: null,
            );
          }

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

//   Future<void> approveJoining(
//       BuildContext context,
//       DeptJoinPendingItem item,
//       DateTime joiningDate,
//       ) async {
//     var isInternet = await UtilityClass.checkInternetConnectivity();
//     if (!isInternet) {
//       showAlertError(
//         AppLocalizations.of(context)!.internet_connection,
//         context,
//       );
//       return;
//     }
//
//     if (true) { // temporary for testing
//       String xml = decodedXml;
//
//       String html = """
//   <html>
//     <body onload="document.forms[0].submit()">
//       <form method="POST"
//             action="https://esign.rajasthan.gov.in/esign/2.1/signdoc/"
//             enctype="multipart/form-data">
//
//         <textarea name="esignData">
//           ${xml.replaceAll("'", "&apos;")}
//         </textarea>
//
//       </form>
//     </body>
//   </html>
//   """;
//       print("cccc");
//       /// 🔹 STEP 3: Open WebView
//       final result = await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => EsignWebViewScreen(htmlData: html),
//         ),
//       );
// print("sasasasas");
//       /// 🔹 STEP 4: Handle redirect response
//       if (result != null) {
//         print("✅ eSign Completed: $result");
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("eSign Completed")),
//         );
//
//         /// 🔄 Refresh list after success
//         await getDeptJoinPendingListApi(context);
//       }
//     }
//
//   }

  void openApproveJoiningPopup(
      BuildContext context,
      DeptJoinPendingItem item,
      ) {
    DateTime? selectedDate;
    TextEditingController dateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    const Center(
                      child: Text(
                        "Select Joining Date",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    TextField(
                      controller: dateController,
                      readOnly: true,
                      decoration: InputDecoration(
                        hintText: "Select Date",
                        suffixIcon: const Icon(Icons.calendar_month),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      // onTap: () async {
                      //   final pickedDate = await showDatePicker(
                      //     context: context,
                      //     initialDate: DateTime.now().add(const Duration(days: 1)),
                      //     firstDate: DateTime.now().add(const Duration(days: 1)), // 🔥 FUTURE ONLY
                      //     lastDate: DateTime(2100),
                      //   );
                      //
                      //   if (pickedDate != null) {
                      //     selectedDate = pickedDate;
                      //     dateController.text =
                      //     "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";
                      //     setStateDialog(() {});
                      //   }
                      // },
                      onTap: () async {
                        DateTime now = DateTime.now();

                        /// 🔹 Parse LastActionDate from API
                        DateTime? lastActionDate;

                        if (item.lastActionDate != null &&
                            item.lastActionDate!.isNotEmpty) {
                          lastActionDate = DateTime.parse(item.lastActionDate!);
                        }

                        /// 🔹 If null fallback (safety)
                        lastActionDate ??= DateTime(now.year - 1);

                        /// 🔹 Yesterday (today disabled)
                        // DateTime yesterday =
                        // DateTime(now.year, now.month, now.day)
                        //     .subtract(const Duration(days: 1));

                        /// 🔹 Today (now allowed)
                        DateTime today = DateTime(
                          now.year,
                          now.month,
                          now.day,
                        );

                        /// 🔥 If LastActionDate is after yesterday, prevent picker crash
                        // if (lastActionDate.isAfter(yesterday)) {
                        if (lastActionDate.isAfter(today)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("No valid joining dates available"),
                            ),
                          );
                          return;
                        }

                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: today,
                          firstDate: DateTime(
                            lastActionDate.year,
                            lastActionDate.month,
                            lastActionDate.day,
                          ),
                          lastDate: today,
                        );

                        if (pickedDate != null) {
                          selectedDate = pickedDate;

                          dateController.text =
                          "${pickedDate.day}-${pickedDate.month}-${pickedDate.year}";

                          setStateDialog(() {});
                        }
                      },
                    ),

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      height: 45,
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedDate == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please select joining date"),
                              ),
                            );
                            return;
                          }

                          approveJoining(
                            context,
                            item,
                            selectedDate!,
                          );
                        },
                        child: const Text("Submit"),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
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
    regNoController.clear();
    pendingList.clear();

    notifyListeners();
  }

}
