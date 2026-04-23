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
import '../../job_seeker/loginscreen/provider/locale_provider.dart';
import '../../job_seeker/otr_form/modal/fetch_jan_adhar_modal.dart';
import 'provider/counsellor_otr_provider.dart';

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
     // provider.clearData();
      // provider.getDistrictMasterApi(context);
      // provider.educationLevelApi(context);
      // provider.ncoCodeApi(context);
      // provider.educationLevelApi(context);
      // provider.ncoCodeApi(context);
      // provider.mediumOfEducationApi(context);
      // provider.courseNatureApi(context);
      // provider.passingYearModalApi(context);
      // provider.gradeTypeApi(context);
      // provider.universityApi(context);
      // provider.employmentTypeApi(context);
      // provider.regionListApi(context);
      // provider.getCategoryTypeDetailsApi(context);
      // provider.proficiencyTypeApi(context);
      // provider.languageTypeModaltApi(context);
      // provider.religionApi(context);
      // provider.disabilityTypeApi(context);
      // provider.uidTypeApi(context);
      // provider.setJanAadhaarControllers(
      //     context, feachJanAadhaarDataList[0], ssoId);
      //
      // provider.areYouSkilledController.text = 'No'; // default
      // provider.areYouInterestedRsldcNameController.text = 'Yes'; // or 'No'
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
                                  // child:
                                  // buildSearchableDropdown<EducationLevelData>(
                                  //   items: provider.educationLevelsList,
                                  //
                                  //   // ✅ MAP YOUR MODEL HERE
                                  //   getId: (item) => item.dropID.toString(),
                                  //   getName: (item) => item.name ?? "",
                                  //
                                  //   controller:
                                  //   provider.educationLevelNameController,
                                  //   idController:
                                  //   provider.educationLevelIdController,
                                  //   hintText: "--Select Option--",
                                  //
                                  //   onChanged: (value) async {
                                  //     if (value.dropID == 2 ||
                                  //         value.dropID == 5 ||
                                  //         value.dropID == 6 ||
                                  //         value.dropID == 8 ||
                                  //         value.dropID == 382) {
                                  //
                                  //       String id = value.dropID == 8 ? "7" : value.dropID.toString();
                                  //
                                  //       await provider.graduationTypeApi(context, id);
                                  //
                                  //       if (id == "382") {
                                  //         provider.itiMainList =
                                  //             List.from(provider.graduationTypeList);
                                  //       }
                                  //
                                  //       setState(() {});
                                  //     } else if (value.dropID == 3) {
                                  //       provider.boardApi(context);
                                  //     } else if (value.dropID == 4) {
                                  //       provider.boardApi(context);
                                  //       provider.streamTypeApi(context);
                                  //     }
                                  //   },
                                  // )
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
                                  // child:
                                  // buildSearchableDropdown<EducationLevelData>(
                                  //   items: provider.educationLevelsList,
                                  //
                                  //   // ✅ MAP YOUR MODEL HERE
                                  //   getId: (item) => item.dropID.toString(),
                                  //   getName: (item) => item.name ?? "",
                                  //
                                  //   controller:
                                  //   provider.educationLevelNameController,
                                  //   idController:
                                  //   provider.educationLevelIdController,
                                  //   hintText: "--Select Option--",
                                  //
                                  //   onChanged: (value) async {
                                  //     if (value.dropID == 2 ||
                                  //         value.dropID == 5 ||
                                  //         value.dropID == 6 ||
                                  //         value.dropID == 8 ||
                                  //         value.dropID == 382) {
                                  //
                                  //       String id = value.dropID == 8 ? "7" : value.dropID.toString();
                                  //
                                  //       await provider.graduationTypeApi(context, id);
                                  //
                                  //       if (id == "382") {
                                  //         provider.itiMainList =
                                  //             List.from(provider.graduationTypeList);
                                  //       }
                                  //
                                  //       setState(() {});
                                  //     } else if (value.dropID == 3) {
                                  //       provider.boardApi(context);
                                  //     } else if (value.dropID == 4) {
                                  //       provider.boardApi(context);
                                  //       provider.streamTypeApi(context);
                                  //     }
                                  //   },
                                  // )
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
                                provider.cPinCodeController,
                                "Administrative department",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled:
                                provider.sameAsAbove == true ? false : true,
                                textLenght: 6),
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
                                provider.cPinCodeController,
                                "Employee ID",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled:
                                provider.sameAsAbove == true ? false : true,
                                textLenght: 6),
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
                                provider.cPinCodeController,
                                "SIPF Number",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled:
                                provider.sameAsAbove == true ? false : true,
                                textLenght: 6),
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
                                provider.cPinCodeController,
                                "Designation",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled:
                                provider.sameAsAbove == true ? false : true,
                                textLenght: 6),
                          ),

                          hSpace(4),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Date of joining',
                                required: true),
                          ),
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

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Date of Retirement',
                                required: true),
                          ),

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

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Year Of Professional Experience', required: true),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: buildTextWithBorderField(
                                provider.cPinCodeController,
                                "Year Of Professional Experience",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled:
                                provider.sameAsAbove == true ? false : true,
                                textLenght: 6),
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
                                provider.cPinCodeController,
                                "Posted Department",
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled:
                                provider.sameAsAbove == true ? false : true,
                                textLenght: 6),
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
                                // child:
                                // buildSearchableDropdown<EducationLevelData>(
                                //   items: provider.educationLevelsList,
                                //
                                //   // ✅ MAP YOUR MODEL HERE
                                //   getId: (item) => item.dropID.toString(),
                                //   getName: (item) => item.name ?? "",
                                //
                                //   controller:
                                //   provider.educationLevelNameController,
                                //   idController:
                                //   provider.educationLevelIdController,
                                //   hintText: "--Select Option--",
                                //
                                //   onChanged: (value) async {
                                //     if (value.dropID == 2 ||
                                //         value.dropID == 5 ||
                                //         value.dropID == 6 ||
                                //         value.dropID == 8 ||
                                //         value.dropID == 382) {
                                //
                                //       String id = value.dropID == 8 ? "7" : value.dropID.toString();
                                //
                                //       await provider.graduationTypeApi(context, id);
                                //
                                //       if (id == "382") {
                                //         provider.itiMainList =
                                //             List.from(provider.graduationTypeList);
                                //       }
                                //
                                //       setState(() {});
                                //     } else if (value.dropID == 3) {
                                //       provider.boardApi(context);
                                //     } else if (value.dropID == 4) {
                                //       provider.boardApi(context);
                                //       provider.streamTypeApi(context);
                                //     }
                                //   },
                                // )
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar('Degree',
                                required: true),
                          ),

                          Visibility(
                            visible:
                            provider.educationLevelIdController.text == "4"
                                ? true
                                : false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              // child: buildSearchableDropdown<StreamTypeData>(
                              //   items: provider.streamTypeList,
                              //
                              //   // ✅ MAP YOUR MODEL HERE
                              //   getId: (item) => item.dropID.toString(),
                              //   getName: (item) => item.name ?? "",
                              //
                              //   controller: provider.streamNameController,
                              //   idController: provider.streamIdController,
                              //   hintText: "--Select Option--",
                              //   // height: 50,
                              //   // color: Colors.transparent,
                              //   // borderRadius: BorderRadius.circular(8),
                              //   onChanged: (value) {},
                              // ),
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
                              // child: buildSearchableDropdown<
                              //     WorkExpEmploymentTypeData>(
                              //   items: provider.employmentTypesList,
                              //
                              //   // ✅ MAP YOUR MODEL HERE
                              //   getId: (item) => item.dropID.toString(),
                              //   getName: (item) => item.name ?? "",
                              //
                              //   controller: provider
                              //       .currentEmploymentStatusNameController,
                              //   idController: provider
                              //       .currentEmploymentStatusIdController,
                              //   hintText: "--Select Option--",
                              //   // height: 50,
                              //   // color: Colors.transparent,
                              //   // borderRadius: BorderRadius.circular(8),
                              //   onChanged: (value) {},
                              // ),
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
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal: 10, vertical: 5),
                          //   child: labelWithStar('International Jobs',
                          //       required: true),
                          // ),

                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: labelWithStar(
                                'Are you interested in private jobs also?',
                                required: false),
                          ),
                          Row(
                            children: [
                              Row(
                                children: [
                                  Radio<String>(
                                    value: 'Yes',
                                    groupValue:
                                    provider.interestedPrivateJobs.text,
                                    onChanged: (val) {
                                      provider.interestedPrivateJobs.text =
                                          val ??
                                              provider
                                                  .interestedPrivateJobs.text;
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
                                    groupValue:
                                    provider.interestedPrivateJobs.text,
                                    onChanged: (val) {
                                      provider.interestedPrivateJobs.text =
                                          val ??
                                              provider
                                                  .interestedPrivateJobs.text;
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

//                     Card(
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Container(
//                             width: MediaQuery.of(context).size.width,
//                             height: 70,
//                             decoration: BoxDecoration(
//                               color: kPrimaryColor,
//                               border: Border.all(color: Colors.grey.shade300),
//                               borderRadius: BorderRadius.only(
//                                   topLeft: Radius.circular(10),
//                                   topRight: Radius.circular(10)),
//                             ),
//                             padding: EdgeInsets.all(10),
//                             alignment: Alignment.centerLeft,
//                             child: Text(
//                               "5.Skills and Languages Details(Add Atleast one Skill)",
//                               style: Styles.semiBoldTextStyle(
//                                   size: 14, color: kWhite),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 5),
//                             child: labelWithStar('Are you Skilled',
//                                 required: true),
//                           ),
//                           Row(
//                             children: [
//                               Row(
//                                 children: [
//                                   // Radio<String>(
//                                   //   value: 'Yes',
//                                   //   groupValue:
//                                   //   provider.areYouSkilledController.text,
//                                   //   onChanged: (val) =>
//                                   //       setState(() =>
//                                   //       provider
//                                   //           .areYouSkilledController.text =
//                                   //           val ??
//                                   //               provider.areYouSkilledController
//                                   //                   .text),
//                                   // ),
//                                   Radio<String>(
//                                     value: 'Yes',
//                                     groupValue:
//                                     provider.areYouSkilledController.text,
//                                     onChanged: (val) {
//                                       setState(() {
//                                         provider.areYouSkilledController.text =
//                                         val!;
//                                       });
//                                     },
//                                   ),
//
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     'Yes',
//                                     style: Styles.mediumTextStyle(
//                                         color: kBlackColor, size: 14),
//                                   ),
//                                 ],
//                               ),
//                               const SizedBox(width: 12),
//                               Row(
//                                 children: [
//                                   // Radio<String>(
//                                   //   value: 'No',
//                                   //   groupValue:
//                                   //   provider.areYouSkilledController.text,
//                                   //   onChanged: (val) =>
//                                   //       setState(() =>
//                                   //       provider
//                                   //           .areYouSkilledController.text =
//                                   //           val ??
//                                   //               provider.areYouSkilledController
//                                   //                   .text),
//                                   // ),
//                                   Radio<String>(
//                                     value: 'No',
//                                     groupValue:
//                                     provider.areYouSkilledController.text,
//                                     onChanged: (val) {
//                                       setState(() {
//                                         provider.areYouSkilledController.text =
//                                         val!;
//                                       });
//                                     },
//                                   ),
//                                   const SizedBox(width: 4),
//                                   Text(
//                                     'No',
//                                     style: Styles.mediumTextStyle(
//                                         color: kBlackColor, size: 14),
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                           if (provider.areYouSkilledController.text ==
//                               'No') ...[
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 5),
//                               child: labelWithStar(
//                                 'Are you interested in RSLDC Skill training?',
//                                 required: true,
//                               ),
//                             ),
//                             Row(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Radio<String>(
//                                       value: 'Yes',
//                                       groupValue: provider
//                                           .areYouInterestedRsldcNameController
//                                           .text,
//                                       onChanged: (val) {
//                                         setState(() {
//                                           provider
//                                               .areYouInterestedRsldcNameController
//                                               .text = val!;
//                                         });
//                                       },
//                                     ),
//                                     Text('Yes'),
//                                   ],
//                                 ),
//                                 const SizedBox(width: 12),
//                                 Row(
//                                   children: [
//                                     Radio<String>(
//                                       value: 'No',
//                                       groupValue: provider
//                                           .areYouInterestedRsldcNameController
//                                           .text,
//                                       onChanged: (val) {
//                                         setState(() {
//                                           provider
//                                               .areYouInterestedRsldcNameController
//                                               .text = val!;
//                                         });
//                                       },
//                                     ),
//                                     Text('No'),
//                                   ],
//                                 ),
//                               ],
//                             ),
//                           ],
//                           if (provider.areYouSkilledController.text ==
//                               'Yes') ...[
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 5),
//                               child: labelWithStar('Skill Category',
//                                   required: true),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 5),
//                               child: buildDropdownWithBorderField(
//                                 items: provider.categoryList,
//                                 controller: provider.categoryNameController,
//                                 idController: provider.categoryIdController,
//                                 hintText: "--Select Option--",
//                                 height: 50,
//                                 color: Colors.transparent,
//                                 borderRadius: BorderRadius.circular(8),
//                                 onChanged: (value) {
//                                   provider.getSubCategoryTypeDetailsApi(
//                                     context,
//                                     provider.categoryIdController.text,
//                                   );
//                                 },
//                               ),
//                             ),
//
//                             // Preferred Location
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 5),
//                               child: labelWithStar('Skill Sub Category',
//                                   required: true),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 5),
//                               child: buildDropdownWithBorderField(
//                                 items: provider.subCategoryList,
//                                 controller: provider.subCategoryNameController,
//                                 idController: provider.subCategoryIdController,
//                                 hintText: "--Select Option--",
//                                 height: 50,
//                                 color: Colors.transparent,
//                                 borderRadius: BorderRadius.circular(8),
//                                 onChanged: (value) {},
//                               ),
//                             ),
//                           ],
//                           hSpace(20),
//                           Divider(
//                             height: 1,
//                             color: E3E5F9Color,
//                             thickness: 10,
//                           ),
//                           hSpace(15),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 5),
//                             child: labelWithStar('Languages', required: true),
//                           ),
//                           IgnorePointer(
//                             ignoring: false,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 5),
//                               child: buildSearchableDropdown<LanguageTypeData>(
//                                 items: provider.languageKnownList,
//                                 // ✅ MAP YOUR MODEL HERE
//                                 getId: (item) => item.dropID.toString(),
//                                 getName: (item) => item.name ?? "",
//
//                                 controller: provider.languageNameController,
//                                 idController: provider.languageIdController,
//                                 hintText: "--Select Option--",
//                                 // height: 50,
//                                 // color: Colors.transparent,
//                                 // borderRadius: BorderRadius.circular(8),
//                                 onChanged: (value) {},
//                               ),
//                             ),
//                           ),
//                           Padding(
//                             padding: const EdgeInsets.symmetric(
//                                 horizontal: 10, vertical: 5),
//                             child: labelWithStar('Proficiency', required: true),
//                           ),
//                           IgnorePointer(
//                             ignoring: false,
//                             child: Padding(
//                               padding: const EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 5),
//                               child:
//                               buildSearchableDropdown<ProficiencyTypeData>(
//                                 items: provider.proficiencyTypeList,
//
//                                 // ✅ MAP YOUR MODEL HERE
//                                 getId: (item) => item.dropID.toString(),
//                                 getName: (item) => item.name ?? "",
//
//                                 controller: provider.proficiencyNameController,
//                                 idController: provider.proficiencyIdController,
//                                 hintText: "--Select Option--",
//                                 // height: 50,
//                                 // color: Colors.transparent,
//                                 // borderRadius: BorderRadius.circular(8),
//                                 onChanged: (value) {},
//                               ),
//                             ),
//                           ),
//                           Column(
//                             children: [
//                               CheckboxListTile(
//                                 title: const Text('Read'),
//                                 value: provider.read,
//                                 onChanged: (v) =>
//                                     setState(() => provider.read = v ?? false),
//                               ),
//                               CheckboxListTile(
//                                 title: const Text('Write'),
//                                 value: provider.write,
//                                 onChanged: (v) =>
//                                     setState(() => provider.write = v ?? false),
//                               ),
//                               CheckboxListTile(
//                                 title: const Text('Speak'),
//                                 value: provider.speak,
//                                 onChanged: (v) =>
//                                     setState(() => provider.speak = v ?? false),
//                               ),
//                             ],
//                           ),
//                           Align(
//                             alignment: Alignment.center,
//                             child: Container(
//                               width: MediaQuery.of(context).size.width * 0.20,
//                               height: 50,
//                               child: ElevatedButton(
//                                 onPressed: () {
//                                   if (provider
//                                       .languageIdController.text.isEmpty) {
//                                     showAlertError(
//                                         "Please select language", context);
//                                   } else if (provider
//                                       .proficiencyIdController.text.isEmpty) {
//                                     showAlertError(
//                                         "Please select proficiency", context);
//                                   } else if (provider.read == false &&
//                                       provider.write == false &&
//                                       provider.speak == false) {
//                                     showAlertError(
//                                         "Please select al least one read|write|speak",
//                                         context);
//                                   } else {
//                                     String read =
//                                     provider.read == true ? "Read" : "";
//                                     String write =
//                                     provider.write == true ? "Write" : "";
//                                     String speak =
//                                     provider.speak == true ? "Speak" : "";
//
//                                     final newId = provider
//                                         .languageIdController.text
//                                         .trim();
//                                     final newName = provider
//                                         .languageNameController.text
//                                         .trim();
//
// // Check duplicate
//                                     bool exists = provider.languageDataList.any(
//                                             (item) =>
//                                         item.languageId == newId &&
//                                             item.languageName.toLowerCase() ==
//                                                 newName.toLowerCase());
//
// // If exists, do NOT add
//                                     if (exists) {
//                                       showAlertError(
//                                           "Already exists!", context);
//                                       print("Already exists!");
//                                       return;
//                                     }
//
// // Otherwise add new item
//                                     provider.languageDataList.add(
//                                       LanguageListData(
//                                         languageId: newId,
//                                         languageName: newName,
//                                         proficiencyId: provider
//                                             .proficiencyIdController.text
//                                             .trim(),
//                                         proficiencyName: provider
//                                             .proficiencyNameController.text
//                                             .trim(),
//                                         read: read,
//                                         write: write,
//                                         speak: speak,
//                                         checkRead: provider.read,
//                                         checkwrite: provider.write,
//                                         checkspeak: provider.speak,
//                                       ),
//                                     );
//                                     provider.languageIdController.text = "";
//                                     provider.languageNameController.text = "";
//                                     provider.proficiencyIdController.text = "";
//                                     provider.proficiencyNameController.text =
//                                     "";
//                                     provider.read = false;
//                                     provider.write = false;
//                                     provider.speak = false;
//                                     setState(() {});
//                                   }
//                                 },
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: kPrimaryColor, // nicer blue
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(18),
//                                   ),
//                                   elevation: 0,
//                                 ),
//                                 child: const Text('Add',
//                                     maxLines: 1,
//                                     //added these line for set 1 line
//                                     softWrap: false,
//                                     //added these line for set 'add' in 1 line
//                                     overflow: TextOverflow.visible,
//                                     //added these line for set 'add' in 1 line
//                                     style: TextStyle(
//                                         fontSize: 16, color: Colors.white)),
//                               ),
//                             ),
//                           ),
//                           hSpace(20),
//                           Divider(
//                             height: 1,
//                             color: E3E5F9Color,
//                             thickness: 10,
//                           ),
//                           hSpace(10),
//                           ListView.builder(
//                             physics: const BouncingScrollPhysics(),
//                             // disable scroll inside scroll
//                             shrinkWrap: true,
//                             // make it take only the space needed
//                             itemCount: provider.languageDataList.length,
//                             itemBuilder: (context, index) {
//                               var number = index + 1;
//                               return InkWell(
//                                 onTap: () {},
//                                 child: Container(
//                                   margin: const EdgeInsets.all(5),
//                                   decoration: BoxDecoration(
//                                     color: kWhite,
//                                     borderRadius: BorderRadius.circular(10),
//                                     border: Border.all(color: borderColor),
//                                   ),
//                                   child: Padding(
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 10, vertical: 5),
//                                     child: Column(
//                                       crossAxisAlignment:
//                                       CrossAxisAlignment.start,
//                                       children: [
//                                         hSpace(5),
//                                         Row(
//                                           crossAxisAlignment:
//                                           CrossAxisAlignment.center,
//                                           children: [
//                                             Container(
//                                               padding: EdgeInsets.symmetric(
//                                                   horizontal: 10, vertical: 5),
//                                               width: 50,
//                                               height: 50,
//                                               alignment: Alignment.center,
//                                               decoration: BoxDecoration(
//                                                 color: kbuttonColor,
//                                                 borderRadius:
//                                                 BorderRadius.circular(50),
//                                               ),
//                                               child: Text(
//                                                 number.toString(),
//                                                 style: Styles.semiBoldTextStyle(
//                                                     size: 16, color: kWhite),
//                                               ),
//                                             ),
//                                             Container(
//                                               width: MediaQuery.of(context)
//                                                   .size
//                                                   .width *
//                                                   0.70,
//                                               alignment: Alignment.centerLeft,
//                                               padding: EdgeInsets.symmetric(
//                                                   horizontal: 10, vertical: 5),
//                                               child: Column(
//                                                 crossAxisAlignment:
//                                                 CrossAxisAlignment.start,
//                                                 children: [
//                                                   Text(
//                                                       provider
//                                                           .languageDataList[
//                                                       index]
//                                                           .languageName
//                                                           .toString(),
//                                                       style: Styles
//                                                           .semiBoldTextStyle(
//                                                           size: 16,
//                                                           color:
//                                                           kBlackColor)),
//                                                   Text(
//                                                       provider
//                                                           .languageDataList[
//                                                       index]
//                                                           .proficiencyName
//                                                           .toString(),
//                                                       style: Styles
//                                                           .mediumTextStyle(
//                                                           size: 14,
//                                                           color:
//                                                           fontGrayColor)),
//                                                   Row(
//                                                     crossAxisAlignment:
//                                                     CrossAxisAlignment
//                                                         .start,
//                                                     children: [
//                                                       Text(
//                                                           provider
//                                                               .languageDataList[
//                                                           index]
//                                                               .read
//                                                               .toString(),
//                                                           style: Styles
//                                                               .mediumTextStyle(
//                                                               size: 14,
//                                                               color:
//                                                               fontGrayColor)),
//                                                       vSpace(2),
//                                                       Text(
//                                                           provider
//                                                               .languageDataList[
//                                                           index]
//                                                               .write
//                                                               .toString(),
//                                                           style: Styles
//                                                               .mediumTextStyle(
//                                                               size: 14,
//                                                               color:
//                                                               fontGrayColor)),
//                                                       vSpace(2),
//                                                       Text(
//                                                           provider
//                                                               .languageDataList[
//                                                           index]
//                                                               .speak
//                                                               .toString(),
//                                                           style: Styles
//                                                               .mediumTextStyle(
//                                                               size: 14,
//                                                               color:
//                                                               fontGrayColor)),
//                                                     ],
//                                                   ),
//                                                 ],
//                                               ),
//                                             ),
//                                             InkWell(
//                                                 onTap: () {
//                                                   provider.languageDataList
//                                                       .removeAt(index);
//                                                   setState(() {});
//                                                 },
//                                                 child: Icon(
//                                                   Icons.delete,
//                                                   color: kbuttonColor,
//                                                   size: 20,
//                                                 ))
//                                           ],
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                           hSpace(10),
//                         ],
//                       ),
//                     ),
//
//                     // Add button
//                     const SizedBox(height: 24),
//                     SizedBox(
//                       width: MediaQuery.of(context).size.width,
//                       height: 50,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           if (validateBasicDetails(context, provider)) {
//                             confirmAlertDialog(
//                               context,
//                               "Confirm Submission",
//                               "Are you sure you want to submit the form ?",
//                                   (value) {
//                                 if (value.toString() == "success") {
//                                   provider.sendSMSApi(
//                                       context,
//                                       feachJanAadhaarDataList,
//                                       janMemberId,
//                                       userID);
//                                 }
//                               },
//                             );
//                             // NEXT STEP
//                           }
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: kPrimaryColor, // nicer blue
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(18),
//                           ),
//                           elevation: 0,
//                         ),
//                         child: const Text('Save',
//                             style:
//                             TextStyle(fontSize: 16, color: Colors.white)),
//                       ),
//                     ),
//
//                     const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          );
        }));
  }

  // String getGraduationTypeLabel() {
  //   final provider = Provider.of<OtrFormProvider>(context, listen: false);
  //   switch (provider.educationLevelIdController.text) {
  //     case "5":
  //       return "Under Graduation Type";
  //
  //     case "6":
  //       return "Graduation Type";
  //
  //     case "8":
  //       return "Post Graduation Type";
  //
  //     case "382":
  //       return "ITI Trade Type";
  //
  //     default:
  //       return "Graduation Type";
  //   }
  // }
}

