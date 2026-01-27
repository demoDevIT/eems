import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:rajemployment/constants/constants.dart';
import 'package:rajemployment/utils/utility_class.dart';

import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../services/HttpService.dart';
import '../../../../utils/global.dart';
import '../../../../utils/progress_dialog.dart';
import '../../otr_form/modal/fetch_jan_adhar_modal.dart';
import '../../otr_form/otr_form.dart';
import '../janadhaarflowpage_screen.dart';
import '../modal/fetch_member_list_modal.dart';
import '../modal/generate_otp_modal.dart';

class JanAadhaarFlowProvider with ChangeNotifier {
  final CommonRepo commonRepo;

  JanAadhaarFlowProvider({required this.commonRepo});

  final TextEditingController janAadhaarController =
      TextEditingController(text: "1478552555");
  final FocusNode janAadhaarFocusNode = FocusNode();

  FlowStep currentStep = FlowStep.enterJanAadhaar;
  final TextEditingController otpController =
      TextEditingController(text: "9464");

  List<FetchJanAdharResponseData> feachJanAadhaarDataList = [];

  List<FetchMemberDataResponse> fetchMemberList = [];

  String memberID = "";
  String tid = "";

  Future<FetchMemberListModal?> fetchMembersListApi(
      BuildContext context, String janAadhaarNumber) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //5188248757
        // https://rajemployment.rajasthan.gov.in/mobileapi/api/NewJanAdharMobile
        //  in this URL, earlier 'NewJanAadharDetail/JanAdharDataNew?', now 'NewJanAdharMobile/JanAdharDataNew?'
        ProgressDialog.showLoadingDialog(context);
        Map<String, dynamic> body = {};
        ApiResponse apiResponse = await commonRepo.post(
            "NewJanAdharMobile/JanAdharDataNew?SchemeName=EEMS&sType=FetchMemberList&JanaadhaarNo=${janAadhaarNumber}",
            body);
        // ApiResponse apiResponse = await commonRepo.post(
        //   "${Constants.janAadhaarBaseUrl}"
        //       "NewJanAadharDetail/JanAdharDataNew"
        //       "?SchemeName=EEMS&sType=FetchMemberList&JanaadhaarNo=$janAadhaarNumber",
        //   {},
        // );

        ProgressDialog.closeLoadingDialog(context);

        print("res11 => ${apiResponse.response}");

        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          print("a1");

          print("STATUS CODE: ${apiResponse.response?.statusCode}");
          print("HEADERS: ${apiResponse.response?.headers}");
          print("RAW DATA: ${apiResponse.response?.data}");

          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = FetchMemberListModal.fromJson(responseData);

