import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/addphysicalattribute/provider/addphysicalattribute_provider.dart';
import 'package:rajemployment/utils/dot_border.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/dropdown.dart';
import '../../../utils/global.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../../../utils/user_new.dart';
import '../loginscreen/provider/locale_provider.dart';
import '../physicalattribute/modal/profile_physical_attribute_modal.dart';
import 'modal/disability_type_modal.dart';

class AddphysicalattributeScreen extends StatefulWidget {
  bool isUpdate;
  ProfilePhysicalAttributeData? profilePhysicalAttributeData;

  AddphysicalattributeScreen(
      {super.key,
      required this.isUpdate,
      required this.profilePhysicalAttributeData});

  @override
  State<AddphysicalattributeScreen> createState() =>
      _PhysicalattributeScreenState(isUpdate, profilePhysicalAttributeData);
}

class _PhysicalattributeScreenState extends State<AddphysicalattributeScreen> {
  bool isUpdate;
  ProfilePhysicalAttributeData? profilePhysicalAttributeData;

  _PhysicalattributeScreenState(
      this.isUpdate, this.profilePhysicalAttributeData);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
          Provider.of<AddphysicalattributeProvider>(context, listen: false);
      provider.clearData();
      provider.bloodGroupApi(context, isUpdate, profilePhysicalAttributeData);

      if (profilePhysicalAttributeData?.isDisablity.toString() == "1") {
        provider.getDisabilityTypeApi(
            context, isUpdate, profilePhysicalAttributeData);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    const double fieldSpacing = 18;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2(
            isUpdate == true
                ? AppLocalizations.of(context)!.updatePhysAttri
                : AppLocalizations.of(context)!.addPhysAttri,
            context,
            localeProvider.currentLanguage,
            "",
            false,
            "", onTapClick: () {
          localeProvider.toggleLocale();
        }),
        body: Consumer<AddphysicalattributeProvider>(
            builder: (context, provider, child) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.phyAttri,
                      style: Styles.semiBoldTextStyle(
                          color: kBlackColor, size: 16),
                    ),
                    hSpace(10),
                    // Sector
                    labelWithStar(AppLocalizations.of(context)!.height0255, required: true),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: buildTextWithBorderField(
                        provider.heightController,
                        AppLocalizations.of(context)!.enterHeight0255,
                        MediaQuery.of(context).size.width,
                        50,
                        TextInputType.number,
                      ),
                    ),

