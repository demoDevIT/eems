import 'dart:convert';

import 'package:flutter/material.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/user_new.dart';
import '../../empotr_form/modal/city_modal.dart';
import '../../empotr_form/modal/district_modal.dart';
import '../../empotr_form/modal/state_modal.dart';
import '../modal/emp_info_modal.dart';


class HeadOfficeApplicantDetailProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  HeadOfficeApplicantDetailProvider({required this.commonRepo});

  final UserData _userData = UserData();
  get userModel => _userData.model.value;

  // STATE
  List<StateData> hoStateList = [];
  StateData? hoSelectedState;
  TextEditingController hoStateController = TextEditingController();
  TextEditingController hoStateIdController = TextEditingController();

// DISTRICT
  List<DistrictData> hoDistrictList = [];
  DistrictData? hoSelectedDistrict;
  TextEditingController hoDistrictController = TextEditingController();
  TextEditingController hoDistrictIdController = TextEditingController();
  bool isHoDistrictLoading = false;

// CITY
  List<CityData> hoCityList = [];
  CityData? hoSelectedCity;
  TextEditingController hoCityController = TextEditingController();
  TextEditingController hoCityIdController = TextEditingController();

  Future<void> getHoStateApi(BuildContext context) async {
    final apiResponse = await commonRepo.get("Common/GetStateMaster");

    if (apiResponse.response?.statusCode == 200) {
      var responseData = apiResponse.response?.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      final sm = StateModal.fromJson(responseData);
      hoStateList.clear();
      hoStateList.addAll(sm.data ?? []);

      notifyListeners();
    }
  }

  Future<void> getHoDistrictApi(BuildContext context, int stateId) async {
    isHoDistrictLoading = true;
    notifyListeners();

    try {
      final apiResponse =
      await commonRepo.get("Common/DistrictMaster_StateIDWise/$stateId");

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        hoDistrictList.clear();
        if (responseData['Data'] != null) {
          for (var e in responseData['Data']) {
            hoDistrictList.add(DistrictData.fromJson(e));
          }
        }
      }
    } catch (_) {
      hoDistrictList.clear();
    }

    isHoDistrictLoading = false;
    notifyListeners();
  }

  Future<void> getHoCityApi(BuildContext context, String districtId) async {
    try {
      final apiResponse =
      await commonRepo.get("Common/GetCityMaster/$districtId");

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        hoCityList.clear();
        if (responseData['Data'] != null) {
          for (var e in responseData['Data']) {
            hoCityList.add(CityData.fromJson(e));
          }
        }
        notifyListeners();
      }
    } catch (_) {
      hoCityList.clear();
      notifyListeners();
    }
  }

  Future<void> setHoLocationFromIds({
    required BuildContext context,
    required int stateId,
    required int districtId,
    required int cityId,
  }) async {
    print("asasasas===");
    /// 1️⃣ SET STATE
    hoSelectedState =
        hoStateList.firstWhere((e) => e.iD == stateId);

    hoStateController.text = hoSelectedState?.name ?? "";
    hoStateIdController.text = stateId.toString();

    notifyListeners();

    /// 2️⃣ LOAD DISTRICT
    await getHoDistrictApi(context, stateId);

    hoSelectedDistrict =
        hoDistrictList.firstWhere((e) => e.iD == districtId);

    hoDistrictController.text = hoSelectedDistrict?.name ?? "";
    hoDistrictIdController.text = districtId.toString();

    notifyListeners();

    /// 3️⃣ LOAD CITY
    await getHoCityApi(context, districtId.toString());

    hoSelectedCity =
        hoCityList.firstWhere((e) => e.iD == cityId);

    hoCityController.text = hoSelectedCity?.nameEng ?? "";
    hoCityIdController.text = cityId.toString();

    notifyListeners();
  }


  void printUserData() {
    final data = userModel;

    if (data == null) {
      debugPrint("❌ Branch Office UserData is NULL");
      return;
    }

    debugPrint("totalPerson : ${data.totalPerson}");
    debugPrint("hoTanNo : ${data.hoTanNo}");

  }

  /// ============================
  /// GETTERS FOR UI
  /// ============================
  String get applicantNameCtrl => userModel?.applicantName ?? "";
  String get applicantMobileCtrl => userModel?.applicantNo ?? "";
  String get applicantEmailCtrl => userModel?.applicantEmail ?? "";
  String get yearCtrl => userModel?.year ?? "";
  String get ownershipCtrl => userModel?.ownership ?? "";
  String get totalPersonCtrl => userModel?.totalPerson?.toString() ?? "0";
  String get actAuthorityRegCtrl => userModel?.actRegNo ?? "";
  String get tanCtrl => userModel?.hoTanNo ?? "";
  String get emailCtrl => userModel?.hoApplicationEmail ?? "";
  String get websiteCtrl => userModel?.webSite ?? "";
  String get applicantAddressCtrl => userModel?.applicantAddress ?? "";
  String get nicCodeCtrl => userModel?.nicCode ?? "";

}