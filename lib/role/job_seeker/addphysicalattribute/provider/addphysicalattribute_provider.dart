import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/role/job_seeker/addphysicalattribute/provider/blood_group_modal.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../../addeducationaldetail/modal/nco_code_modal.dart';
import '../../addworkexperience/modal/save_work_experience_modal.dart';
import '../../physicalattribute/modal/profile_physical_attribute_modal.dart';
import '../modal/disability_type_modal.dart';
import '../modal/save_physical_attributes_modal.dart';

class AddphysicalattributeProvider extends ChangeNotifier {
  final CommonRepo commonRepo;
  final List<String> height = ['1', '2', '3', '4'];
  final List<String> weight = ['5', '10', '15', '20'];
  final List<String> chest = ['2', '6', '8', '12'];
  final List<String> blood = ['A', 'B', 'AB', 'O'];

  List<DisabilityTypeData> disabilityTypeList = [];
  final TextEditingController disabilityTypeIdController =
  TextEditingController();
  final TextEditingController disabilityTypeNameController =
  TextEditingController();
  final TextEditingController disabilityPercentageController =
  TextEditingController();


  String diffAbled = 'No';
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController chestController = TextEditingController();
  final TextEditingController eyesController = TextEditingController();
  final TextEditingController bloodIdController = TextEditingController();
  final TextEditingController bloodNameController = TextEditingController();
  List<BloodGroupData> bloodGroupList = [];





  AddphysicalattributeProvider({required this.commonRepo});


  Future<DisabilityTypeModal?> getDisabilityTypeApi(
      BuildContext context,
      bool isUpdate,
      ProfilePhysicalAttributeData? profilePhysicalAttributeData) async {

    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        ApiResponse apiResponse = await commonRepo.get(
            "Common/CommonMasterDataByCode/DisabilityType/0/0");

        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {

          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }

          final sm = DisabilityTypeModal.fromJson(responseData);

          if (sm.state == 200) {
            disabilityTypeList.clear();
            disabilityTypeList.addAll(sm.data!);

            if (isUpdate &&
                profilePhysicalAttributeData != null &&
                profilePhysicalAttributeData.isDisablity.toString() == "1") {
              disabilityTypeIdController.text =
                  profilePhysicalAttributeData.disablityType.toString();
              disabilityTypeNameController.text =
                  profilePhysicalAttributeData.disabilityName.toString();
            }

            notifyListeners();
            return sm;
          } else {
            showAlertError(sm.message ?? "Something went wrong", context);
          }
        }
      } catch (e) {
        showAlertError(e.toString(), context);
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
    return null;
  }


  Future<BloodGroupModal?> bloodGroupApi(BuildContext context,bool isUpdate,ProfilePhysicalAttributeData? profilePhysicalAttributeData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
         ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get("Common/CommonMasterDataByCode/BloodGroup/0/0");
           ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = BloodGroupModal.fromJson(responseData);
          if (sm.state == 200) {
            bloodGroupList.clear();
            bloodGroupList.addAll(sm.data!);
            notifyListeners();
            if(isUpdate == true){
              autoFillData(profilePhysicalAttributeData);
            }
            else{
              notifyListeners();
            }

            return sm;
          } else {
            final smmm = BloodGroupModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return BloodGroupModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
          ProgressDialog.closeLoadingDialog(context);
        final sm = BloodGroupModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }



  Future<SavePhysicalAttributesModal?> saveWorkExperienceApi(BuildContext context,bool isUpdate,String? physicalDetailID) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String ? IpAddress =  await UtilityClass.getIpAddress();
       /* List<Map<String, dynamic>> body = [
          {
            "UserID":UserData().model.value.userId.toString(),
            "Height":heightController.text,
            "Weight":weightController.text,
            "Chest":chestController.text,
            "BloodGroup":bloodIdController.text,
            "EyeSight":eyesController.text,
            "IsPWD":diffAbled == "Yes" ? "1" : "0"
          }
        ];*/

        Map<String, dynamic> bodyy =
        {
          "PhysicalDetailID":isUpdate == true ? physicalDetailID :"0",
          "UserID":UserData().model.value.userId.toString(),
          "Height":heightController.text,
          "Weight":weightController.text,
          "Chest":UserData().model.value.gENDER == "Female" ? "0" : chestController.text,
          "BloodGroup":bloodIdController.text.isNotEmpty ? bloodIdController.text : "0",
          "EyeSight":eyesController.text,
          "IsPWD":diffAbled == "Yes" ? "1" : "0",
          "Disability": diffAbled == "Yes" ? disabilityTypeIdController.text : "0",
          "DisabilityPercentage": diffAbled == "Yes" ? disabilityPercentageController.text : "0",

        };

/*
        {"UserID":324,"qualification":"2","Class":"9","School":"cccc","university":"0","stream":"0","medium":"69","Grade":"75","percentage":"0","passingyear":"2025-01","CGPA":"0","board":"0","Course":"73","NCOCode":"8223.72","ResultType":"146","Graduationtype":"0","College":null,"EducationID":"0","OtherEducationUniversity":"","OtherMediumEducation":"","OtherGraduationType":""};
*/


        String url = "MobileProfile/SavePhysicalAttributeData";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post(url,bodyy);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = SavePhysicalAttributesModal.fromJson(responseData);
          if (sm.state == 200) {
            successDialog(
              context,sm.message.toString(), (value) {
              print(value);
              if (value.toString() == "success") {
                Navigator.of(context).pop("success");
                //showAlertSuccess(AppLocalizations.of(context)!.login_successfully, context);
              }
            },
            );

            return sm;
          } else {
            final smmm = SavePhysicalAttributesModal(state: 0, message: sm.message.toString());
            showAlertError(sm.errorMessage.toString(), context);
            return smmm;
          }
        } else {
          return SavePhysicalAttributesModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = SavePhysicalAttributesModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  autoFillData(ProfilePhysicalAttributeData? profilePhysicalAttributeData){
    heightController.text = (profilePhysicalAttributeData?.heightInCMS ?? 0).toInt().toString();
    weightController.text = (profilePhysicalAttributeData?.weightInKG ?? 0).toInt().toString();
    chestController.text = (profilePhysicalAttributeData?.chestInCMS ?? 0).toInt().toString();
    bloodIdController.text = profilePhysicalAttributeData!.bloodGroupID.toString();
    bloodNameController.text = profilePhysicalAttributeData.bloodGroupName.toString();
    diffAbled =  profilePhysicalAttributeData.isDisablity.toString() == '1' ? "Yes" : "No";
    print(profilePhysicalAttributeData.eyeSight.toString());
    eyesController.text = profilePhysicalAttributeData.eyeSight.toString();

     notifyListeners();
  }



  String removeDecimal(String value) {
    double? number = double.tryParse(value);
    return number != null ? number.toInt().toString() : value;
  }



  @override
  void dispose() {
    super.dispose();
  }



  clearData() {
    diffAbled = 'No';

    heightController.clear();
    weightController.clear();
    chestController.clear();
    eyesController.clear();
    bloodIdController.clear();
    bloodNameController.clear();

    bloodGroupList.clear();
    disabilityTypeList.clear();
    disabilityTypeIdController.clear();
    disabilityTypeNameController.clear();
    disabilityPercentageController.clear();


    notifyListeners();
  }
}
