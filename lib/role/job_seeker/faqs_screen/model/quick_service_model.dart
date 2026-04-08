import 'dart:ui';

import 'package:flutter/cupertino.dart';

import 'faqs_assistance_model.dart';

class QuickServiceModel {
  dynamic fAQAssistanceId;
  dynamic parentID;
  String faqAssistanceHi;
  String faqAssistanceEng;
  String enumName;
  Color color;
  // IconData icon;
  final String iconPath;
  FaqsAssistanceData originalData;

  QuickServiceModel({
    required this.fAQAssistanceId,
    required this.parentID,
    required this.faqAssistanceHi,
    required this.faqAssistanceEng,
    required this.enumName,
    required this.color,
    // required this.icon,
    required this.iconPath,
    required this.originalData,
  });
}