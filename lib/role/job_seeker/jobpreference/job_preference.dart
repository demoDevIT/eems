import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/jobpreference/provider/job_preference_provider.dart';
import 'package:rajemployment/utils/dot_border.dart';
import 'package:rajemployment/utils/textstyles.dart';

import '../../../utils/global.dart';
import '../addjobpreference/add_job_preference.dart';
import '../loginscreen/provider/locale_provider.dart';

class JobPreferenceScreen extends StatefulWidget {
  JobPreferenceScreen({super.key});

  @override
  State<JobPreferenceScreen> createState() => _JobPreferenceScreenState();
}

class _JobPreferenceScreenState extends State<JobPreferenceScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<JobPreferenceProvider>(context, listen: false);
      provider.clearData();
      provider.getJobPreferenceApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2("Job Preference", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
          localeProvider.toggleLocale();
        }),
        body: Consumer<JobPreferenceProvider>(
            builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text("Note : (Maximum of 5 Job Preferences Allowed)",
                  style: Styles.mediumTextStyle(size: 12,color: kRedColor),),
                 hSpace(10),
                provider.jobPreferenceList.length < 5 ? GestureDetector(
                  onTap: () {
                    // Add education details action
                  },
                  child: const DottedBorder(),
                ) : SizedBox(),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: provider.jobPreferenceList.length,
                    itemBuilder: (context, index) {
                      final data = provider.jobPreferenceList[index];
                      return EducationCard(
                        index: index,
                        jobPreferenceID: data.jobPreferenceID.toString(),
                        sectorName: data.sectorName.toString(),
                        employmenttypeName: data.employmenttypeName.toString(),
                        preLocationName: data.preLocationName.toString(),
                        ncoCode: data.nCOCode.toString(),
                        jobType: data.jobTypeName.toString(),
                        shift: data.shiftName.toString(),
                        salary: "${data.salarymin} - ${data.salarymax}",
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                /* SizedBox(
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
    final provider = Provider.of<JobPreferenceProvider>(context, listen: false);

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
                    builder: (context) => AddJobPreferenceScreen(
                        isUpdate: false, jobPreferenceData: null)),
              );

              if (result != null) {
                provider.getJobPreferenceApi(context);
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
                      "Add Job Preference",
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
  final String jobPreferenceID;
  final String sectorName;
  final String employmenttypeName;
  final String preLocationName;
  final String ncoCode;
  final String jobType;
  final String shift;
  final String salary;

  const EducationCard({
    super.key,
    required this.index,
    required this.jobPreferenceID,
    required this.sectorName,
    required this.employmenttypeName,
    required this.preLocationName,
    required this.ncoCode,
    required this.jobType,
    required this.shift,
    required this.salary,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<JobPreferenceProvider>(context, listen: false);
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
                    checkNullValue(sectorName),
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
                      checkNullValue(employmenttypeName),
                      style: TextStyle(color: kJobFontColor, fontSize: 12),
                    ),
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddJobPreferenceScreen(
                                      isUpdate: true, jobPreferenceData: provider.jobPreferenceList[index])),
                            );
                            if (result != null) {
                              provider.getJobPreferenceApi(context);
                            }
                            },
                          child: SvgPicture.asset(
                            'assets/icons/edit.svg',
                            height: 20,
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            confirmAlertDialog(
                              context,
                              "Alert",
                              "Are you sure want to delete ?",
                              (value) {
                                if (value.toString() == "success") {
                                  provider.deleteDetailProfileApi(
                                      context, jobPreferenceID);
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
              checkNullValue(preLocationName),
              overflow: TextOverflow.ellipsis,
              style: Styles.mediumTextStyle(size: 14, color: fontGrayColor),
            )),
            const SizedBox(height: 6),
            Divider(color: dividerColor),
            Container(
                alignment: Alignment.topLeft,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Text(
                  "NCO Code: ${checkNullValue(ncoCode)}",
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
                      "Job Type: ${checkNullValue(jobType)}",
                      style: Styles.regularTextStyle(
                          size: 13, color: fontGrayColor),
                    )),
                Container(
                    alignment: Alignment.topRight,
                    width: MediaQuery.of(context).size.width * 0.42,
                    child: Text(
                      "Shift: ${checkNullValue(shift)}",
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
                  "Salary: ${checkNullValue(salary)}",
                  style:
                      Styles.regularTextStyle(size: 13, color: fontGrayColor),
                )),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
