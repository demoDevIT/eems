import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/utility_class.dart';
import '../../../job_seeker/addeducationaldetail/modal/education_level_modal.dart';
import '../../../job_seeker/addeducationaldetail/modal/graduation_type_modal.dart';
import '../modal/counselor_info_modal.dart';

class CounselorHighestEduProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  CounselorHighestEduProvider({required this.commonRepo});

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

  EducationLevelData? selectedEducationLevel;

  // Controllers for text fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController prefLangController = TextEditingController();
  final TextEditingController specExpertiseLangController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  int? selectedQualificationId;

  String gender = "Male";

  @override
  void dispose() {
    super.dispose();
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

            // ✅ SET DEFAULT BASED ON API VALUE
            // if (selectedQualificationId != null) {
            //   selectedEducationLevel = educationLevelsList.firstWhere(
            //         (e) => e.dropID.toString() == selectedQualificationId.toString(),
            //     orElse: () => educationLevelsList[0],
            //   );
            // } else {
            //   selectedEducationLevel = educationLevelsList[0];
            // }

// ✅ SET CONTROLLERS ONCE (correct)
            educationLevelIdController.text =
                selectedEducationLevel!.dropID.toString();

            educationLevelNameController.text =
                selectedEducationLevel!.name ?? "";
            print("Final ID: ${educationLevelIdController.text}");
            print("Final Name: ${educationLevelNameController.text}");

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

  void setCounselorData(CounselorInfoData data) {

    print("eduData=> $data");
    fullNameController.text = data.firstName ?? "";
    gender = data.gender ?? "Male";
    dobController.text = data.dob ?? "";
    mobileController.text = data.mobileNo ?? "";
    emailController.text = data.email ?? "";
    //prefLangController.text = data.pref ?? "";
    specExpertiseLangController.text = data.specExpertID.toString() ?? "";
    // stateController.text = data.sta ?? "";
    // districtController.text = data.district ?? "";
    // cityController.text = data.city ?? "";
    selectedQualificationId = data.eduQualID; //

    print("eduQualID => ${data.eduQualID}");
    notifyListeners();
  }

  clearData() {
    //   fullNameController.clear();
    //   fatherNameController.clear();
    //   dobController.clear();
    //   mobileController.clear();
    //   emailController.clear();
    //   aadharController.clear();
    //   familyIncomeController.clear();
    //   uidNumberController.clear();
    //   profileFile =  null;
    //   maritalStatus =  "";
    //   religion =  "";
    //   caste =  "";
    //   uidType =  "";
    //   isMinority = false;
    //   gender = "Male";
    //   notifyListeners();
  }
}
