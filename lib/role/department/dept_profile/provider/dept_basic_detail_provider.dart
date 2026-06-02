import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/role/job_seeker/loginscreen/modal/temp_login_modal.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../../register_form/modal/department_modal.dart';
import '../../register_form/modal/office_modal.dart';
import '../../register_form/modal/reg_form_modal.dart';
import '../modal/dept_profile_modal.dart';
import '../../register_form/modal/district_modal.dart';

class DeptBasicDetailsProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  DeptBasicDetailsProvider({required this.commonRepo});

  // Controllers for text fields
  final TextEditingController ssoController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController districtIdController = TextEditingController();
  final TextEditingController deptIdController = TextEditingController();
  final TextEditingController deptNameController = TextEditingController();
  final TextEditingController allotDeptIdController = TextEditingController();
  final TextEditingController allotDeptNameController = TextEditingController();
  final TextEditingController officerNameController = TextEditingController();
  final TextEditingController nameAsAdharController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController adminDeptNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController personalMailController = TextEditingController();
  final TextEditingController officialMailController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController empNumberController = TextEditingController();

  bool isDistrictLoading = false;
  List<DistrictData> districtList = [];
  DistrictData? selectedDistrict;

  bool isDepartmentLoading = false;
  List<DepartmentData> departmentList = [];
  DepartmentData? selectedDepartment;

  /// Office Dropdown
  bool isOfficeLoading = false;
  List<OfficeData> officeList = [];
  OfficeData? selectedOffice;

  // Profile image
  XFile? profileFile;

  @override
  void dispose() {
    super.dispose();
  }

  bool isLoading = false;
  List<DeptProfileModalData> deptProfileData = [];

  Future<DeptProfileModal?> deptProfile(BuildContext context) async {

    print("========== COMPLETE USER MODEL ==========");
    print(
      const JsonEncoder.withIndent('  ')
          .convert(UserData().model.value.toJson()),
    );
    print("=========================================");

    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        isLoading = true;
        notifyListeners(); // 🔥 trigger UI loader

        String ? IpAddress =  await UtilityClass.getIpAddress();

        Map<String, dynamic> bodyy =
        {
          "ActionName": "DepartmentUserInfoForUpdate",
          "RoleId": UserData().model.value.roleId,
          "UserID": UserData().model.value.userId,
          "OfficeID": UserData().model.value.officeID,
          "DistrictCode": UserData().model.value.districtCode,
        };

        String url = "Common/GetApprovalList";
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post(url,bodyy);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = DeptProfileModal.fromJson(responseData);
          print("Total records from API: ${sm.data?.length}");
          if (sm.state == 200) {
            deptProfileData.clear();
            deptProfileData.addAll(sm.data!);
            if (deptProfileData.isNotEmpty) {
              final data = deptProfileData.first;

              ssoController.text = data.SSOID ?? "";
              nameController.text = data.name ?? "";
              mobileController.text = data.mobileNo ?? "";
              districtController.text = data.districtName ?? "";
             // deptIdController.text = data.departmentID ?? "";

              officerNameController.text = data.officerName ?? "";
              nameAsAdharController.text = data.nameAsPerAadhar ?? "";
              designationController.text = data.designationName ?? "";
              adminDeptNameController.text = data.administrationDepartmentName ?? "";
              genderController.text = data.gender ?? "";
              personalMailController.text = data.mailPersonal ?? "";
              officialMailController.text = data.mailOfficial ?? "";
              lastNameController.text = data.lastName ?? "";
              empNumberController.text = data.empNumber ?? "";

              // selectedDistrict = data.districtCode ?? "";
              // districtIdController.text = data.districtCode ?? "";
              // deptNameController.text = data.departmentName ?? "";
              // allotDeptIdController.text = data.allotmentDeptId ?? "";
              // allotDeptNameController.text = data.allotedDepartmentName ?? "";

              /// DISTRICT
              districtIdController.text = data.districtCode?.toString() ?? "";
              districtController.text = data.districtName ?? "";

              selectedDistrict = districtList.firstWhere(
                    (e) => e.iD.toString() == data.districtCode.toString(),
                orElse: () => DistrictData(),
              );


              /// DEPARTMENT
              deptIdController.text = data.departmentID?.toString() ?? "";
              deptNameController.text = data.departmentName ?? "";

              selectedDepartment = departmentList.firstWhere(
                    (e) => e.iD.toString() == data.departmentID.toString(),
                orElse: () => DepartmentData(),
              );


              /// LOAD OFFICE LIST FIRST
              await getOfficeApi(context);


              /// OFFICE
              allotDeptIdController.text =
                  data.allotmentDeptId?.toString() ?? "";
              allotDeptNameController.text = data.allotedDepartmentName ?? "";

              selectedOffice = officeList.firstWhere(
                    (e) => e.iD.toString() == data.allotmentDeptId.toString(),
                orElse: () => OfficeData(),
              );

            }
            print("Total records in list: ${deptProfileData.length}");
            print("Total records DATAAAA: ${deptProfileData}");

          } else {

            showAlertError(sm.message ?? "Error", context);
          }
          isLoading = false;
          notifyListeners();
          return sm;
        } else {
          isLoading = false;
          notifyListeners();
          return DeptProfileModal(state: 0, message: 'Something went wrong',
          );
        }
      }

      catch (err) {
        isLoading = false;
        notifyListeners();
        showAlertError(err.toString(), context);
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
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

  Future<void> getDepartmentApi(BuildContext context) async {
    isDepartmentLoading = true;

    selectedDepartment = null;
    deptNameController.clear();
    deptIdController.clear();
    departmentList.clear();

    notifyListeners();

    try {
      final apiResponse = await commonRepo.get(
        "Common/DepartmentMasterList",
      );

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        if (responseData['Data'] != null) {
          for (var e in responseData['Data']) {
            departmentList.add(DepartmentData.fromJson(e));
          }
        }
      }
    } catch (_) {
      departmentList.clear();
    }

    isDepartmentLoading = false;
    notifyListeners();
  }

  Future<void> getOfficeApi(BuildContext context) async {
    isOfficeLoading = true;

    selectedOffice = null;
    allotDeptNameController.clear();
    allotDeptIdController.clear();
    officeList.clear();

    notifyListeners();

    final internshipDeptTypeID = UserData().model.value.internshipDeptTypeID;
    try {
      // OLD API
      // final apiResponse = await commonRepo.get(
      //   "Common/GetIntershipDeptListbyDeptTypeID/$internshipDeptTypeID",
      // );

      Map<String, dynamic> data = {
        "PrivateDepartmentID": int.tryParse(deptIdController.text) ?? 0,
        "ddlDistrict": districtIdController.text ?? "0",

        "PrivateCityCode": "0",
        "PrivateBlockCode": "0",
        "PrivateGPCode": "0",
        "PrivateWardCode": "0",
        "PrivateVillageCode": "0",
      };

      /// ✅ DEBUG PRINT (recommended)
      print("========== OFFICE API PAYLOAD ==========");
      print(const JsonEncoder.withIndent('  ').convert(data));
      print("========================================");

      /// ✅ CALL POST API
      final apiResponse = await commonRepo.post(
        "Common/GetIntershipDeptListbyDeptTypeID_WIthModelNew",
        data,
      );

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        if (responseData['Data'] != null) {
          officeList = (responseData['Data'] as List)
              .map((e) => OfficeData.fromJson(e))
              .toList();
        }
      }
    } catch (e) {
      print("Office API Error: $e");
      officeList.clear();
    }

    isOfficeLoading = false;
    notifyListeners();
  }

  Future<RegFormModal> submitForm(BuildContext context) async {
    print("SUBMIT postalAddress => ${UserData().model.value.postalAddress}");
    print("SUBMIT empNumber => ${UserData().model.value.empNumber}");
    print("CONTROLLER empNumber => ${empNumberController.text}");
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
        AppLocalizations.of(context)!.internet_connection,
        context,
      );
      return RegFormModal(
        state: 0,
        message: AppLocalizations.of(context)!.internet_connection,
      );
    }

    String? deviceId = await UtilityClass.getDeviceId();

    //these parameters got from amit tripathi , these are extra parameters which are no need to paas in this
    // API (double work both front and backend side) -
    // Gender, MailPersonal, MailOfficial, postalAddress, LastName, EmployeeNumber,UserType
    try {
      Map<String, dynamic> data = {
        "ActionName": "UserProfileUpdate",
        "UserID": UserData().model.value.userId, //"abcd",
        "SSOID": UserData().model.value.sso, //"abcd",
        "OfficerName": officerNameController.text.trim(),
        "AsPerAadharName": nameAsAdharController.text.trim(),
        "MobileNo": mobileController.text.trim(),
        "Designation": designationController.text,
        "AdministrationDepartmentName": adminDeptNameController.text.trim(),
        "ddlDistrict": districtIdController.text,
        "PrivateDepartmentID": deptIdController.text,
        "AllotmentDeptId": allotDeptIdController.text,
        "OtherOfficeAllotedDept": "",
        "Gender": UserData().model.value.gENDER,
        "MailPersonal": UserData().model.value.mailPersonal, //personalMailController.text, //UserData().model.value.mailPersonal,
        "MailOfficial": UserData().model.value.mailOfficial, //officialMailController.text, //UserData().model.value.mailOfficial,
        "postalAddress": UserData().model.value.postalAddress, //UserData().model.value.postalAddress,
        "LastName": UserData().model.value.lastName, //lastNameController.text, //UserData().model.value.lastName,
        "EmployeeNumber": UserData().model.value.empNumber, //UserData().model.value.empNumber, //empNumberController.text, //UserData().model.value.empNumber,
        "UserType": UserData().model.value.userType,
        "DeviceId": deviceId
      };

      /// ✅ PRINT FULL REQUEST DATA
      print("========== SUBMIT API PAYLOAD ==========");
      print(const JsonEncoder.withIndent('  ').convert(data));
      print("=========================================");


      // return RegFormModal(
      //   state: 1,
      //   message: "Debug Stop",
      // );
      ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.post(
        "Common/UserProfileUpdate",
        data,
      );

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response != null &&
          apiResponse.response?.statusCode == 200) {

        var responseData = apiResponse.response?.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        final sm = RegFormModal.fromJson(responseData);

        if (sm.state == 200) {
          successDialog(
            context,
            sm.data![0].resMsg ?? "Success",
                (value) {
              if (value.toString() == "success") {
                Navigator.pop(context);
              }
            },
          );
          return sm;
        } else {
          showAlertError(
            sm.message?.toString() ?? "Something went wrong",
            context,
          );
          return sm;
        }
      } else {
        return RegFormModal(
          state: 0,
          message: "Something went wrong",
        );
      }


    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
      return RegFormModal(
        state: 0,
        message: e.toString(),
      );
    }
  }

  clearData() {

  }
}
