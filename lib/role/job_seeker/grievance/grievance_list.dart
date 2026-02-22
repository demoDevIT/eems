import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/grievance/add_grievance_screen.dart';
import 'package:rajemployment/role/job_seeker/grievance/provider/grievance_list_provider.dart';
import 'package:rajemployment/role/job_seeker/job_details/job_details.dart';
import 'package:rajemployment/role/job_seeker/jobpreference/provider/job_preference_provider.dart';
import 'package:rajemployment/role/job_seeker/jobs/provider/jobs_list_provider.dart';
import 'package:rajemployment/utils/dot_border.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/images.dart';

import '../../../utils/right_to_left_route.dart';
import '../../../utils/textstyles.dart';
import '../addjobpreference/add_job_preference.dart';
import '../loginscreen/provider/locale_provider.dart';

class GrievanceScreen extends StatefulWidget {
   GrievanceScreen({super.key});

  @override
  State<GrievanceScreen> createState() => _GrievanceScreenState();
}

class _GrievanceScreenState extends State<GrievanceScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<GrievanceListProvider>(context, listen: false);
      provider.clearData();
      provider.getAllGrievanceApi(context);



    });
  }


  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2("Grievance Assign Form", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),

        floatingActionButton: FloatingActionButton(
          backgroundColor: kButtonColor,
          foregroundColor: Colors.white,
          onPressed: () async {
            final result = await  Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>  AddGrievanceScreen(),
              ),
            );
            if (result != null) {
              final provider = Provider.of<GrievanceListProvider>(context, listen: false);
              provider.getAllGrievanceApi(context);
            }
        },
          child: Icon(Icons.add),
        ),
       body: Consumer<GrievanceListProvider>(builder: (context, provider, child) {
            return   Padding(
              padding: const EdgeInsets.all(10),
              child:  ListView.builder(
                itemCount: provider.grievanceDataList.length,
                itemBuilder: (context, index) {
                  final data = provider.grievanceDataList[index];
                  return InkWell(
                    onTap: () {

                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        gradient: index % 2 == 0 ? kWhitedGradient:jobsCardGradient  ,
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
                                        text:"Complain No.",
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
                                          provider.grievanceDataList[index].complainNo.toString(),
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
                                        text:"Subject",
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
                                          provider.grievanceDataList[index].subject.toString(),
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
                                        text:"Category ",
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
                                          provider.grievanceDataList[index].categoryID.toString(),
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
                                        text:"Category Type",
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
                                          provider.grievanceDataList[index].categoryType.toString(),
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
                                        text:"Module",
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
                                          provider.grievanceDataList[index].moduleNameEn.toString(),
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
                                        text:"Status",
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
                                          provider.grievanceDataList[index].statusID.toString(),
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
                                        text:"Created On",
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
                                          provider.grievanceDataList[index].createdDate.toString(),
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
                          hSpace(10),

                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: kButtonColor,
                                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              ),
                              onPressed: () {
                                provider.getGrievanceTrailApi(
                                  context,
                                  provider.grievanceDataList[index],
                                );
                              },
                              child: Text(
                                "View Trail",
                                style: TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                          ),

                          hSpace(10),

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


