import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../repo/common_repo.dart';

class SelfAssessmentProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  SelfAssessmentProvider({required this.commonRepo});





  void clearData() {

    notifyListeners();
  }

}
