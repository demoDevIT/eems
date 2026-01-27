import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../repo/common_repo.dart';

class OtpProvider with ChangeNotifier {
  bool isChecked = false; // Default value for checkbox
  final CommonRepo commonRepo;

  OtpProvider({required this.commonRepo});
  TextEditingController otpController = TextEditingController();







}
