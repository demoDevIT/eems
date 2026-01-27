import 'package:flutter/material.dart';
import 'package:rajemployment/utils/gradient_scaffold.dart';
import 'package:rajemployment/onboarding_screen.dart';
import 'package:rajemployment/utils/pref_util.dart';

import '../../../utils/images.dart';
import '../../../utils/right_to_left_route.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    Future.delayed(Duration(seconds: 5), () {
      checkLoginStatus();
    });
    super.initState();
  }

  Future checkLoginStatus() async {
    Navigator.pushAndRemoveUntil<dynamic>(context,
        MaterialPageRoute<dynamic>(builder: (BuildContext context) => const OnboardingScreen()),
            (route) => false);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.symmetric(horizontal: 50,vertical: 50),
        child: Image(
          image: AssetImage(Images.app_logo_title),
        ),
      ),
    );
  }
}
