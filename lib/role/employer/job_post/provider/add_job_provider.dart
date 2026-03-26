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
import '../../../job_seeker/add_language_skills/modal/category_type_details_modal.dart';
import '../../../job_seeker/add_language_skills/modal/get_sub_category_type_details_modal.dart';
import '../../../job_seeker/add_language_skills/modal/upload_document_modal.dart';
import '../../../job_seeker/addjobpreference/modal/sector_modal.dart';
import '../../../job_seeker/job_fair_event/modal/event_name_modal.dart';
import '../modal/course_modal.dart';
import '../modal/education_type_modal.dart';
import '../modal/emp_type_modal.dart';
import '../modal/gender_modal.dart';
import '../modal/job_title_modal.dart';
import '../modal/location_modal.dart';
import '../modal/nature_job_modal.dart';
import '../modal/noc_code_modal.dart';
import '../modal/salary_range_modal.dart';

import 'package:http_parser/http_parser.dart';

import '../modal/save_job_post_modal.dart';

class SkillModel {

  String category;
  String categoryId;

  String subCategory;
  String subCategoryId;

  SkillModel({
    required this.category,
    required this.categoryId,
    required this.subCategory,
    required this.subCategoryId,
  });

}

class QualificationModel {

  String educationType;
  String educationTypeId;

  String course;
  String courseId;

  QualificationModel({
    required this.educationType,
    required this.educationTypeId,
    required this.course,
    required this.courseId,
  });

}

class AddJobProvider extends ChangeNotifier {

  final CommonRepo commonRepo;

  AddJobProvider({required this.commonRepo});

  //event
  List<EventNameData>  eventNameList = [];
  final TextEditingController  eventNameController = TextEditingController();
  final TextEditingController  eventIdController = TextEditingController();

  //sector
  List<SectorData>  sectorList = [];
  final TextEditingController  sectorIdController = TextEditingController();
  final TextEditingController  sectorNameController = TextEditingController();

  //job title
  List<JobTitleData>  jobTitleList = [];
  final TextEditingController  jobTitleIdController = TextEditingController();
  final TextEditingController  jobTitleController = TextEditingController();

  bool showJobTitleField = false;

  //NCO Code
  List<NcoCodeData>  ncoCodeList = [];
  final TextEditingController  ncoCodeIdController = TextEditingController();
  final TextEditingController  ncoCodeController = TextEditingController();

  File? selectedDocumentFile;
  String? uploadedDocumentPath;
  int? selectedDocumentMasterId;

  //gender
  List<GenderData> genderList = [];
  final TextEditingController  genderIdController = TextEditingController();
  final TextEditingController  genderController = TextEditingController();

  List<String> selectedGenders = [];

  /// Vacancy Controllers
  TextEditingController maleVacancyController = TextEditingController();
  TextEditingController femaleVacancyController = TextEditingController();
  TextEditingController transVacancyController = TextEditingController();
  TextEditingController totalVacancyController = TextEditingController();

  //Location
  List<LocationData> locationList = [];
  final TextEditingController  locationIdController = TextEditingController();
  final TextEditingController  locationController = TextEditingController();

  //Employement Type
  List<EmpTypeData> empTypeList = [];
  final TextEditingController  empTypeIdController = TextEditingController();
  final TextEditingController  empTypeController = TextEditingController();

  //Nature of Job
  List<NatureJobData> natureJobList = [];
  final TextEditingController  natureJobIdController = TextEditingController();
  final TextEditingController  natureJobController = TextEditingController();

  //Work Experience
  List<DropdownItem> workExpList = [
    DropdownItem(dropID: "0", name: "Any"),
    DropdownItem(dropID: "1", name: "Fresher"),
    DropdownItem(dropID: "2", name: "Experienced"),
  ];
  final TextEditingController  workExpIdController = TextEditingController();
  final TextEditingController  workExpController = TextEditingController();


  bool isExperienced = false;
  RangeValues experienceRange = const RangeValues(1, 30);


  //Salary Range
  List<SalaryRangeData> salaryRangeList = [];
  final TextEditingController  salaryRangeIdController = TextEditingController();
  final TextEditingController  salaryRangeController = TextEditingController();

