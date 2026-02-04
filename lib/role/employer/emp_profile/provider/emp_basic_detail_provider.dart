import 'package:flutter/material.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/user_new.dart';
import '../modal/emp_info_modal.dart';


class EmpBasicDetailProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  EmpBasicDetailProvider({required this.commonRepo});

  final UserData _userData = UserData();

  /// ============================
  /// GET FULL USERDATA MODEL
  /// ============================
  get userModel => _userData.model.value;

  /// ============================
  /// PRINT COMPLETE USERDATA
  /// ============================
  void printUserData() {
    final data = _userData.model.value;

    if (data == null) {
      debugPrint("❌ UserData model is NULL");
      return;
    }

    debugPrint("========= USER DATA =========");
    debugPrint("UserID     : ${data.userId}");
    debugPrint("RoleID     : ${data.roleId}");

    debugPrint("BRN        : ${data.brn}");
    debugPrint("District   : ${data.district}");
    debugPrint("Tehsil     : ${data.tehsil}");
    debugPrint("LocalBody  : ${data.localBody}");
    debugPrint("Area       : ${data.area}");

    debugPrint("================================");
  }

  /// ============================
  /// HELPERS FOR UI
  /// ============================
  String get brn => userModel?.brn?.toString() ?? "";
  String get district => userModel?.district ?? "";
  String get tehsil => userModel?.tehsil ?? "";
  String get localBody => userModel?.localBody ?? "";
  String get area => userModel?.area ?? "Rural";
}
