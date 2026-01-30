import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../api_service/model/base/api_response.dart';
import '../../../../repo/common_repo.dart';
import '../modal/actEstablishment_modal.dart';
import '../modal/city_modal.dart';
import '../modal/district_modal.dart';
import '../modal/sector_modal.dart';
import '../modal/state_modal.dart';


class EmpOTRFormProvider with ChangeNotifier {
  final CommonRepo commonRepo;

  EmpOTRFormProvider({required this.commonRepo});

  // -------- Controllers --------

  /// 1. Basic Details
  final TextEditingController ssoController = TextEditingController();
  final TextEditingController brnController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  String? districtError;
  String areaType = "";
  bool isAreaFromBRN = false;
  final TextEditingController tehsilController = TextEditingController();
  final TextEditingController localBodyController = TextEditingController();
  final TextEditingController villageController = TextEditingController();
  final TextEditingController wardController = TextEditingController();

  /// 2. Branch Office Details
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController houseNoController = TextEditingController();
  final TextEditingController laneController = TextEditingController();
  final TextEditingController localityController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController telNoController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController gstController = TextEditingController();
  final TextEditingController panController = TextEditingController();
  final TextEditingController panHolderController = TextEditingController();
  final TextEditingController panVerifiedController = TextEditingController();
  final TextEditingController tanController = TextEditingController();

  // errors
  String? pinCodeError;
  String? telError;
  String? emailErrorText;
  String? gstLengthError;
  String? gstFormatError;
  String? panErrorText;
  String? tanErrorText;


  /// 3. Head Office Details
  final TextEditingController hoCompanyNameController = TextEditingController();
  final TextEditingController hoTelNoController = TextEditingController();
  final TextEditingController hoEmailController = TextEditingController();
  final TextEditingController hoPanController = TextEditingController();
  final TextEditingController hoHouseNoController = TextEditingController();
  final TextEditingController hoLaneController = TextEditingController();
  final TextEditingController hoLocalityController = TextEditingController();
  final TextEditingController hoPincodeController = TextEditingController();

  /// 4. Head Office Applicant Details
  final TextEditingController applicantNameController = TextEditingController();
  final TextEditingController applicantMobileController = TextEditingController();
  final TextEditingController applicantEmailController = TextEditingController();
  String? applicantEmailError;
  final TextEditingController yearController = TextEditingController();
  final TextEditingController ownershipController = TextEditingController();
  final TextEditingController totalPersonController = TextEditingController();
  final TextEditingController actAuthorityRegController = TextEditingController();
  final TextEditingController tanNoController = TextEditingController();
  String? hoTanErrorText;
  final TextEditingController hoApplicantEmailController = TextEditingController();
  String? hoApplicantEmailError;
  final TextEditingController websiteController = TextEditingController();
  final TextEditingController nicCodeController = TextEditingController();
  final TextEditingController applicantAddressController = TextEditingController();


  // =======================
// STATE / DISTRICT / CITY
// =======================

// Lists
  List<StateData> stateList = [];
  List<DistrictData> districtList = [];
  List<CityData> locationList = [];

// Selected values
  StateData? selectedState;
  DistrictData? selectedDistrict;
  CityData? selectedCity;

// Internal controllers
  final TextEditingController stateIdController = TextEditingController();
  final TextEditingController stateNameController = TextEditingController();

  final TextEditingController districtIdController = TextEditingController();
  final TextEditingController districtNameController = TextEditingController();

  final TextEditingController locationIdController = TextEditingController();
  final TextEditingController locationNameController = TextEditingController();

// 🔁 ALIAS CONTROLLERS (FOR UI – DO NOT REMOVE)
  TextEditingController get stateController => stateNameController;
  TextEditingController get districtHoController => districtNameController;
  TextEditingController get cityHoController => locationNameController;
  TextEditingController get cityIdController => locationIdController;

// Loader
  bool isDistrictLoading = false;



