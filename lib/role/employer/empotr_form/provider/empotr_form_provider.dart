import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/global.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/right_to_left_route.dart';
import '../../../../utils/user_new.dart';
import '../../../../utils/utility_class.dart';
import '../../employerdashboard/employer_dashboard.dart';
import '../modal/actEstablishment_modal.dart';
import '../modal/city_modal.dart';
import '../modal/district_modal.dart';
import '../modal/document_master_modal.dart';
import '../modal/sector_modal.dart';
import '../modal/state_modal.dart';
import '../modal/upload_document_modal.dart';
import 'package:http_parser/http_parser.dart';


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


  bool districtPrefilled = false;
  bool pinCodePrefilled = false;
  bool emailPrefilled = false;
  bool panPrefilled = false;
  bool tanPrefilled = false;

  bool hoEmailPrefilled = false;
  bool hoPanPrefilled = false;
  bool applicantEmailPrefilled = false;



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

  bool get showGovtBody {
    if (organisationType == null) return true;
    return organisationType == "Government" || organisationType == "PSU";
  }

  bool get showActEst {
    if (organisationType == null) return true;
    return organisationType == "Private" || organisationType == "PSU";
  }



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
  File? panCertificateController;
  File? tanCertificateController;
  File? gstCertificateController;
  File? logoController;

  String panFilePath = "";
  String tanFilePath = "";
  String gstFilePath = "";
  String logoFilePath = "";





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

    // Reset dependent fields
    govtBody = null;
    selectedActEst = null;

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

  Future<void> pickAndUploadImage({
    required BuildContext context,
    required int documentMasterId,
    required List<String> allowedExtensions,
    required Function(File file) onFileSelected,
    required Function(String filePath, String fileName) onUploadSuccess,
  }) async {
    showImagePicker(context, (pickedImage) async {
      if (pickedImage == null) return;

      final ext = pickedImage.path.split('.').last.toLowerCase();

      // ✅ File type validation (DYNAMIC)
      if (!allowedExtensions.contains(ext)) {
        showAlertError(
          "Allowed file types: ${allowedExtensions.join(', ').toUpperCase()}",
          context,
        );
        return;
      }

      final file = File(pickedImage.path);

      // ✅ Size validation (25 KB)
      final fileSizeInKB = (await file.length()) / 1024;
      if (fileSizeInKB > 50) {
        showAlertError(
          "File size must be less than 50 KB",
          context,
        );
        return;
      }

      // ✅ Show preview immediately
      onFileSelected(file);
      notifyListeners();

      try {
        String timestamp =
            "${DateTime.now().millisecondsSinceEpoch}.$ext";



        FormData param = FormData.fromMap({
          "file": await MultipartFile.fromFile(
            file.path,
            filename: timestamp,
            contentType: MediaType("image", ext),
          ),
          "FileExtension": "image/$ext",
          "FolderName": "Employer/OTRDocument",
          "MaxFileSize": "51200", // 50 KB
          "MinFileSize": "0",
          "Password": "",
        });

        final res = await uploadDocumentApi(context, param);

        if (res != null &&
            res.data != null &&
            res.data!.isNotEmpty) {
          final uploadedFileName = res.data![0].fileName ?? "";
          documentUploadedPathMap[documentMasterId] = uploadedFileName;

          debugPrint(
            "✅ Stored upload: DocId=$documentMasterId File=$uploadedFileName",
          );

          // ✅ Show preview ONLY after success
         // onFileSelected(file);

          onUploadSuccess(
            res.data![0].filePath ?? "",
            res.data![0].fileName ?? "",
          );

          notifyListeners();
        }

      } catch (e) {
        showAlertError(e.toString(), context);
      }
    });
  }


  List<DocumentMasterData> documentMasterList = [];

