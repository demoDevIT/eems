import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/otr_form/otr_form.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/gradient_scaffold.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/utility_class.dart';

import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import 'provider/janadhaarflow_provider.dart';

enum FlowStep { enterJanAadhaar, memberList, otp }

class JanAadhaarFlowPage extends StatefulWidget {
  String ssoId;
  String userID;
  JanAadhaarFlowPage({super.key,required this.ssoId,required this.userID});


  @override
  State<JanAadhaarFlowPage> createState() => _JanAadhaarFlowPageState(ssoId,userID);
}

class _JanAadhaarFlowPageState extends State<JanAadhaarFlowPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String ssoId;
  String userID;
  _JanAadhaarFlowPageState(this.ssoId,this.userID);


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<JanAadhaarFlowProvider>(context, listen: false);
      provider.clearData();
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
          child: Consumer<JanAadhaarFlowProvider>(
            builder: (context, provider, child) => Padding(
              padding: const EdgeInsets.all(20),
              child: ListView(
                children: [
                  const SizedBox(height: 60),
                  // Logo
                  Center(
                    child: Image.asset(
                      "assets/logos/logo.png",
                      height: 100,
                    ),
                  ),

                  SizedBox(height: SizeConfig.screenHeight! * 0.04),

                  _buildCurrentStep()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentStep() {
    final provider =
        Provider.of<JanAadhaarFlowProvider>(context, listen: false);

    switch (provider.currentStep) {
      case FlowStep.enterJanAadhaar:
        return _buildEnterJanAadhaar();
      case FlowStep.memberList:
        return _buildMemberList();
      case FlowStep.otp:
        return _buildOtpScreen();
    }
  }

  // 1️⃣ Enter Jan Aadhaar
  Widget _buildEnterJanAadhaar() {
    final provider =
        Provider.of<JanAadhaarFlowProvider>(context, listen: false);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              alignment: Alignment.center,
              child: Text(
                   "JanAadhaar",
                style: UtilityClass.poppins(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),

            SizedBox(height: SizeConfig.screenHeight! * 0.025),

            /// ✅ JanAadhaar Form
            ///
            ///
            ///
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child:
                  labelWithStar('JanAadhaar Number', required: false, size: 14),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: buildTextWithBorderField(
                provider.janAadhaarController,
                "Enter JanAadhaar Number",
                MediaQuery.of(context).size.width,
                textLenght: 11,
                50,
                TextInputType.number,
              ),
            ),

            SizedBox(height: SizeConfig.screenHeight! * 0.020),

            // Verify Button
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
                onPressed: () {
                  /*  //provider.currentStep = FlowStep.memberList;
                  setState(() {

                  });*/
                  provider.fetchMembersListApi(
                      context, provider.janAadhaarController.text);
                },
                child: Text(
                  "Submit",
                  style: UtilityClass.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 2️⃣ Member List
  Widget _buildMemberList() {
    final provider =
        Provider.of<JanAadhaarFlowProvider>(context, listen: false);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                "Select Member",
                style: UtilityClass.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.025),
            ...List.generate(
                provider.fetchMemberList.length,
                (index) => Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        color: kButtonColor,
                        border: Border.all(color: borderColor, width: 0.5),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                              10), // Rounded corners for the Container
                        ),
                      ),
                      child: Container(
                        margin: const EdgeInsets.only(top: 5),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 0),
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10),
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(
                                  10) // Rounded corners for the Container
                              ),
                        ),
                        child: Column(
                          children: [
                            hSpace(5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: RichText(
                                    text: TextSpan(
                                      style: Styles.mediumTextStyle(
                                        size: 12,
                                        color:
                                            kBlackColor, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Member Name",
                                          // Normal text
                                          style: Styles.mediumTextStyle(
                                              size: 12, color: kBlackColor),
                                        ),
                                        TextSpan(
                                          text: ' :-',
                                          // Asterisk text
                                          style: Styles.mediumTextStyle(
                                              size: 12, color: kBlackColor),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign
                                        .start, // Align text to the start
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: RichText(
                                      text: TextSpan(
                                        style: Styles.mediumTextStyle(
                                          size: 12,
                                          color:
                                              kBlackColor, // Default text color
                                        ),
                                        children: [
                                          TextSpan(
                                            text: provider
                                                .fetchMemberList[index].nAMEEN
                                                .toString(),
                                            style: Styles.regularTextStyle(
                                                size: 12, color: kBlackColor),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign
                                          .end // Align text to the start
                                      ),
                                ),
                              ],
                            ),
                            hSpace(5),
                            Divider(
                              color: dividerColor,
                              height: 2,
                            ),
                            hSpace(5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: RichText(
                                    text: TextSpan(
                                      style: Styles.mediumTextStyle(
                                        size: 12,
                                        color:
                                            kBlackColor, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Member ID",
                                          // Normal text
                                          style: Styles.mediumTextStyle(
                                              size: 12, color: kBlackColor),
                                        ),
                                        TextSpan(
                                          text: ' :-',
                                          // Asterisk text
                                          style: Styles.mediumTextStyle(
                                              size: 12, color: kBlackColor),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign
                                        .start, // Align text to the start
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: RichText(
                                      text: TextSpan(
                                        style: Styles.mediumTextStyle(
                                          size: 12,
                                          color:
                                              kBlackColor, // Default text color
                                        ),
                                        children: [
                                          TextSpan(
                                            text: provider
                                                .fetchMemberList[index].mEMBERID
                                                .toString(),
                                            style: Styles.regularTextStyle(
                                                size: 12, color: kBlackColor),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign
                                          .end // Align text to the start
                                      ),
                                ),
                              ],
                            ),
                            hSpace(5),
                            Divider(
                              color: dividerColor,
                              height: 2,
                            ),
                            hSpace(5),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.30,
                                  child: RichText(
                                    text: TextSpan(
                                      style: Styles.mediumTextStyle(
                                        size: 12,
                                        color:
                                            kBlackColor, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Member Type",
                                          // Normal text
                                          style: Styles.mediumTextStyle(
                                              size: 12, color: kBlackColor),
                                        ),
                                        TextSpan(
                                          text: ' :-',
                                          // Asterisk text
                                          style: Styles.mediumTextStyle(
                                              size: 12, color: kBlackColor),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign
                                        .start, // Align text to the start
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  child: RichText(
                                      text: TextSpan(
                                        style: Styles.mediumTextStyle(
                                          size: 12,
                                          color:
                                              kBlackColor, // Default text color
                                        ),
                                        children: [
                                          TextSpan(
                                            text: provider
                                                .fetchMemberList[index]
                                                .mEMBERTYPE
                                                .toString(),
                                            style: Styles.regularTextStyle(
                                                size: 12, color: kBlackColor),
                                          ),
                                        ],
                                      ),
                                      textAlign: TextAlign
                                          .end // Align text to the start
                                      ),
                                ),
                              ],
                            ),
                            hSpace(5),
                            Divider(
                              color: dividerColor,
                              height: 2,
                            ),

                            hSpace(5),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.30,
                              height: 35,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kbuttonColor,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed:  () {
                                  provider.memberID =  provider.fetchMemberList[index].mEMBERID.toString();
                                  provider.generateOTPApi(context, provider.fetchMemberList[index].mEMBERID.toString());

                                },
                                child: Text(
                                  "Get OTP",
                                  style: UtilityClass.poppins(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: kWhite,
                                  ),
                                ),
                              ),
                            ),
                            hSpace(5),
                          ],
                        ),
                      ),
                    )),


          ],
        ),
      ),
    );
  }

  // 3️⃣ OTP Screen
  Widget _buildOtpScreen() {
    final provider =
        Provider.of<JanAadhaarFlowProvider>(context, listen: false);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                "Enter OTP",
                style: UtilityClass.poppins(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.030),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: buildTextWithBorderField(
                provider.otpController,
                "Enter OTP",
                MediaQuery.of(context).size.width,
                50,
                TextInputType.number,
                boxColor: Colors.transparent,
                bodercolor: kDartGrayColor,
                textLenght: 6
              ),
            ),
            SizedBox(height: SizeConfig.screenHeight! * 0.030),
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
                onPressed: () {
                  if (provider.otpController.text.isEmpty) {
                    showAlertError("Please enter otp", context);
                  }
                  else {
                    //provider.validateOTPApi(context,provider.memberID,provider.tid,provider.otpController.text,ssoId,userID);
                     provider.validateOTPApiMock(context,provider.memberID,provider.tid,provider.otpController.text,ssoId,userID);

                  }
                },
                child: Text(
                  "Verify OTP",
                  style: UtilityClass.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: kWhite,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // janAadhaarFocus.dispose();
    super.dispose();
  }
}
