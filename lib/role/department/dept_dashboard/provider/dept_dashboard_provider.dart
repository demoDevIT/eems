import 'dart:convert';

import 'package:flutter/material.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/app_shared_prefrence.dart';
import '../../../../utils/encryption_helper.dart';
import '../../../../utils/global.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/right_to_left_route.dart';
import '../../../../utils/user_new.dart';
import '../../../../utils/utility_class.dart';
import '../../../job_seeker/candidate_attendance/dashboard_screen.dart';
import '../../../job_seeker/candidate_attendance/provider/dashboard_provider.dart';
import '../../dept_join_attendance_list/dept_join_attendance_list.dart';
import '../../dept_join_pending_list/dept_join_pending_list.dart';
import '../dept_dashboard.dart';
import '../modal/attendance_overview_modal.dart';
import '../modal/dept_info_modal.dart';
import '../modal/joining_overview_modal.dart';
import '../modal/role_modal.dart';
import 'package:provider/provider.dart';

class DepartmentDashboardProvider extends ChangeNotifier {
   final CommonRepo commonRepo;
   DepartmentDashboardProvider({required this.commonRepo});
  /// Future use:
  /// - API calls
  /// - Navigation logic
  /// - Badge counts (pending list count)

  bool showRegSearch = false;
  bool showResult = false;

  TextEditingController regNoController = TextEditingController();

   ///role dropdown
   bool isRoleLoading = false;

   List<RoleData> roleList = [];
   RoleData? selectedRole;

   final TextEditingController roleNameController = TextEditingController();
   final TextEditingController roleIdController = TextEditingController();

   bool isJoiningOverviewLoading = false;

   JoiningOverviewData? joiningOverviewData;

   int get joiningTotal =>
       joiningOverviewData?.totalApplications ?? 0;

   int get joiningCompleted =>
       joiningOverviewData?.completed ?? 0;

   int get joiningPending =>
       joiningOverviewData?.pending ?? 0;

   double get joiningCompletionPercentage {
     if (joiningTotal == 0) {
       return 0;
     }

     return joiningCompleted / joiningTotal;
   }

   String get joiningCompletionPercentageText {
     return "${(joiningCompletionPercentage * 100).round()}%";
   }

   bool isAttendanceOverviewLoading = false;

   List<AttendanceOverviewData> attendanceOverviewList = [];

   String selectedAttendanceMonth = "All";

