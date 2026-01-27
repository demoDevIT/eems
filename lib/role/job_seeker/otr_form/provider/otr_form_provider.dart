import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/role/job_seeker/addeducationaldetail/modal/board_modal.dart';
import 'package:rajemployment/role/job_seeker/addeducationaldetail/modal/course_nature.dart';
import 'package:rajemployment/role/job_seeker/addeducationaldetail/modal/grade_type.dart';
import 'package:rajemployment/role/job_seeker/addeducationaldetail/modal/passing_year_modal.dart';
import 'package:rajemployment/role/job_seeker/addeducationaldetail/modal/stream_type_modal.dart';
import 'package:rajemployment/role/job_seeker/addeducationaldetail/modal/university_modal.dart';
import 'package:rajemployment/role/job_seeker/jobseekerdashboard/job_seeker_dashboard.dart';
import 'package:rajemployment/role/job_seeker/otr_form/modal/otr_jan_aadhar_detail_modal.dart';
import 'package:rajemployment/role/job_seeker/otr_form/modal/religion_modal.dart';
import 'package:rajemployment/role/job_seeker/otr_form/modal/uid_type_modal.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';
import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/app_shared_prefrence.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/right_to_left_route.dart';
import '../../../../utils/utility_class.dart';
import '../../add_language_skills/modal/category_type_details_modal.dart';
import '../../add_language_skills/modal/get_sub_category_type_details_modal.dart';
import '../../add_language_skills/modal/proficiency_type_modal.dart';
import '../../add_language_skills/modal/upload_document_modal.dart';
import '../../addjobpreference/modal/language_type_modal.dart';
import '../../addjobpreference/modal/region_modal.dart';
import '../../addressinfo/modal/address_info_modal.dart';
import '../../addressinfo/modal/assembly_list_modal.dart';
import '../../addressinfo/modal/city_modal.dart';
import '../../addressinfo/modal/communication_address_info_modal.dart';
import '../../addressinfo/modal/district_modal.dart';
import '../../addressinfo/modal/parliament_list_modal.dart';
import '../../addressinfo/modal/save_data_address_modal.dart';
import '../../addressinfo/modal/ward_modal.dart';
import '../../addworkexperience/modal/employment_type_modal.dart';
import '../../educationdetail/modal/profile_qualication_info_list_modal.dart';
import '../../loginscreen/modal/jobseeker_basicInfo_modal.dart';
import '../../loginscreen/screen/login_screen.dart';
import '../modal/education_level_modal.dart';
import '../modal/fetch_jan_adhar_modal.dart';
import '../modal/graduation_type_modal.dart';
import '../modal/language_list_modal.dart';
import '../modal/medium_type_modal.dart';
import '../modal/nco_code_modal.dart';
import '../modal/save_data_education_modal.dart';
import '../modal/verify_registration_otp_modal.dart';

class OtrFormProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  OtrFormProvider({required this.commonRepo});

  String? uidErrorText;
  String? emailErrorText;

  final formKey = GlobalKey<FormState>();

  final TextEditingController ssoIDController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNOController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController maritalStatusController = TextEditingController();
  final TextEditingController castController = TextEditingController();
  final TextEditingController aadhaarRefNOController = TextEditingController();
  final TextEditingController minorityController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController religionOtherNameController =
      TextEditingController();
  final TextEditingController religionNameController = TextEditingController();
  final TextEditingController religionIdController = TextEditingController();
  final TextEditingController differentlyAbledController =
      TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController familyIncomeController = TextEditingController();
  final TextEditingController uidTypeIdController = TextEditingController();
  final TextEditingController uidTypeNameController = TextEditingController();
  final TextEditingController uidNOController = TextEditingController();
  final TextEditingController linkedinController = TextEditingController();
  List<ReligionData> religionList = [];
  List<UIDTypeData> uidTypeList = [];
  String? selectedUIDTypeData;

  String filePath = "";
  String fileName = "";
  XFile? profileFile;

  //address

  String territoryType = "Urban";
  String territoryTypeID = "2";
  String cTerritoryType = "Urban";
  String cTerritoryTypeID = "2";
  bool sameAsAbove = false;
  List<DistrictData> districtList = [];
  List<DistrictData> cDistrictList = [];
  List<CityData> cityList = [];
  List<CityData> cCityList = [];
  List<WardData> wardList = [];
  List<WardData> cWardList = [];
  List<AssemblyListData> assemblyList = [];
  List<ParliamentListData> parliamentListDataList = [];
  List<AddressInfoData> addressInfoList = [];
  List<CommunicationAddressInfoData> communicationAddressInfoList = [];
  final TextEditingController districtNameController = TextEditingController();
  final TextEditingController districtIdController = TextEditingController();
  final TextEditingController cityNameController = TextEditingController();
  final TextEditingController cityIdController = TextEditingController();
  final TextEditingController wardNameController = TextEditingController();
  final TextEditingController wardIdController = TextEditingController();
  final TextEditingController cDistrictNameController = TextEditingController();
  final TextEditingController cDistrictIdController = TextEditingController();
  final TextEditingController cCityNameController = TextEditingController();
  final TextEditingController cCityIdController = TextEditingController();
  final TextEditingController cWardNameController = TextEditingController();
  final TextEditingController cWardIdController = TextEditingController();
  final TextEditingController assemblyNameController = TextEditingController();
  final TextEditingController assemblyIDController = TextEditingController();
  final TextEditingController constituencyNameController =
      TextEditingController();
  final TextEditingController constituencyIDController =
      TextEditingController();
  final TextEditingController addressController =
      TextEditingController(text: "");
  final TextEditingController cAddressController = TextEditingController(
    text: "",
  );
  final TextEditingController cPinCodeController =
      TextEditingController(text: "");
  final TextEditingController pinCodeController =
      TextEditingController(text: "");
  final TextEditingController exchangeDistrictIdController =
      TextEditingController(text: "");
  final TextEditingController exchangeDistrictNameController = TextEditingController();
  final TextEditingController exchangeNameController =
      TextEditingController(text: "");

  //Education
  String resultType = 'Percentage';

  List<EducationLevelData> educationLevelsList = [];
  List<NcoCodeData> ncoCodeList = [];
  List<GraduationTypeData> graduationTypeList = [];
  List<GraduationTypeData> classList = [];
  List<BoardData> boardList = [];
  List<UniversityData> universityList = [];
  List<CourseNatureData> courseNatureList = [];
  List<MediumTypeData> mediumTypeList = [];
  List<PassingYearData> passingYearList = [];
  List<StreamTypeData> streamTypeList = [];
  List<GradeTypeData> gradeTypeList = [];

  final TextEditingController educationLevelIdController =
      TextEditingController();
  final TextEditingController educationLevelNameController =
      TextEditingController();
  final TextEditingController classIdController = TextEditingController();
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController ncoCodeIdController = TextEditingController();
  final TextEditingController ncoCodeNameController = TextEditingController();
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController mediumEducationIdController =
      TextEditingController();
  final TextEditingController mediumEducationNameController =
      TextEditingController();
  final TextEditingController natureOfCourseIdController =
      TextEditingController();
  final TextEditingController natureOfCourseNameController =
      TextEditingController();
  final TextEditingController yearOfPassingIdController =
      TextEditingController();
  final TextEditingController yearOfPassingNameController =
      TextEditingController();
  final TextEditingController boardIdController = TextEditingController();
  final TextEditingController boardNameController = TextEditingController();
  final TextEditingController streamIdController = TextEditingController();
  final TextEditingController streamNameController = TextEditingController();
  final TextEditingController graduationTypeIdController =
      TextEditingController();
  final TextEditingController graduationTypeNameController =
      TextEditingController();
  final TextEditingController universityIdController = TextEditingController();
  final TextEditingController universityNameController =
      TextEditingController();
  final TextEditingController collageIdController = TextEditingController();
  final TextEditingController collageNameController = TextEditingController();
  final TextEditingController gradeTypeIdController = TextEditingController();
  final TextEditingController gradeTypeNameController = TextEditingController();
  final TextEditingController otherMediumEducationController =
      TextEditingController();
  final TextEditingController otherGraduationTypeController =
      TextEditingController();
  final TextEditingController otherEducationUniversity =
      TextEditingController();
  final TextEditingController otpController = TextEditingController();

  //work experience

  List<WorkExpEmploymentTypeData> employmentTypesList = [];
  List<WorkExpEmploymentTypeData> originalEmploymentTypesList = [];
  List<RegionData> preferredRegionList = [];

  final TextEditingController currentEmploymentStatusIdController =
      TextEditingController();
  final TextEditingController currentEmploymentStatusNameController =
      TextEditingController();
  final TextEditingController areYouInterestedInternational =
      TextEditingController(text: "No");
  final TextEditingController expYearController = TextEditingController();
  final TextEditingController expMonthController = TextEditingController();
  final TextEditingController regionIdController = TextEditingController();
  final TextEditingController regionNameController = TextEditingController();

  //Add Skills and language

  final TextEditingController categoryIdController = TextEditingController();
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController subCategoryIdController = TextEditingController();
  final TextEditingController subCategoryNameController =
      TextEditingController();
  List<GetCategoryTypeDetailsData> categoryList = [];
  List<GetSubCategoryTypeDetailsData> subCategoryList = [];

  final TextEditingController areYouSkilledController = TextEditingController();
  final TextEditingController areYouInterestedRsldcIdController =
      TextEditingController();
  final TextEditingController areYouInterestedRsldcNameController =
      TextEditingController();
  final TextEditingController languageNameController = TextEditingController();
  final TextEditingController languageIdController = TextEditingController();
  final TextEditingController proficiencyNameController =
      TextEditingController();
  final TextEditingController proficiencyIdController = TextEditingController();

  List<ProficiencyTypeData> proficiencyTypeList = [];
  List<LanguageTypeData> languageKnownList = [];
  List<LanguageListData> languageDataList = [];
  bool read = false;
  bool write = false;
  bool speak = false;

  Future<ReligionModal?> religionApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "Common/CommonMasterDataByCode/Religion/0";
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
        //ProgressDialog.closeLoadingDialog(context);
        print("religionList ${apiResponse.response}");
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = ReligionModal.fromJson(responseData);
          if (sm.state == 200) {
            religionList.clear();
            religionList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm =
                ReligionModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return ReligionModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = ReligionModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<UIDTypeModal?> uidTypeApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "Common/CommonMasterDataByCode/UIDType/0";
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
        //ProgressDialog.closeLoadingDialog(context);
        print("uidTypeApi ${apiResponse.response}");
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = UIDTypeModal.fromJson(responseData);
          if (sm.state == 200) {
            uidTypeList.clear();
            uidTypeList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = UIDTypeModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return UIDTypeModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = UIDTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<DistrictModal?> getDistrictMasterApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse =
            await commonRepo.get("Common/GetDistrictMaster");
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = DistrictModal.fromJson(responseData);

          if (sm.state == 200) {
            districtList.clear();
            cDistrictList.clear();
            districtList.addAll(sm.data!);
            cDistrictList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm =
                DistrictModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return DistrictModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = DistrictModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<CityModal?> getCityMasterApi(
      BuildContext context, String districtId, bool isCommunication) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "Common/GetCityMaster/$districtId";
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = CityModal.fromJson(responseData);
          if (sm.state == 200) {
            if (isCommunication == false) {
              cityList.clear();
              cityList.addAll(sm.data!);
            } else {
              cCityList.clear();
              cCityList.addAll(sm.data!);
            }

            notifyListeners();
            return sm;
          } else {
            final smmm = CityModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return CityModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = CityModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<WardModal?> getWardMasterApi(
      BuildContext context, String cityId, bool isCommunication) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "Common/GetWardMaster/$cityId";
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
        //ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = WardModal.fromJson(responseData);
          if (sm.state == 200) {
            if (isCommunication == false) {
              wardList.clear();
              wardList.addAll(sm.data!);
            } else {
              cWardList.clear();
              cWardList.addAll(sm.data!);
            }

            notifyListeners();
            return sm;
          } else {
            final smmm = WardModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return WardModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = WardModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<AssemblyListModal?> assemblyListApi(
      BuildContext context, String districtId) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "Common/GetAssemblyListByDistrictID/$districtId";
        //ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
        //ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = AssemblyListModal.fromJson(responseData);
          if (sm.state == 200) {
            assemblyList.clear();
            assemblyList.addAll(sm.data!);

            notifyListeners();
            return sm;
          } else {
            final smmm =
                AssemblyListModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return AssemblyListModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = AssemblyListModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<ParliamentListModal?> getParliamentListApi(
      BuildContext context, String assemblyId, String districtId) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "Common/GetParliamentByAssemblyId/$assemblyId/$districtId";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = ParliamentListModal.fromJson(responseData);
          if (sm.state == 200) {
            parliamentListDataList.clear();
            parliamentListDataList.addAll(sm.data!);

            notifyListeners();
            return sm;
          } else {
            final smmm =
                ParliamentListModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return ParliamentListModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = ParliamentListModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  String prettyPrintJson(Map<String, dynamic> json) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  void setJanAadhaarControllers(BuildContext context, FetchJanAdharResponseData data, String ssoID) {
    print("ssoId-->" + ssoID);
    print("data.dOB1111-->" + data.dOB);
  //  print("data.district code-->" + data.dISTRICTCD);
    debugPrint("kjhfksdjfsjdfh" + jsonEncode(data.toJson()), wrapWidth: 1024);


    ssoIDController.text = ssoID;
    nameController.text = data.nAMEEN ?? "";
    fullNameController.text = data.nAMEEN ?? "";
    mobileNOController.text = data.mOBILENO?.toString() ?? "";
    mobileNumberController.text = data.mOBILENO?.toString() ?? "";
    dateOfBirthController.text = data.dOB ?? "";
    print("dateOfBirthController.text22222-->" + dateOfBirthController.text);
    fatherNameController.text = data.fATHERNAMEEN ?? "";
    maritalStatusController.text = data.mARITALSTATUS ?? "";
    castController.text = data.cATEGORYDESCENG ?? "";
    aadhaarRefNOController.text = maskAadhaarRef(data.aADHARREFID?.toString()) ?? "";
    minorityController.text = data.iSMINORITY.toString() == "N" ? "No" : "Yes";
    emailController.text = data.eMAIL ?? "";
    religionNameController.text = "";
    religionIdController.text = "";
    differentlyAbledController.text = data.dISABILITYTYPE ?? "";
    genderController.text = data.gENDER == "MALE"
        ? "Male"
        : data.gENDER == "FEMALE"
            ? "Female"
            : "TransGender";
    familyIncomeController.text = ""; // No field available in model
    uidTypeIdController.text = "";
    uidTypeNameController.text = "";
    uidNOController.text = "";
    linkedinController.text = "";
    districtNameController.text = data.dISTRICT?.toString() ?? "";
    districtIdController.text = data.dISTRICTCD?.toString() ?? "";

    exchangeDistrictNameController.text = data.dISTRICT?.toString() ?? "";

    // Call API to get Exchange Name
    if (data.dISTRICTCD != null) {
      fetchExchangeNameByDistrict(context, data.dISTRICTCD.toString());
    }

    cityIdController.text = data.bLOCKCITYCD?.toString() ?? "";
    cityNameController.text = data.bLOCKCITY?.toString() ?? "";
    wardIdController.text = data.gPWARDCD?.toString() ?? "";
    wardNameController.text = data.wARDLL?.toString() ?? "";
    addressController.text = data.aDDRESS?.toString() ?? "";
    pinCodeController.text = data.pINCODE?.toString() ?? "";
    notifyListeners();
  }

  Future<void> fetchExchangeNameByDistrict(
      BuildContext context,
      String districtCd,
      ) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
      return;
    }

    try {
     // ProgressDialog.showLoadingDialog(context);

      Map<String, dynamic> body = {
        "disability": "",
        "gender": "",
        "districtCd": districtCd,
      };

      ApiResponse apiResponse = await commonRepo.post(
        "Common/GetExchangeNameOfficeList",
        body,
      );

      // ✅ ALWAYS close loader once response is received
      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response != null &&
          apiResponse.response?.statusCode == 200) {
        var responseData = apiResponse.response?.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        if (responseData["State"] == 200 &&
            responseData["Data"] != null &&
            (responseData["Data"] as List).isNotEmpty) {

          String officeName =
              responseData["Data"][0]["OfficeName"] ?? "";

          exchangeNameController.text = officeName;
          notifyListeners();
        } else {
          exchangeNameController.text = "";
          notifyListeners();
        }
      } else {
        showAlertError("Something went wrong", context);
      }
    } catch (e) {
      // ✅ ALWAYS close loader in catch as well
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
    }
  }



  String maskAadhaarRef(String? value) {
    if (value == null || value.length < 4) return "";

    final lastFour = value.substring(value.length - 4);
    final maskedPart = '*' * (value.length - 4);

    return maskedPart + lastFour;
  }


  Future<EducationLevelModal?> educationLevelApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //.showLoadingDialog(context);
        ApiResponse apiResponse =
            await commonRepo.get("Common/GetQualificationList");
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = EducationLevelModal.fromJson(responseData);

          if (sm.state == 200) {
            educationLevelsList.clear();
            educationLevelsList.addAll(sm.data!);
            for (var item in educationLevelsList) {
              item.name = item.qualificationHI
                  ?.replaceAll(RegExp(r'[\r\n]+'), '')
                  .trim();
              item.qualificationHI = item.qualificationHI
                  ?.replaceAll(RegExp(r'[\r\n]+'), '')
                  .trim();
            }

            educationLevelIdController.text =
                educationLevelsList[0].dropID.toString();
            educationLevelNameController.text =
                educationLevelsList[0].name.toString();

            notifyListeners();
            return sm;
          } else {
            final smmm =
                EducationLevelModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return EducationLevelModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //  ProgressDialog.closeLoadingDialog(context);
        final sm = EducationLevelModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<NcoCodeModal?> ncoCodeApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get("Common/GetNCOTreeData");
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = NcoCodeModal.fromJson(responseData);

          if (sm.state == 200) {
            ncoCodeList.clear();
            ncoCodeList.addAll(sm.data!);

            notifyListeners();
            return sm;
          } else {
            final smmm = NcoCodeModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return NcoCodeModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = NcoCodeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<GraduationTypeModal?> graduationTypeApi(
      BuildContext context, String id) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //  ProgressDialog.showLoadingDialog(context);
        String url = "Common/GetGraduationType/$id";
        ApiResponse apiResponse = await commonRepo.get(url);
        //  ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = GraduationTypeModal.fromJson(responseData);

          if (sm.state == 200) {
            if (id == "2") {
              classList.clear();
              classList.addAll(sm.data!);
              classList
                  .sort((a, b) => a.dropID!.compareTo(b.dropID!)); // ascending
            } else {
              graduationTypeList.clear();
              graduationTypeList.addAll(sm.data!);
            }

            notifyListeners();
            return sm;
          } else {
            final smmm =
                GraduationTypeModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return GraduationTypeModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //ProgressDialog.closeLoadingDialog(context);
        final sm = GraduationTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<BoardModal?> boardApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        // ProgressDialog.showLoadingDialog(context);
        String url = "Common/Board_UniversityMaster/Board";
        ApiResponse apiResponse = await commonRepo.get(url);
        //  ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = BoardModal.fromJson(responseData);

          if (sm.state == 200) {
            boardList.clear();
            boardList.addAll(sm.data!);

            notifyListeners();
            return sm;
          } else {
            final smmm = BoardModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return BoardModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = BoardModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<StreamTypeModal?> streamTypeApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        String url = "Common/CommonMasterDataByCode/StreamType/1";
        ApiResponse apiResponse = await commonRepo.get(url);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = StreamTypeModal.fromJson(responseData);

          if (sm.state == 200) {
            streamTypeList.clear();
            streamTypeList.addAll(sm.data!);

            notifyListeners();
            return sm;
          } else {
            final smmm =
                StreamTypeModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return StreamTypeModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = StreamTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<UniversityModal?> universityApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        String url = "Common/Board_UniversityMaster/University";
        ApiResponse apiResponse = await commonRepo.get(url);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = UniversityModal.fromJson(responseData);

          if (sm.state == 200) {
            universityList.clear();
            universityList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm =
                UniversityModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return UniversityModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = UniversityModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<MediumTypeModal?> mediumOfEducationApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        String url = "Common/CommonMasterDataByCode/MediumType/1";
        ApiResponse apiResponse = await commonRepo.get(url);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = MediumTypeModal.fromJson(responseData);
          if (sm.state == 200) {
            mediumTypeList.clear();
            mediumTypeList.addAll(sm.data!);

            notifyListeners();
            return sm;
          } else {
            final smmm =
                MediumTypeModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return MediumTypeModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = MediumTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<CourseNatureModal?> courseNatureApi(
    BuildContext context,
  ) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        String url = "Common/CommonMasterDataByCode/CourseNature/1";
        ApiResponse apiResponse = await commonRepo.get(url);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = CourseNatureModal.fromJson(responseData);

          if (sm.state == 200) {
            courseNatureList.clear();
            courseNatureList.addAll(sm.data!);

            notifyListeners();
            return sm;
          } else {
            final smmm =
                CourseNatureModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return CourseNatureModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = CourseNatureModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<PassingYearModal?> passingYearModalApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        String url = "Common/CommonMasterDataByCode/PassingYear/1";
        ApiResponse apiResponse = await commonRepo.get(url);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = PassingYearModal.fromJson(responseData);

          if (sm.state == 200) {
            passingYearList.clear();
            passingYearList.addAll(sm.data!);

            notifyListeners();
            return sm;
          } else {
            final smmm =
                PassingYearModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return PassingYearModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = PassingYearModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<GradeTypeModal?> gradeTypeApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        String url = "Common/CommonMasterDataByCode/GradeType/1";
        ApiResponse apiResponse = await commonRepo.get(url);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = GradeTypeModal.fromJson(responseData);

          if (sm.state == 200) {
            gradeTypeList.clear();
            gradeTypeList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm =
                GradeTypeModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return GradeTypeModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = GradeTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<WorkExpEmploymentTypeModal?> employmentTypeApi(
      BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse =
            await commonRepo.get("Common/GetEmploymenType");
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = WorkExpEmploymentTypeModal.fromJson(responseData);

          if (sm.state == 200) {
            employmentTypesList.clear();
            originalEmploymentTypesList.clear();
            originalEmploymentTypesList.addAll(sm.data!);
            /* if (areYouInterestedInternational.text == "No") {
              print("employmentTypesList-1->" + employmentTypesList.length.toString());
              // show only the item where ID = 1
              employmentTypesList = sm.data!.where((item) => item.dropID == 1).toList();
            } else {
              // show all items
              print("employmentTypesList--2>" + employmentTypesList.length.toString());

              employmentTypesList = sm.data!;
            }*/
            employmentTypesList = sm.data!;
            //notifyListeners();
            return sm;
          } else {
            final smmm = WorkExpEmploymentTypeModal(
                state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return WorkExpEmploymentTypeModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm =
            WorkExpEmploymentTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<GetCategoryTypeDetailsModal?> getCategoryTypeDetailsApi(
    BuildContext context,
  ) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse =
            await commonRepo.get("MobileProfile/GetCategoryTypeDetails");
        //   ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = GetCategoryTypeDetailsModal.fromJson(responseData);

          if (sm.state == 200) {
            categoryList.clear();
            categoryList.addAll(sm.data!);

            //notifyListeners();
            return sm;
          } else {
            final smmm = GetCategoryTypeDetailsModal(
                state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return GetCategoryTypeDetailsModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //  ProgressDialog.closeLoadingDialog(context);
        final sm =
            GetCategoryTypeDetailsModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<GetSubCategoryTypeDetailsModal?> getSubCategoryTypeDetailsApi(
      BuildContext context, String id) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse =
            await commonRepo.get("MobileProfile/GetSubCategoryTypeDetails/$id");
        //   ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = GetSubCategoryTypeDetailsModal.fromJson(responseData);

          if (sm.state == 200) {
            subCategoryList.clear();
            subCategoryList.addAll(sm.data!);
            notifyListeners();

            //
            return sm;
          } else {
            final smmm = GetSubCategoryTypeDetailsModal(
                state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return GetSubCategoryTypeDetailsModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //  ProgressDialog.closeLoadingDialog(context);
        final sm =
            GetSubCategoryTypeDetailsModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<RegionModal?> regionListApi(
    BuildContext context,
  ) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "Common/CommonMasterDataByCode/Region/0/0";
        //ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
        //ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = RegionModal.fromJson(responseData);
          if (sm.state == 200) {
            preferredRegionList.clear();
            preferredRegionList.addAll(sm.data!);

            // notifyListeners();
            return sm;
          } else {
            final smmm = RegionModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return RegionModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //ProgressDialog.closeLoadingDialog(context);
        final sm = RegionModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  employmentFilterList() {
    if (areYouInterestedInternational.text == "No") {
      // Filter only ID = 1
      employmentTypesList =
          employmentTypesList.where((item) => item.dropID == 1).toList();

      print("Filtered (ID = 1): ${employmentTypesList.length}");
    } else {
      // Show all (restore original full list)
      employmentTypesList = List.from(originalEmploymentTypesList);

      print("All items: ${employmentTypesList.length}");
    }
    notifyListeners();
  }

  //Add Skills and Language

  Future<ProficiencyTypeModal?> proficiencyTypeApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo
            .get("Common/CommonMasterDataByCode/ProficiencyType/0/0");
        //   ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = ProficiencyTypeModal.fromJson(responseData);

          if (sm.state == 200) {
            proficiencyTypeList.clear();
            proficiencyTypeList.addAll(sm.data!);
            //notifyListeners();
            return sm;
          } else {
            final smmm =
                ProficiencyTypeModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return ProficiencyTypeModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //  ProgressDialog.closeLoadingDialog(context);
        final sm = ProficiencyTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<LanguageTypeModal?> languageTypeModaltApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {};
        String url = "MobileProfile/ProfileLanguageType";
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post(url, body);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = LanguageTypeModal.fromJson(responseData);
          if (sm.state == 200) {
            languageKnownList.clear();
            languageKnownList.addAll(sm.data!);
            return sm;
          } else {
            final smmm =
                LanguageTypeModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return LanguageTypeModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //ProgressDialog.closeLoadingDialog(context);
        final sm = LanguageTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<OTRJanAadharDetailModal?> saveOTRFormApi(
      BuildContext context,
      List<FetchJanAdharResponseData> feachJanAadhaarDataList,
      String memberId,
      String userID) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String? IpAddress = await UtilityClass.getIpAddress();
        List<Map<String, dynamic>> jsonList = languageDataList.map((e) {
          final json = e.toJson();
          json.remove('languageName');
          json.remove('proficiencyName');
          json.remove('dread');
          json.remove('dwrite');
          json.remove('dspeak');
          return json;
        }).toList();
        Map<String, dynamic> data =
            /*  {
          "SSOID": ssoIDController.text,
          "EnrId": feachJanAadhaarDataList[0].eNRID.toString(),
          "JanAadharNo": feachJanAadhaarDataList[0].jANAADHAR.toString(),
          "JanAadharMemberID": memberId,
          "Salutation": "",
          "FirstName": fullNameController.text,
          "FatherName": fatherNameController.text,
          "DOB": dateOfBirthController.text,
          "Gender": genderController.text == "Male"
              ? "M"
              : genderController.text == "Female"
              ? "F"
              : "T",
          "MobileNumber": mobileNumberController.text,
          "Email": emailController.text,
          "MaritalStatus": formatCase(maritalStatusController.text),
          "Category": castController.text,
          "AadharNo": aadhaarRefNOController.text,
          "Religion": regionIdController.text == "135" ? religionOtherNameController.text :  regionIdController.text,
          "Minority": minorityController.text == "Yes" ? "Y" : "N",
          "isStateGovtEmp": "",
          "Isdisable": 0,
          "DisabilityPercentage": "",
          "DisabilityType": "",
          "UIDNCOCode": uidTypeIdController.text,
          "UIDNumber": uidNOController.text,
          "UIDType": uidTypeNameController.text,

          // ---------- Correct: Int ----------
          "JanDistrict": int.tryParse(districtIdController.text) ?? 0,
          "JanTerritoryType": int.tryParse(territoryTypeID.toString()) ?? 0,

          "JanBlock": "",
          "JanGPName": "",
          "JanVillage": "",
          "JanCity": cityIdController.text,
          "JanWard": wardIdController.text,
          "JanAddress": addressController.text,
          "JanPincode": pinCodeController.text,

          "CorresParliament": constituencyIDController.text,
          "CorresAssembly": assemblyIDController.text,
          "CorresDistrict": int.tryParse(cDistrictIdController.text) ?? 0,
          "CorresTerritoryType": int.tryParse(cTerritoryTypeID.toString()) ?? 0,
          "CorresBlock": "",
          "CorresGPName": "",
          "CorresVillage": "",
          "CorresCity": cCityIdController.text,
          "CorresWard": cWardIdController.text,
          "CorresAddress": cAddressController.text,
          "CorresPincode": cPinCodeController.text,

          // ---------- Education ----------
          "EducationQualification": educationLevelIdController.text,
          "EducationClass": int.tryParse(classIdController.text) ?? 0,
          "EducationState": 0,
          "EducationDistrict": 0,
          "EducationSchool": schoolNameController.text,
          "EducationBoard": int.tryParse(boardIdController.text) ?? 0,
          "EducationUniversity": int.tryParse(universityIdController.text) ?? 0,
          "EducationCollege": collageNameController.text,
          "EducationPassingYear": int.tryParse(yearOfPassingNameController.text) ?? 0,
          "EducationStream": int.tryParse(streamIdController.text) ?? 0,
          "EducationMedium": int.tryParse(mediumEducationIdController.text) ?? 0,
          "EducationCourse": int.tryParse(natureOfCourseIdController.text) ?? 0,
          "EducationGrade": resultType == "Grade" ? int.tryParse(gradeTypeIdController.text) ?? 0 : 0,
          "MarksObtainedPer": resultType == "Percentage" ? double.tryParse(gradeTypeNameController.text) ?? 0 : 0,
          "CGPA": resultType == "CGPA" ? gradeTypeNameController.text : "",

          // ---------- Employment ----------
          "EmployStatus": int.tryParse(currentEmploymentStatusIdController.text) ?? 0,
          "EmployedInPast": 0,
          "EmployExpYear": expYearController.text,
          "EmployExpMonth": expMonthController.text,
          "UploadLatestPhoto": fileName,
          "SkilledYN": areYouSkilledController.text == "Yes" ? 1 : 0,
          "RSLDCTranning": 0,
          "InternationalJobYN": areYouInterestedInternational.text == "Yes" ? 1 : 0,
          "InternationalRegion": int.tryParse(regionIdController.text) ?? 0,
          "LinkedinURL": linkedinController.text,

          // ---------- Bank ----------
          "BankName": feachJanAadhaarDataList[0].bANK.toString(),
          "BankAccount": feachJanAadhaarDataList[0].aCCOUNTNO.toString(),
          "BankIFSC": feachJanAadhaarDataList[0].iFSCCODE.toString(),
          "BankBranch": feachJanAadhaarDataList[0].bANKBRANCH.toString(),

          // ---------- Office ----------
          "OfficeDistrictId":
          int.tryParse(exchangeDistrictIdController.text) ?? 0,
          "OfficeName": exchangeNameController.text,

          // ---------- NCO ----------
          "NCOCode": ncoCodeIdController.text,

          // ---------- ResultType (Fixing your wrong ternary) ----------
          "ResultType": resultType == "Grade"
              ? 0
              : resultType == "Percentage"
              ? 1
              : 2,

          "CasteCartificate": "",
          "CasteCartificatedate": "",
          "CategoryID": int.tryParse(categoryIdController.text) ?? 0,
          "SubCategoryID": int.tryParse(subCategoryIdController.text) ?? 0,
          "FamilyIncome": familyIncomeController.text,
          "UDIDNumber": "",

          "OtherEducationUniversity": otherEducationUniversity.text,
          "OtherGraduationType": otherGraduationTypeController.text,
          "OtherMediumEducation": otherMediumEducationController.text,
          "OtherReligion": "",

          "RegistrationNo": "REG20250001",
          "SameAsAddress": "",

          "Languages": jsonList // Make sure this list has correct types
        };*/

            //DOB
            //UIDType
            //CorresDistrict

            {
          "SSOID": ssoIDController.text,
          "ApplicationID": 0,
          "EnrId": feachJanAadhaarDataList[0].eNRID.toString(),

          "UserJanaadhaarImg": "",

          "Salutation": "",
          "FirstName": fullNameController.text,
          "FatherName": fatherNameController.text,

          "DOB": "1990-07-01",
          "Gender": genderController.text,

          "MobileNumber": mobileNumberController.text,
          "Email": emailController.text,

          "MaritalStatus": formatCase(maritalStatusController.text),
          "Category": castController.text,

          "AadharNo": aadhaarRefNOController.text,

          //"Religion": regionIdController.text == "135" ? religionOtherNameController.text :  regionIdController.text,
          "Religion": religionIdController == "135"
              ? religionOtherNameController.text
              : religionIdController.text,
          "Minority": minorityController.text == "Yes" ? "1" : "2",

          "JanAadharNo": feachJanAadhaarDataList[0].jANAADHAR.toString(),
          "JanAadharMemberID": memberId,

          "isStateGovtEmp": "",
          "Isdisable": differentlyAbledController.text == "Yes" ? "1" : "2",

          "DisabilityPercentage": "",
          "DisabilityType": "",

          "UIDNCOCode": uidTypeIdController.text,
          "UIDNumber": uidNOController.text,
          "UIDType": uidTypeIdController.text,

          "JanDistrict": int.tryParse(districtIdController.text) ?? 0,
          "JanTerritoryType": int.tryParse(territoryTypeID.toString()) ?? 0,
          "JanBlock": "",
          "JanGPName": "",
          "JanVillage": "",
          "JanCity": cityIdController.text,
          "JanWard": wardIdController.text,

          "JanAddress": addressController.text,
          "JanPincode": pinCodeController.text,

          "CorresParliament": constituencyIDController.text,
          "CorresAssembly": assemblyIDController.text,
          "CorresDistrict": cDistrictIdController.text,
          "CorresTerritoryType": int.tryParse(cTerritoryTypeID.toString()) ?? 0,
          "CorresBlock": "",
          "CorresGPName": "",
          "CorresVillage": "",
          "CorresCity": cCityIdController.text,
          "CorresWard": cWardIdController.text,

          "CorresAddress": cAddressController.text,
          "CorresPincode": cPinCodeController.text,

          "EducationQualification": educationLevelIdController.text,
          "EducationClass": int.tryParse(classIdController.text) ?? 0,
          "EducationState": 0,
          "EducationDistrict": 0,
          "EducationSchool": schoolNameController.text,

          "EducationBoard": int.tryParse(boardIdController.text) ?? 0,
          "EducationUniversity": int.tryParse(universityIdController.text) ?? 0,
          "EducationCollege": collageNameController.text,

          "EducationPassingYear": yearOfPassingNameController.text,
             // int.tryParse(yearOfPassingNameController.text) ?? 0,

          "EducationStream": int.tryParse(streamIdController.text) ?? 0,
          "EducationMedium":
              int.tryParse(mediumEducationIdController.text) ?? 0,
          "EducationCourse": int.tryParse(natureOfCourseIdController.text) ?? 0,
          "EducationGrade": resultType == "Grade"
              ? int.tryParse(gradeTypeIdController.text) ?? 0
              : 0,

          "MarksObtainedPer": resultType == "Percentage"
              ? double.tryParse(gradeTypeNameController.text) ?? 0
              : 0,
          "CGPA": resultType == "CGPA" ? gradeTypeNameController.text : "",

          "EmployStatus":
              int.tryParse(currentEmploymentStatusIdController.text) ?? 0,
          "EmployedInPast": 0,
          "EmployExpYear": expYearController.text,
          "EmployExpMonth": expMonthController.text,

          "UploadLatestPhoto": fileName,

          "SkilledYN": areYouSkilledController.text == "Yes" ? 1 : 2,
          "RSLDCTranning": 15,

          "InternationalJobYN":
              areYouInterestedInternational.text == "Yes" ? 1 : 2,
          "InternationalRegion": int.tryParse(regionIdController.text) ?? 0,

          "LinkedinURL": linkedinController.text,

          "BankName": feachJanAadhaarDataList[0].bANK == null ? feachJanAadhaarDataList[0].bANK.toString() : "",
          "BankAccount": feachJanAadhaarDataList[0].aCCOUNTNO == null ? feachJanAadhaarDataList[0].aCCOUNTNO.toString() : "",
          "BankIFSC": feachJanAadhaarDataList[0].iFSCCODE == null ? feachJanAadhaarDataList[0].iFSCCODE.toString() : "",
          "BankBranch": feachJanAadhaarDataList[0].bANKBRANCH == null ? feachJanAadhaarDataList[0].bANKBRANCH.toString() : "",

          "OfficeDistrictId":
              int.tryParse(exchangeDistrictIdController.text) ?? 0,
          "OfficeName": exchangeNameController.text,

          "NCOCode": ncoCodeIdController.text,
          "ResultType": resultType == "Grade"
              ? 0
              : resultType == "Percentage"
                  ? 1
                  : 2,

          "CasteCartificate": "",
          "CasteCartificatedate": "1900-01-01",

          "CategoryID": int.tryParse(categoryIdController.text) ?? 0,
          "SubCategoryID": int.tryParse(subCategoryIdController.text) ?? 0,

          "FamilyIncome": familyIncomeController.text,

          "UDIDNumber": "",

          "OtherEducationUniversity": otherEducationUniversity.text,
          "OtherGraduationType": otherGraduationTypeController.text,
          "OtherMediumEducation": otherMediumEducationController.text,
          "OtherReligion": "",

          "RegistrationNo": "REG20250001",

          "SameAsAddress": sameAsAbove == true ? 'Y' : 'N',

          "Languages": jsonList
        };
        print("printFullData -->");
        printFullJson(data);

        print("WardName => ${wardNameController.text}");
        print("WardId => ${wardIdController.text}");

        print("cWardName => ${cWardNameController.text}");
        print("cWardId => ${cWardIdController.text}");
       //  return null;
        String url = "OTRJanAadharDetail/SaveData";
        ProgressDialog.showLoadingDialog(context);
        // ApiResponse apiResponse = await commonRepo.postArray(url,body);

        ApiResponse apiResponse = await commonRepo.post(url, data);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = OTRJanAadharDetailModal.fromJson(responseData);
          if (sm.state == 200) {
            successDialog(
              context,
              sm.message.toString(),
              (value) {
                if (value.toString() == "success") {
                  if (sm.data != null &&
                      sm.data![0].userId != null &&
                      sm.data![0].userId > 0) {
                    getBasicDetailsApi(context, sm.data![0].userId.toString(),
                        sm.data![0].roleId);
                  }
                }
              },
            );
            return sm;
          } else {
            final smmm = OTRJanAadharDetailModal(
                state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return OTRJanAadharDetailModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = OTRJanAadharDetailModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<JobseekerBasicInfoModal?> getBasicDetailsApi(
      BuildContext context, String userId, int? roleId) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {
          "Action": "GetJobseekerBasicInfo",
          "UserID": userId
        };
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse =
            await commonRepo.post("Login/GetBasicDetails", body);
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
          final sm = JobseekerBasicInfoModal.fromJson(responseData);
          if (sm.state == 200) {
            final pref = AppSharedPref();
            UserData().model.value.userId = sm.data![0].userID;
            UserData().model.value.jobSeekerID = sm.data![0].jobSeekerID;
            UserData().model.value.registrationNumber =
                sm.data![0].registrationNumber;
            UserData().model.value.registrationDate =
                sm.data![0].registrationDate;
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
            UserData().model.value.latestPhotoPath =
                sm.data![0].latestPhotoPath;
            UserData().model.value.isLogin = true;
            UserData().model.value.username = "";
            UserData().model.value.password = "";
            UserData().model.value.roleId = roleId;
            UserData().model.value.maritalStatus = sm.data![0].maritalStatus;
            UserData().model.value.familyIncome = sm.data![0].familyIncome;
            pref.save('UserData', UserData().model.value);

            Navigator.of(context).push(
              RightToLeftRoute(
                page: const JobSeekerDashboard(),
                duration: const Duration(milliseconds: 500),
                startOffset: const Offset(-1.0, 0.0),
              ),
            );
            return sm;
          } else {
            final smmm = JobseekerBasicInfoModal(
                state: 0, message: sm.message.toString());

            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return JobseekerBasicInfoModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = JobseekerBasicInfoModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<SaveDataEducationModal?> sendSMSApi(
      BuildContext context,
      List<FetchJanAdharResponseData> feachJanAadhaarDataList,
      String memberId,
      String userID) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String? IpAddress = await UtilityClass.getIpAddress();
        Map<String, dynamic> bodyy = {
          "mobile": mobileNumberController.text,
          "userId": 0, //userID,
          "registrationNo": "",
          "ssoId": ssoIDController.text
        };

        String url = "Common/SendSMS";
        https: //eems.devitsandbox.com/mobileapi/api/Common/SendSMS
        ProgressDialog.showLoadingDialog(context);
        // ApiResponse apiResponse = await commonRepo.postArray(url,body);
        ApiResponse apiResponse = await commonRepo.post(url, bodyy);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          final responseId = responseData['Data']['ResponseId'];
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = SaveDataEducationModal.fromJson(responseData);
          if (sm.state == 200) {
            otpDialog(
              context,
              otpController,
              (value) {
                if (value.toString() == "success") {
                  VerifyRegistrationOtpApi(context, feachJanAadhaarDataList,
                      memberId, responseId, userID);
                }
              },
            );

            return sm;
          } else {
            final smmm = SaveDataEducationModal(
                state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          otpController.text = "";
          otpDialog(
            context,
            otpController,
            (value) {
              if (value.toString() == "success") {
                VerifyRegistrationOtpApi(
                    context, feachJanAadhaarDataList, memberId, "444", userID);
              }
            },
          );
          return SaveDataEducationModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = SaveDataEducationModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<VerifyRegistrationOtpModal?> VerifyRegistrationOtpApi(
      BuildContext context,
      List<FetchJanAdharResponseData> feachJanAadhaarDataList,
      String memberId,
      String responseId,
      String userID) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String? IpAddress = await UtilityClass.getIpAddress();
        Map<String, dynamic> bodyy = {
          /*"mobile": mobileNumberController.text,
          "OTP": otpController.text,
          "ResponseId": responseId,*/
        };
        String url =
            "Common/VerifyRegistrationOtp/${mobileNumberController.text}/${otpController.text}/${responseId}";
        ProgressDialog.showLoadingDialog(context);
        // ApiResponse apiResponse = await commonRepo.postArray(url,body);
        ApiResponse apiResponse = await commonRepo.post(url, bodyy);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = VerifyRegistrationOtpModal.fromJson(responseData);
          if (sm.state == 200) {
            saveOTRFormApi(context, feachJanAadhaarDataList, memberId, userID);

            return sm;
          } else {
            final smmm = VerifyRegistrationOtpModal(
                state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return VerifyRegistrationOtpModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm =
            VerifyRegistrationOtpModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<UploadDocumentModal?> uploadDocumentApi(
      BuildContext context, FormData inputText) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.uploadDocumentRepo(
            "Common/UploadDocument", inputText);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = UploadDocumentModal.fromJson(responseData);
          filePath = sm.data![0].filePath.toString();
          fileName = sm.data![0].fileName.toString();
          notifyListeners();
          return sm;
        } else {
          final sm =
              UploadDocumentModal(state: 0, message: 'Something went wrong');
          showAlertError(sm.message.toString(), context);
          return sm;
        }
      } on Exception catch (err) {
        final sm = UploadDocumentModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void clearData() {
    // Personal Info
    ssoIDController.clear();
    nameController.clear();
    mobileNOController.clear();
    fullNameController.clear();
    dateOfBirthController.clear();
    mobileNumberController.clear();
    fatherNameController.clear();
    maritalStatusController.clear();
    castController.clear();
    aadhaarRefNOController.clear();
    minorityController.clear();
    emailController.clear();
    religionNameController.clear();
    religionIdController.clear();
    differentlyAbledController.clear();
    genderController.clear();
    familyIncomeController.clear();
    uidTypeIdController.clear();
    uidTypeNameController.clear();
    uidNOController.clear();
    linkedinController.clear();

    religionList.clear();
    uidTypeList.clear();

    // Address Info
    districtNameController.clear();
    districtIdController.clear();
    cityNameController.clear();
    cityIdController.clear();
    wardNameController.clear();
    wardIdController.clear();

    cDistrictNameController.clear();
    cDistrictIdController.clear();
    cCityNameController.clear();
    cCityIdController.clear();
    cWardNameController.clear();
    cWardIdController.clear();

    assemblyNameController.clear();
    assemblyIDController.clear();
    constituencyNameController.clear();
    constituencyIDController.clear();

    addressController.clear();
    cAddressController.clear();
    cPinCodeController.clear();
    pinCodeController.clear();
    exchangeDistrictIdController.clear();
    exchangeDistrictNameController.clear();
    exchangeNameController.clear();

    districtList.clear();
    cDistrictList.clear();
    cityList.clear();
    cCityList.clear();
    wardList.clear();
    cWardList.clear();
    assemblyList.clear();
    parliamentListDataList.clear();
    addressInfoList.clear();
    communicationAddressInfoList.clear();

    territoryType = "Urban";
    territoryTypeID = "2";
    cTerritoryType = "Urban";
    cTerritoryTypeID = "2";
    sameAsAbove = false;

    // Education
    educationLevelIdController.clear();
    educationLevelNameController.clear();
    classIdController.clear();
    classNameController.clear();
    ncoCodeIdController.clear();
    ncoCodeNameController.clear();
    schoolNameController.clear();
    mediumEducationIdController.clear();
    mediumEducationNameController.clear();
    natureOfCourseIdController.clear();
    natureOfCourseNameController.clear();
    yearOfPassingIdController.clear();
    yearOfPassingNameController.clear();
    boardIdController.clear();
    boardNameController.clear();
    streamIdController.clear();
    streamNameController.clear();
    graduationTypeIdController.clear();
    graduationTypeNameController.clear();
    universityIdController.clear();
    universityNameController.clear();
    collageIdController.clear();
    collageNameController.clear();
    gradeTypeIdController.clear();
    gradeTypeNameController.clear();
    otherMediumEducationController.clear();
    otherGraduationTypeController.clear();
    otherEducationUniversity.clear();

    educationLevelsList.clear();
    ncoCodeList.clear();
    graduationTypeList.clear();
    boardList.clear();
    universityList.clear();
    courseNatureList.clear();
    mediumTypeList.clear();
    passingYearList.clear();
    streamTypeList.clear();
    gradeTypeList.clear();
    classList.clear();

    resultType = 'Percentage';

    // Work Experience
    currentEmploymentStatusIdController.clear();
    currentEmploymentStatusNameController.clear();
    areYouInterestedInternational.text = "No";
    expYearController.clear();
    expMonthController.clear();
    regionIdController.clear();
    regionNameController.clear();

    employmentTypesList.clear();
    originalEmploymentTypesList.clear();
    preferredRegionList.clear();

    // Skills & Languages
    categoryIdController.clear();
    categoryNameController.clear();
    subCategoryIdController.clear();
    subCategoryNameController.clear();

    areYouSkilledController.clear();
    areYouInterestedRsldcIdController.clear();
    areYouInterestedRsldcNameController.clear();
    languageNameController.clear();
    languageIdController.clear();
    proficiencyNameController.clear();
    proficiencyIdController.clear();

    categoryList.clear();
    subCategoryList.clear();
    proficiencyTypeList.clear();
    languageKnownList.clear();
    languageDataList.clear();

    read = false;
    write = false;
    speak = false;
  }

  String prettyJson(dynamic json) {
    const JsonEncoder encoder = JsonEncoder.withIndent('  ');
    return encoder.convert(json);
  }

  void printFullJson(Map<String, dynamic> json) {
    const encoder = JsonEncoder.withIndent('  ');
    final prettyString = encoder.convert(json);
    prettyString.split('\n').forEach((line) => debugPrint(line));
  }

  void validateUid(String value) {
    uidErrorText = null;
    if (value.isEmpty) {
      notifyListeners();
      return;
    }
    if (selectedUIDTypeData == "Aadhaar Card") {
      final cleaned = value.replaceAll(" ", "");
      if (cleaned.length == 12 && cleaned.isValidAadharNumber()) {
        uidErrorText = null;
      } else {
        uidErrorText = "Invalid Aadhaar number";
      }
    } else if (selectedUIDTypeData == "Pan Card") {
      final pan = value.toUpperCase();
      if (pan.length == 10 && pan.isValidPanCardNo()) {
        uidErrorText = null;
      } else {
        uidErrorText = "Invalid PAN number";
      }
    } else if (selectedUIDTypeData == "Driving License") {
      final dl = value.toUpperCase().trim();
      if (dl.length == 15 && dl.isValidLicenseNo()) {
        uidErrorText = null;
      } else {
        uidErrorText = "Invalid Driving License number";
      }
    }

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

extension AadharNumberValidator on String {
  bool isValidAadharNumber() {
    final cleaned = replaceAll(" ", "");
    return RegExp(r'^[2-9][0-9]{11}$').hasMatch(cleaned);
  }
}

extension PanCardValidator on String {
  bool isValidPanCardNo() {
    return RegExp(
      r'^[A-Z]{5}[0-9]{4}[A-Z]{1}$',
    ).hasMatch(this);
  }
}

extension DrivingLicenseValidator on String {
  bool isValidLicenseNo() {
    final value = toUpperCase().trim();

    return RegExp(
      r'^[A-Z]{2}[- ]?[0-9]{2}(19|20)[0-9]{2}[0-9]{7}$',
    ).hasMatch(value);
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
