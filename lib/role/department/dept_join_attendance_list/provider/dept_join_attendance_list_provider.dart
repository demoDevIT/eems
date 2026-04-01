import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
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
import '../modal/mark_attendance_basic_detail_modal.dart';
import '../modal/month_modal.dart';
import '../modal/year_modal.dart';

class DeptJoinAttendanceListProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  DeptJoinAttendanceListProvider({required this.commonRepo});

  bool isPageLoading = false;

  bool isWholeMonthAbsent = false;

  String? registrationNumber;
  String? jobSeekerId;
  String? userId;

  // *********popup variables**********
  int totalDays = 0;
  int absentDays = 0;
  int presentDays = 0;

  TextEditingController absentController = TextEditingController();

  DateTime selectedMonth = DateTime.now();

  int? selectedYear;
  int? selectedMonthNumber;

  List<int> yearList = [];
  List<int> monthList = List.generate(12, (index) => index + 1);
  // ********popup variables*********

  bool isAttendanceLoading = false;
  List<DeptJoinAttendanceItem> attendanceList = [];

  // ******** filter variables *********
  TextEditingController regNoController = TextEditingController();

  int? filterSelectedYear;
  int? filterSelectedMonthNumber;

//  List<int> FilterMonthList = List.generate(12, (index) => index + 1);

  bool isMonthLoading = false;

  List<MonthData> monthListApi = [];
  MonthData? selectedMonthObj;

  bool isYearLoading = false;

  List<YearData> yearListApi = [];
  YearData? selectedYearObj;

  Future<void> getMonthApi(BuildContext context) async {
    isMonthLoading = true;
    notifyListeners();

    try {
      final apiResponse =
      await commonRepo.get("Common/getMonth");

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        monthListApi.clear();

        if (responseData['Data'] != null) {
          for (var e in responseData['Data']) {
            monthListApi.add(MonthData.fromJson(e));
          }
        }
      }
    } catch (e) {
      monthListApi.clear();
    }

    isMonthLoading = false;
    notifyListeners();
  }

  Future<void> getYearApi(BuildContext context) async {
    isYearLoading = true;
    notifyListeners();

    try {
      // final apiResponse =
      // await commonRepo.get("Common/GetYear");

      Map<String, dynamic> body = {

      };

     // notifyListeners();

      ApiResponse apiResponse = await commonRepo.post(
        "Common/GetYear",
        body,
      );

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        yearListApi.clear();

        if (responseData['Data'] != null) {
          for (var e in responseData['Data']) {
            yearListApi.add(YearData.fromJson(e));
          }
        }
      }
    } catch (e) {
      yearListApi.clear();
    }

    isYearLoading = false;
    notifyListeners();
  }

  void setCurrentYearMonth() {
    final now = DateTime.now();

    /// SET YEAR
    try {
      selectedYearObj = yearListApi.firstWhere(
            (y) => y.name == now.year.toString(),
        orElse: () => yearListApi.isNotEmpty ? yearListApi.first : null!,
      );

      filterSelectedYear = selectedYearObj?.dropID;
    } catch (e) {
      selectedYearObj = null;
      filterSelectedYear = null;
    }

    /// SET MONTH
    try {
      selectedMonthObj = monthListApi.firstWhere(
            (m) => m.dropID == now.month,
        orElse: () => monthListApi.isNotEmpty ? monthListApi.first : null!,
      );

      filterSelectedMonthNumber = selectedMonthObj?.dropID;
    } catch (e) {
      selectedMonthObj = null;
      filterSelectedMonthNumber = null;
    }

    notifyListeners();
  }

  Future<DeptJoinAttendanceModal?> getDeptJoinAttendanceListApi(
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

      // Map<String, dynamic> body = {
      //   "Action": "PendingAttendanceByDistrict",
      //   "PrivateDistrictCode": 108, //UserData().model.value.district, //108,
      //   "PrivateDepartmentId": 1,
      //   "SSOID": UserData().model.value.sso,
      //   "RegistrationNumber": this.registrationNumber,
      //   "JobSeekerID": this.jobSeekerId,
      //   "UserId": this.userId,
      // };

      final districtcode = UserData().model.value.districtCode;
      print("UserData().model.value.districtCode==>$districtcode");
      Map<String, dynamic> body = {
        "ActionName": "PendingAttendanceByDistrict",
        "DistrictCode": UserData().model.value.districtCode, //"108", //UserData().model.value.district, //108,
        "UserID": UserData().model.value.userId, //2261663, //UserData().model.value.userId,
        "RegistrationNumber": this.registrationNumber,
        "OfficeId": UserData().model.value.officeID, //24,
        "StateId": 0,
        "DepartmentID": 1,
        "FYID": selectedYearObj?.name, //filterSelectedYear, //2026
        "MonthId": filterSelectedMonthNumber, //2
        "RoleId": UserData().model.value.roleId,
        "FromDate":null,
        "ToDate":null
      };

      isAttendanceLoading = true;
      notifyListeners();

      //  ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.post(
        // "Common/GetRSLDCTrainingApplicationsList",
        "Common/GetPendingAttendanceByDepartment",
        body,
      );

      // ProgressDialog.closeLoadingDialog(context);

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

  Future<void> search(BuildContext context) async {
    // if (regNoController.text.trim().isEmpty) {
    //   showAlertError("Please enter registration number", context);
    //   return;
    // }

    await getDeptJoinAttendanceListApi(
      context,
      registrationNumber: regNoController.text.trim(),
      jobSeekerId: null,
      userId: null,
    );
  }

  void clearSearch() {
    regNoController.clear();

    /// RESET DROPDOWNS
    selectedYearObj = null;
    selectedMonthObj = null;

    filterSelectedYear = null;
    filterSelectedMonthNumber = null;

    /// CLEAR LIST
    attendanceList.clear();

    notifyListeners();
  }

  void setDefaultFilters() {
    final now = DateTime.now();

    selectedYear = now.year;
    selectedMonthNumber = now.month;

    /// Static year list (for now)
    yearList = [
      now.year - 1,
      now.year,
      now.year + 1,
    ];

    notifyListeners();
  }

  void openAttendancePopup(
    BuildContext context,
    DeptJoinAttendanceItem item,
  ) {
    isWholeMonthAbsent = false;

    // Reset values
    final now = DateTime.now();

    // selectedYear = null;
    // selectedMonthNumber = null;

    selectedYear = item.year;
    selectedMonthNumber = item.monthId;

    selectedMonth = DateTime(
      selectedYear ?? DateTime.now().year,
      selectedMonthNumber ?? DateTime.now().month,
    );

    // yearList = [
    //   now.year - 1,
    //   now.year,
    //   now.year + 1,
    // ];

    yearList = [item.year ?? DateTime.now().year];

    absentDays = 0;
    absentController.clear();

    totalDays = 0;
    presentDays = 0;

    String _getMonthName(int month) {
      const months = [
        "January",
        "February",
        "March",
        "April",
        "May",
        "June",
        "July",
        "August",
        "September",
        "October",
        "November",
        "December",
      ];

      return months[month - 1];
    }

    _calculateTotalDays();
    // _calculatePresentDays();

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
                      // _labelValue("Name", item.nameEng),
                      // _labelValue("Mobile No.", item.mobileNo),
                      // _labelValue("Department Name", item.departmentNameEn),
                      // _labelValue("Joining Date", item.internJoiningDate),
                      // _labelValue("Year", item.workingYear?.toString()),
                      // _labelValue("Month", item.attendanceMonthName),
                      //
                      // const SizedBox(height: 10),
                      // const Divider(),
                      // const SizedBox(height: 10),

                      /// MONTH PICKER
                      // const Text(
                      //   "Select Month",
                      //   style: TextStyle(fontWeight: FontWeight.w600),
                      // ),

                      const SizedBox(height: 8),

                      /// YEAR DROPDOWN
                      const Text(
                        "Select Year",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

                      const SizedBox(height: 8),

                      DropdownButtonFormField<int>(
                        value: selectedYear,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                        ),
                        items: yearList
                            .map(
                              (year) => DropdownMenuItem(
                                value: year,
                                child: Text(year.toString()),
                              ),
                            )
                            .toList(),
                        onChanged: null, // 🔥 DISABLED
                      ),

                      const SizedBox(height: 20),

                      /// MONTH DROPDOWN
                      const Text(
                        "Select Month",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

                      const SizedBox(height: 8),

                      DropdownButtonFormField<int>(
                        value: selectedMonthNumber,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                        ),
                        hint: const Text("Select Month"),
                        items: monthList
                            .map(
                              (month) => DropdownMenuItem(
                                value: month,
                                child: Text(_getMonthName(month)),
                              ),
                            )
                            .toList(),
                        onChanged: null, // 🔥 DISABLED
                      ),

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
                      //     style: const TextStyle(fontWeight: FontWeight.w600),
                      //   ),
                      // ),
                      //
                      // const SizedBox(height: 20),

                      /// WHOLE MONTH ABSENT CHECKBOX
                      Row(
                        children: [
                          Checkbox(
                            value: isWholeMonthAbsent,
                            activeColor: Colors.red,
                            // ✔ Fill color when checked
                            checkColor: Colors.white,
                            // ✔ Tick color
                            side: const BorderSide(
                              color: Colors.red,
                              // ✔ Border color when unchecked
                              width: 2,
                            ),
                            onChanged: (value) {
                              isWholeMonthAbsent = value ?? false;

                              if (isWholeMonthAbsent) {
                                absentDays = 0;
                                presentDays = 0;
                                absentController.clear();
                              }

                              // _calculatePresentDays();
                              setStateDialog(() {});
                            },
                          ),
                          const Text(
                            "Whole Month Absent",
                            style: TextStyle(
                                fontWeight: FontWeight.w600, color: Colors.red),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      if (!isWholeMonthAbsent) ...[
                        /// ABSENT FIELD
                        const Text(
                          "No. of Absent Days",
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),

                        const SizedBox(height: 8),

                        TextField(
                          controller: absentController,
                          // enabled: !isWholeMonthAbsent,
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
                              absentController.text = totalDays.toString();
                              absentController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: absentController.text.length));
                            }

                            _calculatePresentDays();
                            setStateDialog(() {});
                          },
                        ),

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

                        const SizedBox(height: 26),
                      ],

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

  Future<void> viewCertificate(
    BuildContext context,
    DeptJoinAttendanceItem item,
  ) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
        AppLocalizations.of(context)!.internet_connection,
        context,
      );
      return;
    }

    try {
      ProgressDialog.showLoadingDialog(context);

      Map<String, dynamic> body = {
        "JobSeekerID": item.jobSeekerUserId,
       // "JoiningID": item.joiningID,
        "AttendanceMonthID": item.monthId,
        "WorkingYear": item.year,
      };

      /// 🔍 PRINT REQUEST
      print("======= GET ATTENDANCE CERTIFICATE REQUEST =======");
      print(const JsonEncoder.withIndent('  ').convert(body));
      print("==================================================");

      ApiResponse apiResponse = await commonRepo.post(
        "Common/GetAttendanceCertificatePath",
        body,
      );

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        if (responseData["State"] == 200 &&
            responseData["Data"] != null &&
            responseData["Data"].isNotEmpty) {
          final String? fileUrl = responseData["Data"][0]["CertificatePath"];

          print("Certificate URL => $fileUrl");

          if (fileUrl != null && fileUrl.isNotEmpty) {
            await downloadAndOpenPdf(fileUrl);
          } else {
            showAlertError("Certificate not found", context);
          }
        } else {
          showAlertError(
            responseData["Message"] ?? "Certificate not available",
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

  Future<void> approveAttendance(
    BuildContext context,
    DeptJoinAttendanceItem item,
  ) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
        AppLocalizations.of(context)!.internet_connection,
        context,
      );
      return;
    }

    try {
      ProgressDialog.showLoadingDialog(context);

      Map<String, dynamic> body = {
        "JobSeekerID": item.jobSeekerUserId,
       // "JoiningID": item.joiningID,
        "AttendanceMonthID": item.monthId,
        "WorkingYear": item.year,
      };

      /// 🔍 PRINT REQUEST
      print("======= APPROVE ATTENDANCE REQUEST =======");
      print(const JsonEncoder.withIndent('  ').convert(body));
      print("==========================================");

      ApiResponse apiResponse = await commonRepo.post(
        "Common/ApproveAttendanceCertificate",
        body,
      );

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        /// ✅ Show API Message (Success or Fail)
        String message = responseData["Message"] ?? "Something went wrong";

        if (responseData["State"] == 200) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );

          /// 🔄 Refresh List After Approval
          /// 🔥 Reset filters after approval
          registrationNumber = null;
          jobSeekerId = null;
          userId = null;

          /// 🔄 Refresh list
          await getDeptJoinAttendanceListApi(
            context,
            registrationNumber: null,
            jobSeekerId: null,
            userId: null,
          );
        } else {
          showAlertError(message, context);
        }
      } else {
        showAlertError("Something went wrong", context);
      }
    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
    }
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
    //  _calculatePresentDays();

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
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
    final firstDay = DateTime(selectedMonth.year, selectedMonth.month, 1);

    final lastDay = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);

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
                style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value ?? "-"),
          ],
        ),
      ),
    );
  }

  Future<MarkAttendanceBasicDetails?> getMarkAttendanceBasicDetails(
      BuildContext context,
      DeptJoinAttendanceItem item,
      ) async {
    try {
      final month = item.monthId!.toString().padLeft(2, '0');
      final year = item.year.toString();

      final body = {
        "ActionName": "MarkAttendanceBasicDeatils",
        "JobSeekerUserId": item.jobSeekerUserId,
        "JobSeekerID": item.jobSeekerID,
        "INPUT_AttendanceMonth": "$year$month", // 🔥 202602
      };

      print("========== FINAL First API ==========");
      print(const JsonEncoder.withIndent('  ').convert(body));
      print("==========================================");

      ApiResponse apiResponse = await commonRepo.post(
        "Common/GetMarkAttendanceBasicDeatils",
        body,
      );

      if (apiResponse.response?.statusCode == 200) {
        var data = apiResponse.response!.data;

        if (data is String) {
          data = jsonDecode(data);
        }

        if (data["State"] == 200 && data["Data"] != null && data["Data"].isNotEmpty) {
          return MarkAttendanceBasicDetails.fromJson(data["Data"][0]);
        }
      }

      return null;
    } catch (e) {
      showAlertError(e.toString(), context);
      return null;
    }
  }

  Future<void> _submitAttendance(
    BuildContext context,
    DeptJoinAttendanceItem item,
  ) async {
    // ✅ Validate only when NOT whole month absent
    if (!isWholeMonthAbsent && absentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter absent days"),
        ),
      );
      return;
    }

    // If whole month absent → set values properly
    if (isWholeMonthAbsent) {
      absentDays = totalDays;
      presentDays = 0;
    } else {
      absentDays = int.tryParse(absentController.text) ?? 0;
      presentDays = totalDays - absentDays;
    }

    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
        AppLocalizations.of(context)!.internet_connection,
        context,
      );
      return;
    }

    try {
      ProgressDialog.showLoadingDialog(context);

      /// 🔥 STEP 1: CALL FIRST API
      final basicData = await getMarkAttendanceBasicDetails(context, item);

      if (basicData == null) {
        ProgressDialog.closeLoadingDialog(context);
        showAlertError("Unable to fetch basic details", context);
        return;
      }

      /// 🔥 FORMAT MONTH
      final monthNumber = item.monthId!.toString().padLeft(2, '0');
      final year = item.year.toString();

      final monthName = selectedMonthObj?.name ?? "";

      /// 🔥 STEP 2: FINAL PAYLOAD
      Map<String, dynamic> data = {
        "UserID": UserData().model.value.userId,
        "RoleID": UserData().model.value.roleId,
        "JobSeekerID": item.jobSeekerID,
        "JobSeekerUserId": item.jobSeekerUserId,
        "JoiningID": basicData.joiningID,

        "totalDays": totalDays,
        "workingDays": presentDays,
        "absentDays": absentDays,

        "AttendanceMonthID": item.monthId,
        "WorkingYear": item.year,
        "fullAbsent": isWholeMonthAbsent,

        "RegistrationNo": basicData.registrationNo,
        "applicantName": basicData.applicantName,
        "fatherName": basicData.fatherName,
        "joiningDate": basicData.joiningDate,
        "departmentName": basicData.departmentName,
        "Address": basicData.address,
        "Assembly": "",
        "DistrictName": basicData.districtName,

        "AttendanceLetter": "",
        "attendanceMonth": "$year-$monthNumber", // 🔥 2026-02
        "MonthName": monthName,
        "OtherDocument": "",
        "AttendanceReasonID": 0,
        "BaseUrl": "http://localhost:5000/",
      };

      // Map<String, dynamic> data = {
      //   "JobSeekerID": item.jobSeekerUserId, // 8253
      //   //"JoiningID": item.joiningID, // static
      //   "WorkingDaysOfMonth": totalDays,
      //   "TotalAbsent": absentDays,
      //   "TotolWorkingDays": presentDays,
      //   "AttendanceMonthID": item.monthId,
      //   "WorkingYear": item.year,
      //   //"OfficeName": item.officeName,
      //   "RegistrationNo": item.registrationNo,
      //   "Name": item.name,
      //   "FatherName": item.fName,
      //   //"Resident": item.address,
      //   "Tehsil": "",
      //   //"Assembly": item.assembly,
      //  // "DistrictName": item.districtEn,
      //   "AttendanceLetter": "",
      //   "IsWholeMonthAbsent": isWholeMonthAbsent ? 1 : 0, //whole month 1
      // };

      /// 🔍 DEBUG
      print("========== FINAL INSERT PAYLOAD ==========");
      print(const JsonEncoder.withIndent('  ').convert(data));
      print("==========================================");

      /// 🔥 STEP 3: CALL FINAL API
      ApiResponse apiResponse = await commonRepo.post(
        "Common/InsertAttendance",
        data,
      );

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response?.statusCode == 200) {
        var responseData = apiResponse.response!.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        if (responseData["State"] == 200) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseData["Message"])),
          );

          /// 🔄 Refresh list
          await getDeptJoinAttendanceListApi(context);
        } else {
          showAlertError(responseData["Message"], context);
        }
      } else {
        showAlertError("Something went wrong", context);
      }
    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
    }
  }

  // void markAttendance(DeptJoinAttendanceItem item) {
  //   debugPrint("Mark attendance for: ${item.name}");
  //   // TODO: API call for marking attendance
  // }

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
    attendanceList.clear();
    notifyListeners();
  }
}
