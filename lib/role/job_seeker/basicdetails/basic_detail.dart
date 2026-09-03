import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/basicdetails/provider/basic_details_provider.dart';
import 'package:rajemployment/utils/dot_border.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/user_new.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/dropdown.dart';
import '../../../utils/global.dart';
import '../../../utils/images.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../loginscreen/provider/locale_provider.dart';

class BasicDetailsScreen extends StatefulWidget {
  const BasicDetailsScreen({super.key});

  @override
  State<BasicDetailsScreen> createState() => _BasicDetailsScreenState();
}

class _BasicDetailsScreenState extends State<BasicDetailsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
      Provider.of<BasicDetailsProvider>(context, listen: false);
      provider.clearData();
      provider.addData();
    });
  }



  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(

    appBar: commonAppBar2(AppLocalizations.of(context)!.addBasicInfo, context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),

     body: Consumer<BasicDetailsProvider>(builder: (context, provider, child) {
      return  SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          color: kWhite,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.basicDetails,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(
                "("+AppLocalizations.of(context)!.nameAsPerJanAdhar+")",
                style: TextStyle(color: Colors.red, fontSize: 12),
              ),
              const SizedBox(height: 20),

              Center(
                child: Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none, // allow button to overflow a little
                  children: [
                    GestureDetector(
                      onTap: () {
                        showImagePicker(context,
                                (pickedImage) async {
                              if (pickedImage != null) {
                                provider.profileFile = pickedImage;
                                setState(() {});
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
                          width: MediaQuery.of(context).size.width * 0.18,
                          height: MediaQuery.of(context).size.width * 0.18,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.blue, // 👉 Border color
                              width: 3,           // 👉 Border width
                            ),
                          ),
                          child: ClipOval(
                            child:  provider.profileFile != null ? Image.file(File(provider.profileFile!.path,), fit: BoxFit.cover,) :
                            Image.network(
                              checkNullValue(UserData().model.value.latestPhotoPath.toString()).isNotEmpty ? UserData().model.value.latestPhotoPath.toString() :  "" ,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  Images.placeholder,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                          ),
                        )

                      ),
                    ),

                    // ✅ Place edit icon overlapping border
                    Positioned(
                      bottom: 3,  // slightly outside
                      right: -6,   // slightly outside
                      child: GestureDetector(
                        onTap: () {
                          showImagePicker(context,
                                  (pickedImage) async {
                                if (pickedImage != null) {
                                  provider.profileFile = pickedImage;
                                  setState(() {});
                                }
                              });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white, // 👈 white outline makes it "sit" on border
                              width: 2,
                            ),
                          ),
                          padding: const EdgeInsets.all(4),
                          child: const Icon(Icons.add, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              labelWithStar(AppLocalizations.of(context)!.fullName,required: false),
             /* Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text( "Full Name",
                      style: Styles.mediumTextStyle(
                          color: kBlackColor, size: 14)),
                ),
              ),*/
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: buildTextWithBorderField(
                  provider.fullNameController,
                  AppLocalizations.of(context)!.enterFullName,
                  MediaQuery.of(context).size.width,
                  50,
                  isEnabled: false,
                  TextInputType.emailAddress,
                ),
              ),

             /* Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text( "Father’s Name",
                      style: Styles.mediumTextStyle(
                          color: kBlackColor, size: 14)),
                ),
              ),*/
              labelWithStar(AppLocalizations.of(context)!.fName,required: false),

              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: buildTextWithBorderField(
                  provider.fatherNameController,
                  AppLocalizations.of(context)!.enterFName,
                  MediaQuery.of(context).size.width,
                  50,
                  isEnabled: false,
                  TextInputType.emailAddress,
                ),
              ),

              labelWithStar(AppLocalizations.of(context)!.mName,required: false),

              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: buildTextWithBorderField(
                  provider.motherNameController,
                  AppLocalizations.of(context)!.enterMName,
                  MediaQuery.of(context).size.width,
                  50,
                  isEnabled: false,
                  TextInputType.text,
                ),
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Container(
              //       alignment: Alignment.centerLeft,
              //       width: MediaQuery.of(context).size.width  * 0.92/ 2,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           labelWithStar('Date of Birth',required: false),
              //           /*Padding(
              //             padding:
              //             const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              //             child: Align(
              //               alignment: Alignment.topLeft,
              //               child: Text( "Date of Birth",
              //                   style: Styles.mediumTextStyle(
              //                       color: kBlackColor, size: 14)),
              //             ),
              //           ),*/
              //           InkWell(
              //             onTap: () async {
              //
              //             },
              //             child: Padding(
              //               padding: const EdgeInsets.symmetric(
              //                   horizontal: 0, vertical: 5),
              //               child: buildTextWithBorderWhiteBgField(
              //                   provider.dobController,
              //                   "mm/dd/yy" , // No
              //                   MediaQuery.of(context).size.width,
              //                   50,
              //                   TextInputType.text,
              //                   isEnabled: false,
              //                   postfixIcon: Icon(Icons.calendar_month_outlined,)
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //     Container(
              //       alignment: Alignment.centerLeft,
              //       width: MediaQuery.of(context).size.width  * 0.92/ 2,
              //       child: Column(
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           labelWithStar('Mobile Number',required: false),
              //         /*  Padding(
              //             padding:
              //             const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              //             child: Align(
              //               alignment: Alignment.topLeft,
              //               child: Text( "Mobile Number",
              //                   style: Styles.mediumTextStyle(
              //                       color: kBlackColor, size: 14)),
              //             ),
              //           ),*/
              //
              //           Padding(
              //             padding: const EdgeInsets.symmetric(
              //                 horizontal: 0, vertical: 5),
              //             child: buildTextWithBorderWhiteBgField(
              //               provider.mobileController,
              //               "Enter mobile number" , // No
              //               MediaQuery.of(context).size.width,
              //               50,
              //               isEnabled: false,
              //               TextInputType.text,
              //             ),
              //           ),
              //
              //         ],
              //       ),
              //     ),
              //   ],
              // ),

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
                        labelWithStar(AppLocalizations.of(context)!.dob,required: false),
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
                        labelWithStar(AppLocalizations.of(context)!.mobileNo,required: false),
                        const SizedBox(height: 6),
                        buildTextWithBorderWhiteBgField(
                          provider.mobileController,
                          AppLocalizations.of(context)!.enterMobileNo , // No
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

              labelWithStar(AppLocalizations.of(context)!.email,required: false),

              /*Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text( "Email",
                      style: Styles.mediumTextStyle(
                          color: kBlackColor, size: 14)),
                ),
              ),*/
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: buildTextWithBorderField(
                  provider.emailController,
                  AppLocalizations.of(context)!.enterEmail,
                  MediaQuery.of(context).size.width,
                  50,
                  isEnabled: false,
                  TextInputType.emailAddress,
                ),
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width  * 0.90/ 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelWithStar(AppLocalizations.of(context)!.maritalStatus,required: false),
                       /* Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text( "Marital Status",
                                style: Styles.mediumTextStyle(
                                    color: kBlackColor, size: 14)),
                          ),
                        ),*/
                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                          child: buildTextWithBorderField(
                            provider.maritalStatusController,
                            AppLocalizations.of(context)!.maritalStatus,
                            MediaQuery.of(context).size.width,
                            50,
                            isEnabled: false,
                            TextInputType.emailAddress,
                          ),
                        ),

                       /* buildDropdownField(
                          "Marital Status",
                          "Select marital status",
                          value:  provider.maritalStatus != null && ["Single", "Married", "Divorced", "Widowed","Unmarried"].contains( provider.maritalStatus) ?  provider.maritalStatus : null,
                          items: const ["Single", "Married", "Divorced", "Widowed","Unmarried"],
                          onChanged: (val) => setState(() =>  provider.maritalStatus = val),
                        ),*/
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width  * 0.90/ 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelWithStar(AppLocalizations.of(context)!.religion,required: false),
                        /*Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text( "Religion",
                                style: Styles.mediumTextStyle(
                                    color: kBlackColor, size: 14)),
                          ),
                        ),*/

                        Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                          child: buildTextWithBorderField(
                            provider.religionController,
                            AppLocalizations.of(context)!.selectReligion,
                            MediaQuery.of(context).size.width,
                            50,
                            isEnabled: false,
                            TextInputType.emailAddress,
                          ),
                        ),
                      /*  buildDropdownField(
                          "Religion",
                          "Select religion",
                          value:  provider.religion != null &&  ["Hinduism", "Muslim", "Christian", "Sikh", "Other"].contains( provider.religion) ?  provider.religion : null,
                          items: const ["Hinduism", "Muslim", "Christian", "Sikh", "Other"],
                          onChanged: (val) => setState(() =>  provider.religion = val),
                        ),*/

                      ],
                    ),
                  ),
                ],
              ),

              labelWithStar(AppLocalizations.of(context)!.caste,required: false),
             /* Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text( "Caste",
                      style: Styles.mediumTextStyle(
                          color: kBlackColor, size: 14)),
                ),
              ),*/
              /*buildDropdownField(
                "Caste",
                "Select caste",
                value:  provider.caste != null &&  ["GEN", "OBC", "SC", "ST", "Other"].contains( provider.caste) ?  provider.caste : null,
                items: const ["GEN", "OBC", "SC", "ST", "Other"],
                onChanged: (val) => setState(() =>  provider.caste = val),
              ),*/

              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: buildTextWithBorderField(
                  provider.casteController,
                  AppLocalizations.of(context)!.selectCaste,
                  MediaQuery.of(context).size.width,
                  50,
                  isEnabled: false,
                  TextInputType.emailAddress,
                ),
              ),
              labelWithStar(AppLocalizations.of(context)!.adharRefNo,required: false),

              /*Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text( "Aadhar Reference Number",
                      style: Styles.mediumTextStyle(
                          color: kBlackColor, size: 14)),
                ),
              ),*/
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: buildTextWithBorderField(
                  provider.aadharController,
                  AppLocalizations.of(context)!.enterAdharRefNo,
                  MediaQuery.of(context).size.width,
                  50,
                  isEnabled: false,
                  TextInputType.emailAddress,
                ),
              ),


              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      labelWithStar(AppLocalizations.of(context)!.minority,required: false),
                      //const Text("Minority", style: TextStyle(fontWeight: FontWeight.w500)),
                      const SizedBox(height: 0),

                      Theme(
                        data: Theme.of(context).copyWith(
                          switchTheme: SwitchThemeData(
                            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                            thumbIcon: WidgetStateProperty.all(
                              Icon(
                                Icons.circle,
                                size: 12, // ✅ fixed thumb size
                                color: kPrimaryColor,
                              ),
                            ),
                          ),
                        ),
                        child: Transform.scale(
                          alignment: Alignment.centerLeft,

                          scale: 0.8, // 🔽 reduce overall size (try 0.6–0.8)
                          child: Switch(
                            value:  provider.isMinority,
                            onChanged: (value) {
                              setState(() {
                             //   provider.isMinority = value;
                              });
                            },
                            activeColor: kPrimaryColor,
                            inactiveThumbColor: kPrimaryColor,
                            activeTrackColor: const Color.fromARGB(255, 188, 198, 237),
                            inactiveTrackColor: Colors.grey[200],
                          ),
                        ),
                      )




                    ],
                  ),


                  // const SizedBox(width: 20),
                  SizedBox(width: SizeConfig.defaultSize! * 2),


                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // margin: const EdgeInsets.only(left: 12),
                    children: [
                      labelWithStar(AppLocalizations.of(context)!.gender,required: false),
                     /* Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: const Text("Gender", style: TextStyle(fontWeight: FontWeight.w500)),
                      ),*/
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
                          Text(AppLocalizations.of(context)!.male),
                          Radio<String>(
                            value: "Female",
                            groupValue:  provider.gender,
                            onChanged: (val) => () {
                              //setState(() =>  provider.gender = val!);
                            },
                            visualDensity: VisualDensity.compact, // reduce space inside
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          Text(AppLocalizations.of(context)!.female),
                          Radio<String>(
                            value: "Other",
                            groupValue:  provider.gender,
                            onChanged: (val) => () {
                              //setState(() =>  provider.gender = val!);
                            },
                            visualDensity: VisualDensity.compact, // reduce space inside
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          Text(AppLocalizations.of(context)!.other),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),

                ],
              ),

              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelWithStar(AppLocalizations.of(context)!.exSerMan,required: false),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Radio<String>(
                            value: "yes",
                            groupValue:  provider.isExServiceMan,
                            onChanged: (val) => () {
                              //setState(() =>  provider.gender = val!);
                            },
                            visualDensity: VisualDensity.compact, // reduce space inside
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          Text(AppLocalizations.of(context)!.yes),
                          Radio<String>(
                            value: "no",
                            groupValue:  provider.isExServiceMan,
                            onChanged: (val) => () {
                              //setState(() =>  provider.gender = val!);
                            },
                            visualDensity: VisualDensity.compact, // reduce space inside
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          Text(AppLocalizations.of(context)!.no),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      labelWithStar(AppLocalizations.of(context)!.ewsBanificiary,required: false),
                      const SizedBox(height: 8),

                      Row(
                        children: [
                          Radio<String>(
                            value: "yes",
                            groupValue:  provider.isEWSCategory,
                            onChanged: (val) => () {
                              //setState(() =>  provider.gender = val!);
                            },
                            visualDensity: VisualDensity.compact, // reduce space inside
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          Text(AppLocalizations.of(context)!.yes),
                          Radio<String>(
                            value: "no",
                            groupValue:  provider.isEWSCategory,
                            onChanged: (val) => () {
                              //setState(() =>  provider.gender = val!);
                            },
                            visualDensity: VisualDensity.compact, // reduce space inside
                            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          Text(AppLocalizations.of(context)!.no),
                        ],
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 12),

              labelWithStar(AppLocalizations.of(context)!.familyIncome,required: false),

            /*  Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text( "Family Income",
                      style: Styles.mediumTextStyle(
                          color: kBlackColor, size: 14)),
                ),
              ),*/
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: buildTextWithBorderField(
                  provider.familyIncomeController,
                  AppLocalizations.of(context)!.enterFamilyIncome,
                  MediaQuery.of(context).size.width,
                  50,
                  isEnabled: false,
                  TextInputType.emailAddress,
                ),
              ),

              const SizedBox(height: 20),

              labelWithStar(AppLocalizations.of(context)!.addOtherInfo,required: false),
              /*const Text(
                "Add Other Info",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),*/
              const SizedBox(height: 12),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width  * 0.90/ 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelWithStar(AppLocalizations.of(context)!.uidType,required: false),
                       /* Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text( "UID Type",
                                style: Styles.mediumTextStyle(
                                    color: kBlackColor, size: 14)),
                          ),
                        ),*/
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 5),
                          child: buildTextWithBorderWhiteBgField(
                            provider.uidTypeController,
                              AppLocalizations.of(context)!.uidType , // No
                            MediaQuery.of(context).size.width,
                            50,
                            TextInputType.text,
                            isEnabled: false
                          ),
                        ),

                      /*  buildDropdownField(
                          "UID Type",
                          "UID Type",
                          value:  provider.uidType != null &&  ["Aadhar", "Pan Card", "Passport"].contains( provider.uidType) ?  provider.uidType : null,
                          items: const ["Aadhar", "Pan Card", "Passport"],
                          onChanged: (val) => setState(() =>  provider.uidType = val),
                        ),*/
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    width: MediaQuery.of(context).size.width  * 0.90/ 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        labelWithStar(AppLocalizations.of(context)!.uidNumber,required: false),
                        /*Padding(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text( "UID Number",
                                style: Styles.mediumTextStyle(
                                    color: kBlackColor, size: 14)),
                          ),
                        ),*/

                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 5),
                          child: buildTextWithBorderWhiteBgField(
                            provider.uidNumberController,
                            "Enter UID Number" , // No
                            MediaQuery.of(context).size.width,
                            50,
                            TextInputType.text,
                            isEnabled: false
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),





              const SizedBox(height: 30),

              /*SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryDark,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                  ),
                  onPressed: () {
                    // Save logic here
                    // Validate and submit data
                  },
                  child: const Text(
                    "Save",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),*/
              SizedBox(height: SizeConfig.screenHeight! * 0.02),
            ],

          ),
        ),

      );
    }));

    
  }




}
