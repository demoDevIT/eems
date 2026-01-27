import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/addressinfo/modal/district_modal.dart';
import 'package:rajemployment/role/job_seeker/addressinfo/provider/address_info_provider.dart';
import 'package:rajemployment/utils/size_config.dart';

import '../../../../utils/dropdown.dart';
import '../../../../utils/global.dart';
import '../../../../utils/textfeild.dart';
import '../../../../utils/textstyles.dart';

class CreateSessionInfoScreen extends StatefulWidget {
  const CreateSessionInfoScreen({super.key});

  @override
  State<CreateSessionInfoScreen> createState() => _CreateSessionInfoScreenState();
}

class _CreateSessionInfoScreenState extends State<CreateSessionInfoScreen> {




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {

    });
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          "Create Session",
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
        body: Consumer<AddressInfoProvider>(builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child:  RichText(
                      text: TextSpan(
                        style: Styles.mediumTextStyle(
                          size: 12,
                          color: kBlackColor, // Default text color
                        ),
                        children: [
                          TextSpan(
                            text: "Event title*",
                            // Normal text
                            style: Styles.mediumTextStyle(
                                size: 12,
                                color:
                                kBlackColor),
                          ),
                          TextSpan(
                            text: ' *', // Asterisk text
                            style: Styles.mediumTextStyle(
                                size: 12,
                                color:
                                kRedColor),
                          ),
                        ],
                      ),
                      textAlign: TextAlign
                          .start, // Align text to the start
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: buildTextWithBorderField(
                    provider.addressController,
                    "Event title*",
                    MediaQuery.of(context).size.width,
                    50,
                    TextInputType.emailAddress,
                    isEnabled: provider.sameAsAbove == false ? true : false
                  ),
                ),

                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child:  RichText(
                      text: TextSpan(
                        style: Styles.mediumTextStyle(
                          size: 12,
                          color: kBlackColor, // Default text color
                        ),
                        children: [
                          TextSpan(
                            text: "Date",
                            // Normal text
                            style: Styles.mediumTextStyle(
                                size: 12,
                                color:
                                kBlackColor),
                          ),
                          TextSpan(
                            text: ' *', // Asterisk text
                            style: Styles.mediumTextStyle(
                                size: 12,
                                color:
                                kRedColor),
                          ),
                        ],
                      ),
                      textAlign: TextAlign
                          .start, // Align text to the start
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    FocusScope.of(context).requestFocus(new FocusNode());
                    showDateSheet2(context, provider.assemblyIDController).then((_) {
                      setState(() {});
                    }).catchError((error) {
                      setState(() {});
                    });
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: buildTextWithBorderField(
                        provider.addressController,
                        "Date",
                        MediaQuery.of(context).size.width,
                        50,
                        TextInputType.text,
                        postfixIcon: Icon(Icons.calendar_month,color: grayLightColor,),
                        isEnabled:  false
                        
                    ),
                  ),
                ),


                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width  * 0.92/ 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child:   RichText(
                              text: TextSpan(
                                style: Styles.mediumTextStyle(
                                  size: 12,
                                  color: kBlackColor, // Default text color
                                ),
                                children: [
                                  TextSpan(
                                    text: "Start Time",
                                    // Normal text
                                    style: Styles.mediumTextStyle(
                                        size: 12,
                                        color:
                                        kBlackColor),
                                  ),
                                  TextSpan(
                                    text: ' *', // Asterisk text
                                    style: Styles.mediumTextStyle(
                                        size: 12,
                                        color:
                                        kRedColor),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign
                                  .start, // Align text to the start
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              FocusScope.of(context).requestFocus(new FocusNode());
                              showDateSheet2(context, provider.assemblyIDController).then((_) {
                                setState(() {});
                              }).catchError((error) {
                                setState(() {});
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                              child: buildTextWithBorderField(
                                  provider.addressController,
                                  "Start Time",
                                  MediaQuery.of(context).size.width,
                                  50,
                                  TextInputType.text,
                                  postfixIcon: Icon(Icons.lock_clock,color: grayLightColor,),
                                  isEnabled:  false

                              ),
                            ),
                          ),


                        ],
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width  * 0.92/ 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                            child:   RichText(
                              text: TextSpan(
                                style: Styles.mediumTextStyle(
                                  size: 12,
                                  color: kBlackColor, // Default text color
                                ),
                                children: [
                                  TextSpan(
                                    text: "End Time",
                                    // Normal text
                                    style: Styles.mediumTextStyle(
                                        size: 12,
                                        color:
                                        kBlackColor),
                                  ),
                                  TextSpan(
                                    text: ' *', // Asterisk text
                                    style: Styles.mediumTextStyle(
                                        size: 12,
                                        color:
                                        kRedColor),
                                  ),
                                ],
                              ),
                              textAlign: TextAlign
                                  .start, // Align text to the start
                            ),
                          ),


                          InkWell(
                            onTap: () {
                              FocusScope.of(context).requestFocus(new FocusNode());
                              showDateSheet2(context, provider.assemblyIDController).then((_) {
                                setState(() {});
                              }).catchError((error) {
                                setState(() {});
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                              child: buildTextWithBorderField(
                                  provider.addressController,
                                  "End Time",
                                  MediaQuery.of(context).size.width,
                                  50,
                                  TextInputType.text,
                                  postfixIcon: Icon(Icons.lock_clock,color: grayLightColor,),
                                  isEnabled:  false

                              ),
                            ),
                          ),


                        ],
                      ),
                    ),
                  ],
                ),







                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child:  RichText(
                      text: TextSpan(
                        style: Styles.mediumTextStyle(
                          size: 12,
                          color: kBlackColor, // Default text color
                        ),
                        children: [
                          TextSpan(
                            text: "Session Link",
                            // Normal text
                            style: Styles.mediumTextStyle(
                                size: 12,
                                color:
                                kBlackColor),
                          ),
                          TextSpan(
                            text: ' *', // Asterisk text
                            style: Styles.mediumTextStyle(
                                size: 12,
                                color:
                                kRedColor),
                          ),
                        ],
                      ),
                      textAlign: TextAlign
                          .start, // Align text to the start
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: buildTextWithBorderField(
                      provider.addressController,
                      "Session Link",
                      MediaQuery.of(context).size.width,
                      50,
                      TextInputType.emailAddress,
                      isEnabled: provider.sameAsAbove == false ? true : false
                  ),
                ),

                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child:  RichText(
                      text: TextSpan(
                        style: Styles.mediumTextStyle(
                          size: 12,
                          color: kBlackColor, // Default text color
                        ),
                        children: [
                          TextSpan(
                            text: "Description",
                            // Normal text
                            style: Styles.mediumTextStyle(
                                size: 12,
                                color:
                                kBlackColor),
                          ),
                          TextSpan(
                            text: ' *', // Asterisk text
                            style: Styles.mediumTextStyle(
                                size: 12,
                                color:
                                kRedColor),
                          ),
                        ],
                      ),
                      textAlign: TextAlign
                          .start, // Align text to the start
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  child: buildTextWithBorderField(
                      provider.addressController,
                      "Description",
                      MediaQuery.of(context).size.width,
                      100,
                      maxLine: 50,
                      TextInputType.emailAddress,
                      isEnabled: provider.sameAsAbove == false ? true : false
                  ),
                ),

                SizedBox(height: SizeConfig.screenHeight! * 0.050),

                SizedBox(

                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {

                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    child: const Text(
                      "Submit",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),

                ),
                SizedBox(height: SizeConfig.screenHeight! * 0.02),

              ],

            ),
          );
        }));



  }

 }