          notifyListeners();
          // if (sm.state == 200) { //test with live
            print("a2");
            if (sm.state == 1) { //test with sandbox
            fetchMemberList.clear();
            fetchMemberList.addAll(sm.data!.response!.data!);
            currentStep = FlowStep.memberList;
            notifyListeners();
            return sm;
          } else {
            print("a3");
            final smmm =
                FetchMemberListModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          print("a4");
          currentStep = FlowStep.memberList;
          fetchMemberList.addAll([
            FetchMemberDataResponse(
              mEMBERID: 45053402607,
              nAMEEN: "D*e*a* K*m*r G*p*a",
              mEMBERTYPE: "MEM",
            ),
            FetchMemberDataResponse(
              mEMBERID: 32687381288,
              nAMEEN: "J*o*i G*y*l",
              mEMBERTYPE: "HOF",
            ),
          ]);
          notifyListeners();
          return FetchMemberListModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = FetchMemberListModal(state: 0, message: err.toString());
        currentStep = FlowStep.memberList;
        print("a5");
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      print("a6");
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<GenerateOTPModal?> generateOTPApi(
      BuildContext context, String memberId) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //member id - 45053402607
        ProgressDialog.showLoadingDialog(context);
        Map<String, dynamic> body = {};
        ApiResponse apiResponse = await commonRepo.post(
            "NewJanAdharMobile/JanAdharDataNew?SchemeName=EEMS&sType=GenerateOTP&memberId=${memberId}",
            body);
        // ApiResponse apiResponse = await commonRepo.post(
        //   "${Constants.janAadhaarBaseUrl}"
        //       "NewJanAadharDetail/JanAdharDataNew"
        //       "?SchemeName=EEMS&sType=GenerateOTP&memberId=$memberId",
        //   {},
        // );

        ProgressDialog.closeLoadingDialog(context);
        print("resGenOTP => ${apiResponse.response}");
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) {
          print("b1");

          print("STATUS CODE: ${apiResponse.response?.statusCode}");
          print("HEADERS: ${apiResponse.response?.headers}");
          print("RAW DATA: ${apiResponse.response?.data}");

          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = GenerateOTPModal.fromJson(responseData);
          // if (sm.state == 400) {
          if (sm.state == 2) {
            print("b2");
            tid = sm.data!.response!.tid.toString();
            currentStep = FlowStep.otp;
            notifyListeners();
            return sm;
          } else {
            print("b3");
            final smmm =
                GenerateOTPModal(state: 0, message: sm.message.toString());
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          print("b4");
          tid = "7421";
          currentStep = FlowStep.otp;
          notifyListeners();
          return GenerateOTPModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = GenerateOTPModal(state: 0, message: err.toString());
        print("b5");
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      print("b6");
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  Future<void> validateOTPApiMock(
      BuildContext context,
      String memberId,
      String tid,
      String otp,
      String ssoId,
      String userID,
      ) async {
    // Simulate network delay
    await Future.delayed(Duration(seconds: 1));

    // Fixed mock response (your JSON)
    final Map<String, dynamic> mockResponse = {
      "State": 200,
      "Status": false,
      "Message": null,
      "ErrorMessage": null,
      "Data": {
        "response": {
          "status": true,
          "message": "OTP validated successfully",
          "responseCode": "JAN_200",
          "transactionId": "EEMS20260116741277",
          "schemeCode": "EEMS",
          "appCode": "PJAN4601237",
          "tid": "13364030",
          "data": [
            {
              "NAME_EN": "MUKESH JANGID",
              "NAME_LL": "मुकेश जांगिड",
              "MEM_TYPE": "MEM",
              "SRDR_MID": "27966330873",
              "IS_DEATH": "N",
              "FATHER_NAME_EN": "SHANKAR LAL JANGID",
              "FATHER_NAME_LL": "शंकर लाल जांगिड",
              "DOB": "30/09/1994",
              "MOTHER_NAME_EN": "SUMAN DEVI",
              "MOTHER_NAME_LL": "सुमन देवी",
              "ENR_ID": "9999-TAL3-00443",
              "CATEGORY_ID": 4,
              "CATEGORY_DESC_LL": "अन्य पिछड़ा वर्ग",
              "GENDER_ID": 3,
              "GENDER": "MALE",
              "MARITAL_STATUS_ID": 7,
              "MARITAL_STATUS_CODE": 7,
              "MARITAL_STATUS": "MARRIED",
              "SPOUCE_NAME_EN": "PRIYA JANGID",
              "SPOUCE_NAME_LL": "प्रिया जॉगिड",
              "MOBILE_NO": 9887574406,
              "EMAIL": null,
              "IS_ORPHAN": null,
              "BANK": null,
              "ACCOUNT_NO": null,
              "IFSC_CODE": null,
              "BANK_BRANCH": null,
              "REL_WITH_HOF": "HUSBAND",
              "EDUCATION": "GRADUATE",
              "PIN_CODE": 302013,
              "AADHAR_REF_ID": 444785710545301,
              "ADDRESS":
              "70-A,Anand Vihar-d Machera Harmada Jaipur,Ward No. 03,Jaipur,Jaipur,302013",
              "BLOCK_CITY": "JAIPUR",
              "CASTE_CODE": 2,
              "CATEGORY_DESC_ENG": "OBC",
              "DISTRICT": "JAIPUR",
              "GP_WARD": "WARD NO. 03",
              "IS_MINORITY": "N",
              "JAN_AADHAR": 5124746250,
              "MICR": null,
              "VILLAGE_NAME": null,
              "EKYC": "Y",
              "DISABILITY_TYPE": null,
              "DISTRICT_CD": 110,
              "BLOCK_CITY_CD": "C340",
              "BLOCK_CITY_ID": 340,
              "GP_WARD_CD": "C0340W003",
              "GP_WARD_ID": 9475,
              "VILLAGE_CD": null,
              "DISABILITY_PERCENTAGE": null,
              "ADDRESS_LL":
              "70-ए,आनंद विहार डी माचड़ा हरमाडा जयपुर,वार्ड न. 03,जयपुर,जयपुर,302013",
              "DISTRICT_NAME_LL": "जयपुर",
              "BLOCK_CITY_LL": "जयपुर",
              "GP_LL": null,
              "WARD_LL": "वार्ड न. 03",
              "VILLAGE_LL": null,
              "CATEGORY_CODE": 13,
              "IS_DISABILITY": null,
              "STATUS": 1
            }
          ],
          "janId": null
        },
        "signature":
        "RrgI2dbr2cHQBb1sN2jt6PMYObzNBhlF20HbIrdtjZiy1YrR2QL9wRT5M78Q8DDlZxZjb1yuBirDpRe5J39qQ10xU3msMLa0Yf5DRzbmkUI/47aYeP1LJOTxb5yWliQBqJkAuPyqFOHxytxQQqHjK7ms46+5mb71nlGGhAR214SnNelgPS19Lh7MX/hAigovkkuxTj9n/CPfjFPeWUQg/G/vIq3/rrPSJTdo1z99DmMuB0o0eiJqBbDzELs64Qs2K5x9E9WwiZTNMJYBlJUDlEoz5vKGvav/8zvEHjdtkmtH0vkB18WMOHCtbhWHWWLYnFxCCSMLbIJTZXfx5Tvdkw=="
      }
    };

    // Convert to your modal
    final sm = FetchJanAdharModal.fromJson(mockResponse);

    // Clear existing list and add mock data
    feachJanAadhaarDataList.clear();
    feachJanAadhaarDataList.addAll(sm.data!.response!.data!);

    // Navigate to OTR form screen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => OtrFormScreen(
          feachJanAadhaarDataList: feachJanAadhaarDataList,
          janMemberId: memberId,
          ssoId: ssoId,
          userID: userID,
        ),
      ),
          (route) => false,
    );

