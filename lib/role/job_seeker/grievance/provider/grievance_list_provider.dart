import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/role/job_seeker/grievance/module/grievance_modal.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../module/grievance_trail_model.dart';

class GrievanceListProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  GrievanceListProvider({required this.commonRepo});

  List<GrievanceModalData>  grievanceDataList = [];

  final Map<int, String> statusMap = {
    3: "FormSubmission",
    11: "Forward",
    10: "Dispose",
    12: "MoreInfo",
    13: "Reopen",
  };

  String getStatusName(int? statusId) {
    if (statusId == null) return "";
    return statusMap[statusId] ?? "Unknown";
  }

  /// Category Mapping
  final Map<int, String> categoryMap = {
    1: "Mobile",
    2: "Web",
  };

  String getCategoryName(int? categoryId) {
    if (categoryId == null) return "";
    return categoryMap[categoryId] ?? "Unknown";
  }

  /// Category Type Mapping
  final Map<int, String> categoryTypeMap = {
    1: "Information Required",
    2: "Issue",
    3: "Suggestion",
    4: "Other",
    5: "Information Required",
    6: "Issue",
    7: "Suggestion",
    8: "Other",
  };

  String getCategoryTypeName(int? categoryTypeId) {
    if (categoryTypeId == null) return "";
    return categoryTypeMap[categoryTypeId] ?? "Unknown";
  }


  Future<GrievanceModal?> getAllGrievanceApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String ? IpAddress =  await UtilityClass.getIpAddress();

        Map<String, dynamic> bodyy =
        {
          "GrievanceID": 0,
          "CategoryID": 0,
          "DepartmentID": 0,
          "ModuleID": 0,
          "StatusID": 0,
          "CreatedBy": UserData().model.value.userId.toString(),
          "ModifyBy": 0,
          "RoleID":  UserData().model.value.roleId.toString(),
          "ComplainNo": "",
        };

        String url = "Grievance/GetAllData";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post(url,bodyy);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = GrievanceModal.fromJson(responseData);
          print("Total records from API: ${sm.data?.length}");
          if (sm.state == 200) {
            grievanceDataList.clear();
            grievanceDataList.addAll(sm.data!);
            print("Total records in list: ${grievanceDataList.length}");


           notifyListeners();
            return sm;
          } else {
            final smmm = GrievanceModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return GrievanceModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = GrievanceModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<void> getGrievanceTrailApi(
      BuildContext context,
      GrievanceModalData grievance,
      ) async {

    try {
      Map<String, dynamic> body = {
        "GrievanceID": 26, //grievance.grievanceID, // ✅ dynamic
        "ComplainNo": "Gri/2026/00014", //grievance.complainNo ?? "",
        "Subject": "I have a suggestion in Download registration card", //grievance.subject ?? "",
        "Remark": "Download Registration card not working properly", //""
        "StatusID": 3, //grievance.statusID ?? 0,
        "CreatedDate": "2026-02-21T11:17:15.73", //grievance.createdDate ?? "",
        "FileAttachment": "1", //""
        "DisAttachmentFileName": "",
        "CategoryID": 2, //grievance.categoryID ?? 0,
        "CategoryType": 7, //grievance.categoryType ?? 0,
        "ModuleID": 1, //grievance.moduleID ?? 0,
        "SubModuleID": 7, //grievance.subModuleID ?? 0,
        "ModuleNameEn": "Job Seeker", //grievance.moduleNameEn ?? "",
        "SubModuleNameEn": "Download Registration Card", //grievance.subModuleNameEn ?? "",
        "CreatedBy": 6995, //UserData().model.value.userId,
        "RoleID": 4, //UserData().model.value.roleId,
        "DepartmentID": 1, //grievance.departmentID ?? 0,
        "GrievanceApplier": "JOB SEEKER", //grievance.grievanceApplier ?? "",
        "FeedbackDone": 0,
        "SNo": 3, //0
        "CategoryName": "Web", //"",
        "CategoryTypeName": "Suggestion", //""
      };

      ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.post(
        "Grievance/GetGrievanceTrailData",
        body,
      );

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response?.statusCode == 200) {
        var responseData = apiResponse.response!.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        final trailModel =
        GrievanceTrailModel.fromJson(responseData);

        if (trailModel.state == 200) {
          _showTrailDialog(context, trailModel.data ?? []);
        }
      }

    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
    }
  }

  void _showTrailDialog(
      BuildContext context,
      List<GrievanceTrailData> trailList,
      ) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            padding: EdgeInsets.all(10),
            height: 500,
            child: Column(
              children: [
                Text(
                  "Grievance Trail",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),

                Expanded(
                  child: ListView.builder(
                    itemCount: trailList.length,
                    itemBuilder: (context, index) {
                      final data = trailList[index];

                      return Container(
                        margin: EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          children: [

                            _row("Complaint No.", data.complainNo),
                            _divider(),

                            _row("Subject", data.subject),
                            _divider(),

                            _row("Category", data.categoryID?.toString()),
                            _divider(),

                            _row("Category Type", data.categoryType?.toString()),
                            _divider(),

                            _row("Module", data.moduleNameEn),
                            _divider(),

                            _row("Created By", data.createdBy?.toString()),
                            _divider(),

                            _row("Created On", data.rts),
                            _divider(),

                            _row("Remark", data.remark),
                            _divider(),

                            _row("Status", data.statusID?.toString()),
                            _divider(),

                            /// Upload Section
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Uploads"),
                                  data.fileAttachment != null &&
                                      data.fileAttachment != "0"
                                      ? IconButton(
                                    icon: Icon(Icons.remove_red_eye),
                                    onPressed: () {
                                      _openAttachment(
                                          context,
                                          data
                                              .disAttachmentFileName);
                                    },
                                  )
                                      : Text("No File"),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Close"),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _row(String title, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 10, vertical: 6),
      child: Row(
        mainAxisAlignment:
        MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$title :-",
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              value ?? "",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      thickness: 0.6,
      color: Colors.grey.shade300, // light soft grey
    );
  }


  void _openAttachment(
      BuildContext context,
      String? fileName,
      ) {

    if (fileName == null || fileName.isEmpty) return;

    String fileUrl =
        "https://eems.devitsandbox.com/mobileapi/Uploads/$fileName";

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            height: 400,
            child: Image.network(
              fileUrl,
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) {
                return Center(
                  child: Text("Unable to load file"),
                );
              },
            ),
          ),
        );
      },
    );
  }


  clearData(){
    grievanceDataList.clear();
    notifyListeners();
  }



  @override
  void dispose() {
    super.dispose();
  }


}
