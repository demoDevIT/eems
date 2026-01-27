import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/gradient_scaffold.dart';
import 'package:rajemployment/l10n/app_localizations.dart';
import 'package:rajemployment/utils/language_toggle_switch.dart';
import 'package:rajemployment/utils/right_to_left_route.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/utility_class.dart';
import '../../../../utils/textfeild.dart';
import '../../../../utils/textstyles.dart';
import '../../../../utils/user_new.dart';
import '../../candidate_attendance/candidate_attendance_screen.dart';
import '../../jobseekerdashboard/job_seeker_dashboard.dart';
import 'package:provider/provider.dart';

import '../../roleselectionscreen/roleselection_screen.dart';
import '../provider/login_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool _obscureText = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool validateAndSave() {
    print("checking-> 1");
    final isValid = _formKey.currentState!.validate();
    print("checking-> ${isValid.toString()}");
    if (isValid) {
      _formKey.currentState!.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final userAuthProvider = Provider.of<LoginProvider>(context, listen: false);
      if (checkNullValue(UserData().model.value.username.toString()).isNotEmpty && UserData().model.value.password.toString().isNotEmpty) {
        userAuthProvider.rememberMe(true);
        userAuthProvider.SSOIDController.text = UserData().model.value.username.toString();
        userAuthProvider.passwordController.text = UserData().model.value.password.toString();
      } else {
       // userAuthProvider.SSOIDController.text = "DEEPAKJANGID505364";
        //userAuthProvider.passwordController.text = "Iamdk@5364";

         // userAuthProvider.SSOIDController.text = "deepakmay23"; //"jjseeker123";
         // userAuthProvider.passwordController.text = "KD@1230";

       // userAuthProvider.SSOIDController.text = "EEMSJobFairEvent"; //eemsdevitjaipur
       // userAuthProvider.passwordController.text = "EEMSJobFair@123"; //KD@1230

        userAuthProvider.rememberMe(false);
      }
    });
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
          child: Consumer<LoginProvider>(
            builder: (context, provider, child) => Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
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
                          horizontal: 10, vertical: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Row(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.80 / 3,

                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.80 / 3,
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.login,
                                    style: UtilityClass.poppins(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.80 / 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      width: 80,
                                      child: LanguageToggleSwitch(),
                                    ),
                                  ],
                                ),
                              ),


                              // Toggle button aligned to right

                            ],
                          ),




                          SizedBox(height: SizeConfig.screenHeight! * 0.025),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.SSOIDController,
                              AppLocalizations.of(context)!.ssoid,
                              MediaQuery.of(context).size.width,
                              50,
                              TextInputType.emailAddress,
                              boxColor: Colors.transparent,
                              bodercolor: kDartGrayColor,
                              prefixIcon: Icon(
                                Icons.email_outlined,
                                color: Colors.grey,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                              /* obscureText: _obscureText,*/

                              provider.passwordController,
                              AppLocalizations.of(context)!.password,
                              MediaQuery.of(context).size.width,
                              50,
                              TextInputType.text,
                              boxColor: Colors.transparent,
                              bodercolor: kDartGrayColor,
                              isObsecure:
                                  provider.passwordInVisible ? true : false,
                              prefixIcon: Icon(
                                Icons.lock_outline,
                                color: Colors.grey,
                              ),
                              postfixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    provider.updatePasswordVisibility();
                                  });
                                },
                                child: provider.passwordInVisible
                                    ? const Icon(
                                        Icons.visibility_off,
                                        color: Colors.grey,
                                      )
                                    : const Icon(
                                        Icons.visibility,
                                        color: Colors.grey,
                                      ),
                              ),
                            ),
                          ),

                          // Email

                          SizedBox(height: SizeConfig.screenHeight! * 0.005),
                          // Remember me + Forgot Password
                          Row(
                            children: [
                              Checkbox(
                                value: provider.isChecked,
                                onChanged: (value) {
                                  provider.rememberMe(value);
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(4), // adjust radius
                                ),
                                side: const BorderSide(
                                  color: kDartGrayColor,
                                  width: 2,
                                ),
                                // border color
                                activeColor: kPrimaryColor,
                                checkColor: Colors.white,
                                fillColor:
                                    MaterialStateProperty.resolveWith<Color>(
                                  (states) {
                                    if (states.contains(MaterialState.selected)) {
                                      return kPrimaryColor;
                                    }
                                    return kTextColor1;
                                  },
                                ),
                              ),
                               Text(
                                AppLocalizations.of(context)!.rememberme,
                                style: Styles.mediumTextStyle(size: 12),
                              ),
                              const Spacer(),
                              TextButton(
                                onPressed: () {},
                                child: Text(
                                  AppLocalizations.of(context)!.forgetpass,
                                  style: Styles.mediumTextStyle(size: 12,color: kbuttonColor),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: SizeConfig.screenHeight! * 0.020),

                          // Login Button
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
                              // onPressed: () {
                              //   Navigator.of(_scaffoldKey.currentContext!).push(
                              //     RightToLeftRoute(
                              //       page: const JobSeekerDashboard(),
                              //       duration: const Duration(milliseconds: 500),
                              //       startOffset: const Offset(-1.0, 0.0),
                              //     ),
                              //   );
                              //   setState(() {
                              //
                              //   });
                              // },
                              onPressed: () async {
                                    if (provider.SSOIDController.text.isEmpty) {
                                        showAlertError("Please enter sso id", context);
                                      }
                                      else if (provider.passwordController.text.isEmpty) {
                                        showAlertError("Please enter password", context);
                                      } else {
                                      // Navigator.of(context).push(
                                      //   RightToLeftRoute(
                                      //     page: const JobSeekerDashboard(),
                                      //     duration: const Duration(milliseconds: 500),
                                      //     startOffset: const Offset(-1.0, 0.0),
                                      //   ),
                                      // );
                                      await provider.ssoLoginWithIDPassApi(context);
                                      }
                                     },
                              child: Text(
                                AppLocalizations.of(context)!.login,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                          SizedBox(height: SizeConfig.screenHeight! * 0.040),

                          UtilityClass.orDivider(context),

                          SizedBox(height: SizeConfig.screenHeight! * 0.030),

                          InkWell(
                            onTap: () {
                              Navigator.of(_scaffoldKey.currentContext!).push(
                                RightToLeftRoute(
                                  page:  RoleSelectionScreen(ssoId:provider.SSOIDController.text,userID: "",),
                                  duration: const Duration(milliseconds: 500),
                                  startOffset: const Offset(-1.0, 0.0),
                                ),
                              );
                              setState(() {});
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [

                                Text(
                                  AppLocalizations.of(context)!.donthaveaccount,
                                  style: Styles.mediumTextStyle(size: 12),
                                ),
                                vSpace(5),
                                Text(
                                  AppLocalizations.of(context)!.dosignup,
                                  style: Styles.semiBoldTextStyle(size: 12,color: kbuttonColor),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
