import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/global.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/user_new.dart';
import '../../../../utils/utility_class.dart';


import 'package:http_parser/http_parser.dart';

import '../../../counselor/counsellor_otr/modal/district_modal.dart';
import '../../../employer/empotr_form/modal/sector_modal.dart';
import '../../../employer/job_post/modal/job_title_modal.dart';
import '../../addeducationaldetail/modal/board_modal.dart';
import '../../addeducationaldetail/modal/education_level_modal.dart';
import '../../addeducationaldetail/modal/graduation_type_modal.dart';
import '../../addeducationaldetail/modal/stream_type_modal.dart';
import '../../educationdetail/modal/profile_qualication_info_list_modal.dart';
import '../modal/caste_model.dart';
import '../modal/event_model.dart';
import '../modal/job_fair_reg_save_model.dart';
import '../modal/matched_job_post_model.dart';


class JobFairRegistrationProvider extends ChangeNotifier {

  final CommonRepo commonRepo;

  JobFairRegistrationProvider({required this.commonRepo});

  List<EventData> eventList = [];
  EventData? selectedEvent;

  final TextEditingController  eventIdController = TextEditingController();
  final TextEditingController  eventNameController = TextEditingController();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController fNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  List<DistrictData> districtList = [];
  final TextEditingController districtNameController = TextEditingController();
  final TextEditingController districtIdController = TextEditingController();

  List<CasteData> casteList = [];
  final TextEditingController casteNameController = TextEditingController();
  final TextEditingController casteIdController = TextEditingController();

  CasteData? casteDistrict;

  final TextEditingController territoryController = TextEditingController();
  List<EducationLevelData> educationLevelsList = [];

  final TextEditingController educationLevelIdController = TextEditingController();
  final TextEditingController educationLevelNameController = TextEditingController();

  List<GraduationTypeData> classList = [];
  final TextEditingController classIdController = TextEditingController();
  final TextEditingController classNameController = TextEditingController();

  List<GraduationTypeData> graduationTypeList = [];
  List<GraduationTypeData> itiMainList = [];
  List<BoardData> boardList = [];
  List<StreamTypeData> streamTypeList = [];

  final TextEditingController graduationTypeIdController = TextEditingController();
  final TextEditingController graduationTypeNameController = TextEditingController();

  DistrictData? selectedDistrict;

  List<SectorData>  sectorList = [];
  final TextEditingController  sectorIdController = TextEditingController();
  final TextEditingController  sectorNameController = TextEditingController();

  //job title
  List<JobTitleData>  jobTitleList = [];
  final TextEditingController  jobTitleIdController = TextEditingController();
  final TextEditingController  jobTitleController = TextEditingController();

  List<JobPostTable> matchedJobList = [];

  int get selectedJobCount =>
      matchedJobList.where((e) => e.isSelected).length;

  void resetSectorAndJobs() {
    sectorIdController.clear();
    sectorNameController.clear();

    matchedJobList.clear();

    notifyListeners();
  }

  Future<void> getEventList(BuildContext context, {bool showLoader = true}) async {
    if (showLoader) {
      ProgressDialog.showLoadingDialog(context);
    }

    final isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
      return;
    }

