import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../utils/textfeild.dart';
import 'provider/head_office_detail_provider.dart';

class HeadOfficeDetailScreen extends StatefulWidget {
  const HeadOfficeDetailScreen({super.key});

  @override
  State<HeadOfficeDetailScreen> createState() =>
      _HeadOfficeDetailScreenState();
}

class _HeadOfficeDetailScreenState
    extends State<HeadOfficeDetailScreen> {

  final TextEditingController companyNameCtrl = TextEditingController();
  final TextEditingController telNoCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController panCtrl = TextEditingController();
  final TextEditingController houseNoCtrl = TextEditingController();
  final TextEditingController laneCtrl = TextEditingController();
  final TextEditingController localityCtrl = TextEditingController();
  final TextEditingController pincodeCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    final provider =
    Provider.of<HeadOfficeDetailProvider>(context, listen: false);

    provider.printUserData();

    companyNameCtrl.text = provider.companyName;
    telNoCtrl.text = provider.telNo;
    emailCtrl.text = provider.email;
    panCtrl.text = provider.panNo;
    houseNoCtrl.text = provider.houseNo;
    laneCtrl.text = provider.lane;
    localityCtrl.text = provider.locality;
    pincodeCtrl.text = provider.pincode;
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
          "Head Office Details",
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

            _label("Tel No"),
            _field(telNoCtrl, "Enter telephone number", TextInputType.phone),

            _label("Email"),
            _field(emailCtrl, "Enter email", TextInputType.emailAddress),

            _label("PAN No"),
            _field(panCtrl, "Enter PAN number"),

            _label("House Number"),
            _field(houseNoCtrl, "Enter house number"),

            _label("Lane"),
            _field(laneCtrl, "Enter lane"),

            _label("Locality"),
            _field(localityCtrl, "Enter locality"),

            _label("Pincode"),
            _field(pincodeCtrl, "Enter pincode", TextInputType.number),

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

  /// ===== Disabled Field =====
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
