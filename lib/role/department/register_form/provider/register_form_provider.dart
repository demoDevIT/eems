import 'package:flutter/material.dart';

import '../../../../repo/common_repo.dart';

class RegisterFormProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  RegisterFormProvider({required this.commonRepo});

  /// ======================
  /// DISTRICT DROPDOWN
  /// ======================
  bool isDistrictLoading = false;

  List<DistrictData> districtList = [];
  DistrictData? selectedDistrict;

  final TextEditingController districtController = TextEditingController();
  final TextEditingController districtIdController = TextEditingController();

  /// ======================
  /// AREA (URBAN / RURAL)
  /// ======================
  String areaType = "Rural";
  bool isAreaFromBRN = false;

  void setArea(String? value) {
    if (value == null) return;
    areaType = value;
    notifyListeners();
  }

  /// ======================
  /// FORM CONTROLLERS
  /// ======================
  final TextEditingController cityGramController = TextEditingController();
  final TextEditingController wardVillageController = TextEditingController();
  final TextEditingController departmentNameController = TextEditingController();
  final TextEditingController officeNameController = TextEditingController();
  final TextEditingController ssoIdController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController designationController = TextEditingController();

  /// ======================
  /// INIT DATA
  /// ======================
  void init(String ssoId) {
    ssoIdController.text = ssoId; // disabled field
  }
}

/// ======================
/// DUMMY MODEL (already exists in your project)
/// ======================
class DistrictData {
  final int? iD;
  final String? name;

  DistrictData({this.iD, this.name});
}
