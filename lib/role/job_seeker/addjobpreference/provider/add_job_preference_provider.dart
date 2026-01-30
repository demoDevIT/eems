import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/role/job_seeker/addjobpreference/modal/desired_job_type_modal.dart';
import 'package:rajemployment/role/job_seeker/addjobpreference/modal/employment_type_modal.dart';
import 'package:rajemployment/role/job_seeker/addjobpreference/modal/language_type_modal.dart';
import 'package:rajemployment/role/job_seeker/addjobpreference/modal/region_modal.dart';
import 'package:rajemployment/role/job_seeker/addjobpreference/modal/sector_modal.dart';
import 'package:rajemployment/role/job_seeker/addjobpreference/modal/shift_type_modal.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/utility_class.dart';
import '../../addeducationaldetail/modal/nco_code_modal.dart';
import '../../jobpreference/modal/job_preference_modal.dart';
import '../modal/preferred_location_type_modal.dart';
import '../modal/salary_range_modal.dart';
import '../modal/save_data_job_preference_modal.dart';

class AddJobPreferenceProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  AddJobPreferenceProvider({required this.commonRepo});

  // Range slider values
  RangeValues salaryRange = const RangeValues(5000, 200000);

  // International job radio
  //String international = 'No';

  // Controllers
   final TextEditingController ncoCodeIdController = TextEditingController();
  final TextEditingController ncoCodeNameController = TextEditingController();
  final TextEditingController sectorIdController = TextEditingController();
  final TextEditingController sectorNameController = TextEditingController();
  final TextEditingController preferredLocationIdController = TextEditingController();
  final TextEditingController preferredLocationNameController = TextEditingController();
  final TextEditingController employmentTypeIdController = TextEditingController();
  final TextEditingController employmentTypeNameController = TextEditingController();
  final TextEditingController jobTypeIdController = TextEditingController();
  final TextEditingController jobTypeNameController = TextEditingController();
  final TextEditingController shiftIdController = TextEditingController();
  final TextEditingController shiftNameController = TextEditingController();
  final TextEditingController preferredRegionIdController = TextEditingController();
  final TextEditingController preferredRegionNameController = TextEditingController();
  final TextEditingController languageKnownIdController = TextEditingController();
  final TextEditingController languageKnownNameController = TextEditingController();
  //List
  List<NcoCodeData> ncoCodeList = [];
  List<SectorData> sectorList = [];
  List<PreferredLocationTypeData> preferredLocationList = [];
  List<EmploymentTypeData> employmentTypeList = [];
  List<DesiredJobTypeData> jobTypeList = [];
  List<ShiftTypeData> shiftList = [];
  List<RegionData> preferredRegionList = [];
  List<LanguageTypeData> languageKnownList = [];

  final TextEditingController salaryRangeIdController = TextEditingController();
  final TextEditingController salaryRangeNameController = TextEditingController();

  List<SalaryRangeData> salaryRangeList = [];
  String isInternationalJob = "2"; // default No



  Future<SalaryRangeModal?> salaryRangeApi(
      BuildContext context, bool isUpdate, JobPreferenceData? jobPreferenceData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (!isInternet) {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
      return null;
    }

    try {
      String url = "Common/CommonMasterDataByCode/SalaryRangeJC/1/0";
      ProgressDialog.showLoadingDialog(context);
      ApiResponse apiResponse = await commonRepo.get(url);
      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response?.statusCode == 200) {
        var responseData = apiResponse.response?.data;
        if (responseData is String) responseData = jsonDecode(responseData);

        final sm = SalaryRangeModal.fromJson(responseData);
        if (sm.state == 200) {
          salaryRangeList.clear();
          salaryRangeList.addAll(sm.data!);

          if (isUpdate && jobPreferenceData != null) {
            salaryRangeIdController.text =
                jobPreferenceData.salaryENUM.toString();

            final match = salaryRangeList.firstWhere(
                  (e) => e.enumValue.toString() == jobPreferenceData.salaryENUM.toString(),
              orElse: () => SalaryRangeData(),
            );

            salaryRangeNameController.text = match.name ?? "";

            // salaryRangeNameController.text =
            //     jobPreferenceData.salaryRangeName.toString();
          }

          notifyListeners();

          // Continue flow
          shiftListApi(context, isUpdate, jobPreferenceData);
          return sm;
        }
      }
    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
    }
    return null;
  }


  Future<NcoCodeModal?> ncoCodeApi(BuildContext context,bool isUpdate, JobPreferenceData? jobPreferenceData) async {
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

            sectorListApi(context,isUpdate,jobPreferenceData);



            //notifyListeners();
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

  Future<SaveDataJobPreferenceModal?> saveJobPreferenceApi(BuildContext context,bool isUpdate,String jobPreferenceID) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    print("AddJobPreferenceScreen → providerrrr page: $isInternationalJob");
    if (isInternet) {
      try {
        String ? IpAddress =  await UtilityClass.getIpAddress();
        Map<String, dynamic> body =

        //last these parameters got from Amit Tripathi
        {
          "ActionName":"Job Preference",
          "UserId": UserData().model.value.userId.toString(),
          "JobSeekarId": UserData().model.value.jobSeekerID.toString(),
          "CreatedBy" : UserData().model.value.userId.toString(),
          "Sector": sectorIdController.text.isNotEmpty ? sectorIdController.text : "0",
          "PreRole": "0",
          "PreLocation": preferredLocationIdController.text.isNotEmpty ? preferredLocationIdController.text:"0",
          "Employmenttype": employmentTypeIdController.text.isNotEmpty ? employmentTypeIdController.text:"0",
          "JobType": jobTypeIdController.text.isNotEmpty ? jobTypeIdController.text :"0",
          "Shift": shiftIdController.text.isNotEmpty ? shiftIdController.text : "0",
          "NCOCode": ncoCodeIdController.text.isNotEmpty ? ncoCodeIdController.text:"0",
          "IsInternationalJob": isInternationalJob,
          "PreferredRegion": preferredRegionIdController.text.isNotEmpty ? preferredRegionIdController.text :"0",
          "ForeignLanguageKnown": languageKnownIdController.text.isNotEmpty ? languageKnownIdController.text : "0",
          "JobPreferenceID": isUpdate == true ? jobPreferenceID : "0",
          //"Salary": [salaryRange.start.toInt(), salaryRange.end.toInt()],
          "SalaryEnumValue":
          salaryRangeIdController.text.isNotEmpty
              ? salaryRangeIdController.text
              : "0",
          "IsActive":"1",
          "IPAddress":"192.168.10.58",
          "IPAddressv6":"fe80::dd8f:3204:9dba:62ba%2"
        }
        ;
        String url = "MobileProfile/SaveJobPreference";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post(url,body);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = SaveDataJobPreferenceModal.fromJson(responseData);
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
            final smmm = SaveDataJobPreferenceModal(state: 0, message: sm.message.toString());
            showAlertError(sm.errorMessage.toString(), context);
            return smmm;
          }
        } else {
          return SaveDataJobPreferenceModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = SaveDataJobPreferenceModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<SectorModal?> sectorListApi(BuildContext context,bool isUpdate, JobPreferenceData? jobPreferenceData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "MobileProfile/SectorDetailsData";
        ProgressDialog.showLoadingDialog(context);
        Map<String, dynamic> body = {};
        ApiResponse apiResponse = await commonRepo.post(url,body);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = SectorModal.fromJson(responseData);
          if (sm.state == 200) {
            sectorList.clear();
            sectorList.addAll(sm.data!);
            preferredLocationTypeApi(context,isUpdate,jobPreferenceData);


           // notifyListeners();
            return sm;
          } else {
            final smmm = SectorModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return SectorModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = SectorModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<PreferredLocationTypeModal?> preferredLocationTypeApi(BuildContext context,bool isUpdate, JobPreferenceData? jobPreferenceData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "Common/CommonMasterDataByCode/PreferredLocationType/0/0";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = PreferredLocationTypeModal.fromJson(responseData);
          if (sm.state == 200) {
            preferredLocationList.clear();
            preferredLocationList.addAll(sm.data!);

            desiredJobTypeListApi(context,isUpdate,jobPreferenceData);


           // notifyListeners();
            return sm;
          } else {
            final smmm = PreferredLocationTypeModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return PreferredLocationTypeModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
         ProgressDialog.closeLoadingDialog(context);
        final sm = PreferredLocationTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<DesiredJobTypeModal?> desiredJobTypeListApi(BuildContext context,bool isUpdate, JobPreferenceData? jobPreferenceData )async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "Common/CommonMasterDataByCode/DesiredJobType/0/0";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = DesiredJobTypeModal.fromJson(responseData);
          if (sm.state == 200) {
            jobTypeList.clear();
            jobTypeList.addAll(sm.data!);
           // shiftListApi(context,isUpdate,jobPreferenceData);
            salaryRangeApi(context,isUpdate,jobPreferenceData);



            // notifyListeners();
            return sm;
          } else {
            final smmm = DesiredJobTypeModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return DesiredJobTypeModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = DesiredJobTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<ShiftTypeModal?> shiftListApi(BuildContext context,bool isUpdate, JobPreferenceData? jobPreferenceData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "Common/CommonMasterDataByCode/ShiftType/0/0";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = ShiftTypeModal.fromJson(responseData);
          if (sm.state == 200) {
            shiftList.clear();
            shiftList.addAll(sm.data!);

            regionListApi(context,isUpdate,jobPreferenceData);

            //notifyListeners();
            return sm;
          } else {
            final smmm = ShiftTypeModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return ShiftTypeModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = ShiftTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<RegionModal?> regionListApi(BuildContext context,bool isUpdate, JobPreferenceData? jobPreferenceData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "Common/CommonMasterDataByCode/Region/0/0";
       ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = RegionModal.fromJson(responseData);
          if (sm.state == 200) {
            preferredRegionList.clear();
            preferredRegionList.addAll(sm.data!);
            languageTypeModaltApi(context,isUpdate,jobPreferenceData);

           // notifyListeners();
            return sm;
          } else {
            final smmm = RegionModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return RegionModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
       ProgressDialog.closeLoadingDialog(context);
        final sm = RegionModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<LanguageTypeModal?> languageTypeModaltApi(BuildContext context,bool isUpdate, JobPreferenceData? jobPreferenceData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {};
        String url = "MobileProfile/ProfileLanguageType";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post(url,body);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = LanguageTypeModal.fromJson(responseData);
          if (sm.state == 200) {
            languageKnownList.clear();
            languageKnownList.addAll(sm.data!);
            employmenTypeApi(context,isUpdate,jobPreferenceData);
            //notifyListeners();
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
        ProgressDialog.closeLoadingDialog(context);
        final sm = LanguageTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<EmploymentTypeModal?> employmenTypeApi(BuildContext context,bool isUpdate, JobPreferenceData? jobPreferenceData) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {};
        String url = "Common/CommonMasterDataByCode/CourseNature/0/0";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
         ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null && apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = EmploymentTypeModal.fromJson(responseData);
          if (sm.state == 200) {
            employmentTypeList.clear();
            employmentTypeList.addAll(sm.data!);
            if (isUpdate && jobPreferenceData != null) {
              autoFillData(context, jobPreferenceData);
            }
           // else{
              notifyListeners();
           // }

            return sm;
          } else {
            final smmm = EmploymentTypeModal(state: 0, message: sm.message.toString());
            showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return EmploymentTypeModal(state: 0, message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = EmploymentTypeModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(AppLocalizations.of(context)!.internet_connection, context);
    }
  }


  @override
  void dispose() {
    super.dispose();
  }

  autoFillData(BuildContext context,JobPreferenceData? jobPreferenceData) {
   // salaryRange =  RangeValues(jobPreferenceData!.salarymin, jobPreferenceData!.salarymax);
     salaryRangeIdController.text = jobPreferenceData!.salaryENUM.toString();

    // salaryRangeNameController.text = jobPreferenceData.salaryENUM.toString();

    sectorIdController.text = jobPreferenceData.sectorId.toString();
    sectorNameController.text = jobPreferenceData.sectorName.toString();
    preferredLocationIdController.text = jobPreferenceData.preLocation.toString();
    preferredLocationNameController.text = jobPreferenceData.preLocationName.toString();
    preferredLocationNameController.text = jobPreferenceData.preLocationName.toString();
    employmentTypeIdController.text = jobPreferenceData.employmenttype.toString();
    employmentTypeNameController.text = jobPreferenceData.employmenttypeName.toString();
    jobTypeIdController.text = jobPreferenceData.jobType.toString();
    jobTypeNameController.text = jobPreferenceData.jobTypeName.toString();
    shiftIdController.text = jobPreferenceData.shift.toString();
    shiftNameController.text = jobPreferenceData.shiftName.toString();
    ncoCodeIdController.text = jobPreferenceData.nCO.toString();
    ncoCodeNameController.text = jobPreferenceData.nCOCode.toString().replaceAll("-", " ");
    preferredRegionIdController.text = jobPreferenceData.preferredRegion.toString();
    preferredRegionNameController.text = jobPreferenceData.preferredRegionName.toString();
    languageKnownIdController.text = jobPreferenceData.foreignLanguageKnown.toString();
    languageKnownNameController.text = jobPreferenceData.foreignLanguageName.toString();
    //international = jobPreferenceData.isInternationalJob.toString()== "1" ? "Yes" : "No";
    notifyListeners();
  }

  clearData() {
    salaryRange = const RangeValues(5000, 200000);
    salaryRangeIdController.clear();
    salaryRangeNameController.clear();
    salaryRangeList.clear();

   // international = 'No';
   ncoCodeIdController.clear();
   ncoCodeNameController.clear();
   sectorIdController.clear();
   sectorNameController.clear();
   preferredLocationIdController.clear();
   preferredLocationNameController.clear();
   employmentTypeIdController.clear();
   employmentTypeNameController.clear();
   jobTypeIdController.clear();
   jobTypeNameController.clear();
   shiftIdController.clear();
   shiftNameController.clear();
   preferredRegionIdController.clear();
   preferredRegionNameController.clear();
   languageKnownIdController.clear();
   languageKnownNameController.clear();
   ncoCodeList.clear();
   sectorList.clear();
   preferredLocationList.clear();
   employmentTypeList.clear();
   jobTypeList.clear();
   shiftList.clear();
   preferredRegionList.clear();
   languageKnownList.clear();
   notifyListeners();
  }
}
