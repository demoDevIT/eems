import 'package:flutter/material.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/dropdown.dart';

class ExchangeMarketInformationProgram extends StatefulWidget {
  const ExchangeMarketInformationProgram({super.key});

  @override
  State<ExchangeMarketInformationProgram> createState() =>
      _ExchangeMarketInformationProgramState();
}

class _ExchangeMarketInformationProgramState
    extends State<ExchangeMarketInformationProgram> {

  // Text Controllers
  final TextEditingController maleEmpCtrl = TextEditingController();
  final TextEditingController femaleEmpCtrl = TextEditingController();
  final TextEditingController transgenderEmpCtrl = TextEditingController();
  final TextEditingController totalEmpCtrl = TextEditingController();

  // Dropdown values
  String? orgType;
  String? govtBody;
  String? actEstablishment;
  String? industryType;
  String? sector;

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
          "Exchange Market Information Program",
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

            /// ===== Dropdowns =====
            _label("Type of Organization"),
            buildDropdownField(
              "Type of Organization",
              "Select type",
              value: orgType,
              items: const ["Private", "Public"],
              onChanged: (value) {}, // disabled
            ),

            _label("Government Body"),
            buildDropdownField(
              "Government Body",
              "Select government body",
              value: govtBody,
              items: const ["Central", "State"],
              onChanged: (value) {}, // disabled
            ),

            /// ===== Employee Count =====
            _label("No of Male Employees"),
            _field(maleEmpCtrl, "Enter male employees", TextInputType.number),

            _label("No of Female Employees"),
            _field(femaleEmpCtrl, "Enter female employees", TextInputType.number),

            _label("No of Transgender Employees"),
            _field(transgenderEmpCtrl, "Enter transgender employees", TextInputType.number),

            _label("Total Number of Employees"),
            _field(totalEmpCtrl, "Enter total employees", TextInputType.number),

            /// ===== More Dropdowns =====
            _label("Act Establishment"),
            buildDropdownField(
              "Act Establishment",
              "Select act establishment",
              value: actEstablishment,
              items: const ["Act 1", "Act 2"],
              onChanged: (value) {}, // disabled
            ),

            _label("Industry Type"),
            buildDropdownField(
              "Industry Type",
              "Select industry type",
              value: industryType,
              items: const ["Manufacturing", "Service"],
              onChanged: (value) {}, // disabled
            ),

            _label("Sector"),
            buildDropdownField(
              "Sector",
              "Select sector",
              value: sector,
              items: const ["Public", "Private"],
              onChanged: (value) {}, // disabled
            ),

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
