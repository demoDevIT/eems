import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../utils/textfeild.dart';
import 'provider/register_form_provider.dart';

class RegisterFormScreen extends StatefulWidget {
  const RegisterFormScreen({super.key});

  @override
  State<RegisterFormScreen> createState() => _RegisterFormScreenState();
}

class _RegisterFormScreenState extends State<RegisterFormScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<RegisterFormProvider>(context, listen: false)
        .init("SSO123456"); // 🔴 dynamic later
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<RegisterFormProvider>(
      builder: (context, provider, _) {
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
              "Register Form",
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

                /// ===== DISTRICT =====
                _label("District *"),
                provider.isDistrictLoading
                    ? const Center(child: CircularProgressIndicator())
                    : buildDropdownWithBorderFieldOnlyThisPage<DistrictData>(
                  items: provider.districtList,
                  controller: provider.districtController,
                  idController: provider.districtIdController,
                  hintText: "--Select District--",
                  height: 50,
                  selectedValue: provider.selectedDistrict,
                  getLabel: (e) => e.name ?? "",
                  onChanged: (value) {
                    provider.selectedDistrict = value;
                    provider.districtController.text =
                        value?.name ?? "";
                    provider.districtIdController.text =
                        value?.iD.toString() ?? "";
                    provider.notifyListeners();
                  },
                ),

                /// ===== AREA =====
                _label("Area *"),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Rural',
                      groupValue: provider.areaType,
                      onChanged: provider.isAreaFromBRN
                          ? null
                          : provider.setArea,
                    ),
                    const Text("Rural"),
                    const SizedBox(width: 20),
                    Radio<String>(
                      value: 'Urban',
                      groupValue: provider.areaType,
                      onChanged: provider.isAreaFromBRN
                          ? null
                          : provider.setArea,
                    ),
                    const Text("Urban"),
                  ],
                ),

                /// ===== CITY / GRAM PANCHAYAT =====
                _label("City / Gram Panchayat"),
                _field(provider.cityGramController, "Enter city / gram panchayat"),

                /// ===== WARD / VILLAGE =====
                _label("Ward / Village"),
                _field(provider.wardVillageController, "Enter ward / village"),

                /// ===== DEPARTMENT NAME =====
                _label("Department Name"),
                _field(provider.departmentNameController, "Enter department name"),

                /// ===== OFFICE NAME =====
                _label("Office Name"),
                _field(provider.officeNameController, "Enter office name"),

                /// ===== SSO ID (DISABLED) =====
                _label("SSO ID"),
                _field(
                  provider.ssoIdController,
                  "SSO ID",
                  isEnabled: false,
                ),

                /// ===== MOBILE =====
                _label("Mobile No."),
                _field(
                  provider.mobileController,
                  "Enter mobile number",
                  keyboardType: TextInputType.phone,
                ),

                /// ===== DESIGNATION =====
                _label("Designation"),
                _field(
                  provider.designationController,
                  "Enter designation",
                ),

                const SizedBox(height: 30),

                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // //provider.submitEmpOTRForm(context);
                      // if (validateEmpOTRBasicAndOfficeDetails(
                      //     context, provider)) {
                      //   confirmAlertDialog(
                      //     context,
                      //     "Confirm Submission",
                      //     "Are you sure you want to submit the form ?",
                      //         (value) {
                      //       if (value.toString() == "success") {
                      //         provider.submitEmpOTRForm(context);
                      //       }
                      //     },
                      //   );
                      //   // NEXT STEP
                      // }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor, // nicer blue
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Save',
                        style:
                        TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  /// ===== LABEL =====
  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 6),
      child: Text(
        text,
        style: Styles.mediumTextStyle(size: 14, color: kBlackColor),
      ),
    );
  }

  /// ===== TEXT FIELD =====
  Widget _field(
      TextEditingController controller,
      String hint, {
        TextInputType keyboardType = TextInputType.text,
        bool isEnabled = true,
      }) {
    return buildTextWithBorderField(
      controller,
      hint,
      MediaQuery.of(context).size.width,
      50,
      keyboardType,
      isEnabled: isEnabled,
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