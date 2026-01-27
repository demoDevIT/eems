import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/grievance/add_grievance_screen.dart';
import 'package:rajemployment/role/job_seeker/grievance/provider/grievance_list_provider.dart';
import 'package:rajemployment/role/job_seeker/job_details/job_details.dart';
import 'package:rajemployment/role/job_seeker/job_fair_event/provider/job_apply_list_provider.dart' show JobApplyListProvider;
import 'package:rajemployment/role/job_seeker/job_fair_event/provider/registered_event_list_provider.dart';
import 'package:rajemployment/role/job_seeker/jobpreference/provider/job_preference_provider.dart';
import 'package:rajemployment/role/job_seeker/jobs/provider/jobs_list_provider.dart';
import 'package:rajemployment/utils/dot_border.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/images.dart';

import '../../../utils/dropdown.dart';
import '../../../utils/right_to_left_route.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../addjobpreference/add_job_preference.dart';
import '../loginscreen/provider/locale_provider.dart';

class JobApplyListScreen extends StatefulWidget {
   JobApplyListScreen({super.key});

  @override
  State<JobApplyListScreen> createState() => _JobApplyListScreenState();
}

class _JobApplyListScreenState extends State<JobApplyListScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<JobApplyListProvider>(context, listen: false);
      provider.clearData();
      provider.allJobMatchingListApi(context,"48","3");
      provider.getEventNameListApi(context);
      provider.sectorListApi(context);
    });
  }


  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2("Job Apply List", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),


       body: Consumer<JobApplyListProvider>(builder: (context, provider, child) {
            return   Padding(
              padding: const EdgeInsets.all(10),
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  labelWithStar('Event Name',required: false),
                  IgnorePointer(
                    ignoring: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: buildDropdownWithBorderField(
                        items: provider.eventNameList,
                        controller: provider.eventNameController,
                        idController: provider.eventIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {

                        },
                      ),
                    ),
                  ),

                  labelWithStar('Job Sector',required: false),
                  IgnorePointer(
                    ignoring: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: buildDropdownWithBorderField(
                        items: provider.sectorList,
                        controller: provider.sectorNameController,
                        idController: provider.sectorIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {

                        },
                      ),
                    ),
                  ),

                  hSpace(30),

                  Align(
                  alignment: Alignment.center,
                  child: labelWithStar('Search and Apply',required: false,size: 18)),
                  hSpace(10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: provider.jobApplyList.length,
                      itemBuilder: (context, index) {
                        final data = provider.jobApplyList[index];
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
                                              text:"NCO Code",
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
                                                provider.jobApplyList[index].nCOCode.toString(),
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
                                              text:"NCO Name",
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
                                                provider.jobApplyList[index].nCOName.toString() ,
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







                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }));

    //147664


    //pending//62664


  }
}


