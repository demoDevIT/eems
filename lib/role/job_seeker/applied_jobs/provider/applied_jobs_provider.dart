import 'package:flutter/material.dart';
import '../../../../repo/common_repo.dart';

class AppliedJobsProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  AppliedJobsProvider({required this.commonRepo}) {
    appliedJobs = jobList;
  }

  /// =========================
  /// STATIC JOB LIST (Same as Preferred)
  /// =========================

  List<Map<String, dynamic>> jobList = [
    {
      "title": "Designer Assistant",
      "type": "Full Time",
      "salary": "₹35000",
      "name": "48 F DUGDH UTPADAK SAHAKARI",
      "district": "Alwar"
    },
    {
      "title": "Product Manager",
      "type": "Full Time",
      "salary": "₹35000",
      "name": "48 F DUGDH UTPADAK SAHAKARI",
      "district": "Mount Abu"
    },
    {
      "title": "Associate Product Manager",
      "type": "Full Time",
      "salary": "₹35000",
      "name": "48 F DUGDH UTPADAK SAHAKARI",
      "district": "Jaipur Greater"
    },
    {
      "title": "Product Owner",
      "type": "Full Time",
      "salary": "₹25000",
      "name": "48 F DUGDH UTPADAK SAHAKARI",
      "district": "Jaipur Greater"
    },
  ];

  List<Map<String, dynamic>> appliedJobs = [];
}
