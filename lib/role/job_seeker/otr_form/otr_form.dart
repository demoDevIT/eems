import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/main.dart';
import 'package:rajemployment/role/job_seeker/addeducationaldetail/provider/add_educational_detail_provider.dart';
import 'package:rajemployment/role/job_seeker/otr_form/modal/language_list_modal.dart';
import 'package:rajemployment/role/job_seeker/otr_form/provider/otr_form_provider.dart';

import '../../../utils/dot_border.dart';
import '../../../utils/dropdown.dart';
import '../../../utils/global.dart';
import '../../../utils/images.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../../../utils/user_new.dart';
import '../educationdetail/modal/profile_qualication_info_list_modal.dart';
import '../loginscreen/provider/locale_provider.dart';
import 'modal/fetch_jan_adhar_modal.dart';

//748272210000018

class OtrFormScreen extends StatefulWidget {
  List<FetchJanAdharResponseData> feachJanAadhaarDataList = [];
  String janMemberId;
  String ssoId;
  String userID;

  OtrFormScreen(
      {super.key,
      required this.feachJanAadhaarDataList,
      required this.janMemberId,
      required this.ssoId,
      required this.userID});

  @override
  State<OtrFormScreen> createState() =>
      _OtrFormScreenState(feachJanAadhaarDataList, janMemberId, ssoId, userID);
}

class _OtrFormScreenState extends State<OtrFormScreen> {
  String janMemberId;
  String ssoId;
  String userID;
  List<FetchJanAdharResponseData> feachJanAadhaarDataList = [];

  _OtrFormScreenState(
      this.feachJanAadhaarDataList, this.janMemberId, this.ssoId, this.userID);

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<OtrFormProvider>(context, listen: false);
      provider.clearData();
      provider.getDistrictMasterApi(context);
      provider.educationLevelApi(context);
      provider.ncoCodeApi(context);
      provider.educationLevelApi(context);
      provider.ncoCodeApi(context);
      provider.mediumOfEducationApi(context);
      provider.courseNatureApi(context);
      provider.passingYearModalApi(context);
      provider.gradeTypeApi(context);
      provider.universityApi(context);
      provider.employmentTypeApi(context);
      provider.regionListApi(context);
      provider.getCategoryTypeDetailsApi(context);
      provider.proficiencyTypeApi(context);
      provider.languageTypeModaltApi(context);
      provider.religionApi(context);
      provider.uidTypeApi(context);
      provider.setJanAadhaarControllers(
          context, feachJanAadhaarDataList[0], ssoId);

