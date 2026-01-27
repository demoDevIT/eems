import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/educationdetail/provider/education_details_provider.dart';
import 'package:rajemployment/utils/dot_border.dart';

import '../../../utils/global.dart';
import '../../../utils/textstyles.dart';
import '../addeducationaldetail/add_educational_detail.dart';
import '../basicdetails/provider/basic_details_provider.dart';
import '../loginscreen/provider/locale_provider.dart';

class EducationalDetailsScreen extends StatefulWidget {
  const EducationalDetailsScreen({super.key});

  @override
  State<EducationalDetailsScreen> createState() =>
      _EducationalDetailsScreenState();
}

class _EducationalDetailsScreenState extends State<EducationalDetailsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<EducationDetailsProvider>(context, listen: false);
      provider.clearData();
      provider.profileQualicationInfoApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2("Educational Details", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
          localeProvider.toggleLocale();
        }),
        body: Consumer<EducationDetailsProvider>(
            builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // Add education details action
                  },
                  child: const DottedBorder(),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true, // makes list take only needed height
                    physics: BouncingScrollPhysics(),
                    itemCount: provider.educationList.length,
                    itemBuilder: (context, index) {
                      final data = provider.educationList[index];
                      return EducationCard(
                        index: index,
                        educationID: data.educationID.toString(),
                        qualificationName: data.qualificationName.toString(),
                        educationTypeName: data.educationTypeName.toString(),
                        ncoCode: data.nCOCode.toString(),
                        uniborad :data.universityName.toString().isNotEmpty ? data.universityName.toString() : data.boardName.toString(),
                        college :data.collegeName.toString().isNotEmpty ? data.collegeName.toString() : data.schoolName.toString(),
                        mode :data.courseName.toString(),
                        medium :data.mediumName.toString(),
                        passing_year :data.passingYear.toString(),
                       // grade :checkNullValue(data.gradeName.toString()).isNotEmpty ?  data.gradeName.toString() : checkNullValue(data.cGPA.toString()).isNotEmpty ? data.cGPA.toString() : data.percentage.toString() + "%" ,
                        resultTypeName: data.resultTypeName.toString(),
                        gradeName: data.gradeName.toString(),
                        cgpa: data.cGPA.toString(),
                        percentage: data.percentage.toString(),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                /*SizedBox(
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
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                ),*/
              ],
            ),
          );
        }));
  }
}

