import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:rajemployment/role/job_seeker/addeducationaldetail/modal/board_modal.dart';
import 'package:rajemployment/role/job_seeker/addeducationaldetail/modal/course_nature.dart';
import 'package:rajemployment/role/job_seeker/addeducationaldetail/modal/grade_type.dart';
import 'package:rajemployment/role/job_seeker/addeducationaldetail/modal/passing_year_modal.dart';
import 'package:rajemployment/role/job_seeker/addeducationaldetail/modal/stream_type_modal.dart';
import 'package:rajemployment/role/job_seeker/addeducationaldetail/modal/university_modal.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';
import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../../educationdetail/modal/profile_qualication_info_list_modal.dart';
import '../modal/education_level_modal.dart';
import '../modal/graduation_type_modal.dart';
import '../modal/medium_type_modal.dart';
import '../modal/nco_code_modal.dart';
import '../modal/save_data_education_modal.dart';

class AddEducationalDetailProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  AddEducationalDetailProvider({required this.commonRepo});




  // Result type
  String resultType = 'Percentage';
  TextEditingController percentageController = TextEditingController();
  TextEditingController cgpaController = TextEditingController();
 // String resultType = "Percentage"; // default


  List<EducationLevelData> educationLevelsList = [];
  List<NcoCodeData> ncoCodeList = [];
  List<GraduationTypeData> graduationTypeList = [];
  List<GraduationTypeData> classList = [];
  List<BoardData> boardList = [];
  List<UniversityData> universityList = [];
  List<CourseNatureData> courseNatureList = [];
  List<MediumTypeData> mediumTypeList = [];
  List<PassingYearData> passingYearList= [];
  List<StreamTypeData> streamTypeList = [];
  List<GradeTypeData> gradeTypeList = [];

  final TextEditingController educationLevelIdController = TextEditingController();
  final TextEditingController educationLevelNameController = TextEditingController();
  final TextEditingController classIdController = TextEditingController();
  final TextEditingController classNameController = TextEditingController();
  final TextEditingController ncoCodeIdController = TextEditingController();
  final TextEditingController ncoCodeNameController = TextEditingController();
  final TextEditingController schoolNameController = TextEditingController();
  final TextEditingController mediumEducationIdController = TextEditingController();
  final TextEditingController mediumEducationNameController = TextEditingController();
  final TextEditingController natureOfCourseIdController = TextEditingController();
  final TextEditingController natureOfCourseNameController = TextEditingController();
  final TextEditingController yearOfPassingIdController = TextEditingController();
  final TextEditingController yearOfPassingNameController = TextEditingController();
  final TextEditingController boardIdController = TextEditingController();
  final TextEditingController boardNameController = TextEditingController();
  final TextEditingController streamIdController = TextEditingController();
  final TextEditingController streamNameController = TextEditingController();
  final TextEditingController graduationTypeIdController = TextEditingController();
  final TextEditingController graduationTypeNameController = TextEditingController();
  final TextEditingController universityIdController = TextEditingController();
  final TextEditingController universityNameController = TextEditingController();
  final TextEditingController collageIdController = TextEditingController();
  final TextEditingController collageNameController = TextEditingController();
  final TextEditingController gradeTypeIdController = TextEditingController();
  final TextEditingController gradeTypeNameController = TextEditingController();
  final TextEditingController otherMediumEducationController = TextEditingController();
  final TextEditingController otherGraduationTypeController = TextEditingController();
  final TextEditingController otherEducationUniversity = TextEditingController();





  Future<EducationLevelModal?> educationLevelApi(BuildContext context, bool isUpdate, ProfileQualicationInfoData? profileData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get("Common/GetQualificationList");
        ProgressDialog.closeLoadingDialog(context);
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
            if (isUpdate && profileData != null) {
              // 🔥 FIND MATCHING ITEM
              final selectedItem = educationLevelsList.firstWhere(
                    (e) => e.dropID.toString() == profileData.hightestEducationLevelID.toString(),
                orElse: () => educationLevelsList.first,
              );

              print("isUpdate && profileData != null");
              educationLevelIdController.text =
                  selectedItem.dropID.toString();
              educationLevelNameController.text =
                  selectedItem.name.toString();
            } else {
              print("elseee isUpdate && profileData != null");
              // default selection
              educationLevelIdController.text =
                  educationLevelsList.first.dropID.toString();
              educationLevelNameController.text =
                  educationLevelsList.first.name.toString();
            }

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
        ProgressDialog.closeLoadingDialog(context);
        final sm = EducationLevelModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<NcoCodeModal?> ncoCodeApi(BuildContext context, bool isUpdate, ProfileQualicationInfoData? profileData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
       // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get("Common/GetNCOTreeData");
       // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = NcoCodeModal.fromJson(responseData);

          if (sm.state == 200) {
            ncoCodeList.clear();
            ncoCodeList.addAll(sm.data!);

            /// 🔥 PRESELECT AFTER LIST LOADED
            if (isUpdate && profileData?.nCO != null) {
              final selectedItem = ncoCodeList.firstWhere(
                    (e) => e.dropID == profileData!.nCO,
                orElse: () => ncoCodeList.first,
              );

              ncoCodeIdController.text =
                  selectedItem.dropID.toString();
              ncoCodeNameController.text =
                  selectedItem.name.toString();
            }
            // else if (ncoCodeIdController.text.isEmpty) {
            //   ncoCodeIdController.text =
            //       ncoCodeList.first.dropID.toString();
            //   ncoCodeNameController.text =
            //       ncoCodeList.first.name.toString();
            // }


            notifyListeners();
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
       // ProgressDialog.closeLoadingDialog(context);
        final sm = NcoCodeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<GraduationTypeModal?> graduationTypeApi(BuildContext context,String id,bool isUpdate, ProfileQualicationInfoData? profileData) async {
    print("classIDDDD=>$id");
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
      //  ProgressDialog.showLoadingDialog(context);
        String url = "Common/GetGraduationType/$id";
        ApiResponse apiResponse = await commonRepo.get(url);
      //  ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = GraduationTypeModal.fromJson(responseData);

          if (sm.state == 200) {
            if(id == "2"){
              classList.clear();
              classList.addAll(sm.data!);
              classList.sort((a, b) => a.dropID!.compareTo(b.dropID!));  // ascending

              if (isUpdate && profileData?.classID != null) {
                final selectedClass = classList.firstWhere(
                      (e) => e.dropID == profileData!.classID,
                  orElse: () => classList.first,
                );

                classIdController.text = selectedClass.dropID.toString();
                classNameController.text = selectedClass.name.toString();
              }

            }
            else{
              graduationTypeList.clear();
              graduationTypeList.addAll(sm.data!);
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

  Future<BoardModal?> boardApi(BuildContext context,bool isUpdate) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
       // ProgressDialog.showLoadingDialog(context);
        String url = "Common/Board_UniversityMaster/Board";
        ApiResponse apiResponse = await commonRepo.get(url);
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

  Future<StreamTypeModal?> streamTypeApi(BuildContext context,bool isUpdate) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        String url = "Common/CommonMasterDataByCode/StreamType/1";
        ApiResponse apiResponse = await commonRepo.get(url);
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


  Future<UniversityModal?> universityApi(BuildContext context,bool isUpdate) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        String url = "Common/Board_UniversityMaster/University";
        ApiResponse apiResponse = await commonRepo.get(url);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = UniversityModal.fromJson(responseData);

          if (sm.state == 200) {
            universityList.clear();
            universityList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = UniversityModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return UniversityModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = UniversityModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  Future<MediumTypeModal?> mediumOfEducationApi(BuildContext context,bool isUpdate, ProfileQualicationInfoData? profileData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        String url = "Common/CommonMasterDataByCode/MediumType/1";
        ApiResponse apiResponse = await commonRepo.get(url);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = MediumTypeModal.fromJson(responseData);
          if (sm.state == 200) {
            mediumTypeList.clear();
            mediumTypeList.addAll(sm.data!);

            notifyListeners();
            return sm;
          } else {
            final smmm = MediumTypeModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return MediumTypeModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = MediumTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  Future<CourseNatureModal?> courseNatureApi(BuildContext context,bool isUpdate, ProfileQualicationInfoData? profileData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        String url = "Common/CommonMasterDataByCode/CourseNature/1";
        ApiResponse apiResponse = await commonRepo.get(url);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = CourseNatureModal.fromJson(responseData);

          if(sm.state == 200) {
            courseNatureList.clear();
            courseNatureList.addAll(sm.data!);

            /// 🔥 PRESELECT HERE (AFTER LIST LOADED)
            if (isUpdate && profileData?.courseNature != null) {
              final selectedItem = courseNatureList.firstWhere(
                    (e) => e.dropID.toString() ==
                    profileData!.courseNature.toString(),
                orElse: () => courseNatureList.first,
              );

              natureOfCourseIdController.text =
                  selectedItem.dropID.toString();
              natureOfCourseNameController.text =
                  selectedItem.name.toString();
            }
            // else if (natureOfCourseIdController.text.isEmpty) {
            //   natureOfCourseIdController.text =
            //       courseNatureList.first.dropID.toString();
            //   natureOfCourseNameController.text =
            //       courseNatureList.first.name.toString();
            // }

            notifyListeners();
            return sm;
          } else {
            final smmm = CourseNatureModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return CourseNatureModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = CourseNatureModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  Future<PassingYearModal?> passingYearModalApi(BuildContext context,bool isUpdate, ProfileQualicationInfoData? profileData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        String url = "Common/CommonMasterDataByCode/PassingYear/1";
        ApiResponse apiResponse = await commonRepo.get(url);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = PassingYearModal.fromJson(responseData);

          if(sm.state == 200) {
            passingYearList.clear();
            passingYearList.addAll(sm.data!);

            notifyListeners();
            return sm;
          } else {
            final smmm = PassingYearModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return PassingYearModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = PassingYearModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<GradeTypeModal?> gradeTypeApi(BuildContext context,bool isUpdate, ProfileQualicationInfoData? profileData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //ProgressDialog.showLoadingDialog(context);
        String url = "Common/CommonMasterDataByCode/GradeType/1";
        ApiResponse apiResponse = await commonRepo.get(url);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = GradeTypeModal.fromJson(responseData);

          if(sm.state == 200) {
            gradeTypeList.clear();
            gradeTypeList.addAll(sm.data!);

            if (isUpdate &&
                profileData?.gradeID != null &&
                resultType == "Grade") {
              final selectedGrade = gradeTypeList.firstWhere(
                    (e) => e.dropID == profileData!.gradeID,
                orElse: () => gradeTypeList.first,
              );

              gradeTypeIdController.text =
                  selectedGrade.dropID.toString();
              gradeTypeNameController.text =
                  selectedGrade.name.toString();
            }

            notifyListeners();
            return sm;
          } else {
            final smmm = GradeTypeModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return GradeTypeModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = GradeTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  Future<SaveDataEducationModal?> saveDataEducationDetailsApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String ? IpAddress =  await UtilityClass.getIpAddress();
        List<Map<String, dynamic>> body = [
         /* {
            "qualification": educationLevelIdController.text,
            "Class": classIdController.text.isNotEmpty ? classIdController.text : "0",
            "UserID": UserData().model.value.userId.toString(),
            "board": boardIdController.text.isNotEmpty ? boardIdController.text : "0",
            "university": universityIdController.text.isNotEmpty ? universityIdController.text : "0",
            "stream": streamIdController.text.isNotEmpty ? streamIdController.text : "0",
            "medium": mediumEducationIdController.text.isNotEmpty ? mediumEducationIdController.text : "0",
            "Grade": gradeTypeIdController.text.isNotEmpty ? gradeTypeIdController.text : "0",
            "percentage": resultType == "Percentage" ? gradeTypeNameController.text : "0",
            "CGPA": resultType == "CGPA" ? gradeTypeNameController.text : "0",
            "ResultType": resultType == "Grade" ? "146" :resultType == "Percentage" ? "147" : "148",
            "School": schoolNameController.text.isNotEmpty ? schoolNameController.text :"",
            "Course": natureOfCourseIdController.text.isNotEmpty ? natureOfCourseIdController.text : "0",
            "NCOCode": ncoCodeIdController.text.isNotEmpty ? ncoCodeIdController.text : "0",
            "Graduationtype": graduationTypeIdController.text.isNotEmpty ? graduationTypeIdController.text : "0",
            "College": collageNameController.text.isNotEmpty ? collageNameController.text : "",
            "passingyear":"2025-11",
            "OtherMediumEducation": otherMediumEducationController.text.isNotEmpty ? otherMediumEducationController.text :"",
            "OtherGraduationType": otherGraduationTypeController.text.isNotEmpty ? otherGraduationTypeController.text : "",
            "OtherEducationUniversity": otherEducationUniversity.text.isNotEmpty ? otherEducationUniversity.text : "",
            "CreatedBy": UserData().model.value.userId.toString(),
            "EducationID": "0",
            "IsActive": 1,
            "IPAddress": IpAddress.toString(),
            "IPAddressv6": IpAddress.toString()
          }*/

        ];
        Map<String, dynamic> bodyy =
          {
            "qualification": educationLevelIdController.text,
            "Class": classIdController.text.isNotEmpty ? classIdController.text : "0",
            "UserID": UserData().model.value.userId.toString(),
            "board": boardIdController.text.isNotEmpty ? boardIdController.text : "0",
            "university": universityIdController.text.isNotEmpty ? universityIdController.text : "0",
            "stream": streamIdController.text.isNotEmpty ? streamIdController.text : "0",
            "medium": mediumEducationIdController.text.isNotEmpty ? mediumEducationIdController.text : "0",
            "Grade": gradeTypeIdController.text.isNotEmpty ? gradeTypeIdController.text : "0",
          //  "percentage": resultType == "Percentage" && gradeTypeNameController.text.isNotEmpty ? gradeTypeNameController.text : "0",
            "percentage": resultType == "Percentage" && percentageController.text.isNotEmpty
                ? percentageController.text
                : "0",

           // "CGPA": resultType == "CGPA" && gradeTypeNameController.text.isNotEmpty ? gradeTypeNameController.text : "0",
            "CGPA": resultType == "CGPA" && cgpaController.text.isNotEmpty
                ? cgpaController.text
                : "0",

            "ResultType": resultType == "Grade" ? "146" :resultType == "Percentage" ? "147" : "148",
            "School": schoolNameController.text.isNotEmpty ? schoolNameController.text :"",
            "Course": natureOfCourseIdController.text.isNotEmpty ? natureOfCourseIdController.text : "0",
            "NCOCode": ncoCodeIdController.text.isNotEmpty ? ncoCodeIdController.text : "0",
            "Graduationtype": graduationTypeIdController.text.isNotEmpty ? graduationTypeIdController.text : "0",
            "College": collageNameController.text.isNotEmpty ? collageNameController.text : "",
            "passingyear":yearOfPassingNameController.text.isNotEmpty ? yearOfPassingNameController.text :"0",
            "OtherMediumEducation": otherMediumEducationController.text.isNotEmpty ? otherMediumEducationController.text :"",
            "OtherGraduationType": otherGraduationTypeController.text.isNotEmpty ? otherGraduationTypeController.text : "",
            "OtherEducationUniversity": otherEducationUniversity.text.isNotEmpty ? otherEducationUniversity.text : "",
            "CreatedBy": UserData().model.value.userId.toString(),
            "EducationID": "0",
            "IsActive": 1,
            "IPAddress": IpAddress.toString(),
            "IPAddressv6": IpAddress.toString()

        };

/*
        {"UserID":324,"qualification":"2","Class":"9","School":"cccc","university":"0","stream":"0","medium":"69","Grade":"75","percentage":"0","passingyear":"2025-01","CGPA":"0","board":"0","Course":"73","NCOCode":"8223.72","ResultType":"146","Graduationtype":"0","College":null,"EducationID":"0","OtherEducationUniversity":"","OtherMediumEducation":"","OtherGraduationType":""};
*/

        print("bodyy=>$bodyy");


        String url = "MobileProfile/SaveDataQualification";
        ProgressDialog.showLoadingDialog(context);
       // ApiResponse apiResponse = await commonRepo.postArray(url,body);
        ApiResponse apiResponse = await commonRepo.post(url,bodyy);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = SaveDataEducationModal.fromJson(responseData);
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
            final smmm = SaveDataEducationModal(state: 0, message: sm.message.toString());
            showAlertError( sm.message.toString() , context); // previously sm.errorMessage.toString() was working , as changed in API by Amit Tripathi so i changed this errorMessage to message
            return smmm;
          }
        } else {
          return SaveDataEducationModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = SaveDataEducationModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }




  updateData(ProfileQualicationInfoData? profileData){

    if (profileData != null) {
      debugPrint("Profile Data JSON:");
      debugPrint(jsonEncode(profileData.toJson()));
    } else {
      debugPrint("Profile Data is null");
    }
    educationLevelIdController.text = profileData!.hightestEducationLevelID.toString();
    educationLevelNameController.text =  profileData.qualificationName.toString();
    classIdController.text = profileData.classID.toString();
    classNameController.text = profileData.className.toString();
    // ncoCodeIdController.text = profileData!.nCO.toString();
    // ncoCodeNameController.text = profileData.nCOCode.toString();
    schoolNameController.text = profileData.schoolName.toString();
    mediumEducationIdController.text = profileData.mediumID.toString();
    mediumEducationNameController.text = profileData.mediumName.toString();
    // natureOfCourseIdController.text = profileData.courseNature.toString();;
    // natureOfCourseNameController.text = profileData.courseNature.toString();
    yearOfPassingIdController.text = "";
    yearOfPassingNameController.text = profileData.passingYear.toString();
    boardIdController.text = profileData.boardID.toString();
    boardNameController.text = profileData.boardName.toString();
    streamIdController.text = profileData.streamID.toString();
    streamNameController.text = profileData.streamName.toString();
    graduationTypeIdController.text = "";
    graduationTypeNameController.text = "";
    universityIdController.text = profileData.universityID.toString();
    universityNameController.text = profileData.universityName.toString();
    collageIdController.text ="";
    collageNameController.text = profileData.collegeName.toString();
    // gradeTypeIdController.text = profileData.gradeID.toString();
    // gradeTypeNameController.text = profileData.gradeName.toString();
    otherMediumEducationController.text = "";
    otherGraduationTypeController.text = "";
    otherEducationUniversity.text = "";
    resultType = profileData.resultTypeName.toString();

    resultType = profileData.resultTypeName ?? "Percentage";

    if (resultType == "Grade") {
      gradeTypeIdController.text =
          profileData.gradeID?.toString() ?? "";
      gradeTypeNameController.text =
          profileData.gradeName ?? "";
    }

    if (resultType == "Percentage") {
      percentageController.text =
          profileData.percentage?.toString() ?? "";
    }

    if (resultType == "CGPA") {
      cgpaController.text =
          profileData.cGPA?.toString() ?? "";
    }

    notifyListeners();




  }







  @override
  void dispose() {
    super.dispose();
  }




  clearData() {
    // ---------- Reset result type ----------
    resultType = 'Percentage';
    // ---------- Clear lists ----------
    educationLevelsList.clear();
    ncoCodeList.clear();
    graduationTypeList.clear();
    classList.clear();
    boardList.clear();
    universityList.clear();
    courseNatureList.clear();
    mediumTypeList.clear();
    passingYearList.clear();
    streamTypeList.clear();
    gradeTypeList.clear();
    // ---------- Clear Text Controllers ----------
    educationLevelIdController.clear();
    educationLevelNameController.clear();
    classIdController.clear();
    classNameController.clear();
    ncoCodeIdController.clear();
    ncoCodeNameController.clear();
    schoolNameController.clear();
    mediumEducationIdController.clear();
    mediumEducationNameController.clear();
    natureOfCourseIdController.clear();
    natureOfCourseNameController.clear();
    yearOfPassingIdController.clear();
    yearOfPassingNameController.clear();
    boardIdController.clear();
    boardNameController.clear();
    streamIdController.clear();
    streamNameController.clear();
    graduationTypeIdController.clear();
    graduationTypeNameController.clear();
    universityIdController.clear();
    universityNameController.clear();
    collageIdController.clear();
    collageNameController.clear();
    gradeTypeIdController.clear();
    gradeTypeNameController.clear();
    otherMediumEducationController.clear();
    otherGraduationTypeController.clear();
    otherEducationUniversity.clear();
    percentageController.clear();
    cgpaController.clear();

    // ---------- You can add more reset logic here ----------
    // E.g. selected dropdown variables = null
    // selectedCourseNature = null;
    // selectedBoard = null;
    // selectedStream = null;

    notifyListeners();
  }
}