      provider.areYouSkilledController.text = 'No'; // default
      provider.areYouInterestedRsldcNameController.text = 'Yes'; // or 'No'
    });
  }

  @override
  Widget build(BuildContext context) {
    // Small device padding / sizing
    final double spacing = 12;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2(
            "OTR Form", context, localeProvider.currentLanguage, "", false, "",
            onTapClick: () {
          localeProvider.toggleLocale();
        }),
        body: Consumer<OtrFormProvider>(builder: (context, provider, child) {
          return SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 5, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 5, vertical: 5),
                      child: Text(
                          'Dear aspirant, please use your own SSO_ID while apply',
                          textAlign: TextAlign.center,
                          style: Styles.semiBoldTextStyle(size: 16)),
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

                                  // ✅ 25 KB validation
                                  if (fileSizeInKB > 25) {
                                    showAlertError(
                                      "Image size must be less than 25 KB",
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
                              "1.Basic Details",
                              style: Styles.semiBoldTextStyle(
                                  size: 14, color: kWhite),
                            ),
                          ),
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
                            child:
                                labelWithStar('Date of Birth', required: true),
                          ),
                          InkWell(
                            onTap: () {
                              /* FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              showDatePickerDialog(
                                context,
                                provider.dateOfBirthController,
                                DateTime.now(), // initialDate
                                DateTime(DateTime
                                    .now()
                                    .year - 1), // firstDate
                                DateTime.now(), // lastDate
                              ).then((_) {
                                setState(() {});
                              }).catchError((error) {
                                setState(() {});
                              });*/
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
                                labelWithStar('Fathers Name', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.fatherNameController,
                              "Enter father name",
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
                            child: labelWithStar('Marital Status',
                                required: false),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.maritalStatusController,
                              "Enter marital status",
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
                            child: labelWithStar('Caste', required: false),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.castController,
                              "Enter caste",
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
                            child: labelWithStar('Aadhaar Reference No.',
                                required: false),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.aadhaarRefNOController,
                              "Enter Aadhaar Reference No.",
                              MediaQuery.of(context).size.width,
                              50,
                              TextInputType.number,
                              isEnabled: false,
                              boxColor: fafafaColor,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Minority', required: false),
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'Yes',
                                    groupValue:
                                        provider.minorityController.text,
                                    onChanged: (val) => setState(() => provider
                                            .minorityController.text =
                                        val ??
                                            provider.minorityController.text),
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
                                    groupValue:
                                        provider.minorityController.text,
                                    onChanged: (val) => setState(() => provider
                                            .minorityController.text =
                                        val ??
                                            provider.minorityController.text),
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
                            ],
                          ),

                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Religion', required: true),
                          ),
                          IgnorePointer(
                            ignoring: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderField(
                                items: provider.religionList,
                                controller: provider.religionNameController,
                                idController: provider.religionIdController,
                                hintText: "--Select Option--",
                                height: 50,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                onChanged: (value) {
                                  print(provider.religionIdController.text
                                      .toString());
                                  print(provider.religionNameController.text
                                      .toString());
                                  setState(() {});
                                },
                              ),
                            ),
                          ),

                          provider.religionIdController.text == "135"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: buildTextWithBorderField(
                                    provider.religionOtherNameController,
                                    "Other Religion",
                                    MediaQuery.of(context).size.width,
                                    50,
                                    TextInputType.number,
                                  ),
                                )
                              : SizedBox(),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Differently Abled(PWD)',
                                required: true),
                          ),

                          Row(
                            children: [
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'Yes',
                                    groupValue: provider
                                        .differentlyAbledController.text,
                                    onChanged: (val) => setState(() => provider
                                            .differentlyAbledController.text =
                                        val ??
                                            provider.differentlyAbledController
                                                .text),
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
                                    groupValue: provider
                                        .differentlyAbledController.text,
                                    onChanged: (val) => setState(() => provider
                                            .differentlyAbledController.text =
                                        val ??
                                            provider.differentlyAbledController
                                                .text),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'No',
                                    style: Styles.mediumTextStyle(
                                        color: kBlackColor, size: 14),
                                  ),
                                ],
                              ),
                              const SizedBox(width: 12),
                            ],
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
                            child: labelWithStar('Family Annual Income(INR)',
                                required: false),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.familyIncomeController,
                              "Enter family annual income(INR)",
                              MediaQuery.of(context).size.width,
                              50,
                              TextInputType.number,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('UID Type', required: true),
                          ),
                          IgnorePointer(
                            ignoring: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderField(
                                items: provider.uidTypeList,
                                controller: provider.uidTypeNameController,
                                idController: provider.uidTypeIdController,
                                hintText: "--Select Option--",
                                height: 50,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                onChanged: (value) {
                                  print(value);
                                  provider.selectedUIDTypeData = value;

                                  // 🔥 RESET UID FIELD WHEN UID TYPE CHANGES
                                  provider.uidNOController.clear();
                                  provider.uidErrorText = null;

                                  provider.notifyListeners();
                                },
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('UID No.', required: true),
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 10, vertical: 5),
                          //   child: buildTextWithBorderField(
                          //     provider.uidNOController,
                          //     "Enter uid no.",
                          //     MediaQuery
                          //         .of(context)
                          //         .size
                          //         .width,
                          //     50,
                          //     TextInputType.text,
                          //     textLenght: 25
                          //   ),
                          // ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Consumer<OtrFormProvider>(
                              builder: (context, provider, _) {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    buildTextWithBorderField(
                                      provider.uidNOController,
                                      "Enter UID ",
                                      MediaQuery.of(context).size.width,
                                      50,
                                      TextInputType.text,
                                      textLenght: 25,
                                      fun: (value) {
                                        provider.validateUid(
                                            value); // 🔥 real-time check
                                      },
                                    ),
                                    if (provider.uidErrorText != null)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4, left: 8),
                                        child: Text(
                                          provider.uidErrorText!,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                  ],
                                );
                              },
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Linkedin Profile URL',
                                required: false),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.linkedinController,
                              "Enter linkedin profile URL",
                              MediaQuery.of(context).size.width,
                              50,
                              TextInputType.text,
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
                              "2.Permanent Address As Per Jan Aadhaar(If any change please update on jan Aadhaar)",
                              style: Styles.semiBoldTextStyle(
                                  size: 14, color: kWhite),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery.of(context).size.width *
                                      0.90 /
                                      2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      labelWithStar('District ',
                                          required: true),

                                      /* Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text( "District",
                                    style: Styles.mediumTextStyle(
                                        color: kBlackColor, size: 14)),
                              ),
                            ),*/
                                      /* IgnorePointer(
                              ignoring: provider.sameAsAbove,
                              child: buildDropdownWithBorderField(
                                items: provider.districtList,
                                controller: provider.districtNameController,
                                idController: provider.districtIdController,
                                hintText:"Select District",
                                height: 50,
                                color: Colors.transparent,
                                width: MediaQuery.of(context).size.width * 0.90 / 2,
                                borderRadius: BorderRadius.circular(8),
                                onChanged: (value) {
                                  final id = provider.districtIdController.text;
                                  if (id.isEmpty) return;
                                  try {
                                    final selectedRole = provider.districtList.firstWhere((item) => item.dropID.toString() == id);
                                    provider.getCityMasterApi(context, selectedRole.dropID.toString(),false);
                                    provider.assemblyListApi(context, selectedRole.dISTRICTID.toString());
                                    setState(() {});
                                  } catch (e) {
                                    debugPrint("Error finding selected role: $e");
                                  }

                                  },
                              ),
                            ),*/
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 5),
                                        child: buildTextWithBorderField(
                                            provider.districtNameController,
                                            "Select District",
                                            MediaQuery.of(context).size.width,
                                            50,
                                            TextInputType.emailAddress,
                                            isEnabled: false),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery.of(context).size.width *
                                      0.90 /
                                      2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      labelWithStar('City ', required: true),
                                      /*Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text( "City",
                                    style: Styles.mediumTextStyle(
                                        color: kBlackColor, size: 14)),
                              ),
                            ),*/

                                      /*IgnorePointer(
                              ignoring: provider.sameAsAbove,
                              child: buildDropdownWithBorderField(
                                items: provider.cityList,
                                controller: provider.cityNameController,
                                idController: provider.cityIdController,
                                hintText:"Select City",
                                height: 50,
                                color: Colors.transparent,
                                width: MediaQuery.of(context).size.width * 0.90 / 2,
                                borderRadius: BorderRadius.circular(8),
                                onChanged: (value) {
                                  final id = provider.cityIdController.text;
                                  if (id.isEmpty) return;
                                  try {
                                    final selectedRole = provider.cityList.firstWhere((item) => item.dropID.toString() == id);
                                    provider.getWardMasterApi(context, selectedRole.dropID.toString(),false);
                                    setState(() {});
                                  } catch (e) {
                                    debugPrint("Error finding selected role: $e");
                                  }
                                },
                              ),
                            ),*/

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 5),
                                        child: buildTextWithBorderField(
                                            provider.cityNameController,
                                            "Select City",
                                            MediaQuery.of(context).size.width,
                                            50,
                                            TextInputType.emailAddress,
                                            isEnabled: false),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery.of(context).size.width *
                                      0.90 /
                                      2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      labelWithStar('Ward ', required: true),
                                      /*Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text( "Ward",
                                    style: Styles.mediumTextStyle(
                                        color: kBlackColor, size: 14)),
                              ),
                            ),*/
                                      /*   IgnorePointer(
                              ignoring: provider.sameAsAbove, // set to false to re-enable
                              child: buildDropdownWithBorderField(
                                items: provider.wardList,
                                controller: provider.wardNameController,
                                idController: provider.wardIdController,
                                hintText:"Select Ward",
                                height: 50,
                                color: Colors.transparent,
                                width: MediaQuery.of(context).size.width * 0.90 / 2,
                                borderRadius: BorderRadius.circular(8),
                                isEnable: false,
                                onChanged: (value) {
                                  setState(() {

                                  });
                                },
                              ),
                            ),*/
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 5),
                                        child: buildTextWithBorderField(
                                            provider.wardNameController,
                                            "Select Ward",
                                            MediaQuery.of(context).size.width,
                                            50,
                                            TextInputType.emailAddress,
                                            isEnabled: false),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery.of(context).size.width *
                                      0.90 /
                                      2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      labelWithStar('Territory Type ',
                                          required: true),
                                      /* Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text( "Territory Type",
                                    style: Styles.mediumTextStyle(
                                        color: kBlackColor, size: 14)),
                              ),
                            ),*/

                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Radio<String>(
                                            value: "Rural",
                                            groupValue: provider.territoryType,
                                            onChanged: (val) => setState(() =>
                                                provider.territoryType = val!),
                                            visualDensity:
                                                VisualDensity.compact,
                                            // reduce space inside
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                          const Text("Rural"),
                                          SizedBox(width: 10),
                                          // Add space between the radio buttons
                                          Radio<String>(
                                            value: "Urban",
                                            groupValue: provider.territoryType,
                                            onChanged: (val) => setState(() =>
                                                provider.territoryType = val!),
                                            visualDensity:
                                                VisualDensity.compact,
                                            // reduce space inside
                                            materialTapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                          const Text("Urban"),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Address', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.addressController,
                                "Address",
                                MediaQuery.of(context).size.width,
                                80,
                                TextInputType.emailAddress,
                                maxLine: 20,
                                isEnabled: provider.sameAsAbove == false
                                    ? false
                                    : false),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Pin Code', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.pinCodeController,
                                "Pin Code",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                isEnabled: provider.sameAsAbove == false
                                    ? false
                                    : false,
                                textLenght: 6),
                          ),

                          /// Communication Address
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              children: [
                                labelWithStar('Communication Address',
                                    required: false),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: provider.sameAsAbove,
                                      onChanged: (value) {
                                        provider.sameAsAbove = value!;
                                        // print(value);
                                        if (value == true) {
                                          provider.cDistrictIdController.text =
                                              provider
                                                  .districtIdController.text;
                                          provider.cDistrictNameController
                                                  .text =
                                              provider
                                                  .districtNameController.text;
                                          provider.cCityNameController.text =
                                              provider.cityNameController.text;
                                          provider.cCityIdController.text =
                                              provider.cityIdController.text;
                                          provider.cWardIdController.text =
                                              provider.wardIdController.text;
                                          provider.cWardNameController.text =
                                              provider.wardNameController.text;
                                          provider.cTerritoryType =
                                              provider.territoryType;
                                          provider.cTerritoryTypeID =
                                              provider.territoryTypeID;
                                          provider.cAddressController.text =
                                              provider.addressController.text;
                                          provider.cPinCodeController.text =
                                              provider.pinCodeController.text;
                                          final selectedRole = provider
                                              .cDistrictList
                                              .firstWhere((item) =>
                                                  item.dropID.toString() ==
                                                  provider.districtIdController
                                                      .text);
                                          provider.assemblyListApi(
                                              context,
                                              selectedRole.dISTRICTID
                                                  .toString());
                                        } else {
                                          provider.cDistrictIdController.text =
                                              "";
                                          provider.cDistrictNameController
                                              .text = "";
                                          provider.cCityNameController.text =
                                              "";
                                          provider.cCityIdController.text = "";
                                          provider.cWardIdController.text = "";
                                          provider.cWardNameController.text =
                                              "";
                                          provider.cTerritoryType = "";
                                          provider.cTerritoryTypeID = "";
                                          provider.cAddressController.text = "";
                                          provider.cPinCodeController.text = "";
                                          provider.assemblyIDController.text =
                                              "";
                                          provider.assemblyNameController.text =
                                              "";
                                          provider.constituencyIDController
                                              .text = "";
                                          provider.constituencyNameController
                                              .text = "";
                                          provider.assemblyList.clear();
                                          provider.parliamentListDataList
                                              .clear();
                                        }
                                        setState(() {});
                                      },
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            6), // adjust radius
                                      ),
                                      side: const BorderSide(
                                        color: kDartGrayColor,
                                        width: 2,
                                      ),
                                      // border color
                                      activeColor: kPrimaryColor,
                                      checkColor: Colors.white,
                                      fillColor: MaterialStateProperty
                                          .resolveWith<Color>(
                                        (states) {
                                          if (states.contains(
                                              MaterialState.selected)) {
                                            return kPrimaryColor;
                                          }
                                          return kTextColor1;
                                        },
                                      ),
                                    ),
                                    const Text("Same As Above"),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          hSpace(4),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery.of(context).size.width *
                                      0.90 /
                                      2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      labelWithStar('District', required: true),
                                      /*  Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text( "District",
                                    style: Styles.mediumTextStyle(
                                        color: kBlackColor, size: 14)),
                              ),
                            ),*/
                                      provider.sameAsAbove == false
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 5),
                                              child:
                                                  buildDropdownWithBorderField(
                                                items: provider.cDistrictList,
                                                controller: provider
                                                    .cDistrictNameController,
                                                idController: provider
                                                    .cDistrictIdController,
                                                hintText: "Select District",
                                                height: 50,
                                                color: Colors.transparent,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.90 /
                                                    2,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                onChanged: (value) {
                                                  final id = provider
                                                      .cDistrictIdController
                                                      .text;
                                                  if (id.isEmpty) return;
                                                  try {
                                                    final selectedRole = provider
                                                        .cDistrictList
                                                        .firstWhere((item) =>
                                                            item.dropID
                                                                .toString() ==
                                                            id);
                                                    provider.getCityMasterApi(
                                                        context,
                                                        selectedRole.dropID
                                                            .toString(),
                                                        true);
                                                    provider.assemblyListApi(
                                                        context,
                                                        selectedRole.dISTRICTID
                                                            .toString());

                                                    setState(() {});
                                                  } catch (e) {
                                                    debugPrint(
                                                        "Error finding selected role: $e");
                                                  }
                                                },
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 5),
                                              child: buildTextWithBorderField(
                                                  provider
                                                      .cDistrictNameController,
                                                  "Select District",
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  50,
                                                  isEnabled:
                                                      provider.sameAsAbove ==
                                                              true
                                                          ? false
                                                          : true,
                                                  TextInputType.emailAddress,
                                                  postfixIcon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: fontGrayColor,
                                                  )),
                                            )
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery.of(context).size.width *
                                      0.90 /
                                      2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      labelWithStar('City', required: true),
                                      /*  Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text( "City",
                                    style: Styles.mediumTextStyle(
                                        color: kBlackColor, size: 14)),
                              ),
                            ),
                            */
                                      provider.sameAsAbove == false
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 5),
                                              child:
                                                  buildDropdownWithBorderField(
                                                items: provider.cCityList,
                                                controller: provider
                                                    .cCityNameController,
                                                idController:
                                                    provider.cCityIdController,
                                                hintText: "Select City",
                                                height: 50,
                                                color: Colors.transparent,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.90 /
                                                    2,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                onChanged: (value) {
                                                  final id = provider
                                                      .cCityIdController.text;
                                                  if (id.isEmpty) return;
                                                  try {
                                                    final selectedRole = provider
                                                        .cCityList
                                                        .firstWhere((item) =>
                                                            item.dropID
                                                                .toString() ==
                                                            id);
                                                    provider.getWardMasterApi(
                                                        context,
                                                        selectedRole.dropID
                                                            .toString(),
                                                        true);
                                                    setState(() {});
                                                  } catch (e) {
                                                    debugPrint(
                                                        "Error finding selected role: $e");
                                                  }
                                                },
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 5),
                                              child: buildTextWithBorderField(
                                                  provider.cCityNameController,
                                                  "Select City",
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  50,
                                                  isEnabled:
                                                      provider.sameAsAbove ==
                                                              true
                                                          ? false
                                                          : true,
                                                  TextInputType.emailAddress,
                                                  postfixIcon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: fontGrayColor,
                                                  )),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery.of(context).size.width *
                                      0.90 /
                                      2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      labelWithStar('Ward', required: true),
                                      /* Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text( "Ward",
                                    style: Styles.mediumTextStyle(
                                        color: kBlackColor, size: 14)),
                              ),
                            ),*/
                                      provider.sameAsAbove == false
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 5),
                                              child:
                                                  buildDropdownWithBorderField(
                                                items: provider.cWardList,
                                                controller: provider
                                                    .cWardNameController,
                                                idController:
                                                    provider.cWardIdController,
                                                hintText: "Select Ward",
                                                height: 50,
                                                color: Colors.transparent,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.90 /
                                                    2,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                onChanged: (value) {},
                                                // onChanged: (value) {
                                                //   final id = provider.wardIdController.text;
                                                //   if (id.isEmpty) return;
                                                //
                                                //   print("Selected Ward ID => $id");
                                                //   print("Selected Ward Name => ${provider.wardNameController.text}");
                                                //
                                                //   setState(() {});
                                                // },
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 0,
                                                      vertical: 5),
                                              child: buildTextWithBorderField(
                                                  provider.cWardNameController,
                                                  "Select Ward",
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width,
                                                  50,
                                                  isEnabled:
                                                      provider.sameAsAbove ==
                                                              true
                                                          ? false
                                                          : true,
                                                  TextInputType.emailAddress,
                                                  postfixIcon: Icon(
                                                    Icons.arrow_drop_down,
                                                    color: fontGrayColor,
                                                  )),
                                            ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery.of(context).size.width *
                                      0.90 /
                                      2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      labelWithStar('Territory Type',
                                          required: true),
                                      /*  Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text( "Territory Type",
                                    style: Styles.mediumTextStyle(
                                        color: kBlackColor, size: 14)),
                              ),
                            ),*/

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 5),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Radio<String>(
                                              value: "Rural",
                                              groupValue:
                                                  provider.cTerritoryType,
                                              onChanged: (val) => setState(() =>
                                                  provider.cTerritoryType =
                                                      val!),
                                              visualDensity:
                                                  VisualDensity.compact,
                                              // reduce space inside
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            const Text("Rural"),
                                            SizedBox(width: 10),
                                            // Add space between the radio buttons
                                            Radio<String>(
                                              value: "Urban",
                                              groupValue:
                                                  provider.cTerritoryType,
                                              onChanged: (val) => setState(() =>
                                                  provider.cTerritoryType =
                                                      val!),
                                              visualDensity:
                                                  VisualDensity.compact,
                                              // reduce space inside
                                              materialTapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            const Text("Urban"),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Address', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.cAddressController,
                              "Address",
                              MediaQuery.of(context).size.width,
                              80,
                              maxLine: 20,
                              isEnabled:
                                  provider.sameAsAbove == true ? false : true,
                              TextInputType.emailAddress,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Pin Code', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.cPinCodeController,
                                "Pin Code",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.number,
                                isEnabled:
                                    provider.sameAsAbove == true ? false : true,
                                textLenght: 6),
                          ),

                          hSpace(4),

                          /// Constituency
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Select Constituency',
                                required: false),
                          ),

                          hSpace(16),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery.of(context).size.width *
                                      0.90 /
                                      2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      labelWithStar('Assembly Constituency',
                                          required: true),
                                      /*Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text( "Assembly Constituency",
                                    style: Styles.mediumTextStyle(
                                        color: kBlackColor, size: 14)),
                              ),
                            ),*/
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 5),
                                        child: buildDropdownWithBorderField(
                                          items: provider.assemblyList,
                                          controller:
                                              provider.assemblyNameController,
                                          idController:
                                              provider.assemblyIDController,
                                          hintText:
                                              "Select Assembly Constituency",
                                          height: 50,
                                          color: Colors.transparent,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.90 /
                                              2,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          onChanged: (value) {
                                            final selectedRole = provider
                                                .districtList
                                                .firstWhere((item) =>
                                                    item.dropID.toString() ==
                                                    provider
                                                        .districtIdController
                                                        .text);

                                            provider.getParliamentListApi(
                                                context,
                                                provider
                                                    .assemblyIDController.text,
                                                selectedRole.dISTRICTID
                                                    .toString());
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.centerLeft,
                                  width: MediaQuery.of(context).size.width *
                                      0.90 /
                                      2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      labelWithStar('Parliament Constituency',
                                          required: true),
                                      /*  Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                              child: Align(
                                alignment: Alignment.topLeft,
                                child: Text( "Parliament Constituency",
                                    style: Styles.mediumTextStyle(
                                        color: kBlackColor, size: 14)),
                              ),
                            ),*/

                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 0, vertical: 5),
                                        child: buildDropdownWithBorderField(
                                          items:
                                              provider.parliamentListDataList,
                                          controller: provider
                                              .constituencyNameController,
                                          idController:
                                              provider.constituencyIDController,
                                          hintText:
                                              "Select Parliament Constituency",
                                          height: 50,
                                          color: Colors.transparent,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.90 /
                                              2,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          onChanged: (value) {},
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar(
                                'Exchange Name/District Employment Office',
                                required: false),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('District', required: true),
                          ),
                          IgnorePointer(
                            ignoring: true, // disables the dropdown
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.exchangeDistrictNameController,
                                // already has pre-selected district
                                "Select District",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: false, // disables editing
                              ),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child:
                                labelWithStar('Exchange Name', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.exchangeNameController,
                              "Enter Exchange Name",
                              MediaQuery.of(context).size.width,
                              50,
                              TextInputType.text,
                              isEnabled: false, // ✅ disabled
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
                              "3.Education Details",
                              style: Styles.semiBoldTextStyle(
                                  size: 14, color: kWhite),
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Education Level',
                                required: true),
                          ),

                          IgnorePointer(
                            ignoring: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderField(
                                items: provider.educationLevelsList,
                                controller:
                                    provider.educationLevelNameController,
                                idController:
                                    provider.educationLevelIdController,
                                hintText: "--Select Option--",
                                height: 50,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                onChanged: (value) {
                                  setState(() {
                                    print("test==-->" +
                                        provider.educationLevelIdController.text
                                            .toString());
                                    if (provider.educationLevelIdController.text == "2" ||
                                        provider.educationLevelIdController
                                                .text ==
                                            "5" ||
                                        provider.educationLevelIdController
                                                .text ==
                                            "6" ||
                                        provider.educationLevelIdController
                                                .text ==
                                            "8") {
                                      String id = provider
                                                  .educationLevelIdController
                                                  .text ==
                                              "8"
                                          ? "7"
                                          : provider
                                              .educationLevelIdController.text;
                                      provider.graduationTypeApi(context, id);
                                    } else if (provider
                                            .educationLevelIdController.text ==
                                        "3") {
                                      provider.boardApi(context);
                                    } else if (provider
                                            .educationLevelIdController.text ==
                                        "4") {
                                      provider.boardApi(context);
                                      provider.streamTypeApi(context);
                                    }
                                  });
                                },
                              ),
                            ),
                          ),

                          provider.educationLevelIdController.text == "2"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: labelWithStar('Choose Class',
                                      required: true),
                                )
                              : SizedBox(),

                          Visibility(
                            visible:
                                provider.educationLevelIdController.text == "2"
                                    ? true
                                    : false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderField(
                                items: provider.classList,
                                controller: provider.classNameController,
                                idController: provider.classIdController,
                                hintText: "--Select Option--",
                                height: 50,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                          //below10.................

                          //10th secondary............

                          provider.educationLevelIdController.text == "3" ||
                                  provider.educationLevelIdController.text ==
                                      "4"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: labelWithStar('Board', required: true),
                                )
                              : SizedBox(),

                          Visibility(
                            visible: provider.educationLevelIdController.text ==
                                        "3" ||
                                    provider.educationLevelIdController.text ==
                                        "4"
                                ? true
                                : false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderField(
                                items: provider.boardList,
                                controller: provider.boardNameController,
                                idController: provider.boardIdController,
                                hintText: "--Select Option--",
                                height: 50,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                onChanged: (value) {},
                              ),
                            ),
                          ),

                          provider.educationLevelIdController.text == "2" ||
                                  provider.educationLevelIdController.text ==
                                      "3" ||
                                  provider.educationLevelIdController.text ==
                                      "4"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: labelWithStar('School Name',
                                      required: true),
                                )
                              : SizedBox(),

                          provider.educationLevelIdController.text == "2" ||
                                  provider.educationLevelIdController.text ==
                                      "3" ||
                                  provider.educationLevelIdController.text ==
                                      "4"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: buildTextWithBorderField(
                                    provider.schoolNameController,
                                    "Enter School Name",
                                    MediaQuery.of(context).size.width,
                                    50,
                                    TextInputType.text,
                                  ),
                                )
                              : SizedBox(),

                          provider.educationLevelIdController.text == "4"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child:
                                      labelWithStar('Stream', required: true),
                                )
                              : SizedBox(),

                          Visibility(
                            visible:
                                provider.educationLevelIdController.text == "4"
                                    ? true
                                    : false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderField(
                                items: provider.streamTypeList,
                                controller: provider.streamNameController,
                                idController: provider.streamIdController,
                                hintText: "--Select Option--",
                                height: 50,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                onChanged: (value) {},
                              ),
                            ),
                          ),

                          provider.educationLevelIdController.text == "5" ||
                                  provider.educationLevelIdController.text ==
                                      "6" ||
                                  provider.educationLevelIdController.text ==
                                      "8"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: labelWithStar('Graduation Type',
                                      required: true),
                                )
                              : SizedBox(),

                          Visibility(
                            visible: provider.educationLevelIdController.text ==
                                        "5" ||
                                    provider.educationLevelIdController.text ==
                                        "6" ||
                                    provider.educationLevelIdController.text ==
                                        "8"
                                ? true
                                : false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderField(
                                items: provider.graduationTypeList,
                                controller:
                                    provider.graduationTypeNameController,
                                idController:
                                    provider.graduationTypeIdController,
                                hintText: "--Select Option--",
                                height: 50,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                          (provider.educationLevelIdController.text == "5" &&
                                      provider.graduationTypeIdController
                                              .text ==
                                          "31") ||
                                  (provider.educationLevelIdController.text ==
                                          "6" &&
                                      provider.graduationTypeIdController
                                              .text ==
                                          "90") ||
                                  (provider.educationLevelIdController.text ==
                                          "8" &&
                                      provider.graduationTypeIdController
                                              .text ==
                                          "127")
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: labelWithStar('Other Graduation Type',
                                      required: true),
                                )
                              : SizedBox(),

                          (provider.educationLevelIdController.text == "5" &&
                                      provider.graduationTypeIdController
                                              .text ==
                                          "31") ||
                                  (provider.educationLevelIdController.text ==
                                          "6" &&
                                      provider.graduationTypeIdController
                                              .text ==
                                          "90") ||
                                  (provider.educationLevelIdController.text ==
                                          "8" &&
                                      provider.graduationTypeIdController
                                              .text ==
                                          "127")
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: buildTextWithBorderField(
                                    provider.otherGraduationTypeController,
                                    "Enter Other Graduation Type*",
                                    MediaQuery.of(context).size.width,
                                    50,
                                    TextInputType.text,
                                  ),
                                )
                              : SizedBox(),

                          provider.educationLevelIdController.text == "5" ||
                                  provider.educationLevelIdController.text ==
                                      "6" ||
                                  provider.educationLevelIdController.text ==
                                      "8"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: labelWithStar('University',
                                      required: true),
                                )
                              : SizedBox(),

                          Visibility(
                            visible: provider.educationLevelIdController.text ==
                                        "5" ||
                                    provider.educationLevelIdController.text ==
                                        "6" ||
                                    provider.educationLevelIdController.text ==
                                        "8"
                                ? true
                                : false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderField(
                                items: provider.universityList,
                                controller: provider.universityNameController,
                                idController: provider.universityIdController,
                                hintText: "--Select Option--",
                                height: 50,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ),

                          provider.universityIdController.text == "3"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: labelWithStar('Other University',
                                      required: true),
                                )
                              : SizedBox(),

                          provider.universityIdController.text == "3"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: buildTextWithBorderField(
                                    provider.otherEducationUniversity,
                                    "Enter Other University",
                                    MediaQuery.of(context).size.width,
                                    50,
                                    TextInputType.text,
                                  ),
                                )
                              : SizedBox(),

                          provider.educationLevelIdController.text == "5" ||
                                  provider.educationLevelIdController.text ==
                                      "6" ||
                                  provider.educationLevelIdController.text ==
                                      "8"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child:
                                      labelWithStar('College', required: true),
                                )
                              : SizedBox(),

                          provider.educationLevelIdController.text == "5" ||
                                  provider.educationLevelIdController.text ==
                                      "6" ||
                                  provider.educationLevelIdController.text ==
                                      "8"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: buildTextWithBorderField(
                                    provider.collageNameController,
                                    "Enter College name",
                                    MediaQuery.of(context).size.width,
                                    50,
                                    TextInputType.text,
                                  ),
                                )
                              : SizedBox(),

                          // under graduate / graduate / post graduate.......////

                          provider.educationLevelIdController.text != "1"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: labelWithStar('Medium of Education',
                                      required: true),
                                )
                              : SizedBox(),

                          provider.educationLevelIdController.text != "1"
                              ? IgnorePointer(
                                  ignoring: false,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: buildDropdownWithBorderField(
                                      items: provider.mediumTypeList,
                                      controller: provider
                                          .mediumEducationNameController,
                                      idController:
                                          provider.mediumEducationIdController,
                                      hintText: "--Select Option--",
                                      height: 50,
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      onChanged: (value) {
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                )
                              : SizedBox(),

                          provider.mediumEducationIdController.text == "70"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: labelWithStar(
                                      'Other Medium of Education',
                                      required: true),
                                )
                              : SizedBox(),

                          provider.mediumEducationIdController.text == "70"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: buildTextWithBorderField(
                                    provider.otherMediumEducationController,
                                    "Other Medium of Education",
                                    MediaQuery.of(context).size.width,
                                    50,
                                    TextInputType.text,
                                  ),
                                )
                              : SizedBox(),

                          provider.educationLevelIdController.text != "1"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: labelWithStar('Nature of Course',
                                      required: true),
                                )
                              : SizedBox(),

                          provider.educationLevelIdController.text != "1"
                              ? IgnorePointer(
                                  ignoring: false,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: buildDropdownWithBorderField(
                                      items: provider.courseNatureList,
                                      controller:
                                          provider.natureOfCourseNameController,
                                      idController:
                                          provider.natureOfCourseIdController,
                                      hintText: "--Select Option--",
                                      height: 50,
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      onChanged: (value) {},
                                    ),
                                  ),
                                )
                              : SizedBox(),

                          provider.educationLevelIdController.text != "1"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: labelWithStar('Year of Passing',
                                      required: true),
                                )
                              : SizedBox(),

                          provider.educationLevelIdController.text != "1"
                              ? InkWell(
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());
                                    showDatePickerYearMonthDialog(
                                      context,
                                      provider.yearOfPassingNameController,
                                      DateTime.now(), // initialDate
                                      DateTime(DateTime.now().year -
                                          100), // firstDate
                                      DateTime.now(), // lastDate
                                    ).then((_) {
                                      setState(() {});
                                    }).catchError((error) {
                                      setState(() {});
                                    });
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: buildTextWithBorderField(
                                      provider.yearOfPassingNameController,
                                      "--Select Option--",
                                      MediaQuery.of(context).size.width,
                                      50,
                                      TextInputType.text,
                                      isEnabled: false,
                                    ),
                                  ),
                                )
                              : SizedBox(),

                          provider.educationLevelIdController.text != "1"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child:
                                      labelWithStar('NCO Code', required: true),
                                )
                              : SizedBox(),

                          provider.educationLevelIdController.text != "1"
                              ? IgnorePointer(
                                  ignoring: false,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: buildDropdownWithBorderField(
                                      items: provider.ncoCodeList,
                                      controller:
                                          provider.ncoCodeNameController,
                                      idController:
                                          provider.ncoCodeIdController,
                                      hintText: "--Select Option--",
                                      height: 50,
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(8),
                                      onChanged: (value) {},
                                    ),
                                  ),
                                )
                              : SizedBox(),

                          provider.educationLevelIdController.text != "1"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    'Note:- Please select the NCO code based on your Qualification',
                                    style: TextStyle(
                                        fontSize: 12, color: Colors.red),
                                  ),
                                )
                              : SizedBox(),

                          hSpace(18),

                          provider.educationLevelIdController.text != "1"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: labelWithStar('Result Type',
                                      required: true),
                                )
                              : SizedBox(),

                          provider.educationLevelIdController.text != "1"
                              ? Row(
                                  children: [
                                    Row(
                                      children: [
                                        Radio<String>(
                                          value: 'Grade',
                                          groupValue: provider.resultType,
                                          onChanged: (val) {
                                            provider.resultType = val!;
                                            setState(() {
                                              provider.gradeTypeNameController
                                                  .text = "";
                                              provider.gradeTypeIdController
                                                  .text = "";
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Grade',
                                          style: Styles.mediumTextStyle(
                                              color: kBlackColor, size: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Row(
                                      children: [
                                        Radio<String>(
                                          value: 'Percentage',
                                          groupValue: provider.resultType,
                                          onChanged: (val) {
                                            provider.resultType = val!;
                                            setState(() {
                                              provider.gradeTypeNameController
                                                  .text = "";
                                              provider.gradeTypeIdController
                                                  .text = "";
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'Percentage',
                                          style: Styles.mediumTextStyle(
                                              color: kBlackColor, size: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 12),
                                    Row(
                                      children: [
                                        Radio<String>(
                                          value: 'CGPA',
                                          groupValue: provider.resultType,
                                          onChanged: (val) {
                                            provider.resultType = val!;
                                            setState(() {
                                              provider.gradeTypeNameController
                                                  .text = "";
                                              provider.gradeTypeIdController
                                                  .text = "";
                                            });
                                          },
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          'CGPA',
                                          style: Styles.mediumTextStyle(
                                              color: kBlackColor, size: 14),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : SizedBox(),

                          provider.educationLevelIdController.text != "1"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: labelWithStar(provider.resultType,
                                      required: true),
                                )
                              : SizedBox(),

                          provider.educationLevelIdController.text != "1" &&
                                  provider.resultType != "Grade"
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: buildTextWithBorderField(
                                    provider.gradeTypeNameController,
                                    'Enter ${provider.resultType}',
                                    MediaQuery.of(context).size.width,
                                    50,
                                    TextInputType.text,
                                  ),
                                )
                              : SizedBox(),

                          Visibility(
                            visible:
                                provider.resultType == "Grade" ? true : false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderField(
                                items: provider.gradeTypeList,
                                controller: provider.gradeTypeNameController,
                                idController: provider.gradeTypeIdController,
                                hintText: "--Select Option--",
                                height: 50,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                onChanged: (value) {},
                              ),
                            ),
                          ),

                          hSpace(10),
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
                              "4.Employment Details/Work Experience",
                              style: Styles.semiBoldTextStyle(
                                  size: 14, color: kWhite),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Current Employment Status',
                                required: true),
                          ),
                          IgnorePointer(
                            ignoring: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderField(
                                items: provider.employmentTypesList,
                                controller: provider
                                    .currentEmploymentStatusNameController,
                                idController: provider
                                    .currentEmploymentStatusIdController,
                                hintText: "--Select Option--",
                                height: 50,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Experience(In Years)',
                                required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.expYearController,
                              "Enter Experience(In Years)",
                              MediaQuery.of(context).size.width,
                              50,
                              TextInputType.number,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Experience(In Month)',
                                required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.expMonthController,
                              "Enter Experience(In Month)",
                              MediaQuery.of(context).size.width,
                              50,
                              TextInputType.number,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('International Jobs',
                                required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar(
                                'Are you interested in international jobs?',
                                required: false),
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'Yes',
                                    groupValue: provider
                                        .areYouInterestedInternational.text,
                                    onChanged: (val) {
                                      provider.areYouInterestedInternational
                                              .text =
                                          val ??
                                              provider
                                                  .areYouInterestedInternational
                                                  .text;
                                      //  provider.employmentFilterList();
                                      setState(() {});
                                    },
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
                                    groupValue: provider
                                        .areYouInterestedInternational.text,
                                    onChanged: (val) {
                                      provider.areYouInterestedInternational
                                              .text =
                                          val ??
                                              provider
                                                  .areYouInterestedInternational
                                                  .text;
                                      // provider.employmentFilterList();
                                      setState(() {});
                                    },
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
                          if (provider.areYouInterestedInternational.text ==
                              'Yes') ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Select Region',
                                  required: true),
                            ),
                            IgnorePointer(
                              ignoring: false,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: buildDropdownWithBorderField(
                                  items: provider.preferredRegionList,
                                  controller: provider.regionNameController,
                                  idController: provider.regionIdController,
                                  hintText: "--Select Option--",
                                  height: 50,
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(8),
                                  onChanged: (value) {},
                                ),
                              ),
                            ),
                            hSpace(10),
                          ]
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
                              "5.Skills and Languages Details(Add Atleast one Skill)",
                              style: Styles.semiBoldTextStyle(
                                  size: 14, color: kWhite),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Are you Skilled',
                                required: true),
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  // Radio<String>(
                                  //   value: 'Yes',
                                  //   groupValue:
                                  //   provider.areYouSkilledController.text,
                                  //   onChanged: (val) =>
                                  //       setState(() =>
                                  //       provider
                                  //           .areYouSkilledController.text =
                                  //           val ??
                                  //               provider.areYouSkilledController
                                  //                   .text),
                                  // ),
                                  Radio<String>(
                                    value: 'Yes',
                                    groupValue:
                                        provider.areYouSkilledController.text,
                                    onChanged: (val) {
                                      setState(() {
                                        provider.areYouSkilledController.text =
                                            val!;
                                      });
                                    },
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
                                  // Radio<String>(
                                  //   value: 'No',
                                  //   groupValue:
                                  //   provider.areYouSkilledController.text,
                                  //   onChanged: (val) =>
                                  //       setState(() =>
                                  //       provider
                                  //           .areYouSkilledController.text =
                                  //           val ??
                                  //               provider.areYouSkilledController
                                  //                   .text),
                                  // ),
                                  Radio<String>(
                                    value: 'No',
                                    groupValue:
                                        provider.areYouSkilledController.text,
                                    onChanged: (val) {
                                      setState(() {
                                        provider.areYouSkilledController.text =
                                            val!;
                                      });
                                    },
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
                          if (provider.areYouSkilledController.text ==
                              'No') ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar(
                                'Are you interested in RSLDC Skill training?',
                                required: true,
                              ),
                            ),
                            Row(
                              children: [
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'Yes',
                                      groupValue: provider
                                          .areYouInterestedRsldcNameController
                                          .text,
                                      onChanged: (val) {
                                        setState(() {
                                          provider
                                              .areYouInterestedRsldcNameController
                                              .text = val!;
                                        });
                                      },
                                    ),
                                    Text('Yes'),
                                  ],
                                ),
                                const SizedBox(width: 12),
                                Row(
                                  children: [
                                    Radio<String>(
                                      value: 'No',
                                      groupValue: provider
                                          .areYouInterestedRsldcNameController
                                          .text,
                                      onChanged: (val) {
                                        setState(() {
                                          provider
                                              .areYouInterestedRsldcNameController
                                              .text = val!;
                                        });
                                      },
                                    ),
                                    Text('No'),
                                  ],
                                ),
                              ],
                            ),
                          ],
                          if (provider.areYouSkilledController.text ==
                              'Yes') ...[
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Skill Category',
                                  required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderField(
                                items: provider.categoryList,
                                controller: provider.categoryNameController,
                                idController: provider.categoryIdController,
                                hintText: "--Select Option--",
                                height: 50,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                onChanged: (value) {
                                  provider.getSubCategoryTypeDetailsApi(
                                    context,
                                    provider.categoryIdController.text,
                                  );
                                },
                              ),
                            ),

                            // Preferred Location
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: labelWithStar('Skill Sub Category',
                                  required: true),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderField(
                                items: provider.subCategoryList,
                                controller: provider.subCategoryNameController,
                                idController: provider.subCategoryIdController,
                                hintText: "--Select Option--",
                                height: 50,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                onChanged: (value) {},
                              ),
                            ),
                          ],
                          hSpace(20),
                          Divider(
                            height: 1,
                            color: E3E5F9Color,
                            thickness: 10,
                          ),
                          hSpace(15),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Languages', required: true),
                          ),
                          IgnorePointer(
                            ignoring: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderField(
                                items: provider.languageKnownList,
                                controller: provider.languageNameController,
                                idController: provider.languageIdController,
                                hintText: "--Select Option--",
                                height: 50,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Proficiency', required: true),
                          ),
                          IgnorePointer(
                            ignoring: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: buildDropdownWithBorderField(
                                items: provider.proficiencyTypeList,
                                controller: provider.proficiencyNameController,
                                idController: provider.proficiencyIdController,
                                hintText: "--Select Option--",
                                height: 50,
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                                onChanged: (value) {},
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              CheckboxListTile(
                                title: const Text('Read'),
                                value: provider.read,
                                onChanged: (v) =>
                                    setState(() => provider.read = v ?? false),
                              ),
                              CheckboxListTile(
                                title: const Text('Write'),
                                value: provider.write,
                                onChanged: (v) =>
                                    setState(() => provider.write = v ?? false),
                              ),
                              CheckboxListTile(
                                title: const Text('Speak'),
                                value: provider.speak,
                                onChanged: (v) =>
                                    setState(() => provider.speak = v ?? false),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.20,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  if (provider
                                      .languageIdController.text.isEmpty) {
                                    showAlertError(
                                        "Please select language", context);
                                  } else if (provider
                                      .proficiencyIdController.text.isEmpty) {
                                    showAlertError(
                                        "Please select proficiency", context);
                                  } else if (provider.read == false &&
                                      provider.write == false &&
                                      provider.speak == false) {
                                    showAlertError(
                                        "Please select al least one read|write|speak",
                                        context);
                                  } else {
                                    String read =
                                        provider.read == true ? "Read" : "";
                                    String write =
                                        provider.write == true ? "Write" : "";
                                    String speak =
                                        provider.speak == true ? "Speak" : "";

                                    final newId = provider
                                        .languageIdController.text
                                        .trim();
                                    final newName = provider
                                        .languageNameController.text
                                        .trim();

// Check duplicate
                                    bool exists = provider.languageDataList.any(
                                        (item) =>
                                            item.languageId == newId &&
                                            item.languageName.toLowerCase() ==
                                                newName.toLowerCase());

// If exists, do NOT add
                                    if (exists) {
                                      showAlertError(
                                          "Already exists!", context);
                                      print("Already exists!");
                                      return;
                                    }

// Otherwise add new item
                                    provider.languageDataList.add(
                                      LanguageListData(
                                        languageId: newId,
                                        languageName: newName,
                                        proficiencyId: provider
                                            .proficiencyIdController.text
                                            .trim(),
                                        proficiencyName: provider
                                            .proficiencyNameController.text
                                            .trim(),
                                        read: read,
                                        write: write,
                                        speak: speak,
                                        checkRead: provider.read,
                                        checkwrite: provider.write,
                                        checkspeak: provider.speak,
                                      ),
                                    );
                                    provider.languageIdController.text = "";
                                    provider.languageNameController.text = "";
                                    provider.proficiencyIdController.text = "";
                                    provider.proficiencyNameController.text =
                                        "";
                                    provider.read = false;
                                    provider.write = false;
                                    provider.speak = false;
                                    setState(() {});
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: kPrimaryColor, // nicer blue
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Text('Add',
                                    maxLines: 1,
                                    //added these line for set 1 line
                                    softWrap: false,
                                    //added these line for set 'add' in 1 line
                                    overflow: TextOverflow.visible,
                                    //added these line for set 'add' in 1 line
                                    style: TextStyle(
                                        fontSize: 16, color: Colors.white)),
                              ),
                            ),
                          ),
                          hSpace(20),
                          Divider(
                            height: 1,
                            color: E3E5F9Color,
                            thickness: 10,
                          ),
                          hSpace(10),
                          ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            // disable scroll inside scroll
                            shrinkWrap: true,
                            // make it take only the space needed
                            itemCount: provider.languageDataList.length,
                            itemBuilder: (context, index) {
                              var number = index + 1;
                              return InkWell(
                                onTap: () {},
                                child: Container(
                                  margin: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    color: kWhite,
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: borderColor),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        hSpace(5),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              width: 50,
                                              height: 50,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                color: kbuttonColor,
                                                borderRadius:
                                                    BorderRadius.circular(50),
                                              ),
                                              child: Text(
                                                number.toString(),
                                                style: Styles.semiBoldTextStyle(
                                                    size: 16, color: kWhite),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.70,
                                              alignment: Alignment.centerLeft,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      provider
                                                          .languageDataList[
                                                              index]
                                                          .languageName
                                                          .toString(),
                                                      style: Styles
                                                          .semiBoldTextStyle(
                                                              size: 16,
                                                              color:
                                                                  kBlackColor)),
                                                  Text(
                                                      provider
                                                          .languageDataList[
                                                              index]
                                                          .proficiencyName
                                                          .toString(),
                                                      style: Styles
                                                          .mediumTextStyle(
                                                              size: 14,
                                                              color:
                                                                  fontGrayColor)),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          provider
                                                              .languageDataList[
                                                                  index]
                                                              .read
                                                              .toString(),
                                                          style: Styles
                                                              .mediumTextStyle(
                                                                  size: 14,
                                                                  color:
                                                                      fontGrayColor)),
                                                      vSpace(2),
                                                      Text(
                                                          provider
                                                              .languageDataList[
                                                                  index]
                                                              .write
                                                              .toString(),
                                                          style: Styles
                                                              .mediumTextStyle(
                                                                  size: 14,
                                                                  color:
                                                                      fontGrayColor)),
                                                      vSpace(2),
                                                      Text(
                                                          provider
                                                              .languageDataList[
                                                                  index]
                                                              .speak
                                                              .toString(),
                                                          style: Styles
                                                              .mediumTextStyle(
                                                                  size: 14,
                                                                  color:
                                                                      fontGrayColor)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                            InkWell(
                                                onTap: () {
                                                  provider.languageDataList
                                                      .removeAt(index);
                                                  setState(() {});
                                                },
                                                child: Icon(
                                                  Icons.delete,
                                                  color: kbuttonColor,
                                                  size: 20,
                                                ))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          hSpace(10),
                        ],
                      ),
                    ),

                    // Add button
                    const SizedBox(height: 24),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (validateBasicDetails(context, provider)) {
                            confirmAlertDialog(
                              context,
                              "Confirm Submission",
                              "Are you sure you want to submit the form ?",
                              (value) {
                                if (value.toString() == "success") {
                                  provider.sendSMSApi(
                                      context,
                                      feachJanAadhaarDataList,
                                      janMemberId,
                                      userID);
                                }
                              },
                            );
                            // NEXT STEP
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor, // nicer blue
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: const Text('Save',
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        }));
  }
}

bool validateBasicDetails(BuildContext context, provider) {
  // ✅ Image validation
  if (provider.profileFile == null) {
    showAlertError("Please upload Photo", context);
    return false;
  }

  // Full Name
  if (provider.fullNameController.text.isEmpty) {
    showAlertError("Please enter Full Name", context);
    return false;
  }

  // DOB
  if (provider.dateOfBirthController.text.isEmpty) {
    showAlertError("Please select Date of Birth", context);
    return false;
  }

  // Mobile Number
  if (provider.mobileNumberController.text.isEmpty) {
    showAlertError("Please enter Mobile Number", context);
    return false;
  }
  if (provider.mobileNumberController.text.length != 10) {
    showAlertError("Mobile number must be 10 digits", context);
    return false;
  }

  // Father Name
  if (provider.fatherNameController.text.isEmpty) {
    showAlertError("Please enter Father’s Name", context);
    return false;
  }

  // Email
  if (provider.emailController.text.isEmpty) {
    showAlertError("Please enter Email Address", context);
    return false;
  }
  final emailReg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailReg.hasMatch(provider.emailController.text)) {
    showAlertError("Please enter valid Email Address", context);
    return false;
  }

  // Religion Dropdown
  if (provider.religionIdController.text.isEmpty) {
    showAlertError("Please select Religion", context);
    return false;
  }

  // Differently Abled
  if (provider.differentlyAbledController.text.isEmpty) {
    showAlertError("Please enter Differently Abled (PWD)", context);
    return false;
  }

  // Gender (Male / Female / Transgender)
  if (provider.genderController.text.isEmpty) {
    showAlertError("Please select Gender", context);
    return false;
  }

  // UID Type Dropdown
  if (provider.uidTypeIdController.text.isEmpty) {
    showAlertError("Please select UID Type", context);
    return false;
  }

  // UID Number
  if (provider.uidNOController.text.isEmpty) {
    showAlertError("Please enter UID Number", context);
    return false;
  }

  // 1. District
  if (provider.districtNameController.text.isEmpty) {
    showAlertError("Please select District", context);
    return false;
  }

  // 2. City
  if (provider.cityNameController.text.isEmpty) {
    showAlertError("Please select City", context);
    return false;
  }

  // 3. Ward
  if (provider.wardNameController.text.isEmpty) {
    showAlertError("Please select Ward", context);
    return false;
  }

  // 4. Territory Type (Rural / Urban)
  if (provider.territoryType.isEmpty) {
    showAlertError("Please select Territory Type (Rural / Urban)", context);
    return false;
  }

  // 5. Address
  if (provider.addressController.text.trim().isEmpty) {
    showAlertError("Please enter Address", context);
    return false;
  }

  // 6. Pin Code Required
  if (provider.pinCodeController.text.trim().isEmpty) {
    showAlertError("Please enter Pin Code", context);
    return false;
  }

  // 7. Validate Pin Code Length
  if (provider.pinCodeController.text.length != 6) {
    showAlertError("Pin Code must be 6 digits", context);
    return false;
  }

  if (provider.sameAsAbove == true) {
    if (provider.cDistrictNameController.text.isEmpty) {
      showAlertError("District (Communication) is missing", context);
      return false;
    }

    if (provider.cCityNameController.text.isEmpty) {
      showAlertError("City (Communication) is missing", context);
      return false;
    }

    if (provider.cWardNameController.text.isEmpty) {
      showAlertError("Ward (Communication) is missing", context);
      return false;
    }

    if (provider.cTerritoryType.toString().isEmpty) {
      showAlertError("Please select Territory Type (Rural / Urban)", context);
      return false;
    }

    if (provider.cAddressController.text.trim().isEmpty) {
      showAlertError("Please enter Communication Address", context);
      return false;
    }

    if (provider.cPinCodeController.text.isEmpty) {
      showAlertError("Please enter Communication Pin Code", context);
      return false;
    }

    if (provider.cPinCodeController.text.length != 6) {
      showAlertError("Communication Pin Code must be 6 digits", context);
      return false;
    }
  }

  if (provider.cDistrictNameController.text.isEmpty) {
    showAlertError("Please select District", context);
    return false;
  }

  if (provider.cCityNameController.text.isEmpty) {
    showAlertError("Please select City", context);
    return false;
  }

  if (provider.cWardNameController.text.isEmpty) {
    showAlertError("Please select Ward", context);
    return false;
  }

  if (provider.cTerritoryType.toString().isEmpty) {
    showAlertError("Please select Territory Type (Rural / Urban)", context);
    return false;
  }

  if (provider.cAddressController.text.trim().isEmpty) {
    showAlertError("Please enter Address", context);
    return false;
  }

  if (provider.cPinCodeController.text.isEmpty) {
    showAlertError("Please enter Pin Code", context);
    return false;
  }

  if (provider.cPinCodeController.text.length != 6) {
    showAlertError("Pin Code must be 6 digits", context);
    return false;
  }
  if (provider.assemblyNameController.text.isEmpty) {
    showAlertError("Please select assembly", context);
    return false;
  }

  if (provider.constituencyNameController.text.isEmpty) {
    showAlertError("Please select parliament", context);
    return false;
  }
  if (provider.exchangeDistrictNameController.text.isEmpty) {
    showAlertError("Please select exchange district", context);
    return false;
  }
  if (provider.exchangeNameController.text.isEmpty) {
    showAlertError("Please enter exchange", context);
    return false;
  }

  // 1️⃣ Education Level Required
  if (provider.educationLevelIdController.text.isEmpty) {
    showAlertError("Please select Education Level", context);
    return false;
  }

  String level = provider.educationLevelIdController.text;

  // 2️⃣ Class required for level = 2
  if (level == "2" && provider.classIdController.text.isEmpty) {
    showAlertError("Please select Class", context);
    return false;
  }

  // 3️⃣ Board required for 3 & 4
  if ((level == "3" || level == "4") &&
      provider.boardIdController.text.isEmpty) {
    showAlertError("Please select Board", context);
    return false;
  }

  // 4️⃣ School Name required for 2,3,4
  if ((level == "2" || level == "3" || level == "4") &&
      provider.schoolNameController.text.isEmpty) {
    showAlertError("Please enter School Name", context);
    return false;
  }

  // 5️⃣ Stream required for level=4
  if (level == "4" && provider.streamIdController.text.isEmpty) {
    showAlertError("Please select Stream", context);
    return false;
  }

  // 6️⃣ Graduation Type required for 5,6,8
  if ((level == "5" || level == "6" || level == "8") &&
      provider.graduationTypeIdController.text.isEmpty) {
    showAlertError("Please select Graduation Type", context);
    return false;
  }

  // 7️⃣ Other Graduation Type required for specific IDs
  if ((level == "5" && provider.graduationTypeIdController.text == "31") ||
      (level == "6" && provider.graduationTypeIdController.text == "90") ||
      (level == "8" && provider.graduationTypeIdController.text == "127")) {
    if (provider.otherGraduationTypeController.text.isEmpty) {
      showAlertError("Please enter Other Graduation Type", context);
      return false;
    }
  }

  // 8️⃣ University Required for 5,6,8
  if ((level == "5" || level == "6" || level == "8") &&
      provider.universityIdController.text.isEmpty) {
    showAlertError("Please select University", context);
    return false;
  }

  // 9️⃣ Other University required only when id = 3
  if (provider.universityIdController.text == "3" &&
      provider.otherEducationUniversity.text.isEmpty) {
    showAlertError("Please enter Other University", context);
    return false;
  }

  // 🔟 College Required for 5,6,8
  if ((level == "5" || level == "6" || level == "8") &&
      provider.collageNameController.text.isEmpty) {
    showAlertError("Please enter College Name", context);
    return false;
  }

  // 1️⃣1️⃣ Medium Required (for everything except level = 1)
  if (level != "1" && provider.mediumEducationIdController.text.isEmpty) {
    showAlertError("Please select Medium of Education", context);
    return false;
  }

  // 1️⃣2️⃣ Other Medium Required when id=70
  if (provider.mediumEducationIdController.text == "70" &&
      provider.otherMediumEducationController.text.isEmpty) {
    showAlertError("Please enter Other Medium of Education", context);
    return false;
  }

  // 1️⃣3️⃣ Nature of Course Required (except level = 1)
  if (level != "1" && provider.natureOfCourseIdController.text.isEmpty) {
    showAlertError("Please select Nature of Course", context);
    return false;
  }

  // 1️⃣4️⃣ Year of Passing Required
  if (level != "1" && provider.yearOfPassingNameController.text.isEmpty) {
    showAlertError("Please select Year of Passing", context);
    return false;
  }

  // 1️⃣5️⃣ NCO Code Required
  if (level != "1" && provider.ncoCodeIdController.text.isEmpty) {
    showAlertError("Please select NCO Code", context);
    return false;
  }

  // 1️⃣6️⃣ Result Type required
  if (level != "1" && provider.resultType.isEmpty) {
    showAlertError("Please select Result Type", context);
    return false;
  }

  // 1️⃣7️⃣ If Result Type != Grade → enter value
  if (level != "1" &&
      provider.resultType != "Grade" &&
      provider.gradeTypeNameController.text.isEmpty) {
    showAlertError("Please enter ${provider.resultType}", context);
    return false;
  }

  // 1️⃣8️⃣ If Result Type = Grade → grade dropdown required
  // if (level != "1" &&
  //     provider.resultType == "Grade" &&
  //     provider.gradeTypeIdController.text.isEmpty) {
  //   showAlertError("Please select Grade",context);
  //   return false;
  // }

  // Percentage Validation
  if (provider.resultType == "Percentage") {
    final value = provider.gradeTypeNameController.text.trim();

    if (value.isEmpty) {
      showAlertError("Please enter Percentage", context);
      return false;
    }

    if (!isValidPercentage(value)) {
      showAlertError(
        "Percentage can have maximum 2 digits after decimal",
        context,
      );
      return false;
    }

    final percent = double.tryParse(value);
    if (percent == null || percent < 0 || percent > 100) {
      showAlertError(
        "Percentage must be between 0 and 100",
        context,
      );
      return false;
    }
  }

// CGPA Validation
  if (provider.resultType == "CGPA") {
    final value = provider.gradeTypeNameController.text.trim();

    if (value.isEmpty) {
      showAlertError("Please enter CGPA", context);
      return false;
    }

    final cgpa = double.tryParse(value);

    if (cgpa == null) {
      showAlertError("CGPA must be a valid number", context);
      return false;
    }

    if (cgpa < 0 || cgpa > 10) {
      showAlertError("CGPA must be between 0 and 10", context);
      return false;
    }
  }

  // Current Employment Status
  if (provider.currentEmploymentStatusIdController.text.isEmpty) {
    showAlertError("Please select Current Employment Status", context);
    return false;
  }

  // Experience (Year)
  if (provider.expYearController.text.isEmpty) {
    showAlertError("Please enter Experience in Years", context);
    return false;
  }
  if (int.tryParse(provider.expYearController.text) == null) {
    showAlertError("Experience in Years must be a valid number", context);
    return false;
  }

  // Experience (Month)
  if (provider.expMonthController.text.isEmpty) {
    showAlertError("Please enter Experience in Months", context);
    return false;
  }
  if (int.tryParse(provider.expMonthController.text) == null) {
    showAlertError("Experience in Months must be a valid number", context);
    return false;
  }
  if (int.parse(provider.expMonthController.text) > 11) {
    showAlertError("Experience in Months must be between 0 and 11", context);
    return false;
  }

  // International Job Interest (Yes/No)
  if (provider.areYouInterestedInternational.text.isEmpty) {
    showAlertError(
        "Please select whether you are interested in international jobs",
        context);
    return false;
  }

  // Preferred Region
  if (provider.areYouInterestedInternational.text == 'Yes' &&
      provider.regionIdController.text.isEmpty) {
    showAlertError("Please select Preferred Region", context);
    return false;
  }

  // 1. Are You Skilled
  if (provider.areYouSkilledController.text.isEmpty) {
    showAlertError("Please select Are You Skilled (Rural / Urban)", context);
    return false;
  }

  // 🔹 CASE 1: Are You Skilled = NO
  if (provider.areYouSkilledController.text == 'No') {
    if (provider.areYouInterestedRsldcNameController.text.isEmpty) {
      showAlertError(
        "Please select Are you interested in RSLDC Skill Training",
        context,
      );
      return false;
    }
  }

// 🔹 CASE 2: Are You Skilled = YES
  if (provider.areYouSkilledController.text == 'Yes') {
    if (provider.categoryIdController.text.isEmpty) {
      showAlertError("Please select Skill Category", context);
      return false;
    }

    if (provider.subCategoryIdController.text.isEmpty) {
      showAlertError("Please select Skill Sub Category", context);
      return false;
    }
  }

  // 4. Language
  if (provider.languageIdController.text.isEmpty &&
      provider.languageDataList.isEmpty) {
    showAlertError("Please select a Language", context);
    return false;
  }

  // 5. Proficiency
  if (provider.proficiencyIdController.text.isEmpty &&
      provider.languageDataList.isEmpty) {
    showAlertError("Please select Proficiency", context);
    return false;
  }

  // 6. At least one Read/Write/Speak must be selected
  if (provider.read == false &&
      provider.write == false &&
      provider.speak == false &&
      provider.languageDataList.isEmpty) {
    showAlertError(
        "Please select at least one option: Read / Write / Speak", context);
    return false;
  }

  // 7. At least one skill/language must be added in list
  if (provider.languageDataList.isEmpty) {
    showAlertError("Please click on add button", context);
    return false;
  }

  return true;
}

bool isValidPercentage(String value) {
  final reg = RegExp(r'^\d{1,3}(\.\d{1,2})?$');
  return reg.hasMatch(value);
}
