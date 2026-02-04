import 'package:flutter/material.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/user_new.dart';
import '../modal/emp_info_modal.dart';


class HeadOfficeApplicantDetailProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  HeadOfficeApplicantDetailProvider({required this.commonRepo});

  final UserData _userData = UserData();
  get userModel => _userData.model.value;

  void printUserData() {
    final data = userModel;

    if (data == null) {
      debugPrint("❌ Branch Office UserData is NULL");
      return;
    }

    debugPrint("NIC CODE : ${data.nicCode}");

  }

  /// ============================
  /// GETTERS FOR UI
  /// ============================
  String get applicantNameCtrl => userModel?.applicantName ?? "";
  String get applicantMobileCtrl => userModel?.applicantNo ?? "";
  String get applicantEmailCtrl => userModel?.applicantEmail ?? "";
  String get yearCtrl => userModel?.year ?? "";
  String get ownershipCtrl => userModel?.ownership ?? "";
  //String get totalPersonCtrl => userModel?.totalPerson ?? "0";
  String get actAuthorityRegCtrl => userModel?.actRegNo ?? "";
  String get tanCtrl => userModel?.hoTanNo ?? "";
  String get emailCtrl => userModel?.hoApplicationEmail ?? "";
  String get websiteCtrl => userModel?.webSite ?? "";
  String get applicantAddressCtrl => userModel?.applicantAddress ?? "";
  String get nicCodeCtrl => userModel?.nicCode ?? "";

}