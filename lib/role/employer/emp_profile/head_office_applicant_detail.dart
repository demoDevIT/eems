import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/dropdown.dart';
import 'provider/head_office_applicant_detail_provider.dart';

class HeadOfficeApplicantDetailScreen extends StatefulWidget {
  const HeadOfficeApplicantDetailScreen({super.key});

  @override
  State<HeadOfficeApplicantDetailScreen> createState() =>
      _HeadOfficeApplicantDetailScreenState();
}

class _HeadOfficeApplicantDetailScreenState
    extends State<HeadOfficeApplicantDetailScreen> {

  // Text Controllers
  final TextEditingController applicantNameCtrl = TextEditingController();
  final TextEditingController applicantMobileCtrl = TextEditingController();
  final TextEditingController applicantEmailCtrl = TextEditingController();
  final TextEditingController yearCtrl = TextEditingController();
  final TextEditingController ownershipCtrl = TextEditingController();
  final TextEditingController totalPersonCtrl = TextEditingController();
  final TextEditingController actAuthorityRegCtrl = TextEditingController();
  final TextEditingController tanCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController websiteCtrl = TextEditingController();
  final TextEditingController applicantAddressCtrl = TextEditingController();
  final TextEditingController nicCodeCtrl = TextEditingController();

  // Dropdown values
  String? selectedState;
  String? selectedDistrict;
  String? selectedCity;

  @override
  void initState() {
    super.initState();

    final provider =
    Provider.of<HeadOfficeApplicantDetailProvider>(context, listen: false);

    provider.printUserData();

    applicantNameCtrl.text = provider.applicantNameCtrl;
    applicantMobileCtrl.text = provider.applicantMobileCtrl;
    applicantEmailCtrl.text = provider.applicantEmailCtrl;
    yearCtrl.text = provider.yearCtrl;
    ownershipCtrl.text = provider.ownershipCtrl;
  //  totalPersonCtrl.text = provider.totalPersonCtrl;
    actAuthorityRegCtrl.text = provider.actAuthorityRegCtrl;
    tanCtrl.text = provider.tanCtrl;
    emailCtrl.text = provider.emailCtrl;
    websiteCtrl.text = provider.websiteCtrl;
    applicantAddressCtrl.text = provider.applicantAddressCtrl;
    nicCodeCtrl.text = provider.nicCodeCtrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Head Office Applicant Details",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _label("Applicant Name"),
            _field(applicantNameCtrl, "Enter applicant name"),

            _label("Applicant Mobile No."),
            _field(applicantMobileCtrl, "Enter mobile number", TextInputType.phone),

            _label("Applicant Email"),
            _field(applicantEmailCtrl, "Enter email", TextInputType.emailAddress),

            _label("Year"),
            _field(yearCtrl, "Enter year", TextInputType.number),

            _label("Ownership"),
            _field(ownershipCtrl, "Enter ownership"),

            _label("Total Person"),
            _field(totalPersonCtrl, "Enter total persons", TextInputType.number),

            _label("Act Authority Reg No"),
            _field(actAuthorityRegCtrl, "Enter registration number"),

            _label("TAN No"),
            _field(tanCtrl, "Enter TAN number"),

            _label("Email"),
            _field(emailCtrl, "Enter email", TextInputType.emailAddress),

            /// ===== Dropdowns =====
            _label("State"),
            buildDropdownField(
              "State",
              "Select state",
              value: selectedState,
              items: const ["State 1", "State 2"],
                onChanged: (value) {}, // disabled
            ),

            _label("District"),
            buildDropdownField(
              "District",
              "Select district",
              value: selectedDistrict,
              items: const ["District 1", "District 2"],
              onChanged: (value) {}, // disabled
            ),

            _label("City"),
            buildDropdownField(
              "City",
              "Select city",
              value: selectedCity,
              items: const ["City 1", "City 2"],
              onChanged: (value) {}, // disabled
            ),

            _label("Website"),
            _field(websiteCtrl, "Enter website"),

            _label("Applicant Address"),
            _field(applicantAddressCtrl, "Enter address"),

            _label("NIC Code"),
            _field(nicCodeCtrl, "Enter NIC code"),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// ===== Label =====
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Text(
        text,
        style: Styles.mediumTextStyle(size: 14, color: kBlackColor),
      ),
    );
  }

  /// ===== Disabled Text Field =====
  Widget _field(
      TextEditingController controller,
      String hint, [
        TextInputType keyboardType = TextInputType.text,
      ]) {
    return buildTextWithBorderField(
      controller,
      hint,
      MediaQuery.of(context).size.width,
      50,
      keyboardType,
      isEnabled: false,
    );
  }
}
