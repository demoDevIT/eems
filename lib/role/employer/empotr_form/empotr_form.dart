import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../../repo/common_repo.dart';
import '../../../constants/colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/dropdown.dart';
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
  final bool isFreshForm;
  final Map<String, dynamic>? brnResponseData;

  const EmpOTRFormScreen({
    super.key,
    required this.ssoId,
    required this.userID,
    this.isFreshForm = true,
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
      //provider.clearData();
      // ✅ CLEAR ONLY FOR NEW FORM
      if (widget.isFreshForm) {
        provider.clearData();
      }

      provider.setSSO(ssoId);
      provider.stateApi(context);
      provider.actEstablishmentApi(context);
      provider.sectorApi(context);
      provider.fetchDocumentMastersApi(context);

      // ✅ AUTO FILL FROM BRN
      if (widget.brnResponseData != null) {
        provider.autoFillFromBRN(widget.brnResponseData!);

        // ✅ CALL Exchange API USING DISTRICT
        final districtName =
        provider.districtController.text.trim();

        if (districtName.isNotEmpty) {
          provider.getExchangeOfficeByDistrict(
            context,
            districtName,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    return Scaffold(
        appBar: commonAppBar2(
          AppLocalizations.of(context)!.empOTRForm,
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
                        child: labelWithStar(AppLocalizations.of(context)!.ssoId, required: false),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: buildTextWithBorderField(
                            provider.ssoController,
                            AppLocalizations.of(context)!.enterSSOID,
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
                                "1. " + AppLocalizations.of(context)!.basicDetails + " :-",
                                style: Styles.semiBoldTextStyle(
                                    size: 14, color: kWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.brn, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.brnController,
                                AppLocalizations.of(context)!.enterBRN,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                isEnabled:
                                    provider.isEditable(provider.brnController),
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
                              child: labelWithStar(AppLocalizations.of(context)!.district, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.districtController,
                                AppLocalizations.of(context)!.enterDistrict,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                //isEnabled: provider.isEditable(provider.districtController),
                                isEnabled: !provider.districtPrefilled,
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z\s]')),
                                ],
                                fun: (value) {
                                  if (value.length > 0 && value.length < 4) {
                                    provider.districtError =
                                        AppLocalizations.of(context)!.min3Char;
                                  } else {
                                    provider.districtError = null;
                                  }
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            if (provider.districtError != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Text(
                                  provider.districtError!,
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.area, required: true),
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Rural',
                                      groupValue: provider.areaType,
                                      onChanged: provider.isAreaFromBRN
                                          ? null
                                          : provider.setArea,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      AppLocalizations.of(context)!.rural,
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
                                      onChanged: provider.isAreaFromBRN
                                          ? null
                                          : provider.setArea,
                                      // onChanged: (val) => setState(() =>
                                      //     provider.areaType =
                                      //         val ?? provider.areaType),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      AppLocalizations.of(context)!.urban,
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
                              child: labelWithStar(AppLocalizations.of(context)!.tehsil, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.tehsilController,
                                AppLocalizations.of(context)!.enterTehsil,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider
                                    .isEditable(provider.tehsilController),
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            if (provider.areaType == 'Rural') ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: labelWithStar(AppLocalizations.of(context)!.village, required: true),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: buildTextWithBorderField(
                                  provider.villageController,
                                  AppLocalizations.of(context)!.enterVillage,
                                  MediaQuery.of(context).size.width,
                                  50,
                                  TextInputType.text,
                                  isEnabled: provider
                                      .isEditable(provider.villageController),
                                  boxColor: fafafaColor,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z\s]')),
                                  ],
                                ),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                                  labelWithStar(AppLocalizations.of(context)!.localBody, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.localBodyController,
                                AppLocalizations.of(context)!.enterLocalBody,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider
                                    .isEditable(provider.localBodyController),
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z\s]')),
                                ],
                              ),
                            ),
                            if (provider.areaType == 'Urban') ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: labelWithStar(AppLocalizations.of(context)!.ward, required: true),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: buildTextWithBorderField(
                                  provider.wardController,
                                  AppLocalizations.of(context)!.enterWard,
                                  MediaQuery.of(context).size.width,
                                  50,
                                  TextInputType.text,
                                  isEnabled: provider
                                      .isEditable(provider.wardController),
                                  boxColor: fafafaColor,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp(r'[a-zA-Z0-9\s]')),
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
                                // "2. Branch Office Details (As on Sanstha Aadhaar) :-",
                                "2. " + AppLocalizations.of(context)!.branchOffDetailAsSansthaadhar + " :-",
                                style: Styles.semiBoldTextStyle(
                                    size: 14, color: kWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                                  labelWithStar(AppLocalizations.of(context)!.companyName, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.companyNameController,
                                AppLocalizations.of(context)!.companyName,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider
                                    .isEditable(provider.companyNameController),
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                                  labelWithStar(AppLocalizations.of(context)!.houseNo, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.houseNoController,
                                AppLocalizations.of(context)!.houseNo,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider
                                    .isEditable(provider.houseNoController),
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.lane, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.laneController,
                                AppLocalizations.of(context)!.lane,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider
                                    .isEditable(provider.laneController),
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.locality, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.localityController,
                                AppLocalizations.of(context)!.locality,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider
                                    .isEditable(provider.localityController),
                                // isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.pincode, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.pinCodeController,
                                AppLocalizations.of(context)!.pincode,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                // isEnabled: provider.isEditable(provider.pinCodeController),
                                isEnabled: !provider.pinCodePrefilled,
                                textLenght: 6,
                                // isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(6),
                                ],
                                fun: (value) {
                                  if (value.length != 6) {
                                    provider.pinCodeError =
                                        AppLocalizations.of(context)!.pinCode6digit;
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
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12)),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.telNo, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.telNoController,
                                AppLocalizations.of(context)!.telNo,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.phone,
                                textLenght: 10,
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(15),
                                ],
                                fun: (value) {
                                  if (value.length != 10) {
                                    provider.telError =
                                        AppLocalizations.of(context)!.telNo15digit;
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
                              child: labelWithStar(AppLocalizations.of(context)!.email, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.emailController,
                                AppLocalizations.of(context)!.email,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.emailAddress,
                                // isEnabled: provider.isEditable(provider.emailController),
                                isEnabled: !provider.emailPrefilled,
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                                fun: provider.validateEmail,
                              ),
                            ),
                            if (provider.emailErrorText != null)
                              Padding(
                                padding: const EdgeInsets.only(left: 12),
                                child: Text(provider.emailErrorText!,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12)),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                                  labelWithStar(AppLocalizations.of(context)!.gstNo, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.gstController,
                                AppLocalizations.of(context)!.gstNo,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                textLenght: 15,
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(15),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[A-Za-z0-9]')),
                                ],
                                fun: provider.validateGST,
                              ),
                            ),
                            if (provider.gstLengthError != null)
                              Text(provider.gstLengthError!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12)),
                            if (provider.gstFormatError != null)
                              Text(provider.gstFormatError!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                                  labelWithStar(AppLocalizations.of(context)!.panNo, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.panController,
                                AppLocalizations.of(context)!.panNo,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                // isEnabled: provider.isEditable(provider.panController),
                                isEnabled: !provider.panPrefilled,
                                textLenght: 10,
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[A-Za-z0-9]')),
                                ],
                                fun: (value) {
                                  final pan = value.toUpperCase();
                                  provider.panController.value = provider
                                      .panController.value
                                      .copyWith(text: pan);

                                  if (pan.length == 10 &&
                                      pan.isValidPanCardNo()) {
                                    provider.panErrorText = null;
                                  } else {
                                    provider.panErrorText =
                                        AppLocalizations.of(context)!.invalidPANNo;
                                  }

                                  provider.panVerifiedController.text = pan;
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            if (provider.panErrorText != null)
                              Text(provider.panErrorText!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                                  labelWithStar(AppLocalizations.of(context)!.panHolder, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.panHolderController,
                                AppLocalizations.of(context)!.panHolder,
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
                                  labelWithStar(AppLocalizations.of(context)!.panVerified, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.panVerifiedController,
                                AppLocalizations.of(context)!.panVerified,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider
                                    .isEditable(provider.panVerifiedController),
                                textLenght: 10,
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[A-Za-z0-9]')),
                                ],
                                fun: (value) {
                                  provider.panController.text =
                                      value.toUpperCase();
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                                  labelWithStar(AppLocalizations.of(context)!.tanNo, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.tanController,
                                AppLocalizations.of(context)!.tanNo,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                // isEnabled: provider.isEditable(provider.tanController),
                                isEnabled: !provider.tanPrefilled,
                                textLenght: 10,
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[A-Za-z0-9]')),
                                ],
                                fun: (value) {
                                  final tan = value.toUpperCase();
                                  provider.tanErrorText = tan.isValidTan()
                                      ? null
                                      : AppLocalizations.of(context)!.enterValidTAN;
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            if (provider.tanErrorText != null)
                              Text(provider.tanErrorText!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12)),
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
                                "3. " + AppLocalizations.of(context)!.headOfficeDetailAsSansthaAdhar + " :-",
                                style: Styles.semiBoldTextStyle(
                                    size: 14, color: kWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                                  labelWithStar(AppLocalizations.of(context)!.companyName, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.hoCompanyNameController,
                                AppLocalizations.of(context)!.companyName,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(
                                    provider.hoCompanyNameController),
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z\s]')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.telNo, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.hoTelNoController,
                                AppLocalizations.of(context)!.telNo,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.phone,
                                // isEnabled: provider
                                //     .isEditable(provider.hoTelNoController),
                                textLenght: 10,
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(15),
                                ],
                                fun: (value) {
                                  if (value.length != 10) {
                                    provider.telNoError =
                                        AppLocalizations.of(context)!.telNo10digit;
                                  } else {
                                    provider.telNoError = null;
                                  }
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.email, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.hoEmailController,
                                AppLocalizations.of(context)!.email,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.emailAddress,
                                //isEnabled: provider.isEditable(provider.hoEmailController),
                                isEnabled: !provider.hoEmailPrefilled,
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
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.panNo, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.hoPanController,
                                AppLocalizations.of(context)!.panNo,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                // isEnabled: provider.isEditable(provider.hoPanController),
                                isEnabled: !provider.hoPanPrefilled,
                                textLenght: 10,
                                //   isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[A-Za-z0-9]')),
                                ],
                                fun: (value) {
                                  final pan = value.toUpperCase();
                                  provider.hoPanController.value = provider
                                      .hoPanController.value
                                      .copyWith(text: pan);

                                  provider.panErrorText =
                                      pan.length == 10 && pan.isValidPanCardNo()
                                          ? null
                                          : AppLocalizations.of(context)!.invalidPANNo;

                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            if (provider.panErrorText != null)
                              Text(provider.panErrorText!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12)),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                                  labelWithStar(AppLocalizations.of(context)!.houseNo, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.hoHouseNoController,
                                AppLocalizations.of(context)!.houseNo,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider
                                    .isEditable(provider.hoHouseNoController),
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.lane, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.hoLaneController,
                                AppLocalizations.of(context)!.lane,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider
                                    .isEditable(provider.hoLaneController),
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.locality, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.hoLocalityController,
                                AppLocalizations.of(context)!.locality,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider
                                    .isEditable(provider.hoLocalityController),
                                // isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z\s]')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.pincode, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.hoPincodeController,
                                AppLocalizations.of(context)!.pincode,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                isEnabled: provider
                                    .isEditable(provider.hoPincodeController),
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
                                "4. " + AppLocalizations.of(context)!.headOffAppDetailAsSansthaAdhar + " :-",
                                style: Styles.semiBoldTextStyle(
                                    size: 14, color: kWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.applicantName,
                                  required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.applicantNameController,
                                AppLocalizations.of(context)!.applicantName,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(
                                    provider.applicantNameController),
                                // isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z\s]')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.applicantMobNo,
                                  required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.applicantMobileController,
                                AppLocalizations.of(context)!.applicantMobNo,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                isEnabled: provider.isEditable(
                                    provider.applicantMobileController),
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
                              child: labelWithStar(AppLocalizations.of(context)!.applicantEmail,
                                  required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.applicantEmailController,
                                AppLocalizations.of(context)!.applicantEmail,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.emailAddress,
                                //isEnabled: provider.isEditable(provider.applicantEmailController),
                                isEnabled: !provider.applicantEmailPrefilled,
                                // isEnabled: false,
                                boxColor: fafafaColor,
                                fun: (value) {
                                  provider.applicantEmailError =
                                      value.isNotEmpty && value.isValidEmail()
                                          ? null
                                          : AppLocalizations.of(context)!.invalidEmail;
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            if (provider.applicantEmailError != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  provider.applicantEmailError!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.year, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.yearController,
                                AppLocalizations.of(context)!.year,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                isEnabled: provider
                                    .isEditable(provider.yearController),
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
                              child: labelWithStar(AppLocalizations.of(context)!.ownership, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.ownershipController,
                                AppLocalizations.of(context)!.ownership,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider
                                    .isEditable(provider.ownershipController),
                                // isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                                  labelWithStar(AppLocalizations.of(context)!.totalPer, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.totalPersonController,
                                AppLocalizations.of(context)!.totalPer,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                isEnabled: provider
                                    .isEditable(provider.totalPersonController),
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
                              child: labelWithStar(AppLocalizations.of(context)!.actAuthReg,
                                  required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.actAuthorityRegController,
                                AppLocalizations.of(context)!.actAuthReg,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(
                                    provider.actAuthorityRegController),
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.tanNo, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.tanNoController,
                                AppLocalizations.of(context)!.tanNo,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[A-Za-z0-9]')),
                                ],
                                fun: (value) {
                                  final tan = value.toUpperCase();
                                  provider.tanNoController.value =
                                      provider.tanNoController.value.copyWith(
                                    text: tan,
                                    selection: TextSelection.collapsed(
                                        offset: tan.length),
                                  );

                                  provider.hoTanErrorText =
                                      tan.length == 10 && tan.isValidTan()
                                          ? null
                                          : AppLocalizations.of(context)!.invalidTANNo;

                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            if (provider.hoTanErrorText != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  provider.hoTanErrorText!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.email, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.hoApplicantEmailController,
                                AppLocalizations.of(context)!.email,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.emailAddress,
                                // isEnabled: false,
                                boxColor: fafafaColor,
                                fun: (value) {
                                  provider.hoApplicantEmailError =
                                      value.isNotEmpty && value.isValidEmail()
                                          ? null
                                          : AppLocalizations.of(context)!.invalidEmail;
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            if (provider.hoApplicantEmailError != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  provider.hoApplicantEmailError!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.state, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildSearchableDropdown<StateData>(
                                items: provider.stateList,

                                // ✅ MAP YOUR MODEL HERE
                                getId: (item) => item.iD.toString(),
                                // getName: (item) => item.name ?? "",
                                getName: (item) {
                                  final locale = AppLocalizations.of(context)!.localeName;

                                  return locale == 'hi'
                                      ? (item.nameHI ?? item.name ?? "")
                                      : (item.name ?? "");
                                },
                                controller: provider.stateController,
                                idController: provider.stateIdController,
                                hintText: AppLocalizations.of(context)!.selectState,
                                // height: 50,
                                // selectedValue: provider.selectedState,
                                // getLabel: (e) => e.name ?? "",
                                onChanged: (value) {
                                  provider.selectedState = value;

                                  provider.stateController.text =
                                      value?.name ?? "";
                                  provider.stateIdController.text =
                                      value?.iD.toString() ?? "";

                                  provider.selectedDistrict = null;
                                  provider.districtHoController.clear();
                                  provider.locationList.clear();

                                  provider.getDistrictApi(context, value!.iD!);
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.district, required: true),
                            ),
                            provider.isDistrictLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child:
                                    buildSearchableDropdown<
                                            DistrictData>(
                                      items: provider.districtList,

                                      // ✅ MAP YOUR MODEL HERE
                                      getId: (item) => item.iD.toString(),
                                     // getName: (item) => item.name ?? "",

                                      getName: (item) {
                                        final locale = AppLocalizations.of(context)!.localeName;

                                        return locale == 'hi'
                                            ? (item.nameHi ?? item.name ?? "")
                                            : (item.name ?? "");
                                      },

                                      controller: provider.districtHoController,
                                      idController:
                                          provider.districtIdController,
                                      hintText: AppLocalizations.of(context)!.selectDistrict,
                                      // height: 50,
                                      // selectedValue: provider.selectedDistrict,
                                      // getLabel: (e) => e.name ?? "",
                                      onChanged: (value) {
                                        provider.selectedDistrict = value;

                                        provider.districtHoController.text =
                                            value?.name ?? "";
                                        provider.districtIdController.text =
                                            value?.iD.toString() ?? "";

                                        // 🔴 CLEAR CITY
                                        provider.selectedCity = null;
                                        provider.cityHoController.clear();
                                        provider.cityIdController.clear();
                                        provider.locationList.clear();

                                        provider.getCityApi(
                                            context, value!.code!.toString());
                                        provider.notifyListeners();
                                      },
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.city, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildSearchableDropdown<
                                  CityData>(
                                items: provider.locationList,

                                // ✅ MAP YOUR MODEL HERE
                                getId: (item) => item.iD.toString(),
                                //getName: (item) => item.nameEng ?? "",

                                getName: (item) {
                                  final locale = AppLocalizations.of(context)!.localeName;

                                  return locale == 'hi'
                                      ? (item.nameHi ?? item.nameEng ?? "")
                                      : (item.nameEng ?? "");
                                },

                                controller: provider.cityHoController,
                                idController: provider.cityIdController,
                                hintText: AppLocalizations.of(context)!.selectCity,
                                // height: 50,
                                // selectedValue: provider.selectedCity,
                                // getLabel: (e) => e.nameEng ?? "",
                                onChanged: (value) {
                                  provider.selectedCity = value;

                                  provider.cityHoController.text =
                                      value?.nameEng ?? "";
                                  provider.cityIdController.text =
                                      value?.iD.toString() ?? "";

                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.website),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.websiteController,
                                AppLocalizations.of(context)!.website,
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
                              child: labelWithStar(AppLocalizations.of(context)!.applicantAddress,
                                  required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.applicantAddressController,
                                AppLocalizations.of(context)!.applicantAddress,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider.isEditable(
                                    provider.applicantAddressController),
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.nicCode, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.nicCodeController,
                                AppLocalizations.of(context)!.nicCode,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: provider
                                    .isEditable(provider.nicCodeController),
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
                                "5. " + AppLocalizations.of(context)!.contactPerDetail + " :-",
                                style: Styles.semiBoldTextStyle(
                                    size: 14, color: kWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.panNo),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactPanController,
                                AppLocalizations.of(context)!.panNo,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                textLenght: 10,
                                // isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  LengthLimitingTextInputFormatter(10),
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[A-Za-z0-9]')),
                                ],
                                fun: (value) {
                                  final pan = value.toUpperCase();

                                  // force uppercase in field
                                  provider.contactPanController.value = provider
                                      .contactPanController.value
                                      .copyWith(
                                    text: pan,
                                    selection: TextSelection.collapsed(
                                        offset: pan.length),
                                  );

                                  // validation (same as HO PAN)
                                  provider.contactPanError =
                                      pan.length == 10 && pan.isValidPanCardNo()
                                          ? null
                                          : AppLocalizations.of(context)!.invalidPANNo;

                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            if (provider.contactPanError != null)
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                child: Text(
                                  provider.contactPanError!,
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.fullName, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactNameController,
                                AppLocalizations.of(context)!.fullName,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z\s]')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.mobileNo,
                                  required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactMobileController,
                                AppLocalizations.of(context)!.mobileNo,
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
                                  if (value.length != 10) {
                                    provider.contactMobileError =
                                        AppLocalizations.of(context)!.telNo10digit;
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
                              child: labelWithStar(AppLocalizations.of(context)!.alterMobile,
                                  required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactAltMobileController,
                                AppLocalizations.of(context)!.alterMobile,
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
                                  if (value.length != 10) {
                                    provider.contactAlterMobileError =
                                        AppLocalizations.of(context)!.telNo10digit;
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
                              child: labelWithStar(AppLocalizations.of(context)!.email, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactEmailController,
                                AppLocalizations.of(context)!.email,
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
                                  style: const TextStyle(
                                      color: Colors.red, fontSize: 12),
                                ),
                              ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.state, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildSearchableDropdown<StateData>(
                                items: provider.coStateList,

                                // ✅ MAP YOUR MODEL HERE
                                getId: (item) => item.iD.toString(),
                                // getName: (item) => item.name ?? "",

                                getName: (item) {
                                  final locale = AppLocalizations.of(context)!.localeName;

                                  return locale == 'hi'
                                      ? (item.nameHI ?? item.name ?? "")
                                      : (item.name ?? "");
                                },

                                controller: provider.coStateController,
                                idController: provider.coStateIdController,
                                hintText: AppLocalizations.of(context)!.selectState,
                                // height: 50,
                                // selectedValue: provider.coSelectedState,
                                // getLabel: (e) => e.name ?? "",
                                onChanged: (value) {
                                  provider.coSelectedState = value;

                                  provider.coStateController.text =
                                      value?.name ?? "";
                                  provider.coStateIdController.text =
                                      value?.iD.toString() ?? "";

                                  provider.coSelectedDistrict = null;
                                  provider.coDistrictController.clear();
                                  provider.coLocationList.clear();

                                  provider.getDistrictApi(context, value!.iD!);
                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.district, required: true),
                            ),
                            provider.iscoDistrictLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child:
                                    buildSearchableDropdown<
                                            DistrictData>(
                                      items: provider.coDistrictList,

                                      // ✅ MAP YOUR MODEL HERE
                                      getId: (item) => item.iD.toString(),
                                      //getName: (item) => item.name ?? "",

                                      getName: (item) {
                                        final locale = AppLocalizations.of(context)!.localeName;

                                        return locale == 'hi'
                                            ? (item.nameHi ?? item.name ?? "")
                                            : (item.name ?? "");
                                      },

                                      controller: provider.coDistrictController,
                                      idController:
                                          provider.coDistrictIdController,
                                      hintText: AppLocalizations.of(context)!.selOption,
                                      // height: 50,
                                      // selectedValue:
                                      //     provider.coSelectedDistrict,
                                      // getLabel: (e) => e.name ?? "",
                                      onChanged: (value) {
                                        provider.coSelectedDistrict = value;

                                        provider.coDistrictController.text =
                                            value?.name ?? "";
                                        provider.coDistrictIdController.text =
                                            value?.iD.toString() ?? "";

                                        // 🔴 CLEAR CITY
                                        provider.coSelectedCity = null;
                                        provider.coCityController.clear();
                                        provider.coCityIdController.clear();
                                        provider.coLocationList.clear();

                                        provider.getCityApi(
                                            context, value!.code!.toString());
                                        provider.notifyListeners();
                                      },
                                    ),
                                  ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.city, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildSearchableDropdown<
                                  CityData>(
                                items: provider.coLocationList,

                                // ✅ MAP YOUR MODEL HERE
                                getId: (item) => item.iD.toString(),
                                //getName: (item) => item.nameEng ?? "",

                                getName: (item) {
                                  final locale = AppLocalizations.of(context)!.localeName;

                                  return locale == 'hi'
                                      ? (item.nameHi ?? item.nameEng ?? "")
                                      : (item.nameEng ?? "");
                                },

                                controller: provider.coCityController,
                                idController: provider.coCityIdController,
                                hintText: AppLocalizations.of(context)!.selectCity,
                                // height: 50,
                                // selectedValue: provider.coSelectedCity,
                                // getLabel: (e) => e.nameEng ?? "",
                                onChanged: (value) {
                                  provider.coSelectedCity = value;

                                  provider.coCityController.text =
                                      value?.nameEng ?? "";
                                  provider.coCityIdController.text =
                                      value?.iD.toString() ?? "";

                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.pincode, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactPincodeController,
                                AppLocalizations.of(context)!.pincode,
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
                              child:
                                  labelWithStar(AppLocalizations.of(context)!.designation, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactDesignationController,
                                AppLocalizations.of(context)!.designation,
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
                                  labelWithStar(AppLocalizations.of(context)!.department, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactDepartmentController,
                                AppLocalizations.of(context)!.department,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                //  isEnabled: false,
                                boxColor: fafafaColor,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp(r'[a-zA-Z\s]')),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.address, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactAddressController,
                                AppLocalizations.of(context)!.address,
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
                                "6. " + AppLocalizations.of(context)!.exchangeNameDistrictEmpOfc +" :-",
                                style: Styles.semiBoldTextStyle(
                                    size: 14, color: kWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.exchangeName,
                                  required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.exchangeNameController,
                                AppLocalizations.of(context)!.exchangeName,
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
                                "7. " + AppLocalizations.of(context)!.exchangeMarInfoProg + " :-",
                                style: Styles.semiBoldTextStyle(
                                    size: 14, color: kWhite),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.typeOfOrg,
                                  required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              // child: buildDropdownWithBorder(
                              //   hint: "--Select Option--",
                              //   value: provider.organisationType,
                              //   boxColor: fafafaColor,
                              //   onChanged: provider.setOrganisationType,
                              //   items: const [
                              //     DropdownMenuItem(
                              //         value: "Private", child: Text("Private")),
                              //     DropdownMenuItem(
                              //         value: "Government",
                              //         child: Text("Government")),
                              //     DropdownMenuItem(
                              //         value: "PSU", child: Text("PSU")),
                              //   ],
                              // ),

                              child: buildSearchableDropdown<String>(
                                items: ["Private", "Government", "PSU"],

                                getId: (item) => item,
                                getName: (item) => item,

                                controller: provider.organisationTypeController,
                                idController: provider.organisationTypeIdController,

                                hintText: AppLocalizations.of(context)!.selOption,

                                onChanged: (value) {
                                  provider.organisationType = value;

                                  provider.organisationTypeController.text = value ?? "";
                                  provider.organisationTypeIdController.text = value ?? "";

                                  provider.notifyListeners();
                                },
                              ),
                            ),
                            if (provider.showGovtBody) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: labelWithStar(AppLocalizations.of(context)!.govtBody,
                                    required: true),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),

                                child: buildSearchableDropdown<String>(
                                  items: [
                                    "Central Government",
                                    "Local Body",
                                    "State Government",
                                    "State Quasi Government",
                                    "Central Quasi Government",
                                  ],

                                  getId: (item) => item,
                                  getName: (item) => item,

                                  controller: provider.govtBodyController,
                                  idController: provider.govtBodyIdController,

                                  hintText: AppLocalizations.of(context)!.selOption,

                                  onChanged: (value) {
                                    provider.govtBody = value;

                                    provider.govtBodyController.text = value ?? "";
                                    provider.govtBodyIdController.text = value ?? "";

                                    provider.notifyListeners();
                                  },
                                ),

                                // child: buildDropdownWithBorder(
                                //   hint: "--Select Option--",
                                //   value: provider.govtBody,
                                //   boxColor: fafafaColor,
                                //   onChanged: provider.setGovtBody,
                                //   items: const [
                                //     DropdownMenuItem(
                                //         value: "Central",
                                //         child: Text("Central Government")),
                                //     DropdownMenuItem(
                                //         value: "Local Body",
                                //         child: Text("Local Body")),
                                //     DropdownMenuItem(
                                //         value: "State Government",
                                //         child: Text("State Government")),
                                //     DropdownMenuItem(
                                //         value: "State Quasi Government",
                                //         child: Text("State Quasi Government")),
                                //     DropdownMenuItem(
                                //         value: "Central Quasi Government",
                                //         child:
                                //             Text("Central Quasi Government")),
                                //   ],
                                // ),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.noOfMaleEmp,
                                  required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.noOfMaleEmpController,
                                AppLocalizations.of(context)!.noOfMaleEmp,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                fun: (_) => provider.calculateTotalEmployees(),
                                // isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.noOfFemaleEmp,
                                  required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.noOfFemaleEmpController,
                                AppLocalizations.of(context)!.noOfFemaleEmp,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                fun: (_) => provider.calculateTotalEmployees(),
                                // isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.noOfTransEmp,
                                  required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.noOfTransEmpController,
                                AppLocalizations.of(context)!.noOfTransEmp,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly
                                ],
                                fun: (_) => provider.calculateTotalEmployees(),
                                // isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.totalNoEmp,
                                  required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.noOfTotalEmpController,
                                AppLocalizations.of(context)!.totalNoEmp,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                isEnabled: false,
                                // isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            if (provider.showActEst) ...[
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: labelWithStar(AppLocalizations.of(context)!.actEst,
                                    required: true),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: DropdownButtonFormField<
                                    ActEstablishmentData>(
                                  value: provider.selectedActEst,
                                  isExpanded: true,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: fafafaColor,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  hint: Text(AppLocalizations.of(context)!.selOption),
                                  // items: provider.actEstList
                                  //     .map(
                                  //       (e) => DropdownMenuItem<
                                  //           ActEstablishmentData>(
                                  //         value: e,
                                  //         child: Text(e.actEstablishment ?? ""),
                                  //       ),
                                  //     )
                                  //     .toList(),

                                  items: provider.actEstList.map(
                                        (e) {
                                      final locale = AppLocalizations.of(context)!.localeName;

                                      return DropdownMenuItem<ActEstablishmentData>(
                                        value: e,
                                        child: Text(
                                          locale == 'hi'
                                              ? (e.nameHi ?? e.actEstablishment ?? "")
                                              : (e.actEstablishment ?? ""),
                                        ),
                                      );
                                    },
                                  ).toList(),

                                  // 🔒 ALWAYS DISABLED
                                  onChanged: null,
                                ),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.indusType,
                                  required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildSearchableDropdown<String>(
                                items: [
                                  "Manufacturing",
                                  "IT",
                                  "Service",
                                ],

                                getId: (item) => item,
                                getName: (item) => item,

                                controller: provider.industryTypeController,
                                idController: provider.industryTypeIdController,

                                hintText: AppLocalizations.of(context)!.selOption,

                                onChanged: (value) {
                                  provider.industryType = value;

                                  provider.industryTypeController.text = value ?? "";
                                  provider.industryTypeIdController.text = value ?? "";

                                  provider.notifyListeners();
                                },
                              ),
                              // child: buildDropdownWithBorder(
                              //   hint: "--Select Option--",
                              //   value: provider.industryType,
                              //   boxColor: fafafaColor,
                              //   onChanged: provider.setIndustryType,
                              //   items: const [
                              //     DropdownMenuItem(
                              //         value: "Manufacturing",
                              //         child: Text("Manufacturing")),
                              //     DropdownMenuItem(
                              //         value: "IT", child: Text("IT")),
                              //     DropdownMenuItem(
                              //         value: "Service", child: Text("Service")),
                              //   ],
                              // ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(AppLocalizations.of(context)!.sector, required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
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
                                hint: Text(AppLocalizations.of(context)!.selOption),
                                // items: provider.sectorList
                                //     .map(
                                //       (e) => DropdownMenuItem<SectorData>(
                                //         value: e,
                                //         child: Text(e.name ?? ""),
                                //       ),
                                //     )
                                //     .toList(),

                                items: provider.sectorList.map(
                                      (e) {
                                    final locale = AppLocalizations.of(context)!.localeName;

                                    return DropdownMenuItem<SectorData>(
                                      value: e,
                                      child: Text(
                                        locale == 'hi'
                                            ? (e.nameHi ?? e.name ?? "")
                                            : (e.name ?? ""),
                                      ),
                                    );
                                  },
                                ).toList(),

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
                                "8. " + AppLocalizations.of(context)!.uploadOrgCompDoc + " :-",
                                style: Styles.semiBoldTextStyle(
                                    size: 14, color: kWhite),
                              ),
                            ),
                            // buildImageUploadBox(
                            //   title: "PAN Certificate",
                            //   imageFile: provider.panCertificateController,
                            //   onTap: () {
                            //     provider.pickAndUploadPdf(
                            //       context: context,
                            //       onFileSelected: (file) {
                            //         provider.panCertificateController = file;
                            //       },
                            //       onUploadSuccess: (path, name) {
                            //         provider.panFilePath = path;
                            //       },
                            //     );
                            //   },
                            // ),
                            // buildImageUploadBox(
                            //   title: "TAN Certificate",
                            //   imageFile: provider.tanCertificateController,
                            //   onTap: () {
                            //     provider.pickAndUploadPdf(
                            //       context: context,
                            //       onFileSelected: (file) {
                            //         provider.tanCertificateController = file;
                            //       },
                            //       onUploadSuccess: (path, name) {
                            //         provider.tanFilePath = path;
                            //       },
                            //     );
                            //   },
                            // ),
                            // buildImageUploadBox(
                            //   title: "GST Certificate",
                            //   imageFile: provider.gstCertificateController,
                            //   onTap: () {
                            //     provider.pickAndUploadPdf(
                            //       context: context,
                            //       onFileSelected: (file) {
                            //         provider.gstCertificateController = file;
                            //       },
                            //       onUploadSuccess: (path, name) {
                            //         provider.gstFilePath = path;
                            //       },
                            //     );
                            //   },
                            // ),
                            // buildImageUploadBox(
                            //   title: "Choose Logo (PNG/JPG/JPEG)",
                            //   imageFile: provider.logoController,
                            //   onTap: () {
                            //     provider.pickAndUploadImage(
                            //       context: context,
                            //       allowedExtensions: ['png', 'jpg', 'jpeg'],
                            //       onFileSelected: (file) {
                            //         provider.logoController = file;
                            //       },
                            //       onUploadSuccess: (path, name) {
                            //         provider.logoFilePath = path;
                            //       },
                            //     );
                            //   },
                            // ),

                            Consumer<EmpOTRFormProvider>(
                              builder: (context, provider, _) {
                                return Column(
                                  children: provider.documentMasterList.map((doc) {
                                    final isLogo = doc.shortName == "Logo";

                                    return buildImageUploadBox(
                                      title: doc.documentMasterEn ?? "",
                                      imageFile:
                                      provider.documentFileMap[doc.documentMasterId],
                                      onTap: () {
                                        if (isLogo) {
                                          provider.pickAndUploadImage(
                                            context: context,
                                            documentMasterId: doc.documentMasterId!,
                                            allowedExtensions: ['png', 'jpg', 'jpeg'],
                                            onFileSelected: (file) {
                                              provider.documentFileMap[doc.documentMasterId!] =
                                                  file;
                                            },
                                            onUploadSuccess: (path, name) {
                                              provider.documentUploadedPathMap[
                                              doc.documentMasterId!] = name;
                                            },
                                          );
                                        } else {
                                          provider.pickAndUploadPdf(
                                            context: context,
                                            documentMasterId: doc.documentMasterId!,
                                            onFileSelected: (file) {
                                              provider.documentFileMap[doc.documentMasterId!] =
                                                  file;
                                            },
                                            onUploadSuccess: (path, name) {
                                              provider.documentUploadedPathMap[
                                              doc.documentMasterId!] = name;
                                            },
                                          );
                                        }
                                      },
                                    );
                                  }).toList(),
                                );
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
                            //provider.submitEmpOTRForm(context);
                            if (validateEmpOTRBasicAndOfficeDetails(
                                context, provider)) {
                              confirmAlertDialog(
                                context,
                                AppLocalizations.of(context)!.confirmSub,
                                AppLocalizations.of(context)!.areYouSureSubmitForm,
                                (value) {
                                  if (value.toString() == "success") {
                                    provider.submitEmpOTRForm(context);
                                  }
                                },
                              );
                              // NEXT STEP
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: kPrimaryColor, // nicer blue
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 0,
                          ),
                          child: Text(AppLocalizations.of(context)!.save,
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
    VoidCallback? onTap,
  }) {
    final bool isPdf =
        imageFile != null && imageFile.path.toLowerCase().endsWith('.pdf');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          GestureDetector(
            onTap: onTap,
            child: Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: imageFile == null
                  ? const Center(
                child: Icon(Icons.cloud_upload, size: 30),
              )

              // ✅ PDF UI
                  : isPdf
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.picture_as_pdf,
                    color: Colors.red,
                    size: 36,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      imageFile.path.split('/').last,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              )

              // ✅ IMAGE UI
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
        ],
      ),
    );
  }

}

bool validateEmpOTRBasicAndOfficeDetails(
  BuildContext context,
  EmpOTRFormProvider provider,
) {
  /// =========================
  /// 1️⃣ BASIC DETAILS
  /// =========================

  if (provider.brnController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterBRN, context);
    return false;
  }

  if (provider.districtController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterDistrict, context);
    return false;
  }

  if (provider.areaType == null || provider.areaType!.isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzSelAreaRU, context);
    return false;
  }

  if (provider.tehsilController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterTehsil, context);
    return false;
  }

  if (provider.areaType == 'Rural' &&
      provider.villageController.text.trim().isEmpty) {
    provider.villageController.text = 'salumbar';
    // showAlertError("Please enter Village", context);
    // return false;
  }

  if (provider.localBodyController.text.trim().isEmpty) {
    provider.localBodyController.text = 'salumbar';
    // showAlertError("Please enter Local Body", context);
    // return false;
  }

  if (provider.areaType == 'Urban' &&
      provider.wardController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterWard, context);
    return false;
  }

  /// =========================
  /// 2️⃣ BRANCH OFFICE DETAILS
  /// =========================

  if (provider.companyNameController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterCompName, context);
    return false;
  }

  if (provider.houseNoController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterHouseNo, context);
    return false;
  }

  if (provider.laneController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterLane, context);
    return false;
  }

  if (provider.localityController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterLocality, context);
    return false;
  }

  if (provider.pinCodeController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterPinCode, context);
    return false;
  }

  if (provider.pinCodeController.text.length != 6) {
    showAlertError(AppLocalizations.of(context)!.pinCode6digit, context);
    return false;
  }

  if (provider.telNoController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterTelNo, context);
    return false;
  }

  if (provider.telError != null) {
    showAlertError(provider.telError!, context);
    return false;
  }

  if (provider.emailController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterEmail, context);
    return false;
  }

  if (provider.emailErrorText != null) {
    showAlertError(provider.emailErrorText!, context);
    return false;
  }

  if (provider.gstController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterGSTNo, context);
    return false;
  }

  if (provider.gstLengthError != null || provider.gstFormatError != null) {
    showAlertError(
      provider.gstLengthError ?? provider.gstFormatError!,
      context,
    );
    return false;
  }

  if (provider.panController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterPANNo, context);
    return false;
  }

  if (provider.panErrorText != null) {
    showAlertError(provider.panErrorText!, context);
    return false;
  }

  if (provider.panHolderController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterPANHolderName, context);
    return false;
  }

  if (provider.panVerifiedController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzVerifyPAN, context);
    return false;
  }

  if (provider.tanController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterTANNo, context);
    return false;
  }

  if (provider.tanErrorText != null) {
    showAlertError(provider.tanErrorText!, context);
    return false;
  }

  /// =========================
  /// 3️⃣ HEAD OFFICE DETAILS
  /// =========================

  if (provider.hoCompanyNameController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterHeadOfficeCompName, context);
    return false;
  }

  if (provider.hoTelNoController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterHeadOfficeTelNo, context);
    return false;
  }

  if (provider.hoEmailController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterHeadOfficeEmail, context);
    return false;
  }

  if (provider.emailErrorText != null) {
    showAlertError(provider.emailErrorText!, context);
    return false;
  }

  if (provider.hoPanController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterHeadOfficePANNo, context);
    return false;
  }

  if (provider.panErrorText != null) {
    showAlertError(provider.panErrorText!, context);
    return false;
  }

  if (provider.hoHouseNoController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterHeadOfficeHouseNo, context);
    return false;
  }

  if (provider.hoLaneController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterHeadOfficeLane, context);
    return false;
  }

  if (provider.hoLocalityController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterHeadOfficeLocality, context);
    return false;
  }

  if (provider.hoPincodeController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterHeadOfficePincode, context);
    return false;
  }

  if (provider.hoPincodeController.text.length != 6) {
    showAlertError(AppLocalizations.of(context)!.headOffPin6Digit, context);
    return false;
  }

  /// =========================
  /// 4️⃣ HEAD OFFICE APPLICANT DETAILS
  /// =========================
  if (provider.applicantNameController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterApplicantName, context);
    return false;
  }

  if (provider.applicantMobileController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterAppMobileNo, context);
    return false;
  }

  if (provider.applicantMobileController.text.length != 10) {
    showAlertError(AppLocalizations.of(context)!.applicantMobile10Digit, context);
    return false;
  }

  if (provider.applicantEmailController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterApplicantEmail, context);
    return false;
  }

  if (provider.applicantEmailError != null) {
    showAlertError(provider.applicantEmailError!, context);
    return false;
  }

  /// STATE
  if (provider.selectedState == null ||
      provider.stateController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzSelectState, context);
    return false;
  }

  /// DISTRICT
  if (provider.selectedDistrict == null ||
      provider.districtHoController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzSelectDistrict, context);
    return false;
  }

  /// CITY
  if (provider.selectedCity == null ||
      provider.cityHoController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzSelectCity, context);
    return false;
  }

  if (provider.yearController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterYear, context);
    return false;
  }

  if (provider.ownershipController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterOwnership, context);
    return false;
  }

  if (provider.totalPersonController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterTotalPer, context);
    return false;
  }

  if (provider.actAuthorityRegController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterActAuthReg, context);
    return false;
  }

  if (provider.tanNoController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterTANNo, context);
    return false;
  }

  if (provider.hoTanErrorText != null) {
    showAlertError(provider.hoTanErrorText!, context);
    return false;
  }

  if (provider.hoApplicantEmailController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterEmail, context);
    return false;
  }

  if (provider.hoApplicantEmailError != null) {
    showAlertError(provider.hoApplicantEmailError!, context);
    return false;
  }

  if (provider.stateController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzSelectState, context);
    return false;
  }

  if (provider.districtHoController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzSelectDistrict, context);
    return false;
  }

  if (provider.cityHoController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzSelectCity, context);
    return false;
  }

  // if (provider.websiteController.text.trim().isEmpty) {
  //   showAlertError("Please enter Website", context);
  //   return false;
  // }

  if (provider.applicantAddressController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterApplicantAddress, context);
    return false;
  }

  if (provider.nicCodeController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterNicCode, context);
    return false;
  }

  /// =========================
  /// 5️⃣ CONTACT PERSON DETAILS
  /// =========================
  // if (provider.contactPanController.text.trim().isEmpty) {
  //   showAlertError("Please enter Contact PAN No", context);
  //   return false;
  // }

  if (provider.contactPanError != null) {
    showAlertError(provider.contactPanError!, context);
    return false;
  }

  if (provider.contactNameController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterContactFullName, context);
    return false;
  }

  if (provider.contactMobileController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterContactMobileNo, context);
    return false;
  }

  if (provider.contactMobileError != null) {
    showAlertError(provider.contactMobileError!, context);
    return false;
  }

  // if (provider.contactAltMobileController.text.trim().isEmpty) {
  //   showAlertError("Please enter Contact Alternate Mobile", context);
  //   return false;
  // }

  if (provider.contactAlterMobileError != null) {
    showAlertError(provider.contactAlterMobileError!, context);
    return false;
  }

  if (provider.contactEmailController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterContactEmail, context);
    return false;
  }

  if (provider.emailErrorText != null) {
    showAlertError(provider.emailErrorText!, context);
    return false;
  }

  /// CONTACT STATE
  if (provider.coSelectedState == null ||
      provider.coStateController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzSelContactState, context);
    return false;
  }

  /// CONTACT DISTRICT
  if (provider.coSelectedDistrict == null ||
      provider.coDistrictController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzSelContactDistrict, context);
    return false;
  }

  /// CONTACT CITY
  if (provider.coSelectedCity == null ||
      provider.coCityController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzSelContactCity, context);
    return false;
  }

  if (provider.coStateController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzSelContactState, context);
    return false;
  }

  if (provider.coDistrictController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzSelContactDistrict, context);
    return false;
  }

  if (provider.coCityController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzSelContactCity, context);
    return false;
  }

  if (provider.contactPincodeController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterContactPincode, context);
    return false;
  }

  if (provider.contactDesignationController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterContactDesig, context);
    return false;
  }

  if (provider.contactDepartmentController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterContactDept, context);
    return false;
  }

  if (provider.contactAddressController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterContactAddress, context);
    return false;
  }

  /// =========================
  /// 6️⃣ EXCHANGE / DISTRICT EMPLOYMENT OFFICE
  /// =========================
  if (provider.exchangeNameController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterExchangeName, context);
    return false;
  }

  /// 7 exchange market information
  int male = int.tryParse(provider.noOfMaleEmpController.text) ?? 0;
  int female = int.tryParse(provider.noOfFemaleEmpController.text) ?? 0;
  int trans = int.tryParse(provider.noOfTransEmpController.text) ?? 0;
  int total = int.tryParse(provider.noOfTotalEmpController.text) ?? 0;

  /// MALE
  if (provider.noOfMaleEmpController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterNoOfMaleEmp, context);
    return false;
  }

  /// FEMALE
  if (provider.noOfFemaleEmpController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterNoOfFemaleEmp, context);
    return false;
  }

  /// TRANSGENDER
  if (provider.noOfTransEmpController.text.trim().isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzEnterNoOfTransEmp, context);
    return false;
  }

  /// TOTAL CHECK
  if (total != (male + female + trans)) {
    showAlertError(AppLocalizations.of(context)!.totalEmpCountIncorrect, context);
    return false;
  }

  /// ORGANIZATION TYPE
  if (provider.organisationType == null ||
      provider.organisationType!.isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzSelTypeOrg, context);
    return false;
  }

  /// GOVERNMENT BODY
  if (provider.showGovtBody &&
      provider.organisationType != null) {
    if (provider.govtBody == null || provider.govtBody!.isEmpty) {
      showAlertError(AppLocalizations.of(context)!.plzSelGovtBody, context);
      return false;
    }
  }

  /// ACT ESTABLISHMENT
  if (provider.showActEst &&
      provider.organisationType != null) {
    if (provider.selectedActEst == null) {
      showAlertError(AppLocalizations.of(context)!.plzSelActEst, context);
      return false;
    }
  }


  /// INDUSTRY TYPE
  if (provider.industryType == null ||
      provider.industryType!.isEmpty) {
    showAlertError(AppLocalizations.of(context)!.plzSelIndusType, context);
    return false;
  }

  /// SECTOR
  if (provider.selectedSector == null) {
    showAlertError(AppLocalizations.of(context)!.plzSelectSector, context);
    return false;
  }


  /// ✅ ALL VALIDATIONS PASSED
  return true;
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
        fillColor: fafafaColor,
        // SAME as text field
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
