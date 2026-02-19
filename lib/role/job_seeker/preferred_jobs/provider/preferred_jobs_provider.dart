import 'package:flutter/material.dart';

import '../../../../repo/common_repo.dart';

class PreferredJobsProvider extends ChangeNotifier {
  final CommonRepo commonRepo;
  PreferredJobsProvider({required this.commonRepo});
  /// =========================
  /// FILTER CONTROLLERS
  /// =========================

  final TextEditingController jobTitleController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String? selectedSector;

  List<String> sectorList = [
    "IT",
    "Finance",
    "Education",
    "Healthcare",
    "Construction"
  ];

  /// =========================
  /// JOB LIST (STATIC FOR NOW)
  /// =========================

  List<Map<String, dynamic>> jobList = [
    {
      "title": "Tester",
      "type": "Full Time",
      "salary": "₹25000",
      "name": "48 F DUGDH UTPADAK SAHAKARI",
      "district": "Alwar"
    },
    {
      "title": "Data Entry Operator",
      "type": "Part Time",
      "salary": "₹18000",
      "name": "ABC Private Limited",
      "district": "Jaipur"
    }
  ];

  List<Map<String, dynamic>> filteredJobs = [];

  // PreferredJobsProvider() {
  //   filteredJobs = jobList;
  // }

  /// =========================
  /// SEARCH
  /// =========================

  void searchJobs() {
    filteredJobs = jobList.where((job) {
      final titleMatch = jobTitleController.text.isEmpty ||
          job["title"]
              .toString()
              .toLowerCase()
              .contains(jobTitleController.text.toLowerCase());

      final locationMatch = locationController.text.isEmpty ||
          job["district"]
              .toString()
              .toLowerCase()
              .contains(locationController.text.toLowerCase());

      final sectorMatch = selectedSector == null ||
          selectedSector!.isEmpty ||
          true; // static for now

      return titleMatch && locationMatch && sectorMatch;
    }).toList();

    notifyListeners();
  }

  /// =========================
  /// CLEAR
  /// =========================

  void clearFilters() {
    jobTitleController.clear();
    locationController.clear();
    selectedSector = null;
    filteredJobs = jobList;
    notifyListeners();
  }
}
