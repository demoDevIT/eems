import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../repo/common_repo.dart';
import '../../../constants/colors.dart';
import '../../../utils/global.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import 'modal/actEstablishment_modal.dart';
import 'modal/sector_modal.dart';
import 'modal/state_modal.dart';
import '../../job_seeker/loginscreen/provider/locale_provider.dart';
import 'modal/city_modal.dart';
import 'modal/district_modal.dart';
import 'provider/empotr_form_provider.dart';

class EmpOTRFormScreen extends StatefulWidget {
  final String ssoId;
  final String userID;
  final Map<String, dynamic>? brnResponseData;

  const EmpOTRFormScreen({
    super.key,
    required this.ssoId,
    required this.userID,
    this.brnResponseData,
  });

  @override
  State<EmpOTRFormScreen> createState() =>
      _EmpOTRFormScreenState(ssoId, userID);
}

class _EmpOTRFormScreenState extends State<EmpOTRFormScreen> {
  final String ssoId;
  final String userID;

  _EmpOTRFormScreenState(this.ssoId, this.userID);

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<EmpOTRFormProvider>(context, listen: false);
      provider.clearData();
      provider.setSSO(ssoId);
      provider.stateApi(context);
      provider.actEstablishmentApi(context);
      provider.sectorApi(context);

