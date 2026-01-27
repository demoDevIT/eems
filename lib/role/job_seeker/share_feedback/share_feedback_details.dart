import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/job_details/provider/job_details_provider.dart';
import 'package:rajemployment/role/job_seeker/jobpreference/provider/job_preference_provider.dart';
import 'package:rajemployment/role/job_seeker/jobs/provider/jobs_list_provider.dart';
import 'package:rajemployment/role/job_seeker/share_feedback/provider/share_feedback_details_provider.dart';
import 'package:rajemployment/utils/dot_border.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/images.dart';

import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../addjobpreference/add_job_preference.dart';

class ShareFeedbackDetailsScreen extends StatefulWidget {
   ShareFeedbackDetailsScreen({super.key});

  @override
  State<ShareFeedbackDetailsScreen> createState() => _ShareFeedbackDetailsScreenState();
}

class _ShareFeedbackDetailsScreenState extends State<ShareFeedbackDetailsScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            "Share Feedback",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
       body: Consumer<ShareFeedbackDetailsProvider>(builder: (context, provider, child) {
            return   Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child:SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                      decoration: BoxDecoration(
                        color: purpal455CDCColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * 0.86 / 2,
                            child:  Text("State Level Job Fair",
                              style: Styles.semiBoldTextStyle(size: 14,color: kWhite)),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width * 0.86 / 2,
                            child:  Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("Sitapura, Jaipur, Rajasthan 302022",
                                    style: Styles.regularTextStyle(size: 10,color: kWhite)),
                                Text("11:02 AM 2-8-2025",
                                    style: Styles.regularTextStyle(size: 10,color: kWhite)),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                    hSpace(20),

                    Text("We love to hear from you! How’s\nyour experience with us",
                          textAlign: TextAlign.center,
                          style: Styles.mediumTextStyle(size: 14,color: fontGrayColor)
                      ),

                    hSpace(20),

                    Container(
                        width:MediaQuery.of(context).size.width,
                        child: Image(image:  AssetImage(Images.job1),width: 60,height: 60,)),
                    hSpace(10),
                    Text("Senior UX Researcher",
                        style: Styles.semiBoldTextStyle(size: 18)
                    ),
                    Text("Jaipur Rajasthan",
                        style: Styles.mediumTextStyle(size: 14,color: fontGrayColor)
                    ),
                    hSpace(20),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('Did the company offer you a job?', style: Styles.semiBoldTextStyle(
                          color: kBlackColor, size: 14)),
                    ),
                    hSpace(10),
                    Row(
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Yes',
                              groupValue:  provider.radio1,
                              onChanged: (val) => setState(() => provider.radio1 = val ?? provider.radio1),
                            ),
                            const SizedBox(width: 4),
                            Text('Yes',style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14),),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'No',
                              groupValue:  provider.radio1,
                              onChanged: (val) => setState(() => provider.radio1 = val ?? provider.radio1),
                            ),
                            const SizedBox(width: 4),
                            Text('No',style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14),),
                          ],
                        ),
                      ],
                    ),
                    hSpace(10),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('Did you receive the job offer letter?', style: Styles.semiBoldTextStyle(
                          color: kBlackColor, size: 14)),
                    ),
                    hSpace(10),
                    Row(
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Yes',
                              groupValue:  provider.radio2,
                              onChanged: (val) => setState(() => provider.radio2 = val ?? provider.radio2),
                            ),
                            const SizedBox(width: 4),
                            Text('Yes',style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14),),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'No',
                              groupValue:  provider.radio2,
                              onChanged: (val) => setState(() => provider.radio2 = val ?? provider.radio2),
                            ),
                            const SizedBox(width: 4),
                            Text('No',style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14),),
                          ],
                        ),


                      ],
                    ),
                    hSpace(10),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('Was your job interview scheduled?', style: Styles.semiBoldTextStyle(
                          color: kBlackColor, size: 14)),
                    ),
                    hSpace(10),
                    Row(
                      children: [
                        Row(
                          children: [
                            Radio<String>(
                              value: 'Yes',
                              groupValue:  provider.radio3,
                              onChanged: (val) => setState(() => provider.radio3 = val ?? provider.radio3),
                            ),
                            const SizedBox(width: 4),
                            Text('Yes',style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14),),
                          ],
                        ),
                        const SizedBox(width: 12),
                        Row(
                          children: [
                            Radio<String>(
                              value: 'No',
                              groupValue:  provider.radio3,
                              onChanged: (val) => setState(() => provider.radio3 = val ?? provider.radio3),
                            ),
                            const SizedBox(width: 4),
                            Text('No',style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14),),
                          ],
                        ),


                      ],
                    ),
                    hSpace(10),

                    Align(
                      alignment: Alignment.topLeft,
                      child: Text('Other remarks', style: Styles.semiBoldTextStyle(
                          color: kBlackColor, size: 14)),
                    ),

                    hSpace(5),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                      child: buildTextWithBorderField(
                        provider.commentController,
                        "Type your remarks here",
                        MediaQuery.of(context).size.width,
                        100,
                        isEnabled: false,
                        maxLine: 50,
                        borderRadius: 5,
                        TextInputType.emailAddress,
                      ),
                    ),

                    hSpace(20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: blue3066CDColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                         // Save logic here
                          // Validate and submit data
                        },
                        child: const Text(
                          "Submit",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kWhite),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }));


  }
}


