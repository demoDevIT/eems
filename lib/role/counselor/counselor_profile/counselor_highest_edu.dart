import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/dot_border.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/user_new.dart';
import '../../../utils/dropdown.dart';
import '../../../utils/global.dart';
import '../../../utils/images.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../../job_seeker/addeducationaldetail/modal/education_level_modal.dart';
import '../../job_seeker/addeducationaldetail/modal/graduation_type_modal.dart';
import '../../job_seeker/loginscreen/provider/locale_provider.dart';
import 'modal/counselor_info_modal.dart';
import 'provider/counselor_basic_detail_provider.dart';
import 'provider/counselor_highest_edu_provider.dart';

class CounselorHighestEduScreen extends StatefulWidget {
  final CounselorInfoData? counselor;

  const CounselorHighestEduScreen({super.key, this.counselor});

  @override
  State<CounselorHighestEduScreen> createState() => _CounselorHighestEduScreenState();
}

class _CounselorHighestEduScreenState extends State<CounselorHighestEduScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
      Provider.of<CounselorHighestEduProvider>(context, listen: false);

      print("Counselor Data: ${widget.counselor}");

      if (widget.counselor != null) {
        provider.setCounselorData(widget.counselor!);
      }

      provider.educationLevelApi(context);
      provider.degreeTypeApi(context, provider.selectedQualificationId.toString());
      //provider.clearData();
      //provider.addData();
    });
  }



  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(

        appBar: commonAppBar2("Highest Education Detail", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),

        body: Consumer<CounselorHighestEduProvider>(builder: (context, provider, child) {
          return  SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              color: kWhite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Highest Education Detail",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  // const Text(
                  //   "(As Per Jan Aadhaar)",
                  //   style: TextStyle(color: Colors.red, fontSize: 12),
                  // ),
                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: labelWithStar('Highest Qualification',
                        required: true),
                  ),

                  IgnorePointer(
                    ignoring: true, // ✅ disable dropdown
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: buildSearchableDropdown<EducationLevelData>(
                        items: provider.educationLevelsList
                            .where((item) =>
                        item.dropID == 5 ||
                            item.dropID == 6 ||
                            item.dropID == 8)
                            .toList(),

                        getId: (item) => item.dropID.toString(),
                        getName: (item) => item.name ?? "",

                        controller: provider.educationLevelNameController,
                        idController: provider.educationLevelIdController,

                        hintText: "--Select Option--",

                        onChanged: (value) {},
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: labelWithStar('Degree',
                        required: true),
                  ),

                  IgnorePointer(
                    ignoring: true, // ✅ disable dropdown
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: buildSearchableDropdown<GraduationTypeData>(
                        items: provider.graduationTypeList,

                        // ✅ MAP YOUR MODEL HERE
                        getId: (item) => item.dropID.toString(),
                        getName: (item) => item.name ?? "",

                        controller: provider.graduationTypeNameController,
                        idController: provider.graduationTypeIdController,

                        hintText: "--Select Option--",

                        onChanged: (value) {},
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: labelWithStar('Highest Qualification',
                        required: true),
                  ),

                  IgnorePointer(
                    ignoring: true, // ✅ disable dropdown
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: buildSearchableDropdown<EducationLevelData>(
                        items: provider.educationLevelsList
                            .where((item) =>
                        item.dropID == 5 ||
                            item.dropID == 6 ||
                            item.dropID == 8)
                            .toList(),

                        getId: (item) => item.dropID.toString(),
                        getName: (item) => item.name ?? "",

                        controller: provider.educationLevelNameController,
                        idController: provider.educationLevelIdController,

                        hintText: "--Select Option--",

                        onChanged: (value) {},
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    child: labelWithStar('Highest Qualification',
                        required: true),
                  ),

                  IgnorePointer(
                    ignoring: true, // ✅ disable dropdown
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: buildSearchableDropdown<EducationLevelData>(
                        items: provider.educationLevelsList
                            .where((item) =>
                        item.dropID == 5 ||
                            item.dropID == 6 ||
                            item.dropID == 8)
                            .toList(),

                        getId: (item) => item.dropID.toString(),
                        getName: (item) => item.name ?? "",

                        controller: provider.educationLevelNameController,
                        idController: provider.educationLevelIdController,

                        hintText: "--Select Option--",

                        onChanged: (value) {},
                      ),
                    ),
                  ),

                  labelWithStar('Full Name',required: false),

                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: buildTextWithBorderField(
                      provider.fullNameController,
                      "Enter your full name",
                      MediaQuery.of(context).size.width,
                      50,
                      isEnabled: false,
                      TextInputType.emailAddress,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          labelWithStar('Gender',required: false),

                          const SizedBox(height: 8),

                          Row(
                            children: [
                              Radio<String>(
                                value: "Male",
                                groupValue:  provider.gender,
                                onChanged: (val) => () {
                                  //setState(() =>  provider.gender = val!);
                                },
                                visualDensity: VisualDensity.compact, // reduce space inside
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              const Text("Male"),
                              Radio<String>(
                                value: "Female",
                                groupValue:  provider.gender,
                                onChanged: (val) => () {
                                  //setState(() =>  provider.gender = val!);
                                },
                                visualDensity: VisualDensity.compact, // reduce space inside
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              const Text("Female"),
                              Radio<String>(
                                value: "Other",
                                groupValue:  provider.gender,
                                onChanged: (val) => () {
                                  //setState(() =>  provider.gender = val!);
                                },
                                visualDensity: VisualDensity.compact, // reduce space inside
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              const Text("Other"),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),

                    ],
                  ),

                  const SizedBox(height: 10),
                  Row(
                    //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        // alignment: Alignment.centerLeft,
                        //width: MediaQuery.of(context).size.width  * 0.92/ 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            labelWithStar('Date of Birth',required: false),
                            const SizedBox(height: 6),
                            buildTextWithBorderWhiteBgField(
                                provider.dobController,
                                "mm/dd/yy" , // No
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: false,
                                postfixIcon: Icon(Icons.calendar_month_outlined,)
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        // alignment: Alignment.centerLeft,
                        // width: MediaQuery.of(context).size.width  * 0.92/ 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            labelWithStar('Mobile Number',required: false),
                            const SizedBox(height: 6),
                            buildTextWithBorderWhiteBgField(
                              provider.mobileController,
                              "Enter mobile number" , // No
                              MediaQuery.of(context).size.width,
                              50,
                              isEnabled: false,
                              TextInputType.text,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  labelWithStar('Email',required: false),

                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: buildTextWithBorderField(
                      provider.emailController,
                      "Enter your email",
                      MediaQuery.of(context).size.width,
                      50,
                      isEnabled: false,
                      TextInputType.emailAddress,
                    ),
                  ),


                  SizedBox(height: SizeConfig.screenHeight! * 0.02),
                ],

              ),
            ),

          );
        }));


  }




}