    notifyListeners();
  }


  Future<FetchJanAdharModal?> validateOTPApi(
      BuildContext context,
      String memberId,
      String tid,
      String otp,
      String ssoId,
      String userID) async {
    var isInternet = await UtilityClass.checkInternetConnectivity();
    if (isInternet) {
      try {
        //member id - 45053402607
        ProgressDialog.showLoadingDialog(context);
        Map<String, dynamic> body = {};
        ApiResponse apiResponse = await commonRepo.post(
            "NewJanAdharMobile/JanAdharDataNew?SchemeName=EEMS&sType=ValidateOTP_FetchRequestedData&memberId=${memberId}&tid=${tid}&otp=${otp}",
            body);
        // ApiResponse apiResponse = await commonRepo.post(
        //   "${Constants.janAadhaarBaseUrl}"
        //       "NewJanAadharDetail/JanAdharDataNew"
        //       "?SchemeName=EEMS&sType=ValidateOTP_FetchRequestedData"
        //       "&memberId=$memberId&tid=$tid&otp=$otp",
        //   {},
        // );

        ProgressDialog.closeLoadingDialog(context);
        if (apiResponse.response != null &&
            apiResponse.response?.statusCode == 200) { //correct 200
          //apiResponse.response?.statusCode == 300 //for testing with static data
          var responseData = apiResponse.response?.data;
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }
          final sm = FetchJanAdharModal.fromJson(responseData);
          // if (sm.state == 200) {
          if (sm.state == 1) {
            print("oppopopo");
            feachJanAadhaarDataList.clear();
            feachJanAadhaarDataList.addAll(sm.data!.response!.data!);
            Navigator.pushAndRemoveUntil<dynamic>(
                context,
                MaterialPageRoute<dynamic>(
                    builder: (BuildContext context) => OtrFormScreen(
                        feachJanAadhaarDataList: feachJanAadhaarDataList,
                        janMemberId: memberId,
                        ssoId: ssoId,
                        userID: userID)),
                (route) => false);
            notifyListeners();
            return sm;
          } else {
            print("qwqwqw1");
            final smmm = FetchJanAdharModal(
                state: 0, message: sm.errorMessage.toString());
            print(sm.errorMessage.toString());
            print("qwqwqw2");
            showAlertError(
                smmm.message.toString().isNotEmpty
                    ? smmm.message.toString()
                    : "Invalid SSO ID and Password",
                context);
            return smmm;
          }
        } else {
          addSaticData(context, memberId, ssoId, userID);

          notifyListeners();
          return FetchJanAdharModal(
            state: 0,
            message: 'Something went wrong',
          );
        }
      } on Exception catch (err) {
        ProgressDialog.closeLoadingDialog(context);
        final sm = FetchJanAdharModal(state: 0, message: err.toString());
        showAlertError(sm.message.toString(), context);
        return sm;
      }
    } else {
      showAlertError(
          AppLocalizations.of(context)!.internet_connection, context);
    }
  }

  addSaticData(
      BuildContext context, String memberId, String ssoId, String userID) {
    feachJanAadhaarDataList.clear();
    feachJanAadhaarDataList.add(
      FetchJanAdharResponseData(
        nAMEEN: "DEEPAK KUMAR GUPTA",
        nAMELL: "दीपक कुमार गुप्ता",
        mEMTYPE: "MEM",
        sRDRMID: 45053402607,
        iSDEATH: "N",
        fATHERNAMEEN: "OM PRAKASH GUPTA",
        fATHERNAMELL: "ओम प्रकाश गुप्ता",
        dOB: "1990-07-01", //1900-01-01
        mOTHERNAMEEN: "SHIMLA DEVI",
        mOTHERNAMELL: "शिमला देवी",
        cATEGORYDESCLL: "सामान्य",
        gENDER: "MALE",
        mARITALSTATUS: "MARRIED",
        sPOUCENAMEEN: "JYOTI GOYAL",
        sPOUCENAMELL: "ज्योति गोयल",
        mOBILENO: 9352691869,
        eMAIL: null,
        iSORPHAN: null,
        bANK: null,
        aCCOUNTNO: null,
        iFSCCODE: null,
        rELWITHHOF: "HUSBAND",
        eDUCATION: "GRADUATE",
        pINCODE: 322201,
        bANKBRANCH: null,
        aADHARREFID: 444466291586091,
        aDDRESS: "Udai Mode,Ward No 53,Gangapur City,Sawai Madhopur,322201",
        bLOCKCITY: "GANGAPUR CITY",
        cASTECODE: null,
        cATEGORYDESCENG: "GEN",
        dISTRICT: "SAWAI MADHOPUR",
        eNRID: "9999-MPJ3-00051",
        gPWARD: "WARD NO 53",
        iSMINORITY: "N",
        jANAADHAR: 5158248757,
        mICR: null,
        pPONO: null,
        vILLAGENAME: null,
        eKYC: "Y",
        dISABILITYTYPE: null,
        dISTRICTCD: "108",
        bLOCKCITYCD: "800508",
        gPWARDCD: "C067W053",
        vILLAGECD: null,
        dISABILITYPERCENTAGE: null,
        aDDRESSLL: "उदेई मोड,वार्ड न. 53,गंगापुर सिटी,सवाई माधोपुर,322201",
        dISTRICTNAMELL: "सवाई माधोपुर",
        bLOCKCITYLL: "गंगापुर सिटी",
        gPLL: null,
        wARDLL: "वार्ड न. 53",
        vILLAGELL: null,
        cATEGORYCODE: 15,
        iSDISABILITY: null,
      ),
    );

    Navigator.pushAndRemoveUntil<dynamic>(
        context,
        MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => OtrFormScreen(
                feachJanAadhaarDataList: feachJanAadhaarDataList,
                janMemberId: memberId,
                ssoId: ssoId,
                userID: userID)),
        (route) => false);
  }

  void clearData() {
    janAadhaarController.clear();
    otpController.clear();

    currentStep = FlowStep.enterJanAadhaar;

    feachJanAadhaarDataList.clear();
    fetchMemberList.clear();

    memberID = "";
    tid = "";
    notifyListeners();
  }
}
