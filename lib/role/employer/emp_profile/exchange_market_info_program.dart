import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/employer/emp_profile/provider/exchange_market_info_provider.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../l10n/app_localizations.dart';
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
        title: Text(
          AppLocalizations.of(context)!.exchangeMarInfoProg,
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
                _label(AppLocalizations.of(context)!.typeOfOrg),
                buildDropdownFieldStaticValue(
                  AppLocalizations.of(context)!.typeOfOrg,
                  AppLocalizations.of(context)!.selType,
                  value: orgType,
                  items: provider.organizationTypes,
                  onChanged: null, // disabled
                ),

                if (orgType != null && orgType != "Private") ...[
                  _label(AppLocalizations.of(context)!.govtBody),
                  buildDropdownFieldStaticValue(
                    AppLocalizations.of(context)!.govtBody,
                    AppLocalizations.of(context)!.selectGovtBody,
                    value: govtBody,
                    items: provider.governmentBodies,
                    onChanged: null, // 👈 disabled
                  ),
                ],

                /// ===== Employee Count =====
                _label(AppLocalizations.of(context)!.noOfMaleEmp),
                _field(provider.maleEmpCtrl, AppLocalizations.of(context)!.enterMaleEmp,
                    TextInputType.number),

                _label(AppLocalizations.of(context)!.noOfFemaleEmp),
                _field(provider.femaleEmpCtrl, AppLocalizations.of(context)!.enterFemaleEmp,
                    TextInputType.number),

                _label(AppLocalizations.of(context)!.noOfTransEmp),
                _field(provider.transgenderEmpCtrl,
                    AppLocalizations.of(context)!.enterTransEmp, TextInputType.number),

                _label(AppLocalizations.of(context)!.totalNoEmp),
                _field(provider.totalEmpCtrl, AppLocalizations.of(context)!.enterTotalEmp,
                    TextInputType.number),

                /// ===== More Dropdowns =====
                if (orgType != "Government") ...[
                  _label(AppLocalizations.of(context)!.actEst),
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
                    hint: Text(AppLocalizations.of(context)!.selOption),
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

                _label(AppLocalizations.of(context)!.indusType),
                buildDropdownFieldStaticValue(
                  AppLocalizations.of(context)!.indusType,
                  AppLocalizations.of(context)!.selectIndusType,
                  value: industryType,
                  items: provider.industryTypes,
                  onChanged: null, // ✅ disabled like previous dropdowns
                ),

                _label(AppLocalizations.of(context)!.sector),
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
                  hint: Text(AppLocalizations.of(context)!.selOption),
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