    try {
      //ProgressDialog.showLoadingDialog(context);

      final response = await commonRepo.get(
        "MobileProfile/EventDetails/0/0/0",
      );

      //ProgressDialog.closeLoadingDialog(context);

      if (response.response?.statusCode == 200) {
        var data = response.response?.data;
        if (data is String) data = jsonDecode(data);

        if (data['State'] == 200 && data['Data'] != null) {
          // eventList = (data['Data'] as List)
          //     .map((e) => EventModel.fromJson(e))
          //     .toList();

          eventList = (data['Data'] as List)
              .map((e) => EventData.fromJson(e))
              .toList();

          notifyListeners();
        }
      }
    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
    } finally {
      if (showLoader) {
        ProgressDialog.closeLoadingDialog(context);
      }
    }
  }

  Future<SectorModal?> sectorListApi(BuildContext context, {bool showLoader = true}) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (showLoader) {
      ProgressDialog.showLoadingDialog(context);
    }
    print("11aa");
    if (isInternet) {
      print("22bb");
      try {
        print("33cc");
        String url = "ProfilJobSeekar/SectorDetailsData";
        // ProgressDialog.showLoadingDialog(context);
        Map<String, dynamic> body = {};
        ApiResponse apiResponse = await commonRepo.post(url,body);
        //ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          print("44dd");
          final sm = SectorModal.fromJson(responseData);
          sectorList.clear();
          if (sm.state == 200) {
            sectorList.add(
              SectorData(
                iD: 0,
                name: "All",
              ),
            );
            sectorList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = SectorModal(state: 0, message: sm.message.toString());

            notifyListeners();
            //showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return SectorModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = SectorModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      } finally {
        if (showLoader) {
          ProgressDialog.closeLoadingDialog(context);
        }
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<DistrictModal?> getDistrictMasterApi(
      BuildContext context,
      {bool showLoader = true}) async {

    if (showLoader) {
      ProgressDialog.showLoadingDialog(context);
    }

    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        // ApiResponse apiResponse =
        // await commonRepo
        //     .get("Common/GetDistrictMaster")
        //     .timeout(const Duration(seconds: 30));

        Map<String, dynamic> body = {};
        ApiResponse apiResponse = await commonRepo.post("Common/GetDistrictMaster",body);

       // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = DistrictModal.fromJson(responseData);

          if (sm.state == 200) {
            districtList.clear();
            districtList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm =
            DistrictModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return DistrictModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
       // ProgressDialog.closeLoadingDialog(context);
        final sm = DistrictModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      } finally {
        if (showLoader) {
          ProgressDialog.closeLoadingDialog(context);
        }
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<CasteModal?> getCasteMasterApi(
      BuildContext context,
      {bool showLoader = true}) async {

    print("casteeeee11");
    if (showLoader) {
      ProgressDialog.showLoadingDialog(context);
    }

    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      print("casteeeee22");
      try {
        //ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse =
        await commonRepo
            .get("Common/GetCasteMaster")
            .timeout(const Duration(seconds: 30));
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          print("casteeeee33");
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = CasteModal.fromJson(responseData);
          print("casteeeee44");
          if (sm.state == 200) {
            print("casteeeee55");
            casteList.clear();
            casteList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            print("casteeeee66");
            final smmm =
            CasteModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return CasteModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = CasteModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      } finally {
        if (showLoader) {
          ProgressDialog.closeLoadingDialog(context);
        }
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<EducationLevelModal?> educationLevelApi(
      BuildContext context,
      {bool showLoader = true}) async {

    if (showLoader) {
      ProgressDialog.showLoadingDialog(context);
    }

    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
       // ProgressDialog.showLoadingDialog(context);
       //  ApiResponse apiResponse = await commonRepo.get("Common/GetQualificationList");

       //  ApiResponse apiResponse =
       //  await commonRepo
       //      .get("Common/GetQualificationList")
       //      .timeout(const Duration(seconds: 30));

        Map<String, dynamic> body = {};
        ApiResponse apiResponse = await commonRepo.post("Common/GetQualificationList",body);

      //  ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = EducationLevelModal.fromJson(responseData);

          if (sm.state == 200) {
            educationLevelsList.clear();
            educationLevelsList.addAll(sm.data!);
            for (var item in educationLevelsList) {
              item.name = item.qualificationHI?.replaceAll(RegExp(r'[\r\n]+'), '').trim();
              item.qualificationHI = item.qualificationHI?.replaceAll(RegExp(r'[\r\n]+'), '').trim();
            }

              print("elseee isUpdate && profileData != null");
              // default selection
              educationLevelIdController.text =
                  educationLevelsList.first.dropID.toString();
              educationLevelNameController.text =
                  educationLevelsList.first.name.toString();

            notifyListeners();
            return sm;
          } else {
            final smmm = EducationLevelModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return EducationLevelModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
      //  ProgressDialog.closeLoadingDialog(context);
        final sm = EducationLevelModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      } finally {
        if (showLoader) {
          ProgressDialog.closeLoadingDialog(context);
        }
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<GraduationTypeModal?> graduationTypeApi(BuildContext context,String id) async {
    print("classIDDDD=>$id");
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //  ProgressDialog.showLoadingDialog(context);
        // String url = "Common/GetGraduationType/$id";
        // ApiResponse apiResponse = await commonRepo.get(url);

        Map<String, dynamic> body = {
          "QualificationID": id
        };
        ApiResponse apiResponse = await commonRepo.post("Common/GetGraduationType",body);

        //  ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = GraduationTypeModal.fromJson(responseData);

          if (sm.state == 200) {
            if(id == "2"){
              print("graduationTypeApi function ID 2");
              classList.clear();
              classList.addAll(sm.data!);
              classList.sort((a, b) => a.dropID!.compareTo(b.dropID!));  // ascending

              // if (isUpdate && profileData?.classID != null) {
              //   final selectedClass = classList.firstWhere(
              //         (e) => e.dropID == profileData!.classID,
              //     orElse: () => classList.first,
              //   );
              //
              //   classIdController.text = selectedClass.dropID.toString();
              //   classNameController.text = selectedClass.name.toString();
              // }

            }
            else{
              print("graduationTypeApi function ID not 2 - $id");
              graduationTypeList.clear();
              graduationTypeList.addAll(sm.data!);

              // ✅ FIX HERE
              if (id == "9") {
                itiMainList.clear();
                itiMainList.addAll(graduationTypeList);
              }
            }



            notifyListeners();
            return sm;
          } else {
            final smmm = GraduationTypeModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return GraduationTypeModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //ProgressDialog.closeLoadingDialog(context);
        final sm = GraduationTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<BoardModal?> boardApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        // ProgressDialog.showLoadingDialog(context);
        // String url = "Common/Board_UniversityMaster/Board";
        // ApiResponse apiResponse = await commonRepo.get(url);

        Map<String, dynamic> body = {
          "ActionName": "",
          "MasterCode": "Board",
          "UserID": 0,
          "DepartmentID": 0,
          "RoleID": 0,
          "SchemeId": 0,
          "CityId": 0,
          "BlockId": "",
          "DistrictId": "",
          "GPId": ""
        };
        ApiResponse apiResponse = await commonRepo.post("Common/Board_UniversityMaster",body);

        //  ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = BoardModal.fromJson(responseData);

          if (sm.state == 200) {
            boardList.clear();
            boardList.addAll(sm.data!);

            notifyListeners();
            return sm;
          } else {
            final smmm = BoardModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return BoardModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = BoardModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<StreamTypeModal?> streamTypeApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        // String url = "Common/CommonMasterDataByCode/StreamType/1";
        // ApiResponse apiResponse = await commonRepo.get(url);

        Map<String, dynamic> body = {
          "ActionName": "",
          "MasterCode": "StreamType",
          "UserID": 0,
          "DepartmentID": 1, //first argument
          "RoleID": 0, //second argument
          "SchemeId": 0,
          "CityId": 0,
          "BlockId": 0,
          "DistrictId": 0,
          "GPId": 0
        };
        ApiResponse apiResponse = await commonRepo.post("Common/CommonMasterDataByCode",body);

        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = StreamTypeModal.fromJson(responseData);

          if (sm.state == 200) {
            streamTypeList.clear();
            streamTypeList.addAll(sm.data!);

            notifyListeners();
            return sm;
          } else {
            final smmm = StreamTypeModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return StreamTypeModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = StreamTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<void> getMatchedJobPostedList(
      BuildContext context,
      int categoryId,
      ) async {
    try {

      Map<String, dynamic> body = {
        "ActionKey": "GetJobSeekerJobPostListbyUserID",
        "UserId": 0,
        "EventRegistrationId": 0,
        "Roleid": 0,
        "EventId": int.parse(eventIdController.text),
        "JobCategoryID": categoryId,
        "ncoCode": "",
        "JobPositionTitle": "",
        "JobSector": 0,
        "JobTitle": 0,
        "MobileNo": "",
        "EventRegNo": "",
        "EventId_Encrypted": ""
      };

      ApiResponse response = await commonRepo.post(
        "JobFairEvent/GetMatchedJobPostedListEnc",
        body,
      );

      if (response.response?.statusCode == 200) {
        var data = response.response?.data;

        if (data is String) {
          data = jsonDecode(data);
        }

        final model = MatchedJobPostModel.fromJson(data);

        matchedJobList.clear();

        matchedJobList.addAll(
          model.data?.table1 ?? [],
        );

        notifyListeners();
      }
    } catch (e) {
      showAlertError(e.toString(), context);
    }
  }

  Future<void> saveJobFairRegistration(
      BuildContext context,
      ) async {

    ProgressDialog.showLoadingDialog(context);

    try {

      List<Map<String, dynamic>> jobList =
      matchedJobList
          .where((e) => e.isSelected)
          .map((e) => {

        "JobPostId": e.jobPostId,
        "EmployerUserId": e.employerUserId,
        "EventId": e.eventId,
        "EventRegistrationId": 0,
      }).toList();

      String? deviceId = await UtilityClass.getDeviceId();

      Map<String, dynamic> body = {
        "Name": nameController.text,
        "FatherName": fNameController.text,
        "MobileNo": mobileController.text,
        "EmailID": emailController.text,
        "JanAadharNo": "",
        "JanMemberId": "",
        "AadharNo": "",
        "JobEventId": int.parse(eventIdController.text),
        "JobEventId_Encrypted": "",
        "UserId": 0,
        "HightestEducationId": int.parse(educationLevelIdController.text),
        "GetGraduationTypeID": int.parse(graduationTypeIdController.text),
        "DDLDistrictID": int.parse(districtIdController.text),
        "DOB": dateOfBirthController.text,
        "Gender": genderController.text,
        "Action": "ByMobileNo",
        "CorresBlock": "",
        "CorresGPName": "",
        "CorresVillage": "",
        "CorresCity": "",
        "CorresWard": "",
        "SelectedCaste": casteNameController.text,
        "CorresTerritoryType": territoryController.text == "Urban" ? 2 : 1,
        "RoleId": 4,
        "RegistrationType": "DirectRegistrationByDeptUserByMobile",
        "DeviceId": deviceId,
        "JobList": jobList
      };

      ApiResponse response =
      await commonRepo.post(
        "JobFairEvent/RegJobFairEventDayForJobSeekersSaveData",
        body,
      );

      if (response.response?.statusCode ==
          200) {

        var data = response.response?.data;

        if (data is String) {
          data = jsonDecode(data);
        }

        if (data["State"] == 200) {

          // showAlertSuccess(
          //   data["Message"],
          //   context,
          // );
          //
          // Navigator.pop(context);

          final model =
          JobFairRegistrationSaveModel.fromJson(
              data);

          if (model.state == 200 &&
              model.data != null &&
              model.data!.isNotEmpty) {

            final registration = model.data!.first;

            ProgressDialog.closeLoadingDialog(context);

            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (dialogContext) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Container(
                          height: 80,
                          width: 80,
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle,
                            color: Colors.green,
                            size: 50,
                          ),
                        ),

                        const SizedBox(height: 16),

                        const Text(
                          "Registration Successful",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 12),

                        Text(
                          registration.msg ?? "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.green
                          ),
                        ),

                        const SizedBox(height: 20),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: Colors.blue.shade200,
                            ),
                          ),
                          child: Column(
                            children: [

                              const Text(
                                "Job Fair Registration Number",
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),

                              const SizedBox(height: 8),

                              SelectableText(
                                registration.uniqueId ?? "",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        const Text(
                          "Attendance also marked successfully",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.green
                          ),
                        ),

                        const SizedBox(height: 24),

                        SizedBox(
                          width: double.infinity,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(dialogContext);
                              Navigator.pop(context);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text("OK"),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );

            return;
          }
        }
        else {
          showAlertError(
              data["Message"],
              context);
        }
      }
    }
    catch (e) {
      showAlertError(
          e.toString(),
          context);
    }
    finally {
      // ProgressDialog.closeLoadingDialog(
      //     context);
    }
  }

  void clearData() {
    nameController.clear();
    fNameController.clear();
    mobileController.clear();
    dateOfBirthController.clear();
    genderController.clear();
    emailController.clear();

    eventIdController.clear();
    eventNameController.clear();

    districtNameController.clear();
    districtIdController.clear();
    selectedDistrict = null;

    casteNameController.clear();
    casteIdController.clear();
    casteDistrict = null;

    territoryController.clear();

    educationLevelIdController.clear();
    educationLevelNameController.clear();

    classIdController.clear();
    classNameController.clear();

    graduationTypeIdController.clear();
    graduationTypeNameController.clear();

    sectorIdController.clear();
    sectorNameController.clear();

    jobTitleIdController.clear();
    jobTitleController.clear();

    // Clear lists if required
    graduationTypeList.clear();
    itiMainList.clear();

    notifyListeners();
  }

}

class DropdownItem {
  String dropID;
  String name;

  DropdownItem({required this.dropID, required this.name});
}