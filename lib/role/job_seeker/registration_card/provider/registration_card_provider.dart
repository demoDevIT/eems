import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rajemployment/role/job_seeker/registration_card/modal/reg_card.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';
import 'package:open_file/open_file.dart';
import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../../loginscreen/modal/download_registraction_modal.dart';

class RegistrationCardProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  RegistrationCardProvider({required this.commonRepo});


  // Controllers for text fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController fatherNameController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
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
  String gender = "Male";

  // Profile image
  XFile? profileFile;



  @override
  void dispose() {
    super.dispose();
  }

  addData() {
    fullNameController.text = UserData().model.value.nAMEENG.toString();
    fatherNameController.text = UserData().model.value.fATHERNAMEENG.toString();
    dobController.text = UserData().model.value.dOB.toString();
    mobileController.text = UserData().model.value.mOBILENO.toString();
    emailController.text = UserData().model.value.eMAILID.toString();
    aadharController.text = UserData().model.value.aadharNo.toString();
    familyIncomeController.text = "";
    uidNumberController.text = UserData().model.value.uIDNumber.toString();
    maritalStatus = UserData().model.value.maritalStatus.toString();
    maritalStatusController.text = UserData().model.value.maritalStatus.toString();
    religion = UserData().model.value.religion.toString();
    religionController.text = UserData().model.value.religion.toString();
    caste = UserData().model.value.caste.toString();
    casteController.text = UserData().model.value.caste.toString();
    uidTypeController.text = "Aadhar";
    isMinority = UserData().model.value.miniority == 1 ?  true :  false;
    gender = checkNullValue(UserData().model.value.gENDER.toString()).isNotEmpty ?  UserData().model.value.gENDER.toString() :  "Male";
    familyIncomeController.text =UserData().model.value.familyIncome.toString();
    notifyListeners();
  }

  clearData() {
    fullNameController.clear();
    fatherNameController.clear();
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
    gender = "Male";
    notifyListeners();
  }



  Future<DownloadRegistractionModal?>  pdfDownloadApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> bodyy =
        {
          "UserId": UserData().model.value.userId.toString(),



        };
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post("Common/Pdfbase64",bodyy);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = DownloadRegistractionModal.fromJson(responseData);
          if (sm.userId.toString().isNotEmpty) {
            saveAndOpenPdf(context, sm.pdfBase64.toString(), "pdfBase64fdfdfd.Pdf");
            notifyListeners();
            return sm;
          } else {
            final smmm = DownloadRegistractionModal(userId: 0, pdfBase64: UserData().model.value.nAMEENG.toString());
            showAlertError(smmm.userId.toString().isNotEmpty ? smmm.userId.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return DownloadRegistractionModal(userId: 0, pdfBase64: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = DownloadRegistractionModal(userId: 0, pdfBase64: err.toString());
        showAlertError(sm.pdfBase64.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }
  Future<void> saveAndOpenPdf(BuildContext context, String base64String, String fileName) async {
    try {
      // Decode base64 string
      final bytes = base64Decode(base64String);

      // Get temporary directory
      final dir = await getTemporaryDirectory();
      final file = File('${dir.path}/$fileName');

      // Write the PDF bytes to the file
      await file.writeAsBytes(bytes);
      // Open the PDF
      // openPdfFile(context,file.path + ".pdf");
      await OpenFile.open(file.path);
    } catch (e) {
      print('Error saving/opening PDF: $e');
    }
  }

  List<RegCardInfoData> regCardList = [];

  Future<RegCardInfoListModal?> regCardDetailData(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {
          //"UserId": UserData().model.value.userId.toString(),
        };
        final userId = UserData().model.value.userId.toString();
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post("MobileProfile/GetRegistrationCardInfo/$userId",body);

        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          // 🔍 DEBUG PRINTS
          print("RAW RESPONSE TYPE ---> ${responseData.runtimeType}");
          print("RAW RESPONSE DATA ---> $responseData");

          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }

          final sm = RegCardInfoListModal.fromJson(responseData);

          regCardList.clear();
          if (sm.state == 200) {
            regCardList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            notifyListeners();
            final smmm = RegCardInfoListModal(state: 0, message: sm.message.toString());
            //showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {

          return RegCardInfoListModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = RegCardInfoListModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }
}
