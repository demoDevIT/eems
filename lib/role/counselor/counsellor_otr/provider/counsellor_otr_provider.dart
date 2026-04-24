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
import '../../../job_seeker/addjobpreference/modal/language_type_modal.dart';

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
  final TextEditingController specializationNameController = TextEditingController();
  final TextEditingController specializationIdController = TextEditingController();
  final TextEditingController adminDeptController = TextEditingController();
  final TextEditingController empIdController = TextEditingController();
  final TextEditingController sipfNoController = TextEditingController();
  final TextEditingController designationController = TextEditingController();
  final TextEditingController dateOfJoinController = TextEditingController();
  final TextEditingController dateOfRetireController = TextEditingController();
  final TextEditingController proExpYearController = TextEditingController();
  final TextEditingController postDeptController = TextEditingController();

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
}

