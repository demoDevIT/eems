import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/workexperience/provider/work_experience_provider.dart';
import 'package:rajemployment/utils/dot_border.dart';

import '../../../utils/global.dart';
import '../../../utils/textstyles.dart';
import '../addworkexperience/add_work_experience.dart';
import '../loginscreen/provider/locale_provider.dart';

class WorkExperienceScreen extends StatefulWidget {
  const WorkExperienceScreen({super.key});

  @override
  State<WorkExperienceScreen> createState() => _WorkExperienceScreenState();
}

class _WorkExperienceScreenState extends State<WorkExperienceScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<WorkExperienceProvider>(context, listen: false);
      provider.clearData();
      provider.getBasicDetailsApi(context);
      provider.profileWorkExperienceDataApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2("Work Experience", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
          localeProvider.toggleLocale();
        }),
        body: Consumer<WorkExperienceProvider>(
            builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const DottedBorder(),

                const SizedBox(height: 16),

                const EmploymentSummaryCard(),

                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.workExperienceList.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      final data = provider.workExperienceList[index];

                      final isStudent = data.employmentName == "Student";

                      return WorkExperienceCard(
                        index: index,
                        employmentID: "${data.employmentID}",
                        jobTiTle: isStudent
                            ? "Student"
                            : "${data.jobTitle}, ${data.empolyer}",
                        date: isStudent
                            ? ""
                            : "${data.jobStartDate}, ${data.jobEndDate}",
                        ncoCode: "${data.nCOCode}",
                        address: "${data.address}",
                        jobType: "${data.jobType}",
                        natureofEmployment: "${data.natureofEmployment}",
                        jobResponsibilities: "${data.jobResponsibilities}",
                        isStudent: isStudent,
                      );
                    },

                  ),
                ),
                const SizedBox(height: 12),
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
    final provider = Provider.of<WorkExperienceProvider>(context, listen: false);
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

              final hasExperience = provider.basicDetails != null ||
                  provider.workExperienceList.isNotEmpty;

              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddWorkExperienceScreen(
                    isUpdate: false,
                    workExperienceListData: null,
                    hideExperienceQuestion: hasExperience,
                    existingExperiences: provider.workExperienceList,
                  ),
                ),
              );

              if (result != null) {
                provider.profileWorkExperienceDataApi(context);
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
                      "Add Work Experience",
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

class EmploymentSummaryCard extends StatelessWidget {
  const EmploymentSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkExperienceProvider>(context);

    final data = provider.basicDetails;

    if (data == null) {
      return const SizedBox(); // or shimmer
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Add the heading inside the box
          Text(
            "As Per OTR Form",
            style: Styles.semiBoldTextStyle(size: 14, color: kBlackColor),
          ),
          const SizedBox(height: 8),
          _rowItem("Employment Status", data.employmentStatus ?? "-"),
          const SizedBox(height: 6),
          Divider(color: dividerColor),
          const SizedBox(height: 6),

          _rowItem(
              "Experience (Years)", "${data.employmentExpYear ?? 0}"),
          const SizedBox(height: 6),
          Divider(color: dividerColor),
          const SizedBox(height: 6),

          _rowItem(
              "Experience (Months)", "${data.employmentExpMonth ?? 0}"),
        ],
      ),
    );
  }

  Widget _rowItem(String title, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Styles.mediumTextStyle(
            size: 14,
            color: fontGrayColor,
          ),
        ),
        Text(
          value,
          style: Styles.semiBoldTextStyle(
            size: 14,
            color: kBlackColor,
          ),
        ),
      ],
    );
  }
}



class WorkExperienceCard extends StatelessWidget {
  final int index;
  final String employmentID;
  final String jobTiTle;
  final String date;
  final String ncoCode;
  final String address;
  final String jobType;
  final String natureofEmployment;
  final String jobResponsibilities;
  final bool isStudent;

  const WorkExperienceCard({
    super.key,
    required this.index,
    required this.employmentID,
    required this.jobTiTle,
    required this.date,
    required this.ncoCode,
    required this.address,
    required this.jobType,
    required this.natureofEmployment,
    required this.jobResponsibilities,
    required this.isStudent,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<WorkExperienceProvider>(context, listen: false);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),

      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child:Padding(
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
                    isStudent ? "Student" : checkNullValue(jobTiTle),
                    style: Styles.semiBoldTextStyle(
                      size: 14,
                      color: kBlackColor,
                    ),
                  ),
                ),
                if (!isStudent)
                  Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: kJobFlotBackColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        checkNullValue(jobType),
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
                        //   onTap: () async {
                        //     final result = await Navigator.push(
                        //       context,
                        //       MaterialPageRoute(
                        //         builder: (context) => AddWorkExperienceScreen(
                        //           isUpdate: true,
                        //           workExperienceListData: provider.workExperienceList[index],
                        //           hideExperienceQuestion: true, // ✅ ADD THIS
                        //         ),
                        //
                        //       ),
                        //     );
                        //
                        //     if (result != null) {
                        //       provider.profileWorkExperienceDataApi(context);
                        //     }
                        //   },
                        //   child: SvgPicture.asset(
                        //     'assets/icons/edit.svg',
                        //     height: 20,
                        //   ),
                        // ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            confirmAlertDialog(context, "Alert","Are you sure want to delete ?", (value) {
                              if (value.toString() == "success") {
                                provider.deleteEducationDetailsApi(context,employmentID);

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
            if (isStudent) ...[
              const SizedBox(height: 8),
              Text(
                "Student",
                style: Styles.mediumTextStyle(
                  size: 13,
                  color: fontGrayColor,
                ),
              ),
            ]
            else ...[
              const SizedBox(height: 6),
              Text(
                checkNullValue(date),
                style: Styles.mediumTextStyle(size: 14, color: fontGrayColor),
              ),
              const SizedBox(height: 6),
              Divider(color: dividerColor),

              Text(
                "NCO Code: ${checkNullValue(ncoCode)}",
                style: Styles.regularTextStyle(size: 13, color: fontGrayColor),
              ),

              Divider(color: dividerColor),

              Row(
                children: [
                  Expanded(
                    child: Text(
                      checkNullValue(address),
                      style: Styles.regularTextStyle(
                          size: 13, color: fontGrayColor),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      checkNullValue(natureofEmployment),
                      textAlign: TextAlign.right,
                      style: Styles.regularTextStyle(
                          size: 13, color: fontGrayColor),
                    ),
                  ),
                ],
              ),

              Divider(color: dividerColor),

              Text(
                checkNullValue(jobResponsibilities),
                style: Styles.regularTextStyle(size: 13, color: fontGrayColor),
              ),
            ],


          ],
        ),
      ),
    );
  }
}
