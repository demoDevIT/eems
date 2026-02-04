import 'package:flutter/material.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/dropdown.dart';

class ContactPersonDetail extends StatefulWidget {
  const ContactPersonDetail({super.key});

  @override
  State<ContactPersonDetail> createState() =>
      _ContactPersonDetailState();
}

class _ContactPersonDetailState
    extends State<ContactPersonDetail> {

  // Text Controllers
  final TextEditingController panCtrl = TextEditingController();
  final TextEditingController fullNameCtrl = TextEditingController();
  final TextEditingController mobileCtrl = TextEditingController();
  final TextEditingController altMobileCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController pincodeCtrl = TextEditingController();
  final TextEditingController designationCtrl = TextEditingController();
  final TextEditingController departmentCtrl = TextEditingController();
  final TextEditingController addressCtrl = TextEditingController();

  // Dropdown values
  String? selectedState;
  String? selectedDistrict;
  String? selectedCity;

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
          "Contact Person Details",
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

            _label("PAN No"),
            _field(panCtrl, "Enter PAN number"),

            _label("Full Name"),
            _field(fullNameCtrl, "Enter full name"),

            _label("Mobile Number"),
            _field(mobileCtrl, "Enter mobile number", TextInputType.phone),

            _label("Alternate Mobile Number"),
            _field(altMobileCtrl, "Enter alternate mobile number",
                TextInputType.phone),

            _label("Email"),
            _field(emailCtrl, "Enter email", TextInputType.emailAddress),

            /// ===== Dropdowns (SAME STYLE) =====
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

            _label("Pincode"),
            _field(pincodeCtrl, "Enter pincode", TextInputType.number),

            _label("Designation"),
            _field(designationCtrl, "Enter designation"),

            _label("Department"),
            _field(departmentCtrl, "Enter department"),

            _label("Address"),
            _field(addressCtrl, "Enter address"),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// ===== Label (EXACT SAME AS APPLICANT PAGE) =====
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Text(
        text,
        style: Styles.mediumTextStyle(size: 14, color: kBlackColor),
      ),
    );
  }

  /// ===== Disabled Text Field (EXACT SAME) =====
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
