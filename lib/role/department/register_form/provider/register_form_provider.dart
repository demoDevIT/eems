import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rajemployment/role/department/register_form/modal/reg_form_modal.dart';
import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/global.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../modal/block_modal.dart';
import '../modal/department_modal.dart';
import '../modal/district_modal.dart';
import '../modal/city_modal.dart';
import '../modal/gp_modal.dart';
import '../modal/village_modal.dart';
import '../modal/ward_modal.dart';


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

    try {
      Map<String, dynamic> data = {
       // "ActionName": "InsertData",
        "District": "",
        "Area": "",
        "City": "",
        "Ward": "",
        "Department": "",
        "Office": "",
        "SSOID": "",
        "Mobile": "",
        "Designation": "",
      };

      ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.post(
        "************** Department Save API ****************",
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

  void init(String ssoId) {
    ssoIdController.text = ssoId; // disabled field
  }

  void clearData() {
    // districtList.clear();
    // selectedDistrict = null;
  }
}




