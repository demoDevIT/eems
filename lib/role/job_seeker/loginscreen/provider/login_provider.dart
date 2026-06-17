import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rajemployment/constants/static_variables.dart';
import 'package:rajemployment/role/counselor/counsellor_otr/counsellor_otr_screen.dart';
import 'package:rajemployment/role/department/dept_dashboard/provider/dept_dashboard_provider.dart';
import 'package:rajemployment/role/employer/employerdashboard/employer_dashboard.dart';
import '../../../../api_service/model/base/api_response.dart';
import '../../../../constants/colors.dart';
import '../../../../constants/constants.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../services/HttpService.dart';
import '../../../../utils/app_shared_prefrence.dart';
import '../../../../utils/global.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/right_to_left_route.dart';
import '../../../../utils/user_new.dart';
import '../../../../utils/utility_class.dart';
import '../../../counselor/counselor_dashboard/counselor_dashboard.dart';
import '../../../department/dept_dashboard/dept_dashboard.dart';
import '../../../department/dept_dashboard/modal/dept_info_modal.dart';
import '../../../department/register_form/provider/register_form_provider.dart';
import '../../../department/register_form/register_form.dart';
import '../../../employer/emp_profile/modal/emp_info_modal.dart';
import '../../candidate_attendance/candidate_attendance_screen.dart';
import '../../candidate_attendance/dashboard_screen.dart';
import '../../candidate_attendance/modal/job_fair_modal.dart';
import '../../candidate_attendance/provider/candidate_attendance_provider.dart';
import '../../candidate_attendance/provider/dashboard_provider.dart';
import '../../jobseekerdashboard/job_seeker_dashboard.dart';
import '../../roleselectionscreen/roleselection_screen.dart';
import '../modal/jobseeker_basicInfo_modal.dart';
import '../modal/login_modal.dart';
import '../modal/temp_login_modal.dart';
import 'package:provider/provider.dart';

class LoginProvider with ChangeNotifier {
  bool isChecked = false; // Default value for checkbox
  final CommonRepo commonRepo;

  LoginProvider({required this.commonRepo});


  bool _passwordInVisible = true;

  bool get passwordInVisible => _passwordInVisible;
  void updatePasswordVisibility() {
    _passwordInVisible = !_passwordInVisible;
    notifyListeners();
  }

  TextEditingController _SSOIDController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  String? otpResponseId;
  String? otpResponseCode;
  String? otpRequestJson;
  String? otpResponseJson;

  //comment this part when test with other credentials
  login_provider() {
    // 👇 Set default test values

    // _SSOIDController.text = "geeta.saini87";
    // _passwordController.text = "geeta@1987";

    _SSOIDController.text = "DEEPAKJANGID505364"; //"deepakjangid";
    _passwordController.text = "Iamdk@5364"; //"KD@1230";
  }
  //comment this part when test with other credentials

  TextEditingController get SSOIDController => _SSOIDController;
  TextEditingController get passwordController => _passwordController;

