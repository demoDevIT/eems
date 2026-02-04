import 'package:flutter/material.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/user_new.dart';
import '../modal/emp_info_modal.dart';


class HeadOfficeDetailProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  HeadOfficeDetailProvider({required this.commonRepo});

  final UserData _userData = UserData();
  get userModel => _userData.model.value;

  void printUserData() {
    final data = userModel;

    if (data == null) {
      debugPrint("❌ Branch Office UserData is NULL");
      return;
    }

    //debugPrint("Company Name : ${data.branchName}");

  }

  /// ============================
  /// GETTERS FOR UI
  /// ============================
  String get companyName => userModel?.headName ?? "";
  String get telNo => userModel?.hoTelno ?? "";
  String get email => userModel?.hoCompanyEmail ?? "";
  String get panNo => userModel?.hoPanNumber ?? "";
  String get houseNo => userModel?.headHouseNumber ?? "";
  String get lane => userModel?.headLane ?? "";
  String get locality => userModel?.headLocality ?? "";
  String get pincode => userModel?.hoPinCode ?? "";

}