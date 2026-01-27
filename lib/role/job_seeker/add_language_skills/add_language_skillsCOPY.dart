import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/add_language_skills/provider/add_language_skills_provider.dart';
import 'package:rajemployment/role/job_seeker/addjobpreference/provider/add_job_preference_provider.dart';

import '../../../utils/dropdown.dart';
import '../../../utils/global.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../languageandskill/modal/profile_language_info_modal.dart';
import '../languageandskill/modal/profile_skill_info_modal.dart';
import '../loginscreen/provider/locale_provider.dart';

class AddLanguageSkillsScreen extends StatefulWidget {
  bool isUpdateSkill;
  bool isUpdateLanguage;
  ProfileSkillInfoData? profileSkillInfoData;
  ProfileLanguageInfoData? profileLanguageInfoData;
  AddLanguageSkillsScreen({super.key, required this.isUpdateSkill, required this.isUpdateLanguage, required this.profileSkillInfoData, required this.profileLanguageInfoData});

  @override
  State<AddLanguageSkillsScreen> createState() => _AddLanguageSkillsScreenState(isUpdateSkill,isUpdateLanguage,profileSkillInfoData,profileLanguageInfoData);
}

class _AddLanguageSkillsScreenState extends State<AddLanguageSkillsScreen> {
  bool isUpdateSkill;
  bool isUpdateLanguage;
  ProfileSkillInfoData? profileSkillInfoData;
  ProfileLanguageInfoData? profileLanguageInfoData;
  _AddLanguageSkillsScreenState(this.isUpdateSkill, this.isUpdateLanguage, this.profileSkillInfoData,this.profileLanguageInfoData);







  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<AddLanguageSkillsProvider>(context, listen: false);
      provider.clearData();
      provider.ncoCodeApi(context,isUpdateSkill,isUpdateLanguage,profileSkillInfoData,profileLanguageInfoData);
    });
  }


  @override
  Widget build(BuildContext context) {
    const double fieldSpacing = 18;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    final provider = Provider.of<AddLanguageSkillsProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2(isUpdateSkill == false && isUpdateLanguage == false ? "Add Language-Skills" : "Update Language-Skills", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 10),
        child: SizedBox(
          height: 50,
          child: ElevatedButton(
            onPressed: () {

              if (validateSkillAndLanguageForm(context, provider)) {
                confirmAlertDialog(context, "Alert","Are you sure want to submit ?", (value) {
                  if (value.toString() == "success") {
                    if(isUpdateSkill == false && isUpdateLanguage == false){
                      provider.saveSkillsApi(context,isUpdateSkill,isUpdateLanguage,"","");
                    }
                    else if(isUpdateSkill == true){
                      provider.saveSkillsApi(context,isUpdateSkill,isUpdateLanguage,profileSkillInfoData != null ? profileSkillInfoData!.skillDetailID.toString():"","");
                    }
                    else if(isUpdateLanguage == true){
                      provider.saveDataLanguageApi(context,isUpdateSkill,isUpdateLanguage,profileLanguageInfoData != null ? profileLanguageInfoData!.languageDetailID.toString():"");
                    }



                  }
                },
                );
              }




            },
            style: ElevatedButton.styleFrom(
              backgroundColor: kPrimaryColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            ),
            child:  Text(isUpdateSkill == false && isUpdateLanguage == false ? 'Add' : "Update", style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ),
      ),

        body: Consumer<AddLanguageSkillsProvider>(builder: (context, provider, child) {
          return  SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Skill Known',
                      style: Styles.boldTextStyle(
                          color: kBlackColor, size: 16),
                    ),
                    hSpace( 14),

                    // Sector
                    labelWithStar('Category',required: true),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: buildDropdownWithBorderField(
                        items: provider.categoryList,
                        controller: provider.categoryNameController,
                        idController: provider.categoryIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {

                          provider.getSubCategoryTypeDetailsApi(context,provider.categoryIdController.text,false,null);

                        },
                      ),
                    ),
                    hSpace(8),

                    // Preferred Location
                    labelWithStar('Sub Category',required: true),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: buildDropdownWithBorderField(
                        items: provider.subCategoryList,
                        controller: provider.subCategoryNameController,
                        idController: provider.subCategoryIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {

                        },
                      ),
                    ),
                    hSpace(8),


                    labelWithStar('Acquired Through',required: true),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: buildDropdownWithBorderField(
                        items: provider.acquiredTypeList,
                        controller: provider.acquiredThroughNameController,
                        idController: provider.acquiredThroughIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {

                        },
                      ),
                    ),
                    hSpace(8),

                    // Desired Job Type (text field)
                    labelWithStar('Experience',required: true),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 0, vertical: 5),
                          child: buildTextWithBorderField(
                            provider.yearController,
                            "Enter Year",
                            MediaQuery.of(context).size.width * 0.88 / 2,
                            50,
                            TextInputType.text,
                          ),
                        ),


                        Padding(padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                          child: buildTextWithBorderField(
                            provider.monthController,
                            "Enter Month",
                            MediaQuery.of(context).size.width * 0.88 / 2,
                            50,
                            TextInputType.text,
                          ),
                        ),
                      ],
                    ),
                    hSpace(8),


                    labelWithStar('NCO Code',required: true),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: buildDropdownWithBorderField(
                        items: provider.ncoCodeList,
                        controller: provider.ncoNameController,
                        idController: provider.ncoIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {

                        },
                      ),
                    ),
                    hSpace(8),


                    labelWithStar('Remark',required: true),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: buildTextWithBorderField(
                        provider.remarkController,
                        "",
                        MediaQuery.of(context).size.width ,
                        50,
                        TextInputType.text,

                      ),
                    ),
                    hSpace(8),

                    labelWithStar('Upload Skill Certificate',required: false),
                    InkWell(
                      onTap: () {
                        showImagePicker(context,
                                (pickedImage) async {
                              if (pickedImage != null) {
                                // First update the file path (optional)
                                provider.attachments =
                                    pickedImage;

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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: buildTextWithBorderField(
                          provider.certificateController,
                          "",
                          MediaQuery.of(context).size.width ,
                          50,
                          TextInputType.text,
                          isEnabled: false,
                          postfixIcon: Icon(Icons.attach_file)
                        ),
                      ),
                    ),
                    hSpace(8),



                    Text(
                      'Language Known',
                      style: Styles.boldTextStyle(
                          color: kBlackColor, size: 16),
                    ),
                    const SizedBox(height: 30),


                    labelWithStar('Language',required: true),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: buildDropdownWithBorderField(
                        items: provider.languageKnownList,
                        controller: provider.languageNameController,
                        idController: provider.languageIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {

                        },
                      ),
                    ),
                    hSpace(8),

                    labelWithStar('Proficiency',required: true),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: buildDropdownWithBorderField(
                        items: provider.proficiencyTypeList,
                        controller: provider.proficiencyNameController,
                        idController: provider.proficiencyIdController,
                        hintText: "--Select Option--",
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {

                        },
                      ),
                    ),
                    hSpace(8),

                    Column(
                      children: [
                        CheckboxListTile(
                          title: const Text('Read'),
                          value: provider.read,
                          onChanged: (v) => setState(() => provider.read = v ?? false),
                        ),
                        CheckboxListTile(
                          title: const Text('Write'),
                          value: provider.write,
                          onChanged: (v) => setState(() => provider.write = v ?? false),
                        ),
                        CheckboxListTile(
                          title: const Text('Speak'),
                          value: provider.speak,
                          onChanged: (v) => setState(() => provider.speak = v ?? false),
                        ),
                      ],

                    )


                  ],
                ),
              ),
            ),
          );
        }));



  }

  bool validateSkillAndLanguageForm(BuildContext context, provider) {
    // ---------- CATEGORY ----------
    if (provider.categoryIdController.text.trim().isEmpty) {
      showAlertError("Please select category", context);
      return false;
    }

    // ---------- SUB CATEGORY ----------
    if (provider.subCategoryIdController.text.trim().isEmpty) {
      showAlertError("Please select sub category",context);

      return false;
    }

    // ---------- ACQUIRED THROUGH ----------
    if (provider.acquiredThroughIdController.text.trim().isEmpty) {
      showAlertError("Please select acquired through",context);

      return false;
    }

    // ---------- EXPERIENCE YEAR ----------
    if (provider.yearController.text.trim().isEmpty) {
      showAlertError("Please enter experience year",context);
      return false;
    }
    if (int.tryParse(provider.yearController.text.trim()) == null) {
      showAlertError("Experience year must be number",context);
      return false;
    }

    // ---------- EXPERIENCE MONTH ----------
    if (provider.monthController.text.trim().isEmpty) {
      showAlertError("Please enter experience month",context);
      return false;
    }
    if (int.tryParse(provider.monthController.text.trim()) == null ||
        int.parse(provider.monthController.text.trim()) > 11) {
      showAlertError("Month must be between 0 - 11",context);
      return false;
    }

    // ---------- NCO CODE ----------
    if (provider.ncoIdController.text.trim().isEmpty) {
      showAlertError("Please select NCO code",context);
      return false;
    }

    // ---------- REMARK ----------
    if (provider.remarkController.text.trim().isEmpty) {
      showAlertError("Remark is required",context);
      return false;
    }

    /*// ---------- CERTIFICATE ----------
    if (provider.certificateController.text.trim().isEmpty) {
      showAlertError("Please upload certificate",context);
      return false;
    }*/

    // ---------- LANGUAGE ----------
    if (provider.languageIdController.text.trim().isEmpty) {
      showAlertError("Please select language",context);
      return false;
    }

    // ---------- PROFICIENCY ----------
    if (provider.proficiencyIdController.text.trim().isEmpty) {
      showAlertError("Please select proficiency",context);
      return false;
    }

    // ---------- READ/WRITE/SPEAK ----------
    if (!provider.read && !provider.write && !provider.speak) {
      showAlertError("Select at least one: Read / Write / Speak",context);
      return false;
    }

    return true; // ALL OK
  }

}
