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
import '../../job_seeker/addjobpreference/modal/language_type_modal.dart';
import '../../job_seeker/loginscreen/provider/locale_provider.dart';
import '../../job_seeker/otr_form/modal/fetch_jan_adhar_modal.dart';
import 'package:rajemployment/role/counselor/counsellor_otr/provider/counsellor_otr_provider.dart';

import 'modal/specialization_modal.dart';

class CounselorOtrScreen extends StatefulWidget {
  List<FetchJanAdharResponseData>? feachJanAadhaarDataList = [];
  String? janMemberId;
  String ssoId;
  String userID;

  CounselorOtrScreen(
      {super.key,
        this.feachJanAadhaarDataList,
        this.janMemberId,
        required this.ssoId,
       required this.userID
  });

  @override
  State<CounselorOtrScreen> createState() =>
      _CounselorOtrScreenState();
}

class _CounselorOtrScreenState extends State<CounselorOtrScreen> {
  String? janMemberId;
  String? ssoId;
  String? userID;
  List<FetchJanAdharResponseData> feachJanAadhaarDataList = [];

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
      provider.languageTypeModaltApi(context);
      provider.specializationApi(context);
      provider.educationLevelApi(context);

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
                                    onChanged: (val) => setState(() => provider
                                        .genderController.text =
                                        val ?? provider.genderController.text),
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
                                    onChanged: (val) => setState(() => provider
                                        .genderController.text =
                                        val ?? provider.genderController.text),
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
                                    onChanged: (val) => setState(() => provider
                                        .genderController.text =
                                        val ?? provider.genderController.text),
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
                              showDatePickerYearMonthDialog(
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
                                showDatePickerYearMonthDialog(
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

