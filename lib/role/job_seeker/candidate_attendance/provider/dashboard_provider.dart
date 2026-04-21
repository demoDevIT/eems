import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../repo/common_repo.dart';

class DashboardProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  DashboardProvider({required this.commonRepo});

  @override
  void dispose() {
    super.dispose();
  }

  clearData() {

    notifyListeners();
  }
}
