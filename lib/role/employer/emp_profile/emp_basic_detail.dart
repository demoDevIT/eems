import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../l10n/app_localizations.dart';
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
        title: Text(
          AppLocalizations.of(context)!.basicDetails,
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
            _label(AppLocalizations.of(context)!.brn),
            buildTextWithBorderField(
              brnController,
              AppLocalizations.of(context)!.enterBRN,
              MediaQuery.of(context).size.width,
              50,
              TextInputType.text,
              isEnabled: false,
            ),

            /// District
            _label(AppLocalizations.of(context)!.district),
            buildTextWithBorderField(
              districtController,
              AppLocalizations.of(context)!.enterDistrict,
              MediaQuery.of(context).size.width,
              50,
              TextInputType.text,
              isEnabled: false,
            ),

            /// Area (Radio)
            _label(AppLocalizations.of(context)!.area),
            Row(
              children: [
                Radio<String>(
                  value: "Rural",
                  groupValue: areaType,
                  onChanged: null, // disabled
                ),
                Text(AppLocalizations.of(context)!.rural),
                const SizedBox(width: 12),
                Radio<String>(
                  value: "Urban",
                  groupValue: areaType,
                  onChanged: null, // disabled
                ),
                Text(AppLocalizations.of(context)!.urban),
              ],
            ),

            /// Tehsil
            _label(AppLocalizations.of(context)!.tehsil),
            buildTextWithBorderField(
              tehsilController,
              AppLocalizations.of(context)!.enterTehsil,
              MediaQuery.of(context).size.width,
              50,
              TextInputType.text,
              isEnabled: false,
            ),

            /// Local Body
            _label(AppLocalizations.of(context)!.localBody),
            buildTextWithBorderField(
              localBodyController,
              AppLocalizations.of(context)!.enterLocalBody,
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
