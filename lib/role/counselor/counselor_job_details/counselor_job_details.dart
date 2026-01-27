import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/counselor/counselor_job_details/provider/counselor_job_details_provider.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/images.dart';

import '../../../utils/button.dart';
import '../../../utils/textstyles.dart';

class CounselorJobDetailsScreen extends StatefulWidget {
   CounselorJobDetailsScreen({super.key});

  @override
  State<CounselorJobDetailsScreen> createState() => _CounselorJobDetailsScreenState();
}

class _CounselorJobDetailsScreenState extends State<CounselorJobDetailsScreen> {


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
            "Jobs Details",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          centerTitle: true,
        ),
       body: Consumer<CounselorJobDetailsProvider>(builder: (context, provider, child) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                        "Frontend Developer,  Infosys",
                        style: Styles.semiBoldTextStyle(size: 18,color: kBlackColor)
                    ),
                    hSpace(10),
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Text("Position: ",
                            style: Styles.semiBoldTextStyle(
                                size: 14,
                                color:kBlackColor)),
                        Expanded(
                          child: Text("Frontend Developer",
                              style: Styles.semiBoldTextStyle(
                                  size: 14,
                                  color: fontGrayColor))
                        ),
                      ],
                    ),
                    hSpace(5),
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Text("Company: ",
                            style: Styles.semiBoldTextStyle(
                                size: 14,
                                color:kBlackColor)),
                        Expanded(
                            child: Text("Infosys",
                                style: Styles.semiBoldTextStyle(
                                    size: 14,
                                    color: fontGrayColor))
                        ),
                      ],
                    ),
                    hSpace(5),
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Text("Location: ",
                            style: Styles.semiBoldTextStyle(
                                size: 14,
                                color:kBlackColor)),
                        Expanded(
                            child: Text("Bangalore, India",
                                style: Styles.semiBoldTextStyle(
                                    size: 14,
                                    color: fontGrayColor))
                        ),
                      ],
                    ),
                    hSpace(5),
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Text("Job Type:",
                            style: Styles.semiBoldTextStyle(
                                size: 14,
                                color:kBlackColor)),
                        Expanded(
                            child: Text(" Full-time",
                                style: Styles.semiBoldTextStyle(
                                    size: 14,
                                    color: fontGrayColor))
                        ),
                      ],
                    ),
                    hSpace(5),
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Text("Salary:",
                            style: Styles.semiBoldTextStyle(
                                size: 14,
                                color:kBlackColor)),
                        Expanded(
                            child: Text("₹6.5 LPA",
                                style: Styles.semiBoldTextStyle(
                                    size: 14,
                                    color: fontGrayColor))
                        ),
                      ],
                    ),
                    hSpace(5),
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Text("Experience Required:",
                            style: Styles.semiBoldTextStyle(
                                size: 14,
                                color:kBlackColor)),
                        Expanded(
                            child: Text("2+ Years",
                                style: Styles.semiBoldTextStyle(
                                    size: 14,
                                    color: fontGrayColor))
                        ),
                      ],
                    ),
                    hSpace(20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [

                        customButton(() async {

                          successDialog(
                            context, "Job has been successfully recommended to Anjali Sharma", (value) {
                            print(value);
                            if (value.toString() == "success") {
                              //showAlertSuccess(AppLocalizations.of(context)!.login_successfully, context);
                            }
                          },
                          );

                        }, "Recommend job",
                            '',
                            context,
                            width:MediaQuery.of(context).size.width * 0.85 / 2,
                            height: 50,
                            color: purpal455CDCColor,
                            txtColor: kWhite),

                        vSpace(10),

                        customButton2(() async {
                        }, "Save",
                            '',
                            context,
                            width:MediaQuery.of(context).size.width * 0.85 / 2,
                            height: 50,
                            color: kWhite,
                            txtColor: purpal455CDCColor,
                            borderColor:purpal455CDCColor ),

                      ],
                    ),
                    hSpace(10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          "Job Summary:",
                          style: Styles.semiBoldTextStyle(size: 16,color: kBlackColor)
                      ),
                    ),
                    hSpace(10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text("Infosys is seeking a talented and motivated Frontend Developer to join our engineering team. As a frontend developer, you will be responsible for developing and implementing user interface components using React.js, ensuring high performance and responsiveness of web applications.",
                          style: Styles.regularTextStyle(size: 12,color: fontGrayColor)
                      ),
                    ),
                    hSpace(20),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          "Key Responsibilities:",
                          style: Styles.semiBoldTextStyle(size: 16,color: kBlackColor)
                      ),
                    ),
                    hSpace(10),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                          "Develop new user-facing features using React.js and\nmodern JavaScript\nBuild reusable code and libraries for future use\nOptimize components for maximum speed and\nscalability Ensure technical feasibility of UI/UX designs\nCollaborate with backend developers,\ndesigners, and",
                          style: Styles.regularTextStyle(size: 12,color: fontGrayColor)
                      ),
                    ),
                    hSpace(20),

                  ],
                ),
              ),
            );
          }));


  }
}


