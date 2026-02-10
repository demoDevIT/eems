import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/global.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/user_new.dart';
import '../../../../utils/utility_class.dart';
import '../modal/dept_join_attendance_modal.dart';
import '../modal/financial_year_modal.dart';
import '../modal/level_name_modal.dart';
import '../../register_form/modal/district_modal.dart';

class DeptJoinAttendanceListProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  DeptJoinAttendanceListProvider({required this.commonRepo});

  /// LEVEL
  bool isLevelLoading = false;
  List<LevelData> levelList = [];
  LevelData? selectedLevel;

  /// DISTRICT
  bool isDistrictLoading = false;
  List<DistrictData> districtList = [];
  DistrictData? selectedDistrict;
  TextEditingController districtController = TextEditingController();
  TextEditingController districtIdController = TextEditingController();

  /// DATE
  String? fromDate;
  String? endDate;

  TextEditingController fromDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  /// FINANCIAL YEAR
  bool isFinancialYearLoading = false;
  List<FinancialYearData> financialYearList = [];
  FinancialYearData? selectedFinancialYear;



  Future<void> getLevelApi(BuildContext context) async {
    isLevelLoading = true;
    levelList.clear();
    selectedLevel = null;
    notifyListeners();

    try {
      final apiResponse = await commonRepo.get(
        "Common/CommonMasterDataByCode/DDLLevelList_jobFair/0/0",
      );

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        if (responseData['Data'] != null) {
          for (var e in responseData['Data']) {
            levelList.add(LevelData.fromJson(e));
          }
        }
      }
    } catch (_) {
      levelList.clear();
    }

    isLevelLoading = false;
    notifyListeners();
  }

  Future<void> getDistrictApi(BuildContext context, int stateId) async {
    isDistrictLoading = true;
    selectedDistrict = null;
    districtController.clear();
    districtIdController.clear();
    notifyListeners();

    try {
      final apiResponse =
      await commonRepo.get("Common/DistrictMaster_StateIDWise/$stateId");

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        districtList.clear();

        if (responseData['Data'] != null) {
          for (var e in responseData['Data']) {
            districtList.add(DistrictData.fromJson(e));
          }
        }
      }
    } catch (_) {
      districtList.clear();
    }

    isDistrictLoading = false;
    notifyListeners();
  }

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


  Future<void> pickFromDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      fromDateController.text =
          picked.toString().split(" ").first;
      notifyListeners();
    }
  }

  Future<void> pickEndDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      endDateController.text =
          picked.toString().split(" ").first;
      notifyListeners();
    }
  }

  bool isAttendanceLoading = false;
  List<DeptJoinAttendanceItem> attendanceList = [];

  Future<DeptJoinAttendanceModal?> getDeptJoinAttendanceListApi(
      BuildContext context,
      ) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
      return null;
    }

    try {
      Map<String, dynamic> body = {
        "ActionName": "RSLDCTrainingApprovedApplications",
        "DDLLevelID": selectedLevel?.levelID ?? 0,
        "UserID": 1820, //UserData().model.value.userId,
        "RoleId": 6, //UserData().model.value.roleId,
        "DistrictCode": 108, //districtIdController.text, //108
        "FinancialYearName": selectedFinancialYear?.financialYearName ?? "",
        "FromDate": fromDateController.text,
        "EndDate": endDateController.text,
      };

      isAttendanceLoading = true;
      notifyListeners();

      ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.post(
        "Common/GetRSLDCTrainingApplicationsList",
        body,
      );

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        final sm = DeptJoinAttendanceModal.fromJson(responseData);
        attendanceList.clear();

        if (sm.state == 200 && sm.data != null) {
          attendanceList.addAll(sm.data!);
        }

        isAttendanceLoading = false;
        notifyListeners();
        return sm;
      } else {
        isAttendanceLoading = false;
        notifyListeners();
        return DeptJoinAttendanceModal(
            state: 0, message: "Something went wrong");
      }
    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      isAttendanceLoading = false;
      notifyListeners();
      showAlertError(e.toString(), context);
      return DeptJoinAttendanceModal(state: 0, message: e.toString());
    }
  }


  void markAttendance(DeptJoinAttendanceItem item) {
    debugPrint("Mark attendance for: ${item.name}");
    // TODO: API call for marking attendance
  }

  Future<void> pickAttendanceDate(
      BuildContext context,
      DeptJoinAttendanceItem item,
      ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      debugPrint(
        "Attendance marked for ${item.name} on ${pickedDate.toIso8601String()}",
      );
    }
  }

  void clearData() {
    /// dropdown selections
    selectedLevel = null;
    selectedDistrict = null;
    selectedFinancialYear = null;

    districtController.clear();
    districtIdController.clear();

    financialYearList.clear();

    fromDateController.clear();
    endDateController.clear();

    /// clear list
    attendanceList.clear();

    notifyListeners();
  }

}
