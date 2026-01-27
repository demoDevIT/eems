import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/grievance/add_grievance_screen.dart';
import 'package:rajemployment/role/job_seeker/grievance/provider/grievance_list_provider.dart';
import 'package:rajemployment/role/job_seeker/job_details/job_details.dart';
import 'package:rajemployment/role/job_seeker/job_fair_event/provider/registered_event_list_provider.dart';
import 'package:rajemployment/role/job_seeker/jobpreference/provider/job_preference_provider.dart';
import 'package:rajemployment/role/job_seeker/jobs/provider/jobs_list_provider.dart';
import 'package:rajemployment/utils/dot_border.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/images.dart';

import '../../../utils/right_to_left_route.dart';
import '../../../utils/textstyles.dart';
import '../addjobpreference/add_job_preference.dart';
import '../loginscreen/provider/locale_provider.dart';

class RegisteredEventListScreen extends StatefulWidget {
   RegisteredEventListScreen({super.key});

  @override
  State<RegisteredEventListScreen> createState() => _RegisteredEventListScreenState();
}

class _RegisteredEventListScreenState extends State<RegisteredEventListScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<RegisteredEventListProvider>(context, listen: false);
      provider.clearData();
      provider.allJobMatchingListApi(context);



    });
  }


  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2("Registered Events", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),


       body: Consumer<RegisteredEventListProvider>(builder: (context, provider, child) {
            return   Padding(
              padding: const EdgeInsets.all(10),
              child:  ListView.builder(
                itemCount: provider.registeredEventListList.length,
                itemBuilder: (context, index) {
                  final data = provider.registeredEventListList[index];
                  return InkWell(
                    onTap: () {

                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        gradient: index % 2 == 0 ? kWhitedGradient : jobsCardGradient,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),

                     // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          hSpace(5),
                          Row(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5),
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.40,
                                child: RichText(
                                  text: TextSpan(
                                    style:
                                    Styles.mediumTextStyle(
                                      size: 12,
                                      color: kBlackColor, // Default text color
                                    ),
                                    children: [
                                      TextSpan(
                                        text:"Event Id",
                                        // Normal text
                                        style: Styles
                                            .mediumTextStyle(
                                            size: 12,
                                            color: kBlackColor),
                                      ),
                                      TextSpan(
                                        text: ' :-',
                                        // Asterisk text
                                        style: Styles
                                            .mediumTextStyle(
                                            size: 12,
                                            color: kBlackColor),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign
                                      .start, // Align text to the start
                                ),
                              ),
                              Container(
                                alignment:
                                Alignment.centerRight,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5),
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.45,
                                child: RichText(
                                    text: TextSpan(
                                      style: Styles
                                          .mediumTextStyle(
                                        size: 12,
                                        color: kBlackColor, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                          provider.registeredEventListList[index].eventId.toString(),
                                          style: Styles
                                              .regularTextStyle(
                                              size: 12,
                                              color: kBlackColor),
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
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5),
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.40,
                                child: RichText(
                                  text: TextSpan(
                                    style:
                                    Styles.mediumTextStyle(
                                      size: 12,
                                      color: kBlackColor, // Default text color
                                    ),
                                    children: [
                                      TextSpan(
                                        text:"Event Name",
                                        // Normal text
                                        style: Styles
                                            .mediumTextStyle(
                                            size: 12,
                                            color: kBlackColor),
                                      ),
                                      TextSpan(
                                        text: ' :-',
                                        // Asterisk text
                                        style: Styles
                                            .mediumTextStyle(
                                            size: 12,
                                            color: kBlackColor),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign
                                      .start, // Align text to the start
                                ),
                              ),
                              Container(
                                alignment:
                                Alignment.centerRight,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5),
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.45,
                                child: RichText(
                                    text: TextSpan(
                                      style: Styles
                                          .mediumTextStyle(
                                        size: 12,
                                        color: kBlackColor, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                          localeProvider.currentLanguage == "en" ? provider.registeredEventListList[index].eventNameENG.toString() : provider.registeredEventListList[index].eventNameHI.toString(),
                                          style: Styles
                                              .regularTextStyle(
                                              size: 12,
                                              color: kBlackColor),
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
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5),
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.40,
                                child: RichText(
                                  text: TextSpan(
                                    style:
                                    Styles.mediumTextStyle(
                                      size: 12,
                                      color: kBlackColor, // Default text color
                                    ),
                                    children: [
                                      TextSpan(
                                        text:"Event Description",
                                        // Normal text
                                        style: Styles
                                            .mediumTextStyle(
                                            size: 12,
                                            color: kBlackColor),
                                      ),
                                      TextSpan(
                                        text: ' :-',
                                        // Asterisk text
                                        style: Styles
                                            .mediumTextStyle(
                                            size: 12,
                                            color: kBlackColor),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign
                                      .start, // Align text to the start
                                ),
                              ),
                              Container(
                                alignment:
                                Alignment.centerRight,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5),
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.45,
                                child: RichText(
                                    text: TextSpan(
                                      style: Styles
                                          .mediumTextStyle(
                                        size: 12,
                                        color: kBlackColor, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                          provider.registeredEventListList[index].eventDescription.toString(),
                                          style: Styles
                                              .regularTextStyle(
                                              size: 12,
                                              color: kBlackColor),
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
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5),
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.40,
                                child: RichText(
                                  text: TextSpan(
                                    style:
                                    Styles.mediumTextStyle(
                                      size: 12,
                                      color: kBlackColor, // Default text color
                                    ),
                                    children: [
                                      TextSpan(
                                        text:"Start Date",
                                        // Normal text
                                        style: Styles
                                            .mediumTextStyle(
                                            size: 12,
                                            color: kBlackColor),
                                      ),
                                      TextSpan(
                                        text: ' :-',
                                        // Asterisk text
                                        style: Styles
                                            .mediumTextStyle(
                                            size: 12,
                                            color: kBlackColor),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign
                                      .start, // Align text to the start
                                ),
                              ),
                              Container(
                                alignment:
                                Alignment.centerRight,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5),
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.45,
                                child: RichText(
                                    text: TextSpan(
                                      style: Styles
                                          .mediumTextStyle(
                                        size: 12,
                                        color: kBlackColor, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text:getFormattedDate(provider.registeredEventListList[index].startDate.toString()),
                                          style: Styles
                                              .regularTextStyle(
                                              size: 12,
                                              color: kBlackColor),
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
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5),
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.40,
                                child: RichText(
                                  text: TextSpan(
                                    style:
                                    Styles.mediumTextStyle(
                                      size: 12,
                                      color: kBlackColor, // Default text color
                                    ),
                                    children: [
                                      TextSpan(
                                        text:"End Date",
                                        // Normal text
                                        style: Styles
                                            .mediumTextStyle(
                                            size: 12,
                                            color: kBlackColor),
                                      ),
                                      TextSpan(
                                        text: ' :-',
                                        // Asterisk text
                                        style: Styles
                                            .mediumTextStyle(
                                            size: 12,
                                            color: kBlackColor),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign
                                      .start, // Align text to the start
                                ),
                              ),
                              Container(
                                alignment:
                                Alignment.centerRight,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5),
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.45,
                                child: RichText(
                                    text: TextSpan(
                                      style: Styles
                                          .mediumTextStyle(
                                        size: 12,
                                        color: kBlackColor, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text:getFormattedDate(provider.registeredEventListList[index].endDate.toString()),
                                          style: Styles
                                              .regularTextStyle(
                                              size: 12,
                                              color: kBlackColor),
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
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5),
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.40,
                                child: RichText(
                                  text: TextSpan(
                                    style:
                                    Styles.mediumTextStyle(
                                      size: 12,
                                      color: kBlackColor, // Default text color
                                    ),
                                    children: [
                                      TextSpan(
                                        text:"Level",
                                        // Normal text
                                        style: Styles
                                            .mediumTextStyle(
                                            size: 12,
                                            color: kBlackColor),
                                      ),
                                      TextSpan(
                                        text: ' :-',
                                        // Asterisk text
                                        style: Styles
                                            .mediumTextStyle(
                                            size: 12,
                                            color: kBlackColor),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign
                                      .start, // Align text to the start
                                ),
                              ),
                              Container(
                                alignment:
                                Alignment.centerRight,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5),
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.45,
                                child: RichText(
                                    text: TextSpan(
                                      style: Styles
                                          .mediumTextStyle(
                                        size: 12,
                                        color: kBlackColor, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                          provider.registeredEventListList[index].levelNameEnglish.toString(),
                                          style: Styles
                                              .regularTextStyle(
                                              size: 12,
                                              color: kBlackColor),
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
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5),
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.40,
                                child: RichText(
                                  text: TextSpan(
                                    style:
                                    Styles.mediumTextStyle(
                                      size: 12,
                                      color: kBlackColor, // Default text color
                                    ),
                                    children: [
                                      TextSpan(
                                        text:"Venue",
                                        // Normal text
                                        style: Styles
                                            .mediumTextStyle(
                                            size: 12,
                                            color: kBlackColor),
                                      ),
                                      TextSpan(
                                        text: ' :-',
                                        // Asterisk text
                                        style: Styles
                                            .mediumTextStyle(
                                            size: 12,
                                            color: kBlackColor),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign
                                      .start, // Align text to the start
                                ),
                              ),
                              Container(
                                alignment:
                                Alignment.centerRight,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5),
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.45,
                                child: RichText(
                                    text: TextSpan(
                                      style: Styles
                                          .mediumTextStyle(
                                        size: 12,
                                        color: kBlackColor, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                          provider.registeredEventListList[index].venue.toString(),
                                          style: Styles
                                              .regularTextStyle(
                                              size: 12,
                                              color: kBlackColor),
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
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5),
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.40,
                                child: RichText(
                                  text: TextSpan(
                                    style:
                                    Styles.mediumTextStyle(
                                      size: 12,
                                      color: kBlackColor, // Default text color
                                    ),
                                    children: [
                                      TextSpan(
                                        text:"Get Pass",
                                        // Normal text
                                        style: Styles
                                            .mediumTextStyle(
                                            size: 12,
                                            color: kBlackColor),
                                      ),
                                      TextSpan(
                                        text: ' :-',
                                        // Asterisk text
                                        style: Styles
                                            .mediumTextStyle(
                                            size: 12,
                                            color: kBlackColor),
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign
                                      .start, // Align text to the start
                                ),
                              ),
                              Container(
                                alignment:
                                Alignment.centerRight,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5),
                                width: MediaQuery.of(context)
                                    .size
                                    .width *
                                    0.45,
                                child: Icon(Icons.visibility,color: kbuttonColor,)
                              ),
                            ],
                          ),
                          hSpace(5),
                          Divider(
                            color: dividerColor,
                            height: 2,
                          ),



                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }));

    //147664


    //pending//62664


  }
}


