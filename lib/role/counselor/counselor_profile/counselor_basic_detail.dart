import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
// import 'package:rajemployment/role/job_seeker/basicdetails/provider/basic_details_provider.dart';
import 'package:rajemployment/utils/dot_border.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/user_new.dart';
import '../../../utils/dropdown.dart';
import '../../../utils/global.dart';
import '../../../utils/images.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../../job_seeker/loginscreen/provider/locale_provider.dart';
import 'modal/counselor_info_modal.dart';
import 'provider/counselor_basic_detail_provider.dart';
// import '../loginscreen/provider/locale_provider.dart';

class CounselorBasicDetailsScreen extends StatefulWidget {
  final CounselorInfoData? counselor;

  const CounselorBasicDetailsScreen({super.key, this.counselor});

  @override
  State<CounselorBasicDetailsScreen> createState() => _CounselorBasicDetailsScreenState();
}

class _CounselorBasicDetailsScreenState extends State<CounselorBasicDetailsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
      Provider.of<CounselorBasicDetailsProvider>(context, listen: false);

      if (widget.counselor != null) {
        provider.setCounselorData(widget.counselor!);
      }
      //provider.clearData();
      //provider.addData();
    });
  }



  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(

        appBar: commonAppBar2("Basic Info", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),

        body: Consumer<CounselorBasicDetailsProvider>(builder: (context, provider, child) {
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
                  // const Text(
                  //   "(As Per Jan Aadhaar)",
                  //   style: TextStyle(color: Colors.red, fontSize: 12),
                  // ),
                  const SizedBox(height: 20),

                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none, // allow button to overflow a little
                      children: [
                        GestureDetector(
                          onTap: () {
                            // showImagePicker(context,
                            //         (pickedImage) async {
                            //       if (pickedImage != null) {
                            //         provider.profileFile = pickedImage;
                            //         setState(() {});
                            //       }
                            //     });
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
                                  // child:  provider.profileFile != null ? Image.file(File(provider.profileFile!.path,), fit: BoxFit.cover,) :
                                  // Image.network(
                                  //   widget.counselor?.profileImg ?? "",
                                  //   fit: BoxFit.cover,
                                  //   errorBuilder: (context, error, stackTrace) {
                                  //     return Image.asset(Images.placeholder);
                                  //   },
                                  // )
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
                              // showImagePicker(context,
                              //         (pickedImage) async {
                              //       if (pickedImage != null) {
                              //         provider.profileFile = pickedImage;
                              //         setState(() {});
                              //       }
                              //     });
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
