import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/global.dart';
import '../../../../utils/user_new.dart';
import '../../../../utils/utility_class.dart';
import '../../../job_seeker/add_language_skills/modal/category_type_details_modal.dart';
import '../../../job_seeker/add_language_skills/modal/get_sub_category_type_details_modal.dart';
import '../../../job_seeker/addjobpreference/modal/sector_modal.dart';
import '../../../job_seeker/job_fair_event/modal/event_name_modal.dart';
import '../modal/emp_type_modal.dart';
import '../modal/gender_modal.dart';
import '../modal/job_title_modal.dart';
import '../modal/location_modal.dart';
import '../modal/nature_job_modal.dart';
import '../modal/noc_code_modal.dart';
import '../modal/salary_range_modal.dart';

class SkillModel {
  String category;
  String subCategory;

  SkillModel({
    required this.category,
    required this.subCategory,
  });
}

class QualificationModel {
  String educationType;
  String course;

  QualificationModel({
    required this.educationType,
    required this.course,
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

  //gender
  List<GenderData> genderList = [];
  final TextEditingController  genderIdController = TextEditingController();
  final TextEditingController  genderController = TextEditingController();

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

  List<SkillModel> selectedSkills = [];

  final TextEditingController skillCategoryController = TextEditingController();
  final TextEditingController skillCategoryIdController = TextEditingController();

  final TextEditingController skillSubCategoryController = TextEditingController();
  final TextEditingController skillSubCategoryIdController = TextEditingController();

  /// Dropdown values
  String? eventList;
  String? sector;
  String? jobTitle;
  String? ncoCode;
  String? gender;
  String? jobLocation;
  String? employmentType;
  String? natureOfJob;
  String? workExperience;
  String? salaryRange;

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

  List<String> salaryRanges = ["10k-15k", "15k-25k", "25k-40k"];

  List<DropdownItem> skillCategories = [
    DropdownItem(id: "1", name: "IT"),
    DropdownItem(id: "2", name: "Construction"),
    DropdownItem(id: "3", name: "Manufacturing"),
  ];
  List<DropdownItem> skillSubCategories = [
    DropdownItem(id: "1", name: "Developer"),
    DropdownItem(id: "2", name: "Electrician"),
    DropdownItem(id: "3", name: "Operator"),
  ];

  List<String> educationTypes = ["10th", "12th", "Graduate"];
  List<String> courses = ["BA", "BSc", "BCom"];

  List<String> skillCatList = ["IT", "Construction", "Manufacturing"];
  List<String> skillSubCatList = ["Developer", "Electrician", "Operator"];

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

  // void addSkill() {
  //
  //   if (selectedSkillCategory == null || selectedSkillSubCategory == null) {
  //     return;
  //   }
  //
  //   skills.add(
  //     SkillModel(
  //       category: selectedSkillCategory!,
  //       subCategory: selectedSkillSubCategory!,
  //     ),
  //   );
  //
  //   selectedSkillCategory = null;
  //   selectedSkillSubCategory = null;
  //
  //   skillCategoryController.clear();
  //   skillSubCategoryController.clear();
  //
  //   notifyListeners();
  // }

  // void removeSkill(int index) {
  //   skills.removeAt(index);
  //   notifyListeners();
  // }

  void addSkill() {

    if (selectedSkillCategory == null || selectedSkillSubCategory == null) {
      return;
    }

    skills.add(
      SkillModel(
        category: selectedSkillCategory!,
        subCategory: selectedSkillSubCategory!,
      ),
    );

    selectedSkillCategory = null;
    selectedSkillSubCategory = null;

    notifyListeners();
  }

  void removeSkill(int index) {
    skills.removeAt(index);
    notifyListeners();
  }

  void addQualification() {

    if (selectedEducationType == null || selectedCourse == null) {
      return;
    }

    qualifications.add(
      QualificationModel(
        educationType: selectedEducationType!,
        course: selectedCourse!,
      ),
    );

    selectedEducationType = null;
    selectedCourse = null;

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

    skillCategories.clear();
    skillCategoryController.clear();
    skillCategoryIdController.clear();

    skillSubCategories.clear();
    skillSubCategoryController.clear();
    skillSubCategoryIdController.clear();

    notifyListeners();
  }

}

class DropdownItem {
  String id;
  String name;

  DropdownItem({required this.id, required this.name});
}