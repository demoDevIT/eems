import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../repo/common_repo.dart';

class ShareFeedbackDetailsProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  ShareFeedbackDetailsProvider({required this.commonRepo});

  final TextEditingController commentController = TextEditingController();


  final List<Map<String, String>> educationList = [
    {
      "degree": "Telecom",
      "university": "Rajasthan University",
      "ncoCode": "123123",
      "salary": "50k",

    },

  ];
  String radio1 = "No";
  String radio2 = "No";
  String radio3 = "No";




  @override
  void dispose() {
    super.dispose();
  }


}
