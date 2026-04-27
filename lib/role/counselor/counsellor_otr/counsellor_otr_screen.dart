import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/main.dart';
import 'package:rajemployment/role/job_seeker/otr_form/modal/language_list_modal.dart';
import 'package:rajemployment/role/job_seeker/otr_form/provider/otr_form_provider.dart';
import '../../../utils/dot_border.dart';
import '../../../utils/dropdown.dart';
import '../../../utils/global.dart';
import '../../../utils/images.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../../../utils/user_new.dart';
import '../../job_seeker/addeducationaldetail/modal/education_level_modal.dart';
import '../../job_seeker/addeducationaldetail/modal/graduation_type_modal.dart';
import '../../job_seeker/addeducationaldetail/modal/passing_year_modal.dart';
import '../../job_seeker/addeducationaldetail/modal/university_modal.dart';
import '../../job_seeker/addjobpreference/modal/language_type_modal.dart';
import '../../job_seeker/loginscreen/provider/locale_provider.dart';
import '../../job_seeker/otr_form/modal/fetch_jan_adhar_modal.dart';
import 'package:rajemployment/role/counselor/counsellor_otr/provider/counsellor_otr_provider.dart';

import 'modal/counseling_medium_modal.dart';
import 'modal/preferred_age_group.dart';
import 'modal/primary_domain_modal.dart';
import 'modal/specialization_modal.dart';
import 'modal/tech_tool_modal.dart';

class CounselorOtrScreen extends StatefulWidget {
  final List<FetchJanAdharResponseData> feachJanAadhaarDataList;
  final String? janMemberId;
  final String ssoId;
  final String userID;

  CounselorOtrScreen({
    super.key,
    List<FetchJanAdharResponseData>? feachJanAadhaarDataList,
    this.janMemberId,
    required this.ssoId,
    required this.userID,
  }) : feachJanAadhaarDataList = feachJanAadhaarDataList ?? [];

  @override
  State<CounselorOtrScreen> createState() => _CounselorOtrScreenState();
}

class _CounselorOtrScreenState extends State<CounselorOtrScreen> {
  // String? janMemberId;
  // String? ssoId;
  // String? userID;
  // List<FetchJanAdharResponseData> feachJanAadhaarDataList = [];
  //
  // _CounselorOtrScreenState(
  //     this.feachJanAadhaarDataList,
  //     this.janMemberId,
  //     this.ssoId,
  //     this.userID
  //     );

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<CounselorOtrProvider>(context, listen: false);

      provider.setJanAadhaarControllers(
          context, widget.feachJanAadhaarDataList[0], widget.ssoId);

