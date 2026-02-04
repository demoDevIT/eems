import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../utils/textfeild.dart';
import 'provider/emp_basic_detail_provider.dart';

class EmpBasicDetailScreen extends StatefulWidget {
  const EmpBasicDetailScreen({super.key});

  @override
  State<EmpBasicDetailScreen> createState() => _EmpBasicDetailScreenState();
}

class _EmpBasicDetailScreenState extends State<EmpBasicDetailScreen> {
  final TextEditingController brnController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController tehsilController = TextEditingController();
  final TextEditingController localBodyController = TextEditingController();

  String areaType = "Rural";

  @override
  void initState() {
    super.initState();

    final provider =
    Provider.of<EmpBasicDetailProvider>(context, listen: false);

    provider.printUserData(); // 🔥 PRINT FULL USERDATA

    brnController.text = provider.brn;
    districtController.text = provider.district;
    tehsilController.text = provider.tehsil;
    localBodyController.text = provider.localBody;

    areaType = provider.area;
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
          "Basic Details",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// BRN
            _label("BRN"),
            buildTextWithBorderField(
              brnController,
              "Enter BRN",
              MediaQuery.of(context).size.width,
              50,
              TextInputType.text,
              isEnabled: false,
            ),

            /// District
            _label("District"),
            buildTextWithBorderField(
              districtController,
              "Enter District",
              MediaQuery.of(context).size.width,
              50,
              TextInputType.text,
              isEnabled: false,
            ),

            /// Area (Radio)
            _label("Area"),
            Row(
              children: [
                Radio<String>(
                  value: "Rural",
                  groupValue: areaType,
                  onChanged: null, // disabled
                ),
                const Text("Rural"),
                const SizedBox(width: 12),
                Radio<String>(
                  value: "Urban",
                  groupValue: areaType,
                  onChanged: null, // disabled
                ),
                const Text("Urban"),
              ],
            ),

            /// Tehsil
            _label("Tehsil"),
            buildTextWithBorderField(
              tehsilController,
              "Enter Tehsil",
              MediaQuery.of(context).size.width,
              50,
              TextInputType.text,
              isEnabled: false,
            ),

            /// Local Body
            _label("Local Body"),
            buildTextWithBorderField(
              localBodyController,
              "Enter Local Body",
              MediaQuery.of(context).size.width,
              50,
              TextInputType.text,
              isEnabled: false,
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Text(
        text,
        style: Styles.mediumTextStyle(size: 14, color: kBlackColor),
      ),
    );
  }
}
