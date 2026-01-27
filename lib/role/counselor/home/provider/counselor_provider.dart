import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../repo/common_repo.dart';

class CounselorProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  CounselorProvider({required this.commonRepo});

  List<Color> backgroundColors = [
    Color(0xffE9E5FF),
    Color(0xffFFECE7),
    Color(0xffDDE8FF),
    Color(0xffE8FFFA),
  ];

  List<Color> iconBgColors = [
    Color(0xff714EFC),
    Color(0xffF93A0B),
    Color(0xff0F53CD),
    Color(0xff10AE82),
  ];

  final List<Map<String, String>> dataList = [
    {
      "name": "Upcoming Sessions",
      "description": "200",

    },
    {
      "name": "Past Sessions",
      "description": "150",

    },
    {
      "name": "Present Sessions",
      "description": "75",

    },
    {
      "name": "Job Recommended",
      "description": "25",

    },

  ];




  @override
  void dispose() {
    super.dispose();
  }


}