// bool validateBasicDetails(BuildContext context, provider) {
//   // ✅ Image validation
//   if (provider.profileFile == null) {
//     showAlertError("Please upload Photo", context);
//     return false;
//   }
//
//   // Full Name
//   if (provider.fullNameController.text.isEmpty) {
//     showAlertError("Please enter Full Name", context);
//     return false;
//   }
//
//   // DOB
//   if (provider.dateOfBirthController.text.isEmpty) {
//     showAlertError("Please select Date of Birth", context);
//     return false;
//   }
//
//   // Mobile Number
//   if (provider.mobileNumberController.text.isEmpty) {
//     showAlertError("Please enter Mobile Number", context);
//     return false;
//   }
//   if (provider.mobileNumberController.text.length != 10) {
//     showAlertError("Mobile number must be 10 digits", context);
//     return false;
//   }
//
//   // Father Name
//   if (provider.fatherNameController.text.isEmpty) {
//     showAlertError("Please enter Father’s Name", context);
//     return false;
//   }
//
//   // Email
//   if (provider.emailController.text.isEmpty) {
//     showAlertError("Please enter Email Address", context);
//     return false;
//   }
//   final emailReg = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
//   if (!emailReg.hasMatch(provider.emailController.text)) {
//     showAlertError("Please enter valid Email Address", context);
//     return false;
//   }
//
//   // Religion Dropdown
//   if (provider.religionIdController.text.isEmpty) {
//     showAlertError("Please select Religion", context);
//     return false;
//   }
//
//   // Differently Abled
//   if (provider.differentlyAbledController.text.isEmpty) {
//     showAlertError("Please enter Differently Abled (PWD)", context);
//     return false;
//   }
//
//   // Disability Validation
//   if (provider.disabilityIdController.text.isNotEmpty) {
//     if (provider.disabilityPercentageController.text.trim().isEmpty) {
//       showAlertError("Please enter Disability Percentage", context);
//       return false;
//     }
//
//     final percent =
//     double.tryParse(provider.disabilityPercentageController.text.trim());
//
//     if (percent == null) {
//       showAlertError("Please enter valid Disability Percentage", context);
//       return false;
//     }
//
//     if (percent < 0 || percent > 100) {
//       showAlertError(
//           "Disability Percentage must be between 0 and 100", context);
//       return false;
//     }
//   }
//
//   // Gender (Male / Female / Transgender)
//   if (provider.genderController.text.isEmpty) {
//     showAlertError("Please select Gender", context);
//     return false;
//   }
//
//   // UID Type Dropdown
//   if (provider.uidTypeIdController.text.isEmpty) {
//     showAlertError("Please select UID Type", context);
//     return false;
//   }
//
//   // UID Number
//   if (provider.uidNOController.text.isEmpty) {
//     showAlertError("Please enter UID Number", context);
//     return false;
//   }
//
//   // 1. District
//   if (provider.districtNameController.text.isEmpty) {
//     showAlertError("Please select District", context);
//     return false;
//   }
//
//   // 2. City
//   if (provider.cityNameController.text.isEmpty) {
//     showAlertError("Please select City", context);
//     return false;
//   }
//
//   // 3. Ward
//   if (provider.wardNameController.text.isEmpty) {
//     showAlertError("Please select Ward", context);
//     return false;
//   }
//
//   // 4. Territory Type (Rural / Urban)
//   if (provider.territoryType.isEmpty) {
//     showAlertError("Please select Territory Type (Rural / Urban)", context);
//     return false;
//   }
//
//   // 5. Address
//   if (provider.addressController.text.trim().isEmpty) {
//     showAlertError("Please enter Address", context);
//     return false;
//   }
//
//   // 6. Pin Code Required
//   if (provider.pinCodeController.text.trim().isEmpty) {
//     showAlertError("Please enter Pin Code", context);
//     return false;
//   }
//
//   // 7. Validate Pin Code Length
//   if (provider.pinCodeController.text.length != 6) {
//     showAlertError("Pin Code must be 6 digits", context);
//     return false;
//   }
//
//   if (provider.sameAsAbove == true) {
//     if (provider.cDistrictNameController.text.isEmpty) {
//       showAlertError("District (Communication) is missing", context);
//       return false;
//     }
//
//     if (provider.cCityNameController.text.isEmpty) {
//       showAlertError("City (Communication) is missing", context);
//       return false;
//     }
//
//     if (provider.cWardNameController.text.isEmpty) {
//       showAlertError("Ward (Communication) is missing", context);
//       return false;
//     }
//
//     if (provider.cTerritoryType.toString().isEmpty) {
//       showAlertError("Please select Territory Type (Rural / Urban)", context);
//       return false;
//     }
//
//     if (provider.cAddressController.text.trim().isEmpty) {
//       showAlertError("Please enter Communication Address", context);
//       return false;
//     }
//
//     if (provider.cPinCodeController.text.isEmpty) {
//       showAlertError("Please enter Communication Pin Code", context);
//       return false;
//     }
//
//     if (provider.cPinCodeController.text.length != 6) {
//       showAlertError("Communication Pin Code must be 6 digits", context);
//       return false;
//     }
//   }
//
//   if (provider.cDistrictNameController.text.isEmpty) {
//     showAlertError("Please select District", context);
//     return false;
//   }
//
//   if (provider.cCityNameController.text.isEmpty) {
//     showAlertError("Please select City", context);
//     return false;
//   }
//
//   if (provider.cWardNameController.text.isEmpty) {
//     showAlertError("Please select Ward", context);
//     return false;
//   }
//
//   if (provider.cTerritoryType.toString().isEmpty) {
//     showAlertError("Please select Territory Type (Rural / Urban)", context);
//     return false;
//   }
//
//   if (provider.cAddressController.text.trim().isEmpty) {
//     showAlertError("Please enter Address", context);
//     return false;
//   }
//
//   if (provider.cPinCodeController.text.isEmpty) {
//     showAlertError("Please enter Pin Code", context);
//     return false;
//   }
//
//   if (provider.cPinCodeController.text.length != 6) {
//     showAlertError("Pin Code must be 6 digits", context);
//     return false;
//   }
//   // if (provider.assemblyNameController.text.isEmpty) {
//   //   showAlertError("Please select assembly", context);
//   //   return false;
//   // }
//   //
//   // if (provider.constituencyNameController.text.isEmpty) {
//   //   showAlertError("Please select parliament", context);
//   //   return false;
//   // }
//   if (provider.exchangeDistrictNameController.text.isEmpty) {
//     showAlertError("Please select exchange district", context);
//     return false;
//   }
//   if (provider.exchangeNameController.text.isEmpty) {
//     showAlertError("Please enter exchange", context);
//     return false;
//   }
//
//   // 1️⃣ Education Level Required
//   if (provider.educationLevelIdController.text.isEmpty) {
//     showAlertError("Please select Education Level", context);
//     return false;
//   }
//
//   String level = provider.educationLevelIdController.text;
//
//   // 2️⃣ Class required for level = 2
//   if (level == "2" && provider.classIdController.text.isEmpty) {
//     showAlertError("Please select Class", context);
//     return false;
//   }
//
//   // 3️⃣ Board required for 3 & 4
//   if ((level == "3" || level == "4") &&
//       provider.boardIdController.text.isEmpty) {
//     showAlertError("Please select Board", context);
//     return false;
//   }
//
//   // 4️⃣ School Name required for 2,3,4
//   if ((level == "2" || level == "3" || level == "4") &&
//       provider.schoolNameController.text.isEmpty) {
//     showAlertError("Please enter School Name", context);
//     return false;
//   }
//
//   // 5️⃣ Stream required for level=4
//   if (level == "4" && provider.streamIdController.text.isEmpty) {
//     showAlertError("Please select Stream", context);
//     return false;
//   }
//
//   // 6️⃣ Graduation Type required for 5,6,8
//   if ((level == "5" || level == "6" || level == "8") &&
//       provider.graduationTypeIdController.text.isEmpty) {
//     showAlertError("Please select Graduation Type", context);
//     return false;
//   }
//
//   // 7️⃣ Other Graduation Type required for specific IDs
//   if ((level == "5" && provider.graduationTypeIdController.text == "31") ||
//       (level == "6" && provider.graduationTypeIdController.text == "90") ||
//       (level == "8" && provider.graduationTypeIdController.text == "127")) {
//     if (provider.otherGraduationTypeController.text.isEmpty) {
//       showAlertError("Please enter Other Graduation Type", context);
//       return false;
//     }
//   }
//
//   // 8️⃣ University Required for 5,6,8
//   if ((level == "5" || level == "6" || level == "8") &&
//       provider.universityIdController.text.isEmpty) {
//     showAlertError("Please select University", context);
//     return false;
//   }
//
//   // 9️⃣ Other University required only when id = 3
//   if (provider.universityIdController.text == "3" &&
//       provider.otherEducationUniversity.text.isEmpty) {
//     showAlertError("Please enter Other University", context);
//     return false;
//   }
//
//   // 🔟 College Required for 5,6,8
//   if ((level == "5" || level == "6" || level == "8") &&
//       provider.collageNameController.text.isEmpty) {
//     showAlertError("Please enter College Name", context);
//     return false;
//   }
//
//   // 1️⃣1️⃣ Medium Required (for everything except level = 1)
//   if (level != "1" && provider.mediumEducationIdController.text.isEmpty) {
//     showAlertError("Please select Medium of Education", context);
//     return false;
//   }
//
//   if ((level == "5" || level == "6" || level == "8") &&
//       provider.graduationStreamTypeIdController.text.isEmpty) {
//     showAlertError("Please select Stream Type", context);
//     return false;
//   }
//
//   if (provider.graduationStreamTypeIdController.text == "-1" &&
//       provider.otherStreamController.text.isEmpty) {
//     showAlertError("Please enter Other Stream", context);
//     return false;
//   }
//
//   // 1️⃣2️⃣ Other Medium Required when id=70
//   if (provider.mediumEducationIdController.text == "70" &&
//       provider.otherMediumEducationController.text.isEmpty) {
//     showAlertError("Please enter Other Medium of Education", context);
//     return false;
//   }
//
//   // 1️⃣3️⃣ Nature of Course Required (except level = 1)
//   if (level != "1" && provider.natureOfCourseIdController.text.isEmpty) {
//     showAlertError("Please select Nature of Course", context);
//     return false;
//   }
//
//   // 1️⃣4️⃣ Year of Passing Required
//   if (level != "1" && provider.yearOfPassingNameController.text.isEmpty) {
//     showAlertError("Please select Year of Passing", context);
//     return false;
//   }
//
//   // 1️⃣5️⃣ NCO Code Required
//   if (level != "1" && provider.ncoCodeIdController.text.isEmpty) {
//     showAlertError("Please select NCO Code", context);
//     return false;
//   }
//
//   // 1️⃣6️⃣ Result Type required
//   if (level != "1" && provider.resultType.isEmpty) {
//     showAlertError("Please select Result Type", context);
//     return false;
//   }
//
//   // 1️⃣7️⃣ If Result Type != Grade → enter value
//   if (level != "1" &&
//       provider.resultType != "Grade" &&
//       provider.gradeTypeNameController.text.isEmpty) {
//     showAlertError("Please enter ${provider.resultType}", context);
//     return false;
//   }
//
//   // 1️⃣8️⃣ If Result Type = Grade → grade dropdown required
//   // if (level != "1" &&
//   //     provider.resultType == "Grade" &&
//   //     provider.gradeTypeIdController.text.isEmpty) {
//   //   showAlertError("Please select Grade",context);
//   //   return false;
//   // }
//
//   // Percentage Validation
//   if (level != "1" && provider.resultType == "Percentage") {
//     final value = provider.gradeTypeNameController.text.trim();
//
//     if (value.isEmpty) {
//       showAlertError("Please enter Percentage", context);
//       return false;
//     }
//
//     if (!isValidPercentage(value)) {
//       showAlertError(
//         "Percentage can have maximum 2 digits after decimal",
//         context,
//       );
//       return false;
//     }
//
//     final percent = double.tryParse(value);
//     if (percent == null || percent < 0 || percent > 100) {
//       showAlertError(
//         "Percentage must be between 0 and 100",
//         context,
//       );
//       return false;
//     }
//   }
//
// // CGPA Validation
//   if (level != "1" && provider.resultType == "CGPA") {
//     final value = provider.gradeTypeNameController.text.trim();
//
//     if (value.isEmpty) {
//       showAlertError("Please enter CGPA", context);
//       return false;
//     }
//
//     final cgpa = double.tryParse(value);
//
//     if (cgpa == null) {
//       showAlertError("CGPA must be a valid number", context);
//       return false;
//     }
//
//     if (cgpa < 0 || cgpa > 10) {
//       showAlertError("CGPA must be between 0 and 10", context);
//       return false;
//     }
//   }
//
//   // Current Employment Status
//   if (provider.currentEmploymentStatusIdController.text.isEmpty) {
//     showAlertError("Please select Current Employment Status", context);
//     return false;
//   }
//
//   // Experience (Year)
//   if (provider.expYearController.text.isEmpty) {
//     showAlertError("Please enter Experience in Years", context);
//     return false;
//   }
//   if (int.tryParse(provider.expYearController.text) == null) {
//     showAlertError("Experience in Years must be a valid number", context);
//     return false;
//   }
//
//   // Experience (Month)
//   if (provider.expMonthController.text.isEmpty) {
//     showAlertError("Please enter Experience in Months", context);
//     return false;
//   }
//   if (int.tryParse(provider.expMonthController.text) == null) {
//     showAlertError("Experience in Months must be a valid number", context);
//     return false;
//   }
//   if (int.parse(provider.expMonthController.text) > 11) {
//     showAlertError("Experience in Months must be between 0 and 11", context);
//     return false;
//   }
//
//   // International Job Interest (Yes/No)
//   if (provider.areYouInterestedInternational.text.isEmpty) {
//     showAlertError(
//         "Please select whether you are interested in international jobs",
//         context);
//     return false;
//   }
//
//   // Preferred Region
//   if (provider.areYouInterestedInternational.text == 'Yes' &&
//       provider.regionIdController.text.isEmpty) {
//     showAlertError("Please select Preferred Region", context);
//     return false;
//   }
//
//   // 1. Are You Skilled
//   if (provider.areYouSkilledController.text.isEmpty) {
//     showAlertError("Please select Are You Skilled (Rural / Urban)", context);
//     return false;
//   }
//
//   // 🔹 CASE 1: Are You Skilled = NO
//   if (provider.areYouSkilledController.text == 'No') {
//     if (provider.areYouInterestedRsldcNameController.text.isEmpty) {
//       showAlertError(
//         "Please select Are you interested in RSLDC Skill Training",
//         context,
//       );
//       return false;
//     }
//   }
//
// // 🔹 CASE 2: Are You Skilled = YES
//   if (provider.areYouSkilledController.text == 'Yes') {
//     if (provider.categoryIdController.text.isEmpty) {
//       showAlertError("Please select Skill Category", context);
//       return false;
//     }
//
//     if (provider.subCategoryIdController.text.isEmpty) {
//       showAlertError("Please select Skill Sub Category", context);
//       return false;
//     }
//   }
//
//   // 4. Language
//   if (provider.languageIdController.text.isEmpty &&
//       provider.languageDataList.isEmpty) {
//     showAlertError("Please select a Language", context);
//     return false;
//   }
//
//   // 5. Proficiency
//   if (provider.proficiencyIdController.text.isEmpty &&
//       provider.languageDataList.isEmpty) {
//     showAlertError("Please select Proficiency", context);
//     return false;
//   }
//
//   // 6. At least one Read/Write/Speak must be selected
//   if (provider.read == false &&
//       provider.write == false &&
//       provider.speak == false &&
//       provider.languageDataList.isEmpty) {
//     showAlertError(
//         "Please select at least one option: Read / Write / Speak", context);
//     return false;
//   }
//
//   // 7. At least one skill/language must be added in list
//   if (provider.languageDataList.isEmpty) {
//     showAlertError("Please click on add button", context);
//     return false;
//   }
//
//   return true;
// }

// bool isValidPercentage(String value) {
//   final reg = RegExp(r'^\d{1,3}(\.\d{1,2})?$');
//   return reg.hasMatch(value);
// }
