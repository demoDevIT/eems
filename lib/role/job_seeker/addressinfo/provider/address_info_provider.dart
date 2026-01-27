import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:rajemployment/role/job_seeker/addressinfo/modal/address_info_modal.dart';
import 'package:rajemployment/role/job_seeker/addressinfo/modal/communication_address_info_modal.dart';
import 'package:rajemployment/role/job_seeker/addressinfo/modal/ward_modal.dart';
import 'package:rajemployment/utils/global.dart';
import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/user_new.dart';
import '../../../../utils/utility_class.dart';
import '../modal/assembly_list_modal.dart';
import '../modal/city_modal.dart';
import '../modal/district_modal.dart';
import '../modal/parliament_list_modal.dart';
import '../modal/save_data_address_modal.dart';

class AddressInfoProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  AddressInfoProvider({required this.commonRepo});

  String territoryType = "Urban";
  String territoryTypeID = "2";
  String cTerritoryType = "Urban";
  String cTerritoryTypeID = "2";
  bool sameAsAbove = false;
  List<DistrictData> districtList = [];
  List<DistrictData> cDistrictList = [];
  List<CityData> cityList = [];
  List<CityData> cCityList = [];
  List<WardData> wardList = [];
  List<WardData> cWardList = [];
  List<AssemblyListData> assemblyList = [];
  List<ParliamentListData> parliamentListDataList = [];
  List<AddressInfoData> addressInfoList = [];
  List<CommunicationAddressInfoData> communicationAddressInfoList = [];
  final TextEditingController districtNameController = TextEditingController();
  final TextEditingController districtIdController = TextEditingController();
  final TextEditingController cityNameController = TextEditingController();
  final TextEditingController cityIdController = TextEditingController();
  final TextEditingController wardNameController = TextEditingController();
  final TextEditingController wardIdController = TextEditingController();
  final TextEditingController cDistrictNameController = TextEditingController();
  final TextEditingController cDistrictIdController = TextEditingController();
  final TextEditingController cCityNameController = TextEditingController();
  final TextEditingController cCityIdController = TextEditingController();
  final TextEditingController cWardNameController = TextEditingController();
  final TextEditingController cWardIdController = TextEditingController();
  final TextEditingController assemblyController = TextEditingController();
  final TextEditingController assemblyNameController = TextEditingController();
  final TextEditingController assemblyIDController = TextEditingController();
  final TextEditingController constituencyNameController =
      TextEditingController();
  final TextEditingController constituencyIDController =
      TextEditingController();
  final TextEditingController addressController =
      TextEditingController(text: "");
  final TextEditingController cAddressController = TextEditingController(
    text: "",
  );
  final TextEditingController cPinCodeController =
      TextEditingController(text: "");
  final TextEditingController pinCodeController =
      TextEditingController(text: "");

  Future<DistrictModal?> getDistrictMasterApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse =
            await commonRepo.get("Common/GetDistrictMaster");
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = DistrictModal.fromJson(responseData);

          if (sm.state == 200) {
            districtList.clear();
            cDistrictList.clear();
            districtList.addAll(sm.data!);
            cDistrictList.addAll(sm.data!);
            getProfileAddressInfoApi(
                context, UserData().model.value.userId.toString());
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
        ProgressDialog.closeLoadingDialog(context);
        final sm = DistrictModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<CityModal?> getCityMasterApi(
      BuildContext context, String districtId, bool isCommunication) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "Common/GetCityMaster/$districtId";
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
        // ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = CityModal.fromJson(responseData);
          if (sm.state == 200) {
            if (isCommunication == false) {
              cityList.clear();
              cityList.addAll(sm.data!);
            } else {
              cCityList.clear();
              cCityList.addAll(sm.data!);
            }

            notifyListeners();
            return sm;
          } else {
            final smmm = CityModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return CityModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = CityModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<WardModal?> getWardMasterApi(
      BuildContext context, String cityId, bool isCommunication) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "Common/GetWardMaster/$cityId";
        // ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
        //ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = WardModal.fromJson(responseData);
          if (sm.state == 200) {
            if (isCommunication == false) {
              wardList.clear();
              wardList.addAll(sm.data!);
            } else {
              cWardList.clear();
              cWardList.addAll(sm.data!);
            }

            notifyListeners();
            return sm;
          } else {
            final smmm = WardModal(state: 0, message: sm.message.toString());
            //showAlertError(smmm.message.toString().isNotEmpty ? smmm.message.toString() : "Invalid SSO ID and Password", context);
            return smmm;
          }
        } else {
          return WardModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = WardModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<AssemblyListModal?> assemblyListApi(
      BuildContext context, String districtId) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "Common/GetAssemblyListByDistrictID/$districtId";
        //ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
        //ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = AssemblyListModal.fromJson(responseData);
          if (sm.state == 200) {
            assemblyList.clear();
            assemblyList.addAll(sm.data!);

            notifyListeners();
            return sm;
          } else {
            final smmm =
                AssemblyListModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return AssemblyListModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        // ProgressDialog.closeLoadingDialog(context);
        final sm = AssemblyListModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<ParliamentListModal?> getParliamentListApi(BuildContext context,
      String assemblyId, String districtId, String pCode, String pName) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String url = "Common/GetParliamentByAssemblyId/$assemblyId/$districtId";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.get(url);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = ParliamentListModal.fromJson(responseData);
          if (sm.state == 200) {
            parliamentListDataList.clear();
            parliamentListDataList.addAll(sm.data!);
            // if (pCode.isNotEmpty && pName.isNotEmpty) {
            //   print(pCode);
            //   print(pName);
            //   constituencyIDController.text = pCode;
            //   constituencyNameController.text = pName;
            // }

            if (pCode.isNotEmpty) {
              try {
                final selectedParliament = parliamentListDataList.firstWhere(
                      (e) => e.dropID.toString() == pCode,
                );

                constituencyIDController.text =
                    selectedParliament.dropID.toString();
                constituencyNameController.text =
                    selectedParliament.name.toString();
              } catch (e) {
                debugPrint("Parliament not found");
              }
            }


            notifyListeners();
            return sm;
          } else {
            final smmm =
                ParliamentListModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return ParliamentListModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = ParliamentListModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<AddressInfoModal?> getProfileAddressInfoApi(
      BuildContext context, String userId) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {"UserID": userId};
        String url = "MobileProfile/ProfileAddressInfo";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post(url, body);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = AddressInfoModal.fromJson(responseData);
          if (sm.state == 200) {
            addressInfoList.clear();
            addressInfoList.addAll(sm.data!);
            districtIdController.text =
                addressInfoList[0].dISTRICTCODE.toString();
            districtNameController.text =
                addressInfoList[0].dISTRICTENG.toString();
            cityIdController.text = addressInfoList[0].cITYCODE.toString();
            cityNameController.text = addressInfoList[0].cITYENG.toString();
            wardIdController.text = addressInfoList[0].wARDCODE.toString();
            wardNameController.text = addressInfoList[0].wARDENG.toString();
            addressController.text = addressInfoList[0].address.toString();
            pinCodeController.text = addressInfoList[0].pincode.toString();
            territoryType =
                addressInfoList[0].territoryType == 1 ? "Rural" : "Urban";
            territoryTypeID = addressInfoList[0].territoryType.toString();
            final selectedRole = districtList.firstWhere(
                (item) => item.dropID.toString() == districtIdController.text);
            //assemblyListApi(context, selectedRole.dISTRICTID.toString());
            profileCommunicationAddressInfoApi(context, userId);
            notifyListeners();
            return sm;
          } else {
            final smmm =
                AddressInfoModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return AddressInfoModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = AddressInfoModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<CommunicationAddressInfoModal?> profileCommunicationAddressInfoApi(
      BuildContext context, String userId) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        Map<String, dynamic> body = {"UserID": userId};
        String url = "MobileProfile/ProfileCommunicationAddressInfo";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post(url, body);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = CommunicationAddressInfoModal.fromJson(responseData);
          if (sm.state == 200) {
            communicationAddressInfoList.clear();
            communicationAddressInfoList.addAll(sm.data!);
            cDistrictIdController.text =
                communicationAddressInfoList[0].dISTRICTCODE.toString();
            cDistrictNameController.text =
                communicationAddressInfoList[0].dISTRICTENG.toString();
            cCityIdController.text =
                communicationAddressInfoList[0].cITYCODE.toString();
            cCityNameController.text =
                communicationAddressInfoList[0].cITYENG.toString();
            cWardIdController.text =
                communicationAddressInfoList[0].wARDCODE.toString();
            cWardNameController.text =
                communicationAddressInfoList[0].wARDENG.toString();
            cAddressController.text =
                communicationAddressInfoList[0].address.toString();
            cPinCodeController.text =
                communicationAddressInfoList[0].pincode.toString();
            cTerritoryType = communicationAddressInfoList[0].territoryType == 1
                ? "Rural"
                : "Urban";
            cTerritoryTypeID =
                communicationAddressInfoList[0].territoryType.toString();
            assemblyIDController.text =
                communicationAddressInfoList[0].assemblyCode.toString();
            assemblyNameController.text =
                communicationAddressInfoList[0].aCENG.toString();

            print("assemblyIDController-> $assemblyIDController");
            print("assemblyNameController-> $assemblyNameController");

            sameAsAbove = communicationAddressInfoList[0].sameASPermanent == 0
                ? false
                : true;
            final selectedRole = districtList.firstWhere((item) =>
                item.dropID.toString() ==
                communicationAddressInfoList[0].dISTRICTCODE.toString());
            getCityMasterApi(context,
                communicationAddressInfoList[0].dISTRICTCODE.toString(), true);
            getWardMasterApi(context,
                communicationAddressInfoList[0].cITYCODE.toString(), true);
            //assemblyListApi(context, selectedRole.dISTRICTID.toString());
            await assemblyListApi(context, selectedRole.dISTRICTID.toString());

            final assemblyCode =
            communicationAddressInfoList[0].assemblyCode.toString();
            // AFTER list is loaded
            try {
              final selectedAssembly = assemblyList.firstWhere(
                    (e) => e.dropID.toString() ==
                    communicationAddressInfoList[0].assemblyCode.toString(),
              );

              assemblyIDController.text =
                  selectedAssembly.dropID.toString();
              assemblyNameController.text =
                  selectedAssembly.name.toString();
            } catch (e) {
              debugPrint("Assembly not found");
            }

            getParliamentListApi(
                context,
                communicationAddressInfoList[0].assemblyCode.toString(),
                selectedRole.dISTRICTID.toString(),
                communicationAddressInfoList[0].parliamentCode.toString(),
                communicationAddressInfoList[0].pCENG.toString());
            notifyListeners();
            return sm;
          } else {
            final smmm = CommunicationAddressInfoModal(
                state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return CommunicationAddressInfoModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm =
            CommunicationAddressInfoModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<SaveDataAddressModal?> saveDataAddressApi(BuildContext context) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        String? IpAddress = await UtilityClass.getIpAddress();
        Map<String, dynamic> body = {
          "UserID": UserData().model.value.userId.toString(),
          "DistrictId": cDistrictIdController.text,
          "BlockId": null,
          "PanchayatId": null,
          "VillageId": null,
          "CityId": cCityIdController.text,
          "WardId": cWardIdController.text,
          "Pincode": cPinCodeController.text,
          "TerritoryType": territoryType == "Rural" ? "1" : "2",
          "ParliamentCode": constituencyIDController.text,
          "AssemblyCode": assemblyIDController.text,
          "Address": cAddressController.text,
          "CreatedBy": UserData().model.value.userId.toString(),
          "IsActive": 1,
          "IPAddress": IpAddress,
          "IPAddressv6": IpAddress,
        };
        String url = "MobileProfile/SaveDataAddress";
        ProgressDialog.showLoadingDialog(context);
        ApiResponse apiResponse = await commonRepo.post(url, body);
        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = SaveDataAddressModal.fromJson(responseData);
          if (sm.state == 200) {
            successDialog(
              context,
              sm.message.toString(),
              (value) {
                print(value);
                if (value.toString() == "success") {
                  Navigator.of(context).pop();
                  //showAlertSuccess(AppLocalizations.of(context)!.login_successfully, context);
                }
              },
            );

            return sm;
          } else {
            final smmm =
                SaveDataAddressModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          return SaveDataAddressModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = SaveDataAddressModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  clearData() {
    territoryType = "Urban";
    cTerritoryType = "Urban";
    sameAsAbove = false;
    districtList.clear();
    cDistrictList.clear();
    cityList.clear();
    wardList.clear();
    assemblyList.clear();
    parliamentListDataList.clear();
    districtNameController.clear();
    districtIdController.clear();
    cityNameController.clear();
    cityIdController.clear();
    wardNameController.clear();
    wardIdController.clear();
    cDistrictNameController.clear();
    cDistrictIdController.clear();
    cCityNameController.clear();
    cCityIdController.clear();
    cWardNameController.clear();
    cWardIdController.clear();
    assemblyController.clear();
    assemblyNameController.clear();
    assemblyIDController.clear();
    constituencyNameController.clear();
    constituencyIDController.clear();
    addressController.clear();
    cAddressController.clear();
    cPinCodeController.clear();
    pinCodeController.clear();
    notifyListeners();
  }
}
