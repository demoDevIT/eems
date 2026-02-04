import 'package:flutter/material.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/user_new.dart';
import '../modal/emp_info_modal.dart';


class BranchOfficeDetailProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  BranchOfficeDetailProvider({required this.commonRepo});

  final UserData _userData = UserData();
  get userModel => _userData.model.value;

  void printUserData() {
    final data = userModel;

    if (data == null) {
      debugPrint("❌ Branch Office UserData is NULL");
      return;
    }

    debugPrint("Company Name : ${data.branchName}");

  }

  /// ============================
  /// GETTERS FOR UI
  /// ============================
  String get companyName => userModel?.branchName ?? "";
  String get houseNo => userModel?.branchHouseNumber ?? "";
  String get lane => userModel?.branchLane ?? "";
  String get locality => userModel?.branchLocality ?? "";
  String get pincode => userModel?.branchPincode ?? "";
  String get telNo => userModel?.boTelNo ?? "";
  String get email => userModel?.branchEmail ?? "";
  String get gstNo => userModel?.docGSTNumber ?? "";
  String get panNo => userModel?.branchPANVerified ?? "";
  String get panHolder => userModel?.branchPANHolder ?? "";
  String get panVerified => userModel?.branchPANVerified ?? "";
  String get tanNo => userModel?.branchTANNumber ?? "";
}