import 'package:get/get.dart';

import 'package:rajemployment/role/job_seeker/loginscreen/modal/login_modal.dart';

class UserData {
  static final UserData _user = UserData._internal();
  var model = LoginData().obs;
  var referralCode = '';
  var fcmToken = '';
  var pin = '';

  factory UserData() {
    return _user;
  }

  UserData._internal();
}
