// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:rajemployment/utils/global.dart';
// import 'package:rajemployment/utils/user_new.dart';
//
// import '../../../../repo/common_repo.dart';
//
// class CounselorBasicDetailsProvider extends ChangeNotifier {
//   final CommonRepo commonRepo;
//
//   CounselorBasicDetailsProvider({required this.commonRepo});
//
//   // Controllers for text fields
//   final TextEditingController fullNameController = TextEditingController();
//   final TextEditingController genderController = TextEditingController();
//   final TextEditingController dobController = TextEditingController();
//   final TextEditingController mobileController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController prefLangController = TextEditingController();
//   final TextEditingController specExpertiseLangController = TextEditingController();
//   final TextEditingController stateController = TextEditingController();
//   final TextEditingController districtController = TextEditingController();
//   final TextEditingController cityController = TextEditingController();
//
//   @override
//   void dispose() {
//     super.dispose();
//   }
//
//   addData() {
//     // fullNameController.text = UserData().model.value.nAMEENG.toString();
//     // fatherNameController.text = UserData().model.value.fATHERNAMEENG.toString();
//     // dobController.text = UserData().model.value.dOB.toString();
//     // mobileController.text = UserData().model.value.mOBILENO.toString();
//     // emailController.text = UserData().model.value.eMAILID.toString();
//     // aadharController.text = UserData().model.value.aadharNo.toString();
//     // familyIncomeController.text = "";
//     // // uidNumberController.text = UserData().model.value.uIDNumber.toString();
//     // uidNumberController.text = maskUid(UserData().model.value.uIDNumber.toString());
//     // maritalStatus = UserData().model.value.maritalStatus.toString();
//     // maritalStatusController.text = UserData().model.value.maritalStatus.toString();
//     // religion = UserData().model.value.religion.toString();
//     // religionController.text = UserData().model.value.religion.toString();
//     // caste = UserData().model.value.caste.toString();
//     // casteController.text = UserData().model.value.caste.toString();
//     // uidTypeController.text = "Aadhar";
//     // isMinority = UserData().model.value.miniority == 1 ?  true :  false;
//     // gender = checkNullValue(UserData().model.value.gENDER.toString()).isNotEmpty ?  UserData().model.value.gENDER.toString() :  "Male";
//     // familyIncomeController.text =UserData().model.value.familyIncome.toString();
//     // notifyListeners();
//   }
//
//   // String maskUid(String uid) {
//   //   if (uid.isEmpty) return '';
//   //
//   //   if (uid.length <= 4) {
//   //     return uid; // nothing to mask
//   //   }
//   //
//   //   final maskedLength = uid.length - 4;
//   //   return '*' * maskedLength + uid.substring(uid.length - 4);
//   // }
//   //
//
//   // clearData() {
//   //   fullNameController.clear();
//   //   fatherNameController.clear();
//   //   dobController.clear();
//   //   mobileController.clear();
//   //   emailController.clear();
//   //   aadharController.clear();
//   //   familyIncomeController.clear();
//   //   uidNumberController.clear();
//   //   profileFile =  null;
//   //   maritalStatus =  "";
//   //   religion =  "";
//   //   caste =  "";
//   //   uidType =  "";
//   //   isMinority = false;
//   //   gender = "Male";
//   //   notifyListeners();
//   // }
// }