  /// 5. Contact Person Details
  final TextEditingController contactPanController = TextEditingController();
  final TextEditingController contactNameController = TextEditingController();
  final TextEditingController contactMobileController = TextEditingController();
  final TextEditingController contactAltMobileController = TextEditingController();
  final TextEditingController contactEmailController = TextEditingController();
  final TextEditingController contactDesignationController = TextEditingController();
  final TextEditingController contactDepartmentController = TextEditingController();
  final TextEditingController contactPincodeController = TextEditingController();
  final TextEditingController contactStateController = TextEditingController();
  final TextEditingController contactDistrictController = TextEditingController();
  final TextEditingController contactCityController = TextEditingController();
  final TextEditingController contactAddressController = TextEditingController();

  // -------- Contact Person Errors --------
  String? contactPanError;
  String? contactMobileError;
  String? contactAlterMobileError;
  String? contactEmailError;

  // Lists
  List<StateData> coStateList = [];
  List<DistrictData> coDistrictList = [];
  List<CityData> coLocationList = [];

  // Selected values
  StateData? coSelectedState;
  DistrictData? coSelectedDistrict;
  CityData? coSelectedCity;

// Internal controllers
  final TextEditingController coStateIdController = TextEditingController();
  final TextEditingController coStateNameController = TextEditingController();

  final TextEditingController coDistrictIdController = TextEditingController();
  final TextEditingController coDistrictNameController = TextEditingController();

  final TextEditingController coLocationIdController = TextEditingController();
  final TextEditingController coLocationNameController = TextEditingController();

// 🔁 ALIAS CONTROLLERS (FOR UI – DO NOT REMOVE)
  TextEditingController get coStateController => stateNameController;
  TextEditingController get coDistrictController => districtNameController;
  TextEditingController get coCityController => locationNameController;
  TextEditingController get coCityIdController => locationIdController;

// Loader
  bool iscoDistrictLoading = false;


  /// 6. Exchange Name / District Employment Office
  final TextEditingController exchangeNameController = TextEditingController();

  /// 7. Exchange Market Information Program
  final TextEditingController organisationTypeController = TextEditingController();
  final TextEditingController govtBodyController = TextEditingController();
  final TextEditingController noOfMaleEmpController = TextEditingController();
  final TextEditingController noOfFemaleEmpController = TextEditingController();
  final TextEditingController noOfTransEmpController = TextEditingController();
  final TextEditingController noOfTotalEmpController = TextEditingController();
  final TextEditingController actEstController = TextEditingController();
  final TextEditingController industryTypetController = TextEditingController();
  final TextEditingController sectorController = TextEditingController();

  String? organisationType;
  String? govtBody;
  String? industryType;

  List<ActEstablishmentData> actEstList = [];
  ActEstablishmentData? selectedActEst;

  // Sector
  List<SectorData> sectorList = [];
  SectorData? selectedSector;
  bool isSectorLoading = false;


  /// 8. Upload Organization/Company Documents
  // final TextEditingController panCertificateController = TextEditingController();
  // final TextEditingController tanCertificateController = TextEditingController();
  // final TextEditingController gstCertificateController = TextEditingController();
  // final TextEditingController logoController = TextEditingController();

  File? panCertificateController;
  File? tanCertificateController;
  File? gstCertificateController;
  File? logoController;



  // -------- Methods --------

  void setSSO(String ssoId) {
    ssoController.text = ssoId;
  }

  void setArea(String? value) {
    if (value == null) return;
    areaType = value;
    notifyListeners();
  }

  void setOrganisationType(String? value) {
    organisationType = value;
    notifyListeners();
  }

  void setGovtBody(String? value) {
    govtBody = value;
    notifyListeners();
  }

  void setIndustryType(String? value) {
    industryType = value;
    notifyListeners();
  }

  void setActEstablishment(ActEstablishmentData? value) {
    selectedActEst = value;
    notifyListeners();
  }


