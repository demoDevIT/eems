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

class DeptJoinAttendanceListProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  DeptJoinAttendanceListProvider({required this.commonRepo});

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
  //
  // TextEditingController fromDateController = TextEditingController();
  // TextEditingController endDateController = TextEditingController();

  /// FINANCIAL YEAR
  // bool isFinancialYearLoading = false;
  // List<FinancialYearData> financialYearList = [];
  // FinancialYearData? selectedFinancialYear;

  int totalDays = 0;
  int absentDays = 0;
  int presentDays = 0;

  TextEditingController absentController = TextEditingController();

  DateTime selectedMonth = DateTime.now();

  int? selectedYear;
  int? selectedMonthNumber;

  List<int> yearList = [];
  List<int> monthList = List.generate(12, (index) => index + 1);

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
        "Action": "PendingAttendanceByDistrict",
        "PrivateDistrictCode": 108,
        "PrivateDepartmentId": 1,
        "SSOID": "mohdfaizzafar04"
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

  void openAttendancePopup(
      BuildContext context,
      DeptJoinAttendanceItem item,
      ) {

    // Reset values
    final now = DateTime.now();

    // selectedYear = null;
    // selectedMonthNumber = null;

    selectedYear = item.workingYear;
    selectedMonthNumber = item.attendanceMonthId;

    selectedMonth = DateTime(
      selectedYear ?? DateTime.now().year,
      selectedMonthNumber ?? DateTime.now().month,
    );


    // yearList = [
    //   now.year - 1,
    //   now.year,
    //   now.year + 1,
    // ];

    yearList = [item.workingYear ?? DateTime.now().year];


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
                      _labelValue("Name", item.nameEng),
                      _labelValue("Mobile No.", item.mobileNo),
                      _labelValue("Department Name", item.departmentNameEn),
                      _labelValue("Joining Date", item.internJoiningDate),
                      _labelValue("Year", item.workingYear?.toString()),
                      _labelValue("Month", item.attendanceMonthName),

                      const SizedBox(height: 10),
                      const Divider(),
                      const SizedBox(height: 10),

                      /// MONTH PICKER
                      const Text(
                        "Select Month",
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),

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
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
                          contentPadding:
                          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
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
        "JobSeekerID": item.jobseekerUserId,
        "JoiningID": item.joiningID,
        "AttendanceMonthID": item.attendanceMonthId,
        "WorkingYear": item.workingYear,
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

          final String? fileUrl =
          responseData["Data"][0]["CertificatePath"];

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
        "JobSeekerID": item.jobseekerUserId,
        "JoiningID": item.joiningID,
        "AttendanceMonthID": item.attendanceMonthId,
        "WorkingYear": item.workingYear,
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
          await getDeptJoinAttendanceListApi(context);

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

  Future<void> _submitAttendance(
      BuildContext context,
      DeptJoinAttendanceItem item,
      ) async {
    if (absentController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter absent days"),
        ),
      );
      return;
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
      Map<String, dynamic> data = {
        "JobSeekerID": item.jobseekerUserId, // 8253
        "JoiningID": item.joiningID, // static
        "WorkingDaysOfMonth": totalDays,
        "TotalAbsent": absentDays,
        "TotolWorkingDays": presentDays,
        "AttendanceMonthID": item.attendanceMonthId,
        "WorkingYear": item.workingYear,
        "OfficeName": item.officeName,
        "RegistrationNo": item.registrationNo,
        "Name": item.nameEng,
        "FatherName": item.fatherNameEng,
        "Resident": item.address,
        "Tehsil": "",
        "Assembly": item.assembly,
        "DistrictName": item.districtEn,
        "AttendanceLetter": ""
      };

      /// ✅ PRINT FULL REQUEST DATA
      print("========== INSERT ATTENDANCE PAYLOAD ==========");
      print(const JsonEncoder.withIndent('  ').convert(data));
      print("===============================================");

      ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.post(
        "Common/InsertAttendance",
        data,
      );

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response != null &&
          apiResponse.response?.statusCode == 200) {

        var responseData = apiResponse.response?.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        if (responseData["State"] == 200) {
          Navigator.pop(context);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                responseData["Message"] ?? "Attendance Submitted Successfully",
              ),
            ),
          );

          /// 🔄 Refresh list after submit
          getDeptJoinAttendanceListApi(context);
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



  void markAttendance(DeptJoinAttendanceItem item) {
    debugPrint("Mark attendance for: ${item.nameEng}");
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
        "Attendance marked for ${item.nameEng} on ${pickedDate.toIso8601String()}",
      );
    }
  }

  void clearData() {
    attendanceList.clear();
    notifyListeners();
  }

}
