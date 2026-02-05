import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/user_new.dart';
import '../../empotr_form/modal/city_modal.dart';
import '../../empotr_form/modal/district_modal.dart';
import '../../empotr_form/modal/state_modal.dart';

class ContactPersonDetailProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  ContactPersonDetailProvider({required this.commonRepo});

  final UserData _userData = UserData();
  get userModel => _userData.model.value;

  /// =========================
  /// TEXT CONTROLLERS
  /// =========================
  final TextEditingController panCtrl = TextEditingController();
  final TextEditingController fullNameCtrl = TextEditingController();
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController altMobileCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController pincodeCtrl = TextEditingController();
  final TextEditingController designationCtrl = TextEditingController();
  final TextEditingController departmentCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();

  /// =========================
  /// STATE
  /// =========================
  List<StateData> stateList = [];
  StateData? selectedState;
  TextEditingController stateController = TextEditingController();
  TextEditingController stateIdController = TextEditingController();

  /// =========================
  /// DISTRICT
  /// =========================
  List<DistrictData> districtList = [];
  DistrictData? selectedDistrict;
  TextEditingController districtController = TextEditingController();
  TextEditingController districtIdController = TextEditingController();
  bool isDistrictLoading = false;

  /// =========================
  /// CITY
  /// =========================
  List<CityData> cityList = [];
  CityData? selectedCity;
  TextEditingController cityController = TextEditingController();
  TextEditingController cityIdController = TextEditingController();

  /// =========================
  /// SET DATA FROM USER MODEL
  /// =========================
  void setContactPersonData() {
    final data = userModel;
    if (data == null) return;

    panCtrl.text = data.contactPANNo ?? "";
    fullNameCtrl.text = data.contactFirstName ?? "";
    mobileCtrl.text = data.contactMobileNumber ?? "";
    altMobileCtrl.text = data.contactAlternateMobileNumber ?? "";
    emailCtrl.text = data.contactEmail ?? "";
    pincodeCtrl.text = data.contactPincode ?? "";
    designationCtrl.text = data.contactDesignation ?? "";
    departmentCtrl.text = data.contactdepartment ?? "";
    addressCtrl.text = data.contactAddress ?? "";
  }

  /// =========================
  /// API CALLS (same as HO)
  /// =========================
  Future<void> getStateApi() async {
    print("getState===========>");
    final res = await commonRepo.get("Common/GetStateMaster");
    if (res.response?.statusCode == 200) {
      var data = res.response!.data;
      if (data is String) data = jsonDecode(data);
      stateList = (StateModal.fromJson(data).data ?? []);
      notifyListeners();
    }
  }

  Future<void> getDistrictApi(int stateId) async {
    isDistrictLoading = true;
    notifyListeners();

    final res =
    await commonRepo.get("Common/DistrictMaster_StateIDWise/$stateId");

    if (res.response?.statusCode == 200) {
      var data = res.response!.data;
      if (data is String) data = jsonDecode(data);

      districtList.clear();
      for (var e in data['Data']) {
        districtList.add(DistrictData.fromJson(e));
      }
    }

    isDistrictLoading = false;
    notifyListeners();
  }

  Future<void> getCityApi(String districtId) async {
    final res = await commonRepo.get("Common/GetCityMaster/$districtId");

    if (res.response?.statusCode == 200) {
      var data = res.response!.data;
      if (data is String) data = jsonDecode(data);

      cityList.clear();
      for (var e in data['Data']) {
        cityList.add(CityData.fromJson(e));
      }
      notifyListeners();
    }
  }

  int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    return int.tryParse(value.toString());
  }


  /// =========================
  /// SET LOCATION FROM IDS
  /// =========================
  Future<void> setLocationFromIds({
    required BuildContext context,
    required int stateId,
    required int districtId,
    required int cityId,
  }) async {

    print("stateID=@@> $stateId");
    print("districtId=> $districtId");
    print("cityID=> $cityId");
    /// 1️⃣ STATE
    selectedState =
        stateList.firstWhere((e) => e.iD == stateId);

    stateController.text = selectedState?.name ?? "";
    stateIdController.text = stateId.toString();
    notifyListeners();

    /// 2️⃣ DISTRICT
    await getDistrictApi(stateId);

    selectedDistrict =
        districtList.firstWhere((e) => e.iD == districtId);

    districtController.text = selectedDistrict?.name ?? "";
    districtIdController.text = districtId.toString();
    notifyListeners();

    /// 3️⃣ CITY
    await getCityApi(districtId.toString());

    selectedCity =
        cityList.firstWhere((e) => e.iD == cityId);

    cityController.text = selectedCity?.nameEng ?? "";
    cityIdController.text = cityId.toString();
    notifyListeners();
  }

}