  Future<void> pickImage(Function(File) onImagePicked) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      onImagePicked(File(pickedFile.path));
      notifyListeners();
    }
  }

  Future<void> stateApi(BuildContext context) async {
    final apiResponse = await commonRepo.get("Common/GetStateMaster");

    if (apiResponse.response?.statusCode == 200) {
      var responseData = apiResponse.response?.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

      final sm = StateModal.fromJson(responseData);
      stateList.clear();
      stateList.addAll(sm.data ?? []);

      coStateList.clear();
      coStateList.addAll(sm.data ?? []);

      notifyListeners();
    }
  }

  Future<void> getDistrictApi(BuildContext context, int stateId) async {
    isDistrictLoading = true;
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
        coDistrictList.clear();
        if (responseData['Data'] != null) {
          for (var e in responseData['Data']) {
            districtList.add(DistrictData.fromJson(e));
            coDistrictList.add(DistrictData.fromJson(e));
          }
        }

      }
    } catch (_) {
      districtList.clear();
      coDistrictList.clear();
    }

    isDistrictLoading = false;
    iscoDistrictLoading = false;
    notifyListeners();
  }

  Future<void> getCityApi(BuildContext context, String districtCode) async {
    try {
      final apiResponse =
      await commonRepo.get("Common/GetCityMaster/$districtCode");

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        locationList.clear();
        coLocationList.clear();
        if (responseData['Data'] != null) {
          for (var e in responseData['Data']) {
            locationList.add(CityData.fromJson(e));
            coLocationList.add(CityData.fromJson(e));
          }
        }
        notifyListeners();
      }
    } catch (_) {
      locationList.clear();
      coLocationList.clear();
      notifyListeners();
    }
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

      calculateTotalEmployees();

      notifyListeners();
    }
  }

  // void setSector(SectorData? value) {
  //   selectedSector = value;
  //   sectorController.text = value?.name ?? "";
  //   notifyListeners();
  // }

  void setSector(SectorData? value) {
    selectedSector = value;
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

      sectorList.clear();
      sectorList.addAll(sectorModel.data ?? []);

      notifyListeners();
    }
  }




  void calculateTotalEmployees() {
    final male = int.tryParse(noOfMaleEmpController.text) ?? 0;
    final female = int.tryParse(noOfFemaleEmpController.text) ?? 0;
    final trans = int.tryParse(noOfTransEmpController.text) ?? 0;

    final total = male + female + trans;

    // 🔒 Auto set total (disabled field)
    noOfTotalEmpController.text = total.toString();

    // 🔁 Auto select Act Establishment
    if (actEstList.isEmpty) return;

    if (total < 10) {
      selectedActEst = actEstList.firstWhere(
            (e) => e.actEstablishment == "No Act",
        orElse: () => actEstList.first,
      );
    } else if (total >= 10 && total < 25) {
      selectedActEst = actEstList.firstWhere(
            (e) => e.actEstablishment == "Non-Act Establishment",
        orElse: () => actEstList.first,
      );
    } else {
      selectedActEst = actEstList.firstWhere(
            (e) => e.actEstablishment == "Act Establishment",
        orElse: () => actEstList.first,
      );
    }

    notifyListeners();
  }


  void autoFillFromBRN(Map<String, dynamic> data) {
    // -------- BASIC DETAILS --------
    brnController.text = data['BRN']?.toString() ?? "";
    districtController.text = data['District']?.toString() ?? "";
    areaType = data['Area']?.toString() ?? "";
    isAreaFromBRN = areaType.isNotEmpty;
    tehsilController.text = data['Tehsil']?.toString() ?? "";
    villageController.text = data['Village']?.toString() ?? "";
    localBodyController.text = data['LocalBody']?.toString() ?? "";
    wardController.text = data['Ward']?.toString() ?? "";

    // -------- BRANCH OFFICE DETAILS --------
    companyNameController.text = data['BO_Name']?.toString() ?? "";
    houseNoController.text = data['BO_HouseNo']?.toString() ?? "";
    laneController.text = data['BO_Lane']?.toString() ?? "";
    localityController.text = data['BO_Locality']?.toString() ?? "";
    pinCodeController.text = data['BO_PinCode']?.toString() ?? "";
    emailController.text = data['BO_Email']?.toString() ?? "";

    panController.text = data['BO_PanNo']?.toString() ?? "";
    panVerifiedController.text = data['BO_PanNo']?.toString() ?? "";
    tanController.text = data['BO_TanNo']?.toString() ?? "";

    // -------- HEAD OFFICE DETAILS (3rd SECTION) --------
    hoCompanyNameController.text = data['HO_Name']?.toString() ?? "";
    hoHouseNoController.text = data['HO_HouseNo']?.toString() ?? "";
    hoLaneController.text = data['HO_Lane']?.toString() ?? "";
    hoLocalityController.text = data['HO_Locality']?.toString() ?? "";
    hoPincodeController.text = data['HO_PinCode']?.toString() ?? "";
    hoTelNoController.text = data['HO_TelNo']?.toString() ?? "";
    hoEmailController.text = data['HO_EMail']?.toString() ?? "";
    hoPanController.text = data['HO_PanNo']?.toString() ?? "";

    // -------- APPLICANT / OTHER DETAILS (4th SECTION) --------
    nicCodeController.text = data['NIC_Code']?.toString() ?? "";
    yearController.text = data['Year']?.toString() ?? "";
    ownershipController.text = data['Ownership']?.toString() ?? "";
    totalPersonController.text = data['Total_Person']?.toString() ?? "";
    actAuthorityRegController.text =
        data['ActAuthorityRegNo']?.toString() ?? "";

    applicantNameController.text =
        data['Applicant_Name']?.toString() ?? "";
    applicantMobileController.text =
        data['Applicant_No']?.toString() ?? "";
    applicantEmailController.text =
        data['Applicant_EMail']?.toString() ?? "";
    applicantAddressController.text =
        data['Applicant_Address']?.toString() ?? "";


    notifyListeners();
  }

  bool isEditable(TextEditingController controller) {
    return controller.text.isEmpty;
  }

  void submitEmpOTRForm(BuildContext context) {
    // TEMP: bypass API
    debugPrint("Emp OTR Form Submitted");
    debugPrint("SSO: ${ssoController.text}");
    debugPrint("Area: $areaType");

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Form saved successfully (mock)")),
    );
  }

  void validateGST(String value) {
    final gst = value.toUpperCase();

    gstLengthError =
    gst.length != 15 ? "GST Number must be exactly 15 characters." : null;

    gstFormatError = RegExp(
      r'^\d{2}[A-Z]{5}\d{4}[A-Z]{1}[A-Z\d]{1}Z[A-Z\d]{1}$',
    ).hasMatch(gst)
        ? null
        : "Enter valid GST Number (e.g. 27ABCDE1234F1Z5).";

    notifyListeners();
  }


  void clearData() {
    ssoController.clear();
    brnController.clear();
    districtController.clear();
    tehsilController.clear();
    localBodyController.clear();
    villageController.clear();
    wardController.clear();
    companyNameController.clear();
    houseNoController.clear();
    laneController.clear();
    localityController.clear();
    pinCodeController.clear();
    telNoController.clear();
    emailController.clear();
    gstController.clear();
    panController.clear();
    panHolderController.clear();
    panVerifiedController.clear();
    tanController.clear();

    organisationType = null;
    govtBody = null;
    industryType = null;

    // ---------- STATE ----------
    selectedState = null;
    stateController.clear();
    stateIdController.clear();

    // ---------- DISTRICT ----------
    selectedDistrict = null;
    districtHoController.clear();
    districtIdController.clear();
    districtList.clear();

    // ---------- CITY ----------
    selectedCity = null;
    cityHoController.clear();
    cityIdController.clear();
    locationList.clear();

    districtError = null;
    areaType = "";
    isAreaFromBRN = false;

    actEstList.clear();
    selectedActEst = null;

    sectorList.clear();
    selectedSector = null;
    sectorController.clear();


    notifyListeners();
  }

  void validateEmail(String value) {
    emailErrorText = null;
    if (value.isEmpty) return;
    if (!value.contains("@")) {
      emailErrorText = "Email must contain @";
    } else if (!value.isValidEmail()) {
      emailErrorText = "Invalid format";
    } else {
      emailErrorText = null; // ✅ clear error
    }
    notifyListeners();
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    final trimmed = trim();

    // Single @ check
    if (!trimmed.contains("@") ||
        trimmed.indexOf("@") != trimmed.lastIndexOf("@")) {
      return false;
    }

    // Full regex for username@domain.tld
    return RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(trimmed);
  }
}

extension PanCardValidator on String {
  bool isValidPanCardNo() {
    return RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$').hasMatch(this);
  }
}

extension TanValidator on String {
  bool isValidTan() {
    return RegExp(r'^[A-Z]{4}[0-9]{5}[A-Z]{1}$').hasMatch(this);
  }
}
