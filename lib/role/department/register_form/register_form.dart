import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../utils/global.dart';
import '../../../utils/textfeild.dart';
import 'modal/block_modal.dart';
import 'modal/department_modal.dart';
import 'modal/gp_modal.dart';
import 'modal/village_modal.dart';
import 'modal/ward_modal.dart';
import 'provider/register_form_provider.dart';
import 'package:flutter/scheduler.dart';
import 'modal/district_modal.dart';
import 'modal/city_modal.dart';

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

    SchedulerBinding.instance.addPostFrameCallback((_) {
      final provider =
          Provider.of<RegisterFormProvider>(context, listen: false);
      //provider.clearData();
      provider.getDistrictApi(context, 6);
      provider.getDepartmentApi(context);
    });
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
                          provider.districtController.text = value?.name ?? "";
                          provider.districtIdController.text =
                              value?.iD.toString() ?? "";

                          // clear selections
                          provider.selectedCity = null;
                          provider.selectedBlock = null;
                          // provider.cityNameController.clear();
                          // provider.cityIdController.clear();
                         // provider.cityList.clear();

                          // clear lists (district dependency)
                          provider.cityList.clear();
                          provider.blockList.clear();
                          provider.wardList.clear();
                          provider.gpList.clear();
                          provider.villageList.clear();

                          /// 🔵 LOAD CITY
                          if (value?.iD != null) {
                            provider.getCityApi(context, value!.iD.toString());
                            provider.getBlockApi(context, value!.code!);

                          }

                          provider.notifyListeners();
                        },
                      ),

                /// ===== AREA =====
                _label("Area *"),
                Row(
                  children: [
                    Radio<String>(
                      value: 'Urban',
                      groupValue: provider.areaType,
                      onChanged: provider.setArea,
                    ),
                    const Text("Urban"),
                    const SizedBox(width: 20),
                    Radio<String>(
                      value: 'Rural',
                      groupValue: provider.areaType,
                      onChanged: provider.setArea,
                    ),
                    const Text("Rural"),
                  ],
                ),

                if (provider.areaType == "Urban") ...[
                  /// ===== CITY =====
                  _label("City *"),
                  provider.isCityLoading
                      ? const Center(child: CircularProgressIndicator())
                      : buildDropdownWithBorderFieldOnlyThisPage<CityData>(
                          items: provider.cityList,
                          controller: provider.cityNameController,
                          idController: provider.cityIdController,
                          hintText: "--Select City--",
                          height: 50,
                          selectedValue: provider.selectedCity,
                          getLabel: (e) => e.nameEng ?? "",
                          onChanged: (value) {
                            provider.selectedCity = value;
                            provider.cityNameController.text =
                                value?.nameEng ?? "";
                            provider.cityIdController.text =
                                value?.iD?.toString() ?? "";

                            /// 🔴 CLEAR WARD
                            provider.selectedWard = null;
                            provider.wardNameController.clear();
                            provider.wardIdController.clear();
                            provider.wardList.clear();

                            /// 🔵 LOAD WARD USING CITY CODE
                            if (value?.code != null) {
                              provider.getWardApi(context, value!.code!);
                            }

                            provider.notifyListeners();
                          },
                        ),

                  /// ===== WARD =====
                  _label("Ward"),

                  provider.isWardLoading
                      ? const Center(child: CircularProgressIndicator())
                      : buildDropdownWithBorderFieldOnlyThisPage<WardData>(
                          items: provider.wardList,
                          controller: provider.wardNameController,
                          idController: provider.wardIdController,
                          hintText: "--Select Ward--",
                          height: 50,
                          selectedValue: provider.selectedWard,
                          getLabel: (e) => e.nameEng ?? "",
                          onChanged: (value) {
                            provider.selectedWard = value;
                            provider.wardNameController.text =
                                value?.nameEng ?? "";
                            provider.wardIdController.text =
                                value?.iD?.toString() ?? "";
                            provider.notifyListeners();
                          },
                        ),
                ],

                if (provider.areaType == "Rural") ...[

                  /// ===== BLOCK =====
                  _label("Block *"),
                  provider.isBlockLoading
                      ? const Center(child: CircularProgressIndicator())
                      : buildDropdownWithBorderFieldOnlyThisPage<BlockData>(
                    items: provider.blockList,
                    controller: provider.blockNameController,
                    idController: provider.blockIdController,
                    hintText: "--Select Block--",
                    height: 50,
                    selectedValue: provider.selectedBlock,
                    getLabel: (e) => e.nameEng ?? "",
                    onChanged: (value) {
                      provider.selectedBlock = value;
                      provider.blockNameController.text = value?.nameEng ?? "";
                      provider.blockIdController.text = value?.iD.toString() ?? "";

                      provider.getGpApi(context, value!.code!);
                      provider.notifyListeners();
                    },
                  ),

                  /// ===== GRAM PANCHAYAT =====
                  _label("Gram Panchayat *"),
                  provider.isGpLoading
                      ? const Center(child: CircularProgressIndicator())
                      : buildDropdownWithBorderFieldOnlyThisPage<GramPanchayatData>(
                    items: provider.gpList,
                    controller: provider.gpNameController,
                    idController: provider.gpIdController,
                    hintText: "--Select Gram Panchayat--",
                    height: 50,
                    selectedValue: provider.selectedGp,
                    getLabel: (e) => e.nameEng ?? "",
                    onChanged: (value) {
                      provider.selectedGp = value;
                      provider.gpNameController.text = value?.nameEng ?? "";
                      provider.gpIdController.text = value?.iD.toString() ?? "";

                      provider.getVillageApi(context, value!.code!);
                      provider.notifyListeners();
                    },
                  ),

                  /// ===== VILLAGE =====
                  _label("Village *"),
                  provider.isVillageLoading
                      ? const Center(child: CircularProgressIndicator())
                      : buildDropdownWithBorderFieldOnlyThisPage<VillageData>(
                    items: provider.villageList,
                    controller: provider.villageNameController,
                    idController: provider.villageIdController,
                    hintText: "--Select Village--",
                    height: 50,
                    selectedValue: provider.selectedVillage,
                    getLabel: (e) => e.nameEng ?? "",
                    onChanged: (value) {
                      provider.selectedVillage = value;
                      provider.villageNameController.text =
                          value?.nameEng ?? "";
                      provider.villageIdController.text =
                          value?.iD.toString() ?? "";
                      provider.notifyListeners();
                    },
                  ),
                ],

                /// ===== DEPARTMENT NAME =====
                _label("Department Name"),
                provider.isDepartmentLoading
                    ? const Center(child: CircularProgressIndicator())
                    : buildDropdownWithBorderFieldOnlyThisPage<DepartmentData>(
                        items: provider.departmentList,
                        controller: provider.departmentNameController,
                        idController: provider.departmentIdController,
                        hintText: "--Select Department--",
                        height: 50,
                        selectedValue: provider.selectedDepartment,
                        getLabel: (e) => e.nameEng ?? "",
                        onChanged: (value) {
                          provider.selectedDepartment = value;
                          provider.departmentNameController.text =
                              value?.nameEng ?? "";
                          provider.departmentIdController.text =
                              value?.iD?.toString() ?? "";
                          provider.notifyListeners();
                        },
                      ),

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
                      //provider.submitEmpOTRForm(context);
                      if (validateBasicDetails(context, provider)) {
                        confirmAlertDialog(
                          context,
                          "Confirm Submission",
                          "Are you sure you want to submit the form ?",
                          (value) {
                            if (value.toString() == "success") {
                              provider.submitForm(context);
                            }
                          },
                        );
                        // NEXT STEP
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor, // nicer blue
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                      elevation: 0,
                    ),
                    child: const Text('Save',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
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

bool validateBasicDetails(
  BuildContext context,
  RegisterFormProvider provider,
) {
  if (provider.selectedDistrict == null ||
      provider.districtController.text.trim().isEmpty) {
    showAlertError("Please select District", context);
    return false;
  }

  if (provider.areaType == null || provider.areaType!.isEmpty) {
    showAlertError("Please select Area (Rural / Urban)", context);
    return false;
  }
  if (provider.areaType == "Urban") {
    if (provider.selectedCity == null ||
        provider.cityNameController.text
            .trim()
            .isEmpty) {
      showAlertError("Please select City", context);
      return false;
    }

    if (provider.selectedWard == null ||
        provider.wardNameController.text
            .trim()
            .isEmpty) {
      showAlertError("Please select Ward", context);
      return false;
    }
  }
  if (provider.areaType == "Rural") {
    if (provider.selectedBlock == null ||
        provider.selectedGp == null ||
        provider.selectedVillage == null) {
      showAlertError("Please complete location details", context);
      return false;
    }
  }

  if (provider.departmentNameController.text.trim().isEmpty) {
    showAlertError("Please enter Department Name", context);
    return false;
  }

  if (provider.officeNameController.text.trim().isEmpty) {
    showAlertError("Please enter office name", context);
    return false;
  }

  if (provider.mobileController.text.trim().isEmpty) {
    showAlertError("Please enter Mobile Number", context);
    return false;
  }

  if (provider.designationController.text.trim().isEmpty) {
    showAlertError("Please enter Designation", context);
    return false;
  }

  return true;
}