      // ✅ AUTO FILL FROM BRN
      if (widget.brnResponseData != null) {
        provider.autoFillFromBRN(widget.brnResponseData!);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    return Scaffold(
        appBar: commonAppBar2(
          "Employee OTR Form",
          context,
          localeProvider.currentLanguage,
          "",
          false,
          "",
          onTapClick: () {
            localeProvider.toggleLocale();
          },
        ),
        body: Consumer<EmpOTRFormProvider>(
          builder: (context, provider, child) {
            return SafeArea(
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 12),

                      /// SSO ID
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: labelWithStar('SSOID', required: false),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: buildTextWithBorderField(
                            provider.ssoController,
                            "Enter sso id",
                            MediaQuery.of(context).size.width,
                            50,
                            TextInputType.text,
                            isEnabled: false,
                            boxColor: fafafaColor),
                      ),

                      // 1. basic detail card
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "1. Basic Details",
                                style: Styles.semiBoldTextStyle(
                                    size: 14, color: kWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('BRN', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.brnController,
                                "Enter BRN",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number  ,
                                isEnabled: provider.isEditable(provider.brnController),
                               // isEnabled: false,
                                boxColor: fafafaColor,
                                textLenght: 16,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(16),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('District', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.districtController,
                                "Enter District",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.districtController),
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                                ],
                                fun: (value) {
                                  if (value.length > 0 && value.length < 4) {
                                    provider.districtError = "Minimum 3 characters required.";
                                  } else {
                                    provider.districtError = null;
                                  }
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            if (provider.districtError != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  provider.districtError!,
                                  style: TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Area', required: true),
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Rural',
                                      groupValue: provider.areaType,
                                      onChanged: provider.isAreaFromBRN ? null : provider.setArea,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Rural',
                                      style: Styles.mediumTextStyle(
                                          color: kBlackColor, size: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Urban',
                                      groupValue: provider.areaType,
                                      onChanged: provider.isAreaFromBRN ? null : provider.setArea,
                                      // onChanged: (val) => setState(() =>
                                      //     provider.areaType =
                                      //         val ?? provider.areaType),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Urban',
                                      style: Styles.mediumTextStyle(
                                          color: kBlackColor, size: 14),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 12),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Tehsil', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.tehsilController,
                                "Enter Tehsil",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.tehsilController),
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            if (provider.areaType == 'Rural') ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: labelWithStar('Village', required: true),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: buildTextWithBorderField(
                                  provider.villageController,
                                  "Enter Village",
                                  MediaQuery.of(context).size.width,
                                  50,
                                  TextInputType.text,
                                  isEnabled: provider.isEditable(provider.villageController),
                                  boxColor: fafafaColor,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                                  ],
                                ),
                              ),
                            ],

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                                  labelWithStar('Local Body', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.localBodyController,
                                "Enter Local Body",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.localBodyController),
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                                ],
                              ),
                            ),

                            if (provider.areaType == 'Urban') ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: labelWithStar('Ward', required: true),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                child: buildTextWithBorderField(
                                  provider.wardController,
                                  "Enter Ward",
                                  MediaQuery.of(context).size.width,
                                  50,
                                  TextInputType.text,
                                  isEnabled: provider.isEditable(provider.wardController),
                                  boxColor: fafafaColor,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9\s]')),
                                  ],
                                ),
                              ),
                            ],

                          ],
                        ),
                      ),

                      // 2. branch office detail card
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "2. Branch Office Details (As on Sanstha Aadhaar) :-",
                                style: Styles.semiBoldTextStyle(
                                    size: 14, color: kWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                                  labelWithStar('Company Name', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.companyNameController,
                                "Company Name",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.companyNameController),
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                                  labelWithStar('House Number', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.houseNoController,
                                "House Number",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.houseNoController),
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Lane', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.laneController,
                                "Lane",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.laneController),
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Locality', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.localityController,
                                "Locality",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.localityController),
                               // isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Pin Code', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.pinCodeController,
                                "Pin Code",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                isEnabled: provider.isEditable(provider.pinCodeController),
                                textLenght: 6,
                               // isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                fun: (value) {
                                  if (value.length != 6) {
                                    provider.pinCodeError = "Pin Code must be 6 digits";
                                  } else {
                                    provider.pinCodeError = null;
                                  }
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            if (provider.pinCodeError != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(provider.pinCodeError!,
                                    style: const TextStyle(color: Colors.red, fontSize: 12)),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Tel No', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.telNoController,
                                "Tel No",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.phone,
                                textLenght: 15,
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(15),
                                ],
                                fun: (value) {
                                  if (value.length != 15) {
                                    provider.telError = "Telephone number must be 15 digits";
                                  } else {
                                    provider.telError = null;
                                  }
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Email', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.emailController,
                                "Email",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.emailAddress,
                                isEnabled: provider.isEditable(provider.emailController),
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                                fun: provider.validateEmail,
                              ),
                            ),
                            if (provider.emailErrorText != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(provider.emailErrorText!,
                                    style: const TextStyle(color: Colors.red, fontSize: 12)),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                                  labelWithStar('GST Number', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.gstController,
                                "GST Number",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                textLenght: 15,
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(15),
                                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                                ],
                                fun: provider.validateGST,
                              ),
                            ),
                            if (provider.gstLengthError != null)
                              Text(provider.gstLengthError!,
                                  style: const TextStyle(color: Colors.red, fontSize: 12)),

                            if (provider.gstFormatError != null)
                              Text(provider.gstFormatError!,
                                  style: const TextStyle(color: Colors.red, fontSize: 12)),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                                  labelWithStar('PAN Number', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.panController,
                                "PAN Number",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.panController),
                                textLenght: 10,
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                                ],
                                fun: (value) {
                                  final pan = value.toUpperCase();
                                  provider.panController.value =
                                      provider.panController.value.copyWith(text: pan);

                                  if (pan.length == 10 && pan.isValidPanCardNo()) {
                                    provider.panErrorText = null;
                                  } else {
                                    provider.panErrorText = "Invalid PAN number";
                                  }

                                  provider.panVerifiedController.text = pan;
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            if (provider.panErrorText != null)
                              Text(provider.panErrorText!,
                                  style: const TextStyle(color: Colors.red, fontSize: 12)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                                  labelWithStar('PAN Holder', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.panHolderController,
                                "PAN Holder",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                                  labelWithStar('PAN Verified', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.panVerifiedController,
                                "PAN Verified",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.panVerifiedController),
                                textLenght: 10,
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                                ],
                                fun: (value) {
                                  provider.panController.text = value.toUpperCase();
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                                  labelWithStar('TAN Number', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.tanController,
                                "TAN Number",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.tanController),
                                textLenght: 10,
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                                ],
                                fun: (value) {
                                  final tan = value.toUpperCase();
                                  provider.tanErrorText =
                                  tan.isValidTan() ? null : "Enter valid TAN (e.g. DELA12345B)";
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            if (provider.tanErrorText != null)
                              Text(provider.tanErrorText!,
                                  style: const TextStyle(color: Colors.red, fontSize: 12)),

                          ],
                        ),
                      ),

                      // 3. head office detail card
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "3. Head Office Details (As on Sanstha Aadhaar) :-",
                                style: Styles.semiBoldTextStyle(
                                    size: 14, color: kWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('Company Name', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.hoCompanyNameController,
                                "Company Name",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.hoCompanyNameController),
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('Tel No', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.hoTelNoController,
                                "Tel No",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.phone,
                                isEnabled: provider.isEditable(provider.hoTelNoController),
                                textLenght: 15,
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(15),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Email', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.hoEmailController,
                                "Email",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.emailAddress,
                                isEnabled: provider.isEditable(provider.hoEmailController),
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                                fun: provider.validateEmail,
                              ),
                            ),
                            if (provider.emailErrorText != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  provider.emailErrorText!,
                                  style: const TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('PAN No.', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.hoPanController,
                                "PAN No.",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.hoPanController),
                                textLenght: 10,
                             //   isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                                ],
                                fun: (value) {
                                  final pan = value.toUpperCase();
                                  provider.hoPanController.value =
                                      provider.hoPanController.value.copyWith(text: pan);

                                  provider.panErrorText =
                                  pan.length == 10 && pan.isValidPanCardNo()
                                      ? null
                                      : "Invalid PAN number";

                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            if (provider.panErrorText != null)
                              Text(provider.panErrorText!,
                                  style: const TextStyle(color: Colors.red, fontSize: 12)),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('House Number', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.hoHouseNoController,
                                "House Number",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.hoHouseNoController),
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Lane', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.hoLaneController,
                                "Lane",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.hoLaneController),
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Locality', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.hoLocalityController,
                                "Locality",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.hoLocalityController),
                               // isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('Pincode', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.hoPincodeController,
                                "Pincode",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                isEnabled: provider.isEditable(provider.hoPincodeController),
                                textLenght: 6,
                               // isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 4. head office Applicant detail card
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "4. Head Office Applicant Details (As on Sanstha Aadhaar) :-",
                                style: Styles.semiBoldTextStyle(
                                    size: 14, color: kWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('Applicant Name', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.applicantNameController,
                                "Applicant Name",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.applicantNameController),
                               // isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('Applicant Mobile', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.applicantMobileController,
                                "Applicant Mobile",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                isEnabled: provider.isEditable(provider.applicantMobileController),
                               // isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Applicant Email', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.applicantEmailController,
                                "Applicant Email",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.emailAddress,
                                isEnabled: provider.isEditable(provider.applicantEmailController),
                               // isEnabled: false,
                                boxColor: fafafaColor,
                                fun: (value) {
                                  provider.applicantEmailError =
                                  value.isNotEmpty && value.isValidEmail()
                                      ? null
                                      : "Invalid email address";
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            if (provider.applicantEmailError != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  provider.applicantEmailError!,
                                  style: const TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Year', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.yearController,
                                "Year",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                isEnabled: provider.isEditable(provider.yearController),
                               // isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(4),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Ownership', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.ownershipController,
                                "Ownership",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.ownershipController),
                               // isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Total Person', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.totalPersonController,
                                "Total Person",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                isEnabled: provider.isEditable(provider.totalPersonController),
                               // isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(5),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Act Authority Reg', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.actAuthorityRegController,
                                "Act Authority Reg",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.actAuthorityRegController),
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('TAN No', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.tanNoController,
                                "TAN No",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                                ],
                                fun: (value) {
                                  final tan = value.toUpperCase();
                                  provider.tanNoController.value =
                                      provider.tanNoController.value.copyWith(
                                        text: tan,
                                        selection: TextSelection.collapsed(offset: tan.length),
                                      );

                                  provider.hoTanErrorText =
                                  tan.length == 10 && tan.isValidTan()
                                      ? null
                                      : "Invalid TAN number";

                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            if (provider.hoTanErrorText != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  provider.hoTanErrorText!,
                                  style: const TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('Email', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.hoApplicantEmailController,
                                "Email",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.emailAddress,
                               // isEnabled: false,
                                boxColor: fafafaColor,
                                fun: (value) {
                                  provider.hoApplicantEmailError =
                                  value.isNotEmpty && value.isValidEmail()
                                      ? null
                                      : "Invalid email address";
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            if (provider.hoApplicantEmailError != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  provider.hoApplicantEmailError!,
                                  style: const TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: labelWithStar('State', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderFieldOnlyThisPage<StateData>(
                                items: provider.stateList,
                                controller: provider.stateController,
                                idController: provider.stateIdController,
                                hintText: "--Select State--",
                                height: 50,
                                selectedValue: provider.selectedState,
                                getLabel: (e) => e.name ?? "",
                                onChanged: (value) {
                                  provider.selectedState = value;

                                  provider.stateController.text = value?.name ?? "";
                                  provider.stateIdController.text = value?.iD.toString() ?? "";

                                  // 🔴 CLEAR DEPENDENTS
                                  // provider.selectedDistrict = null;
                                  // provider.districtHoController.clear();
                                  // provider.districtIdController.clear();
                                  // provider.districtList.clear();
                                  //
                                  // provider.selectedCity = null;
                                  // provider.cityHoController.clear();
                                  // provider.cityIdController.clear();
                                  // provider.locationList.clear();

                                  provider.selectedDistrict = null;
                                  provider.districtHoController.clear();
                                  provider.locationList.clear();

                                  provider.getDistrictApi(context, value!.iD!);
                                  provider.notifyListeners();
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: labelWithStar('District', required: true),
                            ),
                            provider.isDistrictLoading
                                ? const Center(child: CircularProgressIndicator())
                                : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderFieldOnlyThisPage<DistrictData>(
                                items: provider.districtList,
                                controller: provider.districtHoController,
                                idController: provider.districtIdController,
                                hintText: "--Select District--",
                                height: 50,
                                selectedValue: provider.selectedDistrict,
                                getLabel: (e) => e.name ?? "",
                                onChanged: (value) {
                                  provider.selectedDistrict = value;

                                  provider.districtHoController.text = value?.name ?? "";
                                  provider.districtIdController.text =
                                      value?.iD.toString() ?? "";

                                  // 🔴 CLEAR CITY
                                  provider.selectedCity = null;
                                  provider.cityHoController.clear();
                                  provider.cityIdController.clear();
                                  provider.locationList.clear();

                                  provider.getCityApi(context, value!.iD!.toString());
                                  provider.notifyListeners();
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: labelWithStar('City', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderFieldOnlyThisPage<CityData>(
                                items: provider.locationList,
                                controller: provider.cityHoController,
                                idController: provider.cityIdController,
                                hintText: "--Select City--",
                                height: 50,
                                selectedValue: provider.selectedCity,
                                getLabel: (e) => e.nameEng ?? "",
                                onChanged: (value) {
                                  provider.selectedCity = value;

                                  provider.cityHoController.text = value?.nameEng ?? "";
                                  provider.cityIdController.text =
                                      value?.iD.toString() ?? "";

                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('Website', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.websiteController,
                                "Website",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                               // isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('Applicant Address', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.applicantAddressController,
                                "Applicant Address",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.applicantAddressController),
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('NIC Code', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.nicCodeController,
                                "NIC Code",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(provider.nicCodeController),
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 5. Contact Person detail card
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "5. Contact Person Details :-",
                                style: Styles.semiBoldTextStyle(
                                    size: 14, color: kWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('PAN No', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactPanController,
                                "PAN No",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                textLenght: 10,
                               // isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9]')),
                                ],
                                fun: (value) {
                                  final pan = value.toUpperCase();

                                  // force uppercase in field
                                  provider.contactPanController.value =
                                      provider.contactPanController.value.copyWith(
                                        text: pan,
                                        selection: TextSelection.collapsed(offset: pan.length),
                                      );

                                  // validation (same as HO PAN)
                                  provider.contactPanError =
                                  pan.length == 10 && pan.isValidPanCardNo()
                                      ? null
                                      : "Invalid PAN number";

                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            if (provider.contactPanError != null)
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  provider.contactPanError!,
                                  style: const TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('Full Name', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactNameController,
                                "Full Name",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Mobile Number', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactMobileController,
                                "Mobile Number",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.phone,
                                textLenght: 10,
                             //   isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(15),
                                ],
                                fun: (value) {
                                  if (value.length != 15) {
                                    provider.contactMobileError = "Telephone number must be 10 digits";
                                  } else {
                                    provider.contactMobileError = null;
                                  }
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Alternate Mobile', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactAltMobileController,
                                "Alternate Mobile",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.phone,
                                textLenght: 10,
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                fun: (value) {
                                  if (value.length != 15) {
                                    provider.contactAlterMobileError = "Telephone number must be 10 digits";
                                  } else {
                                    provider.contactAlterMobileError = null;
                                  }
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Email', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactEmailController,
                                "Email",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.emailAddress,
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                                fun: provider.validateEmail,
                              ),
                            ),
                            if (provider.emailErrorText != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(
                                  provider.emailErrorText!,
                                  style: const TextStyle(color: Colors.red, fontSize: 12),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('State', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderFieldOnlyThisPage<StateData>(
                                items: provider.coStateList,
                                controller: provider.coStateController,
                                idController: provider.coStateIdController,
                                hintText: "--Select State--",
                                height: 50,
                                selectedValue: provider.coSelectedState,
                                getLabel: (e) => e.name ?? "",
                                onChanged: (value) {
                                  provider.coSelectedState = value;

                                  provider.coStateController.text = value?.name ?? "";
                                  provider.coStateIdController.text = value?.iD.toString() ?? "";

                                  provider.coSelectedDistrict = null;
                                  provider.coDistrictController.clear();
                                  provider.coLocationList.clear();

                                  provider.getDistrictApi(context, value!.iD!);
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: labelWithStar('District', required: true),
                            ),
                            provider.iscoDistrictLoading
                                ? const Center(child: CircularProgressIndicator())
                                : Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderFieldOnlyThisPage<DistrictData>(
                                items: provider.coDistrictList,
                                controller: provider.coDistrictController,
                                idController: provider.coDistrictIdController,
                                hintText: "--Select District--",
                                height: 50,
                                selectedValue: provider.coSelectedDistrict,
                                getLabel: (e) => e.name ?? "",
                                onChanged: (value) {
                                  provider.coSelectedDistrict = value;

                                  provider.coDistrictController.text = value?.name ?? "";
                                  provider.coDistrictIdController.text =
                                      value?.iD.toString() ?? "";

                                  // 🔴 CLEAR CITY
                                  provider.coSelectedCity = null;
                                  provider.coCityController.clear();
                                  provider.coCityIdController.clear();
                                  provider.coLocationList.clear();

                                  provider.getCityApi(context, value!.iD!.toString());
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: labelWithStar('City', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderFieldOnlyThisPage<CityData>(
                                items: provider.coLocationList,
                                controller: provider.coCityController,
                                idController: provider.coCityIdController,
                                hintText: "--Select City--",
                                height: 50,
                                selectedValue: provider.coSelectedCity,
                                getLabel: (e) => e.nameEng ?? "",
                                onChanged: (value) {
                                  provider.coSelectedCity = value;

                                  provider.coCityController.text = value?.nameEng ?? "";
                                  provider.coCityIdController.text =
                                      value?.iD.toString() ?? "";

                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('Pincode', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactPincodeController,
                                "Pincode",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Designation', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactDesignationController,
                                "Designation",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Department', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactDepartmentController,
                                "Department",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                              //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                                ],
                              ),
                            ),


                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('Address', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactAddressController,
                                "Address",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                             //   isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // 6. Exchange Name / District Employment Office
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "6. Exchange Name / District Employment Office :-",
                                style: Styles.semiBoldTextStyle(
                                    size: 14, color: kWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('Exchange Name', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.exchangeNameController,
                                "Exchange Name",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                               // isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 7. Exchange Market Information Program
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "7. Exchange Market Information Program :-",
                                style: Styles.semiBoldTextStyle(
                                    size: 14, color: kWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('Type of Organization', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorder(
                                hint: "--Select Option--",
                                value: provider.organisationType,
                                boxColor: fafafaColor,
                                onChanged: provider.setOrganisationType,
                                items: const [
                                  DropdownMenuItem(value: "Private", child: Text("Private")),
                                  DropdownMenuItem(value: "Government", child: Text("Government")),
                                  DropdownMenuItem(value: "PSU", child: Text("PSU")),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('Government Body', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorder(
                                hint: "--Select Option--",
                                value: provider.govtBody,
                                boxColor: fafafaColor,
                                onChanged: provider.setGovtBody,
                                items: const [
                                  DropdownMenuItem(value: "Central", child: Text("Central Government")),
                                  DropdownMenuItem(value: "Local Body", child: Text("Local Body")),
                                  DropdownMenuItem(value: "State Government", child: Text("State Government")),
                                  DropdownMenuItem(
                                      value: "State Quasi Government",
                                      child: Text("State Quasi Government")),
                                  DropdownMenuItem(
                                      value: "Central Quasi Government",
                                      child: Text("Central Quasi Government")),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('No of Male Employee', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.noOfMaleEmpController,
                                "No of Male Employee",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                fun: (_) => provider.calculateTotalEmployees(),
                               // isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('No of Female Employee', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.noOfFemaleEmpController,
                                "No of Female Employee",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                fun: (_) => provider.calculateTotalEmployees(),
                               // isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('No of Transgender', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.noOfTransEmpController,
                                "No of Transgender",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                                fun: (_) => provider.calculateTotalEmployees(),
                               // isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Total No of Employee', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.noOfTotalEmpController,
                                "Total No of Employee",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                isEnabled: false,
                               // isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Act Establishment', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: DropdownButtonFormField<ActEstablishmentData>(
                                value: provider.selectedActEst,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: fafafaColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                hint: const Text("--Select Option--"),
                                items: provider.actEstList
                                    .map(
                                      (e) => DropdownMenuItem<ActEstablishmentData>(
                                    value: e,
                                    child: Text(e.actEstablishment ?? ""),
                                  ),
                                )
                                    .toList(),

                                // 🔒 ALWAYS DISABLED
                                onChanged: null,
                              ),
                            ),



                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('Industry Type', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorder(
                                hint: "--Select Option--",
                                value: provider.industryType,
                                boxColor: fafafaColor,
                                onChanged: provider.setIndustryType,
                                items: const [
                                  DropdownMenuItem(value: "Manufacturing", child: Text("Manufacturing")),
                                  DropdownMenuItem(value: "IT", child: Text("IT")),
                                  DropdownMenuItem(value: "Service", child: Text("Service")),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: labelWithStar('Sector', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: DropdownButtonFormField<SectorData>(
                                value: provider.selectedSector,
                                isExpanded: true,
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: fafafaColor,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                                hint: const Text("--Select Option--"),
                                items: provider.sectorList
                                    .map(
                                      (e) => DropdownMenuItem<SectorData>(
                                    value: e,
                                    child: Text(e.name ?? ""),
                                  ),
                                )
                                    .toList(),

                                // ✅ ALWAYS ENABLED
                                onChanged: (val) => provider.setSector(val),
                              ),
                            ),



                          ],
                        ),
                      ),

                      /// 8. Upload Organization/Company Documents
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              decoration: BoxDecoration(
                                color: kPrimaryColor,
                                border: Border.all(color: Colors.grey.shade300),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.centerLeft,
                              child: Text(
                                "8. Upload Organization/Company Documents :-",
                                style: Styles.semiBoldTextStyle(
                                    size: 14, color: kWhite),
                              ),
                            ),
                            buildImageUploadBox(
                              title: "PAN Certificate",
                              imageFile: provider.panCertificateController,
                              onTap: () {
                                provider.pickImage((file) {
                                  //provider.panCertificateController = file;
                                });
                              },
                            ),

                            buildImageUploadBox(
                              title: "TAN Certificate",
                              imageFile: provider.tanCertificateController,
                              onTap: () {
                                provider.pickImage((file) {
                                  provider.tanCertificateController = file;
                                });
                              },
                            ),

                            buildImageUploadBox(
                              title: "GST Certificate",
                              imageFile: provider.gstCertificateController,
                              onTap: () {
                                provider.pickImage((file) {
                                  provider.gstCertificateController = file;
                                });
                              },
                            ),

                            buildImageUploadBox(
                              title: "Choose Logo (PNG/JPG/JPEG)",
                              imageFile: provider.logoController,
                              onTap: () {
                                provider.pickImage((file) {
                                  provider.logoController = file;
                                });
                              },
                            ),
                            const SizedBox(height: 24),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // if (validateBasicDetails(context, provider)) {
                            //   confirmAlertDialog(
                            //     context,
                            //     "Confirm Submission",
                            //     "Are you sure you want to submit the form ?",
                            //         (value) {
                            //       if (value.toString() == "success") {
                            //         provider.sendSMSApi(
                            //             context,
                            //             feachJanAadhaarDataList,
                            //             janMemberId,
                            //             userID);
                            //       }
                            //     },
                            //   );
                            //   // NEXT STEP
                            // }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor, // nicer blue
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 0,
                          ),
                          child: const Text('Save',
                              style:
                              TextStyle(fontSize: 16, color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  Widget buildImageUploadBox({
    required String title,
    required File? imageFile,
    required VoidCallback onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: labelWithStar(title, required: true),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: InkWell(
            onTap: onTap,
            child: Container(
              height: 80,
              width: double.infinity,
              decoration: BoxDecoration(
                color: fafafaColor,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: imageFile == null
                  ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.cloud_upload_outlined, size: 35),
                  SizedBox(height: 8),
                  Text("Tap to upload image"),
                ],
              )
                  : ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  imageFile,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}

Widget buildDropdownWithBorderFieldOnlyThisPage<T>({
  required List<T> items,
  required TextEditingController controller,
  required TextEditingController idController,
  required String hintText,
  required double height,
  required T? selectedValue,
  required ValueChanged<T?> onChanged,
  String Function(T)? getLabel,
}) {
  return SizedBox(
    height: height,
    child: InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: fafafaColor, // SAME as text field
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: selectedValue,
          hint: Text(
            hintText,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                getLabel != null ? getLabel(item) : item.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    ),
  );
}

Widget buildDropdownWithBorder({
  required String hint,
  required String? value,
  required List<DropdownMenuItem<String>> items,
  required ValueChanged<String?> onChanged,
  Color? boxColor,
  bool isEnabled = true,
}) {
  return Container(
    height: 50,
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: boxColor ?? Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: borderColor),
    ),
    child: DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: value,
        hint: Text(hint),
        isExpanded: true,
        onChanged: isEnabled ? onChanged : null,
        items: items,
      ),
    ),
  );
}


