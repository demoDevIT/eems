import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/job_details/provider/job_details_provider.dart';
import 'package:rajemployment/role/job_seeker/jobpreference/provider/job_preference_provider.dart';
import 'package:rajemployment/role/job_seeker/jobs/provider/jobs_list_provider.dart';
import 'package:rajemployment/utils/dot_border.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/images.dart';

import '../../../utils/textstyles.dart';
import '../addjobpreference/add_job_preference.dart';
import '../loginscreen/provider/locale_provider.dart';

class JobDetailsScreen extends StatefulWidget {
   JobDetailsScreen({super.key});

  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {


  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2("Jobs Details", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),

       body: Consumer<JobDetailsProvider>(builder: (context, provider, child) {
            return   Padding(
              padding: const EdgeInsets.all(16.0),
              child:SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    hSpace(20),
                    Container(
                        width:MediaQuery.of(context).size.width,
                        child: Image(image:  AssetImage(Images.job1),width: 60,height: 60,)),
                    hSpace(10),
                    Text("Senior UX Reseacher",
                        style: Styles.semiBoldTextStyle(size: 18)
                    ),
                    hSpace(5),
                    Text("Information Technology...",
                        style: Styles.mediumTextStyle(size: 14,color: fontGrayColor)
                    ),
                    hSpace(20),
                    Container(
                      height:MediaQuery.of(context).size.width / 4,
                      decoration: BoxDecoration(
                        color: E1E1E1Color.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                
                        children: [
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1.0, // optional, default is 1.0
                                ),
                              ),                          ),
                               width:  MediaQuery.of(context).size.width * 0.75 / 3,
                               height:MediaQuery.of(context).size.width / 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  Images.location,
                                  width: 15,
                                  height: 15,
                                  semanticsLabel: 'Location icon',
                                  fit: BoxFit.contain,
                                ),
                                hSpace(5),
                                Text(
                                    "Location",
                                    style: Styles.mediumTextStyle(size: 12,color: blue3066CDColor)
                                ),
                                hSpace(5),
                                Text(
                                    "Jaipur",
                                    style: Styles.semiBoldTextStyle(size: 12,color: kBlackColor)
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1.0, // optional, default is 1.0
                                ),
                              ),                          ),
                            width:  MediaQuery.of(context).size.width * 0.75 / 3,
                            height:MediaQuery.of(context).size.width / 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  Images.messageee,
                                  width: 15,
                                  height: 15,
                                  semanticsLabel: 'Job Type',
                                  fit: BoxFit.contain,
                                ),
                                hSpace(5),
                                Text(
                                    "Job Type",
                                    style: Styles.mediumTextStyle(size: 12,color: blue3066CDColor)
                                ),
                                hSpace(5),
                                Text(
                                    "Full Time",
                                    style: Styles.semiBoldTextStyle(size: 12,color: kBlackColor)
                                ),
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.all(10),
                             width:  MediaQuery.of(context).size.width * 0.75 / 3,
                            height:MediaQuery.of(context).size.width / 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  Images.currency,
                                  width: 15,
                                  height: 15,
                                  semanticsLabel: 'Salaries',
                                  fit: BoxFit.contain,
                                ),
                                hSpace(5),
                                Text(
                                    "Salaries",
                                    style: Styles.mediumTextStyle(size: 12,color: blue3066CDColor)
                                ),
                                hSpace(5),
                                Text(
                                    "RS 20k - 50k",
                                    style: Styles.semiBoldTextStyle(size: 12,color: kBlackColor)
                                ),
                              ],
                            ),
                          ),
                
                
                
                        ],
                      ),
                    ),
                    hSpace(20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          "Overview",
                          style: Styles.semiBoldTextStyle(size: 16,color: kBlackColor)
                      ),
                    ),
                    hSpace(10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          "Just like the Junior UX Researcher, the Senior UX Researcher works closely with the Product Design, the Marketing, and Brand Strategy departments in validating new concepts and improving on the existing products for the purpose of enhancing the user experience.Read More",
                          style: Styles.regularTextStyle(size: 12,color: fontGrayColor)
                      ),
                    ),
                    hSpace(20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          "What You’ll Do",
                          style: Styles.semiBoldTextStyle(size: 16,color: kBlackColor)
                      ),
                    ),
                    hSpace(10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          "Research Objectives: The Senior UX Research independently defines the research objectives and formulates research proposals that are forwarded to the various product departments based on the different departmental needs.",
                          style: Styles.regularTextStyle(size: 12,color: fontGrayColor)
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
                          successDialog(
                            context, " Application Submitted Successfully!", (value) {
                              print(value);
                              if (value.toString() == "success") {
                                //showAlertSuccess(AppLocalizations.of(context)!.login_successfully, context);
                              }
                            },
                          ); // Save logic here
                          // Validate and submit data
                        },
                        child: const Text(
                          "Apply Now",
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


