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

  bool isPageLoading = false;

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

  int totalDays = 0;
  int absentDays = 0;
  int presentDays = 0;

  TextEditingController absentController = TextEditingController();

  DateTime selectedMonth = DateTime.now();

  Future<void> initPageApis(BuildContext context) async {
    isPageLoading = true;
    notifyListeners();

    try {
      await Future.wait([
        getLevelApi(context),
        getFinancialYearApi(context),
        getDistrictApi(context, 1),
      ]);
    } catch (e) {
      debugPrint("Init API error: $e");
    }

    isPageLoading = false;
    notifyListeners();
  }


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

  void openAttendancePopup(
      BuildContext context,
      DeptJoinAttendanceItem item,
      ) {

    // Reset values
    selectedMonth = DateTime.now();
    absentDays = 0;
    absentController.clear();

    _calculateTotalDays();
    _calculatePresentDays();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// HEADER
                      const Center(
                        child: Text(
                          "Mark Attendance",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// USER DETAILS
                      _labelValue("Name", item.name),
                      _labelValue("Father Name", item.fatherName),
                      _labelValue("Scheme Name", item.schemeName),
                      _labelValue("Technical Course", item.technicalCourse),

                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),

                      /// MONTH PICKER
                      const Text(
                        "Select Month",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

                      const SizedBox(height: 8),

                      InkWell(
                        onTap: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedMonth,
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2100),
                            helpText: "Select Month",
                          );

                          if (picked != null) {
                            selectedMonth =
                                DateTime(picked.year, picked.month);

                            _calculateTotalDays();
                            _calculatePresentDays();
                            setStateDialog(() {});
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade400),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${selectedMonth.month}-${selectedMonth.year}",
                              ),
                              const Icon(Icons.calendar_month),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// TOTAL DAYS BOX
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Total No. of Days - $totalDays days",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600),
                        ),
                      ),

                      const SizedBox(height: 20),

                      /// ABSENT FIELD
                      const Text(
                        "No. of Absent Days",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

                      const SizedBox(height: 8),

                      TextField(
                        controller: absentController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: "Enter absent days",
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onChanged: (value) {
                          absentDays = int.tryParse(value) ?? 0;

                          if (absentDays > totalDays) {
                            absentDays = totalDays;
                            absentController.text =
                                totalDays.toString();
                            absentController.selection =
                                TextSelection.fromPosition(
                                    TextPosition(
                                        offset: absentController.text.length));
                          }

                          _calculatePresentDays();
                          setStateDialog(() {});
                        },
                      ),

                      const SizedBox(height: 20),

                      /// PRESENT DAYS BOX
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.green.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          "Total No. of Present Days - $presentDays",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.green,
                          ),
                        ),
                      ),

                      const SizedBox(height: 26),

                      /// SUBMIT BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 45,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            _submitAttendance(context, item);
                          },
                          child: const Text("Submit"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );

          },
        );
      },
    );
  }

  void viewAttendance(
      BuildContext context,
      DeptJoinAttendanceItem item,
      ) {

    // Reset values
    selectedMonth = DateTime.now();
    absentDays = 0;
    absentController.clear();

    _calculateTotalDays();
    _calculatePresentDays();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      /// HEADER
                      const Center(
                        child: Text(
                          "View Attendance",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // /// USER DETAILS
                      // _labelValue("Name", item.name),
                      // _labelValue("Father Name", item.fatherName),
                      // _labelValue("Scheme Name", item.schemeName),
                      // _labelValue("Technical Course", item.technicalCourse),
                      //
                      // const SizedBox(height: 10),
                      // const Divider(),
                      // const SizedBox(height: 10),
                      //
                      // /// MONTH PICKER
                      // const Text(
                      //   "Select Month",
                      //   style: TextStyle(fontWeight: FontWeight.w600),
                      // ),
                      //
                      // const SizedBox(height: 8),
                      //
                      // InkWell(
                      //   onTap: () async {
                      //     final picked = await showDatePicker(
                      //       context: context,
                      //       initialDate: selectedMonth,
                      //       firstDate: DateTime(2000),
                      //       lastDate: DateTime(2100),
                      //       helpText: "Select Month",
                      //     );
                      //
                      //     if (picked != null) {
                      //       selectedMonth =
                      //           DateTime(picked.year, picked.month);
                      //
                      //       _calculateTotalDays();
                      //       _calculatePresentDays();
                      //       setStateDialog(() {});
                      //     }
                      //   },
                      //   child: Container(
                      //     padding: const EdgeInsets.symmetric(
                      //         horizontal: 14, vertical: 14),
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //       border: Border.all(color: Colors.grey.shade400),
                      //     ),
                      //     child: Row(
                      //       mainAxisAlignment:
                      //       MainAxisAlignment.spaceBetween,
                      //       children: [
                      //         Text(
                      //           "${selectedMonth.month}-${selectedMonth.year}",
                      //         ),
                      //         const Icon(Icons.calendar_month),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      //
                      // const SizedBox(height: 20),
                      //
                      // /// TOTAL DAYS BOX
                      // Container(
                      //   padding: const EdgeInsets.all(12),
                      //   decoration: BoxDecoration(
                      //     color: Colors.grey.shade100,
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: Text(
                      //     "Total No. of Days - $totalDays days",
                      //     style: const TextStyle(
                      //         fontWeight: FontWeight.w600),
                      //   ),
                      // ),
                      //
                      // const SizedBox(height: 20),
                      //
                      // /// ABSENT FIELD
                      // const Text(
                      //   "No. of Absent Days",
                      //   style: TextStyle(fontWeight: FontWeight.w600),
                      // ),
                      //
                      // const SizedBox(height: 8),
                      //
                      // TextField(
                      //   controller: absentController,
                      //   keyboardType: TextInputType.number,
                      //   decoration: InputDecoration(
                      //     hintText: "Enter absent days",
                      //     contentPadding: const EdgeInsets.symmetric(
                      //         horizontal: 14, vertical: 14),
                      //     border: OutlineInputBorder(
                      //       borderRadius: BorderRadius.circular(10),
                      //     ),
                      //   ),
                      //   onChanged: (value) {
                      //     absentDays = int.tryParse(value) ?? 0;
                      //
                      //     if (absentDays > totalDays) {
                      //       absentDays = totalDays;
                      //       absentController.text =
                      //           totalDays.toString();
                      //       absentController.selection =
                      //           TextSelection.fromPosition(
                      //               TextPosition(
                      //                   offset: absentController.text.length));
                      //     }
                      //
                      //     _calculatePresentDays();
                      //     setStateDialog(() {});
                      //   },
                      // ),
                      //
                      // const SizedBox(height: 20),
                      //
                      // /// PRESENT DAYS BOX
                      // Container(
                      //   padding: const EdgeInsets.all(12),
                      //   decoration: BoxDecoration(
                      //     color: Colors.green.shade50,
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: Text(
                      //     "Total No. of Present Days - $presentDays",
                      //     style: const TextStyle(
                      //       fontWeight: FontWeight.w600,
                      //       color: Colors.green,
                      //     ),
                      //   ),
                      // ),
                      //
                      // const SizedBox(height: 26),
                      //
                      // /// SUBMIT BUTTON
                      // SizedBox(
                      //   width: double.infinity,
                      //   height: 45,
                      //   child: ElevatedButton(
                      //     style: ElevatedButton.styleFrom(
                      //       shape: RoundedRectangleBorder(
                      //         borderRadius: BorderRadius.circular(10),
                      //       ),
                      //     ),
                      //     onPressed: () {
                      //       _submitAttendance(context, item);
                      //     },
                      //     child: const Text("Submit"),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            );

          },
        );
      },
    );
  }

  void _calculateTotalDays() {
    final firstDay =
    DateTime(selectedMonth.year, selectedMonth.month, 1);

    final lastDay =
    DateTime(selectedMonth.year, selectedMonth.month + 1, 0);

    totalDays = lastDay.day;
  }

  void _calculatePresentDays() {
    presentDays = totalDays - absentDays;
  }

  Widget _labelValue(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            TextSpan(
                text: "$label: ",
                style: const TextStyle(
                    fontWeight: FontWeight.bold)),
            TextSpan(text: value ?? "-"),
          ],
        ),
      ),
    );
  }

  void _submitAttendance(
      BuildContext context,
      DeptJoinAttendanceItem item,
      ) {

    if (absentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter absent days"),
        ),
      );
      return;
    }

    debugPrint("Submitting Attendance:");
    debugPrint("User: ${item.name}");
    debugPrint("Month: ${selectedMonth.month}-${selectedMonth.year}");
    debugPrint("Total Days: $totalDays");
    debugPrint("Absent Days: $absentDays");
    debugPrint("Present Days: $presentDays");

    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Attendance Submitted Successfully"),
      ),
    );

    // 👉 Call API here
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
