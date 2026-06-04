import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/role/counselor/counsellor_otr/modal/specialization_modal.dart';
import 'package:rajemployment/utils/global.dart';
import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/app_shared_prefrence.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/right_to_left_route.dart';
import '../../../../utils/utility_class.dart';
import '../../../employer/empotr_form/modal/upload_document_modal.dart';
import '../../../job_seeker/addeducationaldetail/modal/education_level_modal.dart';
import '../../../job_seeker/addeducationaldetail/modal/graduation_type_modal.dart';
import '../../../job_seeker/addeducationaldetail/modal/passing_year_modal.dart';
import '../../../job_seeker/addeducationaldetail/modal/university_modal.dart';
import '../../../job_seeker/addjobpreference/modal/language_type_modal.dart';
import '../../../job_seeker/otr_form/modal/fetch_jan_adhar_modal.dart';
import '../modal/counseling_medium_modal.dart';
import '../modal/counselor_otr_detail_modal.dart';
import '../modal/preferred_age_group.dart';
import '../modal/primary_domain_modal.dart';
import '../modal/tech_tool_modal.dart';
import '../../../counselor/counsellor_otr/modal/state_modal.dart';
import '../../../counselor/counsellor_otr/modal/district_modal.dart';
import '../../../counselor/counsellor_otr/modal/city_modal.dart';

class CounselorOtrProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  CounselorOtrProvider({required this.commonRepo});

  List<LanguageTypeData> languageKnownList = [];
  List<SpecializationData> specializationList = [];

  final TextEditingController ssoIDController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileNOController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  XFile? profileFile;
  String filePath = "";
  String fileName = "";
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController mobileNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String? emailErrorText;
  final TextEditingController languageNameController = TextEditingController();
  final TextEditingController languageIdController = TextEditingController();
  final TextEditingController specializationNameController =
      TextEditingController();
  final TextEditingController specializationIdController =
      TextEditingController();
  final TextEditingController adminDeptController = TextEditingController();
  final TextEditingController empIdController = TextEditingController();
  final TextEditingController sipfNoController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController dateOfJoinController = TextEditingController();
  final TextEditingController dateOfRetireController = TextEditingController();
  final TextEditingController proExpYearController = TextEditingController();
  final TextEditingController postDeptController = TextEditingController();
  final TextEditingController speSubController = TextEditingController();

  List<EducationLevelData> educationLevelsList = [];
  final TextEditingController educationLevelIdController =
      TextEditingController();
  final TextEditingController educationLevelNameController =
      TextEditingController();
  List<GraduationTypeData> graduationTypeList = [];
  final TextEditingController graduationTypeIdController =
      TextEditingController();
  final TextEditingController graduationTypeNameController =
      TextEditingController();
  final TextEditingController otherDegreeController = TextEditingController();

  List<UniversityData> universityList = [];
  final TextEditingController universityIdController = TextEditingController();
  final TextEditingController universityNameController =
      TextEditingController();

  List<PassingYearData> passingYearList = [];
  final TextEditingController yearOfPassingIdController =
      TextEditingController();
  final TextEditingController yearOfPassingNameController =
      TextEditingController();

  final TextEditingController addQualiController = TextEditingController();

  List<PrimaryDomainData> primaryDomainList = [];
  final TextEditingController primaryDomainIdController =
      TextEditingController();
  final TextEditingController primaryDomainNameController =
      TextEditingController();
  final TextEditingController certCourseController = TextEditingController();
  final TextEditingController issuOrgController = TextEditingController();
  final TextEditingController compYearIdController = TextEditingController();
  final TextEditingController compYearNameController = TextEditingController();

  final TextEditingController langProfIdController = TextEditingController();
  final TextEditingController langProfNameController = TextEditingController();

  List<CounselingMediumData> counsMedList = [];
  final TextEditingController counsMedIdController = TextEditingController();
  final TextEditingController counsMedNameController = TextEditingController();

  List<TechToolData> techToolList = [];
  final TextEditingController techToolIdController = TextEditingController();
  final TextEditingController techToolNameController = TextEditingController();

  final TextEditingController yearExpController = TextEditingController();
  final TextEditingController clinicalPsychologistController =
      TextEditingController();
  final TextEditingController psychometricTestController =
      TextEditingController();

  final TextEditingController pubWorkArtController = TextEditingController();
  final TextEditingController linkPortController = TextEditingController();
  final TextEditingController trainWorkCondController = TextEditingController();
  final TextEditingController availUpskillController = TextEditingController();

  List<PreAgeGroupData> preAgeGroupCounsList = [];
  final TextEditingController preAgeGroupCounsIdController =
      TextEditingController();
  final TextEditingController preAgeGroupCounsNameController =
      TextEditingController();

  bool isDeclarationAccepted = false;

  List<StateData> stateList = [];
  StateData? selectedState;
  TextEditingController stateController = TextEditingController();
  TextEditingController stateIdController = TextEditingController();

  List<DistrictData> districtList = [];
  DistrictData? selectedDistrict;
  TextEditingController districtController = TextEditingController();
  TextEditingController districtIdController = TextEditingController();
  bool isDistrictLoading = false;

  List<CityData> cityList = [];
  CityData? selectedCity;
  TextEditingController cityController = TextEditingController();
  TextEditingController cityIdController = TextEditingController();

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

  Future<void> getDistrictApi(String stateId) async {
    try {
     // isDistrictLoading = true;
      notifyListeners();

      // final res =
      // await commonRepo.get("Common/DistrictMaster_StateIDWise/$stateId");

      final res = await commonRepo.get("Common/GetDistrict/$stateId");

      if (res.response?.statusCode == 200) {
        var data = res.response!.data;
        if (data is String) data = jsonDecode(data);

        districtList.clear();
        for (var e in data['Data']) {
          districtList.add(DistrictData.fromJson(e));
        }
        print("District Count: ${districtList.length}");
        print(jsonEncode(data));
      }
    } catch (e, s) {
      print("District API Error: $e");
      print(s);
    } finally {
     // isDistrictLoading = false;
      notifyListeners();
    }
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

  void setJanAadhaarControllers(
      BuildContext context, FetchJanAdharResponseData data, String ssoID) {
    // print("ssoIdaaaaaaaa-->" + ssoID);
    // print("data.dOB1111aaaaaaaaaa-->" + data.dOB);
    // //  print("data.district code-->" + data.dISTRICTCD);
    debugPrint("kjhfksdjfsjdfhaaaaaaaaaaaaa" + jsonEncode(data.toJson()),
        wrapWidth: 1024);

    ssoIDController.text = ssoID;
    nameController.text = data.nAMEEN ?? "";
    fullNameController.text = data.nAMEEN ?? "";
    mobileNOController.text = data.mOBILENO?.toString() ?? "";
    mobileNumberController.text = data.mOBILENO?.toString() ?? "";
    dateOfBirthController.text = data.dOB ?? "";
    genderController.text = data.gENDER == "MALE"
        ? "Male"
        : data.gENDER == "FEMALE"
            ? "Female"
            : "TransGender";
    // print("dateOfBirthController.text22222-->" + dateOfBirthController.text);
    // fatherNameController.text = data.fATHERNAMEEN ?? "";
    // maritalStatusController.text = data.mARITALSTATUS ?? "";
    // castController.text = data.cATEGORYDESCENG ?? "";
    // aadhaarRefNOController.text = maskAadhaarRef(data.aADHARREFID?.toString()) ?? "";
    // minorityController.text = data.iSMINORITY.toString() == "N" ? "No" : "Yes";
    // emailController.text = data.eMAIL ?? "";
    // religionNameController.text = "";
    // religionIdController.text = "";
    // differentlyAbledController.text =
    // data.iSDISABILITY == '1'
    //     ? 'Yes'
    //     : data.iSDISABILITY == '0'
    //     ? 'No'
    //     : '';

    // familyIncomeController.text = ""; // No field available in model
    // uidTypeIdController.text = "";
    // uidTypeNameController.text = "";
    // uidNOController.text = "";
    // linkedinController.text = "";
    // districtNameController.text = data.dISTRICT?.toString() ?? "";
    // districtIdController.text = data.dISTRICTCD?.toString() ?? "";
    //
    // exchangeDistrictNameController.text = data.dISTRICT?.toString() ?? "";
    //
    // // Call API to get Exchange Name
    // if (data.dISTRICTCD != null) {
    //   fetchExchangeNameByDistrict(context, data.dISTRICTCD.toString());
    // }
    //
    // cityIdController.text = data.bLOCKCITYCD?.toString() ?? "";
    // cityNameController.text = data.bLOCKCITY?.toString() ?? "";
    // wardIdController.text = data.gPWARDCD?.toString() ?? "";
    // wardNameController.text = data.wARDLL?.toString() ?? "";
    // addressController.text = data.aDDRESS?.toString() ?? "";
    // pinCodeController.text = data.pINCODE?.toString() ?? "";
    notifyListeners();
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

  Future<SpecializationModal?> specializationApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "Common/CommonMasterDataByCode/Specialization/0/0";
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
        //ProgressDialog.closeLoadingDialog(context);
        print("specializationList ${apiResponse.response}");
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = SpecializationModal.fromJson(responseData);
          if (sm.state == 200) {
            specializationList.clear();
            specializationList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm =
                SpecializationModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return SpecializationModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = SpecializationModal(state: 0, message: err.toString());
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

  Future<GraduationTypeModal?> degreeTypeApi(
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
            graduationTypeList.clear();
            graduationTypeList.addAll(sm.data!);

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

  Future<PrimaryDomainModal?> primaryDomainModalApi(
      BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        String url = "Common/CommonMasterDataByCode/PrimaryDomainExperties/0/0";
        ApiResponse apiResponse = await commonRepo.get(url);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = PrimaryDomainModal.fromJson(responseData);

          if (sm.state == 200) {
            primaryDomainList.clear();
            primaryDomainList.addAll(sm.data!);

            notifyListeners();
            return sm;
          } else {
            final smmm =
                PrimaryDomainModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return PrimaryDomainModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = PrimaryDomainModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<CounselingMediumModal?> counsMedModalApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        String url = "Common/CommonMasterDataByCode/Counselling/0/0";
        ApiResponse apiResponse = await commonRepo.get(url);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = CounselingMediumModal.fromJson(responseData);

          if (sm.state == 200) {
            counsMedList.clear();
            counsMedList.addAll(sm.data!);

            notifyListeners();
            return sm;
          } else {
            final smmm =
                CounselingMediumModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return CounselingMediumModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = CounselingMediumModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<TechToolModal?> techToolModalApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        String url = "Common/CommonMasterDataByCode/TechnicalTools/0/0";
        ApiResponse apiResponse = await commonRepo.get(url);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = TechToolModal.fromJson(responseData);

          if (sm.state == 200) {
            techToolList.clear();
            techToolList.addAll(sm.data!);

            notifyListeners();
            return sm;
          } else {
            final smmm =
                TechToolModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return TechToolModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = TechToolModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<PreAgeGroupModal?> preAgeGroupModalApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        String url = "Common/CommonMasterDataByCode/PrefferredAge/0/0";
        ApiResponse apiResponse = await commonRepo.get(url);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = PreAgeGroupModal.fromJson(responseData);

          if (sm.state == 200) {
            preAgeGroupCounsList.clear();
            preAgeGroupCounsList.addAll(sm.data!);

            notifyListeners();
            return sm;
          } else {
            final smmm =
                PreAgeGroupModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return PreAgeGroupModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = PreAgeGroupModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  void toggleDeclaration(bool value) {
    isDeclarationAccepted = value;
    notifyListeners();
  }

  String getEmpTypeName(String empType, String? subType) {
    if (empType == "govt" && subType == "retired") {
      return "RetiredGovernmentEmp";
    } else if (empType == "govt" && subType == "serving") {
      return "GovernmentEmp";
    } else if (empType == "private") {
      return "PrivateEmp";
    }
    return "Unknown"; // fallback (optional)
  }

  Future<CounselorOTRDetailModal?> submitCounsellorFormApi(
    BuildContext context,
    List<FetchJanAdharResponseData> feachJanAadhaarDataList,
    String memberId,
    String empType,
    String empSubType,
    // String userID
  ) async {
    print("function call");
    print("dISTRICTCD=>");
    print("dISTRICT=>");
    print("dISTRICTNAMELL=>");

    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String? IpAddress = await UtilityClass.getIpAddress();
        // List<Map<String, dynamic>> jsonList = languageDataList.map((e) {
        //   final json = e.toJson();
        //   json.remove('languageName');
        //   json.remove('proficiencyName');
        //   json.remove('dread');
        //   json.remove('dwrite');
        //   json.remove('dspeak');
        //   return json;
        // }).toList();

        // Map<String, dynamic> data =
        // {
        //   //***********these value I got from amit tripathi in teams
        //   "AadhaarNo": feachJanAadhaarDataList[0].aADHARREFID,
        //   "Additional_Qualificate": addQualiController.text,
        //   "AdministrativedepartmentName": empType == "govt" ? adminDeptController.text : "",
        //   "AffiliatedWithAnyCareerID": 0,
        //   "AreaOfProfessionalExpertise": "",
        //   "AvailibiltyForUpskilling": availUpskillController.text,
        //   "CertificationName": "",
        //   "Certifications_CoursesCompleted": certCourseController.text,
        //   "ClinicalPsychologist": clinicalPsychologistController.toString() == 'Yes' ? true : false,
        //   "ConditionCheckbox": isDeclarationAccepted,
        //   "CounselingMediumID": counsMedIdController.text,
        //   "CounselorID": 0,
        //   "DOB": dateOfBirthController.text,
        //   "DateofRetirement": dateOfRetireController.text,
        //   "Dateofjoining": dateOfJoinController.text,
        //   "DegreeID": graduationTypeIdController.text,
        //   "DegreeName": "", //graduationTypeNameController.text, this is not used any where pass static ""
        //   "DesignationID": designationController.text,
        //   "DisclaimerStatus": false,
        //   "DistrictCode": "",
        //   "DistrictId": 0, //***********
        //   "DivIsPresentGovtEmploye": empType == "govt" ? true : false,
        //   "DivIsPresentPrivateEmploye": empType == "private" ? true : false,
        //   "EducationPassingYearID": yearOfPassingIdController.text,
        //   "EducationQualificationID": educationLevelIdController.text,
        //   "Email": emailController.text,
        //   "EmpTypeName": getEmpTypeName(empType, empSubType),
        //   "EmployeeID": "",
        //   "EmployeeNumber": null,
        //   "EmployeeType": empType == "private" ? "Private" : "government",
        //   "EmployeeTypeID": 0,
        //   "EmploymentID": empIdController.text,
        //   "EmploymentStatusID": 0,
        //   "EnrID": feachJanAadhaarDataList[0].eNRID,
        //   "FatherName": feachJanAadhaarDataList[0].fATHERNAMEEN,
        //   "FirstName": nameController.text,  // janadhaar name
        //   "FreePsychometricTests": psychometricTestController.toString() == 'Yes' ? true : false,
        //   "Gender": genderController.text,
        //   "IsDivCounsellorType": false,
        //   "IsJanIDShow": false,
        //   "IsPresentEmployee": false,
        //   "IsPresentGovtEmploye": empType == "govt" ? true : false,
        //   //"IsPresentGovtEmployee": true, // this field has not sent by amit
        //   "IsResidentState": true, //************
        //   "IscounselorType": false,
        //   "IssuingOrganization": issuOrgController.text,
        //   "JanAadhaarNo": feachJanAadhaarDataList[0].jANAADHAR,
        //   "JanmenID": memberId,
        //   "LanguageID": languageIdController.text,
        //   "LanguageProficiencyID": langProfIdController.text,
        //   "LinkedIn_PortfolioURL": linkPortController.text,
        //   "MobileNo": mobileNOController.text,
        //   "Name": "", //nameController.text
        //   "OccupationName": "",
        //   "OrganizationName": "",
        //   "OtherDegreeName": otherDegreeController.text,
        //   "PPONumber": null, // ************ ppo number
        //   "PinCode": "",
        //   "PostedDepartmentName": postDeptController.text,
        //   "PreferredAgeGroupForCounselingID": preAgeGroupCounsIdController.text,
        //   "PresentEmployeeID": 0,
        //   "PrimaryDomainExpertiseID": primaryDomainIdController.text,
        //   "PrivateCityID": 0, // ***********
        //   "PrivateDistrictID": 0, //************
        //   "PrivateStateID": 0,//***********
        //   "ProfileImageUrl": fileName,
        //   "PublishedWorkArticles": pubWorkArtController.text,
        //   "QualificationID": 0,
        //   "RegistrationNo": "",
        //   "ResidentStateID": 0,
        //   "SIPFHRMSNumber": sipfNoController.text,
        //   "SSOID": ssoIDController.text,
        //   "ShowEmployeIDField": false,
        //   "Specialization_ExpertiseID": specializationIdController.text,
        //   "Specialization_Subject": speSubController.text,
        //   "StateID": 0,
        //   "TechnicalToolsProficiencyID": techToolIdController.text,
        //   "Training_WorkshopConducted": trainWorkCondController.text,
        //   "UIDNumber": "",
        //   "UIDTypeID": 0,
        //   "UniversityID": universityIdController.text,
        //   "UniversityInstitutionName": "",
        //   "UploadDegreeCertificate": "",
        //   "UploadDegreeCertificateYearOfCompletion": "",
        //   "UploadExperienceLetterCertificate": "",
        //   "UploadProfessionalID": "",
        //   "UserID": 0,
        //   "UserId": 0,
        //   "YearOfCompletionID": compYearIdController.text,
        //   "YearOfProfessionalExperience": proExpYearController.text,
        //   "YearsOfExperienceInCounseling": yearExpController.text,
        //   "category": "", //**********janadhar category
        //
        // };

        Map<String, dynamic> data = {
          //***********these value I got from Renu in teams

          "CounsellorID": 0,
          "FirstName": nameController.text,
          "DOB": dateOfBirthController.text,
          "Name": "", //blank
          "MobileNo": mobileNOController.text,
          "Gender": genderController.text,
          "Email": emailController.text,
          "LanguageID": languageIdController.text,
          "Specialization_ExpertiseID": specializationIdController.text,
          "EmploymentID": empIdController.text,
          "OrganizationName": "", // blank
          "DesignationID": designationController.text,
          "YearOfProfessionalExperience": proExpYearController.text,
          "AreaOfProfessionalExpertise": "",
          "UploadExperienceLetterCertificate": "",
          "UploadProfessionalID": "",
          "AffiliatedWithAnyCareerID": 0,
          "EducationQualificationID": educationLevelIdController.text,
          "DegreeName": graduationTypeNameController.text,
          "Specialization_Subject": speSubController.text,
          "Additional_Qualificate": addQualiController.text,
          "EducationPassingYearID": yearOfPassingIdController.text,
          "UploadDegreeCertificate": "",
          "PrimaryDomainExpertiseID": primaryDomainIdController.text,
          "Certifications_CoursesCompleted": certCourseController.text,
          "CertificationName": "",
          "IssuingOrganization": issuOrgController.text,
          "YearOfCompletionID": compYearIdController.text,
          "UploadDegreeCertificateYearOfCompletion": "",
          "LanguageProficiencyID": langProfIdController.text,
          "CounselingMediumID": counsMedIdController.text,
          "TechnicalToolsProficiencyID": techToolIdController.text,
          "YearsOfExperienceInCounseling": yearExpController.text,
          "PublishedWorkArticles": pubWorkArtController.text,
          "LinkedIn_PortfolioURL": linkPortController.text,
          "Training_WorkshopConducted": trainWorkCondController.text,
          "AvailibiltyForUpskilling": availUpskillController.text,
          "PreferredAgeGroupForCounselingID": preAgeGroupCounsIdController.text,
          "ConditionCheckbox": isDeclarationAccepted,
          "EmployeeType": empType == "private" ? "Private" : "government",
          "IsPresentEmployee": empType == "govt" ? false : true,
          "IsDivCounsellorType": false, // static
          "IsPresentGovtEmploye": empType == "govt" ? true : false,
          "IscounselorType": false, // static
          "ShowEmployeIDField": false, // static
          "EmployeeID": "", // blank
          "PPONumber": "", // blank
          "IsJanIDShow": false, // static
          "SSOID": ssoIDController.text,
          "UserID": 0, // static
          "CounselorID": 0, // static
          "UIDTypeID": 0, // static
          "UIDNumber": "", // blank
          "FatherName": feachJanAadhaarDataList[0].fATHERNAMEEN != '' ? feachJanAadhaarDataList[0].fATHERNAMEEN : "", //blank on the case or non rajasthan as discussed with Pankaj Sir
          "EmploymentStatusID": 0, // static
          "QualificationID": 0, // static
          "OccupationName": "", // blank
          "StateID": 0, // static
          "DistrictCode": "0", // static
          "PinCode": "", // static blank
          "DisclaimerStatus": false, // static
          "UserId": 0, // static
          "ResidentStateID": 0, // static
          "EmployeeTypeID": 0, // static
          "PresentEmployeeID": 0, // static
          "EmployeeNumber": null, // ***************login se
          "JanAadhaarNo": feachJanAadhaarDataList[0].jANAADHAR != '' ? feachJanAadhaarDataList[0].jANAADHAR : "", //blank on the case or non rajasthan as discussed with Pankaj Sir
          "AadhaarNo": feachJanAadhaarDataList[0].aADHARREFID != '' ? feachJanAadhaarDataList[0].aADHARREFID : "", //blank on the case or non rajasthan as discussed with Pankaj Sir
          "JanmenID": memberId != '' ? memberId : "", //blank on the case or non rajasthan as discussed with Pankaj Sir
          "EnrID": feachJanAadhaarDataList[0].eNRID != '' ? feachJanAadhaarDataList[0].eNRID : "", //blank on the case or non rajasthan as discussed with Pankaj Sir
          "RegistrationNo": "", // blank
          "AdministrativedepartmentName":
              empType == "govt" ? adminDeptController.text : "",
          "SIPFHRMSNumber": sipfNoController.text,
          "Dateofjoining": dateOfJoinController.text,
          "DateofRetirement": dateOfRetireController.text,
          "PostedDepartmentName": postDeptController.text,
          "EmpTypeName": getEmpTypeName(empType, empSubType),
          "UniversityInstitutionName": universityNameController.text,
          "IsResidentState": empSubType == 'rajasthan' ? true : false,
          "DivIsPresentGovtEmploye": empType == "govt" ? true : false,
          "DivIsPresentPrivateEmploye": empType == "private" ? true : false,
          "IsPresentGovtEmployee": empType == "govt" ? true : false,
          "DistrictId": 0, //***********janadhar district code se district id // always static 0 as discussed with Pankaj Sir
          "category": feachJanAadhaarDataList[0].cATEGORYDESCENG != "" ? feachJanAadhaarDataList[0].cATEGORYDESCENG : "", //blank on the case or non rajasthan as discussed with Pankaj Sir
          "ClinicalPsychologist":
              clinicalPsychologistController.toString() == 'Yes' ? true : false,
          "FreePsychometricTests":
              psychometricTestController.toString() == 'Yes' ? true : false,
          "ProfileImageUrl": fileName,
          "DegreeID": graduationTypeIdController.text,
          "UniversityID": universityIdController.text,
          "OtherDegreeName": otherDegreeController.text,
          "PrivateDistrictID": empSubType == 'nonRajasthan' ? stateIdController.text : 0,
          "PrivateStateID": empSubType == 'nonRajasthan' ? districtIdController.text : 0,
          "PrivateCityID": empSubType == 'nonRajasthan' ? cityIdController.text : 0,
        };

        print("printFullData -->");
        // printFullJson(data);
        print("========== counselor OTR SUBMIT API PAYLOAD ==========");
        debugPrint(
          const JsonEncoder.withIndent('  ').convert(data),
          wrapWidth: 1024,
        );
        print("=========================================");
        //return null;
        String url = "Counselor/CounsellorRegSaveData";
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
          final sm = CounselorOTRDetailModal.fromJson(responseData);
          if (sm.state == 200) {
            successDialog(
              context,
              sm.message.toString(),
              (value) {
                if (value.toString() == "success") {
                  if (sm.data != null &&
                      sm.data![0].userId != null &&
                      sm.data![0].userId > 0) {
                    // getBasicDetailsApi(context, sm.data![0].userId.toString(),
                    //  sm.data![0].roleId);
                  }
                }
              },
            );
            return sm;
          } else {
            final smmm = CounselorOTRDetailModal(
                state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return CounselorOTRDetailModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = CounselorOTRDetailModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
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

  void clearData() {
    languageKnownList.clear();
    specializationList.clear();
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

  void printFullJson(Map<String, dynamic> json) {
    const encoder = JsonEncoder.withIndent('  ');
    final prettyString = encoder.convert(json);
    prettyString.split('\n').forEach((line) => debugPrint(line));
  }
}