  String? validateempIDTextField(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter SSO ID";
    }
    return null;
  }

  String? validatepasswordTextField(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter Password";
    }
    return null;
  }

  Future<TempLoginModal?> ssoLoginWithIDPassApi(BuildContext context) async {
    // temporary, because APIs are not working
    // Navigator.of(context).push(
    //   RightToLeftRoute(
    //     page:  CounselorOtrScreen(
    //       // ssoId: SSOIDController.text,
    //       // userID:userId,
    //         ssoId: SSOIDController.text, // ✅ pass SSO
    //         userID:"",
    //         displayName: "",
    //         mobileNo: ""
    //     ),
    //     duration: const Duration(milliseconds: 500),
    //     startOffset: const Offset(-1.0, 0.0),
    //   ),
    // );

    // Navigator.of(context).push(
    //   RightToLeftRoute(
    //     page: ChangeNotifierProvider(
    //       create: (_) =>
    //           RegisterFormProvider(
    //             commonRepo: commonRepo,
    //           ),
    //       child: RegisterFormScreen(
    //           ssoId: "aaa" ,
    //               displayName: "",
    //           mobileNo: "",
    //           designation: "",
    //           deptName: ""
    //       ),
    //     ),
    //     duration: const Duration(milliseconds: 500),
    //     startOffset: const Offset(-1.0, 0.0),
    //   ),
    // );
    // return null;
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //EncryptionHelper helper = EncryptionHelper();
        //String encryptedSSOid = helper.encryptData(SSOIDController.text);
        //String encryptedPassword = helper.encryptData(passwordController.text);
        // String randomNumber = helper.encryptData(generateRandomNumber());
        //String newPassword = encryptedPassword + randomNumber + generateRandomNumber();
        //  String finalEncryptedPassword = helper.encryptData(newPassword);
        // String pass = "$finalEncryptedPassword#@\$$randomNumber";

        String ssoId = SSOIDController.text;
        String pass = passwordController.text;
        String? deviceId = await UtilityClass.getDeviceId();

        Map<String, dynamic> body;

        if(ssoId == "EEMSJobFairEvent"){
          body = {
            "SSOID": ssoId,
            "Password": pass,
            "DeviceID": deviceId,
           "BypassSSO": true // for everytime while live or sandbox for this sso 'EEMSJobFairEvent'
          };
        }else{
          body = {
            "SSOID": ssoId,
            "Password": pass,
            "DeviceID": deviceId,
            "BypassSSO": true //true for sandbox, remove for live
          };
        }

        // if (ssoId == "employer1") {
        //   getEmpBasicDetailsApi(context, "2261606", 7);
        // }else{

        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post(
            "Login/MobileLogin", body);

        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          String? authToken = apiResponse.response?.headers?['X-AuthToken']?.first;
          print("authtoken -> $authToken");

         // StaticVariables.authToken = authToken.toString();
          if (authToken != null) {
            commonRepo.dioClient.updateHeader(authToken);
          }


          final sm = TempLoginModal.fromJson(responseData);
          if (sm.state == 200) {
            print("aaaaaaaaaaaaaaa");

            print("===== LOGIN RESPONSE VALUES =====");
            print("PostalAddress = ${sm.data?.postalAddress}");
            print("postalAddress1 = ${sm.data?.postalAddress1}");
            print("employeeNumber = ${sm.data?.employeeNumber}");
            print("empNumber = ${sm.data?.empNumber}");
            print("================================");

            print("LOGIN postalAddress => ${UserData().model.value.postalAddress}");
            if (sm.data!.userType.trim().toLowerCase() == 'govt') {
              if (sm.data != null && sm.data!.userID != null &&
                  sm.data!.userID! > 0 && sm.data!.roleID > 0) {

                if (sm.data!.roleID == 22) {

                  //callbasicdetail API for department getDeptBasicDetails
                  UserData().model.value.officeID = sm.data!.officeID;
                  UserData().model.value.districtCode = sm.data!.districtCode;
                  UserData().model.value.deptID = sm.data!.deptID;
                  UserData().model.value.internshipDeptTypeID =
                      sm.data!.internshipDeptTypeID;
                  UserData().model.value.NameAsjanAdhar =
                      sm.data!.NameAsjanAdhar;
                  UserData().model.value.DistrictEn = sm.data!.DistrictEn;
                  // UserData().model.value.postalAddress = sm.data!.postalAddress;
                  // UserData().model.value.empNumber = sm.data!.employeeNumber;
                  print("PA1 = ${sm.data!.postalAddress}");
                  print("PA2 = ${sm.data!.postalAddress1}");

                  print("EMP1 = ${sm.data!.employeeNumber}");
                  print("EMP2 = ${sm.data!.empNumber}");

                  final design11 = UserData().model.value.designation;
                  final design22 = sm.data!.designation;

                  print("design11->$design11");
                  print("design22->$design22");

                  UserData().model.value.designation = sm.data!.designation;

                  // UserData().model.value.mailPersonal = sm.data!.mailPersonal;
                  // UserData().model.value.mailOfficial = sm.data!.mailOfficial;
                  // UserData().model.value.postalAddress = sm.data!.postalAddress1;
                  // UserData().model.value.empNumber = sm.data!.employeeNumber;
                  // UserData().model.value.gENDER = sm.data!.gender;


                  // await saveRememberMeData();
                  // getDeptBasicDetails(
                  //     context, sm.data!.userID.toString(), sm.data!.roleID,
                  //     ssoId);

                  await saveRememberMeData();

                  bool otpSent = await loginHistoryMessagesApi(
                    context,
                    sm.data!.mobileno,
                    sm.data!.userID,
                    sm.data!.roleID,
                  );

                  if (!otpSent) {
                    showAlertError("Failed to send OTP", context);
                    return null;
                  }

                  showOtpDialog(
                    context,
                    sm.data!.mobileno,
                    onSubmit: (otp) async {
                      bool verified = await verifyOtpApi(
                        context,
                        sm.data!.mobileno,
                        otp,
                      );

                      if (!verified) {
                        showAlertError(
                          "Invalid OTP. Please try again.",
                          context,
                        );
                        return;
                      }

                      await getDeptBasicDetails(
                        context,
                        sm.data!.userID.toString(),
                        sm.data!.roleID,
                        ssoId,
                      );
                    },
                  );

                  return sm;


                } else { //earlier it was role 6 , currently 24, future any of role will be set
                  // print("Redirecting to CandidateAttendanceScreen"); job fair login

                  print("Redirecting to DashboardScreen");
                  await saveRememberMeData();

                  UserData().model.value.userId = sm.data!.userID;
                  UserData().model.value.sso = sm.data!.sSOID;
                  UserData().model.value.roleId = sm.data!.roleID;
                  UserData().model.value.name = sm.data!.displayName;
                  UserData().model.value.searchRecID = sm.data!.searchRecordID;
                  UserData().model.value.deptID = sm.data!.deptID;
                  UserData().model.value.officeID = sm.data!.officeID;

                  // Navigator.of(context).push(
                  //   RightToLeftRoute(
                  //     page: ChangeNotifierProvider(
                  //       create: (_) =>
                  //           DashboardProvider(
                  //             commonRepo: commonRepo, // ✅ FIX
                  //           ),
                  //       child: const DashboardScreen(),
                  //     ),
                  //     duration: const Duration(milliseconds: 500),
                  //     startOffset: const Offset(-1.0, 0.0),
                  //   ),
                  // );

                  bool otpSent = await loginHistoryMessagesApi(
                    context,
                    sm.data!.mobileno,
                    sm.data!.userID,
                    sm.data!.roleID,
                  );

                  if (!otpSent) {
                    showAlertError("Failed to send OTP", context);
                    return null;
                  }

                  showOtpDialog(
                    context,
                      sm.data!.mobileno,
                    onSubmit: (otp) async {

                      bool verified = await verifyOtpApi(
                        context,
                        sm.data!.mobileno,
                        otp,
                      );

                      if (!verified) {
                        showAlertError(
                          "Invalid OTP. Please try again.",
                          context,
                        );
                        return;
                      }

                      await getJobFairUserDetails(
                        context,
                        switchRoleID: sm.data!.roleID,
                        switchOfficeID: sm.data!.officeID,
                      );
                    },
                  );

                  // loginHistoryMessagesApi(context, sm.data!.mobileno, sm.data!.userID, sm.data!.roleID);
                  // getJobFairUserDetails(
                  //     context, switchRoleID: sm.data!.roleID, switchOfficeID: sm.data!.officeID);

                }
              } else {
                Navigator.of(context).push(
                  RightToLeftRoute(
                    page: ChangeNotifierProvider(
                      create: (_) =>
                          RegisterFormProvider(
                            commonRepo: commonRepo,
                          ),
                      child: RegisterFormScreen(
                        ssoId: sm.data!.sSOID ??
                            SSOIDController.text, // ✅ pass SSO
                          displayName: sm.data!.displayName ?? "",
                          mobileNo: sm.data!.mobileno ?? "",
                          designation: sm.data!.designation ?? "",
                          deptName: sm.data!.departmentName ?? ""
                      ),
                    ),
                    duration: const Duration(milliseconds: 500),
                    startOffset: const Offset(-1.0, 0.0),
                  ),
                );
              }
              return sm;
            }

            else {
              if (sm.data!.userType.trim().toLowerCase() == 'citizen') {
                if (sm.data != null && sm.data!.userID != null &&
                    sm.data!.userID! > 0 && sm.data!.roleID > 0) {
                  // getEmpBasicDetailsApi(context,"2261606",7);
                  // return null;
                  if (sm.data!.roleID == 4) { //jobseeker
                    await saveRememberMeData();
                    getBasicDetailsApi(
                        context, sm.data!.userID.toString(), sm.data!.roleID);
                  } else if (sm.data!.roleID == 7) { //employer
                    print("getEmpBasicDetailsApi userID => ${sm.data!.userID}");
                    print("getEmpBasicDetailsApi roleID => ${sm.data!.roleID}");
                    await saveRememberMeData();
                    getEmpBasicDetailsApi(
                        context, sm.data!.userID.toString(), sm.data!.roleID);
                  } else if (sm.data!.roleID == 8) { //counselor
                    print("getCounselorBasicDetailsApi userID => ${sm.data!.userID}");
                    print("getCounselorBasicDetailsApi roleID => ${sm.data!.roleID}");
                    await saveRememberMeData();
                    getCounselorBasicDetailsApi(
                        context, sm);
                  } else {
                    Navigator.of(context).push(
                      RightToLeftRoute(
                        page: RoleSelectionScreen(
                            // ssoId: SSOIDController.text,
                            // userID: "",
                            ssoId: sm.data!.sSOID ??
                                SSOIDController.text,
                            userID: "",// ✅ pass SSO
                            displayName: sm.data!.displayName ?? "",
                            mobileNo: sm.data!.mobileno ?? ""

                        ),
                        duration: const Duration(milliseconds: 500),
                        startOffset: const Offset(-1.0, 0.0),
                      ),
                    );
                  }
                }
                else {
                  Navigator.of(context).push(
                    RightToLeftRoute(
                      page: RoleSelectionScreen(
                         // ssoId: SSOIDController.text, userID: ""
                          ssoId: sm.data!.sSOID ??
                              SSOIDController.text,// ✅ pass SSO
                          userID: "",
                          displayName: sm.data!.displayName ?? "",
                          mobileNo: sm.data!.mobileno ?? ""
                      ),
                      duration: const Duration(milliseconds: 500),
                      startOffset: const Offset(-1.0, 0.0),
                    ),
                  );
                }
                return sm;
              }
            }
          } else {
            print("bbbbbbbbbbbbbbb");
            final smmm = TempLoginModal(
                state: 0, message: sm.message.toString());
            Navigator.of(context).push(
              RightToLeftRoute(
                page: RoleSelectionScreen(
                   // ssoId: SSOIDController.text, userID: ""
                    ssoId: sm.data!.sSOID ??
                        SSOIDController.text, // ✅ pass SSO
                    userID: "",
                    displayName: sm.data!.displayName ?? "",
                    mobileNo: sm.data!.mobileno ?? ""
                ),
                duration: const Duration(milliseconds: 500),
                startOffset: const Offset(-1.0, 0.0),
              ),
            );
            // showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return TempLoginModal(state: 0, message: 'Something went wrong',
          );
        }
     // }
      } on Exception catch (err) {
        print(err.toString());
        ProgressDialog.closeLoadingDialog(context);
        final sm = TempLoginModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<bool> loginHistoryMessagesApi(BuildContext context, mobileNo, userID, roleID) async {
    try {
      String? deviceId = await UtilityClass.getDeviceId();
      Map<String, dynamic> body = {
        "SMSCategoryType": "LoginOTPHistory",
        "TemplateID": "",
        "MobileNo": mobileNo,
        "Request_Status": "",
        "RequestJson": "",
        "ResponseJson": "",
        "TransactionId": "",
        "OTP": "",
        "UserID": userID ?? "0",
        "RoleID": roleID ?? "0",
        "CreatedBy_IP": "",
        "CreatedBy_IPv6": "",
        "Action": "Insert",
        "uniqueId": "EMPLOYMENT_SMS",
        "isManualDeveloperLogin": 0,
        "DeviceId": deviceId
      };

      print("========== LOGIN HISTORY API ==========");
      print(const JsonEncoder.withIndent('  ').convert(body));

      final apiResponse = await commonRepo.post(
        "Common/LoginHistoryMessages",
        body,
      );

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response?.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        final responseDataMap = responseData["Data"];

        otpResponseId = responseDataMap["ResponseId"];
        otpResponseCode = responseDataMap["ResponseCode"];
        otpRequestJson = responseDataMap["RequestJson"];
        otpResponseJson = responseDataMap["ResponseJson"];

        print("========== LOGIN HISTORY RESPONSE login page ==========");
        print(const JsonEncoder.withIndent('  ').convert(responseData));

        if (responseData["State"] == 200) {
          return true;

        }
      }

      return false;
    } catch (e) {
      print("LoginHistoryMessages Error : $e");
      return false;
    }
  }

  Future<void> showOtpDialog(
      BuildContext context, mobileno, {
        required Function(String otp) onSubmit,
      }) async {
    final TextEditingController otpController = TextEditingController();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            "OTP Verification",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "OTP has been sent to $mobileno",
              ),
              const SizedBox(height: 8),
              const Text(
                "Please enter OTP",
              ),
              const SizedBox(height: 12),
              TextField(
                controller: otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  hintText: "Enter OTP",
                  border: OutlineInputBorder(),
                  counterText: "",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () {
                if (otpController.text.trim().isEmpty) {
                  showAlertError(
                    "Please enter OTP",
                    context,
                  );
                  return;
                }

                Navigator.pop(context);

                onSubmit(
                  otpController.text.trim(),
                );
              },
              child: const Text("Submit"),
            ),
          ],
        );
      },
    );
  }

  Future<bool> verifyOtpApi(
      BuildContext context,
  mobileno,
      String otp,
      ) async {
    try {
      String? deviceId = await UtilityClass.getDeviceId();
      Map<String, dynamic> body = {
        "SMSCategoryType": "LoginOTPHistory",
        "TemplateID": "1407170730552013237",

        "MobileNo": mobileno,

        "Request_Status": "SUCCESS",

        "RequestJson": otpRequestJson ?? "",
        "ResponseJson": otpResponseJson ?? "",

        "OTP": otp,

        "TransactionId": otpResponseId ?? "",

        "MessageBody": "",
        "Key": "",
        "OrginPath": "",
        "smsResponse": "",
        "uniqueId": "",

        "UserID": UserData().model.value.userId ?? "",
        "RoleID": UserData().model.value.roleId ?? "",

        "IsLocal": true,
        "isManualDeveloperLogin": 1,
        "DeviceId": deviceId
      };

      print("========== VERIFY OTP REQUEST ==========");
      print(const JsonEncoder.withIndent('  ').convert(body));

      final apiResponse = await commonRepo.post(
        "Common/LoginVerifyOTP",
        body,
      );

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response?.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        print("========== VERIFY OTP RESPONSE ==========");
        print(const JsonEncoder.withIndent('  ').convert(responseData));

        if (responseData["State"] == 200 &&
            responseData["Data"] != null &&
            responseData["Data"] is List &&
            responseData["Data"].isNotEmpty &&
            responseData["Data"][0]["res"] == 1) {
          return true;
        }
      }

      return false;
    } catch (e) {
      print("Verify OTP Error : $e");
      return false;
    }
  }

