import 'dart:convert';
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
import '../../addeducationaldetail/modal/nco_code_modal.dart';
import '../../addjobpreference/modal/language_type_modal.dart';
import '../../grievance/module/upload_document_response.dart';
import '../../languageandskill/modal/profile_language_info_modal.dart';
import '../../languageandskill/modal/profile_skill_info_modal.dart';
import '../modal/acquired_type_modal.dart';
import '../modal/category_type_details_modal.dart';
import '../modal/get_sub_category_type_details_modal.dart';
import '../modal/proficiency_type_modal.dart';
import '../modal/save_skills_modal.dart';

class AddLanguageSkillsProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  AddLanguageSkillsProvider({required this.commonRepo});

  // Range slider values
  RangeValues salaryRange = const RangeValues(5000, 200000);

  // International job radio
  String international = 'No';

  // Controllers
  final TextEditingController categoryIdController = TextEditingController();
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController subCategoryIdController = TextEditingController();
  final TextEditingController subCategoryNameController = TextEditingController();
  final TextEditingController acquiredThroughIdController = TextEditingController();
  final TextEditingController acquiredThroughNameController = TextEditingController();
  final TextEditingController yearController  = TextEditingController();
  final TextEditingController monthController = TextEditingController();
  final TextEditingController ncoIdController  = TextEditingController();
  final TextEditingController ncoNameController  = TextEditingController();
  final TextEditingController certificateController  = TextEditingController();
  final TextEditingController remarkController  = TextEditingController();


  final TextEditingController languageIdController  = TextEditingController();
  final TextEditingController languageNameController  = TextEditingController();
  final TextEditingController proficiencyIdController  = TextEditingController();
  final TextEditingController proficiencyNameController  = TextEditingController();
  //List
  List<NcoCodeData> ncoCodeList = [];
  List<GetCategoryTypeDetailsData> categoryList = [];
  List<GetSubCategoryTypeDetailsData> subCategoryList = [];
  List<AcquiredTypeData> acquiredTypeList = [];
  List<ProficiencyTypeData> proficiencyTypeList = [];
  List<LanguageTypeData> languageKnownList = [];
  bool read = false;
  bool write = false;
  bool speak = false;
  String filePath = "";
  String fileName = "";
  XFile? attachments;


  Future<NcoCodeModal?> ncoCodeApi(BuildContext context,bool isUpdateSkill,bool isUpdateLanguage,ProfileSkillInfoData? profileSkillInfoData,
  ProfileLanguageInfoData? profileLanguageInfoData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
         ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get("Common/GetNCOTreeData");
         ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = NcoCodeModal.fromJson(responseData);

          if (sm.state == 200) {
            ncoCodeList.clear();
            ncoCodeList.addAll(sm.data!);
            getCategoryTypeDetailsApi(context,isUpdateSkill,isUpdateLanguage,profileSkillInfoData,profileLanguageInfoData);
            // notifyListeners();
            return sm;
          } else {
            final smmm = NcoCodeModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return NcoCodeModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
         ProgressDialog.closeLoadingDialog(context);
        final sm = NcoCodeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }



  Future<GetCategoryTypeDetailsModal?> getCategoryTypeDetailsApi(BuildContext context,bool isUpdateSkill,bool isUpdateLanguage,ProfileSkillInfoData? profileSkillInfoData,
      ProfileLanguageInfoData? profileLanguageInfoData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
       // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get("MobileProfile/GetCategoryTypeDetails");
     //   ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = GetCategoryTypeDetailsModal.fromJson(responseData);

          if (sm.state == 200) {
            categoryList.clear();
            categoryList.addAll(sm.data!);
            acquiredTypeApi(context,isUpdateSkill,isUpdateLanguage,profileSkillInfoData,profileLanguageInfoData);


            //notifyListeners();
            return sm;
          } else {
            final smmm = GetCategoryTypeDetailsModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return GetCategoryTypeDetailsModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
      //  ProgressDialog.closeLoadingDialog(context);
        final sm = GetCategoryTypeDetailsModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }



  Future<GetSubCategoryTypeDetailsModal?> getSubCategoryTypeDetailsApi(BuildContext context,String id,bool isUpdateSkill,ProfileSkillInfoData? profileSkillInfoData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get("MobileProfile/GetSubCategoryTypeDetails/$id");
        //   ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = GetSubCategoryTypeDetailsModal.fromJson(responseData);

          if (sm.state == 200) {
            subCategoryList.clear();
            subCategoryList.addAll(sm.data!);

            if(isUpdateSkill == true){
              autoFillSkillsData(context,profileSkillInfoData);

            }
            else{
              notifyListeners();
            }

          //
            return sm;
          } else {
            final smmm = GetSubCategoryTypeDetailsModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return GetSubCategoryTypeDetailsModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //  ProgressDialog.closeLoadingDialog(context);
        final sm = GetSubCategoryTypeDetailsModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }



  Future<AcquiredTypeModal?> acquiredTypeApi(BuildContext context,bool isUpdateSkill,bool isUpdateLanguage,ProfileSkillInfoData? profileSkillInfoData,
      ProfileLanguageInfoData? profileLanguageInfoData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get("Common/CommonMasterDataByCode/AcquiredType/0/0");
        //   ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = AcquiredTypeModal.fromJson(responseData);

          if (sm.state == 200) {
            acquiredTypeList.clear();
            acquiredTypeList.addAll(sm.data!);
            proficiencyTypeApi(context,isUpdateSkill,isUpdateLanguage,profileSkillInfoData,profileLanguageInfoData);

            //notifyListeners();
            return sm;
          } else {
            final smmm = AcquiredTypeModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return AcquiredTypeModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //  ProgressDialog.closeLoadingDialog(context);
        final sm = AcquiredTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  Future<ProficiencyTypeModal?> proficiencyTypeApi(BuildContext context ,bool isUpdateSkill,bool isUpdateLanguage,ProfileSkillInfoData? profileSkillInfoData,
      ProfileLanguageInfoData? profileLanguageInfoData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get("Common/CommonMasterDataByCode/ProficiencyType/0/0");
        //   ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = ProficiencyTypeModal.fromJson(responseData);

          if (sm.state == 200) {
            proficiencyTypeList.clear();
            proficiencyTypeList.addAll(sm.data!);
            languageTypeModaltApi(context,isUpdateSkill,isUpdateLanguage,profileSkillInfoData,profileLanguageInfoData);
            //notifyListeners();
            return sm;
          } else {
            final smmm = ProficiencyTypeModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return ProficiencyTypeModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //  ProgressDialog.closeLoadingDialog(context);
        final sm = ProficiencyTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<LanguageTypeModal?> languageTypeModaltApi(BuildContext context,bool isUpdateSkill,bool isUpdateLanguage,ProfileSkillInfoData? profileSkillInfoData,
      ProfileLanguageInfoData? profileLanguageInfoData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {};
        String url = "MobileProfile/ProfileLanguageType";
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post(url,body);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = LanguageTypeModal.fromJson(responseData);
          if (sm.state == 200) {
            languageKnownList.clear();
            languageKnownList.addAll(sm.data!);

            if(isUpdateSkill == true){
              getSubCategoryTypeDetailsApi(context, profileSkillInfoData!.categoryID.toString(),isUpdateSkill,profileSkillInfoData);

            }
            else if(isUpdateLanguage == true){
              autoFillLanguageData(context,profileLanguageInfoData);
            }

            return sm;
          } else {
            final smmm = LanguageTypeModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return LanguageTypeModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //ProgressDialog.closeLoadingDialog(context);
        final sm = LanguageTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<SaveSkillsModal?> saveSkillsApi(BuildContext context,bool isUpdateSkill,bool isUpdateLanguage,String skillID,String languageId) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String ? IpAddress =  await UtilityClass.getIpAddress();

        List<Map<String, dynamic>> body = [
          {
            "ActionName": "Skills",
            "UserID": UserData().model.value.userId.toString(),
            // "ModifyBy": UserData().model.value.userId.toString(),
             "CreatedBy": UserData().model.value.userId.toString(),
             "IsActive": 1,
             "Category": categoryIdController.text,
             "SubCategory": subCategoryIdController.text,
             "Acquired": acquiredThroughIdController.text,
             "Years": yearController.text,
             "Months": monthController.text,
             "Remark": remarkController.text,
             "NCOCode": ncoIdController.text,
             "UploadCertificate":certificateController.text,
             "SkillDetailID": isUpdateSkill == true ? skillID:"0",
             "IPAddress": "1",
             "IPAddressv6": "1"
          }
        ];

        String url = "MobileProfile/SaveDataSkills";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.postArray(url,body);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = SaveSkillsModal.fromJson(responseData);
          if (sm.state == 200) {
              successDialog(
                context,sm.message.toString(), (value) {
                print(value);
                if (value.toString() == "success") {
                  // Navigator.pop(context, true);
                  Navigator.of(context).pop("success");// close dialog
                  //showAlertSuccess(AppLocalizations.of(context)!.login_successfully, context);
                }
              },
              );
            return sm;
          } else {
            final smmm = SaveSkillsModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid", context);
            return smmm;
          }
        } else {
          return SaveSkillsModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = SaveSkillsModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  Future<SaveSkillsModal?> saveDataLanguageApi(BuildContext context, bool isUpdateSkill,bool isUpdateLanguage,String languageId) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String ? IpAddress =  await UtilityClass.getIpAddress();

        List<Map<String, dynamic>> body = [
          {
            "ActionName": "Language & Skills",
            "UserID": UserData().model.value.userId.toString(),
            "Language": languageIdController.text,
            "Proficiency": proficiencyIdController.text,
            "Read":read == true ? "1" : "0",
            "Write": write == true ? "1" : "0",
            "Speak": speak == true ? "1" : "0",
           // "ModifyBy": UserData().model.value.userId.toString(),
            "CreatedBy": UserData().model.value.userId.toString(),
            "IsActive": 1,
            "LanguageDetailID": isUpdateLanguage == true ? languageId:"0",
          }
        ];

        String url = "MobileProfile/SaveDataLanguage";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.postArray(url,body);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = SaveSkillsModal.fromJson(responseData);
          if (sm.state == 200) {
            successDialog(
              context,
              sm.message.toString(),
                  (value) {
                if (value.toString() == "success") {
                 // Navigator.of(context, rootNavigator: true).pop(); // dialog
                 //  Navigator.pop(context, true); // page
                  Navigator.of(context).pop("success");
                }
              },
            );

            return sm;
          } else {
            final smmm = SaveSkillsModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return SaveSkillsModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = SaveSkillsModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<UploadDocumentModal?> uploadDocumentApi(BuildContext context, FormData inputText) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse =
        await commonRepo.uploadDocumentRepo("Common/UploadDocument",inputText);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = UploadDocumentModal.fromJson(responseData);
          filePath = sm.data![0].filePath.toString();
          fileName = sm.data![0].fileName.toString();
          certificateController.text = filePath;
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


  autoFillSkillsData(BuildContext context,ProfileSkillInfoData? profileSkillInfoData){
    categoryIdController.text = profileSkillInfoData!.categoryID.toString();
    categoryNameController.text = profileSkillInfoData.categoryName.toString();
    subCategoryIdController.text = profileSkillInfoData.subCategoryID.toString();
    subCategoryNameController.text = profileSkillInfoData.subCategoryName.toString();
    acquiredThroughIdController.text = profileSkillInfoData.acquiredThroughID.toString();
    acquiredThroughNameController.text = profileSkillInfoData.acquiredName.toString();
    yearController.text = profileSkillInfoData.experienceInYear.toString();
    monthController.text = profileSkillInfoData.experienceInMonth.toString();
    ncoIdController.text = profileSkillInfoData.nCO.toString();
    ncoNameController.text = profileSkillInfoData.nCOCode.toString().replaceAll("-", " ");
    certificateController.text = profileSkillInfoData.certificatePath.toString();
    remarkController.text = profileSkillInfoData.remarks.toString();
    notifyListeners();
  }
  autoFillLanguageData(BuildContext context,ProfileLanguageInfoData? profileLanguageInfoData){
    languageIdController.text = profileLanguageInfoData!.languageID.toString();
    languageNameController.text = profileLanguageInfoData.languageName.toString();
    proficiencyIdController.text = profileLanguageInfoData.proficiencyID.toString();
    proficiencyNameController.text = profileLanguageInfoData.proficiencyName.toString();
    read =  profileLanguageInfoData.readStatus.toString() == "1" ? true : false;
    write =  profileLanguageInfoData.writeStatus.toString() == "1" ? true : false;
    speak = profileLanguageInfoData.speakStatus.toString() == "1" ? true : false;
    notifyListeners();
  }






  @override
  void dispose() {
    super.dispose();
  }

  addData() {

  }

  // clearData() {
  //   notifyListeners();
  // }

  void clearData() {
    // Skill controllers
    categoryIdController.clear();
    categoryNameController.clear();
    subCategoryIdController.clear();
    subCategoryNameController.clear();
    acquiredThroughIdController.clear();
    acquiredThroughNameController.clear();
    yearController.clear();
    monthController.clear();
    ncoIdController.clear();
    ncoNameController.clear();
    certificateController.clear();
    remarkController.clear();

    // Language controllers
    languageIdController.clear();
    languageNameController.clear();
    proficiencyIdController.clear();
    proficiencyNameController.clear();

    // Flags
    read = false;
    write = false;
    speak = false;

    // File data
    filePath = "";
    fileName = "";
    attachments = null;

    // Lists (important for dropdown reset)
    subCategoryList.clear();

    notifyListeners();
  }

}
