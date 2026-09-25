import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../../../employer/empotr_form/modal/upload_document_modal.dart';
import '../modal/save_basic_info_modal.dart';

class BasicDetailsProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  BasicDetailsProvider({required this.commonRepo});

  // Controllers for text fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController motherNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();

  final TextEditingController alternateMobileController = TextEditingController();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController aadharController = TextEditingController();
  final TextEditingController familyIncomeController = TextEditingController();
  final TextEditingController uidNumberController = TextEditingController();
  final TextEditingController uidTypeController = TextEditingController();
  final TextEditingController casteController = TextEditingController();
  final TextEditingController religionController = TextEditingController();
  final TextEditingController maritalStatusController = TextEditingController();

  // Dropdown values
  String? maritalStatus;
  String? religion;
  String? caste;
  String? uidType;

  // Switch and Radio values
  bool isMinority = false;
  String isExServiceMan = "no";
  String isEWSCategory = "no";

  String isRetiredGovtServant = "no";

  String gender = "Male";

  // Profile image
  XFile? profileFile;

  String filePath = "";
  String fileName = "";

  bool isUploadingProfile = false;

  bool isLoading = false;

  @override
  void dispose() {
    fullNameController.dispose();
    fatherNameController.dispose();
    motherNameController.dispose();
    dobController.dispose();
    mobileController.dispose();
    alternateMobileController.dispose();
    emailController.dispose();
    aadharController.dispose();
    familyIncomeController.dispose();
    uidNumberController.dispose();
    uidTypeController.dispose();
    casteController.dispose();
    religionController.dispose();
    maritalStatusController.dispose();

    super.dispose();
  }

  addData() {
    fullNameController.text = UserData().model.value.nAMEENG.toString();
    fatherNameController.text = UserData().model.value.fATHERNAMEENG.toString();
    motherNameController.text = UserData().model.value.motherName.toString();
    dobController.text = UserData().model.value.dOB.toString();
    mobileController.text = UserData().model.value.mOBILENO.toString();
    emailController.text = UserData().model.value.eMAILID.toString();
    aadharController.text = UserData().model.value.aadharNo.toString();
    familyIncomeController.text = "";
    // uidNumberController.text = UserData().model.value.uIDNumber.toString();
    uidNumberController.text = maskUid(UserData().model.value.uIDNumber.toString());
    maritalStatus = UserData().model.value.maritalStatus.toString();
    maritalStatusController.text = UserData().model.value.maritalStatus.toString();
    religion = UserData().model.value.religion.toString();
    religionController.text = UserData().model.value.religion.toString();
    caste = UserData().model.value.caste.toString();
    casteController.text = UserData().model.value.caste.toString();
    uidTypeController.text = "Aadhar";
    isMinority = UserData().model.value.miniority == 1 ?  true :  false;
    // isExServiceMan = UserData().model.value.isExServiceMan.toString() == false ? "No" : "Yes";
    // isEWSCategory = UserData().model.value.isEWSCategory.toString() == false ? "No" : "Yes";

    isExServiceMan =
    UserData().model.value.isExServiceMan.toString() == "true"
        ? "yes"
        : "no";

    isEWSCategory =
    UserData().model.value.isEWSCategory.toString() == "true"
        ? "yes"
        : "no";


    gender = checkNullValue(UserData().model.value.gENDER.toString()).isNotEmpty ?  UserData().model.value.gENDER.toString() :  "Male";
    familyIncomeController.text =UserData().model.value.familyIncome.toString();
    notifyListeners();
  }

  String maskUid(String uid) {
    if (uid.isEmpty) return '';

    if (uid.length <= 4) {
      return uid; // nothing to mask
    }

    final maskedLength = uid.length - 4;
    return '*' * maskedLength + uid.substring(uid.length - 4);
  }

  Future<bool> uploadProfileImage(BuildContext context) async {
    if (profileFile == null) {
      return false;
    }

    final isInternet = await UtilityClass.checkInternetConnectivity();

    if (!isInternet) {
      showAlertError(
        AppLocalizations.of(context)!.internet_connection,
        context,
      );
      return false;
    }

    try {
      isUploadingProfile = true;
      notifyListeners();

      final file = File(profileFile!.path);

      final int fileSizeInBytes = await file.length();
      final double fileSizeInKB = fileSizeInBytes / 1024;

      // 100 KB validation
      if (fileSizeInKB > 100) {
        showAlertError(
          AppLocalizations.of(context)!.imgSize,
          context,
        );

        isUploadingProfile = false;
        notifyListeners();

        return false;
      }

      final String timestamp =
          "${DateTime.now().millisecondsSinceEpoch}.jpg";

      final MultipartFile multipartFile =
      await MultipartFile.fromFile(
        profileFile!.path,
        filename: timestamp,
      );

      final FormData formData = FormData.fromMap({
        "file": multipartFile,
      });

      ProgressDialog.showLoadingDialog(context);

      final ApiResponse apiResponse =
      await commonRepo.uploadDocumentRepo(
        "Common/UploadDocument",
        formData,
      );

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response != null &&
          apiResponse.response?.statusCode == 200) {
        var responseData = apiResponse.response?.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        final uploadResponse =
        UploadDocumentModal.fromJson(responseData);

        if (uploadResponse.data != null &&
            uploadResponse.data!.isNotEmpty) {
          filePath =
              uploadResponse.data![0].filePath?.toString() ?? "";

          fileName =
              uploadResponse.data![0].fileName?.toString() ?? "";

          isUploadingProfile = false;
          notifyListeners();

          return true;
        }

        showAlertError(
          uploadResponse.message?.toString() ??
              "File upload failed",
          context,
        );
      } else {
        showAlertError(
          "File upload failed",
          context,
        );
      }
    } on Exception catch (err) {
      ProgressDialog.closeLoadingDialog(context);

      showAlertError(
        err.toString(),
        context,
      );
    }

    isUploadingProfile = false;
    notifyListeners();

    return false;
  }

  Future<SaveBasicInfoModal?> saveBasicInfoApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();

    if (isInternet) {
      try {
        String? ipAddress = await UtilityClass.getIpAddress();
        String? deviceId = await UtilityClass.getDeviceId();

        Map<String, dynamic> body = {
          "ID": 0,
          "UserID": UserData().model.value.userId,
          "UploadLatestProfile": fileName,
          "IsEWSCategory": isEWSCategory.toLowerCase() == "yes" ? "1" : "0", // Yes = 1, No = 0
          "IsExServiceMan": isExServiceMan.toLowerCase() == "yes" ? "1" : "0", // Yes = 1, No = 0
          "MOBILE_NO_Alternate": alternateMobileController.text.trim(),
          "IsRetiredGovtServant": isRetiredGovtServant.toLowerCase() == "yes" ? 1 : 0, // Yes = 1, No = 0
        };

        String url = "ProfilJobSeekar/SaveDataBasicInfo";

        ProgressDialog.showLoadingDialog(context);

        ApiResponse apiResponse =
        await commonRepo.post(url, body);

        ProgressDialog.closeLoadingDialog(context);

        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {

          var responseData = apiResponse.response?.data;

          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }

          final sm = SaveBasicInfoModal.fromJson(responseData);

          if (sm.state == 200) {
            successDialog(
              context,
              sm.message.toString(),
                  (value) {
                print(value);

                if (value.toString() == "success") {
                  Navigator.of(context).pop("success");
                }
              },
            );

            return sm;
          } else {
            final smmm = SaveBasicInfoModal(
              state: 0,
              message: sm.message.toString(),
            );

            showAlertError(
              smmm.message.toString().isNotEmpty
                  ? smmm.message.toString()
                  : "Something went wrong",
              context,
            );

            return smmm;
          }
        } else {
          final smmm = SaveBasicInfoModal(
            state: 0,
            message: "Something went wrong",
          );

          showAlertError(
            smmm.message.toString(),
            context,
          );

          return smmm;
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);

        final sm = SaveBasicInfoModal(
          state: 0,
          message: err.toString(),
        );

        showAlertError(
          sm.message.toString(),
          context,
        );

        return sm;
      }
    } else {
      showAlertError(
        AppLocalizations.of(context)!.internet_connection,
        context,
      );
    }

    return null;
  }

  clearData() {
    fullNameController.clear();
    fatherNameController.clear();
    motherNameController.clear();
    dobController.clear();
    mobileController.clear();
    emailController.clear();
    aadharController.clear();
    familyIncomeController.clear();
    uidNumberController.clear();
    profileFile =  null;
    maritalStatus =  "";
    religion =  "";
    caste =  "";
    uidType =  "";
    isMinority = false;
    isExServiceMan = "no";
    isEWSCategory = "no";
    gender = "Male";
    notifyListeners();
  }
}
