import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/employer/emp_profile/provider/exchange_market_info_provider.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/dropdown.dart';
import '../empotr_form/modal/actEstablishment_modal.dart';
import '../empotr_form/modal/sector_modal.dart';

class ExchangeMarketInformationProgram extends StatefulWidget {
  const ExchangeMarketInformationProgram({super.key});

  @override
  State<ExchangeMarketInformationProgram> createState() =>
      _ExchangeMarketInformationProgramState();
}

class _ExchangeMarketInformationProgramState
    extends State<ExchangeMarketInformationProgram> {
  @override
  void initState() {
    super.initState();
    final provider =
        Provider.of<ExchangeMarketInfoProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      provider.setExchangeMarketData();
      await provider.loadAndBindActEstablishment(context);

      final data = provider.userModel;

      // 🔹 Type of Organization
      if (data != null &&
          provider.organizationTypes.contains(data.organizationType)) {
        setState(() {
          orgType = data.organizationType;
        });
      }

      // 🔹 Government Body
      if (data != null &&
          provider.governmentBodies.contains(data.governmentBody)) {
        setState(() {
          govtBody = data.governmentBody;
        });
      }

      // Industry Type
      if (data != null && provider.industryTypes.contains(data.industryType)) {
        setState(() {
          industryType = data.industryType;
        });
      }

      await provider.sectorApi(context);

      final sectorID = data?.emipSector;
      print("sectorID ====> $sectorID");

      // provider.setSectorFromId(sectorID);
    });
  }

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
      body: Consumer<ExchangeMarketInfoProvider>(
        builder: (context, provider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ===== Dropdowns =====
                _label("Type of Organization"),
                buildDropdownFieldStaticValue(
                  "Type of Organization",
                  "Select type",
                  value: orgType,
                  items: provider.organizationTypes,
                  onChanged: null, // disabled
                ),

                if (orgType != null && orgType != "Private") ...[
                  _label("Government Body"),
                  buildDropdownFieldStaticValue(
                    "Government Body",
                    "Select government body",
                    value: govtBody,
                    items: provider.governmentBodies,
                    onChanged: null, // 👈 disabled
                  ),
                ],

                /// ===== Employee Count =====
                _label("No of Male Employees"),
                _field(provider.maleEmpCtrl, "Enter male employees",
                    TextInputType.number),

                _label("No of Female Employees"),
                _field(provider.femaleEmpCtrl, "Enter female employees",
                    TextInputType.number),

                _label("No of Transgender Employees"),
                _field(provider.transgenderEmpCtrl,
                    "Enter transgender employees", TextInputType.number),

                _label("Total Number of Employees"),
                _field(provider.totalEmpCtrl, "Enter total employees",
                    TextInputType.number),

                /// ===== More Dropdowns =====
                if (orgType != "Government") ...[
                  _label("Act Establishment"),
                  DropdownButtonFormField<ActEstablishmentData>(
                    value: provider.selectedActEst,
                    isExpanded: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 14),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: borderColor,
                          width: 0.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: borderColor,
                          width: 0.5,
                        ),
                      ),
                    ),
                    hint: const Text("--Select Option--"),
                    items: provider.actEstList
                        .map(
                          (e) => DropdownMenuItem<ActEstablishmentData>(
                            value: e,
                            child: Text(e.actEstablishment ?? ""),
                          ),
                        )
                        .toList(),

                    // 🔒 ALWAYS DISABLED
                    onChanged: null,
                  ),
                ],

                _label("Industry Type"),
                buildDropdownFieldStaticValue(
                  "Industry Type",
                  "Select industry type",
                  value: industryType,
                  items: provider.industryTypes,
                  onChanged: null, // ✅ disabled like previous dropdowns
                ),

                _label("Sector"),
                DropdownButtonFormField<int>(
                  value: provider.selectedSectorId,
                  isExpanded: true,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 14),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: borderColor, width: 0.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide:
                          const BorderSide(color: borderColor, width: 0.5),
                    ),
                  ),
                  hint: const Text("--Select Option--"),
                  items: provider.sectorList
                      .map(
                        (e) => DropdownMenuItem<int>(
                          value: e.iD,
                          child: Text(e.name ?? ""),
                        ),
                      )
                      .toList(),
                  onChanged: null, // 🔒 disabled
                ),

                const SizedBox(height: 30),
              ],
            ),
          );
        },
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

Widget buildDropdownFieldStaticValue(
  String label,
  String hint, {
  required String? value,
  required List<String> items,
  ValueChanged<String?>? onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        //Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: value,
          decoration: InputDecoration(
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: borderColor, // 👉 Default border color
                width: 0.5, // 👉 Default border width
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: borderColor, // 👉 Default border color
                width: 0.5, // 👉 Default border width
              ),
            ),
          ),
          hint: Text(hint),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    ),
  );
}
