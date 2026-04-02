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

  Map<String, dynamic> staticEsignResponse = {
    "status": "SUCCESS",
    "message": "Signed XML generated successfully",
    "data": {
      "responseCode": "E_0002",
      "responseMsg": "XML Generated Successful, PDF Signing Pending",
      "signedXMLData": "PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIj8+PEVzaWduIEF1dGhNb2RlPSIxIiBhc3BJZD0iSDQ3ZHo3cFljV2ROaGVRT25naVBiSzZua1JSdEhTOEQiIGVreWNJZD0iIiBla3ljSWRUeXBlPSJBIiByZXNwb25zZVNpZ1R5cGU9InBrY3M3IiByZXNwb25zZVVybD0iaHR0cDovL2xvY2FsaG9zdDo0MjAwL2FwaS9FU2lnbi9HZXRFU2lnblJlc3BvbnNlIiBzYz0iWSIgdHM9IjIwMjYtMDQtMDJUMTI6MDE6NTciIHR4bj0iRUVNUzJVQVQwMjA0MjAyNjEyMDQwNDM3OTg4IiB2ZXI9IjIuMSI+CiAgICA8RG9jcz4KICAgICAgICA8SW5wdXRIYXNoIGRvY0luZm89IlRlc3QiIGhhc2hBbGdvcml0aG09IlNIQTI1NiIgaWQ9IjEiPmMyMGZkNzAyN2NkYTM5MjdjMTRjODlmN2MxNmI2Y2RiODRiMTJkYzc3NjYwMDAyYmNmMDBhMmQxZTRjMGRjMTk8L0lucHV0SGFzaD4KICAgIDwvRG9jcz4KPFNpZ25hdHVyZSB4bWxucz0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnIyI+PFNpZ25lZEluZm8+PENhbm9uaWNhbGl6YXRpb25NZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy9UUi8yMDAxL1JFQy14bWwtYzE0bi0yMDAxMDMxNSIvPjxTaWduYXR1cmVNZXRob2QgQWxnb3JpdGhtPSJodHRwOi8vd3d3LnczLm9yZy8yMDAwLzA5L3htbGRzaWcjcnNhLXNoYTEiLz48UmVmZXJlbmNlIFVSST0iIj48VHJhbnNmb3Jtcz48VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvMjAwMC8wOS94bWxkc2lnI2VudmVsb3BlZC1zaWduYXR1cmUiLz48VHJhbnNmb3JtIEFsZ29yaXRobT0iaHR0cDovL3d3dy53My5vcmcvVFIvMjAwMS9SRUMteG1sLWMxNG4tMjAwMTAzMTUiLz48L1RyYW5zZm9ybXM+PERpZ2VzdE1ldGhvZCBBbGdvcml0aG09Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvMDkveG1sZHNpZyNzaGExIi8+PERpZ2VzdFZhbHVlPnFJcHp5MGk1S3NlUXk5Uk9OTlNvck96UUQ3ND08L0RpZ2VzdFZhbHVlPjwvUmVmZXJlbmNlPjwvU2lnbmVkSW5mbz48U2lnbmF0dXJlVmFsdWU+cWxTR0k5Z3VmcWRXcmQzMVNha0lDdTVSYTM5ZWI3UmhLZlJtak5xQ0VMSWYzU2xEZHlmZmFTVlArTXFmWFBFZW5ObDd3aTNkSXNJeAprQmFERzdXbVAzM3JsTUZyaFUvOG9DUWREa3JlRDhhZEJ2NHhSb1l1YWZiT2N3K2JDNjJzTmdjbmtXTzdyWWp5VFFwRHVac3BpU3o4CmNHSHA1VjBMNlFvTi8yRXY3QjhoS0VEdjFoY1hZM2RqRW9HMFI0c01RRmdQd0c2Sk8vaTN6MElmallJSGZNQ0FzTlBTdG9CQnJ4cVAKclJ5R2RZRy85ZXBNQWJYeWE0aFk2S0VyaVhSdit5WnZEaUZ1c2QvSU90TW1JeFFCMVVic29zRGRwQXJhSkJ5NmltbHhnSVBITUMreApSdk1HNGVZdkRHQUUyRGRmemJWazByMGNScDJ5bnNkeXNPT1g4dz09PC9TaWduYXR1cmVWYWx1ZT48S2V5SW5mbz48WDUwOURhdGE+PFg1MDlDZXJ0aWZpY2F0ZT5NSUlGVmpDQ0JENmdBd0lCQWdJR1o3VUpHaGZITUEwR0NTcUdTSWIzRFFFQkN3VUFNSFF4Q3pBSkJnTlZCQVlUQWtsT01TSXdJQVlEClZRUUtFeGxTWVdwRFQwMVFJRWx1Wm04Z1UyVnlkbWxqWlhNZ1RIUmtNUTh3RFFZRFZRUUxFd1pUZFdJdFEwRXhNREF1QmdOVkJBTVQKSjFKaGFrTlBUVkFnYzNWaUxVTkJJR1p2Y2lCRWIyTjFiV1Z1ZENCVGFXZHVaWElnTWpBeU1qQWVGdzB5TlRBek1qZ3dOVE0zTlRKYQpGdzB5T0RBek1qZ3dOVE0zTlRKYU1JR2hNUXN3Q1FZRFZRUUdFd0pKVGpFbU1DUUdBMVVFQ2hNZFVrRktRMDlOVUNCSlRrWlBJRk5GClVsWkpRMFZUSUV4SlRVbFVSVVF4RnpBVkJnTlZCQXNURGtGVlZFZ2dVMGxIVGtGVVQxSlpNUTh3RFFZRFZRUVJFd1l6TURJd01EVXgKRWpBUUJnTlZCQWdUQ1ZKQlNrRlRWRWhCVGpFc01Db0dBMVVFQXhNalJGTWdVa0ZLUTA5TlVDQkpUa1pQSUZORlVsWkpRMFZUSUV4SgpUVWxVUlVRZ01UQXdnZ0VpTUEwR0NTcUdTSWIzRFFFQkFRVUFBNElCRHdBd2dnRUtBb0lCQVFDd3dDOHp5ZHFTcXdJTkNKdU56dnBtCkZjK0tpVWhUbFl4WWdrSWFDSmhCSG81Yzl5OVU2bytPdkVBSncxVGZ2TUc2NUU0eUd6Yk5hNEEveGFLOFdpMGZsV0F5KzdJRUxqY0QKSmQ1dVZEUFh3MEoyc3NVRjExbm5YelJXWEovRXFJaEZPMDNLQ2JZcVdzMkdLanpaWUJxRGs2dUdjbnhPUjFDYVcvbFFsS2FoWWhyeAo0WTBWTXpsRlR5TGY5bW9SKzZTYVkwL2ZQYWgycTJpaytTQ3ZLbEJOS1dQUlo0RTJ1S296eHpUQU9iV3IxcXNWdUUzWXB4NE5ZT213CldJWDB4Y09tZTJyUUJSK2dCb1VEazZ4VUNWMmt6dzV4Znpha1FhN3h2bjhSSEl4SkkwMk9TNHFMZmc0cVBtZjFxVG16OGk2L3JZZGMKVFptRjh1MUhrTk5HMzFJdEFnTUJBQUdqZ2dHK01JSUJ1akFUQmdOVkhTTUVEREFLZ0FoS2ZDNFNIZndrRnpBUkJnTlZIUTRFQ2dRSQpSOHR6T0pzQlpxZ3dnWndHQ0NzR0FRVUZCd0VCQklHUE1JR01NRXdHQ0NzR0FRVUZCekFDaGtCb2RIUndPaTh2Y21Wd2IzTnBkRzl5CmVTNXlZV3BoYzNSb1lXNHVaMjkyTG1sdUwyTmxjblJwWm1sallYUmxMMFJ2WTFOcFoyNWxjakl3TWpJdVkyVnlNRHdHQ0NzR0FRVUYKQnpBQmhqQm9kSFJ3T2k4dmIyTnpjQzV5WVdwaGMzUm9ZVzR1WjI5MkxtbHVMMFJ2WTNWdFpXNTBVMmxuYm1WeU1qQXlNaTh3VWdZRApWUjBmQkVzd1NUQkhvRVdnUTRaQmFIUjBjRG92TDNKbGNHOXphWFJ2Y25rdWNtRnFZWE4wYUdGdUxtZHZkaTVwYmk5amNtd3ZVa2xUClRFUnZZM1Z0Wlc1MFUybG5ibVZ5TWpBeU1pNWpjbXd3SndZRFZSMGdCQ0F3SGpBSUJnWmdnbVJrQWdNd0NBWUdZSUprWkFJQ01BZ0cKQm1DQ1pHUUtBVEFNQmdOVkhSTUJBZjhFQWpBQU1Db0dBMVVkSlFRak1DRUdDQ3NHQVFVRkJ3TUVCZ2txaGtpRzl5OEJBUVVHQ2lzRwpBUVFCZ2pjS0F3d3dLZ1lEVlIwUkJDTXdJWUVmWVc1cGJITnBibWRvTG5KcGMyeEFjbUZxWVhOMGFHRnVMbWR2ZGk1cGJqQU9CZ05WCkhROEJBZjhFQkFNQ0JzQXdEUVlKS29aSWh2Y05BUUVMQlFBRGdnRUJBSk1ZOEtWRWd3YSt5Um1IREtLVTRSOVlJcGRNM0ppNHlGRkUKUzRIemFsL0pwckNkcmFETU11V1l0QXRmY0VqQ29PbU9heVUwZ2VsRFQ0Y3UyL2RDNXZvb2prMlJlUENObDdNanNvalQzR1ZPRUVPVwo3Zjh2elZxODFCZ1drUFoxOXVraVBWTlZEcnl3M2piTllBcTdxeEFYdGNiUjI4Qk5IZGFBSmdxcUk0VlpQbmhRNk43WDFoOVluWFpxCjA4eWdaSWtqUjgxZUYxTE55Q3YxSEpDYnB5Y29EeloxUCtZZTJjSFVjRTJHVEJNWThSV21iTlBVSDRaTjh0VFJDWFNjbit3Ui9VUU4KanI0dWRGOFdZd1RKUkNmWHJEV05JMGZBcFNYMGN5NzRiWEhxM1lpUHlIakE1eDBaVXV6bHJWNktnQVNVS2Jic0NuT1RldDZMRm1QMQpUTms9PC9YNTA5Q2VydGlmaWNhdGU+PFg1MDlJc3N1ZXJTZXJpYWw+PFg1MDlJc3N1ZXJOYW1lPkNOPWVzaWduLCBPVT1lc2lnbiwgTz1lc2lnbiwgTD1JbmRpYSwgQz05MTwvWDUwOUlzc3Vlck5hbWU+PFg1MDlTZXJpYWxOdW1iZXI+MTE0MDI3MjM5NDQ2NDcxPC9YNTA5U2VyaWFsTnVtYmVyPjwvWDUwOUlzc3VlclNlcmlhbD48L1g1MDlEYXRhPjwvS2V5SW5mbz48L1NpZ25hdHVyZT48L0VzaWduPg==",
      "prn": "EEMS2UAT0204202612040437988",
      "txnId": "27603"
    }
  };

  String get base64Xml =>
      staticEsignResponse["data"]["signedXMLData"];

  String get decodedXml =>
      utf8.decode(base64Decode(base64Xml));


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

  // void approveJoining(
  //     BuildContext context,
  //     DeptJoinPendingItem item,
  //     DateTime joiningDate,
  //     ) async {
  //   var isInternet = await UtilityClass.checkInternetConnectivity();
  //   if (!isInternet) {
  //     showAlertError(
  //       AppLocalizations.of(context)!.internet_connection,
  //       context,
  //     );
  //     return;
  //   }
  //
  //   String? deviceId = await UtilityClass.getDeviceId();
  //
  //   try {
  //     Map<String, dynamic> data = {
  //       "JobSeekerUserId": item.jobSeekerUserId,
  //       "PrivateDepartmentID": Userdata().model.value.deptID,
  //       "DeviceId": deviceId,
  //       "ApprovedByUserId": UserData().model.value.userId, //1234,
  //       "InternshipPdfPath": "",
  //       "JoiningDate": DateTime(
  //         joiningDate.year,
  //         joiningDate.month,
  //         joiningDate.day,
  //       ).toIso8601String(),
  //     };
  //
  //     /// ✅ PRINT FULL REQUEST DATA
  //     print("========== approve joining API PAYLOAD ==========");
  //     print(const JsonEncoder.withIndent('  ').convert(data));
  //     print("=========================================");
  //
  //     ProgressDialog.showLoadingDialog(context);
  //
  //     ApiResponse apiResponse = await commonRepo.post(
  //       "Common/ApproveMYSYInternship",
  //       data,
  //     );
  //
  //     ProgressDialog.closeLoadingDialog(context);
  //
  //     if (apiResponse.response != null &&
  //         apiResponse.response?.statusCode == 200) {
  //
  //       var responseData = apiResponse.response?.data;
  //
  //       if (responseData is String) {
  //         responseData = jsonDecode(responseData);
  //       }
  //
  //       /// ✅ Directly read JSON
  //       if (responseData["State"] == 200) {
  //         Navigator.pop(context); // close popup
  //
  //         ScaffoldMessenger.of(context).showSnackBar(
  //           SnackBar(
  //             content: Text(responseData["Message"] ?? "Success"),
  //           ),
  //         );
  //
  //         /// 🔥 Reset search parameters after approval
  //         registrationNumber = null;
  //         jobSeekerId = null;
  //         userId = null;
  //
  //         /// 🔄 Refresh list with normal dashboard data
  //         await getDeptJoinPendingListApi(
  //           context,
  //           registrationNumber: null,
  //           jobSeekerId: null,
  //           userId: null,
  //         );
  //       } else {
  //         showAlertError(
  //           responseData["Message"] ?? "Something went wrong",
  //           context,
  //         );
  //       }
  //     } else {
  //       showAlertError("Something went wrong", context);
  //     }
  //
  //
  //   } catch (e) {
  //     ProgressDialog.closeLoadingDialog(context);
  //     showAlertError(e.toString(), context);
  //   }
  // }

  void approveJoining(
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

    if (true) { // temporary for testing
      String xml = decodedXml;

      String html = """
  <html>
    <body onload="document.forms[0].submit()">
      <form method="POST"
            action="https://esignuat.rajasthan.gov.in:9006/esign/2.1/signdoc/"
            enctype="multipart/form-data">

        <textarea name="esignData">
          ${xml.replaceAll("'", "&apos;")}
        </textarea>

      </form>
    </body>
  </html>
  """;

      /// 🔹 STEP 3: Open WebView
      final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EsignWebViewScreen(htmlData: html),
        ),
      );

      /// 🔹 STEP 4: Handle redirect response
      if (result != null) {
        print("✅ eSign Completed: $result");

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("eSign Completed")),
        );

        /// 🔄 Refresh list after success
        await getDeptJoinPendingListApi(context);
      }
    }

  }

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
