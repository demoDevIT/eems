import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/dropdown.dart';
import '../empotr_form/modal/city_modal.dart';
import '../empotr_form/modal/district_modal.dart';
import '../empotr_form/modal/state_modal.dart';
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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await provider.getHoStateApi(context);

      provider.printUserData();

      final data = provider.userModel;
      if (data != null &&
          data.hoStateId != null &&
          data.hoDistrictId != null &&
          data.hoCityId != null) {
        await provider.setHoLocationFromIds(
          context: context,
          stateId: data.hoStateId!,
          districtId: data.hoDistrictId!,
          cityId: data.hoCityId!,
        );
      }
    });

    // provider.getHoStateApi(context);
    // provider.printUserData();

    applicantNameCtrl.text = provider.applicantNameCtrl;
    applicantMobileCtrl.text = provider.applicantMobileCtrl;
    applicantEmailCtrl.text = provider.applicantEmailCtrl;
    yearCtrl.text = provider.yearCtrl;
    ownershipCtrl.text = provider.ownershipCtrl;
    totalPersonCtrl.text = provider.totalPersonCtrl;
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
        title: Text(
          AppLocalizations.of(context)!.headOffAppDetail,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<HeadOfficeApplicantDetailProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  _label(AppLocalizations.of(context)!.applicantName),
                  _field(applicantNameCtrl, AppLocalizations.of(context)!.enterApplicantName),

                  _label(AppLocalizations.of(context)!.applicantMobNo),
                  _field(applicantMobileCtrl, AppLocalizations.of(context)!.enterMobNo,
                      TextInputType.phone),

                  _label(AppLocalizations.of(context)!.applicantEmail),
                  _field(applicantEmailCtrl, AppLocalizations.of(context)!.enterEmail,
                      TextInputType.emailAddress),

                  _label(AppLocalizations.of(context)!.year),
                  _field(yearCtrl, AppLocalizations.of(context)!.enterYear, TextInputType.number),

                  _label(AppLocalizations.of(context)!.ownership),
                  _field(ownershipCtrl, AppLocalizations.of(context)!.enterOwnership),

                  _label(AppLocalizations.of(context)!.totalPer),
                  _field(totalPersonCtrl, AppLocalizations.of(context)!.enterTotalPer,
                      TextInputType.number),

                  _label(AppLocalizations.of(context)!.actAuthRegNo),
                  _field(actAuthorityRegCtrl, AppLocalizations.of(context)!.enterActAuthRegNo),

                  _label(AppLocalizations.of(context)!.tanNo),
                  _field(tanCtrl, AppLocalizations.of(context)!.enterTANNo),

                  _label(AppLocalizations.of(context)!.email),
                  _field(emailCtrl, AppLocalizations.of(context)!.enterEmail, TextInputType.emailAddress),

                  /// ===== Dropdowns =====
                  _label(AppLocalizations.of(context)!.state),
                  buildDropdownWithBorderFieldOnlyThisPage<StateData>(
                    items: provider.hoStateList,
                    controller: provider.hoStateController,
                    idController: provider.hoStateIdController,
                    hintText: AppLocalizations.of(context)!.selectState,
                    height: 50,
                    selectedValue: provider.hoSelectedState,
                    getLabel: (e) => e.name ?? "",
                    onChanged: null,
                    // onChanged: (value) {
                    //   provider.hoSelectedState = value;
                    //
                    //   provider.hoStateController.text = value?.name ?? "";
                    //   provider.hoStateIdController.text =
                    //       value?.iD.toString() ?? "";
                    //
                    //   // clear lower levels
                    //   provider.hoSelectedDistrict = null;
                    //   provider.hoDistrictController.clear();
                    //   provider.hoDistrictList.clear();
                    //
                    //   provider.hoSelectedCity = null;
                    //   provider.hoCityController.clear();
                    //   provider.hoCityList.clear();
                    //
                    //   provider.getHoDistrictApi(context, value!.iD!);
                    // },
                  ),


                  _label(AppLocalizations.of(context)!.district),
                  provider.isHoDistrictLoading
                      ? const Center(child: CircularProgressIndicator())
                      : buildDropdownWithBorderFieldOnlyThisPage<DistrictData>(
                    items: provider.hoDistrictList,
                    controller: provider.hoDistrictController,
                    idController: provider.hoDistrictIdController,
                    hintText: AppLocalizations.of(context)!.selectDistrict,
                    height: 50,
                    selectedValue: provider.hoSelectedDistrict,
                    getLabel: (e) => e.name ?? "",
                    onChanged: null,
                    // onChanged: (value) {
                    //   provider.hoSelectedDistrict = value;
                    //
                    //   provider.hoDistrictController.text = value?.name ?? "";
                    //   provider.hoDistrictIdController.text =
                    //       value?.iD.toString() ?? "";
                    //
                    //   // clear city
                    //   provider.hoSelectedCity = null;
                    //   provider.hoCityController.clear();
                    //   provider.hoCityList.clear();
                    //
                    //   provider.getHoCityApi(context, value!.iD.toString());
                    // },
                  ),


                  _label(AppLocalizations.of(context)!.city),
                  buildDropdownWithBorderFieldOnlyThisPage<CityData>(
                    items: provider.hoCityList,
                    controller: provider.hoCityController,
                    idController: provider.hoCityIdController,
                    hintText: AppLocalizations.of(context)!.selectCity,
                    height: 50,
                    selectedValue: provider.hoSelectedCity,
                    getLabel: (e) => e.nameEng ?? "",
                    onChanged: null,
                    // onChanged: (value) {
                    //   provider.hoSelectedCity = value;
                    //
                    //   provider.hoCityController.text = value?.nameEng ?? "";
                    //   provider.hoCityIdController.text =
                    //       value?.iD.toString() ?? "";
                    // },
                  ),


                  _label(AppLocalizations.of(context)!.website),
                  _field(websiteCtrl, AppLocalizations.of(context)!.enterWebsite),

                  _label(AppLocalizations.of(context)!.applicantAddress),
                  _field(applicantAddressCtrl, AppLocalizations.of(context)!.enterApplicantAddress),

                  _label(AppLocalizations.of(context)!.nicCode),
                  _field(nicCodeCtrl, AppLocalizations.of(context)!.enterNICCode),

                  const SizedBox(height: 30),
                ],
              ),
            );

          },),
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

Widget buildDropdownWithBorderFieldOnlyThisPage<T>({
  required List<T> items,
  required TextEditingController controller,
  required TextEditingController idController,
  required String hintText,
  required double height,
  required T? selectedValue,
  required ValueChanged<T?>? onChanged, // 👈 nullable
  String Function(T)? getLabel,
}) {
  return SizedBox(
    height: height,
    child: InputDecorator(
      decoration: InputDecoration(
        filled: true,
        fillColor: fafafaColor,
        // SAME as text field
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.grey.shade400),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: kPrimaryColor, width: 1.5),
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          value: selectedValue,
          hint: Text(
            hintText,
            style: TextStyle(color: Colors.grey.shade600),
          ),
          icon: const Icon(Icons.keyboard_arrow_down),
          items: items.map((item) {
            return DropdownMenuItem<T>(
              value: item,
              child: Text(
                getLabel != null ? getLabel(item) : item.toString(),
                overflow: TextOverflow.ellipsis,
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    ),
  );
}