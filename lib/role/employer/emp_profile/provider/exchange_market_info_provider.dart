import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/user_new.dart';
import '../../empotr_form/modal/actEstablishment_modal.dart';
import '../../empotr_form/modal/sector_modal.dart';

class ExchangeMarketInfoProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  ExchangeMarketInfoProvider({required this.commonRepo});

  final UserData _userData = UserData();
  get userModel => _userData.model.value;

  /// =========================
  /// TEXT CONTROLLERS
  /// =========================
  final TextEditingController maleEmpCtrl = TextEditingController();
  final TextEditingController femaleEmpCtrl = TextEditingController();
  final TextEditingController transgenderEmpCtrl = TextEditingController();
  final TextEditingController totalEmpCtrl = TextEditingController();

  final List<String> organizationTypes = [
    "Private",
    "Government",
    "PSU",
  ];

  String? orgType;

  final List<String> governmentBodies = [
    "Central Government",
    "Local Body",
    "State Government",
    "State Quasi Government",
    "Central Quasi Government",
  ];

  String? govtBody;

  final List<String> industryTypes = [
    "Manufacturing",
    "IT",
    "Service",
  ];

  String? industryType;

  List<ActEstablishmentData> actEstList = [];
  ActEstablishmentData? selectedActEst;

  List<SectorData> sectorList = [];
  SectorData? selectedSector;

  int? selectedSectorId;


  // List<StateData> stateList = [];
  // StateData? selectedState;
  // TextEditingController stateController = TextEditingController();
  // TextEditingController stateIdController = TextEditingController();

  // List<DistrictData> districtList = [];
  // DistrictData? selectedDistrict;
  // TextEditingController districtController = TextEditingController();
  // TextEditingController districtIdController = TextEditingController();
  // bool isDistrictLoading = false;

  // List<CityData> cityList = [];
  // CityData? selectedCity;
  // TextEditingController cityController = TextEditingController();
  // TextEditingController cityIdController = TextEditingController();

  void setExchangeMarketData() {
    final data = userModel;
    if (data == null) return;

    final sectorID = data.emipSector;
    print("sectorID ====> $sectorID");

    maleEmpCtrl.text = data.numberOfMaleEmployees?.toString() ?? "";
    femaleEmpCtrl.text = data.numberOfFemaleEmployees?.toString() ?? "";
    transgenderEmpCtrl.text = data.numberOfTransgenderEmployees?.toString() ?? "";
    totalEmpCtrl.text = data.totalNumberOfEmployees?.toString() ?? "";

    notifyListeners();
  }

  Future<void> loadAndBindActEstablishment(BuildContext context) async {
    await actEstablishmentApi(context); // 1️⃣ load master list

    final data = userModel;
    if (data == null) return;

    final actEst = data.actEstablishment;
    debugPrint("actEst ====> $actEst");

    if (actEst == null || actEst.isEmpty) return;

    try {
      selectedActEst = actEstList.firstWhere(
            (e) =>
        (e.actEstablishment ?? "")
            .toLowerCase()
            .trim() ==
            actEst.toLowerCase().trim(),
      );
    } catch (e) {
      debugPrint("❌ Act Establishment not found in master list");
      selectedActEst = null;
    }

    notifyListeners();
  }

  Future<void> actEstablishmentApi(BuildContext context) async {
    final apiResponse = await commonRepo.get(
      "Common/GetActEstablishmentMaster",
    );

    if (apiResponse.response?.statusCode == 200) {
      var responseData = apiResponse.response?.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      final actModel = ActEstablishmentModal.fromJson(responseData);

      actEstList.clear();
      actEstList.addAll(actModel.data ?? []);

      notifyListeners();
    }
  }

  void setSectorFromId(int? sectorId) {
    if (sectorId == null || sectorList.isEmpty) return;

    try {
      selectedSector =
          sectorList.firstWhere((e) => e.iD == sectorId);
    } catch (e) {
      selectedSector = null;
    }

    notifyListeners();
  }

  Future<void> sectorApi(BuildContext context) async {
    final apiResponse =
    await commonRepo.get("MobileProfile/SectorData");

    if (apiResponse.response?.statusCode == 200) {
      var responseData = apiResponse.response?.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      final sectorModel = SectorModal.fromJson(responseData);

      sectorList
        ..clear()
        ..addAll(sectorModel.data ?? []);

      final data = userModel;

      // 🔥 IMPORTANT FIX
      if (data?.emipSector != null) {
        selectedSectorId = int.tryParse(data!.emipSector.toString());
      }

      notifyListeners();
    }
  }

}
