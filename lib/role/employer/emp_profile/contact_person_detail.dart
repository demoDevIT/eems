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
import 'provider/contact_person_detail_provider.dart';

class ContactPersonDetail extends StatefulWidget {
  const ContactPersonDetail({super.key});

  @override
  State<ContactPersonDetail> createState() =>
      _ContactPersonDetailState();
}

class _ContactPersonDetailState
    extends State<ContactPersonDetail> {

  // Text Controllers
  // final TextEditingController panCtrl = TextEditingController();
  // final TextEditingController fullNameCtrl = TextEditingController();
  // final TextEditingController mobileCtrl = TextEditingController();
  // final TextEditingController altMobileCtrl = TextEditingController();
  // final TextEditingController emailCtrl = TextEditingController();
  // final TextEditingController pincodeCtrl = TextEditingController();
  // final TextEditingController designationCtrl = TextEditingController();
  // final TextEditingController departmentCtrl = TextEditingController();
  // final TextEditingController addressCtrl = TextEditingController();

  // Dropdown values
  // String? selectedState;
  // String? selectedDistrict;
  // String? selectedCity;

  @override
  void initState() {
    super.initState();

    final provider =
    Provider.of<ContactPersonDetailProvider>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await provider.getStateApi();
      provider.setContactPersonData();

      final data = provider.userModel;
      debugPrint("userModel => $data");

      final stateId = _toInt(data?.contactState);
      final districtId = _toInt(data?.contactDistrict);
      final cityId = _toInt(data?.contactCity);

      debugPrint("stateId => $stateId");
      debugPrint("districtId => $districtId");
      debugPrint("cityId => $cityId");

      if (stateId != null && districtId != null && cityId != null) {
        await provider.setLocationFromIds(
          context: context,
          stateId: stateId,
          districtId: districtId,
          cityId: cityId,
        );
      }
    });

    // panCtrl.text = provider.panCtrl;
    // fullNameCtrl.text = provider.fullNameCtrl;
    // mobileCtrl.text = provider.mobileCtrl;
    // altMobileCtrl.text = provider.altMobileCtrl;
    // emailCtrl.text = provider.emailCtrl;
    // pincodeCtrl.text = provider.pincodeCtrl;
    // designationCtrl.text = provider.designationCtrl;
    // departmentCtrl.text = provider.departmentCtrl;
    // addressCtrl.text = provider.addressCtrl;

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
          AppLocalizations.of(context)!.contactPerDetail,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Consumer<ContactPersonDetailProvider>(
          builder: (context, provider, _) {
            return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _label(AppLocalizations.of(context)!.panNo),
            _field(provider.panCtrl, AppLocalizations.of(context)!.enterPANNo),

            _label(AppLocalizations.of(context)!.fullName),
            _field(provider.fullNameCtrl, AppLocalizations.of(context)!.enterFullName),

            _label(AppLocalizations.of(context)!.mobileNo),
            _field(provider.mobileCtrl, AppLocalizations.of(context)!.enterMobileNo, TextInputType.phone),

            _label(AppLocalizations.of(context)!.alterMobileNo),
            _field(provider.altMobileCtrl, AppLocalizations.of(context)!.enterAlterMobileNo,
                TextInputType.phone),

            _label(AppLocalizations.of(context)!.email),
            _field(provider.emailCtrl, AppLocalizations.of(context)!.enterEmail, TextInputType.emailAddress),

            /// ===== Dropdowns =====
            _label(AppLocalizations.of(context)!.state),
            buildDropdownWithBorderFieldOnlyThisPage<StateData>(
              items: provider.stateList,
              controller: provider.stateController,
              idController: provider.stateIdController,
              hintText: AppLocalizations.of(context)!.selectState,
              height: 50,
              selectedValue: provider.selectedState,
              getLabel: (e) => e.name ?? "",
              onChanged: null,
            ),


            _label(AppLocalizations.of(context)!.district),
            provider.isDistrictLoading
                ? const Center(child: CircularProgressIndicator())
                : buildDropdownWithBorderFieldOnlyThisPage<DistrictData>(
              items: provider.districtList,
              controller: provider.districtController,
              idController: provider.districtIdController,
              hintText: AppLocalizations.of(context)!.selectDistrict,
              height: 50,
              selectedValue: provider.selectedDistrict,
              getLabel: (e) => e.name ?? "",
              onChanged: null,
            ),


            _label(AppLocalizations.of(context)!.city),
            buildDropdownWithBorderFieldOnlyThisPage<CityData>(
              items: provider.cityList,
              controller: provider.cityController,
              idController: provider.cityIdController,
              hintText: AppLocalizations.of(context)!.selectCity,
              height: 50,
              selectedValue: provider.selectedCity,
              getLabel: (e) => e.nameEng ?? "",
              onChanged: null,

            ),

            _label(AppLocalizations.of(context)!.pincode),
            _field(provider.pincodeCtrl, AppLocalizations.of(context)!.enterPinCode, TextInputType.number),

            _label(AppLocalizations.of(context)!.designation),
            _field(provider.designationCtrl, AppLocalizations.of(context)!.enterDesignation),

            _label(AppLocalizations.of(context)!.department),
            _field(provider.departmentCtrl, AppLocalizations.of(context)!.enterDept),

            _label(AppLocalizations.of(context)!.address),
            _field(provider.addressCtrl, AppLocalizations.of(context)!.enterAddress),

            const SizedBox(height: 30),
          ],
        ),
            );

          },),
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

int? _toInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  return int.tryParse(value.toString());
}