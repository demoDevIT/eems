import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rajemployment/role/department/dept_dashboard/dept_dashboard.dart';
import 'package:rajemployment/role/department/register_form/modal/reg_form_modal.dart';
import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/app_shared_prefrence.dart';
import '../../../../utils/global.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/right_to_left_route.dart';
import '../../../../utils/utility_class.dart';
import '../../dept_dashboard/modal/dept_info_modal.dart';
import '../modal/block_modal.dart';
import '../modal/department_modal.dart';
import '../modal/district_modal.dart';
import '../modal/city_modal.dart';
import '../modal/gp_modal.dart';
import '../modal/village_modal.dart';
import '../modal/ward_modal.dart';
import '../../../../utils/user_new.dart';


class RegisterFormProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  RegisterFormProvider({required this.commonRepo});

  /// ======================
  /// DISTRICT DROPDOWN
  /// ======================
  bool isDistrictLoading = false;

  List<DistrictData> districtList = [];
  DistrictData? selectedDistrict;

  final TextEditingController districtController = TextEditingController();
  final TextEditingController districtIdController = TextEditingController();

  /// ======================
  /// AREA (URBAN / RURAL)
  /// ======================
  String areaType = "Rural";
  //bool isAreaFromBRN = false;

  ///city dropdown
  bool isCityLoading = false;

  List<CityData> cityList = [];
  CityData? selectedCity;

  final TextEditingController cityNameController = TextEditingController();
  final TextEditingController cityIdController = TextEditingController();


  void setArea(String? value) {
    if (value == null) return;
    areaType = value;

    /// 🔴 CLEAR RURAL DATA
    selectedCity = null;
    cityNameController.clear();
    cityIdController.clear();
    // cityList.clear();

    selectedWard = null;
    wardNameController.clear();
    wardIdController.clear();
    // wardList.clear();

    // Urban selections
    selectedBlock = null;
    blockNameController.clear();
    blockIdController.clear();

    selectedGp = null;
    gpNameController.clear();
    gpIdController.clear();

    selectedVillage = null;
    villageNameController.clear();
    villageIdController.clear();

    notifyListeners();
  }

  /// WARD DROPDOWN
  bool isWardLoading = false;

  List<WardData> wardList = [];
  WardData? selectedWard;

  final TextEditingController wardNameController = TextEditingController();
  final TextEditingController wardIdController = TextEditingController();

  /// ===== BLOCK =====
  bool isBlockLoading = false;
  List<BlockData> blockList = [];
  BlockData? selectedBlock;
  final blockNameController = TextEditingController();
  final blockIdController = TextEditingController();

  /// ===== GRAM PANCHAYAT =====
  bool isGpLoading = false;
  List<GramPanchayatData> gpList = [];
  GramPanchayatData? selectedGp;
  final gpNameController = TextEditingController();
  final gpIdController = TextEditingController();

  /// ===== VILLAGE =====
  bool isVillageLoading = false;
  List<VillageData> villageList = [];
  VillageData? selectedVillage;
  final villageNameController = TextEditingController();
  final villageIdController = TextEditingController();


  /// DEPARTMENT DROPDOWN
  bool isDepartmentLoading = false;

  List<DepartmentData> departmentList = [];
  DepartmentData? selectedDepartment;

  final TextEditingController departmentNameController =
  TextEditingController();
  final TextEditingController departmentIdController =
  TextEditingController();


  /// ======================
  /// FORM CONTROLLERS
  /// ======================
  final TextEditingController gramPanchayatController = TextEditingController();
  final TextEditingController villageController = TextEditingController();
  //final TextEditingController departmentNameController = TextEditingController();
  final TextEditingController officeNameController = TextEditingController();
  final TextEditingController ssoIdController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController designationController = TextEditingController();

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

  Future<void> getCityApi(BuildContext context, String districtCode) async {
    isCityLoading = true;

    selectedCity = null;
    cityNameController.clear();
    cityIdController.clear();
    cityList.clear();

    notifyListeners();

    try {
      final apiResponse =
      await commonRepo.get("Common/GetCityMaster/$districtCode");

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        if (responseData['Data'] != null) {
          for (var e in responseData['Data']) {
            cityList.add(CityData.fromJson(e));
          }
        }
        print(CityData);
      }
    } catch (_) {
      cityList.clear();
    }

    isCityLoading = false;
    notifyListeners();
  }

  Future<void> getWardApi(BuildContext context, String cityCode) async {
    isWardLoading = true;

    selectedWard = null;
    wardNameController.clear();
    wardIdController.clear();
    wardList.clear();

    notifyListeners();

    try {
      final apiResponse = await commonRepo.get(
        "Common/GetWardMaster/$cityCode",
      );

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        if (responseData['Data'] != null) {
          for (var e in responseData['Data']) {
            wardList.add(WardData.fromJson(e));
          }
        }
      }
    } catch (_) {
      wardList.clear();
    }

    isWardLoading = false;
    notifyListeners();
  }

  Future<void> getBlockApi(BuildContext context, String districtCode) async {
    isBlockLoading = true;

    selectedBlock = null;
    blockList.clear();
    blockNameController.clear();
    blockIdController.clear();

    notifyListeners();

    final apiResponse =
    await commonRepo.get("Common/GetBlockMaster/$districtCode");

    if (apiResponse.response?.statusCode == 200) {
      dynamic data = apiResponse.response!.data;
      if (data is String) data = jsonDecode(data);

      for (var e in data['Data']) {
        blockList.add(BlockData.fromJson(e));
      }
    }

    isBlockLoading = false;
    notifyListeners();
  }

  Future<void> getGpApi(BuildContext context, String blockCode) async {
    isGpLoading = true;

    selectedGp = null;
    gpList.clear();
    gpNameController.clear();
    gpIdController.clear();

    notifyListeners();

    final apiResponse =
    await commonRepo.get("Common/GetGrampanchyatMaster/$blockCode");

    if (apiResponse.response?.statusCode == 200) {
      dynamic data = apiResponse.response!.data;
      if (data is String) data = jsonDecode(data);

      for (var e in data['Data']) {
        gpList.add(GramPanchayatData.fromJson(e));
      }
    }

    isGpLoading = false;
    notifyListeners();
  }

  Future<void> getVillageApi(BuildContext context, String gpCode) async {
    isVillageLoading = true;

    selectedVillage = null;
    villageList.clear();
    villageNameController.clear();
    villageIdController.clear();

    notifyListeners();

    final apiResponse =
    await commonRepo.get("Common/GetVillageMaster/$gpCode");

    if (apiResponse.response?.statusCode == 200) {
      dynamic data = apiResponse.response!.data;
      if (data is String) data = jsonDecode(data);

      for (var e in data['Data']) {
        villageList.add(VillageData.fromJson(e));
      }
    }

    isVillageLoading = false;
    notifyListeners();
  }


  Future<void> getDepartmentApi(BuildContext context) async {
    isDepartmentLoading = true;

    selectedDepartment = null;
    departmentNameController.clear();
    departmentIdController.clear();
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


  Future<RegFormModal> submitForm(BuildContext context) async {
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

    try {
      Map<String, dynamic> data = {
        "SSOID": ssoIdController.text.trim(),
        "MobileNo": mobileController.text.trim(),
        "DepartmentId": 0,
        "UserType": "Govt",
        "DistrictCode": selectedDistrict?.code != null
            ? selectedDistrict!.code
            : "0",
        "AreaType": areaType == "Urban" ? 2 : 1,
        "CityCode": areaType == "Urban" && selectedCity?.code != null
            ? selectedCity!.code
            : "0",
        "WardCode": areaType == "Urban" && selectedWard?.code != null
            ? selectedWard!.code
            : "0",
        "BlockCode": areaType == "Rural" && selectedBlock?.code != null
            ? selectedBlock!.code
            : "0",
        "GPCode": areaType == "Rural" && selectedGp?.code != null
            ? selectedGp!.code
            : "0",
        "VillageCode": areaType == "Rural" && selectedVillage?.code != null
            ? selectedVillage!.code
            : "0",
        "OfficeName": officeNameController.text.trim(),
        "DesignationName": designationController.text.trim(),
        "DeviceId": deviceId
      };

      /// ✅ PRINT FULL REQUEST DATA
      print("========== SUBMIT API PAYLOAD ==========");
      print(const JsonEncoder.withIndent('  ').convert(data));
      print("=========================================");

      ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.post(
        "Common/CreateDepartmentUser",
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
            sm.message ?? "Success",
                (value) {
              if (value.toString() == "success") {
                if (sm.data != null &&
                    sm.data!.isNotEmpty &&
                    sm.data![0].userId != null) {
                  getDeptBasicDetails(
                    context,
                    sm.data![0].userId.toString(),
                    sm.data![0].roleId,
                    ssoIdController.text.trim()
                  );

                }
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

  Future<DeptInfoModal?> getDeptBasicDetails(
      BuildContext context, String userId, int? roleId, String ssoID) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {
          "UserID": userId,
          "SSOID": ssoID,
          "RoleID": roleId
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
            UserData().model.value.designation = sm.data![0].designation;
            UserData().model.value.territoryType = sm.data![0].territoryType;
            UserData().model.value.village = sm.data![0].village;
            UserData().model.value.gp = sm.data![0].gp;
            UserData().model.value.block = sm.data![0].block;
            UserData().model.value.city = sm.data![0].city;

            pref.save('UserData', UserData().model.value);

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

  void init(String ssoId) {
    ssoIdController.text = ssoId; // disabled field
  }

  void clearData() {
    // districtList.clear();
    // selectedDistrict = null;
  }
}




