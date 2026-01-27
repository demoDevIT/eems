import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../repo/common_repo.dart';

class CounselorJobDetailsProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  CounselorJobDetailsProvider({required this.commonRepo});

  final List<Map<String, String>> educationList = [
    {
      "degree": "Telecom",
      "university": "Rajasthan University",
      "ncoCode": "123123",
      "salary": "50k",

    },

  ];




  @override
  void dispose() {
    super.dispose();
  }


}
