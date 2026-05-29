import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/user_new.dart';

import '../../../../repo/common_repo.dart';

class DeptProfileProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  DeptProfileProvider({required this.commonRepo});





  @override
  void dispose() {
    super.dispose();
  }

}
