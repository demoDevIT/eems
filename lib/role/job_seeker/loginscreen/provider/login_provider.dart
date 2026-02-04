import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
import '../../../employer/emp_profile/modal/emp_info_modal.dart';
import '../../candidate_attendance/candidate_attendance_screen.dart';
import '../../candidate_attendance/provider/candidate_attendance_provider.dart';
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



/*
  Future<LoginModal?> ssoLoginWithIDPassApi(BuildContext context) async {
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
        Map<String, dynamic> body = {
          "ssoId": ssoId,
          "password": pass,
          "EnvironmentName": ""
        };
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post("Login/MobileLogin",body);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          String? authToken = apiResponse.response?.headers?['x-authtoken']?.first;
          print(authToken);
          final sm = LoginModal.fromJson(responseData);
          if (sm.state == 200) {
            if (sm.data != null && sm.data!.userId != null && sm.data!.userId! > 0 ) {
                getBasicDetailsApi(context,sm.data!.userId.toString(),sm.data!.roleId);
            }
            else{
              Navigator.of(context).push(
                RightToLeftRoute(
                  page:  RoleSelectionScreen(ssoId: SSOIDController.text,userID:""),
                  duration: const Duration(milliseconds: 500),
                  startOffset: const Offset(-1.0, 0.0),
                ),
              );
            }
            return sm;
          } else {
            final smmm = LoginModal(state: 0, message: sm.message.toString());
            Navigator.of(context).push(
              RightToLeftRoute(
                page:  RoleSelectionScreen(ssoId: SSOIDController.text,userID:""),
                duration: const Duration(milliseconds: 500),
                startOffset: const Offset(-1.0, 0.0),
              ),
            );
            // showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return LoginModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        print(err.toString());
        ProgressDialog.closeLoadingDialog(context);
        final sm = LoginModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }
*/


  Future<TempLoginModal?> ssoLoginWithIDPassApi(BuildContext context) async {
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
        String url = "https://eems.devitsandbox.com/mobileapi/Authentication/Login/$ssoId/$pass";
        //String url = "https://rajemployment.rajasthan.gov.in/mobileapi/Authentication/Login/$ssoId/$pass";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          /*String? authToken = apiResponse.response?.headers?['x-authtoken']?.first;
          print(authToken);*/
          final sm = TempLoginModal.fromJson(responseData);
          if (sm.state == 200) {
//print("---->"+sm.message.toString());
            if (sm.data != null && sm.data!.userID != null && sm.data!.userID! > 0 ) {
              print("11");
              // if (sm.data!.sSOID.toLowerCase() == 'eemsdevitjaipur') { &&  sm.data!.roleID == 6
              if (sm.data!.roleID == 6) {
                print("Redirecting to CandidateAttendanceScreen");


                Navigator.of(context).push(
                  RightToLeftRoute(
                    page: ChangeNotifierProvider(
                      create: (_) => CandidateAttendanceProvider(
                        commonRepo: commonRepo, // ✅ FIX
                      ),
                      child: const CandidateAttendanceScreen(),
                    ),
                    duration: const Duration(milliseconds: 500),
                    startOffset: const Offset(-1.0, 0.0),
                  ),
                );

              } else if (sm.data!.roleID == 4){
                 // print("22");
                  getBasicDetailsApi(context,sm.data!.userID.toString(),sm.data!.roleID);

              } else if (sm.data!.roleID == 7){

                getEmpBasicDetailsApi(context,sm.data!.userID.toString(),sm.data!.roleID);

                // Navigator.of(context).push(
                //   RightToLeftRoute(
                //     page:  EmployerDashboard(),
                //     duration: const Duration(milliseconds: 500),
                //     startOffset: const Offset(-1.0, 0.0),
                //   ),
                // );
              }
            }
            else{
              print("33");
              Navigator.of(context).push(
                RightToLeftRoute(
                  page:  RoleSelectionScreen(ssoId: SSOIDController.text,userID:""),
                  duration: const Duration(milliseconds: 500),
                  startOffset: const Offset(-1.0, 0.0),
                ),
              );
            }
            return sm;
          } else {
            final smmm = TempLoginModal(state: 0, message: sm.message.toString());
            Navigator.of(context).push(
              RightToLeftRoute(
                page:  RoleSelectionScreen(ssoId: SSOIDController.text,userID:""),
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
                page:  RoleSelectionScreen(ssoId: SSOIDController.text,userID:userId),
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
                page:  RoleSelectionScreen(ssoId: SSOIDController.text,userID:userId),
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


  rememberMe(bool? value) {
    isChecked = value ?? false;
    notifyListeners();
    // You can implement any action here based on checkbox change
  }



}
