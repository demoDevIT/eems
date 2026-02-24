import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/job_details/provider/job_details_provider.dart';
import 'package:rajemployment/role/job_seeker/job_fair_event/provider/job_fair_event_details_provider.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/images.dart';
import '../../../utils/button.dart';
import '../../../utils/textstyles.dart';
import '../../../utils/user_new.dart';
import '../loginscreen/provider/locale_provider.dart';
import 'modal/running_event_modal.dart';

class JobFairEventDetailsScreen extends StatefulWidget {
  RunningEventData runningEventData;
       JobFairEventDetailsScreen({super.key,required this.runningEventData});

  @override
  State<JobFairEventDetailsScreen> createState() => _JobFairEventDetailsScreenState(runningEventData);
}

class _JobFairEventDetailsScreenState extends State<JobFairEventDetailsScreen> {
  RunningEventData runningEventData;
  _JobFairEventDetailsScreenState(this.runningEventData);

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2("Job Fair Event Detail", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),

       body: Consumer<JobFairEventDetailsProvider>(builder: (context, provider, child) {
            return   Padding(
              padding: const EdgeInsets.all(16.0),
              child:SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    hSpace(20),
                    Container(
                        width:MediaQuery.of(context).size.width,
                        padding: EdgeInsets.all(10),
                        child: Image(image:  AssetImage(Images.job_fair_event),width: MediaQuery.of(context).size.width,height:  MediaQuery.of(context).size.width / 2,)),
                    hSpace(10),
                    Text(localeProvider.currentLanguage == "en" ? "${runningEventData.eventNameENG} (${runningEventData.eventId})": runningEventData.eventNameHI.toString(),
                        style: Styles.semiBoldTextStyle(size: 10,color: fontGrayColor)
                    ),
                    hSpace(5),
                    Text(runningEventData.eventDescription.toString(),
                        style: Styles.semiBoldTextStyle(size: 18,color: kBlackColor)
                    ),
                    hSpace(10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          Images.calendar,
                          width: 25,
                          height: 25,
                          semanticsLabel: 'calendar',
                          fit: BoxFit.contain,
                        ),
                        vSpace(5),
                        Text(
                            "${getFormattedDate(runningEventData.startDate.toString(),)} ${getFormattedDate(runningEventData.endDate.toString(),)}",
                            style: Styles.mediumTextStyle(size: 12,color: fontGrayColor)
                        ),

                      ],
                    ),
                    hSpace(10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SvgPicture.asset(
                          Images.location_bg,
                          width: 25,
                          height: 25,
                          semanticsLabel: 'location bg',
                          fit: BoxFit.contain,
                        ),
                        vSpace(10),
                        Text(
                            runningEventData.venue.toString(),
                            style: Styles.mediumTextStyle(size: 12,color: fontGrayColor)
                        ),

                      ],
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
                          jobSeekerRegistrationDialog(
                            context,
                            runningEventData, (value) {
                            print(value);
                            if (value.toString() == "success") {
                              //showAlertSuccess(AppLocalizations.of(context)!.login_successfully, context);
                            }
                          },
                          ); // Save logic here
                          // Validate and submit data
                        },
                        child: const Text(
                          "Register Now",
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: kWhite),
                        ),
                      ),
                    ),
                    hSpace(20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          "About Job Fair",
                          style: Styles.semiBoldTextStyle(size: 16,color: kBlackColor)
                      ),
                    ),
                    hSpace(10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          runningEventData.eventDescription.toString(),
                          style: Styles.regularTextStyle(size: 12,color: fontGrayColor,lineHeight:2)
                      ),
                    ),

                    hSpace(20),

                  ],
                ),
              ),
            );
          }));


  }

  Future<void> jobSeekerRegistrationDialog(BuildContext context, RunningEventData eventData, Function fun) {
    final user = UserData().model;
    return showGeneralDialog(
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return WillPopScope(
          onWillPop: () async {
            return false; // Prevent back navigation
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 10), // 👈 Removes default side padding
                backgroundColor: kWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // 👈 optional (0 for full edge)
                ),
                child: Container(
                  width: double.infinity, // 👈 Full width
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        eventData.eventNameENG ?? "",
                        style: Styles.semiBoldTextStyle(size: 18, color: kBlackColor),
                      ),
                      hSpace(10),
                      Text(
                        "Job Seeker Registration",
                        style: Styles.regularTextStyle(size: 14, color: fontGrayColor),
                      ),
                      hSpace(10),
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
                        decoration: BoxDecoration(
                          color: kWhite,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: grayBorderColor),
                        ),
                        child: Column(
                          children: [
                            hSpace(10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  width: MediaQuery.of(context).size.width *
                                      0.40,
                                  child: RichText(
                                    text: TextSpan(
                                      style: Styles.mediumTextStyle(
                                        size: 12,
                                        color: kBlackColor, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Name",
                                          // Normal text
                                          style: Styles.semiBoldTextStyle(
                                              size: 12,
                                              color:
                                              kBlackColor),
                                        ),
                                        TextSpan(
                                          text: ' :-', // Asterisk text
                                          style: Styles.semiBoldTextStyle(
                                              size: 12,
                                              color:
                                              kBlackColor),
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
                                  width: MediaQuery.of(context).size.width *
                                      0.40,
                                  child: RichText(
                                    text: TextSpan(
                                      style: Styles.mediumTextStyle(
                                        size: 12,
                                        color: kBlackColor, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "${user?.value.nAMEENG ?? ""}",
                                          style: Styles.regularTextStyle(
                                              size: 12,
                                              color:
                                              kBlackColor),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.end, // Align text to the start
                                  ),
                                ),
                              ],
                            ),
                            hSpace(10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  width: MediaQuery.of(context).size.width *
                                      0.40,
                                  child: RichText(
                                    text: TextSpan(
                                      style: Styles.semiBoldTextStyle(
                                        size: 12,
                                        color: kBlackColor, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Mobile No.",
                                          // Normal text
                                          style: Styles.semiBoldTextStyle(
                                              size: 12,
                                              color:
                                              kBlackColor),
                                        ),
                                        TextSpan(
                                          text: ' :-', // Asterisk text
                                          style: Styles.semiBoldTextStyle(
                                              size: 12,
                                              color:
                                              kBlackColor),
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
                                  width: MediaQuery.of(context).size.width *
                                      0.40,
                                  child: RichText(
                                    text: TextSpan(
                                      style: Styles.regularTextStyle(
                                        size: 12,
                                        color: kBlackColor, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "+91 ${user?.value.mOBILENO ?? ""}",
                                          style: Styles.regularTextStyle(
                                              size: 12,
                                              color:
                                              kBlackColor),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.end, // Align text to the start
                                  ),
                                ),
                              ],
                            ),
                            hSpace(10),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  width: MediaQuery.of(context).size.width *
                                      0.40,
                                  child: RichText(
                                    text: TextSpan(
                                      style: Styles.semiBoldTextStyle(
                                        size: 12,
                                        color: kBlackColor, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Event Name",
                                          // Normal text
                                          style: Styles.semiBoldTextStyle(
                                              size: 12,
                                              color:
                                              kBlackColor),
                                        ),
                                        TextSpan(
                                          text: ' :-', // Asterisk text
                                          style: Styles.semiBoldTextStyle(
                                              size: 12,
                                              color:
                                              kBlackColor),
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
                                  width: MediaQuery.of(context).size.width *
                                      0.40,
                                  child: RichText(
                                    text: TextSpan(
                                      style: Styles.regularTextStyle(
                                        size: 12,
                                        color: kBlackColor, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text: eventData.eventNameENG ?? "",
                                          style: Styles.regularTextStyle(
                                              size: 12,
                                              color:
                                              kBlackColor),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.end, // Align text to the start
                                  ),
                                ),
                              ],
                            ),
                            hSpace(10),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  width: MediaQuery.of(context).size.width *
                                      0.40,
                                  child: RichText(
                                    text: TextSpan(
                                      style: Styles.semiBoldTextStyle(
                                        size: 12,
                                        color: kBlackColor, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text: "Event ID",
                                          // Normal text
                                          style: Styles.semiBoldTextStyle(
                                              size: 12,
                                              color:
                                              kBlackColor),
                                        ),
                                        TextSpan(
                                          text: ' :-', // Asterisk text
                                          style: Styles.mediumTextStyle(
                                              size: 12,
                                              color:
                                              kBlackColor),
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
                                  width: MediaQuery.of(context).size.width *
                                      0.40,
                                  child: RichText(
                                    text: TextSpan(
                                      style: Styles.regularTextStyle(
                                        size: 12,
                                        color: kBlackColor, // Default text color
                                      ),
                                      children: [
                                        TextSpan(
                                          text: eventData.eventId?.toString() ?? "",
                                          style: Styles.regularTextStyle(
                                              size: 12,
                                              color:
                                              kBlackColor),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.end, // Align text to the start
                                  ),
                                ),
                              ],
                            ),
                            hSpace(10),
                          ]
                        ),
                      ),

                      hSpace(20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          customButton2(() async {
                            Navigator.of(context).pop();
                          }, "Back",
                              '',
                              context,
                              width:MediaQuery.of(context).size.width * 0.85 / 2,
                              height: 50,
                              color: kWhite,
                              txtColor: purpal455CDCColor,
                              borderColor:purpal455CDCColor ),

                          customButton(() async {
                            Navigator.of(context).pop(); // close first dialog

                            final provider =
                            Provider.of<JobFairEventDetailsProvider>(
                                context,
                                listen: false);

                            confirmRegistrationDialog(context, provider);

                          }, "Confirm",
                              '',
                              context,
                              width:MediaQuery.of(context).size.width * 0.85 / 2,
                              height: 50,
                              color: purpal455CDCColor,
                              txtColor: kWhite),
                        ],
                      ),



                      hSpace(20),
                    ],
                  ),
                ),
              );

            },
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(CurvedAnimation(
            parent: anim1,
            curve: Curves.linear,
          )),
          child: child,
        );
      },
    );
  }

  Future<void> annualDistrictDialog(BuildContext context, Function fun) {
    return showGeneralDialog(
      barrierDismissible: false,
      barrierLabel: '',
      context: context,
      pageBuilder: (context, anim1, anim2) {
        return WillPopScope(
          onWillPop: () async {
            return false; // Prevent back navigation
          },
          child: StatefulBuilder(
            builder: (context, setState) {
              return Dialog(
                insetPadding: EdgeInsets.symmetric(horizontal: 10), // 👈 Removes default side padding
                backgroundColor: kWhite,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20), // 👈 optional (0 for full edge)
                ),
                child: Container(
                  width: double.infinity, // 👈 Full width
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Annual District-wide job",
                        style: Styles.semiBoldTextStyle(size: 18, color: kBlackColor),
                      ),
                      Text(
                        "fair for all sectors",
                        style: Styles.semiBoldTextStyle(size: 18, color: kBlackColor),
                      ),
                      hSpace(10),
                      hSpace(10),
                      Image(image: AssetImage(Images.qr_code),width: 100,height: 100,),
                      hSpace(10),
                      Text(
                        "Successful",
                        style: Styles.semiBoldTextStyle(size: 18, color: green00C324),
                      ),
                      hSpace(10),
                      Text(
                        "Thank You for  Registration",
                        style: Styles.mediumTextStyle(size: 14, color: kBlackColor),
                      ),
                      Text(
                        "Your Registration ID:- #1234FA/2025",
                        style: Styles.semiBoldTextStyle(size: 14, color: kBlackColor),
                      ),



                      hSpace(20),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          customButton2(() async {
                            Navigator.of(context).pop();
                          }, "OK",
                              '',
                              context,
                              width:MediaQuery.of(context).size.width * 0.85 / 2,
                              height: 50,
                              color: kWhite,
                              radius: 50,
                              txtColor: purpal455CDCColor,
                              borderColor:purpal455CDCColor ),

                          // customButton(() async {
                          //   Navigator.of(context).pop();
                          //   successDialog(
                          //     context, "Event closed pls provide your feedback", (value) {
                          //     if (value.toString() == "success") {
                          //       //showAlertSuccess(AppLocalizations.of(context)!.login_successfully, context);
                          //     }
                          //   },
                          //   ); //
                          // }, "Download",
                          //     '',
                          //     context,
                          //     width:MediaQuery.of(context).size.width * 0.85 / 2,
                          //     height: 50,
                          //     radius: 50,
                          //     color: purpal455CDCColor,
                          //     txtColor: kWhite),
                        ],
                      ),



                      hSpace(20),
                    ],
                  ),
                ),
              );

            },
          ),
        );
      },
      transitionBuilder: (context, anim1, anim2, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: const Offset(0, 0),
          ).animate(CurvedAnimation(
            parent: anim1,
            curve: Curves.linear,
          )),
          child: child,
        );
      },
    );
  }

  Future<void> confirmRegistrationDialog(
      BuildContext context,
      JobFairEventDetailsProvider provider) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Text(
            "Confirmation",
            style: Styles.semiBoldTextStyle(size: 16, color: kBlackColor),
          ),
          content: Text(
            "Are you sure you want to register for this Job Fair Event?",
            style: Styles.regularTextStyle(size: 14, color: kBlackColor),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context); // close confirmation dialog

                final provider =
                Provider.of<JobFairEventDetailsProvider>(
                    context,
                    listen: false);

                int eventId =
                    int.tryParse(
                        runningEventData.jobEventDetailId.toString()) ?? 0;

                bool success =
                await provider.registerJobFairEvent(
                    context,
                    eventId);

                if (success) {
                  annualDistrictDialog(context, (value) {});
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text(
                            provider.apiMessage.isNotEmpty
                                ? provider.apiMessage
                                : "Registration Failed")),
                  );
                }
              },
              child: Text("Yes"),
            ),
          ],
        );
      },
    );
  }

}


