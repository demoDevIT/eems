import 'package:flutter/material.dart';

import '../../../../repo/common_repo.dart';

class MysyListProvider extends ChangeNotifier {

  final CommonRepo commonRepo;
  MysyListProvider({required this.commonRepo});

  List<Map<String, dynamic>> mysyList = [
    {
      "srNo": 1,
      "applicationNo": "APP2024001",
      "fatherName": "Ramesh Kumar",
      "schemeName": "Mukhyamantri Yuva Sambal Yojana",
      "aadharNo": "XXXX-XXXX-1234",
      "gender": "Male",
      "category": "OBC",
      "dob": "12-05-2001",
      "status": "Pending",
      "receivingDate": "01-01-2024"
    },
    {
      "srNo": 2,
      "applicationNo": "APP2024002",
      "fatherName": "Mahesh Sharma",
      "schemeName": "Mukhyamantri Yuva Sambal Yojana",
      "aadharNo": "XXXX-XXXX-5678",
      "gender": "Female",
      "category": "SC",
      "dob": "18-08-2000",
      "status": "Approved",
      "receivingDate": "05-01-2024"
    }
  ];
}
