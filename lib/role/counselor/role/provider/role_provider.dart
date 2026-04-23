import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../repo/common_repo.dart';

class RoleProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  RoleProvider({required this.commonRepo});

  String selectedFlow = ""; // "", "gov", "private"

  bool? isRajasthanResident; // for radio

  void selectGovernment() {
    selectedFlow = "gov";
    notifyListeners();
  }

  void selectPrivate() {
    selectedFlow = "private";
    notifyListeners();
  }

  void reset() {
    selectedFlow = "";
    isRajasthanResident = null;
    notifyListeners();
  }

  void setResident(bool value) {
    isRajasthanResident = value;
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }



  clearData() {

    notifyListeners();
  }
}
