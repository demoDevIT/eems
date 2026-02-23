import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/global.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/user_new.dart';
import '../../../../utils/utility_class.dart';
import '../module/category_model.dart';
import '../module/module_model.dart';
import '../module/save_grievance_modal.dart';
import '../module/sub_module_modal.dart';
import '../module/upload_document_response.dart';


class AddGrievanceProvider extends ChangeNotifier {
  final CommonRepo commonRepo;


  final TextEditingController categoryIdController = TextEditingController();
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController categoryTypeIdController = TextEditingController();
  final TextEditingController categoryTypeNameController = TextEditingController();
  final TextEditingController moduleIdController = TextEditingController();
  final TextEditingController moduleNameController = TextEditingController();
  final TextEditingController subModuleIdController = TextEditingController();
  final TextEditingController subModuleNameController = TextEditingController();
  final TextEditingController complaintController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController certificateController = TextEditingController();

  List<CategoryModel>  categoryList = [];
  List<CategoryModel>  categoryTypesList = [];
  List<ModuleModalData>  moduleList = [];
  List<SubModuleData>  subModuleList = [];
  String filePath = "";
  String fileName = "";
  XFile? attachments;

  // Master list (DO NOT bind this directly to dropdown)
  final List<Map<String, dynamic>> _allCategoryTypes = [
    // Mobile (categoryId = 1)
    {"id": 1, "categoryId": 1, "name": "Information Required"},
    {"id": 2, "categoryId": 1, "name": "Issue"},
    {"id": 3, "categoryId": 1, "name": "Suggestion"},
    {"id": 4, "categoryId": 1, "name": "Other"},

    // Web (categoryId = 2)
    {"id": 5, "categoryId": 2, "name": "Information Required"},
    {"id": 6, "categoryId": 2, "name": "Issue"},
    {"id": 7, "categoryId": 2, "name": "Suggestion"},
    {"id": 8, "categoryId": 2, "name": "Other"},
  ];

  AddGrievanceProvider({required this.commonRepo});


  Future<ModuleModal?> moduleApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
         ProgressDialog.showLoadingDialog(context);
         ApiResponse apiResponse = await commonRepo.get("Common/CommonMasterDataByCode/ModuleList_Grievance/0/4"); //4 - jobseeker
           ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = ModuleModal.fromJson(responseData);
          if (sm.state == 200) {
            moduleList.clear();
            moduleList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = ModuleModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return ModuleModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
          ProgressDialog.closeLoadingDialog(context);
        final sm = ModuleModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<SubModuleModal?> subModuleApi(BuildContext context,String moduleId) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get("Common/CommonMasterDataByCode/SubModuleList_Grievance/0/4");
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = SubModuleModal.fromJson(responseData);
          if (sm.state == 200) {
            subModuleList.clear();
            int selectedModuleId = int.tryParse(moduleId) ?? 0;

            // ✅ Filter based on selected ModuleId (1 or 3)
            subModuleList = sm.data!
                .where((item) => item.moduleId == selectedModuleId)
                .toList();

            notifyListeners();

            return sm;
          } else {
            final smmm =
            SubModuleModal(state: 0, message: sm.message.toString());

            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Something went wrong",
                context);

            return smmm;
          }

        } else {
          return SubModuleModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = SubModuleModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  Future<UploadDocumentModal?> uploadDocumentApi(
      BuildContext context, FormData inputText) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse =
        await commonRepo.uploadDocumentRepo("Common/UploadDocument",inputText);
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
          certificateController.text = sm.data![0].fileName.toString();
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




  Future<SaveGrievanceModal?> saveGrievanceModalApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String ? IpAddress =  await UtilityClass.getIpAddress();

        Map<String, dynamic> bodyy =
        {
          "DisAttachmentFileName": "",
          "CategoryID": categoryIdController.text,
          "CategoryType":categoryTypeIdController.text,
          "ModuleID": moduleIdController.text,
          "SubModuleID": subModuleIdController.text,
          "Subject": complaintController.text,
          "Remark": remarkController.text,
          "StatusID": 3,
          "RequestStatus": 3,
          "IsActive": true,
          "IsDeleted": false,
          "UpdatedBy": UserData().model.value.userId.toString(),
          "CreatedBy": UserData().model.value.userId.toString(),
          "IPAddress": IpAddress,
          "DepartmentID": 1,
          "RoleID": UserData().model.value.roleId.toString(),
          "UserID": UserData().model.value.userId.toString(),
          "FileAttachment": certificateController.text.toString().isNotEmpty ? true :false,
          "AttachmentFileName": certificateController.text,
        };

        String url = "MobileProfile/SaveGrievance";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post(url,bodyy);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = SaveGrievanceModal.fromJson(responseData);
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
            final smmm = SaveGrievanceModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return SaveGrievanceModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = SaveGrievanceModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }






  String removeDecimal(String value) {
    double? number = double.tryParse(value);
    return number != null ? number.toInt().toString() : value;
  }



  @override
  void dispose() {
    super.dispose();
  }


   addData(){
     categoryList.clear();
     categoryList.add(CategoryModel(dropID: 1, name: "Mobile"));
     categoryList.add(CategoryModel(dropID: 2, name: "Web"));

     categoryTypesList.clear();
     notifyListeners();
     // categoryTypesList.add(CategoryModel(dropID: 5, name: 'Information Required'));
     // categoryTypesList.add(CategoryModel(dropID: 6, name: 'Issue'));
     // categoryTypesList.add(CategoryModel(dropID: 7, name: 'Suggestion'));
     // categoryTypesList.add(CategoryModel(dropID: 8, name: 'Other'));

   }

  void updateCategoryTypes(String categoryId) {
    categoryTypesList.clear();

    int selectedId = int.tryParse(categoryId) ?? 0;

    var filteredList = _allCategoryTypes
        .where((item) => item["categoryId"] == selectedId)
        .toList();

    for (var item in filteredList) {
      categoryTypesList.add(
        CategoryModel(
          dropID: item["id"],
          name: item["name"],
        ),
      );
    }

    // Clear previous selection
    categoryTypeIdController.clear();
    categoryTypeNameController.clear();

    notifyListeners();
  }

   clearData(){
      filePath = "";
      fileName = "";

     categoryList.clear();
     categoryTypesList.clear();
     moduleList.clear();
     subModuleList.clear();
     categoryIdController.clear();
     categoryNameController.clear();
     categoryTypeIdController.clear();
     categoryTypeNameController.clear();
     moduleIdController.clear();
     moduleNameController.clear();
     subModuleIdController.clear();
     subModuleNameController.clear();
     complaintController.clear();
     remarkController.clear();
     certificateController.clear();
   }



}
