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

  AddGrievanceProvider({required this.commonRepo});


  Future<ModuleModal?> moduleApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
         ProgressDialog.showLoadingDialog(context);
         ApiResponse apiResponse = await commonRepo.get("Common/CommonMasterDataByCode/Module/0/0");
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
        ApiResponse apiResponse = await commonRepo.get("Common/CommonMasterDataByCode/SubModule/0/$moduleId");
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = SubModuleModal.fromJson(responseData);
          if (sm.state == 200) {
            subModuleList.clear();
            subModuleList.addAll(sm.data!);
            final seenNames = <String>{};
            subModuleList = subModuleList.where((item) {
              return seenNames.add(item.name ?? "");
            }).toList();

            notifyListeners();
            return sm;
          } else {
            final smmm = SubModuleModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return SubModuleModal(state: 0, message: 'Something went wrong',
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
          "AttachmentFileName": certificateController.text,
          "CategoryID": categoryIdController.text,
          "CategoryType":categoryTypeIdController.text,
          "CreatedBy": UserData().model.value.userId.toString(),
          "DepartmentID": 1,
          "DisAttachmentFileName": "",
          "FileAttachment": certificateController.text.toString().isNotEmpty ? true :false,
          "IPAddress": IpAddress,
          "IsActive": true,
          "IsDeleted": false,
          "ModuleID": moduleIdController.text,
          "Remark": remarkController.text,
          "RequestStatus": 3,
          "RoleID": UserData().model.value.roleId.toString(),
          "StatusID": 3,
          "SubModuleID": subModuleIdController.text,
          "Subject": complaintController.text,
          "UpdatedBy": UserData().model.value.userId.toString(),
          "UserID": UserData().model.value.userId.toString(),
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
     categoryTypesList.add(CategoryModel(dropID: 5, name: 'Information Required'));
     categoryTypesList.add(CategoryModel(dropID: 6, name: 'Issue'));
     categoryTypesList.add(CategoryModel(dropID: 7, name: 'Suggestion'));
     categoryTypesList.add(CategoryModel(dropID: 8, name: 'Other'));
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
