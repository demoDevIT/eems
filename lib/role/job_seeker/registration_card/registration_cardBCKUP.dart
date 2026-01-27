import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/basicdetails/provider/basic_details_provider.dart';
import 'package:rajemployment/role/job_seeker/registration_card/provider/registration_card_provider.dart';
import 'package:rajemployment/utils/dot_border.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/user_new.dart';
import '../../../utils/dropdown.dart';
import '../../../utils/global.dart';
import '../../../utils/images.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../loginscreen/provider/locale_provider.dart';

class RegistrationCardScreen extends StatefulWidget {
  const RegistrationCardScreen({super.key});

  @override
  State<RegistrationCardScreen> createState() => _RegistrationCardScreenState();
}

class _RegistrationCardScreenState extends State<RegistrationCardScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<RegistrationCardProvider>(context, listen: false);
      provider.clearData();

    });
  }

  // @override
  // Widget build(BuildContext context) {
  //   final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
  //
  //   return Scaffold(
  //       appBar: commonAppBar2("Download Registration Card", context,
  //           localeProvider.currentLanguage, "", false, "", onTapClick: () {
  //         localeProvider.toggleLocale();
  //       }),
  //       body: Consumer<RegistrationCardProvider>(
  //           builder: (context, provider, child) {
  //         return SingleChildScrollView(
  //           padding: const EdgeInsets.all(16),
  //           child: Container(
  //             color: kWhite,
  //             child: Column(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 Card(
  //             shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           elevation: 5,
  //           child: Stack(
  //             children: [
  //               Container(
  //                 margin: EdgeInsets.all(15),
  //                 width: MediaQuery.of(context).size.width,
  //                 //height: MediaQuery.of(context).size.height / 3,
  //                 decoration: BoxDecoration(
  //                   gradient: backgroundGradient2,
  //                   borderRadius: BorderRadius.circular(20),
  //                   border: Border.all(color: borderColor),
  //                 ),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     Container(
  //                       width: MediaQuery.of(context).size.width,
  //                       height: 80, // child height works now
  //                       decoration: BoxDecoration(
  //                         color: B3362FFColor,
  //                         borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight: Radius.circular(20),),
  //                         border: Border.all(color: borderColor),
  //                       ),
  //                       child: Row(
  //                         children: [
  //                           Stack(
  //                             alignment: Alignment.center,
  //                             clipBehavior: Clip.none,
  //                             children: [
  //
  //                               Padding(
  //                                 padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
  //                                 child: ClipOval(
  //                                   child: Image.asset(
  //                                     Images.logo,
  //                                     width: MediaQuery.of(context).size.width * 0.12,
  //                                     height: MediaQuery.of(context).size.width * 0.12,
  //                                     fit: BoxFit.cover,
  //                                     errorBuilder: (context, error, stackTrace) {
  //                                       return Image.asset(
  //                                         Images.placeholder,
  //                                         width: MediaQuery.of(context).size.width * 0.12,
  //                                         height: MediaQuery.of(context).size.width * 0.12,
  //                                         fit: BoxFit.cover,
  //                                       );
  //                                     },
  //                                   ),
  //                                 ),
  //                               ),
  //                               // ✅ Moved and adjusted this Positioned widget
  //
  //                             ],
  //                           ),
  //                           vSpace(5),
  //                           Column(
  //                             crossAxisAlignment: CrossAxisAlignment.start,
  //                             mainAxisAlignment: MainAxisAlignment.center,
  //                             children: [
  //                               Container(
  //                                 padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
  //                                 width: MediaQuery.of(context).size.width *0.60,
  //                                 child: RichText(
  //                                   text: TextSpan(
  //                                     style: Styles.mediumTextStyle(
  //                                       size: 12,
  //                                       color: kBlackColor, // Default text color
  //                                     ),
  //                                     children: [
  //                                       TextSpan(
  //                                         text:"GOVERNMENT OF RAJASTHAN",
  //                                         // Normal text
  //                                         style: Styles.mediumTextStyle(
  //                                             size: 10,
  //                                             color: kWhite),
  //                                       ),
  //
  //                                     ],
  //                                   ),
  //                                   textAlign: TextAlign
  //                                       .start, // Align text to the start
  //                                 ),
  //                               ),
  //                               Container(
  //                                 padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
  //                                 width: MediaQuery.of(context).size.width *0.60,
  //                                 child: RichText(
  //                                   text: TextSpan(
  //                                     style: Styles.mediumTextStyle(
  //                                       size: 12,
  //                                       color: kBlackColor, // Default text color
  //                                     ),
  //                                     children: [
  //                                       TextSpan(
  //                                         text:"DEPARTMENT OF SKILL, EMPLOYMENT",
  //                                         // Normal text
  //                                         style: Styles.mediumTextStyle(
  //                                             size: 10,
  //                                             color: kWhite),
  //                                       ),
  //
  //                                     ],
  //                                   ),
  //                                   textAlign: TextAlign
  //                                       .start, // Align text to the start
  //                                 ),
  //                               ),
  //                               Container(
  //                                 padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
  //                                 width: MediaQuery.of(context).size.width *0.60,
  //                                 child: RichText(
  //                                   text: TextSpan(
  //                                     style: Styles.mediumTextStyle(
  //                                       size: 12,
  //                                       color: kBlackColor, // Default text color
  //                                     ),
  //                                     children: [
  //                                       TextSpan(
  //                                         text:"AND ENTREPRENEURSHIP",
  //                                         // Normal text
  //                                         style: Styles.mediumTextStyle(
  //                                             size: 10,
  //                                             color: kWhite),
  //                                       ),
  //
  //                                     ],
  //                                   ),
  //                                   textAlign: TextAlign
  //                                       .start, // Align text to the start
  //                                 ),
  //                               ),
  //                               Container(
  //                                 padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
  //                                 width: MediaQuery.of(context).size.width *0.60,
  //                                 child: RichText(
  //                                   text: TextSpan(
  //                                     style: Styles.mediumTextStyle(
  //                                       size: 12,
  //                                       color: kBlackColor, // Default text color
  //                                     ),
  //                                     children: [
  //                                       TextSpan(
  //                                         text:"(Employment Wing)",
  //                                         // Normal text
  //                                         style: Styles.mediumTextStyle(
  //                                             size: 10,
  //                                             color: kWhite),
  //                                       ),
  //
  //                                     ],
  //                                   ),
  //                                   textAlign: TextAlign
  //                                       .start, // Align text to the start
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                     Row(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Stack(
  //                           alignment: Alignment.center,
  //                           clipBehavior: Clip.none,
  //                           children: [
  //
  //                             Padding(
  //                               padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
  //                               child: ClipOval(
  //                                 child: Image.network(
  //                                   UserData().model.value.latestPhotoPath.toString(),
  //                                   width: MediaQuery.of(context).size.width * 0.15,
  //                                   height: MediaQuery.of(context).size.width * 0.15,
  //                                   fit: BoxFit.cover,
  //                                   errorBuilder: (context, error, stackTrace) {
  //                                     return Image.asset(
  //                                       Images.placeholder,
  //                                       width: MediaQuery.of(context).size.width * 0.15,
  //                                       height: MediaQuery.of(context).size.width * 0.15,
  //                                       fit: BoxFit.cover,
  //                                     );
  //                                   },
  //                                 ),
  //                               ),
  //                             ),
  //                             // ✅ Moved and adjusted this Positioned widget
  //
  //                           ],
  //                         ),
  //                         vSpace(5),
  //                         Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           children: [
  //                             hSpace(10),
  //                             Row(
  //                               crossAxisAlignment:
  //                               CrossAxisAlignment.start,
  //                               mainAxisAlignment:
  //                               MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Container(
  //                                   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                                   width: MediaQuery.of(context).size.width * 0.20,
  //                                   child: RichText(
  //                                     text: TextSpan(
  //                                       style: Styles.mediumTextStyle(
  //                                         size: 12,
  //                                         color: kBlackColor, // Default text color
  //                                       ),
  //                                       children: [
  //                                         TextSpan(
  //                                           text:"Name",
  //                                           // Normal text
  //                                           style: Styles.mediumTextStyle(
  //                                               size: 10,
  //                                               color: kbuttonColor),
  //                                         ),
  //                                         TextSpan(
  //                                           text: ' :',
  //                                           // Asterisk text
  //                                           style: Styles
  //                                               .mediumTextStyle(
  //                                               size: 10,
  //                                               color: kbuttonColor),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     textAlign: TextAlign
  //                                         .start, // Align text to the start
  //                                   ),
  //                                 ),
  //                                 Container(
  //                                   alignment:
  //                                   Alignment.centerRight,
  //                                   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                                   width: MediaQuery.of(context).size.width * 0.40,
  //                                   child: RichText(
  //                                       text: TextSpan(
  //                                         style: Styles.mediumTextStyle(
  //                                           size: 10,
  //                                           color: kbuttonColor, // Default text color
  //                                         ),
  //                                         children: [
  //                                           TextSpan(
  //                                             text: UserData().model.value.nAMEENG.toString(),
  //                                             style: Styles.regularTextStyle(
  //                                                 size: 10,
  //                                                 color: kbuttonColor),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       textAlign: TextAlign
  //                                           .end // Align text to the start
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             Row(
  //                               crossAxisAlignment:
  //                               CrossAxisAlignment.start,
  //                               mainAxisAlignment:
  //                               MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Container(
  //                                   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                                   width: MediaQuery.of(context).size.width * 0.30,
  //                                   child: RichText(
  //                                     text: TextSpan(
  //                                       style: Styles.mediumTextStyle(
  //                                         size: 12,
  //                                         color: kBlackColor, // Default text color
  //                                       ),
  //                                       children: [
  //                                         TextSpan(
  //                                           text:"Father Name",
  //                                           // Normal text
  //                                           style: Styles.mediumTextStyle(
  //                                               size: 10,
  //                                               color: kbuttonColor),
  //                                         ),
  //                                         TextSpan(
  //                                           text: ' :',
  //                                           // Asterisk text
  //                                           style: Styles
  //                                               .mediumTextStyle(
  //                                               size: 10,
  //                                               color: kbuttonColor),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     textAlign: TextAlign
  //                                         .start, // Align text to the start
  //                                   ),
  //                                 ),
  //                                 Container(
  //                                   alignment:
  //                                   Alignment.centerRight,
  //                                   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                                   width: MediaQuery.of(context).size.width * 0.30,
  //                                   child: RichText(
  //                                       text: TextSpan(
  //                                         style: Styles.mediumTextStyle(
  //                                           size: 12,
  //                                           color: kbuttonColor, // Default text color
  //                                         ),
  //                                         children: [
  //                                           TextSpan(
  //                                             text: UserData().model.value.fATHERNAMEENG.toString(),
  //                                             style: Styles.regularTextStyle(
  //                                                 size: 10,
  //                                                 color: kbuttonColor),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       textAlign: TextAlign
  //                                           .end // Align text to the start
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             Row(
  //                               crossAxisAlignment:
  //                               CrossAxisAlignment.start,
  //                               mainAxisAlignment:
  //                               MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Container(
  //                                   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                                   width: MediaQuery.of(context).size.width * 0.20,
  //                                   child: RichText(
  //                                     text: TextSpan(
  //                                       style: Styles.mediumTextStyle(
  //                                         size: 12,
  //                                         color: kBlackColor, // Default text color
  //                                       ),
  //                                       children: [
  //                                         TextSpan(
  //                                           text:"DOB ",
  //                                           // Normal text
  //                                           style: Styles.mediumTextStyle(
  //                                               size: 10,
  //                                               color: kbuttonColor),
  //                                         ),
  //                                         TextSpan(
  //                                           text: ' :',
  //                                           // Asterisk text
  //                                           style: Styles
  //                                               .mediumTextStyle(
  //                                               size: 10,
  //                                               color: kbuttonColor),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     textAlign: TextAlign
  //                                         .start, // Align text to the start
  //                                   ),
  //                                 ),
  //                                 Container(
  //                                   alignment:
  //                                   Alignment.centerRight,
  //                                   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                                   width: MediaQuery.of(context).size.width * 0.40,
  //                                   child: RichText(
  //                                       text: TextSpan(
  //                                         style: Styles.mediumTextStyle(
  //                                           size: 10,
  //                                           color: kbuttonColor, // Default text color
  //                                         ),
  //                                         children: [
  //                                           TextSpan(
  //                                             text: UserData().model.value.dOB.toString(),
  //                                             style: Styles.regularTextStyle(
  //                                                 size: 10,
  //                                                 color: kbuttonColor),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       textAlign: TextAlign
  //                                           .end // Align text to the start
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             Row(
  //                               crossAxisAlignment:
  //                               CrossAxisAlignment.start,
  //                               mainAxisAlignment:
  //                               MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Container(
  //                                   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                                   width: MediaQuery.of(context).size.width * 0.20,
  //                                   child: RichText(
  //                                     text: TextSpan(
  //                                       style: Styles.mediumTextStyle(
  //                                         size: 12,
  //                                         color: kBlackColor, // Default text color
  //                                       ),
  //                                       children: [
  //                                         TextSpan(
  //                                           text:"Gender",
  //                                           // Normal text
  //                                           style: Styles.mediumTextStyle(
  //                                               size: 10,
  //                                               color: kbuttonColor),
  //                                         ),
  //                                         TextSpan(
  //                                           text: ' :',
  //                                           // Asterisk text
  //                                           style: Styles
  //                                               .mediumTextStyle(
  //                                               size: 10,
  //                                               color: kbuttonColor),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     textAlign: TextAlign
  //                                         .start, // Align text to the start
  //                                   ),
  //                                 ),
  //                                 Container(
  //                                   alignment:
  //                                   Alignment.centerRight,
  //                                   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                                   width: MediaQuery.of(context).size.width * 0.40,
  //                                   child: RichText(
  //                                       text: TextSpan(
  //                                         style: Styles.mediumTextStyle(
  //                                           size: 10,
  //                                           color: kbuttonColor, // Default text color
  //                                         ),
  //                                         children: [
  //                                           TextSpan(
  //                                             text: UserData().model.value.gENDER.toString(),
  //                                             style: Styles.regularTextStyle(
  //                                                 size: 10,
  //                                                 color: kbuttonColor),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       textAlign: TextAlign
  //                                           .end // Align text to the start
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             Row(
  //                               crossAxisAlignment:
  //                               CrossAxisAlignment.start,
  //                               mainAxisAlignment:
  //                               MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Container(
  //                                   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                                   width: MediaQuery.of(context).size.width * 0.30,
  //                                   child: RichText(
  //                                     text: TextSpan(
  //                                       style: Styles.mediumTextStyle(
  //                                         size: 12,
  //                                         color: kBlackColor, // Default text color
  //                                       ),
  //                                       children: [
  //                                         TextSpan(
  //                                           text:"Exchange Name",
  //                                           // Normal text
  //                                           style: Styles.mediumTextStyle(
  //                                               size: 10,
  //                                               color: kbuttonColor),
  //                                         ),
  //                                         TextSpan(
  //                                           text: ' :',
  //                                           // Asterisk text
  //                                           style: Styles
  //                                               .mediumTextStyle(
  //                                               size: 10,
  //                                               color: kbuttonColor),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     textAlign: TextAlign
  //                                         .start, // Align text to the start
  //                                   ),
  //                                 ),
  //                                 Container(
  //                                   alignment:
  //                                   Alignment.centerRight,
  //                                   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                                   width: MediaQuery.of(context).size.width * 0.30,
  //                                   child: RichText(
  //                                       text: TextSpan(
  //                                         style: Styles.mediumTextStyle(
  //                                           size: 10,
  //                                           color: kbuttonColor, // Default text color
  //                                         ),
  //                                         children: [
  //                                           TextSpan(
  //                                             text:"",
  //                                             style: Styles.regularTextStyle(
  //                                                 size: 10,
  //                                                 color: kbuttonColor),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       textAlign: TextAlign
  //                                           .end // Align text to the start
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             Row(
  //                               crossAxisAlignment:
  //                               CrossAxisAlignment.start,
  //                               mainAxisAlignment:
  //                               MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Container(
  //                                   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                                   width: MediaQuery.of(context).size.width * 0.35,
  //                                   child: RichText(
  //                                     text: TextSpan(
  //                                       style: Styles.mediumTextStyle(
  //                                         size: 12,
  //                                         color: kBlackColor, // Default text color
  //                                       ),
  //                                       children: [
  //                                         TextSpan(
  //                                           text:"Highest Qualification",
  //                                           // Normal text
  //                                           style:Styles.mediumTextStyle(
  //                                               size: 10,
  //                                               color: kbuttonColor),
  //                                         ),
  //                                         TextSpan(
  //                                           text: ' :',
  //                                           // Asterisk text
  //                                           style:Styles
  //                                               .mediumTextStyle(
  //                                               size: 10,
  //                                               color: kbuttonColor),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     textAlign: TextAlign
  //                                         .start, // Align text to the start
  //                                   ),
  //                                 ),
  //                                 Container(
  //                                   alignment:
  //                                   Alignment.centerRight,
  //                                   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                                   width: MediaQuery.of(context).size.width * 0.25,
  //                                   child: RichText(
  //                                       text: TextSpan(
  //                                         style: Styles.mediumTextStyle(
  //                                           size: 10,
  //                                           color: kbuttonColor, // Default text color
  //                                         ),
  //                                         children: [
  //                                           TextSpan(
  //                                             text: "",
  //                                             style: Styles.regularTextStyle(
  //                                                 size: 10,
  //                                                 color: kbuttonColor),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       textAlign: TextAlign.end // Align text to the start
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //                             Row(
  //                               crossAxisAlignment:
  //                               CrossAxisAlignment.start,
  //                               mainAxisAlignment:
  //                               MainAxisAlignment.spaceBetween,
  //                               children: [
  //                                 Container(
  //                                   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                                   width: MediaQuery.of(context).size.width * 0.35,
  //                                   child: RichText(
  //                                     text: TextSpan(
  //                                       style: Styles.mediumTextStyle(
  //                                         size: 12,
  //                                         color: kBlackColor, // Default text color
  //                                       ),
  //                                       children: [
  //                                         TextSpan(
  //                                           text:"NCO Code",
  //                                           // Normal text
  //                                           style: Styles.mediumTextStyle(
  //                                               size: 10,
  //                                               color: kbuttonColor),
  //                                         ),
  //                                         TextSpan(
  //                                           text: ' :',
  //                                           // Asterisk text
  //                                           style: Styles
  //                                               .mediumTextStyle(
  //                                               size: 10,
  //                                               color: kbuttonColor),
  //                                         ),
  //                                       ],
  //                                     ),
  //                                     textAlign: TextAlign
  //                                         .start, // Align text to the start
  //                                   ),
  //                                 ),
  //                                 Container(
  //                                   alignment:
  //                                   Alignment.centerRight,
  //                                   padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                                   width: MediaQuery.of(context).size.width * 0.25,
  //                                   child: RichText(
  //                                       text: TextSpan(
  //                                         style: Styles.mediumTextStyle(
  //                                           size: 10,
  //                                           color: kbuttonColor, // Default text color
  //                                         ),
  //                                         children: [
  //                                           TextSpan(
  //                                             text:UserData().model.value.nCOCode.toString(),
  //                                             style: Styles.regularTextStyle(
  //                                                 size: 10,
  //                                                 color: kbuttonColor),
  //                                           ),
  //                                         ],
  //                                       ),
  //                                       textAlign: TextAlign
  //                                           .end // Align text to the start
  //                                   ),
  //                                 ),
  //                               ],
  //                             ),
  //
  //                             hSpace(10),
  //                           ],
  //                         ),
  //                       ],
  //                     ),
  //                     hSpace(15),
  //                     Divider(color: grayLightColor,height: 3,),
  //                     hSpace(15),
  //                     Container(
  //                       alignment: Alignment.center,
  //                       padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                       width: MediaQuery.of(context).size.width,
  //                       child: RichText(
  //                         text: TextSpan(
  //                           style: Styles.mediumTextStyle(
  //                             size: 12,
  //                             color: kBlackColor, // Default text color
  //                           ),
  //                           children: [
  //                             TextSpan(
  //                               text:"Reg. No",
  //                               // Normal text
  //                               style: Styles.mediumTextStyle(
  //                                   size: 14,
  //                                   color: kbuttonColor),
  //                             ),
  //                             TextSpan(
  //                               text: ' : ',
  //                               // Asterisk text
  //                               style: Styles
  //                                   .mediumTextStyle(
  //                                   size: 10,
  //                                   color: kbuttonColor),
  //                             ),
  //                             TextSpan(
  //                               text:UserData().model.value.registrationNumber,
  //                               // Normal text
  //                               style: Styles.mediumTextStyle(
  //                                   size: 14,
  //                                   color: kbuttonColor),
  //                             ),
  //                           ],
  //                         ),
  //                         textAlign: TextAlign
  //                             .start, // Align text to the start
  //                       ),
  //                     ),
  //
  //                   ],
  //                 ),
  //               ),
  //               Positioned.fill(
  //                 child: Opacity(
  //                   opacity: 0.15,   // Adjust transparency
  //                   child: Center(
  //                     child: Image.asset(
  //                       Images.logo,
  //                       width: 100,   // adjust size
  //                       height: 100,
  //                       fit: BoxFit.contain,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //
  //               // --------------------------------------------------
  //             ],
  //           ),
  //         ),
  //
  //                 Card(
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(20),
  //                   ),
  //                   elevation: 5,
  //                   child: Stack(
  //                     children: [
  //
  //                       Container(
  //                         margin: EdgeInsets.all(15),
  //                         width: MediaQuery.of(context).size.width,
  //                         //height: MediaQuery.of(context).size.height / 3,
  //                         decoration: BoxDecoration(
  //                           color: kWhite,
  //                           borderRadius: BorderRadius.circular(20),
  //                           border: Border.all(color: borderColor),
  //                         ),
  //                         child: Column(
  //                           children: [
  //                             Container(
  //                               width: MediaQuery.of(context).size.width,
  //                               height: 80, // child height works now
  //                               decoration: BoxDecoration(
  //                                 color: B3362FFColor,
  //                                 borderRadius: BorderRadius.only(topLeft:Radius.circular(20),topRight: Radius.circular(20),),
  //                                 border: Border.all(color: borderColor),
  //                               ),
  //                               child: Row(
  //                                 children: [
  //                                   Stack(
  //                                     alignment: Alignment.center,
  //                                     clipBehavior: Clip.none,
  //                                     children: [
  //
  //                                       Padding(
  //                                         padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 10),
  //                                         child: ClipOval(
  //                                           child: Image.asset(
  //                                             Images.logo,
  //                                             width: MediaQuery.of(context).size.width * 0.12,
  //                                             height: MediaQuery.of(context).size.width * 0.12,
  //                                             fit: BoxFit.cover,
  //                                             errorBuilder: (context, error, stackTrace) {
  //                                               return Image.asset(
  //                                                 Images.placeholder,
  //                                                 width: MediaQuery.of(context).size.width * 0.12,
  //                                                 height: MediaQuery.of(context).size.width * 0.12,
  //                                                 fit: BoxFit.cover,
  //                                               );
  //                                             },
  //                                           ),
  //                                         ),
  //                                       ),
  //                                       // ✅ Moved and adjusted this Positioned widget
  //
  //                                     ],
  //                                   ),
  //                                   vSpace(5),
  //                                   Column(
  //                                     crossAxisAlignment: CrossAxisAlignment.start,
  //                                     mainAxisAlignment: MainAxisAlignment.center,
  //                                     children: [
  //                                       Container(
  //                                         padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
  //                                         width: MediaQuery.of(context).size.width *0.60,
  //                                         child: RichText(
  //                                           text: TextSpan(
  //                                             style: Styles.mediumTextStyle(
  //                                               size: 12,
  //                                               color: kBlackColor, // Default text color
  //                                             ),
  //                                             children: [
  //                                               TextSpan(
  //                                                 text:"GOVERNMENT OF RAJASTHAN",
  //                                                 // Normal text
  //                                                 style: Styles.mediumTextStyle(
  //                                                     size: 10,
  //                                                     color: kWhite),
  //                                               ),
  //
  //                                             ],
  //                                           ),
  //                                           textAlign: TextAlign
  //                                               .start, // Align text to the start
  //                                         ),
  //                                       ),
  //                                       Container(
  //                                         padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
  //                                         width: MediaQuery.of(context).size.width *0.60,
  //                                         child: RichText(
  //                                           text: TextSpan(
  //                                             style: Styles.mediumTextStyle(
  //                                               size: 12,
  //                                               color: kBlackColor, // Default text color
  //                                             ),
  //                                             children: [
  //                                               TextSpan(
  //                                                 text:"DEPARTMENT OF SKILL, EMPLOYMENT",
  //                                                 // Normal text
  //                                                 style: Styles.mediumTextStyle(
  //                                                     size: 10,
  //                                                     color: kWhite),
  //                                               ),
  //
  //                                             ],
  //                                           ),
  //                                           textAlign: TextAlign
  //                                               .start, // Align text to the start
  //                                         ),
  //                                       ),
  //                                       Container(
  //                                         padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
  //                                         width: MediaQuery.of(context).size.width *0.60,
  //                                         child: RichText(
  //                                           text: TextSpan(
  //                                             style: Styles.mediumTextStyle(
  //                                               size: 12,
  //                                               color: kBlackColor, // Default text color
  //                                             ),
  //                                             children: [
  //                                               TextSpan(
  //                                                 text:"AND ENTREPRENEURSHIP",
  //                                                 // Normal text
  //                                                 style: Styles.mediumTextStyle(
  //                                                     size: 10,
  //                                                     color: kWhite),
  //                                               ),
  //
  //                                             ],
  //                                           ),
  //                                           textAlign: TextAlign
  //                                               .start, // Align text to the start
  //                                         ),
  //                                       ),
  //                                       Container(
  //                                         padding: EdgeInsets.symmetric(horizontal: 5, vertical: 1),
  //                                         width: MediaQuery.of(context).size.width *0.60,
  //                                         child: RichText(
  //                                           text: TextSpan(
  //                                             style: Styles.mediumTextStyle(
  //                                               size: 12,
  //                                               color: kBlackColor, // Default text color
  //                                             ),
  //                                             children: [
  //                                               TextSpan(
  //                                                 text:"(Employment Wing)",
  //                                                 // Normal text
  //                                                 style: Styles.mediumTextStyle(
  //                                                     size: 10,
  //                                                     color: kWhite),
  //                                               ),
  //
  //                                             ],
  //                                           ),
  //                                           textAlign: TextAlign
  //                                               .start, // Align text to the start
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             Padding(
  //                               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //                               child: Row(
  //                                 crossAxisAlignment: CrossAxisAlignment.start,
  //
  //                                 children: [
  //                                 Expanded(
  //                                 flex: 6,
  //                                   child: Column(
  //                                     crossAxisAlignment: CrossAxisAlignment.start,
  //                                     //mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                                     children: [
  //                                       hSpace(10),
  //
  //                                       Row(
  //                                         crossAxisAlignment:
  //                                         CrossAxisAlignment.start,
  //                                         mainAxisAlignment:
  //                                         MainAxisAlignment.spaceBetween,
  //                                         children: [
  //                                           Container(
  //                                             padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                                             width: MediaQuery.of(context).size.width * 0.50,
  //                                             child: RichText(
  //                                               text: TextSpan(
  //                                                 style: Styles.mediumTextStyle(
  //                                                   size: 16,
  //                                                   color: kBlackColor, // Default text color
  //                                                 ),
  //                                                 children: [
  //                                                   TextSpan(
  //                                                     text:"Permanent Address",
  //                                                     // Normal text
  //                                                     style: Styles.mediumTextStyle(
  //                                                         size: 16,
  //                                                         color: kbuttonColor),
  //                                                   ),
  //                                                   TextSpan(
  //                                                     text: ' :',
  //                                                     // Asterisk text
  //                                                     style: Styles
  //                                                         .mediumTextStyle(
  //                                                         size: 16,
  //                                                         color: kbuttonColor),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                               textAlign: TextAlign
  //                                                   .start, // Align text to the start
  //                                             ),
  //                                           ),
  //
  //                                         ],
  //                                       ),
  //                                       Row(
  //                                         crossAxisAlignment:
  //                                         CrossAxisAlignment.start,
  //                                         mainAxisAlignment:
  //                                         MainAxisAlignment.spaceBetween,
  //                                         children: [
  //                                           Container(
  //                                             padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                                             width: MediaQuery.of(context).size.width * 0.50,
  //                                             child: RichText(
  //                                               text: TextSpan(
  //                                                 style: Styles.mediumTextStyle(
  //                                                   size: 12,
  //                                                   color: kBlackColor, // Default text color
  //                                                 ),
  //                                                 children: [
  //                                                   TextSpan(
  //                                                     text:"",
  //                                                     // Normal text
  //                                                     style: Styles.mediumTextStyle(
  //                                                         size: 10,
  //                                                         color: kbuttonColor),
  //                                                   ),
  //
  //                                                 ],
  //                                               ),
  //                                               textAlign: TextAlign
  //                                                   .start, // Align text to the start
  //                                             ),
  //                                           ),
  //
  //                                         ],
  //                                       ),
  //                                       hSpace(60),
  //                                       Row(
  //                                         crossAxisAlignment:
  //                                         CrossAxisAlignment.center,
  //                                         mainAxisAlignment:
  //                                         MainAxisAlignment.spaceBetween,
  //                                         children: [
  //                                           SvgPicture.asset(
  //                                             Images.arrow_flying,
  //                                             width: 15,
  //                                             height: 15,
  //                                           ),
  //                                           Container(
  //                                             padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
  //                                             width: MediaQuery.of(context).size.width * 0.50,
  //                                             child: RichText(
  //                                               text: TextSpan(
  //                                                 style: Styles.mediumTextStyle(
  //                                                   size: 10,
  //                                                   color: kBlackColor, // Default text color
  //                                                 ),
  //                                                 children: [
  //                                                   TextSpan(
  //                                                     text:"employment.livelihoods.rajasthan.gov.in",
  //                                                     // Normal text
  //                                                     style:Styles.mediumTextStyle(
  //                                                         size: 10,
  //                                                         color: kbuttonColor),
  //                                                   ),
  //                                                   TextSpan(
  //                                                     text: ' :',
  //                                                     // Asterisk text
  //                                                     style:Styles.mediumTextStyle(
  //                                                         size: 10,
  //                                                         color: kbuttonColor),
  //                                                   ),
  //                                                 ],
  //                                               ),
  //                                               textAlign: TextAlign
  //                                                   .start, // Align text to the start
  //                                             ),
  //                                           ),
  //
  //                                         ],
  //                                       ),
  //                                       hSpace(15),
  //
  //
  //                                     ],
  //                                   ),
  //                                 ),
  //                                   vSpace(5),
  //                                   Stack(
  //                                     alignment: Alignment.center,
  //                                     clipBehavior: Clip.none,
  //                                     children: [
  //
  //                                       Padding(
  //                                         padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 10),
  //                                         child: Image.asset(
  //                                           Images.qr_code,
  //                                           width: MediaQuery.of(context).size.width * 0.25,
  //                                           height: MediaQuery.of(context).size.width * 0.25,
  //                                           fit: BoxFit.cover,
  //                                           errorBuilder: (context, error, stackTrace) {
  //                                             return Image.asset(
  //                                               Images.placeholder,
  //                                               width: MediaQuery.of(context).size.width * 0.25,
  //                                               height: MediaQuery.of(context).size.width * 0.25,
  //                                               fit: BoxFit.cover,
  //                                             );
  //                                           },
  //                                         ),
  //                                       ),
  //                                       // ✅ Moved and adjusted this Positioned widget
  //
  //                                     ],
  //                                   ),
  //                                 ],
  //                               ),
  //                             ),
  //                             hSpace(15),
  //                             Divider(color: grayLightColor,height: 3,),
  //                             hSpace(15),
  //                             Container(
  //                               alignment: Alignment.center,
  //                               padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
  //                               width: MediaQuery.of(context).size.width * 0.90,
  //                               child: RichText(
  //                                 text: TextSpan(
  //                                   style: Styles.mediumTextStyle(
  //                                     size: 12,
  //                                     color: kBlackColor, // Default text color
  //                                   ),
  //                                   children: [
  //                                     TextSpan(
  //                                       text:"Registration Date",
  //                                       // Normal text
  //                                       style: Styles.mediumTextStyle(
  //                                           size: 14,
  //                                           color: kBlackColor),
  //                                     ),
  //                                     TextSpan(
  //                                       text: ' : ',
  //                                       // Asterisk text
  //                                       style: Styles
  //                                           .mediumTextStyle(
  //                                           size: 10,
  //                                           color: kBlackColor),
  //                                     ),
  //                                     TextSpan(
  //                                       text:UserData().model.value.registrationDate,
  //                                       // Normal text
  //                                       style: Styles.mediumTextStyle(
  //                                           size: 14,
  //                                           color: kBlackColor),
  //                                     ),
  //                                   ],
  //                                 ),
  //                                 textAlign: TextAlign
  //                                     .start, // Align text to the start
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                       Positioned.fill(
  //                         child: Opacity(
  //                           opacity: 0.15,   // Adjust transparency
  //                           child: Center(
  //                             child: Image.asset(
  //                               Images.logo,
  //                               width: 100,   // adjust size
  //                               height: 100,
  //                               //fit: BoxFit.contain,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //
  //
  //                     ],
  //                   ),
  //                 ),
  //                 const SizedBox(height: 30),
  //
  //                 Padding(
  //                   padding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 10),
  //                   child: SizedBox(
  //                     width: MediaQuery.of(context).size.width,
  //                     height: 50,
  //                     child: ElevatedButton(
  //                       onPressed: () {
  //                         confirmAlertDialog(context, "Alert","Are you sure want to Download ?", (value) {
  //                           if (value.toString() == "success") {
  //                             provider.pdfDownloadApi(context);
  //                            }
  //                         },
  //                         );
  //                       },
  //                       style: ElevatedButton.styleFrom(
  //                         backgroundColor: kPrimaryColor,
  //                         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
  //                       ),
  //                       child:  Text('Download Card', style: TextStyle(fontSize: 16, color: Colors.white)),
  //                     ),
  //                   ),
  //                 ),
  //
  //
  //
  //                ],
  //             ),
  //           ),
  //         );
  //       }));
  // }

@override
Widget build(BuildContext context) {
  final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

  return Scaffold(
      appBar: commonAppBar2("Download Registration Card", context,
          localeProvider.currentLanguage, "", false, "", onTapClick: () {
        localeProvider.toggleLocale();
      }),
      body: Consumer<RegistrationCardProvider>(
          builder: (context, provider, child) {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            color: kWhite,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                registrationFullCard(context),
                const SizedBox(height: 20),
              //  addressCard(context),
              //   const SizedBox(height: 30),

                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 10),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        confirmAlertDialog(context, "Alert","Are you sure want to Download ?", (value) {
                          if (value.toString() == "success") {
                            provider.pdfDownloadApi(context);
                           }
                        },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: kPrimaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                      ),
                      child:  Text('Download Card', style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),
                ),



               ],
            ),
          ),
        );
      }));
}

  Widget registrationFullCard(BuildContext context) {
    final data = UserData().model.value;

    const headerBlue = Color(0xFF0D2F57);
    const labelBlue = Color(0xFF1C86C8);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SizedBox(
        width: 900, // fixed wide card like screenshot
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          elevation: 6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ================= HEADER =================
              Container(
                padding: const EdgeInsets.symmetric(vertical: 18),
                decoration: const BoxDecoration(
                  color: headerBlue,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(18)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(Images.logo, height: 50),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          "Government of Rajasthan",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Text(
                          "Department of Skill, Employment and Entrepreneurship",
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                        Text(
                          "(Employment Wing)",
                          style: TextStyle(color: Colors.white70, fontSize: 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ================= TITLE =================
              const Center(
                child: Text(
                  "Job Seeker Registration Card",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              // ================= REG NO =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        "Reg no:- ${data.registrationNumber}",
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "Registration date:- ${data.registrationDate}",
                        textAlign: TextAlign.end,
                        style: const TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),

              const Divider(height: 28),

              // ================= DETAILS =================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    // Photo
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        data.latestPhotoPath.toString(),
                        height: 110,
                        width: 110,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) =>
                            Image.asset(Images.placeholder, height: 110, width: 110),
                      ),
                    ),

                    const SizedBox(width: 20),

                    // Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          infoRow("Name", data.nAMEENG!, "Caste", "Hindu", labelBlue),
                          infoRow("Father Name", data.fATHERNAMEENG!, "Disability", "Test", labelBlue),
                          infoRow("DOB", data.dOB!, "Gender", data.gENDER!, labelBlue),
                          infoRow("Exchange Name", "Test", "", "", labelBlue),
                          singleInfo("Highest Qualification", "Test", labelBlue),
                        ],
                      ),
                    ),

                    // QR
                    Image.asset(Images.qr_code, height: 110, width: 110),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "NCO Code: ${data.nCOCode}",
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: labelBlue,
                  ),
                ),
              ),

              const SizedBox(height: 24),
              const Divider(),

              // ================= ADDRESS =================
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: addressBlock(
                        "Permanent Address",
                        "Ground & 3rd Floor, SMTOWER, 12, Ajmer Rd,\n"
                            "Teachers Colony, DCM, Jaipur, Rajasthan\n302021",
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: addressBlock(
                        "Communication Address",
                        "Ground & 3rd Floor, SMTOWER, 12, Ajmer Rd,\n"
                            "Teachers Colony, DCM, Jaipur, Rajasthan\n302021",
                      ),
                    ),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: Row(
                  children: const [
                    Icon(Icons.telegram, size: 16),
                    SizedBox(width: 6),
                    Text(
                      "employment.livelihoods.rajasthan.gov.in",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //
  // Widget twoCol(String l1, String v1, String l2, String v2) {
  //   return Padding(
  //     padding: const EdgeInsets.only(bottom: 4),
  //     child: Row(
  //       children: [
  //         Expanded(child: labelValue(l1, v1)),
  //         if (l2.isNotEmpty) Expanded(child: labelValue(l2, v2)),
  //       ],
  //     ),
  //   );
  // }
  //
  // Widget labelOnly(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.only(top: 4),
  //     child: labelValue(label, value),
  //   );
  // }

  // Widget labelValue(String label, String value) {
  //   const Color labelBlue = Color(0xFF1E88E5);
  //   return RichText(
  //     text: TextSpan(
  //       style: const TextStyle(fontSize: 12),
  //       children: [
  //         TextSpan(
  //           text: "$label: ",
  //           style: const TextStyle(
  //               color: labelBlue, fontWeight: FontWeight.w600),
  //         ),
  //         TextSpan(
  //           text: value,
  //           style: const TextStyle(color: Colors.black),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget infoRow(String l1, String v1, String l2, String v2, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Expanded(child: labelValue(l1, v1, color)),
          if (l2.isNotEmpty) Expanded(child: labelValue(l2, v2, color)),
        ],
      ),
    );
  }

  Widget singleInfo(String label, String value, Color color) {
    return labelValue(label, value, color);
  }

  Widget labelValue(String label, String value, Color color) {
    return RichText(
      text: TextSpan(
        style: TextStyle(fontSize: 13, color: color),
        children: [
          TextSpan(
            text: "$label: ",
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          TextSpan(text: value),
        ],
      ),
    );
  }


  Widget info(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 12, color: Colors.black),
          children: [
            TextSpan(
                text: "$title: ",
                style: const TextStyle(fontWeight: FontWeight.w600)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
  }


  Widget addressCard(BuildContext context) {
    final data = UserData().model.value;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 6,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF0B2E59),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(Images.logo, height: 40),
                  const SizedBox(width: 10),
                  const Text(
                    "Government of Rajasthan\n(Employment Wing)",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: addressBlock(
                      "Permanent Address",
                      "" ?? ""),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: addressBlock(
                      "Communication Address",
                      "" ?? ""),
                ),
              ],
            ),

            const SizedBox(height: 14),

            Row(
              children: [
                const Icon(Icons.telegram, size: 16),
                const SizedBox(width: 6),
                const Text(
                  "employment.livelihoods.rajasthan.gov.in",
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget addressBlock(String title, String address) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        Text(address, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

}
