import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../repo/common_repo.dart';

class RegistrationProvider with ChangeNotifier {
  bool isChecked = false; // Default value for checkbox
  final CommonRepo commonRepo;

  RegistrationProvider({required this.commonRepo});
  TextEditingController employeeIDController = TextEditingController();







}