      provider.languageTypeModaltApi(context);
      provider.specializationApi(context);
      provider.educationLevelApi(context);
      provider.universityApi(context);
      provider.passingYearModalApi(context);
      provider.primaryDomainModalApi(context);
      provider.counsMedModalApi(context);
      provider.techToolModalApi(context);
      provider.preAgeGroupModalApi(context);

    });
  }

  @override
  Widget build(BuildContext context) {
    // Small device padding / sizing
    final double spacing = 12;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2(
            "Counsellor OTR Form", context, localeProvider.currentLanguage, "", false, "",
            onTapClick: () {
              localeProvider.toggleLocale();
            }),
        body: Consumer<CounselorOtrProvider>(builder: (context, provider, child) {
          return SafeArea(
            child: Form(
              key: _formKey,
              child: ListView(
                padding:
                const EdgeInsets.symmetric(horizontal: 5, vertical: 18),
                // child: Column(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: labelWithStar('SSOID', required: false),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: buildTextWithBorderField(
                          provider.ssoIDController,
                          "Enter sso id",
                          MediaQuery.of(context).size.width,
                          50,
                          TextInputType.text,
                          isEnabled: false,
                          boxColor: fafafaColor),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: labelWithStar('Name', required: false),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: buildTextWithBorderField(
                        provider.nameController,
                        "Enter Name",
                        MediaQuery.of(context).size.width,
                        50,
                        TextInputType.text,
                        boxColor: fafafaColor,
                        isEnabled: false,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: labelWithStar('Mobile No', required: false),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: buildTextWithBorderField(
                        provider.mobileNOController,
                        "Enter mobile number",
                        MediaQuery.of(context).size.width,
                        50,
                        TextInputType.number,
                        boxColor: fafafaColor,
                        isEnabled: false,
                      ),
                    ),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Basic Details",
                              style: Styles.semiBoldTextStyle(
                                  size: 14, color: kWhite),
                            ),
                          ),
                          SizedBox(height: spacing + 10),
                          Center(
                            child: Stack(
                              alignment: Alignment.center,
                              clipBehavior: Clip.none,
                              // allow button to overflow a little
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showImagePicker(context, (pickedImage) async {
                                      if (pickedImage != null) {
                                        final file = File(pickedImage.path);
                                        final int fileSizeInBytes =
                                        await file.length();
                                        final double fileSizeInKB =
                                            fileSizeInBytes / 1024;

                                        // ✅ 100 KB validation
                                        if (fileSizeInKB > 100) {
                                          showAlertError(
                                            "Image size must be less than 100 KB",
                                            context,
                                          );
                                          return; // ❌ STOP upload
                                        }
                                        // First update the file path (optional)
                                        provider.profileFile = pickedImage;

                                        // Do async work here
                                        String timestamp =
                                            "${DateTime.now().millisecondsSinceEpoch}.jpg";
                                        String fileName = timestamp;

                                        Map<String, dynamic> fields = {
                                          "file": await MultipartFile.fromFile(
                                            provider.profileFile!.path,
                                            filename: fileName,
                                          ),
                                        };

                                        FormData param = FormData.fromMap(fields);

                                        // Call upload API
                                        await provider.uploadDocumentApi(
                                            context, param);

                                        // Now update state if needed
                                        setState(() {
                                          // Update UI-related state if needed
                                        });
                                      }
                                    });
                                  },
                                  child: DashedBorderContainer(
                                      color: const Color(0xFFF3E5F9),
                                      dash: 4,
                                      gap: 4,
                                      strokeWidth: 2,
                                      radius: "100",
                                      child: Container(
                                        width:
                                        MediaQuery.of(context).size.width * 0.18,
                                        height:
                                        MediaQuery.of(context).size.width * 0.18,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: Colors.blue, // 👉 Border color
                                            width: 3, // 👉 Border width
                                          ),
                                        ),
                                        child: ClipOval(
                                          child: provider.profileFile != null
                                              ? Image.file(
                                            File(
                                              provider.profileFile!.path,
                                            ),
                                            fit: BoxFit.cover,
                                          )
                                              : Image.network(
                                            checkNullValue(UserData()
                                                .model
                                                .value
                                                .latestPhotoPath
                                                .toString())
                                                .isNotEmpty
                                                ? UserData()
                                                .model
                                                .value
                                                .latestPhotoPath
                                                .toString()
                                                : "",
                                            width: double.infinity,
                                            height: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Image.asset(
                                                Images.placeholder,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      )),
                                ),

                                // ✅ Place edit icon overlapping border
                                Positioned(
                                  bottom: 3, // slightly outside
                                  right: -6, // slightly outside
                                  child: GestureDetector(
                                    onTap: () {
                                      showImagePicker(context, (pickedImage) async {
                                        if (pickedImage != null) {
                                          // First update the file path (optional)
                                          provider.profileFile = pickedImage;

                                          // Do async work here
                                          String timestamp =
                                              "${DateTime.now().millisecondsSinceEpoch}.jpg";
                                          String fileName = timestamp;

                                          Map<String, dynamic> fields = {
                                            "file": await MultipartFile.fromFile(
                                              provider.profileFile!.path,
                                              filename: fileName,
                                            ),
                                          };

                                          FormData param = FormData.fromMap(fields);

                                          // Call upload API
                                          await provider.uploadDocumentApi(
                                              context, param);

                                          // Now update state if needed
                                          setState(() {
                                            // Update UI-related state if needed
                                          });
                                        }
                                      });
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: kPrimaryColor,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white,
                                          // 👈 white outline makes it "sit" on border
                                          width: 2,
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(4),
                                      child: const Icon(Icons.add,
                                          size: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: spacing + 10),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Full Name', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.fullNameController,
                              "Enter full name",
                              MediaQuery.of(context).size.width,
                              50,
                              TextInputType.text,
                              isEnabled: false,
                              boxColor: fafafaColor,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Gender', required: false),
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'Male',
                                    groupValue: provider.genderController.text,
                                    // onChanged: (val) => setState(() => provider
                                    //     .genderController.text =
                                    //     val ?? provider.genderController.text),
                                    onChanged: null,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Male',
                                    style: Styles.mediumTextStyle(
                                        color: kBlackColor, size: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'Female',
                                    groupValue: provider.genderController.text,
                                    // onChanged: (val) => setState(() => provider
                                    //     .genderController.text =
                                    //     val ?? provider.genderController.text),
                                    onChanged: null,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Female',
                                    style: Styles.mediumTextStyle(
                                        color: kBlackColor, size: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'TransGender',
                                    groupValue: provider.genderController.text,
                                    // onChanged: (val) => setState(() => provider
                                    //     .genderController.text =
                                    //     val ?? provider.genderController.text),
                                    onChanged: null,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'TransGender',
                                    style: Styles.mediumTextStyle(
                                        color: kBlackColor, size: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child:
                            labelWithStar('Date of Birth', required: true),
                          ),
                          InkWell(
                            onTap: () {
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.dateOfBirthController,
                                "Select Date of Birth",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child:
                            labelWithStar('Mobile Number', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.mobileNumberController,
                              "Enter mobile number",
                              MediaQuery.of(context).size.width,
                              50,
                              TextInputType.text,
                              isEnabled: false,
                              boxColor: fafafaColor,
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child:
                            labelWithStar('Email Address', required: true),
                          ),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: buildTextWithBorderField(
                                  provider.emailController,
                                  "Enter email address",
                                  MediaQuery.of(context).size.width,
                                  50,
                                  TextInputType.emailAddress,
                                  fun: (text) {
                                    provider.validateEmail(text);
                                  },
                                ),
                              ),
                              if (provider.emailErrorText != null)
                                Padding(
                                  padding:
                                  const EdgeInsets.only(top: 4, left: 8),
                                  child: Text(
                                    provider.emailErrorText!,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: labelWithStar('Preferred Language for Counseling',
                                    required: true),
                              ),

                              IgnorePointer(
                                ignoring: false,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: buildSearchableDropdown<LanguageTypeData>(
                                    //items: provider.lang  uageKnownList,
                                    items: provider.languageKnownList
                                        .where((item) => item.dropID == 1 || item.dropID == 2 || item.dropID == 7)
                                        .toList(),
                                    // ✅ MAP YOUR MODEL HERE
                                    getId: (item) => item.dropID.toString(),
                                    getName: (item) => item.name ?? "",

                                    controller: provider.languageNameController,
                                    idController: provider.languageIdController,
                                    hintText: "--Select Option--",
                                    // height: 50,
                                    // color: Colors.transparent,
                                    // borderRadius: BorderRadius.circular(8),
                                    onChanged: (value) {},
                                  ),
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: labelWithStar('Specialization / Expertise Area',
                                    required: true),
                              ),

                              IgnorePointer(
                                ignoring: false,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: buildSearchableDropdown<SpecializationData>(
                                    items: provider.specializationList,

                                    // ✅ MAP YOUR MODEL HERE
                                    getId: (item) => item.dropID.toString(),
                                    getName: (item) => item.name ?? "",

                                    controller: provider.specializationNameController,
                                    idController: provider.specializationIdController,
                                    hintText: "--Select Option--",
                                    onChanged: (value) {
                                      print(provider.specializationIdController.text
                                          .toString());
                                      print(provider.specializationNameController.text
                                          .toString());
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    ),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Departmental Details",
                              style: Styles.semiBoldTextStyle(
                                  size: 14, color: kWhite),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Administrative department', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.adminDeptController,
                                "Administrative department",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text
                            ),
                          ),

                          hSpace(4),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Employee ID', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.empIdController,
                                "Employee ID",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text
                                ),
                          ),

                          hSpace(4),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('SIPF Number', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.sipfNoController,
                                "SIPF Number",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text
                            ),
                          ),

                          hSpace(4),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Designation', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.designationController,
                                "Designation",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text
                            ),
                          ),

                          hSpace(4),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Date of joining',
                                required: true),
                          ),
                          InkWell(
                            onTap: () {
                              FocusScope.of(context).requestFocus(FocusNode());
                              showDatePickerYearMonthDialogCounselorOTR(
                                context,
                                provider.dateOfJoinController,
                                DateTime.now(),
                                DateTime(DateTime.now().year - 100),
                                DateTime.now(),
                              ).then((_) {
                                setState(() {});
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.dateOfJoinController,
                                "Date of joining",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Date of Retirement',
                                required: true),
                          ),
                          InkWell(
                              onTap: () {
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                showDatePickerYearMonthDialogCounselorOTR(
                                  context,
                                  provider.dateOfRetireController,
                                  DateTime.now(), // initialDate
                                  DateTime(DateTime.now().year -
                                      100), // firstDate
                                  DateTime.now(), // lastDate
                                ).then((_) {
                                  setState(() {});
                                });
                              },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.dateOfRetireController,
                                "Date of Retirement",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: false,
                                boxColor: fafafaColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Year of Professional Experience', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.proExpYearController,
                                " Year of Professional Experience ",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text
                            ),
                          ),

                          hSpace(4),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Posted Department', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.postDeptController,
                                "Posted Department",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text
                            ),
                          ),

                          hSpace(4),
                        ],
                      ),
                    ),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Highest Education Details",
                              style: Styles.semiBoldTextStyle(
                                  size: 14, color: kWhite),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Highest Qualification',
                                required: true),
                          ),

                          IgnorePointer(
                            ignoring: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child:
                              buildSearchableDropdown<EducationLevelData>(
                               // items: provider.educationLevelsList,
                                items: provider.educationLevelsList
                                    .where((item) => item.dropID == 5 || item.dropID == 6 || item.dropID == 8)
                                    .toList(),
                                // ✅ MAP YOUR MODEL HERE
                                getId: (item) => item.dropID.toString(),
                                getName: (item) => item.name ?? "",

                                controller:
                                provider.educationLevelNameController,
                                idController:
                                provider.educationLevelIdController,
                                hintText: "--Select Option--",

                                onChanged: (value) async {
                                    await provider.degreeTypeApi(context, value.dropID.toString());
                                    setState(() {});
                                },
                              )
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Degree',
                                required: true),
                          ),

                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildSearchableDropdown<GraduationTypeData>(
                                items: provider.graduationTypeList,

                                // ✅ MAP YOUR MODEL HERE
                                getId: (item) => item.dropID.toString(),
                                getName: (item) => item.name ?? "",

                                controller: provider.graduationTypeNameController,
                                idController: provider.graduationTypeIdController,
                                hintText: "--Select Option--",
                                // height: 50,
                                // color: Colors.transparent,
                                // borderRadius: BorderRadius.circular(8),
                                onChanged: (value) {},
                              ),
                            ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Specialization / Subject', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.speSubController,
                                "Specialization / Subject",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('University / Institution Name', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildSearchableDropdown<UniversityData>(
                              items: provider.universityList,

                              // ✅ MAP YOUR MODEL HERE
                              getId: (item) => item.dropID.toString(),
                              getName: (item) => item.name ?? "",

                              controller: provider.universityNameController,
                              idController: provider.universityIdController,
                              hintText: "--Select Option--",
                              // height: 50,
                              // color: Colors.transparent,
                              // borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {},
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Passing Year', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildSearchableDropdown<PassingYearData>(
                              items: provider.passingYearList,

                              // ✅ MAP YOUR MODEL HERE
                              getId: (item) => item.dropID.toString(),
                              getName: (item) => item.name ?? "",

                              controller: provider.yearOfPassingNameController,
                              idController: provider.yearOfPassingIdController,
                              hintText: "--Select Option--",
                              // height: 50,
                              // color: Colors.transparent,
                              // borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {},
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Additional Qualification(if any)', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.addQualiController,
                                "Additional Qualification(if any)",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text
                            ),
                          ),

                        ],
                      ),
                    ),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Skill Set / Domain Expertise",
                              style: Styles.semiBoldTextStyle(
                                  size: 14, color: kWhite),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Primary Domain Expertise',
                                required: true),
                          ),

                          IgnorePointer(
                            ignoring: false,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child:
                                buildSearchableDropdown<PrimaryDomainData>(
                                  items: provider.primaryDomainList,
                                  // ✅ MAP YOUR MODEL HERE
                                  getId: (item) => item.dropID.toString(),
                                  getName: (item) => item.name ?? "",

                                  controller:
                                  provider.primaryDomainNameController,
                                  idController:
                                  provider.primaryDomainIdController,
                                  hintText: "--Select Option--",

                                  onChanged: (value) async {
                                    // await provider.degreeTypeApi(context, value.dropID.toString());
                                    // setState(() {});
                                  },
                                )
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Certificate/ Course Name', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.certCourseController,
                                "Certificate/ Course Name",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Issuing Organization', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.issuOrgController,
                                "Issuing Organization",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Year of Completion', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildSearchableDropdown<PassingYearData>(
                              items: provider.passingYearList,

                              // ✅ MAP YOUR MODEL HERE
                              getId: (item) => item.dropID.toString(),
                              getName: (item) => item.name ?? "",

                              controller: provider.compYearNameController,
                              idController: provider.compYearIdController,
                              hintText: "--Select Option--",
                              // height: 50,
                              // color: Colors.transparent,
                              // borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {},
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Language Proficiency', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildSearchableDropdown<LanguageTypeData>(
                              items: provider.languageKnownList
                                  .where((item) => item.dropID == 1 || item.dropID == 2 || item.dropID == 3 || item.dropID == 4 || item.dropID == 5 || item.dropID == 6)
                                  .toList(),

                              // ✅ MAP YOUR MODEL HERE
                              getId: (item) => item.dropID.toString(),
                              getName: (item) => item.name ?? "",

                              controller: provider.langProfNameController,
                              idController: provider.langProfIdController,
                              hintText: "--Select Option--",
                              // height: 50,
                              // color: Colors.transparent,
                              // borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {},
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Counseling Medium', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildSearchableDropdown<CounselingMediumData>(
                              items: provider.counsMedList,

                              // ✅ MAP YOUR MODEL HERE
                              getId: (item) => item.dropID.toString(),
                              getName: (item) => item.name ?? "",

                              controller: provider.counsMedNameController,
                              idController: provider.counsMedIdController,
                              hintText: "--Select Option--",
                              // height: 50,
                              // color: Colors.transparent,
                              // borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {},
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Technical Tools Proficiency', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildSearchableDropdown<TechToolData>(
                              items: provider.techToolList,

                              // ✅ MAP YOUR MODEL HERE
                              getId: (item) => item.dropID.toString(),
                              getName: (item) => item.name ?? "",

                              controller: provider.techToolNameController,
                              idController: provider.techToolIdController,
                              hintText: "--Select Option--",
                              // height: 50,
                              // color: Colors.transparent,
                              // borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {},
                            ),
                          ),


                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Years Of Experience in Counseling', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.yearExpController,
                                "Years Of Experience in Counseling",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Are you registered clinical psychologist?', required: false),
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'Yes',
                                    groupValue: provider.clinicalPsychologistController.text,
                                    onChanged: (val) => setState(() =>
                                    provider.clinicalPsychologistController.text = val ?? ""),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Yes',
                                    style: Styles.mediumTextStyle(
                                        color: kBlackColor, size: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'No',
                                    groupValue: provider.clinicalPsychologistController.text,
                                    onChanged: (val) => setState(() =>
                                    provider.clinicalPsychologistController.text = val ?? ""),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'No',
                                    style: Styles.mediumTextStyle(
                                        color: kBlackColor, size: 14),
                                  ),
                                ],
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),

                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 70,
                            decoration: BoxDecoration(
                              color: kPrimaryColor,
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10)),
                            ),
                            padding: EdgeInsets.all(10),
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Additional Details (Optional)",
                              style: Styles.semiBoldTextStyle(
                                  size: 14, color: kWhite),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Published Work / Articles', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.pubWorkArtController,
                                "Published Work / Articles",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text
                            ),
                          ),

                          hSpace(4),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('LinkedIn / Portfolio URL', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.linkPortController,
                                "LinkedIn / Portfolio URL",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text
                            ),
                          ),

                          hSpace(4),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Training / Workshop Conducted', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.trainWorkCondController,
                                "Training / Workshop Conducted",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text
                            ),
                          ),

                          hSpace(4),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Availability for Upskilling', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.availUpskillController,
                                "Availability for Upskilling",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text
                            ),
                          ),

                          hSpace(4),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Preferred Age Group for Counseling', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildSearchableDropdown<PreAgeGroupData>(
                              items: provider.preAgeGroupCounsList,

                              // ✅ MAP YOUR MODEL HERE
                              getId: (item) => item.dropID.toString(),
                              getName: (item) => item.name ?? "",

                              controller: provider.preAgeGroupCounsNameController,
                              idController: provider.preAgeGroupCounsIdController,
                              hintText: "--Select Option--",
                              // height: 50,
                              // color: Colors.transparent,
                              // borderRadius: BorderRadius.circular(8),
                              onChanged: (value) {},
                            ),
                          ),

                          hSpace(4),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Consumer<CounselorOtrProvider>(
                            builder: (context, provider, child) {
                              return Checkbox(
                                value: provider.isDeclarationAccepted,
                                onChanged: (value) {
                                  provider.toggleDeclaration(value ?? false);
                                },
                              );
                            },
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 12),
                              child: Text(
                                "I, hereby declare that the information given above is true to the best of my knowledge and belief and nothing has been concealed therein and I will provide online counseling services free-of-cost and I will not charge any fees for online counseling services.",
                                style: Styles.semiBoldTextStyle(
                                  color: kBlackColor,
                                  size: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                      child: Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Preview logic
                              },
                              child: Text("Preview"),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                if (validateCounsellorForm(context, provider)) {
                                  confirmAlertDialog(
                                    context,
                                    "Confirm Submission",
                                    "Are you sure you want to submit the form?",
                                        (value) {
                                      if (value.toString() == "success") {
                                        //provider.submitCounsellorFormApi(context);
                                      }
                                    },
                                  );
                                }
                              },
                              child: Text("Submit"),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                //_resetForm(context);
                              },
                              child: Text("Reset"),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
               // ),

              ),
            ),
          );
        }));
  }

}
bool validateCounsellorForm(BuildContext context, CounselorOtrProvider provider) {

  // ✅ PROFILE IMAGE
  if (provider.profileFile == null) {
    showAlertError("Please upload profile photo", context);
    return false;
  }

  // ✅ BASIC DETAILS
  // if (provider.fullNameController.text.isEmpty) {
  //   showAlertError("Please enter Full Name", context);
  //   return false;
  // }

  // if (provider.dateOfBirthController.text.isEmpty) {
  //   showAlertError("Please select Date of Birth", context);
  //   return false;
  // }

  // if (provider.mobileNumberController.text.isEmpty) {
  //   showAlertError("Please enter Mobile Number", context);
  //   return false;
  // }

  // if (provider.mobileNumberController.text.length != 10) {
  //   showAlertError("Mobile number must be 10 digits", context);
  //   return false;
  // }

  if (provider.emailController.text.isEmpty) {
    showAlertError("Please enter Email Address", context);
    return false;
  }

  if (provider.emailErrorText != null) {
    showAlertError("Please enter valid Email", context);
    return false;
  }

  if (provider.languageIdController.text.isEmpty) {
    showAlertError("Please select Preferred Language", context);
    return false;
  }

  if (provider.specializationIdController.text.isEmpty) {
    showAlertError("Please select Specialization", context);
    return false;
  }

  // ✅ DEPARTMENT DETAILS
  if (provider.adminDeptController.text.isEmpty) {
    showAlertError("Please enter Administrative Department", context);
    return false;
  }

  if (provider.empIdController.text.isEmpty) {
    showAlertError("Please enter Employee ID", context);
    return false;
  }

  if (provider.sipfNoController.text.isEmpty) {
    showAlertError("Please enter SIPF Number", context);
    return false;
  }

  if (provider.designationController.text.isEmpty) {
    showAlertError("Please enter Designation", context);
    return false;
  }

  if (provider.dateOfJoinController.text.isEmpty) {
    showAlertError("Please select Date of Joining", context);
    return false;
  }

  if (provider.dateOfRetireController.text.isEmpty) {
    showAlertError("Please select Date of Retirement", context);
    return false;
  }

  if (provider.proExpYearController.text.isEmpty) {
    showAlertError("Please enter Professional Experience", context);
    return false;
  }

  if (provider.postDeptController.text.isEmpty) {
    showAlertError("Please enter Posted Department", context);
    return false;
  }

  // ✅ EDUCATION DETAILS
  if (provider.educationLevelIdController.text.isEmpty) {
    showAlertError("Please select Highest Qualification", context);
    return false;
  }

  if (provider.graduationTypeIdController.text.isEmpty) {
    showAlertError("Please select Degree", context);
    return false;
  }

  if (provider.speSubController.text.isEmpty) {
    showAlertError("Please enter Specialization / Subject", context);
    return false;
  }

  if (provider.universityIdController.text.isEmpty) {
    showAlertError("Please select University", context);
    return false;
  }

  if (provider.yearOfPassingIdController.text.isEmpty) {
    showAlertError("Please select Passing Year", context);
    return false;
  }

  if (provider.addQualiController.text.isEmpty) {
    showAlertError("Please enter Additional Qualification", context);
    return false;
  }

  // ✅ SKILL SET
  if (provider.primaryDomainIdController.text.isEmpty) {
    showAlertError("Please select Primary Domain", context);
    return false;
  }

  if (provider.certCourseController.text.isEmpty) {
    showAlertError("Please enter Certificate/Course Name", context);
    return false;
  }

  if (provider.issuOrgController.text.isEmpty) {
    showAlertError("Please enter Issuing Organization", context);
    return false;
  }

  if (provider.compYearIdController.text.isEmpty) {
    showAlertError("Please select Year of Completion", context);
    return false;
  }

  if (provider.langProfIdController.text.isEmpty) {
    showAlertError("Please select Language Proficiency", context);
    return false;
  }

  if (provider.counsMedIdController.text.isEmpty) {
    showAlertError("Please select Counseling Medium", context);
    return false;
  }

  if (provider.techToolIdController.text.isEmpty) {
    showAlertError("Please select Technical Tools", context);
    return false;
  }

  if (provider.yearExpController.text.isEmpty) {
    showAlertError("Please enter Years of Experience", context);
    return false;
  }

  if (provider.clinicalPsychologistController.text.isEmpty) {
    showAlertError("Please select if you are a registered clinical psychologist", context);
    return false;
  }

  // ✅ ADDITIONAL DETAILS

  if (provider.pubWorkArtController.text.isEmpty) {
    showAlertError("Please enter Published Work / Articles", context);
    return false;
  }

  if (provider.linkPortController.text.isEmpty) {
    showAlertError("Please enter LinkedIn / Portfolio URL", context);
    return false;
  }

//
// // Optional: basic URL check
//   if (!provider.linkPortController.text.startsWith("http")) {
//     showAlertError("Please enter valid URL (starting with http/https)", context);
//     return false;
//   }

  if (provider.trainWorkCondController.text.isEmpty) {
    showAlertError("Please enter Training / Workshop Conducted", context);
    return false;
  }

  if (provider.availUpskillController.text.isEmpty) {
    showAlertError("Please enter Availability for Upskilling", context);
    return false;
  }

  if (provider.preAgeGroupCounsIdController.text.isEmpty) {
    showAlertError("Please select Preferred Age Group", context);
    return false;
  }

  // ✅ DECLARATION
  if (!provider.isDeclarationAccepted) {
    showAlertError("Please accept declaration", context);
    return false;
  }

  return true;
}
