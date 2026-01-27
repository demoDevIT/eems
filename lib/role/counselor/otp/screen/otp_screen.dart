import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/counselor/counselor_dashboard/counselor_dashboard.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/gradient_scaffold.dart';
import 'package:rajemployment/l10n/app_localizations.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/textstyles.dart';
import 'package:rajemployment/utils/utility_class.dart';
import '../../../../utils/images.dart';
import '../../../../utils/right_to_left_route.dart';
import '../../../../utils/textfeild.dart';
import 'package:provider/provider.dart';
import '../provider/otp_provider.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
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
          child: Consumer<OtpProvider>(
          builder: (context, provider, child) => Padding(
          padding: const EdgeInsets.all(20),
              child: ListView(
                children: [

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(Icons.arrow_back_ios_new),
                      Text(
                        "Verify",
                        textAlign: TextAlign.center,
                        style: Styles.boldTextStyle(size: 18, color: kBlackColor,
                        ),
                      ),

                      SvgPicture.asset(
                        Images.lan,
                        width: 35,
                        height: 35,
                        semanticsLabel: 'Location icon',
                        fit: BoxFit.contain,
                      ),

                    ],
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
                          Container(
                            alignment: Alignment.center,
                            child: Text(
                              "Enter OTP",
                              textAlign: TextAlign.center,
                              style: Styles.boldTextStyle(size: 18, color: kBlackColor,
                              ),
                            ),
                          ),
                          hSpace(10),
                          Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 2),
                              child: Text(
                                textAlign: TextAlign.center,
                                "OTP has been sent on your registered\nmobile number",
                                style: Styles.regularTextStyle(size: 10, color: fontGrayColor,),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10,top: 20),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: PinCodeTextField(
                                  controller: provider.otpController,
                                  autoDisposeControllers: false,
                                  cursorColor: borderColor,
                                  appContext: context,
                                  length: 4,
                                  hintCharacter: '-',
                                  hintStyle: Styles.regularTextStyle(size: 20),
                                  textStyle: Styles.regularTextStyle(size: 20),
                                  keyboardType: TextInputType.number,
                                  pinTheme: PinTheme(
                                    shape: PinCodeFieldShape.box,
                                    inactiveColor:
                                    borderColor,
                                    activeColor:
                                    borderColor,
                                    selectedColor:
                                    borderColor,
                                    selectedFillColor:
                                    borderColor,
                                    fieldHeight: 50,
                                    fieldWidth: 50,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  onChanged: (value) {
                                    debugPrint(value);
                                  },
                                ),
                              ),
                            ),
                          ),

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
                                Navigator.of(context).push(
                                  RightToLeftRoute(
                                    page: const CounselorDashboard(),
                                    duration: const Duration(milliseconds: 500),
                                    startOffset: const Offset(-1.0, 0.0),
                                  ),
                                );

                                    },
                              child: Text(
                                "Verify",
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
                                  "Resend OTP",
                                  style: Styles.mediumTextStyle(size: 12,color:kBlackColor)
                                ),
                                vSpace(5),
                                Text(
                                  "(00:12)",
                                    style: Styles.regularTextStyle(size: 12,color:fontGrayColor)

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