  List<GetCategoryTypeDetailsData> categoryList = [];
  List<GetSubCategoryTypeDetailsData> subCategoryList = [];

  final TextEditingController categoryIdController = TextEditingController();
  final TextEditingController categoryNameController = TextEditingController();
  final TextEditingController subCategoryIdController = TextEditingController();
  final TextEditingController subCategoryNameController = TextEditingController();

  List<GetEducationTypeData> educationTypeList = [];
  List<GetCourseData> courseList = [];

  final TextEditingController educationIdController = TextEditingController();
  final TextEditingController educationNameController = TextEditingController();
  final TextEditingController courseIdController = TextEditingController();
  final TextEditingController courseNameController = TextEditingController();

  /// Radio values
  String exServiceman = "No";
  String nightShift = "No";
  String pwdJob = "No";

  /// Age range
  double minAge = 18;
  double maxAge = 60;

  /// File
  File? jobDescriptionFile;

  /// Static dropdown data (for now)
  List<String> events = ["Job Fair 2025", "Mega Job Fair"];
  List<String> sectors = ["IT", "Construction", "Manufacturing"];

  List<String> jobTitles = ["Helper", "Manager", "Operator"];
  List<String> ncoCodes = ["NCO001", "NCO002"];

  List<String> genders = ["Male", "Female", "Any"];
  List<String> locations = ["Jaipur", "Delhi", "Mumbai"];

  List<String> employmentTypes = ["Full Time", "Part Time"];
  List<String> natureJobs = ["Permanent", "Contract"];

  List<String> experiences = [
    "Fresher",
    "1-2 Years",
    "3-5 Years"
  ];


  /// Controllers
  final TextEditingController salaryController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  bool isCustomJobTitle = false;

