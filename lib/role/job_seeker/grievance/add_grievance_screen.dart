import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/addphysicalattribute/provider/addphysicalattribute_provider.dart';
import 'package:rajemployment/role/job_seeker/grievance/provider/add_grievance_provider.dart';
import '../../../utils/dropdown.dart';
import '../../../utils/global.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../loginscreen/provider/locale_provider.dart';
import '../physicalattribute/modal/profile_physical_attribute_modal.dart';

class AddGrievanceScreen extends StatefulWidget {

   AddGrievanceScreen({super.key});

  @override
  State<AddGrievanceScreen> createState() => _AddGrievanceScreenState();
}

class _AddGrievanceScreenState extends State<AddGrievanceScreen> {


  _AddGrievanceScreenState();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<AddGrievanceProvider>(context, listen: false);
      provider.clearData();
      provider.addData();
      provider.moduleApi(context);


    });
  }


  @override
  Widget build(BuildContext context) {
    const double fieldSpacing = 18;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2("Grievance Assign Form", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),

        body: Consumer<AddGrievanceProvider>(builder: (context, provider, child) {
          return  SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Grievance Assign Form',
                      style: Styles.semiBoldTextStyle(
                          color: kBlackColor, size: 16),
                    ),
                    hSpace(10),
                    // Sector
                    labelWithStar('Category'),
                    IgnorePointer(
                      ignoring: false,
                      child: buildDropdownWithBorderField(
                        items: provider.categoryList,
                        controller: provider.categoryNameController,
                        idController: provider.categoryIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {
                          print("Selected Category:");
                          print("ID: ${provider.categoryIdController.text}");
                          print("Name: ${provider.categoryNameController.text}");
                          provider.updateCategoryTypes(provider.categoryIdController.text);
                        },
                      ),
                    ),



                    hSpace(10),
                    // Preferred Location
                    labelWithStar('Category Type'),
                    IgnorePointer(
                      ignoring: false,
                      child: buildDropdownWithBorderField(
                        items: provider.categoryTypesList,
                        controller: provider.categoryTypeNameController,
                        idController: provider.categoryTypeIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {
                          print("Selected Category Type:");
                          print("ID: ${provider.categoryTypeIdController.text}");
                          print("Name: ${provider.categoryTypeNameController.text}");
                        },
                      ),
                    ),



                    hSpace(10),
                    // Desired Employment Type
                    labelWithStar('Module'),
                    IgnorePointer(
                      ignoring: false,
                      child: buildDropdownWithBorderField(
                        items: provider.moduleList,
                        controller: provider.moduleNameController,
                        idController: provider.moduleIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {
                          provider.subModuleIdController.clear();
                          provider.subModuleNameController.clear();
                          provider.subModuleList.clear();
                          provider.notifyListeners();

                          provider.subModuleApi(context, provider.moduleIdController.text);
                        },
                      ),
                    ),



                    hSpace(10),
                    labelWithStar('Sub Module'),
                    IgnorePointer(
                      ignoring: false,
                      child: buildDropdownWithBorderField(
                        items: provider.subModuleList,
                        controller: provider.subModuleNameController,
                        idController: provider.subModuleIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {

                        },
                      ),
                    ),


                    hSpace(10),
                    labelWithStar('Subject (Related to Complaint)'),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      child: buildTextWithBorderField(
                        provider.complaintController,
                        "Enter Subject (Related to Complaint)",
                        MediaQuery.of(context).size.width,
                        50,
                        TextInputType.number,
                      ),
                    ),


                    hSpace(10),
                    labelWithStar('Remark'),
                    Padding(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                      child: buildTextWithBorderField(
                        provider.remarkController,
                        "Remark",
                        MediaQuery.of(context).size.width,
                        100,
                        maxLine: 20,
                        TextInputType.number,
                      ),
                    ),

                    hSpace(10),
                    labelWithStar('Upload Attachment'),
                    InkWell(
                      onTap: () {
                        showImagePicker(context,
                                (pickedImage) async {
                              if (pickedImage != null) {
                                // First update the file path (optional)
                                provider.attachments = pickedImage;

                                // Do async work here
                                String timestamp =
                                    "${DateTime.now().millisecondsSinceEpoch}.jpg";
                                String fileName = timestamp;

                                Map<String, dynamic> fields = {
                                  "file":
                                  await MultipartFile.fromFile(
                                    provider
                                        .attachments!.path,
                                    filename: fileName,
                                  ),
                                };

                                FormData param =
                                FormData.fromMap(fields);

                                // Call upload API
                                await provider
                                    .uploadDocumentApi(
                                    context, param);

                                // Now update state if needed
                                setState(() {
                                  // Update UI-related state if needed
                                });
                              }
                            });
                      },
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        child: buildTextWithBorderField(
                          provider.certificateController,
                          "Select Upload Attachment",
                          MediaQuery.of(context).size.width,
                          50,
                          TextInputType.number,
                          isEnabled: false,
                          postfixIcon: Icon(Icons.attach_file,color: grayBorderColor,)
                        ),
                      ),
                    ),



                    hSpace(30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:kPrimaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          confirmAlertDialog(context, "Alert","Are you sure want to submit ?", (value) {
                            if (value.toString() == "success") {
                              provider.saveGrievanceModalApi(context);
                            }
                          },
                          );

                        },
                        child:  Text(
                          "Add" ,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),


                  ],
                ),
              ),
            ),
          );
        }));



  }



}
