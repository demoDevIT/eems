import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/basicdetails/provider/basic_details_provider.dart';
import 'package:rajemployment/utils/dot_border.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/user_new.dart';
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

    appBar: commonAppBar2("Add Basic Info", context,
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
              const Text(
                "Basic Details",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Text(
                "(As Per Jan Aadhaar)",
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
              labelWithStar('Full Name',required: false),
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
                  "Enter your full name",
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
              labelWithStar('Father’s Name',required: false),

              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                child: buildTextWithBorderField(
                  provider.fatherNameController,
                  "Enter your father name",
                  MediaQuery.of(context).size.width,
                  50,
                  isEnabled: false,
                  TextInputType.emailAddress,
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
                        labelWithStar('Date of Birth',required: false),
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

              labelWithStar('Email',required: false),

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
                  "Enter your email",
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
                        labelWithStar('Marital Status',required: false),
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
                            "Marital Status",
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
                        labelWithStar('Religion',required: false),
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
                            "Select Religion",
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

              labelWithStar('Caste',required: false),
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
                  "Select caste",
                  MediaQuery.of(context).size.width,
                  50,
                  isEnabled: false,
                  TextInputType.emailAddress,
                ),
              ),
              labelWithStar('Aadhaar Reference Number',required: false),

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
                  "Enter aadhaar reference number",
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
                      labelWithStar('Minority',required: false),
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
                      labelWithStar('Gender',required: false),
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

              labelWithStar('Family Income',required: false),

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
                  "Enter your family income",
                  MediaQuery.of(context).size.width,
                  50,
                  isEnabled: false,
                  TextInputType.emailAddress,
                ),
              ),

              const SizedBox(height: 20),

              labelWithStar('Add Other Info',required: false),
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
                        labelWithStar('UID Type',required: false),
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
                            "UID Type" , // No
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
                        labelWithStar('UID Number',required: false),
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
