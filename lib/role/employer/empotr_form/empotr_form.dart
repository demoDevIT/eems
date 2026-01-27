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
      final provider =
      Provider.of<EmpOTRFormProvider>(context, listen: false);
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
                            MediaQuery
                                .of(context)
                                .size
                                .width,
                            50,
                            TextInputType.text,
                            isEnabled: false,
                            boxColor: fafafaColor
                        ),
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
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
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
                            MediaQuery
                                .of(context)
                                .size
                                .width,
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
                            MediaQuery
                                .of(context)
                                .size
                                .width,
                            50,
                            TextInputType.text,
                            isEnabled: false,
                            boxColor: fafafaColor,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: labelWithStar('Area',
                              required: true),
                        ),

                        Row(
                          children: [
                            Row(
                              children: [
                                Radio<String>(
                                  value: 'Rural',
                                  groupValue: provider.areaType,
                                  onChanged: (val) =>
                                      setState(() =>
                                      provider.areaType =
                                          val ??
                                              provider.areaType),
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
                                  onChanged: (val) =>
                                      setState(() =>
                                      provider.areaType =
                                          val ??
                                              provider.areaType),
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
                            MediaQuery
                                .of(context)
                                .size
                                .width,
                            50,
                            TextInputType.text,
                            isEnabled: false,
                            boxColor: fafafaColor,
                          ),
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: labelWithStar('Local Body', required: true),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          child: buildTextWithBorderField(
                            provider.localBodyController,
                            "Enter Local Body",
                            MediaQuery
                                .of(context)
                                .size
                                .width,
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
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width,
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
                              child: labelWithStar('Company Name', required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.companyNameController,
                                "Company Name",
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width,
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
                                provider.houseNoController,
                                "House Number",
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width,
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
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width,
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
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width,
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
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width,
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
                                provider.telNoController,
                                "Tel No",
                                MediaQuery
                                    .of(context)
                                    .size
                                    .width,
                                50,
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),

                          ],
                        ),
                      ),



                      /// 2. Branch Office Details
                      _sectionHeader(
                          "2. Branch Office Details (As on Sanstha Aadhaar) :-"),

                      _row(
                        _textField(
                            controller: provider.companyNameController,
                            label: "Company Name *"),
                        _textField(
                            controller: provider.houseNoController,
                            label: "House Number *"),
                      ),

                      _row(
                        _textField(
                            controller: provider.laneController,
                            label: "Lane *"),
                        _textField(
                            controller: provider.localityController,
                            label: "Locality *"),
                      ),

                      _row(
                        _textField(
                            controller: provider.pinCodeController,
                            label: "Pin Code *"),
                        _textField(
                            controller: provider.telNoController,
                            label: "Tel No *"),
                      ),

                      _row(
                        _textField(
                            controller: provider.emailController,
                            label: "Email *"),
                        _textField(
                            controller: provider.gstController,
                            label: "GST Number"),
                      ),

                      _row(
                        _textField(
                            controller: provider.panController,
                            label: "PAN Number"),
                        _textField(
                            controller: provider.panHolderController,
                            label: "PAN Holder"),
                      ),

                      _row(
                        _textField(
                            controller: provider.panVerifiedController,
                            label: "PAN Verified"),
                        _textField(
                            controller: provider.tanController,
                            label: "TAN Number"),
                      ),

                      const SizedBox(height: 24),

                      /// 3. Head Office Details
                      _sectionHeader(
                        "3. Head Office Details (As on Sanstha Aadhaar) :-",
                      ),

                      _row(
                        _textField(
                            controller: provider.hoCompanyNameController,
                            label: "Company Name *"),
                        _textField(
                            controller: provider.hoTelNoController,
                            label: "Tel No *"),
                      ),

                      _row(
                        _textField(
                            controller: provider.hoEmailController,
                            label: "Email *"),
                        _textField(
                            controller: provider.hoPanController,
                            label: "PAN No"),
                      ),

                      _row(
                        _textField(
                            controller: provider.hoHouseNoController,
                            label: "House Number"),
                        _textField(
                            controller: provider.hoLaneController,
                            label: "Lane"),
                      ),

                      _row(
                        _textField(
                            controller: provider.hoLocalityController,
                            label: "Locality"),
                        _textField(
                            controller: provider.hoPincodeController,
                            label: "Pincode"),
                      ),

                      const SizedBox(height: 24),

                      /// 4. Head Office Applicant Details
                      _sectionHeader(
                        "4. Head Office Applicant Details (As on Sanstha Aadhaar):-",
                      ),

                      _row(
                        _textField(
                            controller: provider.applicantNameController,
                            label: "Applicant Name *"),
                        _textField(
                            controller: provider.applicantMobileController,
                            label: "Applicant Mobile No. *"),
                      ),

                      _row(
                        _textField(
                            controller: provider.applicantEmailController,
                            label: "Applicant Email *"),
                        _textField(
                            controller: provider.yearController,
                            label: "Year"),
                      ),

                      _row(
                        _textField(
                            controller: provider.ownershipController,
                            label: "Ownership"),
                        _textField(
                            controller: provider.totalPersonController,
                            label: "Total Person"),
                      ),

                      _row(
                        _textField(
                            controller: provider.actAuthorityRegController,
                            label: "Act Authority Reg No"),
                        _textField(
                            controller: provider.tanNoController,
                            label: "TAN No"),
                      ),

                      _row(
                        _textField(
                            controller: provider.hoApplicantEmailController,
                            label: "Email"),
                        _textField(
                            controller: provider.websiteController,
                            label: "Website"),
                      ),

                      _row(
                        _textField(
                            controller: provider.nicCodeController,
                            label: "NIC Code"),
                        _textField(
                            controller: provider.applicantAddressController,
                            label: "Applicant Address"),
                      ),

                      /// NOTE: Dropdowns placeholder (same OTR pattern)
                      _row(
                        _textField(
                            controller: provider.stateController,
                            label: "State *"),
                        _textField(
                            controller: provider.districtHoController,
                            label: "District *"),
                      ),

                      _textField(
                          controller: provider.cityHoController,
                          label: "City"),

                      const SizedBox(height: 24),

                      /// 5. Contact Person Details
                      _sectionHeader(
                        "5. Contact person Details :-",
                      ),

                      _row(
                        _textField(
                            controller: provider.contactPanController,
                            label: "PAN No"),
                        _textField(
                            controller: provider.contactNameController,
                            label: "Full Name *"),
                      ),

                      _row(
                        _textField(
                            controller: provider.contactMobileController,
                            label: "Mobile Number *"),
                        _textField(
                            controller: provider.contactAltMobileController,
                            label: "Alternate Mobile Number"),
                      ),

                      _row(
                        _textField(
                            controller: provider.contactEmailController,
                            label: "Email *"),
                        _textField(
                            controller: provider.contactDesignationController,
                            label: "Designation"),
                      ),

                      _row(
                        _textField(
                            controller: provider.contactDepartmentController,
                            label: "Department"),
                        _textField(
                            controller: provider.contactPincodeController,
                            label: "Pincode"),
                      ),

                      _row(
                        _textField(
                            controller: provider.contactStateController,
                            label: "State"),
                        _textField(
                            controller: provider.contactDistrictController,
                            label: "District"),
                      ),

                      _textField(
                          controller: provider.contactCityController,
                          label: "City"),

                      _textField(
                          controller: provider.contactAddressController,
                          label: "Address"),

                      const SizedBox(height: 24),

                      /// 6. Exchange Name / District Employment Office
                      _sectionHeader(
                        "6. Exchange Name / District Employment Office :-",
                      ),

                      _textField(
                          controller: provider.exchangeNameController,
                          label: "Exchange Name"),

                      const SizedBox(height: 24),

                      /// 7. Exchange Market Information Program
                      _sectionHeader(
                        "7. Exchange Market Information Program :-",
                      ),

                      _row(
                        _textField(
                            controller: provider.organisationTypeController,
                            label: "Type of Organization *"),
                        _textField(
                            controller: provider.govtBodyController,
                            label: "Government Body*"),
                      ),

                      _row(
                        _textField(
                            controller: provider.noOfMaleEmpController,
                            label: "No of Male Employees *"),
                        _textField(
                            controller: provider.noOfFemaleEmpController,
                            label: "No of Female Employees*"),
                      ),

                      _row(
                        _textField(
                            controller: provider.noOfTransEmpController,
                            label: "No of Transgender Employees *"),
                        _textField(
                            controller: provider.noOfTotalEmpController,
                            label: "Total Number of Employees *"),
                      ),

                      _row(
                        _textField(
                            controller: provider.actEstController,
                            label: "Act Establishment *"),
                        _textField(
                            controller: provider.industryTypetController,
                            label: "Industry Type *"),
                      ),

                      _textField(
                          controller: provider.sectorController,
                          label: "Sector *"),


                      const SizedBox(height: 24),

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
        )
    );
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
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold),
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
