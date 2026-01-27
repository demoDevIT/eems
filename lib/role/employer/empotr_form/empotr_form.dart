import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';

import '../../../../repo/common_repo.dart';
import '../../../constants/colors.dart';
import '../../../utils/global.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../../job_seeker/loginscreen/provider/locale_provider.dart';
import 'provider/empotr_form_provider.dart';

class EmpOTRFormScreen extends StatefulWidget {
  final String ssoId;
  final String userID;

  const EmpOTRFormScreen({
    super.key,
    required this.ssoId,
    required this.userID,
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
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                      onChanged: (val) => setState(() =>
                                          provider.areaType =
                                              val ?? provider.areaType),
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
                                      onChanged: (val) => setState(() =>
                                          provider.areaType =
                                              val ?? provider.areaType),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      'No',
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
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
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
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
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
                                isEnabled: false,
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
                                isEnabled: false,
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
                                isEnabled: false,
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
                                isEnabled: false,
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
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
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
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
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
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
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
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
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
                                isEnabled: false,
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
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
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
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
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
                                isEnabled: false,
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
                                isEnabled: false,
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
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                isEnabled: false,
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
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                isEnabled: false,
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
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                isEnabled: false,
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
                                isEnabled: false,
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
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                              child: buildTextWithBorderField(
                                provider.stateController,
                                "State",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('District', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.districtHoController,
                                "District",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('City', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.cityHoController,
                                "City",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: false,
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
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                isEnabled: false,
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
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                              child: buildTextWithBorderField(
                                provider.contactStateController,
                                "State",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('District', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactDistrictController,
                                "District",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('City', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.contactCityController,
                                "City",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                isEnabled: false,
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
                                isEnabled: false,
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
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.organisationTypeController,
                                "Type of Organization",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('Government Body', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.govtBodyController,
                                "Government Body",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
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
                                TextInputType.text,
                                isEnabled: false,
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
                                TextInputType.text,
                                isEnabled: false,
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
                                TextInputType.text,
                                isEnabled: false,
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
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Act Establishment', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.actEstController,
                                "Act Establishment",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('Industry Type', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.industryTypetController,
                                "Industry Type",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              labelWithStar('Sector', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.sectorController,
                                "Sector",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// 8. Upload Organization/Company Documents
                      _sectionHeader(
                        "8. Upload Organization/Company Documents :-",
                      ),

                      _row(
                        _textField(
                            controller: provider.panCertificateController,
                            label: "PAN Certificate"),
                        _textField(
                            controller: provider.tanCertificateController,
                            label: "TAN Certificate"),
                      ),

                      _row(
                        _textField(
                            controller: provider.gstCertificateController,
                            label: "GST Certificate"),
                        _textField(
                            controller: provider.logoController,
                            label: "Choose Logo (PNG/JPG/JPEG)"),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            provider.submitEmpOTRForm(context);
                          },
                          child: const Text("Save & Continue"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ));
  }

  // ================= UI HELPERS =================

  Widget _sectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.teal,
      child: Text(
        title,
        style:
            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _row(Widget left, Widget right) {
    return Row(
      children: [
        Expanded(child: left),
        const SizedBox(width: 12),
        Expanded(child: right),
      ],
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _areaRadio(EmpOTRFormProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Area *", style: TextStyle(fontWeight: FontWeight.bold)),
        Row(
          children: [
            Radio<String>(
              value: "Rural",
              groupValue: provider.areaType,
              onChanged: provider.setArea,
            ),
            const Text("Rural"),
            Radio<String>(
              value: "Urban",
              groupValue: provider.areaType,
              onChanged: provider.setArea,
            ),
            const Text("Urban"),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}