                    hSpace(10),
                    // Preferred Location
                    labelWithStar(AppLocalizations.of(context)!.weight0255, required: true),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: buildTextWithBorderField(
                        provider.weightController,
                        AppLocalizations.of(context)!.enterWeight0255,
                        MediaQuery.of(context).size.width,
                        50,
                        TextInputType.number,
                      ),
                    ),

                    hSpace(10),
                    // Desired Employment Type
                  if (UserData().model.value.gENDER != "Female") ...[
                    labelWithStar(AppLocalizations.of(context)!.chest0255, required: true),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: buildTextWithBorderField(
                        provider.chestController,
                        AppLocalizations.of(context)!.chest0255,
                        MediaQuery.of(context).size.width,
                        50,
                        TextInputType.number,
                      ),
                    ),
                    ],

                    hSpace(10),
                    labelWithStar(AppLocalizations.of(context)!.bloodGroup, required: false),
                    IgnorePointer(
                      ignoring: false,
                      child: buildDropdownWithBorderField(
                        items: provider.bloodGroupList,
                        controller: provider.bloodNameController,
                        idController: provider.bloodIdController,

                        getName: (item) {
                          final locale = AppLocalizations.of(context)!.localeName;

                          return locale == 'hi'
                              ? (item.nameHi ?? item.name ?? '')
                              : (item.name ?? '');
                        },

                        hintText: AppLocalizations.of(context)!.selOption,
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (value) {},
                      ),
                    ),

                    hSpace(10),
                    labelWithStar(AppLocalizations.of(context)!.eyeeSight, required: true),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 5),
                      child: buildTextWithBorderField(
                        provider.eyesController,
                        AppLocalizations.of(context)!.eyeeSight,
                        MediaQuery.of(context).size.width,
                        50,
                        TextInputType.number,
                      ),
                    ),

                    hSpace(10),
                    labelWithStar(AppLocalizations.of(context)!.diffAbled,
                        required: true),

                    const SizedBox(height: 8),
                    Row(
                      children: ['Yes', 'No'].map((opt) {
                        final bool selected = provider.diffAbled == opt;
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Row(
                            children: [
                              Radio<String>(
                                value: opt,
                                groupValue: provider.diffAbled,
                                activeColor: const Color(0xFF2563EB),
                                onChanged: (v) {
                                  setState(() {
                                    provider.diffAbled = v ?? provider.diffAbled;
                                    if (provider.diffAbled == "Yes") {
                                      provider.getDisabilityTypeApi(
                                          context, isUpdate, profilePhysicalAttributeData);
                                    } else {
                                      provider.disabilityTypeIdController.clear();
                                      provider.disabilityTypeNameController.clear();
                                      provider.disabilityPercentageController.clear();
                                    }
                                  });
                                },

                              ),
                              Text(
                                opt,
                                style: Styles.regularTextStyle(
                                    color: selected
                                        ? Colors.black
                                        : Colors.black87,
                                    size: 15),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),

                    if (provider.diffAbled == "Yes") ...[
                      hSpace(10),
                      labelWithStar(AppLocalizations.of(context)!.disabilityType, required: true),
                      buildDropdownWithBorderField(
                        items: provider.disabilityTypeList, // model list
                        controller: provider.disabilityTypeNameController,
                        idController: provider.disabilityTypeIdController,

                        getName: (item) {
                          final locale = AppLocalizations.of(context)!.localeName;

                          return locale == 'hi'
                              ? (item.nameHi ?? item.name ?? '')
                              : (item.name ?? '');
                        },

                        hintText: AppLocalizations.of(context)!.selectDisabilityType,
                        height: 50,
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        onChanged: (String? value) {
                          if (value == null || value.isEmpty) return;

                          final selected = provider.disabilityTypeList.firstWhere(
                                (e) => e.name == value,
                          );

                          provider.disabilityTypeIdController.text =
                              selected.dropID.toString();
                          provider.disabilityTypeNameController.text =
                              selected.name.toString();

                          provider.notifyListeners(); // 🔑 forces rebuild
                        },
                      ),


                      hSpace(10),
                      labelWithStar(AppLocalizations.of(context)!.disabPercent, required: true),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                        child: buildTextWithBorderField(
                          provider.disabilityPercentageController,
                          AppLocalizations.of(context)!.enterDisabPercent,
                          MediaQuery.of(context).size.width,
                          50,
                          TextInputType.number,
                        ),
                      ),

                    ],




                    hSpace(30),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        onPressed: () {
                          if (validatePhysicalAttributes(context, provider)) {
                            confirmAlertDialog(
                              context,
                              AppLocalizations.of(context)!.confirmSub,
                              AppLocalizations.of(context)!.areYouSureSubmitForm,
                                  (value) {
                                if (value.toString() == "success") {
                                  provider.saveWorkExperienceApi(
                                      context,
                                      isUpdate,
                                      profilePhysicalAttributeData != null
                                          ? profilePhysicalAttributeData!
                                          .physicalDetailID
                                          .toString()
                                          : "");
                                }
                              },
                            );
                          }


                        },
                        child: Text(
                          isUpdate == true ? AppLocalizations.of(context)!.update : AppLocalizations.of(context)!.add,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),

// spacing so content doesn't hide behind button
                  ],
                ),
              ),
            ),
          );
        }));
  }
  bool validatePhysicalAttributes(BuildContext context, provider) {
    String height = provider.heightController.text.trim();
    String weight = provider.weightController.text.trim();
    String chest = provider.chestController.text.trim();
    String eyeSight = provider.eyesController.text.trim();
    String diffAbled = provider.diffAbled;   // Yes / No

    // 1. Height
    if (height.isEmpty) {
      showAlertError(AppLocalizations.of(context)!.heightReq, context);
      return false;
    }
    if (int.tryParse(height) == null || int.parse(height) < 0 || int.parse(height) > 255) {
       showAlertError(AppLocalizations.of(context)!.heightMust0255, context);
      return false;
    }

    // 2. Weight
    if (weight.isEmpty) {
      showAlertError(AppLocalizations.of(context)!.weightReq, context);
      return false;
    }
    if (int.tryParse(weight) == null || int.parse(weight) < 0 || int.parse(weight) > 255) {
      showAlertError(AppLocalizations.of(context)!.weightMust0255, context);

      return false;
    }

    // 3. Chest
    if (UserData().model.value.gENDER != "Female") {
      if (chest.isEmpty) {
        showAlertError(AppLocalizations.of(context)!.chestReq, context);
        return false;
      }
      if (int.tryParse(chest) == null || int.parse(chest) < 0 ||
          int.parse(chest) > 255) {
        showAlertError(AppLocalizations.of(context)!.chestMust0255, context);
        return false;
      }
    }

    // 4. Eye Sight
    if (eyeSight.isEmpty) {
      showAlertError(AppLocalizations.of(context)!.eyeSightReq, context);
      return false;
    }
    // if (int.tryParse(eyeSight) == null) {
    //   showAlertError("Eye Sight must be number (-/+)", context);
    //   return false;
    // }

    final RegExp eyeSightRegex = RegExp(r'^\d+(\.\d{1,2})?$');
    if (!eyeSightRegex.hasMatch(eyeSight)) {
      showAlertError(
          AppLocalizations.of(context)!.eyeSightValidation2Decimal,
          context);
      return false;
    }

    // 5. Differently-abled (PwD)
    if (diffAbled.isEmpty) {
      showAlertError(AppLocalizations.of(context)!.selIfUDifAbled, context);
      return false;
    }

    // 6. Disability Type
    if (diffAbled == "Yes" &&
        provider.disabilityTypeIdController.text.isEmpty) {
      showAlertError(AppLocalizations.of(context)!.selectDisabilityType, context);
      return false;
    }

    // 7. Disability Percentage
    if (diffAbled == "Yes") {
      String disabilityPercent =
      provider.disabilityPercentageController.text.trim();

      if (disabilityPercent.isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzEnterDisbPercent, context);
        return false;
      }

      final int? percent = int.tryParse(disabilityPercent);
      if (percent == null || percent < 0 || percent > 100) {
        showAlertError(
            AppLocalizations.of(context)!.disPercentMust0100,
            context);
        return false;
      }
    }


    return true;
  }

}