class DottedBorder extends StatelessWidget {
  const DottedBorder({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EducationDetailsProvider>(context, listen: false);
    return DashedBorderContainer(
        color: const Color(0xFFF3E5F9),
        dash: 4,
        gap: 4,
        strokeWidth: 2,
        radius: "15",
        child: Container(
          height: 80,
          child: InkWell(
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddEducationalDetail(
                    isUpdate: false,
                    profileData: null,
                  ),
                ),
              );

              if (result != null) {
                provider.profileQualicationInfoApi(context);
              }

            },
            child: const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_circle,
                      color: kPrimaryColor,
                      size: 30,
                    ),
                    SizedBox(
                      width: 6,
                      height: 8,
                    ),
                    Text(
                      "Add Educational Details",
                      style: TextStyle(color: Colors.black54),
                    )
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

class EducationCard extends StatelessWidget {
  final int index;
  final String educationID;
  final String qualificationName;
  final String educationTypeName;
  final String ncoCode;
  final String uniborad;
  final String college;
  final String mode;
  final String medium;
  final String passing_year;
  //final String grade;
  final String resultTypeName;
  final String gradeName;
  final String cgpa;
  final String percentage;

  const EducationCard({
    super.key,
    required this.index,
    required this.educationID,
    required this.qualificationName,
    required this.educationTypeName,
    required this.ncoCode,
    required this.uniborad,
    required this.college,
    required this.mode,
    required this.medium,
    required this.passing_year,
    //required this.grade,
    required this.resultTypeName,
    required this.gradeName,
    required this.cgpa,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EducationDetailsProvider>(context, listen: false);

    final result = getResultLabelAndValue(
      resultTypeName: resultTypeName,
      gradeName: gradeName,
      cgpa: cgpa,
      percentage: percentage,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),

      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    checkNullValue(qualificationName),
                    style:
                        Styles.semiBoldTextStyle(size: 14, color: kBlackColor),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: kJobFlotBackColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      checkNullValue(mode),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: kJobFontColor, fontSize: 12),
                    ),
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // InkWell(
                        //   onTap:  () async {
                        //     final result = await Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => AddEducationalDetail(
                        //           isUpdate: true,
                        //           profileData:provider.educationList[index]),
                        //         ),
                        //     );
                        //     if (result != null) {
                        //       provider.profileQualicationInfoApi(context);
                        //     }
                        //  },
                        //   child: SvgPicture.asset(
                        //     'assets/icons/edit.svg',
                        //     height: 20,
                        //   ),
                        // ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap:  () {
                            confirmAlertDialog(context, "Alert","Are you sure want to delete ?", (value) {
                              if (value.toString() == "success") {
                                provider.deleteEducationDetailsApi(context,educationID);

                              }
                            },
                            );
                            },
                          child: SvgPicture.asset(
                            'assets/icons/trash.svg',
                            height: 20,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
            Container(
                child: Text(
                  checkNullValue(educationTypeName),
              overflow: TextOverflow.ellipsis,
              style: Styles.mediumTextStyle(size: 14, color: fontGrayColor),
            )),
            const SizedBox(height: 6),
            Divider(color: dividerColor),
            Container(
                alignment: Alignment.topLeft,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Text(
                  "NCO Code:${checkNullValue(ncoCode)}",
                  style:
                      Styles.regularTextStyle(size: 13, color: fontGrayColor),
                )),
            Divider(color: dividerColor),
            Row(
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    width: MediaQuery.of(context).size.width * 0.42,
                    child: Text(
                      "Uni/Board: ${checkNullValue(uniborad)}",
                      style: Styles.regularTextStyle(
                          size: 13, color: fontGrayColor),
                    )),
                Container(
                    alignment: Alignment.topRight,
                    width: MediaQuery.of(context).size.width * 0.42,
                    child: Text(
                      "College/School: ${checkNullValue(college)}",
                      style: Styles.regularTextStyle(
                          size: 13, color: fontGrayColor),
                    )),
              ],
            ),
            Divider(color: dividerColor),
            Container(
                alignment: Alignment.topLeft,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Text(
                  "Mode: ${checkNullValue(mode)}",
                  style:
                      Styles.regularTextStyle(size: 13, color: fontGrayColor),
                )),
            Divider(color: dividerColor),
            Container(
                alignment: Alignment.topLeft,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Text(
                  "Medium: ${checkNullValue(medium)}",
                  style:
                  Styles.regularTextStyle(size: 13, color: fontGrayColor),
                )),

            Divider(color: dividerColor),
            Container(
                alignment: Alignment.topLeft,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Text(
                  "Passing Year: ${checkNullValue(passing_year)}",
                  style:
                  Styles.regularTextStyle(size: 13, color: fontGrayColor),
                )),

            Divider(color: dividerColor),

            Container(
                alignment: Alignment.topLeft,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Text(
                  "${result['label']}: ${result['value']}",
                  style: Styles.regularTextStyle(size: 13, color: fontGrayColor),
                ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
Map<String, String> getResultLabelAndValue({
  required String resultTypeName,
  required String gradeName,
  required String cgpa,
  required String percentage,
}) {
  switch (resultTypeName) {
    case "CGPA":
      return {
        "label": "CGPA",
        "value": checkNullValue(cgpa),
      };

    case "Grade":
      return {
        "label": "Grade",
        "value": checkNullValue(gradeName),
      };

    case "Percentage":
      return {
        "label": "Percentage",
        "value": "${checkNullValue(percentage)}%",
      };

    default:
      return {
        "label": "Result",
        "value": "",
      };
  }
}
