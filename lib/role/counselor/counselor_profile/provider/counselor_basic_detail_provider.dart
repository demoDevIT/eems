import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../repo/common_repo.dart';
import '../modal/counselor_info_modal.dart';

class CounselorBasicDetailsProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  CounselorBasicDetailsProvider({required this.commonRepo});

  // Controllers for text fields
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController genderController = TextEditingController();
  final TextEditingController dobController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController prefLangController = TextEditingController();
  final TextEditingController specExpertiseLangController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController districtController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  String gender = "Male";

  @override
  void dispose() {
    super.dispose();
  }

  void setCounselorData(CounselorInfoData data) {
    fullNameController.text = data.firstName ?? "";
    gender = data.gender ?? "Male";
    dobController.text = data.dob ?? "";
    mobileController.text = data.mobileNo ?? "";
    emailController.text = data.email ?? "";
    //prefLangController.text = data.pref ?? "";
    specExpertiseLangController.text = data.specExpertID ?? "";
    // stateController.text = data.sta ?? "";
    // districtController.text = data.district ?? "";
    // cityController.text = data.city ?? "";
    notifyListeners();
  }

  // String maskUid(String uid) {
  //   if (uid.isEmpty) return '';
  //
  //   if (uid.length <= 4) {
  //     return uid; // nothing to mask
  //   }
  //
  //   final maskedLength = uid.length - 4;
  //   return '*' * maskedLength + uid.substring(uid.length - 4);
  // }
  //

  // clearData() {
  //   fullNameController.clear();
  //   fatherNameController.clear();
  //   dobController.clear();
  //   mobileController.clear();
  //   emailController.clear();
  //   aadharController.clear();
  //   familyIncomeController.clear();
  //   uidNumberController.clear();
  //   profileFile =  null;
  //   maritalStatus =  "";
  //   religion =  "";
  //   caste =  "";
  //   uidType =  "";
  //   isMinority = false;
  //   gender = "Male";
  //   notifyListeners();
  // }
}
