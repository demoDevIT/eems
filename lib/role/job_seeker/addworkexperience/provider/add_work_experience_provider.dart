import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/role/job_seeker/addworkexperience/modal/jobt_type_modal.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../../addeducationaldetail/modal/nco_code_modal.dart';
import '../../addjobpreference/modal/employment_type_modal.dart';
import '../../workexperience/modal/delete_work_experience_list_modal.dart';
import '../modal/city_modal.dart';
import '../modal/district_modal.dart';
import '../modal/employment_type_modal.dart';
import '../modal/nature_of_employment_modal.dart';
import '../modal/save_work_experience_modal.dart';
import '../modal/state_modal.dart';
import 'package:collection/collection.dart';

class AddWorkExperienceProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  bool isEditMode = false;

  WorkExperienceListData? editWorkData;

  AddWorkExperienceProvider({required this.commonRepo});

  final List<String> experienceTypesList = ['Yes', 'No'];
  final List<String> workingCompanyList = ['Yes', 'No'];
  String experienceTypes = 'No'; // default selection
  String workingCompanyType = 'No'; // default selection

// State & District Lists
  List<StateData> stateList = [];
  List<DistrictData> districtList = [];
  List<CityData> locationList = [];

  StateData? selectedState;
  DistrictData? selectedDistrict;
  CityData? selectedCity;

  bool isDistrictLoading = false;

  // placeholder

// Controllers
  final TextEditingController stateIdController = TextEditingController();
  final TextEditingController stateNameController = TextEditingController();

  final TextEditingController districtIdController = TextEditingController();
  final TextEditingController districtNameController = TextEditingController();

