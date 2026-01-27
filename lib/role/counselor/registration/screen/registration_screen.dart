import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/gradient_scaffold.dart';
import 'package:rajemployment/l10n/app_localizations.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/textstyles.dart';
import 'package:rajemployment/utils/utility_class.dart';
import '../../../../utils/images.dart';
import '../../../../utils/textfeild.dart';
import 'package:provider/provider.dart';
import '../provider/registration_provider.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();




  @override
  void initState() {
    // TODO: implement initState
    super.initState();



  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return PopScope(
      canPop: true,
      child: Scaffold(
        key: _scaffoldKey,
        body: Container(
          decoration:  BoxDecoration(
            gradient: backgroundGradient5,
          ),
          child: Consumer<RegistrationProvider>(
          builder: (context, provider, child) => Padding(
          padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: SvgPicture.asset(
                      Images.lan,
                      width: 35,
                      height: 35,
                      semanticsLabel: 'Location icon',
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 60),
                  Center(
                    child: Image.asset(
                      "assets/logos/logo.png",
                      height: 100,
                    ),
                  ),
                  SizedBox(height: SizeConfig.screenHeight! * 0.04),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 30),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Container(
                                  alignment: Alignment.centerRight,
                                  padding: const EdgeInsets.only(right: 40),
                                  child: Text(
                                    "Registration of Govt Employee",
                                    style: Styles.boldTextStyle(size: 18, color: kBlackColor,),
                                  ),
                                ),
                              ),

                            ],
                          ),
                          hSpace(30),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 2),
                              child: Text(
                                "Employee ID / Batch ID",
                                style: Styles.regularTextStyle(size: 10, color: fontGrayColor,),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child: buildTextWithBorderField(
                                provider.employeeIDController,
                                "Employee ID / Batch ID",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,

                            ),),

                          SizedBox(height: SizeConfig.screenHeight! * 0.025),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kPrimaryDark,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),

                              onPressed:() async {

                                    },
                              child: Text(
                                "Get OTP",
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),

                          SizedBox(height: SizeConfig.screenHeight! * 0.025),

                          InkWell(
                            onTap: () {

                              setState(() {});
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.donthaveaccount,
                                  style: UtilityClass.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                    color: kBlackColor,
                                  ),
                                ),
                                vSpace(5),
                                Text(
                                  "Register Here",
                                  style: UtilityClass.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: kbuttonColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: SizeConfig.screenHeight! * 0.005),
                        ],
                      ),
                    ),
                  ),
                ],
              ),),
                ),
        ),),
    );
  }
}