  Future<EventNameModal?> getEventNameListApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get("MobileProfile/EventDetails/${UserData().model.value.userId.toString()}/${UserData().model.value.roleId.toString()}/2025");
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = EventNameModal.fromJson(responseData);
          eventNameList.clear();
          if (sm.state == 200) {
            eventNameList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = EventNameModal(state: 0, message: sm.message.toString());
            notifyListeners();
            //showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }

        } else {
          return EventNameModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = EventNameModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<SectorModal?> sectorListApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
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
          final sm = SectorModal.fromJson(responseData);
          sectorList.clear();
          if (sm.state == 200) {

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
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<GenderModal?> genderListApi(
      BuildContext context,
      ) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "Common/GetCommonMasterDDLByType";
        // ProgressDialog.showLoadingDialog(context);
        Map<String, dynamic> body = {
          "Type": "gender"
        };
        ApiResponse apiResponse = await commonRepo.post(url,body);
        //ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = GenderModal.fromJson(responseData);
          genderList.clear();
          if (sm.state == 200) {

            genderList.clear();
            genderList.add(
              GenderData(
                dropID: -1,
                name: "Any",
              ),
            );

            genderList.addAll(sm.data ?? []);
            notifyListeners();
            return sm;
          } else {
            return GenderModal(
              state: 0,
              message: sm.message.toString(),
            );
          }
        } else {
          return GenderModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = GenderModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  void toggleGender(String gender) {

    /// If ANY selected
    if (gender == "Any") {

      selectedGenders.clear();
      selectedGenders.add("Any");

    } else {

      /// Remove ANY if selecting individual gender
      selectedGenders.remove("Any");

      /// Toggle
      if (selectedGenders.contains(gender)) {
        selectedGenders.remove(gender);
      } else {
        selectedGenders.add(gender);
      }

      /// If all 3 selected → convert to ANY
      bool male = selectedGenders.contains("Male");
      bool female = selectedGenders.contains("Female");
      bool trans = selectedGenders.contains("TransGender");

      if (male && female && trans) {

        selectedGenders.clear();
        selectedGenders.add("Any");
      }
    }

    notifyListeners();
  }

  Future<NcoCodeModal?> ncoCodeListApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
       // String url = "Common/GetNCOTreeData";
        // ProgressDialog.showLoadingDialog(context);
        // Map<String, dynamic> body = {};
        // ApiResponse apiResponse = await commonRepo.post(url,body);
        ApiResponse apiResponse = await commonRepo.get("Common/GetNCOTreeData");
        //ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = NcoCodeModal.fromJson(responseData);
          ncoCodeList.clear();
          if (sm.state == 200) {

            ncoCodeList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = NcoCodeModal(state: 0, message: sm.message.toString());

            notifyListeners();
            //showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
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

  Future<void> pickAndUploadSingleDocument({
    required BuildContext context,
  }) async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result == null) return;

    final file = File(result.files.single.path!);

    /// File Size Validation
    final sizeInKB = (await file.length()) / 1024;

    if (sizeInKB > 300) {
      showAlertError("File size must be less than 300 KB", context);
      return;
    }

    /// Preview
    selectedDocumentFile = file;
    notifyListeners();

    String timestamp =
        "${DateTime.now().millisecondsSinceEpoch}.pdf";

    FormData param = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: timestamp,
        contentType: MediaType("application", "pdf"),
      ),
      "FileExtension": "application/pdf",
      "FolderName": "Employer/UploadedJobPostDocument",
      "MaxFileSize": "307200",
      "MinFileSize": "0",
      "Password": "",
    });

    final res = await uploadDocumentApi(context, param);

    if (res != null && res.data != null && res.data!.isNotEmpty) {

      uploadedDocumentPath = res.data![0].fileName;

      debugPrint("Uploaded File: $uploadedDocumentPath");

      notifyListeners();
    }
  }

  Future<UploadDocumentModal?> uploadDocumentApi(
      BuildContext context, FormData inputText) async {

    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
      return null;
    }

    try {
      ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.uploadDocumentRepo(
        "Common/UploadDocument",
        inputText,
      );

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response != null &&
          apiResponse.response?.statusCode == 200) {

        var responseData = apiResponse.response?.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        return UploadDocumentModal.fromJson(responseData);
      } else {
        showAlertError("Something went wrong", context);
        return null;
      }
    } catch (e) {
      showAlertError(e.toString(), context);
      return null;
    }
  }

  Future<JobTitleModal?> jobTitleListApi(
      BuildContext context,
      int sectorId,
      ) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "ProfilJobSeekar/JobTitleDetailsData";
        // ProgressDialog.showLoadingDialog(context);
        Map<String, dynamic> body = {
          "JobSectorId": sectorId
        };
        ApiResponse apiResponse = await commonRepo.post(url,body);
        //ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = JobTitleModal.fromJson(responseData);
          jobTitleList.clear();
          if (sm.state == 200) {

            jobTitleList.addAll(sm.data ?? []);
            notifyListeners();
            return sm;
          } else {
            return JobTitleModal(
              state: 0,
              message: sm.message.toString(),
            );
          }
        } else {
          return JobTitleModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = JobTitleModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<LocationModal?> locationListApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {

        ApiResponse apiResponse = await commonRepo.get("Common/CommonMasterDataByCode/PreferredLocation/0/0");
        //ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = LocationModal.fromJson(responseData);
          locationList.clear();
          if (sm.state == 200) {

            locationList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = LocationModal(state: 0, message: sm.message.toString());

            notifyListeners();
            //showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return LocationModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = LocationModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<EmpTypeModal?> empTypeListApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {

        ApiResponse apiResponse = await commonRepo.get("Common/CommonMasterDataByCode/EmploymentType/0/0");
        //ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = EmpTypeModal.fromJson(responseData);
          empTypeList.clear();
          if (sm.state == 200) {

            empTypeList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = EmpTypeModal(state: 0, message: sm.message.toString());

            notifyListeners();
            //showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return EmpTypeModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = EmpTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<NatureJobModal?> natureJobListApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {

        ApiResponse apiResponse = await commonRepo.get("Common/CommonMasterDataByCode/DesiredJobType/0/0");
        //ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = NatureJobModal.fromJson(responseData);
          natureJobList.clear();
          if (sm.state == 200) {

            natureJobList.addAll(sm.data!);
            notifyListeners();
            return sm;
          } else {
            final smmm = NatureJobModal(state: 0, message: sm.message.toString());

            notifyListeners();
            //showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return NatureJobModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = NatureJobModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<SalaryRangeModal?> salaryRangeListApi(
      BuildContext context,
      ) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "Common/GetCommonMasterDDLByType";
        // ProgressDialog.showLoadingDialog(context);
        Map<String, dynamic> body = {
          "Type": "SalaryRangeJobPost"
        };
        ApiResponse apiResponse = await commonRepo.post(url,body);
        //ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = SalaryRangeModal.fromJson(responseData);
          salaryRangeList.clear();
          if (sm.state == 200) {

            salaryRangeList.addAll(sm.data ?? []);
            notifyListeners();
            return sm;
          } else {
            return SalaryRangeModal(
              state: 0,
              message: sm.message.toString(),
            );
          }
        } else {
          return SalaryRangeModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = SalaryRangeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<GetCategoryTypeDetailsModal?> getCategoryTypeDetailsApi(
      BuildContext context,
      ) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse =
        await commonRepo.get("MobileProfile/GetCategoryTypeDetails");
        //   ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = GetCategoryTypeDetailsModal.fromJson(responseData);

          if (sm.state == 200) {
            categoryList.clear();
            categoryList.addAll(sm.data!);

            //notifyListeners();
            return sm;
          } else {
            final smmm = GetCategoryTypeDetailsModal(
                state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return GetCategoryTypeDetailsModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //  ProgressDialog.closeLoadingDialog(context);
        final sm =
        GetCategoryTypeDetailsModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<GetSubCategoryTypeDetailsModal?> getSubCategoryTypeDetailsApi(
      BuildContext context, String id) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse =
        await commonRepo.get("MobileProfile/GetSubCategoryTypeDetails/$id");
        //   ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = GetSubCategoryTypeDetailsModal.fromJson(responseData);

          if (sm.state == 200) {
            subCategoryList.clear();
            subCategoryList.addAll(sm.data!);
            notifyListeners();

            //
            return sm;
          } else {
            final smmm = GetSubCategoryTypeDetailsModal(
                state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return GetSubCategoryTypeDetailsModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //  ProgressDialog.closeLoadingDialog(context);
        final sm =
        GetSubCategoryTypeDetailsModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<GetEducationTypeModal?> getEducationTypeApi(
      BuildContext context,
      ) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse =
        await commonRepo.get("Common/GetQualificationList");
        //   ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = GetEducationTypeModal.fromJson(responseData);

          if (sm.state == 200) {
            educationTypeList.clear();
            educationTypeList.addAll(sm.data!);

            //notifyListeners();
            return sm;
          } else {
            final smmm = GetEducationTypeModal(
                state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return GetEducationTypeModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //  ProgressDialog.closeLoadingDialog(context);
        final sm =
        GetEducationTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<GetCourseModal?> getCourseApi(
      BuildContext context, String id) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse =
        await commonRepo.get("Common/GetGraduationType/$id");
        //   ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = GetCourseModal.fromJson(responseData);

          if (sm.state == 200) {
            courseList.clear();
            courseList.addAll(sm.data!);
            notifyListeners();

            //
            return sm;
          } else {
            final smmm = GetCourseModal(
                state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return GetCourseModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        //  ProgressDialog.closeLoadingDialog(context);
        final sm =
        GetCourseModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  List<int> getSalaryLimit(String range) {
    final cleaned = range
        .replaceAll("₹", "")
        .replaceAll(" ", "")
        .toUpperCase();

    // ✅ HANDLE "ABOVE" CASE
    if (cleaned.contains("ABOVE")) {
      final value = cleaned.replaceAll("ABOVE", "").replaceAll("K", "");

      int start = int.tryParse(value) ?? 0;
      start = start * 1000;

      return [start, 999999999]; // max limit
    }

    // ✅ NORMAL RANGE CASE (e.g. 10K-20K)
    List<String> parts = cleaned.split('-');

    int start = int.tryParse(parts[0].replaceAll('K', '')) ?? 0;
    int end = int.tryParse(parts[1].replaceAll('K', '')) ?? 0;

    return [start * 1000, end * 1000];
  }

  Future<SaveJobPostModal?> saveJobDetailApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {

      try {
        String ? IpAddress =  await UtilityClass.getIpAddress();
        int male = 0;
        int female = 0;
        int trans = 0;
        int total = 0;

        if (selectedGenders.contains("Any")) {

          total = int.tryParse(totalVacancyController.text) ?? 0;

        } else {

          male = int.tryParse(maleVacancyController.text) ?? 0;
          female = int.tryParse(femaleVacancyController.text) ?? 0;
          trans = int.tryParse(transVacancyController.text) ?? 0;

          total = male + female + trans;
        }

        List<int> salaryLimit =
        getSalaryLimit(salaryRangeController.text);

        String? deviceId = await UtilityClass.getDeviceId();

        Map<String, dynamic> bodyy =
        {
          "ActionName": "Insert",
          "UserId": UserData().model.value.userId,
          "RoleId": UserData().model.value.roleId,
          "AgeGroupLimit": [
            minAge.round(),
            maxAge.round()
          ],
          "CloseDate": "",
          "CreationDate": "",
          "Description": descriptionController.text,
          "Event": int.tryParse(eventIdController.text) ?? 0,
          "GraduationTypes": qualifications
              .map((e) => int.tryParse(e.course) ?? 0)
              .toList(),
          "JobPositionTitle": jobTitleController.text,
          "JobSector": int.tryParse(sectorIdController.text) ?? 0,
          "JobTitle": int.tryParse(jobTitleIdController.text) ?? 0,
          "NCOCode": ncoCodeIdController.text,
          "NoofVacancyFeMale": female,
          "NoofVacancyMale": male,
          "NoofVacancyOther": trans,
          "TotalVacancy": total,
          "SkillCatId": skills
              .map((e) => e.category)
              .toSet()
              .join(","),
          "SkillSubCatId": skills
              .map((e) => int.tryParse(e.subCategory) ?? 0)
              .toList(),
          "qualificationId": 0,
          "JobPostPKID": 0,
          "SalaryLimit": salaryLimit,
          "JodDescriptionDocument": uploadedDocumentPath ?? "",
          "DocumentmasterID": 0,
          "PreLocation": locationIdController.text,
          "Employmenttype": int.tryParse(empTypeIdController.text) ?? 0,
          "NatureOfJob": int.tryParse(natureJobIdController.text) ?? 0,
          "WorkExperience": workExpController.text,
          "TotalWorkExperience": 0,

          "_AddedSkilList": skills.map((e) => {
            "SkillName": e.category,
            "SkillID": int.tryParse(e.categoryId) ?? 0,
            "SkillsubcateName": e.subCategory,
            "SubcateID": int.tryParse(e.subCategoryId) ?? 0
          }).toList(),

          "_AddedEducationDetailList": qualifications.map((e) => {
            "EducationType": e.educationType,
            "EducationTypeID": int.tryParse(e.educationTypeId) ?? 0,
            "GraducationType": e.course,
            "GraducationTypeID": int.tryParse(e.courseId) ?? 0
          }).toList(),
          "ExperienceLimit": isExperienced
              ? [
            experienceRange.start.round(),
            experienceRange.end.round()
          ]
              : [0, 0],
          "ExServiceman": exServiceman == "Yes",
          "NightShift": nightShift == "Yes",
          "GenderId": genderIdController.text,
          "SalaryRangeId": int.tryParse(salaryRangeIdController.text) ?? 0,
          "Salary": int.tryParse(salaryController.text) ?? 0,
          "PostDateforAd": "2026-03-12T12:51:37.388Z",
          "IsPwd": pwdJob == "Yes",
          "JobPostedForId": 0,
          "InternshipDuration": "string",
          "OfferStipend": false,
          "StipendAmount": 0,
          "DeviceID": deviceId
        };


        print("printFullData -->");
        printFullJson(bodyy);
// return null;

        String url = "JobFairEvent/SaveDataCreateJob";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post(url,bodyy);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = SaveJobPostModal.fromJson(responseData);
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
            final smmm = SaveJobPostModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return SaveJobPostModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = SaveJobPostModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  void printFullJson(Map<String, dynamic> json) {
    const encoder = JsonEncoder.withIndent('  ');
    final prettyString = encoder.convert(json);
    prettyString.split('\n').forEach((line) => debugPrint(line));
  }

  /// Age update
  void updateAge(RangeValues values) {
    minAge = values.start;
    maxAge = values.end;
    notifyListeners();
  }

  /// Radio updates
  void setExServiceman(String value) {
    exServiceman = value;
    notifyListeners();
  }

  void setNightShift(String value) {
    nightShift = value;
    notifyListeners();
  }

  void setPwdJob(String value) {
    pwdJob = value;
    notifyListeners();
  }

  /// Skills
  List<SkillModel> skills = [];

  /// Qualifications
  List<QualificationModel> qualifications = [];

  /// Temporary dropdown selections
  String? selectedSkillCategory;
  String? selectedSkillSubCategory;

  String? selectedEducationType;
  String? selectedCourse;

  /// File picker
  // Future pickJobDescriptionFile() async {
  //
  //   final result = await FilePicker.platform.pickFiles();
  //
  //   if (result != null) {
  //     jobDescriptionFile = File(result.files.single.path!);
  //     notifyListeners();
  //   }
  // }

  /// Submit
  void postJob(BuildContext context) {

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Job posted successfully"),
      ),
    );
  }

  void addSkill() {

    if (selectedSkillCategory == null || selectedSkillSubCategory == null) {
      return;
    }

    skills.add(
      SkillModel(
        category: categoryNameController.text,
        categoryId: categoryIdController.text,

        subCategory: subCategoryNameController.text,
        subCategoryId: subCategoryIdController.text,
      ),
    );

    categoryNameController.clear();
    subCategoryNameController.clear();

    selectedSkillCategory = null;
    selectedSkillSubCategory = null;

    notifyListeners();
  }

  void removeSkill(int index) {
    skills.removeAt(index);
    notifyListeners();
  }

  void addQualification() {

    qualifications.add(
      QualificationModel(
        educationType: educationNameController.text,
        educationTypeId: educationIdController.text,

        course: courseNameController.text,
        courseId: courseIdController.text,
      ),
    );

    notifyListeners();
  }

  void removeQualification(int index) {
    qualifications.removeAt(index);
    notifyListeners();
  }

  void clearData() {
    eventNameList.clear();
    eventNameController.clear();
    eventIdController.clear();

    sectorList.clear();
    sectorNameController.clear();
    sectorIdController.clear();

    jobTitleList.clear();
    jobTitleController.clear();
    jobTitleIdController.clear();

    ncoCodeList.clear();
    ncoCodeController.clear();
    ncoCodeIdController.clear();

    uploadedDocumentPath = "";
    selectedDocumentFile = null;

    genderList.clear();
    genderController.clear();
    genderIdController.clear();

    /// Reset gender selection
    selectedGenders.clear();

    /// Clear vacancy fields
    maleVacancyController.clear();
    femaleVacancyController.clear();
    transVacancyController.clear();
    totalVacancyController.clear();

    locationList.clear();
    locationController.clear();
    locationIdController.clear();

    empTypeList.clear();
    empTypeIdController.clear();
    empTypeController.clear();

    natureJobList.clear();
    natureJobIdController.clear();
    natureJobController.clear();

    // workExpList.clear();
    workExpController.clear();
    workExpIdController.clear();

    exServiceman = "No";
    nightShift = "No";
    pwdJob = "No";

    //Salary Range
    salaryRangeList.clear();
    salaryRangeIdController.clear();
    salaryRangeController.clear();

    salaryController.clear();

    categoryList.clear();
    categoryIdController.clear();
    categoryNameController.clear();

    subCategoryList.clear();
    subCategoryIdController.clear();
    subCategoryNameController.clear();

    skills.clear();

    //Education Type
    educationTypeList.clear();
    educationIdController.clear();
    educationNameController.clear();

    //Course Type
    courseList.clear();
    courseIdController.clear();
    courseNameController.clear();

    qualifications.clear();

    descriptionController.clear();

    notifyListeners();
  }

}

class DropdownItem {
  String dropID;
  String name;

  DropdownItem({required this.dropID, required this.name});
}