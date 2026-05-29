import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/department/dept_profile/provider/dept_basic_detail_provider.dart';
import 'package:rajemployment/role/job_seeker/basicdetails/provider/basic_details_provider.dart';
import 'package:rajemployment/utils/dot_border.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/user_new.dart';
import '../../../utils/dropdown.dart';
import '../../../utils/global.dart';
import '../../../utils/images.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
// import '../../employer/empotr_form/modal/district_modal.dart';
import '../../department/register_form/modal/district_modal.dart';
import '../../job_seeker/loginscreen/provider/locale_provider.dart';
import '../register_form/modal/department_modal.dart';
import '../register_form/modal/office_modal.dart';

class DeptBasicDetailsScreen extends StatefulWidget {
  const DeptBasicDetailsScreen({super.key});

  @override
  State<DeptBasicDetailsScreen> createState() => _DeptBasicDetailsScreenState();
}

class _DeptBasicDetailsScreenState extends State<DeptBasicDetailsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
      Provider.of<DeptBasicDetailsProvider>(context, listen: false);
      provider.clearData();

      provider.getDistrictApi(context, 6);
      provider.getDepartmentApi(context);

      provider.deptProfile(context);
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

        body: Consumer<DeptBasicDetailsProvider>(builder: (context, provider, child) {
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
                        // GestureDetector(
                        //   onTap: () {
                        //     showImagePicker(context,
                        //             (pickedImage) async {
                        //           if (pickedImage != null) {
                        //             provider.profileFile = pickedImage;
                        //             setState(() {});
                        //           }
                        //         });
                        //   },
                        //   child: DashedBorderContainer(
                        //       color: const Color(0xFFF3E5F9),
                        //       dash: 4,
                        //       gap: 4,
                        //       strokeWidth: 2,
                        //       radius: "100",
                        //       child: Container(
                        //         width: MediaQuery.of(context).size.width * 0.18,
                        //         height: MediaQuery.of(context).size.width * 0.18,
                        //         decoration: BoxDecoration(
                        //           shape: BoxShape.circle,
                        //           border: Border.all(
                        //             color: Colors.blue, // 👉 Border color
                        //             width: 3,           // 👉 Border width
                        //           ),
                        //         ),
                        //         child: ClipOval(
                        //           child:  provider.profileFile != null ? Image.file(File(provider.profileFile!.path,), fit: BoxFit.cover,) :
                        //           Image.network(
                        //             checkNullValue(UserData().model.value.latestPhotoPath.toString()).isNotEmpty ? UserData().model.value.latestPhotoPath.toString() :  "" ,
                        //             width: double.infinity,
                        //             height: double.infinity,
                        //             fit: BoxFit.cover,
                        //             errorBuilder: (context, error, stackTrace) {
                        //               return Image.asset(
                        //                 Images.placeholder,
                        //                 fit: BoxFit.cover,
                        //               );
                        //             },
                        //           ),
                        //         ),
                        //       )
                        //
                        //   ),
                        // ),
                        //
                        // // ✅ Place edit icon overlapping border
                        // Positioned(
                        //   bottom: 3,  // slightly outside
                        //   right: -6,   // slightly outside
                        //   child: GestureDetector(
                        //     onTap: () {
                        //       showImagePicker(context,
                        //               (pickedImage) async {
                        //             if (pickedImage != null) {
                        //               provider.profileFile = pickedImage;
                        //               setState(() {});
                        //             }
                        //           });
                        //     },
                        //     child: Container(
                        //       decoration: BoxDecoration(
                        //         color: kPrimaryColor,
                        //         shape: BoxShape.circle,
                        //         border: Border.all(
                        //           color: Colors.white, // 👈 white outline makes it "sit" on border
                        //           width: 2,
                        //         ),
                        //       ),
                        //       padding: const EdgeInsets.all(4),
                        //       child: const Icon(Icons.add, size: 16, color: Colors.white),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                  labelWithStar("Officer's SSO ID",required: false),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: buildTextWithBorderField(
                      provider.ssoController,
                      "Officer's SSO ID",
                      MediaQuery.of(context).size.width,
                      50,
                      isEnabled: false,
                      TextInputType.text,
                    ),
                  ),

                 // const SizedBox(height: 20),
                  labelWithStar("Officer's Name",required: false),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: buildTextWithBorderField(
                      provider.nameController,
                      "Officer's Name",
                      MediaQuery.of(context).size.width,
                      50,
                      isEnabled: false,
                      TextInputType.text,
                    ),
                  ),

                 // const SizedBox(height: 20),
                  labelWithStar("Name As Per Aadhaar",required: false),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: buildTextWithBorderField(
                      provider.nameAsAdharController,
                      "Name As Per Aadhaar",
                      MediaQuery.of(context).size.width,
                      50,
                     // isEnabled: false,
                      TextInputType.text,
                    ),
                  ),
                  Text(
                    "Note - Enter your name exactly as per your Aadhaar for verification of applicant's internship joining and attendance.",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 10),
                  labelWithStar('Mobile No',required: false),
                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: buildTextWithBorderField(
                      provider.mobileController,
                      "Mobile No",
                      MediaQuery.of(context).size.width,
                      50,
                     // isEnabled: false,
                      TextInputType.text,
                    ),
                  ),

                  labelWithStar('Designation As Per SSO',required: false),

                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: buildTextWithBorderField(
                      provider.designationController,
                      "Designation As Per SSO",
                      MediaQuery.of(context).size.width,
                      50,
                      isEnabled: false,
                      TextInputType.text,
                    ),
                  ),

                 // const SizedBox(height: 30),

                  labelWithStar('Administration Department',required: false),

                  Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                    child: buildTextWithBorderField(
                      provider.adminDeptNameController,
                      "Administration Department",
                      MediaQuery.of(context).size.width,
                      50,
                      isEnabled: false,
                      TextInputType.text,
                    ),
                  ),

              /// ===== DISTRICT =====
                  labelWithStar('District',required: false),
                  buildSearchableDropdown<DistrictData>(
                    enabled: false,
                  items: provider.districtList,

                // ✅ MAP YOUR MODEL HERE
                getId: (item) => item.code.toString(),
                getName: (item) => item.name ?? "",

                controller: provider.districtController,
                idController: provider.districtIdController,
                hintText: "--Select District--",
                // height: 50,
                // selectedValue: provider.selectedDistrict,
                // getLabel: (e) => e.name ?? "",

                onChanged: (value) {
                  provider.selectedDistrict = value;
                  provider.districtController.text = value?.name ?? "";
                  provider.districtIdController.text =
                      value?.iD.toString() ?? "";
                  provider.notifyListeners();
                },
                  ),

                  labelWithStar('Department',required: false),  // label name got from amit in screenshot
                  provider.isDepartmentLoading
                      ? const Center(child: CircularProgressIndicator())
                      : buildSearchableDropdown<DepartmentData>(
                    enabled: false,
                    items: provider.departmentList,

                    // ✅ MAP YOUR MODEL HERE
                    getId: (item) => item.iD.toString(),
                    getName: (item) => item.nameEng ?? "",

                    controller: provider.deptNameController,
                    idController: provider.deptIdController,
                    hintText: "--Select Department--",
                    onChanged: (value) {
                      provider.selectedDepartment = value;
                      provider.deptNameController.text =
                          value?.nameEng ?? "";
                      provider.deptIdController.text =
                          value?.iD?.toString() ?? "";
                      /// ✅ CLEAR OFFICE (important when dept changes)
                      provider.selectedOffice = null;
                      provider.allotDeptNameController.clear();
                      provider.allotDeptIdController.clear();
                      provider.officeList.clear();
                      provider.notifyListeners();

                      /// ✅ CALL OFFICE API WITH NEW DEPARTMENT ID
                      if (value?.iD != null) {
                        provider.getOfficeApi(context);
                      }

                    },
                  ),

                  labelWithStar('Internship Office Name',required: false),
                  provider.isOfficeLoading
                      ? const Center(child: CircularProgressIndicator())
                      : buildSearchableDropdown<OfficeData>(
                    enabled: false,
                    items: provider.officeList,

                    // ✅ MAP YOUR MODEL HERE
                    getId: (item) => item.iD.toString(),
                    getName: (item) => item.nameEng ?? "",

                    controller: provider.allotDeptNameController,
                    idController: provider.allotDeptIdController,
                    hintText: "--Select Office--",
                    // height: 50,
                    // selectedValue: provider.selectedOffice,
                    // getLabel: (e) => e.nameEng ?? "",
                    onChanged: (value) {
                      provider.selectedOffice = value;
                      provider.allotDeptNameController.text =
                          value?.nameEng ?? "";
                      provider.allotDeptIdController.text =
                          value?.iD?.toString() ?? "";
                      provider.notifyListeners();
                    },
                  ),

                  const SizedBox(height: 30),

                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        //provider.submitEmpOTRForm(context);
                        if (validateBasicDetails(context, provider)) {
                          confirmAlertDialog(
                            context,
                            "Confirm Submission",
                            "Are you sure you want to submit the form ?",
                                (value) {
                              if (value.toString() == "success") {
                                provider.submitForm(context);
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
                          style: TextStyle(fontSize: 16, color: Colors.white)),
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

bool validateBasicDetails(
    BuildContext context,
    DeptBasicDetailsProvider provider,
    ) {

  if (provider.nameAsAdharController.text.trim().isEmpty) {
    showAlertError("Please enter Name (As per Aadhaar)", context);
    return false;
  }

  if (provider.mobileController.text.trim().isEmpty) {
    showAlertError("Please enter Mobile Number", context);
    return false;
  }

  return true;
}