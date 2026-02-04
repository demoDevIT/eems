import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../utils/textfeild.dart';
import 'provider/branch_office_detail_provider.dart';

class BranchOfficeDetailScreen extends StatefulWidget {
  const BranchOfficeDetailScreen({super.key});

  @override
  State<BranchOfficeDetailScreen> createState() =>
      _BranchOfficeDetailScreenState();
}

class _BranchOfficeDetailScreenState
    extends State<BranchOfficeDetailScreen> {
  final TextEditingController companyNameCtrl = TextEditingController();
  final TextEditingController houseNumberCtrl = TextEditingController();
  final TextEditingController laneCtrl = TextEditingController();
  final TextEditingController localityCtrl = TextEditingController();
  final TextEditingController pinCodeCtrl = TextEditingController();
  final TextEditingController telNoCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController gstCtrl = TextEditingController();
  final TextEditingController panCtrl = TextEditingController();
  final TextEditingController panHolderCtrl = TextEditingController();
  final TextEditingController panVerifiedCtrl = TextEditingController();
  final TextEditingController tanCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    final provider =
    Provider.of<BranchOfficeDetailProvider>(context, listen: false);

    provider.printUserData();

    companyNameCtrl.text = provider.companyName;
    houseNumberCtrl.text = provider.houseNo;
    laneCtrl.text = provider.lane;
    localityCtrl.text = provider.locality;
    pinCodeCtrl.text = provider.pincode;
    telNoCtrl.text = provider.telNo;
    emailCtrl.text = provider.email;
    gstCtrl.text = provider.gstNo;
    panCtrl.text = provider.panNo;
    panHolderCtrl.text = provider.panHolder;
    panVerifiedCtrl.text = provider.panVerified;
    tanCtrl.text = provider.tanNo;
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
          "Branch Office Details",
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

            _label("Company Name"),
            _field(companyNameCtrl, "Enter company name"),

            _label("House Number"),
            _field(houseNumberCtrl, "Enter house number"),

            _label("Lane"),
            _field(laneCtrl, "Enter lane"),

            _label("Locality"),
            _field(localityCtrl, "Enter locality"),

            _label("Pin Code"),
            _field(pinCodeCtrl, "Enter pin code", TextInputType.number),

            _label("Tel No"),
            _field(telNoCtrl, "Enter telephone number", TextInputType.phone),

            _label("Email"),
            _field(emailCtrl, "Enter email", TextInputType.emailAddress),

            _label("GST Number"),
            _field(gstCtrl, "Enter GST number"),

            _label("PAN Number"),
            _field(panCtrl, "Enter PAN number"),

            _label("PAN Holder"),
            _field(panHolderCtrl, "Enter PAN holder name"),

            _label("PAN Verified"),
            _field(panVerifiedCtrl, "PAN verified"),

            _label("TAN Number"),
            _field(tanCtrl, "Enter TAN number"),

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