// Location dropdown
  final TextEditingController locationIdController = TextEditingController();
  final TextEditingController locationNameController = TextEditingController();

  List<WorkExpEmploymentTypeData> employmentTypesList = [];
  List<WorkExpEmploymentTypeData> originalEmploymentTypesList = [];
  List<JobtTypeData> jobTypeList = [];
  List<NatureofEmploymentData> natureEmploymentList = [];
  List<NcoCodeData> ncoCodeList = [];

  final TextEditingController employmentTypeIdController =
      TextEditingController();
  final TextEditingController employmentTypeNameController =
      TextEditingController();
  final TextEditingController jobTitleIdController = TextEditingController();
  final TextEditingController jobTitleNameController = TextEditingController();
  final TextEditingController companyNameController = TextEditingController();
  final TextEditingController fromDateController = TextEditingController();
  final TextEditingController toDateController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController jobTypeIdController = TextEditingController();
  final TextEditingController jobTypeNameController = TextEditingController();
  final TextEditingController employmentNatureIdController =
      TextEditingController();
  final TextEditingController employmentNatureNameController =
      TextEditingController();
  final TextEditingController ncoIdController = TextEditingController();
  final TextEditingController ncoNameController = TextEditingController();
  final TextEditingController responsibilitiesController =
      TextEditingController();
  final TextEditingController employedInPastController =
      TextEditingController();

  Future<void> initWorkExperienceApis(
      BuildContext context, bool isUpdate, WorkExperienceListData? data, {
        bool hideExperienceQuestion = false, // new parameter
      }) async {

    isEditMode = isUpdate; // 🔥 SET FIRST
    editWorkData = data;

    // 🔥 FORCE EXPERIENCE = YES FOR EDIT
    if (isUpdate || hideExperienceQuestion) {
      experienceTypes = "Yes";
      employedInPastController.text = "Yes";
    }

    await stateApi(context, isUpdate, data);
    await ncoCodeApi(context, isUpdate, data);

    // 🔥 APPLY FILTER ONLY AFTER APIs + FLAGS
    employmentFilterList();

    // 🔥 NOW APPLY EDIT DATA
    if (isUpdate && data != null) {
      updateData(data);
    }

    // if (data != null) {
    //   debugPrint(
    //     "WORK EXPERIENCE DATA (FULL) => ${jsonEncode(data.toJson())}",
    //   );
    // }
  }

  Future<StateModal?> stateApi(
    BuildContext context,
    bool isUpdate,
    WorkExperienceListData? work,
  ) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
      return null;
    }

    try {
      ProgressDialog.showLoadingDialog(context);
      ApiResponse apiResponse = await commonRepo.get("Common/GetStateMaster");
      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response?.statusCode == 200) {
        var responseData = apiResponse.response?.data;
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        print("STATE COUNT => ${stateList.length}");
        print(
            "FIRST STATE => ${stateList.isNotEmpty ? stateList.first.name : 'EMPTY'}");

        final sm = StateModal.fromJson(responseData);
        if (sm.state == 200) {
          stateList.clear();
          stateList.addAll(sm.data ?? []);

          if (isUpdate && work != null) {
            selectedState = stateList.firstWhereOrNull(
              (e) => e.iD == work.stateId,
            );

            if (selectedState != null) {
              stateIdController.text = selectedState!.iD.toString();
              stateNameController.text = selectedState!.name!;

              await getDistrictApi(context, selectedState!.iD!);
            }
          }

          notifyListeners();
          return sm;
        }
      }
    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
    }
    return null;
  }

  Future<void> getDistrictApi(BuildContext context, int stateId) async {
    isDistrictLoading = true;
    notifyListeners();

    try {
      final apiResponse =
          await commonRepo.get("Common/DistrictMaster_StateIDWise/$stateId");

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;

        // ✅ HANDLE BOTH STRING & MAP
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        districtList.clear();

        if (responseData['Data'] != null) {
          for (var e in responseData['Data']) {
            districtList.add(DistrictData.fromJson(e));
          }
        }
        print("EDIT DISTRICT ID => ${editWorkData?.districtId}");

        // ✅ PRESELECT DISTRICT (EDIT MODE)
        if (editWorkData?.districtId != null) {
          selectedDistrict = districtList.firstWhereOrNull(
            (e) => e.iD == editWorkData!.districtId,
          );
        }

        print("DISTRICT COUNT => ${districtList.length}");
      }
    } catch (e) {
      print("DISTRICT API ERROR => $e");
      districtList.clear();
    }

    isDistrictLoading = false;
    notifyListeners();
  }

  Future<void> getCityApi(BuildContext context, String districtCode) async {
    try {
      final apiResponse =
          await commonRepo.get("Common/GetCityMaster/$districtCode");

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;

        // ✅ HANDLE STRING RESPONSE SAFELY
        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        locationList.clear();

        if (responseData['Data'] != null) {
          for (var e in responseData['Data']) {
            locationList.add(CityData.fromJson(e));
          }
        }

        print("CITY COUNT => ${locationList.length}");
        notifyListeners();
      }
    } catch (e) {
      print("CITY API ERROR => $e");
      locationList.clear();
      notifyListeners();
    }
  }

  Future<NcoCodeModal?> ncoCodeApi(BuildContext context, bool isUpdate,
      WorkExperienceListData? workExperience) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get("Common/GetNCOTreeData");
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = NcoCodeModal.fromJson(responseData);

          if (sm.state == 200) {
            ncoCodeList.clear();
            ncoCodeList.addAll(sm.data!);

            employmentTypeApi(context, isUpdate, workExperience);

            //  notifyListeners();
            return sm;
          } else {
            final smmm = NcoCodeModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return NcoCodeModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = NcoCodeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<WorkExpEmploymentTypeModal?> employmentTypeApi(BuildContext context,
      bool isUpdate, WorkExperienceListData? workExperience, {String defaultExperience = "Yes"}) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse =
            await commonRepo.get("Common/GetEmploymenType");
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = WorkExpEmploymentTypeModal.fromJson(responseData);

          if (sm.state == 200) {
            employmentTypesList.clear();
            originalEmploymentTypesList.clear();
            originalEmploymentTypesList.addAll(sm.data!);
            // Always keep original
            originalEmploymentTypesList.clear();
            originalEmploymentTypesList.addAll(sm.data!);

// Do NOT filter here
            employmentTypesList = List.from(originalEmploymentTypesList);

// Filtering happens ONLY here:
            employmentFilterList();


            jobTypeApi(context, isUpdate, workExperience);
            notifyListeners();
            return sm;
          } else {
            final smmm = WorkExpEmploymentTypeModal(
                state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return WorkExpEmploymentTypeModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm =
            WorkExpEmploymentTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<JobtTypeModal?> jobTypeApi(BuildContext context, bool isUpdate,
      WorkExperienceListData? workExperience) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo
            .get("Common/CommonMasterDataByCode/DesiredJobType/0/0");
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = JobtTypeModal.fromJson(responseData);

          if (sm.state == 200) {
            jobTypeList.clear();
            jobTypeList.addAll(sm.data!);

            natureOfEmploymentApi(context, isUpdate, workExperience);

            //notifyListeners();
            return sm;
          } else {
            final smmm =
                JobtTypeModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return JobtTypeModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = JobtTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<NatureofEmploymentModal?> natureOfEmploymentApi(BuildContext context,
      bool isUpdate, WorkExperienceListData? workExperience) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo
            .get("Common/CommonMasterDataByCode/CourseNature/0/0");
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = NatureofEmploymentModal.fromJson(responseData);
          if (sm.state == 200) {
            natureEmploymentList.clear();
            natureEmploymentList.addAll(sm.data!);
            if (isUpdate == true) {
              updateData(workExperience);
            } else {
              notifyListeners();
            }
            return sm;
          } else {
            final smmm = NatureofEmploymentModal(
                state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return NatureofEmploymentModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = NatureofEmploymentModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<SaveWorkExperienceModal?> saveWorkExperienceApi(
      BuildContext context, bool isUpdate, String? employmentID) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String? IpAddress = await UtilityClass.getIpAddress();
        Map<String, dynamic> body = {
          "CompanyName": companyNameController.text,
          "EmployedInPast": "0",
          "EmploymentID": isUpdate == true ? employmentID : "0",
          "Employmenttype": employmentTypeIdController.text.isNotEmpty
              ? employmentTypeIdController.text
              : "0",
          "EndDate": toDateController.text,
          "JobType": jobTypeIdController.text.isNotEmpty
              ? jobTypeIdController.text
              : "0",
          "FirstDate": fromDateController.text,
          "IsCurrentWorking": workingCompanyType == "Yes" ? "1" : "0",
          "IsExperinced": experienceTypes == "Yes" ? "1" : "0",
          "JobTitle": jobTitleNameController.text,
          // "Location": locationController.text,
          "NCOCode":
              ncoIdController.text.isNotEmpty ? ncoIdController.text : "0",
          "NatureofEmployment": employmentNatureIdController.text.isNotEmpty
              ? employmentNatureIdController.text
              : "0",
          "Responsibilities": "Testinf",
          "UserID": UserData().model.value.userId.toString(),
          "stateId": stateIdController.text,
          "DistrictId": districtIdController.text,
          "Location": locationIdController.text,
        };

/*
        {"UserID":324,"qualification":"2","Class":"9","School":"cccc","university":"0","stream":"0","medium":"69","Grade":"75","percentage":"0","passingyear":"2025-01","CGPA":"0","board":"0","Course":"73","NCOCode":"8223.72","ResultType":"146","Graduationtype":"0","College":null,"EducationID":"0","OtherEducationUniversity":"","OtherMediumEducation":"","OtherGraduationType":""};
*/

        String url = "MobileProfile/SaveWorkExperience";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post(url, body);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = SaveWorkExperienceModal.fromJson(responseData);
          if (sm.state == 200) {
            successDialog(
              context,
              sm.message.toString(),
              (value) {
                print(value);
                if (value.toString() == "success") {
                  Navigator.of(context).pop("success");
                  //showAlertSuccess(AppLocalizations.of(context)!.login_successfully, context);
                }
              },
            );

            return sm;
          } else {
            final smmm = SaveWorkExperienceModal(
                state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return SaveWorkExperienceModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = SaveWorkExperienceModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  // employmentFilterList() {
  //   if (experienceTypes == "No") {
  //     // Filter only ID = 1
  //     employmentTypesList =
  //         employmentTypesList.where((item) => item.dropID == 1).toList();
  //
  //     print("Filtered (ID = 1): ${employmentTypesList.length}");
  //   } else {
  //     // Show all (restore original full list)
  //     employmentTypesList = List.from(originalEmploymentTypesList);
  //
  //     print("All items: ${employmentTypesList.length}");
  //   }
  //   notifyListeners();
  // }

  employmentFilterList() {
    // 🟢 EDIT MODE → NEVER SHOW STUDENT
    if (isEditMode) {
      employmentTypesList =
          originalEmploymentTypesList.where((e) => e.dropID != 1).toList();
      return;
    }

    if (experienceTypes == "No") {
      employmentTypesList =
          originalEmploymentTypesList.where((e) => e.dropID == 1).toList();

      if (employmentTypesList.isNotEmpty) {
        employmentTypeNameController.text =
            employmentTypesList.first.name ?? "";
        employmentTypeIdController.text =
            employmentTypesList.first.dropID.toString();
      }
    } else {
      // ✅ HIDE STUDENT
      employmentTypesList =
          originalEmploymentTypesList.where((e) => e.dropID != 1).toList();

      if (!isEditMode) {
        employmentTypeNameController.clear();
        employmentTypeIdController.clear();
      }

      // employmentTypeNameController.clear();
      // employmentTypeIdController.clear();
    }

    notifyListeners();
  }




  updateData(WorkExperienceListData? workExperience) {
//    experienceTypes = workExperience!.isExperinced.toString();
    experienceTypes = workExperience!.isExperinced == 1 ? "Yes" : "No";

    workingCompanyType =
        workExperience.isCurrentWorking.toString() == "true" ? "Yes" : "No";
    employmentFilterList();
    employmentTypeIdController.text = workExperience.employmentID.toString();
    employmentTypeNameController.text =
        workExperience.employmentName.toString();
    jobTitleNameController.text = workExperience.jobTitle.toString();
    companyNameController.text = workExperience.empolyer.toString();
    fromDateController.text = workExperience.jobStartDate.toString();
    toDateController.text = workExperience.jobEndDate.toString() == "Present"
        ? currentDate()
        : workExperience.jobEndDate.toString();
    locationController.text = workExperience.address.toString();
    jobTypeIdController.text = workExperience.jobTypeId.toString();
    jobTypeNameController.text = workExperience.jobType.toString();
    employmentNatureIdController.text =
        workExperience.natureofEmploymentId.toString();
    employmentNatureNameController.text =
        workExperience.natureofEmployment.toString();
    ncoIdController.text = workExperience.nCO.toString();
    ncoNameController.text =
        workExperience.nCOCode.toString().replaceAll("-", " ");
    responsibilitiesController.text =
        workExperience.jobResponsibilities.toString();

    notifyListeners();
  }

  void clearData() {
    // experienceTypes = 'No';
    experienceTypes = 'Yes';
    workingCompanyType = 'No';

    // Clear Lists
    employmentTypesList.clear();
    originalEmploymentTypesList.clear();
    jobTypeList.clear();
    natureEmploymentList.clear();
    ncoCodeList.clear();

    // Clear all controllers
    employmentTypeIdController.clear();
    employmentTypeNameController.clear();
    jobTitleIdController.clear();
    jobTitleNameController.clear();
    companyNameController.clear();
    fromDateController.clear();
    toDateController.clear();
    locationController.clear();
    jobTypeIdController.clear();
    jobTypeNameController.clear();
    employmentNatureIdController.clear();
    employmentNatureNameController.clear();
    ncoIdController.clear();
    ncoNameController.clear();
    responsibilitiesController.clear();

    stateList.clear();
    districtList.clear();

    stateIdController.clear();
    stateNameController.clear();
    districtIdController.clear();
    districtNameController.clear();
    locationIdController.clear();
    locationNameController.clear();

    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  addData() {}
}