   final List<String> attendanceMonths = [
     "All",
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

   AttendanceOverviewData? get selectedAttendanceData {
     if (selectedAttendanceMonth == "All") {
       return null;
     }

     try {
       return attendanceOverviewList.firstWhere(
             (item) => item.monthName == selectedAttendanceMonth,
       );
     } catch (_) {
       return null;
     }
   }

   int get attendanceVerified {
     if (selectedAttendanceMonth == "All") {
       return attendanceOverviewList.fold(
         0,
             (sum, item) => sum + (item.verified ?? 0),
       );
     }

     return selectedAttendanceData?.verified ?? 0;
   }

   int get attendanceSubmitted {
     if (selectedAttendanceMonth == "All") {
       return attendanceOverviewList.fold(
         0,
             (sum, item) => sum + (item.completed ?? 0),
       );
     }

     return selectedAttendanceData?.completed ?? 0;
   }

   int get attendanceSendback {
     if (selectedAttendanceMonth == "All") {
       return attendanceOverviewList.fold(
         0,
             (sum, item) => sum + (item.sendback ?? 0),
       );
     }

     return selectedAttendanceData?.sendback ?? 0;
   }

   int get attendancePending {
     if (selectedAttendanceMonth == "All") {
       return attendanceOverviewList.fold(
         0,
             (sum, item) => sum + (item.pending ?? 0),
       );
     }

     return selectedAttendanceData?.pending ?? 0;
   }

   int get attendanceTotalApplications {
     if (selectedAttendanceMonth == "All") {
       return attendanceOverviewList.fold(
         0,
             (sum, item) => sum + (item.totalApplications ?? 0),
       );
     }

     return selectedAttendanceData?.totalApplications ?? 0;
   }

   Future<void> searchByRegistration(BuildContext context) async {

     if (regNoController.text.isEmpty) {
       showAlertError("Please enter Registration Number", context);
       return;
     }

     var isInternet = await UtilityClass.checkInternetConnectivity();

     if (!isInternet) {
       showAlertError("No Internet Connection", context);
       return;
     }

     try {

       ProgressDialog.showLoadingDialog(context);

       Map<String, dynamic> body = {
         "RegistrationNumber": regNoController.text,
         "JobSeekerID": null,
         "UserID": null
       };

       print("API Request Body: $body");

       ApiResponse apiResponse = await commonRepo.post(
         "Jobseeker/GetMYSYInternStatus",
         body,
       );

       ProgressDialog.closeLoadingDialog(context);

       if (apiResponse.response?.statusCode == 200) {

         dynamic responseData = apiResponse.response!.data;

         if (responseData is String) {
           responseData = jsonDecode(responseData);
         }

         print("API Response: $responseData");

         /// ✅ CHECK API STATE FIRST
         if (responseData['State'] != 200 || responseData['Data'] == null) {

           String errorMsg = responseData['ErrorMessage'] ??
               responseData['Message'] ??
               "Something went wrong";

           showAlertError(errorMsg, context);
           return;
         }

         String status = responseData['Data'][0]['Status'];

         print("Status: $status");

         /// Navigation based on status
         if (status == "Get Pending Attendance List") {

           Navigator.push(
             context,
             MaterialPageRoute(
               builder: (_) => DeptJoinAttendanceListScreen(
                 registrationNumber: regNoController.text,
                 jobSeekerId: null,
                 userId: null,
               ),
             ),
           );

         } else if (status == "Pending for Approval") {

           Navigator.push(
             context,
             MaterialPageRoute(
               builder: (_) => DeptJoinPendingListScreen(
                 registrationNumber: regNoController.text,
                 jobSeekerId: null,
                 userId: null,
               ),
             ),
           );

         } else {
           showAlertError("$status", context);
         }

       } else {
         showAlertError("Something went wrong", context);
       }

     } catch (e) {
       ProgressDialog.closeLoadingDialog(context);
       showAlertError(e.toString(), context);
     }
   }

  void openRegSearch() {
    showRegSearch = true;
    showResult = false;
    notifyListeners();
  }

  void submitSearch() {
    if (regNoController.text.isNotEmpty) {
      showResult = true; // static result for now
      notifyListeners();
    }
  }

   void reset() {
     showRegSearch = false;
     showResult = false;
     regNoController.clear();
     notifyListeners();
   }

  void onRegisterMYSY(BuildContext context) {
    debugPrint("Register yourself for MYSY clicked");
    // TODO: Navigate to MYSY registration page
  }

  void onPendingDepartmentJoining(BuildContext context) {
    debugPrint("Pending list for department joining clicked");
    // TODO: Navigate to pending list page
  }

   Future<void> getRoleApi(BuildContext context, String districtCode) async {
     isRoleLoading = true;

     selectedRole = null;
     roleNameController.clear();
     roleIdController.clear();
     roleList.clear();

     notifyListeners();

     final userSSO = UserData().model.value.sso;
     final deptId = UserData().model.value.deptID;
     final roleId = UserData().model.value.roleId;

     try {
       // final apiResponse =
       // // await commonRepo.get("Authentication/GetUserRoleList/VIVEKBHARDWAJ/1/false/6");
       // await commonRepo.get("Authentication/GetUserRoleList/$userSSO/$deptId/false/$roleId");

       Map<String, dynamic> body = {
         "SSOID": userSSO,
         "DepartmentID": deptId,
         "IsWeb": false,
         "RoleID": roleId
       };
       ApiResponse apiResponse = await commonRepo.post("Authentication/GetUserRoleList",body);

       if (apiResponse.response?.statusCode == 200) {
         dynamic responseData = apiResponse.response!.data;
         if (responseData is String) {
           responseData = jsonDecode(responseData);
         }

         if (responseData['Data'] != null) {
           for (var e in responseData['Data']) {
             roleList.add(RoleData.fromJson(e));
           }
         }
         print(RoleData);
       }
     } catch (_) {
       roleList.clear();
     }

     isRoleLoading = false;
     notifyListeners();
   }

   Future<void> GetSSOUserDetail(BuildContext context, {
     required int switchRoleID,
     required int switchOfficeID,
     required int intDeptTypeID,
     required int intDeptID,
   }) async {

     print("GetSSOUserDetail function call");
     var isInternet = await UtilityClass.checkInternetConnectivity();

     if (!isInternet) {
       showAlertError("No Internet Connection", context);
       return;
     }

     try {

       ProgressDialog.showLoadingDialog(context);

       Map<String, dynamic> body = {
         "SearchRecordID": UserData().model.value.searchRecID,
         "SwitchRoleID": switchRoleID,
         "SwitchOfficeID": switchOfficeID,
         "InternshipDeptTypeID": intDeptTypeID,
         "InternshipDeptID": intDeptID,
       };

       print("API Request Body: $body");

       ApiResponse apiResponse = await commonRepo.post(
         "Authentication/GetSSOUserDetailsNew",
         body,
       );

       ProgressDialog.closeLoadingDialog(context);

       if (apiResponse.response?.statusCode == 200) {

         dynamic responseData = apiResponse.response!.data;

         if (responseData is String) {
           responseData = jsonDecode(responseData);
         }

         print("API Response userdata for switch user : $responseData");

         /// ✅ CHECK API STATE FIRST
         if (responseData['State'] != 200 || responseData['Data'] == null) {

           String errorMsg = responseData['ErrorMessage'] ??
               responseData['Message'] ??
               "Something went wrong";

           showAlertError(errorMsg, context);
           return;
         }

         int userID = responseData['Data']['UserID'];
         int roleID = responseData['Data']['RoleID'];
         String SSOID = responseData['Data']['SSOID'];
         int internshipDeptID = responseData['Data']['InternshipDeptID'];
         int internshipDeptTypeID = responseData['Data']['InternshipDeptTypeID'];

         print("userID: $userID");
         print("roleID: $roleID");
         print("SSOID: $SSOID");

         if(roleID == 22){
           print("role ID 22");
           //redirect to dept dashboard
           //callbasicdetail API for department getDeptBasicDetails
           UserData().model.value.roleId = responseData['Data']['RoleID'];
           UserData().model.value.officeID = responseData['Data']['OfficeID'];
           UserData().model.value.districtCode = responseData['Data']['DistrictCode'];
           UserData().model.value.deptID = responseData['Data']['DepartmentID'];
           UserData().model.value.internshipDeptID = responseData['Data']['InternshipDeptID'];
           UserData().model.value.internshipDeptTypeID = responseData['Data']['InternshipDeptTypeID'];
           UserData().model.value.NameAsjanAdhar = responseData['Data']['NameAsjanAdhar'];
           UserData().model.value.DistrictEn = responseData['Data']['DistrictEn'];
           UserData().model.value.designation = responseData['Data']['Designation'];
           UserData().model.value.roleName = responseData['Data']['RoleName'];
           UserData().model.value.exchangeName = responseData['Data']['ExchangeName'];
           UserData().model.value.deptNameEn = responseData['Data']['DepartmentNameEn'];
           UserData().model.value.allotDeptName = responseData['Data']['AllotmentDeptName'];

           getDeptBasicDetails(
               context, userID.toString(), roleID, SSOID.toString(), internshipDeptID, internshipDeptTypeID);
         }else{
           print("role ID other=> $roleID");
           //redirect to job fair (dashboard page)
           UserData().model.value.roleId = responseData['Data']['RoleID'];
           UserData().model.value.officeID = responseData['Data']['OfficeID'];
           UserData().model.value.districtCode = responseData['Data']['DistrictCode'];
           UserData().model.value.deptID = responseData['Data']['DepartmentID'];
           UserData().model.value.internshipDeptID = responseData['Data']['InternshipDeptID'];
           UserData().model.value.internshipDeptTypeID = responseData['Data']['InternshipDeptTypeID'];
           UserData().model.value.NameAsjanAdhar = responseData['Data']['NameAsjanAdhar'];
           UserData().model.value.DistrictEn = responseData['Data']['DistrictEn'];
           UserData().model.value.designation = responseData['Data']['Designation'];
           UserData().model.value.userId = userID;
           UserData().model.value.sso = SSOID;
           UserData().model.value.roleId = roleID;
           UserData().model.value.name = responseData['Data']['Name'];
           UserData().model.value.roleName = responseData['Data']['RoleName'];
           UserData().model.value.exchangeName = responseData['Data']['ExchangeName'];
           // UserData().model.value.searchRecID = sm.data!.searchRecordID;
           // UserData().model.value.deptID = sm.data!.deptID;

           print("userDATA-------->");
           Navigator.of(context).push(
             RightToLeftRoute(
               page: ChangeNotifierProvider(
                 create: (_) =>
                     DashboardProvider(
                       commonRepo: commonRepo, // ✅ FIX
                     ),
                 child: const DashboardScreen(),
               ),
               duration: const Duration(milliseconds: 500),
               startOffset: const Offset(-1.0, 0.0),
             )
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

   Future<DeptInfoModal?> getDeptBasicDetails(
       BuildContext context, String userId, int? roleId, String ssoID, int? intDeptID, int? intDeptTypeID) async {
     var isInternet = await UtilityClass.checkInternetConnectivity();
     if (isInternet) {
       try {
         Map<String, dynamic> body = {
           "UserID": userId,
           "SSOID": ssoID,
           "RoleID": roleId, //22, //roleId
           "InternshipDeptTypeID": intDeptTypeID,
           "InternshipDeptID": intDeptID
         };
         ProgressDialog.showLoadingDialog(context);
         ApiResponse apiResponse =
         await commonRepo.post("Common/GetInternshipDepartmentUserProfile", body);
         ProgressDialog.closeLoadingDialog(context);
         if (apiResponse.response != null &&
             apiResponse.response?.statusCode == 200) {
           var responseData = apiResponse.response?.data;
           if (responseData is String) {
             responseData = jsonDecode(responseData);
           }
           String? authToken =
               apiResponse.response?.headers?['x-authtoken']?.first;
           print(authToken);
           final sm = DeptInfoModal.fromJson(responseData);
           if (sm.state == 200) {
             final pref = AppSharedPref();
             UserData().model.value.userId = sm.data![0].userID;
             UserData().model.value.roleId = roleId;
             UserData().model.value.name = sm.data![0].name;
             UserData().model.value.mobileNo = sm.data![0].mobileNo;
             UserData().model.value.userType = sm.data![0].userType;
             UserData().model.value.office = sm.data![0].office;
             UserData().model.value.empNumber = sm.data![0].empNumber;
             UserData().model.value.firstName = sm.data![0].firstName;
             UserData().model.value.lastName = sm.data![0].lastName;
             UserData().model.value.postalAddress = sm.data![0].postalAddress;
             UserData().model.value.mailPersonal = sm.data![0].mailPersonal;
             UserData().model.value.mailOfficial = sm.data![0].mailOfficial;
             UserData().model.value.gENDER = sm.data![0].gender;
             UserData().model.value.territoryType = sm.data![0].territoryType;
             UserData().model.value.village = sm.data![0].village;
             UserData().model.value.gp = sm.data![0].gp;
             UserData().model.value.block = sm.data![0].block;
             UserData().model.value.city = sm.data![0].city;
             UserData().model.value.sso = ssoID;
             UserData().model.value.isLogin = true;
             pref.save('UserData', UserData().model.value);

             // Navigator.of(context).push(
             //   RightToLeftRoute(
             //     page: const DepartmentDashboardPage(),
             //     duration: const Duration(milliseconds: 500),
             //     startOffset: const Offset(-1.0, 0.0),
             //   )
             // );

             Navigator.of(context).push(
                 RightToLeftRoute(
                   page: ChangeNotifierProvider(
                     create: (_) =>
                         DepartmentDashboardProvider(
                           commonRepo: commonRepo, // ✅ FIX
                         ),
                     child: const DepartmentDashboardPage(),
                   ),
                   duration: const Duration(milliseconds: 500),
                   startOffset: const Offset(-1.0, 0.0),
                 )
             );
             return sm;
           } else {
             final smmm = DeptInfoModal(
                 state: 0, message: sm.message.toString());

             showAlertError(
                 smmm.message.toString().isNotEmpty
                     ? smmm.message.toString()
                     : "Invalid SSO ID and Password",
                 context);
             return smmm;
           }
         } else {
           return DeptInfoModal(
             state: 0,
             message: 'Something went wrong',
           );
         }
       } on Exception catch (err) {
         ProgressDialog.closeLoadingDialog(context);
         final sm = DeptInfoModal(state: 0, message: err.toString());
         showAlertError(sm.message.toString(), context);
         return sm;
       }
     } else {
       showAlertError(
           AppLocalizations.of(context)!.internet_connection, context);
     }
   }

   Future<void> getJoiningOverview(BuildContext context) async {
     var isInternet = await UtilityClass.checkInternetConnectivity();

     if (!isInternet) {
       showAlertError("No Internet Connection", context);
       return;
     }

     try {
       isJoiningOverviewLoading = true;
       notifyListeners();

       final userData = UserData().model.value;

       Map<String, dynamic> body = {
         "ActionName": "JoiningOverview",
         "UserId": userData.userId,
         "RoleId": userData.roleId,
         "InternDepartmentTypeID": userData.internshipDeptTypeID,
         "AllotmentDeptId": userData.internshipDeptID,
         "OfficeID": userData.officeID,
         "AttendanceMonthID": 0,
         "WorkingYear": 0,
       };

       print("Joining Overview API Request Body: $body");

       ApiResponse apiResponse = await commonRepo.post(
         "Dashboard/GetJoiningOverview",
         body,
       );

       if (apiResponse.response?.statusCode == 200) {
         dynamic responseData = apiResponse.response!.data;
         print("cc");
         if (responseData is String) {
           responseData = jsonDecode(responseData);
         }

         print("Joining Overview API Response: $responseData");

         if (responseData['State'] != 200 ||
             responseData['Data'] == null ||
             responseData['Data'].isEmpty) {
           String errorMsg = responseData['ErrorMessage'] ??
               responseData['Message'] ??
               "Something went wrong";

           joiningOverviewData = null;

           showAlertError(errorMsg, context);
           return;
         }
         print("bb");
         final JoiningOverviewModal modal =
         JoiningOverviewModal.fromJson(responseData);

         if (modal.data != null && modal.data!.isNotEmpty) {
           joiningOverviewData = modal.data!.first;
         } else {
           joiningOverviewData = null;
         }
       } else {
         print("aa");
         joiningOverviewData = null;
         showAlertError("Something went wrong", context);
       }
     } catch (e) {
       print("Joining Overview API Error: $e");

       joiningOverviewData = null;

       showAlertError(e.toString(), context);
     } finally {
       isJoiningOverviewLoading = false;
       notifyListeners();
     }
   }

   Future<void> getAttendanceOverview(BuildContext context) async {
     final isInternet =
     await UtilityClass.checkInternetConnectivity();

     if (!isInternet) {
       showAlertError("No Internet Connection", context);
       return;
     }

     try {
       isAttendanceOverviewLoading = true;
       notifyListeners();

       final userData = UserData().model.value;

       final Map<String, dynamic> body = {
         "ActionName": "AttendanceOverview",
         "UserId": userData.userId ?? 0,
         "RoleId": userData.roleId ?? 0,
         "InternDepartmentTypeID":
         userData.internshipDeptTypeID ?? 0,
         "AllotmentDeptId":
         userData.internshipDeptID ?? 0,
         "OfficeID":
         userData.officeID ?? 0,

         // All means API receives 0.
         // Single month will send month number.
         "AttendanceMonthID": selectedAttendanceMonth == "All"
             ? 0
             : _getMonthNumber(selectedAttendanceMonth),

         // Keep 0 for now as per your payload.
         "WorkingYear": 0,
       };

       print(
         "Attendance Overview API Request Body: $body",
       );

       final ApiResponse apiResponse = await commonRepo.post(
         "Dashboard/GetAttendanceOverview",
         body,
       );

       if (apiResponse.response?.statusCode == 200) {
         dynamic responseData = apiResponse.response!.data;
  print("pp");
         if (responseData is String) {
           responseData = jsonDecode(responseData);
         }

         print(
           "Attendance Overview API Response: $responseData",
         );
         print("qq");
         if (responseData['State'] != 200 ||
             responseData['Data'] == null) {
           attendanceOverviewList.clear();
           print("yy");
           final String errorMsg =
               responseData['ErrorMessage'] ??
                   responseData['Message'] ??
                   "Something went wrong";

           showAlert(errorMsg, context);
           return;
         }
         print("vv");
         final AttendanceOverviewModal modal =
         AttendanceOverviewModal.fromJson(responseData);

         attendanceOverviewList =
             modal.data ?? <AttendanceOverviewData>[];
       } else {
         print("ff");
         attendanceOverviewList.clear();

         showAlertError(
           "Something went wrong",
           context,
         );
       }
     } catch (e) {
       print("Attendance Overview API Error: $e");
       print("ss");
       attendanceOverviewList.clear();

       showAlertError(
         e.toString(),
         context,
       );
     } finally {
       isAttendanceOverviewLoading = false;
       notifyListeners();
     }
   }

   int _getMonthNumber(String month) {
     const months = {
       "January": 1,
       "February": 2,
       "March": 3,
       "April": 4,
       "May": 5,
       "June": 6,
       "July": 7,
       "August": 8,
       "September": 9,
       "October": 10,
       "November": 11,
       "December": 12,
     };

     return months[month] ?? 0;
   }

   Future<void> selectAttendanceMonth(
       BuildContext context,
       String month,
       ) async {
     selectedAttendanceMonth = month;

     notifyListeners();

     await getAttendanceOverview(context);
   }

   void clearData() {
     regNoController.clear();
   }
}