//   Future<TempLoginModal?> ssoLoginWithIDPassApi(BuildContext context) async {
//
// //     Navigator.of(context).push(
// //       RightToLeftRoute(
// //         page: ChangeNotifierProvider(
// //           create: (_) => DepartmentDashboardProvider(),
// //           child: const DepartmentDashboardPage(), // ✅ UI widget
// //         ),
// //         duration: const Duration(milliseconds: 500),
// //         startOffset: const Offset(-1.0, 0.0),
// //       ),
// //     );
// // return null;
//
//     var isInternet = await UtilityClass.checkInternetConnectivity();
//     if (isInternet) {
//
//       try {
//         //EncryptionHelper helper = EncryptionHelper();
//         //String encryptedSSOid = helper.encryptData(SSOIDController.text);
//         //String encryptedPassword = helper.encryptData(passwordController.text);
//         // String randomNumber = helper.encryptData(generateRandomNumber());
//         //String newPassword = encryptedPassword + randomNumber + generateRandomNumber();
//         //  String finalEncryptedPassword = helper.encryptData(newPassword);
//         // String pass = "$finalEncryptedPassword#@\$$randomNumber";
//
//
//         String ssoId = SSOIDController.text;
//         String pass = passwordController.text;
//         String url = "https://eems.devitsandbox.com/mobileapi/Authentication/Login/$ssoId/$pass";
//         //String url = "https://rajemployment.rajasthan.gov.in/mobileapi/Authentication/Login/$ssoId/$pass";
//         ProgressDialog.showLoadingDialog(context);
//         ApiResponse apiResponse = await commonRepo.get(url);
//         ProgressDialog.closeLoadingDialog(context);
//         if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
//           var responseData = apiResponse.response?.data;
//           if (responseData is String) {
//             responseData = jsonDecode(responseData);
//           }
//           /*String? authToken = apiResponse.response?.headers?['x-authtoken']?.first;
//           print(authToken);*/
//           final sm = TempLoginModal.fromJson(responseData);
//           if (sm.state == 200) {
// //print("---->"+sm.message.toString());
//             if (sm.data != null && sm.data!.userID != null && sm.data!.userID! > 0 ) {
//               print("11");
//               // if (sm.data!.sSOID.toLowerCase() == 'eemsdevitjaipur') { &&  sm.data!.roleID == 6
//               if (sm.data!.roleID == 6) {
//                 print("Redirecting to CandidateAttendanceScreen");
//
//
//                 Navigator.of(context).push(
//                   RightToLeftRoute(
//                     page: ChangeNotifierProvider(
//                       create: (_) => CandidateAttendanceProvider(
//                         commonRepo: commonRepo, // ✅ FIX
//                       ),
//                       child: const CandidateAttendanceScreen(),
//                     ),
//                     duration: const Duration(milliseconds: 500),
//                     startOffset: const Offset(-1.0, 0.0),
//                   ),
//                 );
//
//               } else if (sm.data!.roleID == 4){
//                  // print("22");
//                   getBasicDetailsApi(context,sm.data!.userID.toString(),sm.data!.roleID);
//
//               } else if (sm.data!.roleID == 7){
//
//                 getEmpBasicDetailsApi(context,sm.data!.userID.toString(),sm.data!.roleID);
//
//                 // Navigator.of(context).push(
//                 //   RightToLeftRoute(
//                 //     page:  EmployerDashboard(),
//                 //     duration: const Duration(milliseconds: 500),
//                 //     startOffset: const Offset(-1.0, 0.0),
//                 //   ),
//                 // );
//               }
//             }
//             else{
//               print("33");
//               Navigator.of(context).push(
//                 RightToLeftRoute(
//                   page:  RoleSelectionScreen(ssoId: SSOIDController.text,userID:""),
//                   duration: const Duration(milliseconds: 500),
//                   startOffset: const Offset(-1.0, 0.0),
//                 ),
//               );
//             }
//             return sm;
//           } else {
//             final smmm = TempLoginModal(state: 0, message: sm.message.toString());
//             Navigator.of(context).push(
//               RightToLeftRoute(
//                 page:  RoleSelectionScreen(ssoId: SSOIDController.text,userID:""),
//                 duration: const Duration(milliseconds: 500),
//                 startOffset: const Offset(-1.0, 0.0),
//               ),
//             );
//             // showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
//             return smmm;
//           }
//         } else {
//           return TempLoginModal(state: 0, message: 'Something went wrong',
//           );
//         }
//       } on Exception catch (err) {
//         print(err.toString());
//         ProgressDialog.closeLoadingDialog(context);
//         final sm = TempLoginModal(state: 0, message: err.toString());
//         showAlertError(sm.message.toString(), context);
//         return sm;
//       }
//     } else {
//       showAlertError(AppLocalizations.of(context)!.internet_connection, context);
//     }
//   }

  Future<DeptInfoModal?> getDeptBasicDetails(
      BuildContext context, String userId, int? roleId, String ssoID) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {
          "UserID": userId,
          "SSOID": ssoID,
          "RoleID": roleId, //22, //roleId
          // "districtCode": "",
          // "officeID": ""
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
            if(isChecked){
              print("111111222222");
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


              // UserData().model.value.postalAddress = sm.data![0].postalAddress;

             // UserData().model.value.postalAddress = sm.data![0].postalAddress;
              // final des11 = UserData().model.value.designation;
              // final des22 = sm.data![0].designation;
              // print("des11->$des11");
              // print("des22->$des22");
              //
              // UserData().model.value.designation = sm.data![0].designation;
              UserData().model.value.territoryType = sm.data![0].territoryType;
              UserData().model.value.village = sm.data![0].village;
              UserData().model.value.gp = sm.data![0].gp;
              UserData().model.value.block = sm.data![0].block;
              UserData().model.value.city = sm.data![0].city;
              UserData().model.value.sso = ssoID;
              UserData().model.value.roleName = sm.data![0].role;
              UserData().model.value.exchangeName = sm.data![0].office;
             // UserData().model.value.name = sm.data![0].name;


              // UserData().model.value.mailPersonal = sm.data![0].mailPersonal;
              // UserData().model.value.mailOfficial = sm.data![0].mailOfficial;
              // UserData().model.value.postalAddress = sm.data![0].postalAddress;
              // UserData().model.value.empNumber = sm.data![0].empNumber;
              UserData().model.value.isLogin = true;
              pref.save('UserData', UserData().model.value);
            }else{
              print("3333334444444");
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

              // final des33 = UserData().model.value.designation;
              // final des44 = sm.data![0].designation;
              // print("des33->$des33");
              // print("des44->$des44");
              //
              // UserData().model.value.designation = sm.data![0].designation;
              UserData().model.value.territoryType = sm.data![0].territoryType;
              UserData().model.value.village = sm.data![0].village;
              UserData().model.value.gp = sm.data![0].gp;
              UserData().model.value.block = sm.data![0].block;
              UserData().model.value.city = sm.data![0].city;
              UserData().model.value.sso = ssoID;
              UserData().model.value.roleName = sm.data![0].role;
              UserData().model.value.exchangeName = sm.data![0].office;
              //UserData().model.value.name = sm.data![0].name;

              // UserData().model.value.mailPersonal = sm.data![0].mailPersonal;
              // UserData().model.value.mailOfficial = sm.data![0].mailOfficial;
              // UserData().model.value.postalAddress = sm.data![0].postalAddress;
              // UserData().model.value.empNumber = sm.data![0].empNumber;
              UserData().model.value.isLogin = true;
              pref.save('UserData', UserData().model.value);
            }

            print("========== DEPTTTTT USER DATA ==========");
            print(const JsonEncoder.withIndent('  ')
                .convert(UserData().model.value.toJson()));
            print("================================");

            Navigator.of(context).push(
              RightToLeftRoute(
                page: const DepartmentDashboardPage(),
                duration: const Duration(milliseconds: 500),
                startOffset: const Offset(-1.0, 0.0),
              ),
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

  Future<JobFairModal?> getJobFairUserDetails(
      BuildContext context, {
        required int switchRoleID,
        required int switchOfficeID,
      }) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    print("0000");
    if (isInternet) {
      try {
        Map<String, dynamic> body = {
          "SearchRecordID": UserData().model.value.searchRecID,
          "SwitchRoleID": switchRoleID,
          "SwitchOfficeID": switchOfficeID
        };
        print("login API Request Body: $body");
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post(
          "Authentication/GetSSOUserDetailsNew",
          body,
        );
        ProgressDialog.closeLoadingDialog(context);
        print("vvvv");
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

          }

          int userID = responseData['Data']['UserID'];
          int roleID = responseData['Data']['RoleID'];
          String SSOID = responseData['Data']['SSOID'];

          print("userID: $userID");
          print("roleID: $roleID");
          print("SSOID: $SSOID");

          if(roleID == 22){
            print("role ID 22");
            //redirect to dept dashboard
            //callbasicdetail API for department getDeptBasicDetails
            UserData().model.value.officeID = responseData['Data']['OfficeID'];
            UserData().model.value.districtCode = responseData['Data']['DistrictCode'];
            UserData().model.value.deptID = responseData['Data']['DepartmentID'];
            UserData().model.value.internshipDeptTypeID =
            responseData['Data']['InternshipDeptTypeID'];
            UserData().model.value.NameAsjanAdhar =
            responseData['Data']['NameAsjanAdhar'];
            UserData().model.value.DistrictEn = responseData['Data']['DistrictEn'];
            UserData().model.value.designation = responseData['Data']['Designation'];
            UserData().model.value.roleName = responseData['Data']['RoleName'];
            UserData().model.value.exchangeName = responseData['Data']['ExchangeName'];
            UserData().model.value.displayName = responseData['Data']['DisplayName'];
            UserData().model.value.name = responseData['Data']['DisplayName'];

            getDeptBasicDetails(
                context, userID.toString(), roleID, SSOID.toString());
          }else{
            print("role ID other=> $roleID");
            //redirect to job fair (dashboard page)

            UserData().model.value.officeID = responseData['Data']['OfficeID'];
            UserData().model.value.districtCode = responseData['Data']['DistrictCode'];
            UserData().model.value.deptID = responseData['Data']['DepartmentID'];
            UserData().model.value.internshipDeptTypeID =
            responseData['Data']['InternshipDeptTypeID'];
            UserData().model.value.NameAsjanAdhar =
            responseData['Data']['NameAsjanAdhar'];
            UserData().model.value.DistrictEn = responseData['Data']['DistrictEn'];
            UserData().model.value.designation = responseData['Data']['Designation'];
            UserData().model.value.userId = userID;
            UserData().model.value.sso = SSOID;
            UserData().model.value.roleId = roleID;
            UserData().model.value.name = responseData['Data']['Name'];
            UserData().model.value.roleName = responseData['Data']['RoleName'];
            UserData().model.value.exchangeName = responseData['Data']['ExchangeName'];
            UserData().model.value.displayName = responseData['Data']['DisplayName'];
            UserData().model.value.name = responseData['Data']['DisplayName'];
            // UserData().model.value.searchRecID = sm.data!.searchRecordID;
            // UserData().model.value.deptID = sm.data!.deptID;

            print("userDATA-------->");
            Navigator.of(context).pushAndRemoveUntil(
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
              ),
                  (route) => false,
            );
          }



        } else {
          showAlertError("Something went wrong", context);
        }
      } catch (e, stackTrace) {
        ProgressDialog.closeLoadingDialog(context);
        print("Exception: $e");
        print(stackTrace);
        showAlertError(e.toString(), context);
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

    // Future<void> callSSOAuthApi(BuildContext buildContext) async {
    //   Map<String, dynamic> body = {
    //     "usrnm": "rgavp",
    //     "psw": "rgavp@123", // Placeholder encrypted password
    //     "srvnm": "RGAVPLogin",
    //     "srvmethodnm": "SSOAuthentication",
    //     "srvparam": json.encode({
    //       "sso_id": SSOIDController.text,
    //       "password": passwordController.text
    //     }),
    //   };
    //
    //   print("body => $body");
    //
    //   try {
    //     ApiResponse apiResponse = await commonRepo.post("https://rajeevika.devitsandbox.com/Service/AppService",body);
    //
    //     ProgressDialog.closeLoadingDialog(buildContext);
    //     if (apiResponse.response != null &&
    //         apiResponse.response?.statusCode == 200) {
    //
    //       var responseData = apiResponse.response!.data;
    //
    //       // ✅ Decode ONLY if it's String
    //       if (responseData is String) {
    //         responseData = jsonDecode(responseData);
    //       }
    //       print("Full response => $responseData");
    //       final List<dynamic> jsonArray = responseData;
    //       final Map<String, dynamic> result = jsonArray[0];
    //
    //       print("Status => ${result['Status']}");
    //       print("IsSuccess => ${result['IsSuccess']}");
    //       print("Message => ${result['Message']}");
    //
    //     } else {
    //       print("elseeee");
    //     }
    //
    //   } catch (e) {
    //     print("Login error: $e");
    //     UtilityClass.showSnackBar(
    //         buildContext, "Login failed. Please try again.", Colors.red);
    //   }
    // }

  Future<JobseekerBasicInfoModal?> getBasicDetailsApi(BuildContext context,String userId,int? roleId) async {
    print("44");
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {
          "Action": "GetJobseekerBasicInfo",
          "UserID":userId
        };
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post("Login/GetBasicDetails",body);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          String? authToken = apiResponse.response?.headers?['x-authtoken']?.first;
          print("authtoken => $authToken");
          final sm = JobseekerBasicInfoModal.fromJson(responseData);
          if (sm.state == 200) {
            if(isChecked){
              print("55");
              final pref = AppSharedPref();
              UserData().model.value.userId = sm.data![0].userID;
              UserData().model.value.jobSeekerID = sm.data![0].jobSeekerID;
              UserData().model.value.registrationNumber = sm.data![0].registrationNumber;
              UserData().model.value.registrationDate = sm.data![0].registrationDate;
              UserData().model.value.nAMEENG = sm.data![0].nAMEENG;
              UserData().model.value.nAMEHINDI = sm.data![0].nAMEHINDI;
              UserData().model.value.fATHERNAMEENG = sm.data![0].fATHERNAMEENG;
              UserData().model.value.fATHERNAMEHND = sm.data![0].fATHERNAMEHND;
              UserData().model.value.dOB = sm.data![0].dOB;
              UserData().model.value.gENDER = sm.data![0].gENDER;
              UserData().model.value.mOBILENO = sm.data![0].mOBILENO;
              UserData().model.value.eMAILID = sm.data![0].eMAILID;
              UserData().model.value.caste = sm.data![0].caste;
              UserData().model.value.religion = sm.data![0].religion;
              UserData().model.value.latestPhoto = sm.data![0].latestPhoto;
              UserData().model.value.nCOCode = sm.data![0].nCOCode;
              UserData().model.value.aadharNo = sm.data![0].aadharNo;
              UserData().model.value.miniority = sm.data![0].miniority;
              UserData().model.value.uIDName = sm.data![0].uIDName;
              UserData().model.value.uIDType = sm.data![0].uIDType;
              UserData().model.value.uIDNumber = sm.data![0].uIDNumber;
              UserData().model.value.latestPhotoPath = sm.data![0].latestPhotoPath;
              UserData().model.value.isLogin = true;
              UserData().model.value.username = SSOIDController.text.toString();
              UserData().model.value.password = passwordController.text.toString();
              UserData().model.value.maritalStatus = sm.data![0].maritalStatus;
              UserData().model.value.familyIncome = sm.data![0].familyIncome;
              UserData().model.value.roleId = roleId;
              pref.save('UserData', UserData().model.value);
            }
            else{
              print("66");
              final pref = AppSharedPref();
              UserData().model.value.userId = sm.data![0].userID;
              UserData().model.value.jobSeekerID = sm.data![0].jobSeekerID;
              UserData().model.value.registrationNumber = sm.data![0].registrationNumber;
              UserData().model.value.registrationDate = sm.data![0].registrationDate;
              UserData().model.value.nAMEENG = sm.data![0].nAMEENG;
              UserData().model.value.nAMEHINDI = sm.data![0].nAMEHINDI;
              UserData().model.value.fATHERNAMEENG = sm.data![0].fATHERNAMEENG;
              UserData().model.value.fATHERNAMEHND = sm.data![0].fATHERNAMEHND;
              UserData().model.value.dOB = sm.data![0].dOB;
              UserData().model.value.gENDER = sm.data![0].gENDER;
              UserData().model.value.mOBILENO = sm.data![0].mOBILENO;
              UserData().model.value.eMAILID = sm.data![0].eMAILID;
              UserData().model.value.caste = sm.data![0].caste;
              UserData().model.value.religion = sm.data![0].religion;
              UserData().model.value.latestPhoto = sm.data![0].latestPhoto;
              UserData().model.value.nCOCode = sm.data![0].nCOCode;
              UserData().model.value.aadharNo = sm.data![0].aadharNo;
              UserData().model.value.miniority = sm.data![0].miniority;
              UserData().model.value.uIDName = sm.data![0].uIDName;
              UserData().model.value.uIDType = sm.data![0].uIDType;
              UserData().model.value.uIDNumber = sm.data![0].uIDNumber;
              UserData().model.value.latestPhotoPath = sm.data![0].latestPhotoPath;
              UserData().model.value.isLogin = true;
              UserData().model.value.username = "";
              UserData().model.value.password = "";
              UserData().model.value.roleId = roleId;
              UserData().model.value.maritalStatus = sm.data![0].maritalStatus;
              UserData().model.value.familyIncome = sm.data![0].familyIncome;
              pref.save('UserData', UserData().model.value);
              print("--Hello---2");
            }
            print("77");
            Navigator.of(context).push(
              RightToLeftRoute(
                page: const JobSeekerDashboard(),
                duration: const Duration(milliseconds: 500),
                startOffset: const Offset(-1.0, 0.0),
              ),
            );
            return sm;
          } else {
            print("88");
            final smmm = JobseekerBasicInfoModal(state: 0, message: sm.message.toString());
            Navigator.of(context).push(
              RightToLeftRoute(
                page:  RoleSelectionScreen(
                    //ssoId: SSOIDController.text,userID:userId
                    ssoId: SSOIDController.text, // ✅ pass SSO
                    userID:userId,
                    displayName: "",
                    mobileNo: ""
                ),
                duration: const Duration(milliseconds: 500),
                startOffset: const Offset(-1.0, 0.0),
              ),
            );
            // showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          print("99");
          return JobseekerBasicInfoModal(state: 0, message: 'Something went wrong',);
        }
      } on Exception catch (err) {
        print("1010");
        ProgressDialog.closeLoadingDialog(context);
        final sm = JobseekerBasicInfoModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      print("1111");
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  Future<EmpInfoModal?> getEmpBasicDetailsApi(BuildContext context,String userId,int? roleId) async {
    print("44");
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {
          "ActionName": "BasicDetails",
          "UserID":userId
        };
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post("Employer/GetEmployerDetail",body);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          String? authToken = apiResponse.response?.headers?['x-authtoken']?.first;
          print("authToken => $authToken");
          final sm = EmpInfoModal.fromJson(responseData);
          if (sm.state == 200) {
            if(isChecked){
              print("55");
              final pref = AppSharedPref();

              //Job seekar Userdata
              UserData().model.value.userId = sm.data![0].userID;

              UserData().model.value.isLogin = true;
              UserData().model.value.username = SSOIDController.text.toString();
              UserData().model.value.password = passwordController.text.toString();

              UserData().model.value.roleId = roleId;

              //Employer Userdata
              UserData().model.value.brn = sm.data![0].brn;
              UserData().model.value.district = sm.data![0].district;
              UserData().model.value.area = sm.data![0].area;
              UserData().model.value.tehsil = sm.data![0].tehsil;
              UserData().model.value.localBody = sm.data![0].localBody;
              UserData().model.value.ward = sm.data![0].ward;
              UserData().model.value.branchName = sm.data![0].branchName;
              UserData().model.value.branchHouseNumber = sm.data![0].branchHouseNumber;
              UserData().model.value.branchLane = sm.data![0].branchLane;
              UserData().model.value.branchLocality = sm.data![0].branchLocality;
              UserData().model.value.branchPincode = sm.data![0].branchPincode;
              UserData().model.value.boTelNo = sm.data![0].boTelNo;
              UserData().model.value.branchEmail = sm.data![0].branchEmail;
              UserData().model.value.docGSTNumber = sm.data![0].docGSTNumber;
              UserData().model.value.branchPANVerified = sm.data![0].branchPANVerified;
              UserData().model.value.branchPANHolder = sm.data![0].branchPANHolder;
              UserData().model.value.branchTANNumber = sm.data![0].branchTANNumber;
              UserData().model.value.headName = sm.data![0].headName;
              UserData().model.value.hoTelno = sm.data![0].hoTelno;
              UserData().model.value.hoCompanyEmail = sm.data![0].hoCompanyEmail;
              UserData().model.value.hoPanNumber = sm.data![0].hoPanNumber;
              UserData().model.value.headHouseNumber = sm.data![0].headHouseNumber;
              UserData().model.value.headLane = sm.data![0].headLane;
              UserData().model.value.headLocality = sm.data![0].headLocality;
              UserData().model.value.hoPinCode = sm.data![0].hoPinCode;
              UserData().model.value.applicantName = sm.data![0].applicantName;
              UserData().model.value.applicantNo = sm.data![0].applicantNo;
              UserData().model.value.applicantEmail = sm.data![0].applicantEmail;
              UserData().model.value.year = sm.data![0].year;
              UserData().model.value.ownership = sm.data![0].ownership;
              UserData().model.value.totalPerson = sm.data![0].totalPerson;
              UserData().model.value.actRegNo = sm.data![0].actRegNo;
              UserData().model.value.hoTanNo = sm.data![0].hoTanNo;
              UserData().model.value.hoApplicationEmail = sm.data![0].hoApplicationEmail;
              UserData().model.value.hoStateId = sm.data![0].hoStateId;
              UserData().model.value.hoDistrictId = sm.data![0].hoDistrictId;
              UserData().model.value.hoCityId = sm.data![0].hoCityId;
              UserData().model.value.webSite = sm.data![0].webSite;
              UserData().model.value.applicantAddress = sm.data![0].applicantAddress;
              UserData().model.value.nicCode = sm.data![0].nicCode;
              UserData().model.value.contactPANNo = sm.data![0].contactPANNo;
              UserData().model.value.contactFirstName = sm.data![0].contactFirstName;
              UserData().model.value.contactLastName = sm.data![0].contactLastName;
              UserData().model.value.contactMobileNumber = sm.data![0].contactMobileNumber;
              UserData().model.value.contactAlternateMobileNumber = sm.data![0].contactAlternateMobileNumber;
              UserData().model.value.contactEmail = sm.data![0].contactEmail;
              UserData().model.value.contactState = sm.data![0].contactState;
              UserData().model.value.contactDistrict = sm.data![0].contactDistrict;
              UserData().model.value.contactCity = sm.data![0].contactCity;
              UserData().model.value.contactPincode = sm.data![0].contactPincode;
              UserData().model.value.contactAddress = sm.data![0].contactAddress;
              UserData().model.value.contactDesignation = sm.data![0].contactDesignation;
              UserData().model.value.contactdepartment = sm.data![0].contactdepartment;
              UserData().model.value.exchangeName = sm.data![0].exchangeName;
              UserData().model.value.organizationType = sm.data![0].organizationType;
              UserData().model.value.governmentBody = sm.data![0].governmentBody;
              UserData().model.value.numberOfMaleEmployees = sm.data![0].numberOfMaleEmployees;
              UserData().model.value.numberOfFemaleEmployees = sm.data![0].numberOfFemaleEmployees;
              UserData().model.value.numberOfTransgenderEmployees = sm.data![0].numberOfTransgenderEmployees;
              UserData().model.value.totalNumberOfEmployees = sm.data![0].totalNumberOfEmployees;
              UserData().model.value.actEstablishment = sm.data![0].actEstablishment;
              UserData().model.value.emipSector = sm.data![0].emipSector;
              UserData().model.value.industryType = sm.data![0].industryType;
              pref.save('UserData', UserData().model.value);
            }
            else{
              print("66");
              final pref = AppSharedPref();
              UserData().model.value.userId = sm.data![0].userID;
              UserData().model.value.isLogin = true;
              UserData().model.value.username = "";
              UserData().model.value.password = "";
              UserData().model.value.roleId = roleId;

//            employer userdata
              UserData().model.value.brn = sm.data![0].brn;
              UserData().model.value.district = sm.data![0].district;
              UserData().model.value.area = sm.data![0].area;
              UserData().model.value.tehsil = sm.data![0].tehsil;
              UserData().model.value.localBody = sm.data![0].localBody;
              UserData().model.value.ward = sm.data![0].ward;
              UserData().model.value.branchName = sm.data![0].branchName;
              UserData().model.value.branchHouseNumber = sm.data![0].branchHouseNumber;
              UserData().model.value.branchLane = sm.data![0].branchLane;
              UserData().model.value.branchLocality = sm.data![0].branchLocality;
              UserData().model.value.branchPincode = sm.data![0].branchPincode;
              UserData().model.value.boTelNo = sm.data![0].boTelNo;
              UserData().model.value.branchEmail = sm.data![0].branchEmail;
              UserData().model.value.docGSTNumber = sm.data![0].docGSTNumber;
              UserData().model.value.branchPANVerified = sm.data![0].branchPANVerified;
              UserData().model.value.branchPANHolder = sm.data![0].branchPANHolder;
              UserData().model.value.branchTANNumber = sm.data![0].branchTANNumber;
              UserData().model.value.headName = sm.data![0].headName;
              UserData().model.value.hoTelno = sm.data![0].hoTelno;
              UserData().model.value.hoCompanyEmail = sm.data![0].hoCompanyEmail;
              UserData().model.value.hoPanNumber = sm.data![0].hoPanNumber;
              UserData().model.value.headHouseNumber = sm.data![0].headHouseNumber;
              UserData().model.value.headLane = sm.data![0].headLane;
              UserData().model.value.headLocality = sm.data![0].headLocality;
              UserData().model.value.hoPinCode = sm.data![0].hoPinCode;
              UserData().model.value.applicantName = sm.data![0].applicantName;
              UserData().model.value.applicantNo = sm.data![0].applicantNo;
              UserData().model.value.applicantEmail = sm.data![0].applicantEmail;
              UserData().model.value.year = sm.data![0].year;
              UserData().model.value.ownership = sm.data![0].ownership;
              UserData().model.value.totalPerson = sm.data![0].totalPerson;
              UserData().model.value.actRegNo = sm.data![0].actRegNo;
              UserData().model.value.hoTanNo = sm.data![0].hoTanNo;
              UserData().model.value.hoApplicationEmail = sm.data![0].hoApplicationEmail;
              UserData().model.value.hoStateId = sm.data![0].hoStateId;
              UserData().model.value.hoDistrictId = sm.data![0].hoDistrictId;
              UserData().model.value.hoCityId = sm.data![0].hoCityId;
              UserData().model.value.webSite = sm.data![0].webSite;
              UserData().model.value.applicantAddress = sm.data![0].applicantAddress;
              UserData().model.value.nicCode = sm.data![0].nicCode;
              UserData().model.value.contactPANNo = sm.data![0].contactPANNo;
              UserData().model.value.contactFirstName = sm.data![0].contactFirstName;
              UserData().model.value.contactLastName = sm.data![0].contactLastName;
              UserData().model.value.contactMobileNumber = sm.data![0].contactMobileNumber;
              UserData().model.value.contactAlternateMobileNumber = sm.data![0].contactAlternateMobileNumber;
              UserData().model.value.contactEmail = sm.data![0].contactEmail;
              UserData().model.value.contactState = sm.data![0].contactState;
              UserData().model.value.contactDistrict = sm.data![0].contactDistrict;
              UserData().model.value.contactCity = sm.data![0].contactCity;
              UserData().model.value.contactPincode = sm.data![0].contactPincode;
              UserData().model.value.contactAddress = sm.data![0].contactAddress;
              UserData().model.value.contactDesignation = sm.data![0].contactDesignation;
              UserData().model.value.contactdepartment = sm.data![0].contactdepartment;
              UserData().model.value.exchangeName = sm.data![0].exchangeName;
              UserData().model.value.organizationType = sm.data![0].organizationType;
              UserData().model.value.governmentBody = sm.data![0].governmentBody;
              UserData().model.value.numberOfMaleEmployees = sm.data![0].numberOfMaleEmployees;
              UserData().model.value.numberOfFemaleEmployees = sm.data![0].numberOfFemaleEmployees;
              UserData().model.value.numberOfTransgenderEmployees = sm.data![0].numberOfTransgenderEmployees;
              UserData().model.value.totalNumberOfEmployees = sm.data![0].totalNumberOfEmployees;
              UserData().model.value.actEstablishment = sm.data![0].actEstablishment;
              UserData().model.value.emipSector = sm.data![0].emipSector;
              UserData().model.value.industryType = sm.data![0].industryType;
              pref.save('UserData', UserData().model.value);
              print("--Hello---2");
            }
            print("77");
            Navigator.of(context).push(
              RightToLeftRoute(
                page: const EmployerDashboard(),
                duration: const Duration(milliseconds: 500),
                startOffset: const Offset(-1.0, 0.0),
              ),
            );
            return sm;
          } else {
            print("88");
            final smmm = EmpInfoModal(state: 0, message: sm.message.toString());
            Navigator.of(context).push(
              RightToLeftRoute(
                page:  RoleSelectionScreen(
                    // ssoId: SSOIDController.text,
                    // userID:userId,
                    ssoId: SSOIDController.text, // ✅ pass SSO
                    userID:userId,
                      displayName: "",
                    mobileNo: ""
                ),
                duration: const Duration(milliseconds: 500),
                startOffset: const Offset(-1.0, 0.0),
              ),
            );
            // showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          print("99");
          return EmpInfoModal(state: 0, message: 'Something went wrong',);
        }
      } on Exception catch (err) {
        print("1010");
        ProgressDialog.closeLoadingDialog(context);
        final sm = EmpInfoModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      print("1111");
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<void> getCounselorBasicDetailsApi(
      BuildContext context, TempLoginModal sm) async {

    print("Counselor Data सेट हो रहा है");

    final pref = AppSharedPref();

    if (sm.state == 200 && sm.data != null) {

      if (isChecked) {
        // Remember Me ON
       // UserData().model.value.officeID = sm.data!.officeID;
        UserData().model.value.userId = sm.data!.userID;
        UserData().model.value.isLogin = true;
        UserData().model.value.username = SSOIDController.text.toString();
        UserData().model.value.password = passwordController.text.toString();
      } else {
        // Remember Me OFF
        UserData().model.value.userId = sm.data!.userID;
        UserData().model.value.isLogin = true;
        UserData().model.value.username = "";
        UserData().model.value.password = "";
      }
      // Common fields
      UserData().model.value.roleId = sm.data!.roleID;
      // Counselor specific डेटा
      UserData().model.value.displayName = sm.data!.displayName;
      UserData().model.value.mobileNumber = sm.data!.mobileno;
      //UserData().model.value.email = sm.data!.mailPersonal;
      UserData().model.value.departmentName = sm.data!.departmentName;
      UserData().model.value.departmentId = sm.data!.departmentID;
      UserData().model.value.profileId = sm.data!.profileID;

      // Optional fields
      UserData().model.value.firstName = sm.data!.firstName;
      UserData().model.value.lastName = sm.data!.lastName;
      UserData().model.value.userType = sm.data!.userType;

      // Save in shared pref
      pref.save('UserData', UserData().model.value);

      print("Counselor UserData saved");

      // Navigate
      Navigator.of(context).push(
        RightToLeftRoute(
          page: const CounselorDashboard(), // 👈 create this स्क्रीन
          duration: const Duration(milliseconds: 500),
          startOffset: const Offset(-1.0, 0.0),
        ),
      );

    } else {
      showAlertError(
          sm.message ?? "Login failed for counselor", context);
    }
  }

  void rememberMe(bool? value) {
    isChecked = value ?? false;
    notifyListeners();
    // You can implement any action here based on checkbox change
  }

  Future<void> loadRememberedUser() async {
    final pref = AppSharedPref();

    final data = await pref.read('RememberUser');

    if (data != '' && data != null) {
      isChecked = true;
      _SSOIDController.text = data['username'] ?? '';
      _passwordController.text = data['password'] ?? '';
    } else {
      isChecked = false;
    }

    notifyListeners();
  }

  Future<void> saveRememberMeData() async {
    final pref = AppSharedPref();

    if (isChecked) {
      await pref.save('RememberUser', {
        "username": _SSOIDController.text.trim(),
        "password": _passwordController.text.trim(),
      });
    } else {
      await pref.remove('RememberUser');
    }
  }
}