// store picked files against DocumentMasterId
  Map<int, File?> documentFileMap = {};
  Map<int, String?> documentUploadedPathMap = {};

  Future<void> fetchDocumentMastersApi(BuildContext context) async {
    final apiResponse =
    await commonRepo.get("Common/FetchDocumentMastersByScheme/0");

    if (apiResponse.response?.statusCode == 200) {
      var responseData = apiResponse.response?.data;
      if (responseData is String) {
        responseData = jsonDecode(responseData);
      }

        final modal = DocumentMasterModal.fromJson(responseData);

        documentMasterList.clear();

      if (modal.data != null) {
        for (final doc in modal.data!) {
          // ❌ EXCLUDE Job Description ONLY
          if (doc.shortName != "JobDescriptionDoc_ForGovtJobPost") {
            documentMasterList.add(doc);
          }
        }
      }

        notifyListeners();



    }
  }


  Future<void> pickAndUploadPdf({
    required BuildContext context,
    required int documentMasterId,
    required Function(File file) onFileSelected,
    required Function(String filePath, String fileName) onUploadSuccess,
  }) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return;

    final file = File(result.files.single.path!);

    // ✅ Size validation (25 KB)
    final sizeInKB = (await file.length()) / 1024;
    if (sizeInKB > 300) {
      showAlertError("File size must be less than 300 KB", context);
      return;
    }

    // ✅ Preview immediately
    onFileSelected(file);
    notifyListeners();

    String timestamp =
        "${DateTime.now().millisecondsSinceEpoch}.pdf";

    FormData param = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: timestamp,
        contentType: MediaType("application", "pdf"),
      ),
      // 👇 SAME AS POSTMAN
      "FileExtension": "application/pdf",
      "FolderName": "Employer/OTRDocument",
      "MaxFileSize": "307200",
      "MinFileSize": "0",
      "Password": "",
    });

    final res = await uploadDocumentApi(context, param);

    if (res != null &&
        res.data != null &&
        res.data!.isNotEmpty) {
      final uploadedFileName = res.data![0].fileName ?? "";
      documentUploadedPathMap[documentMasterId] = uploadedFileName;

      debugPrint(
        "✅ Stored upload: DocId=$documentMasterId File=$uploadedFileName",
      );

      onUploadSuccess(
        res.data![0].filePath ?? "",
        res.data![0].fileName ?? "",
      );
    }
  }



  Future<UploadDocumentModal?> uploadDocumentApi(
      BuildContext context, FormData inputText) async {

    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
      return null;
    }

    try {
      ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.uploadDocumentRepo(
        "Common/UploadDocument",
        inputText,
      );

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response != null &&
          apiResponse.response?.statusCode == 200) {

        var responseData = apiResponse.response?.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        return UploadDocumentModal.fromJson(responseData);
      } else {
        showAlertError("Something went wrong", context);
        return null;
      }
    } catch (e) {
      showAlertError(e.toString(), context);
      return null;
    }
  }


  Future<void> getExchangeOfficeByDistrict(
      BuildContext context,
      String districtName,
      ) async {
    try {
      Map<String, dynamic> body = {
        "DistrictName": districtName,
      };

      ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.post(
        "Common/GetExchangeNameOfficeListByDistrictName",
        body,
      );

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response != null &&
          apiResponse.response?.statusCode == 200) {
        var responseData = apiResponse.response?.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        // ✅ Safety check
        if (responseData != null &&
            responseData["State"] == 200 &&
            responseData["Data"] != null &&
            responseData["Data"].isNotEmpty) {

          // ✅ Take first office (as per API response)
          final officeName = responseData["Data"][0]["OfficeName"];

          exchangeNameController.text = officeName?.toString() ?? "";
        }
      } else {
        debugPrint("❌ Exchange Office API failed");
      }
    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      debugPrint("❌ Exchange Office Exception: $e");
    }

    notifyListeners();
  }


  void autoFillFromBRN(Map<String, dynamic> data) {
    // -------- BASIC DETAILS --------
    brnController.text = data['BRN']?.toString() ?? "";

    districtController.text = data['District']?.toString() ?? "";
    districtPrefilled = districtController.text.isNotEmpty;

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
    pinCodePrefilled = pinCodeController.text.isNotEmpty;

    emailController.text = data['BO_Email']?.toString() ?? "";
    emailPrefilled = emailController.text.isNotEmpty;

    panController.text = data['BO_PanNo']?.toString() ?? "";
    panPrefilled = panController.text.isNotEmpty;

    panVerifiedController.text = data['BO_PanNo']?.toString() ?? "";

    tanController.text = data['BO_TanNo']?.toString() ?? "";
    tanPrefilled = tanController.text.isNotEmpty;

    // -------- HEAD OFFICE DETAILS (3rd SECTION) --------
    hoCompanyNameController.text = data['HO_Name']?.toString() ?? "";
    hoHouseNoController.text = data['HO_HouseNo']?.toString() ?? "";
    hoLaneController.text = data['HO_Lane']?.toString() ?? "";
    hoLocalityController.text = data['HO_Locality']?.toString() ?? "";
    hoPincodeController.text = data['HO_PinCode']?.toString() ?? "";
    hoTelNoController.text = data['HO_TelNo']?.toString() ?? "";

    hoEmailController.text = data['HO_EMail']?.toString() ?? "";
    hoEmailPrefilled = hoEmailController.text.isNotEmpty;

    hoPanController.text = data['HO_PanNo']?.toString() ?? "";
    hoPanPrefilled = hoPanController.text.isNotEmpty;


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
    applicantEmailPrefilled = applicantEmailController.text.isNotEmpty;

    applicantAddressController.text =
        data['Applicant_Address']?.toString() ?? "";


    notifyListeners();
  }

  bool isEditable(TextEditingController controller) {
    return controller.text.isEmpty;
  }

  Future<void> submitEmpOTRForm(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
        AppLocalizations.of(context)!.internet_connection,
        context,
      );
      return;
    }

    try {
      String? ipAddress = await UtilityClass.getIpAddress();

      /// 🔹 Employer document list (DYNAMIC)
      List<Map<String, dynamic>> employerDocs = [];

      debugPrint("📄 documentMasterList length: ${documentMasterList.length}");

      for (final doc in documentMasterList) {
        debugPrint(
          "➡️ DocId: ${doc.documentMasterId}, "
              "ShortName: ${doc.shortName}, "
              "SchemeID: ${doc.schemeID}",
        );
      }

      for (final doc in documentMasterList) {
        final uploadedFileName =
        documentUploadedPathMap[doc.documentMasterId];

        if (uploadedFileName != null && uploadedFileName.isNotEmpty) {
          employerDocs.add({
            "SchemeID": doc.schemeID ?? 0,
            "DocumentMasterId": doc.documentMasterId ?? 0,
            "FileName": uploadedFileName,
          });
        }
      }

      debugPrint("📂 documentUploadedPathMap111:");
      documentUploadedPathMap.forEach((key, value) {
        debugPrint("   DocId: $key  => FileName: $value");
      });


      String logoFileName = "";
      for (final doc in documentMasterList) {
        if (doc.shortName == "Logo") {
          logoFileName =
              documentUploadedPathMap[doc.documentMasterId] ?? "";
          break;
        }
      }

      debugPrint("📂 documentUploadedPathMap222:");
      documentUploadedPathMap.forEach((key, value) {
        debugPrint("   DocId: $key  => FileName: $value");
      });

      debugPrint("🧾 employerDocs length: ${employerDocs.length}");

      for (final doc in employerDocs) {
        debugPrint(doc.toString());
      }

      // OLD parameters which was also working and give successfull message
      // Map<String, dynamic> data = {
      //   "ActionName": "InsertData",
      //   "SSOID": ssoController.text,
      //   "UserId": UserData().model.value.userId.toString(),
      //   "IsActive": 1,
      //   "IPAddress": ipAddress ?? "",
      //   "IPAddressv6": "::1",
      //
      //   "Sector": selectedSector?.iD.toString() ?? "0",
      //   "ROCity": "",
      //   "RODistrict": "",
      //   "ROPinCode": "",
      //   "ROContactNumber": "",
      //   "ROPhone": "",
      //
      //   "BRN": brnController.text,
      //   "Area": areaType,
      //   "District": districtController.text,
      //   "Tehsil": tehsilController.text,
      //   "Village": "",
      //   "LocalBody": localBodyController.text,
      //   "Ward": wardController.text,
      //
      //   "OrganizationType": organisationType ?? "",
      //   "Ownership": ownershipController.text,
      //   "NIC_Code": nicCodeController.text,
      //   "IndustryType": industryType ?? "",
      //
      //   "Website": websiteController.text,
      //   "ExchangeName": exchangeNameController.text,
      //   "GovernmentBody":
      //   organisationType == "Government" || organisationType == "PSU"
      //       ? govtBody ?? ""
      //       : "",
      //
      //   "HO_Name": hoCompanyNameController.text,
      //   "HO_HouseNo": hoHouseNoController.text,
      //   "HO_Lane": hoLaneController.text,
      //   "HO_Locality": hoLocalityController.text,
      //   "HO_PinCode": hoPincodeController.text,
      //   "HO_Phone": hoTelNoController.text,
      //   "HO_Email": hoEmailController.text,
      //   "HO_PanNo": hoPanController.text,
      //   "HO_TanNo": "",
      //   "HOStateId": int.tryParse(stateIdController.text) ?? 0,
      //   "HODistrictId": int.tryParse(districtIdController.text) ?? 0,
      //   "HOCityId": int.tryParse(cityIdController.text) ?? 0,
      //
      //   "Branch_Name": companyNameController.text,
      //   "Branch_HouseNumber": houseNoController.text,
      //   "Branch_Lane": laneController.text,
      //   "Branch_Locality": localityController.text,
      //   "Branch_Email": emailController.text,
      //   "Branch_PANHolder": panHolderController.text,
      //   "Branch_PANVerified": panVerifiedController.text,
      //   "Branch_Pincode": pinCodeController.text,
      //   "Branch_TANNumber": tanController.text,
      //
      //   "Applicant_Name": applicantNameController.text,
      //   "Applicant_No": applicantMobileController.text,
      //   "Applicant_Email": applicantEmailController.text,
      //   "Applicant_Address": applicantAddressController.text,
      //
      //   "Contact_AadharNumber": "",
      //   "Contact_FirstName": contactNameController.text,
      //   "Contact_LastName": "",
      //   "Contact_MobileNumber": contactMobileController.text,
      //   "Contact_AlternateMobileNumber": contactAltMobileController.text,
      //   "Contact_Email": contactEmailController.text,
      //   "Contact_PAN_No": contactPanController.text,
      //   "Contact_State": int.tryParse(coStateIdController.text) ?? 0,
      //   "Contact_District": int.tryParse(coDistrictIdController.text) ?? 0,
      //   "Contact_City": int.tryParse(coCityIdController.text) ?? 0,
      //   "Contact_Pincode": contactPincodeController.text,
      //   "Contact_Address": contactAddressController.text,
      //   "Contact_Designation": contactDesignationController.text,
      //   "Contact_Department": contactDepartmentController.text,
      //
      //   "DocGSTNumber": "",
      //   "DocPANNumber": "",
      //   "DocTANNumber": "",
      //   "DocEPFNumber": "",
      //   "DocESINumber": "",
      //   "RegistrationNumber": "",
      //   "ActEstablishment":
      //   organisationType == "Private" || organisationType == "PSU"
      //       ? selectedActEst?.actEstablishment ?? ""
      //       : "",
      //   "ActAuthorityRegNo": "NA",
      //
      //   "NumberOfMaleEmployees":
      //   int.tryParse(noOfMaleEmpController.text) ?? 0,
      //   "NumberOfFemaleEmployees":
      //   int.tryParse(noOfFemaleEmpController.text) ?? 0,
      //   "NumberOfTransgenderEmployees":
      //   int.tryParse(noOfTransEmpController.text) ?? 0,
      //   "TotalNumberOfEmployees":
      //   int.tryParse(noOfTotalEmpController.text) ?? 0,
      //
      //   "EMIP_Sector": "",
      //   "Total_Person": 0,
      //   "Year": DateTime.now().year.toString(),
      //
      //   "LogoFileName": logoFileName,
      //   "EmployerDocumentList": employerDocs,
      // };

      // NEW parameters get from Amit Tripathi which is also working and give successfull message
      /// 🔹 MAIN REQUEST BODY
      Map<String, dynamic> data = {
        "ActionName": "InsertData",
        "SSOID": ssoController.text,
        "UserId": 0,
        "ID": 0,
        "Sector": selectedSector?.iD.toString() ?? "0",
        "ROCity": "",
        "RODistrict": 0,
        "ROPinCode": "",
        "ROContactNumber": "",
        "ROPhone": "",
        // "IPAddress": ipAddress ?? "",
        // "IPAddressv6": "::1",
        "BRN": brnController.text,
        "Area": areaType,
        "District": districtController.text,
        "Tehsil": tehsilController.text,
        "Village": villageController.text,
        "LocalBody": localBodyController.text,
        "Ward": wardController.text,
        "NCSID": "",
        "OrganizationName": "",
        "OrganizationCategory": "",
        "OrganizationType": organisationType ?? "",
        "Description": "",
        "HOState": stateNameController.text,
        "HOCity": locationNameController.text,
        "HODistrict": districtNameController.text,
        "HOSubdistrict": "",
        "HOAddress": "",
        "HOPinCode": hoPincodeController.text,
        "HOPhone": hoTelNoController.text,
        "HOCompanyEmail": hoEmailController.text,
        "HOAlterEmail": "",
        "Website": websiteController.text,
        "ROAddress": "",
        "DocPANNumber": "",
        "DocTANNumber": "",
        "DocGSTNumber": "27ABCDE1234F1Z2",
        "DocEPFNumber": "",
        "DocESINumber": "",
        "DocRegNumber": "",
        "DocUdyogNumber": "",
        "DocCertificateNumber": "",
        "DocAdditionalDetails": "",
        "Branch_Name": companyNameController.text,
        "Branch_HouseNumber": houseNoController.text,
        "Branch_Lane": laneController.text,
        "Branch_Locality": localityController.text,
        "Branch_Email": emailController.text,
        "Branch_PANHolder": panHolderController.text,
        "Branch_TANNumber": tanController.text,
        "Branch_Pincode": pinCodeController.text,
        "Branch_PANVerified": panVerifiedController.text,
        "Head_Name": hoCompanyNameController.text,
        "Head_HouseNumber": hoHouseNoController.text,
        "Head_Lane": hoLaneController.text,
        "Head_Locality": hoLocalityController.text,
        "Head_Pincode": hoPincodeController.text,
        "Head_TANNumber": "",
        "Applicant_Name": applicantNameController.text,
        "Applicant_No": applicantMobileController.text,
        "Applicant_Email": applicantEmailController.text,
        "Applicant_Address": applicantAddressController.text,
        "Total_Person": 7,
        "Year": yearController.text.trim(), //DateTime.now().year.toString(),
        "Ownership": ownershipController.text,
        "NIC_Code": nicCodeController.text,
        "HOApp_City": cityHoController.text,
        "HOApp_Email": applicantEmailController.text,
        "HOApp_Website": websiteController.text,
        "HOApp_State": stateController.text,

        "Contact_AadharNumber": "",
        "Contact_FirstName": contactNameController.text,
        "Contact_LastName": "",
        "Contact_MobileNumber": contactMobileController.text,
        "Contact_AlternateMobileNumber": contactAltMobileController.text,
        "Contact_Email": contactEmailController.text,
        "Contact_State": int.tryParse(coStateIdController.text) ?? 0,
        "Contact_District": int.tryParse(coDistrictIdController.text) ?? 0,
        "Contact_City": int.tryParse(coCityIdController.text) ?? 0,
        "Contact_Pincode": contactPincodeController.text,
        "Contact_Address": contactAddressController.text,
        "Contact_Designation": contactDesignationController.text,
        "Contact_Department": contactDepartmentController.text,
        "Contact_UploadIDCard": "",
        "ExchangeName": exchangeNameController.text,
        "GovernmentBody":
        organisationType == "Government" || organisationType == "PSU"
            ? govtBody ?? ""
            : "",
        "NumberOfMaleEmployees":
        int.tryParse(noOfMaleEmpController.text) ?? 0,
        "NumberOfFemaleEmployees":
        int.tryParse(noOfFemaleEmpController.text) ?? 0,
        "NumberOfTransgenderEmployees":
        int.tryParse(noOfTransEmpController.text) ?? 0,
        "TotalNumberOfEmployees":
        int.tryParse(noOfTotalEmpController.text) ?? 0,
        "ActEstablishment":
        organisationType == "Private" || organisationType == "PSU"
            ? selectedActEst?.actEstablishment ?? ""
            : "",
        "IndustryType": industryType ?? "",
        "EMIP_Sector": "",
        "RegistrationNumber": "",
        "ActAuthorityRegNo": actAuthorityRegController.text,
        "HO_PanNo": hoPanController.text,
        "HO_TanNo": "",
        "BO_TelNo": telNoController.text,
        "LogofileName": logoFileName,
        "HO_ApplicationEmail": applicantEmailController.text,
        "HOStateId": int.tryParse(stateIdController.text) ?? 0,
        "HODistrictId": int.tryParse(districtIdController.text) ?? 0,
        "HOCityId": int.tryParse(cityIdController.text) ?? 0,
        "Contact_PAN_No": contactPanController.text,
        "IsActive": true,
        "EmployerDocumentList": employerDocs,
      };

      printFullJson(data);

     // return null;
      ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.post(
        "Employer/SaveEmployerDetail",
        data,
      );

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response != null &&
          apiResponse.response?.statusCode == 200) {

        var responseData = apiResponse.response?.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        final int state = responseData["State"] ?? 0;
        final bool status = responseData["Status"] ?? false;
        final String? message = responseData["Message"];
        final String? errorMessage = responseData["ErrorMessage"];

        // ✅ SUCCESS CASE
        if (state == 200 && status == false) {
          successDialog(
            context,
            message ?? "Employer details saved successfully",
                (_) {
              Navigator.of(context).push(
                RightToLeftRoute(
                  page: const EmployerDashboard(),
                  duration: const Duration(milliseconds: 500),
                  startOffset: const Offset(-1.0, 0.0),
                ),
              );
            },
          );
        }
        // ⚠️ RECORD ALREADY EXISTS
        else if (state == 3) {
          showAlertError(
            message ?? "Record already exists!",
            context,
          );
        }
        // ❌ SERVER / SQL / NULL REFERENCE ERROR
        else {
          showAlertError(
            errorMessage ??
                message ??
                "Something went wrong. Please try again.",
            context,
          );
        }
      } else {
        ProgressDialog.closeLoadingDialog(context);
        showAlertError("Server error. Please try again.", context);
      }
    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
    }
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
    emailErrorText = null;
    panErrorText = null;

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

    hoCompanyNameController.clear();
    hoTelNoController.clear();
    hoEmailController.clear();
    hoPanController.clear();
    panErrorText = null;
    hoHouseNoController.clear();
    hoLaneController.clear();
    hoLocalityController.clear();
    hoPincodeController.clear();

    applicantNameController.clear();
    applicantMobileController.clear();
    applicantEmailController.clear();
    applicantEmailError = null;
    yearController.clear();
    ownershipController.clear();
    totalPersonController.clear();
    actAuthorityRegController.clear();
    tanNoController.clear();
    hoTanErrorText = null;
    hoApplicantEmailController.clear();
    hoApplicantEmailError = null;
    websiteController.clear();
    applicantAddressController.clear();
    nicCodeController.clear();

    contactPanController.clear();
    contactPanError = null;
    contactNameController.clear();
    contactMobileController.clear();
    contactAltMobileController.clear();
    contactAlterMobileError = null;
    contactEmailController.clear();
    contactEmailError = null;
    contactDesignationController.clear();
    contactDepartmentController.clear();
    contactPincodeController.clear();
    contactAddressController.clear();

    exchangeNameController.clear();

    noOfMaleEmpController.clear();
    noOfFemaleEmpController.clear();
    noOfTransEmpController.clear();
    noOfTotalEmpController.clear();


    coStateController.clear();
    coStateIdController.clear();
    coSelectedState = null;

    coDistrictController.clear();
    coDistrictIdController.clear();
    coSelectedDistrict = null;

    coCityController.clear();
    coCityIdController.clear();
    coSelectedCity = null;

    districtPrefilled = false;
    pinCodePrefilled = false;
    emailPrefilled = false;
    panPrefilled = false;
    tanPrefilled = false;

    hoEmailPrefilled = false;
    hoPanPrefilled = false;
    applicantEmailPrefilled = false;

    panCertificateController = null;
    tanCertificateController = null;
    gstCertificateController = null;
    logoController = null;

    // 🔹 IMPORTANT: clear uploaded docs
    documentFileMap.clear();
    documentUploadedPathMap.clear();

    // 🔹 optional but safe
    documentMasterList.clear();

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

void printFullJson(Map<String, dynamic> json) {
  const encoder = JsonEncoder.withIndent('  ');
  final prettyString = encoder.convert(json);
  prettyString.split('\n').forEach((line) => debugPrint(line));
}