import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/main.dart';
import 'package:rajemployment/role/job_seeker/addeducationaldetail/provider/add_educational_detail_provider.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/dropdown.dart';
import '../../../utils/global.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../educationdetail/modal/profile_qualication_info_list_modal.dart';
import '../loginscreen/provider/locale_provider.dart';
import '../otr_form/modal/graduation_stream_type_modal.dart';
import '../otr_form/modal/graduation_type_modal.dart';
import 'modal/education_level_modal.dart';

class AddEducationalDetail extends StatefulWidget {
  bool isUpdate;
  ProfileQualicationInfoData? profileData;

  AddEducationalDetail(
      {super.key, required this.isUpdate, required this.profileData});

  @override
  State<AddEducationalDetail> createState() =>
      _AddEducationalDetailState(isUpdate, profileData);
}

class _AddEducationalDetailState extends State<AddEducationalDetail> {
  bool isUpdate;
  ProfileQualicationInfoData? profileData;

  _AddEducationalDetailState(this.isUpdate, this.profileData);

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
          Provider.of<AddEducationalDetailProvider>(context, listen: false);
      provider.clearData();
      _loadApisAfterFrame(context, isUpdate, profileData);
    });
  }

  Future<void> _loadApisAfterFrame(BuildContext context, bool isUpdate,
      ProfileQualicationInfoData? profileData) async {
    final provider =
        Provider.of<AddEducationalDetailProvider>(context, listen: false);

    provider.clearData();

    List<Future> futures = [];
    // Common API calls
    futures.add(provider.educationLevelApi(context, isUpdate, profileData));
    futures.add(provider.ncoCodeApi(context, isUpdate, profileData));
    futures.add(provider.mediumOfEducationApi(context, isUpdate, profileData));
    futures.add(provider.courseNatureApi(context, isUpdate, profileData));
    futures.add(provider.passingYearModalApi(context, isUpdate, profileData));
    futures.add(provider.gradeTypeApi(context, isUpdate, profileData));
    futures.add(provider.universityApi(context, isUpdate));


    if (isUpdate) {
      String eduId = profileData!.hightestEducationLevelID.toString();

      if (["2", "5", "6", "8"].contains(eduId)) {
        String id = eduId == "8" ? "7" : eduId;
        futures.add(
            provider.graduationTypeApi(context, id, isUpdate, profileData));
      } else if (eduId == "3") {
        futures.add(provider.boardApi(context, isUpdate));
      } else if (eduId == "4") {
        futures.add(provider.boardApi(context, isUpdate));
        futures.add(provider.streamTypeApi(context, isUpdate));
      }
      provider.updateData(profileData);
    }

    // ⏳ Wait for all APIs to finish
    await Future.wait(futures);

    // 🔥 Now updateData only after all responses loaded
    // if (isUpdate) {
    //   provider.updateData(profileData);
    // }
  }

  @override
  Widget build(BuildContext context) {
    // Small device padding / sizing
    final double spacing = 12;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2(AppLocalizations.of(context)!.addEduDetail, context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
          localeProvider.toggleLocale();
        }),
        body: Consumer<AddEducationalDetailProvider>(
            builder: (context, provider, child) {
          return SafeArea(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.eduHistory,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    SizedBox(height: spacing + 10),
                    // Education Level comman

                    /* Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Education Level",
                            style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14)),
                      ),
                    ),*/

                    labelWithStar(AppLocalizations.of(context)!.eduLevel, required: true),

                    IgnorePointer(
                      ignoring: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: buildSearchableDropdown<EducationLevelData>(
                          items: provider.educationLevelsList,

                          // ✅ MAP YOUR MODEL HERE
                          getId: (item) => item.dropID.toString(),
                          getName: (item) => item.name ?? "",

                          controller: provider.educationLevelNameController,
                          idController: provider.educationLevelIdController,
                          hintText: AppLocalizations.of(context)!.selOption,
                          // height: 50,
                          // color: Colors.transparent,
                          // borderRadius: BorderRadius.circular(8),
                          onChanged: (value) {
                            setState(() {
                              print("test==-->" +
                                  provider.educationLevelIdController.text
                                      .toString());
                              if (provider.educationLevelIdController.text == "2" ||
                                  provider.educationLevelIdController.text ==
                                      "5" ||
                                  provider.educationLevelIdController.text ==
                                      "6" ||
                                  provider.educationLevelIdController.text ==
                                      "8" ||
                                  provider.educationLevelIdController.text ==
                                      "9") {
                                // String id = provider
                                //             .educationLevelIdController.text ==
                                //         "8"
                                //     ? "7"
                                //     : provider.educationLevelIdController.text;
                                provider.graduationTypeApi(
                                    context, provider.educationLevelIdController.text, isUpdate, profileData);

                                if (provider.educationLevelIdController.text == "9") {
                                  provider.itiMainList = List.from(provider.graduationTypeList);
                                }

                              } else if (provider
                                      .educationLevelIdController.text ==
                                  "3") {
                                provider.boardApi(context, isUpdate);
                              } else if (provider
                                      .educationLevelIdController.text ==
                                  "4") {
                                provider.boardApi(context, isUpdate);
                                provider.streamTypeApi(context, isUpdate);
                              }
                            });
                          },
                        ),
                      ),
                    ),

                    //below10.................

                    provider.educationLevelIdController.text == "2"
                        ? labelWithStar(AppLocalizations.of(context)!.chooseClass, required: true)
                        : SizedBox(),

                    Visibility(
                      visible: provider.educationLevelIdController.text == "2"
                          ? true
                          : false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: buildDropdownWithBorderField(
                          items: provider.classList,
                          controller: provider.classNameController,
                          idController: provider.classIdController,

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
                    ),
                    //below10.................

                    //10th secondary............

                    provider.educationLevelIdController.text == "3" ||
                            provider.educationLevelIdController.text == "4"
                        ? labelWithStar(AppLocalizations.of(context)!.board, required: true)
                        : SizedBox(),

/*
                    provider.educationLevelIdController.text == "3" ||  provider.educationLevelIdController.text == "4" ?     Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Board",
                            style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14)),
                      ),
                    ) : SizedBox(),*/

                    Visibility(
                      visible: provider.educationLevelIdController.text ==
                                  "3" ||
                              provider.educationLevelIdController.text == "4"
                          ? true
                          : false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: buildDropdownWithBorderField(
                          items: provider.boardList,
                          controller: provider.boardNameController,
                          idController: provider.boardIdController,

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
                    ),

                    provider.educationLevelIdController.text == "2" ||
                            provider.educationLevelIdController.text == "3" ||
                            provider.educationLevelIdController.text == "4"
                        ? labelWithStar(AppLocalizations.of(context)!.schoolName, required: true)
                        : SizedBox(),

                    /*provider.educationLevelIdController.text == "2"  || provider.educationLevelIdController.text == "3"  ||  provider.educationLevelIdController.text == "4"?  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("School Name",
                            style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14)),
                      ),
                    ) : SizedBox(),*/

                    provider.educationLevelIdController.text == "2" ||
                            provider.educationLevelIdController.text == "3" ||
                            provider.educationLevelIdController.text == "4"
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.schoolNameController,
                              AppLocalizations.of(context)!.enterSchoolName,
                              MediaQuery.of(context).size.width,
                              50,
                              TextInputType.text,
                            ),
                          )
                        : SizedBox(),

                    //10th secondary............//////

                    //12 secondary.............

                    provider.educationLevelIdController.text == "4"
                        ? labelWithStar(AppLocalizations.of(context)!.stream, required: true)
                        : SizedBox(),

                    /*  provider.educationLevelIdController.text == "4" ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Stream",
                            style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14)),
                      ),
                    ) : SizedBox(),*/

                    Visibility(
                      visible: provider.educationLevelIdController.text == "4"
                          ? true
                          : false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: buildDropdownWithBorderField(
                          items: provider.streamTypeList,
                          controller: provider.streamNameController,
                          idController: provider.streamIdController,

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
                    ),

                    //12 secondary.............////////

                    // under graduate / graduate / post graduate.......

                    provider.educationLevelIdController.text == "5" ||
                            provider.educationLevelIdController.text == "6" ||
                            provider.educationLevelIdController.text == "8" ||
                        provider.educationLevelIdController.text == "9"
                        ? labelWithStar(getGraduationTypeLabel(), required: true)
                        : SizedBox(),

                    /*   provider.educationLevelIdController.text == "5" ||  provider.educationLevelIdController.text == "6"  ||  provider.educationLevelIdController.text == "8" ?  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Graduation Type",
                            style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14)),
                      ),
                    ) : SizedBox(),*/

                    Visibility(
                      visible: provider.educationLevelIdController.text ==
                                  "5" ||
                              provider.educationLevelIdController.text == "6" ||
                              provider.educationLevelIdController.text == "8" ||
                          provider.educationLevelIdController.text == "9"
                          ? true
                          : false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: buildSearchableDropdown<GraduationTypeData>(
                          items: provider.educationLevelIdController.text == "9"
                              ? provider.itiMainList
                              : provider.graduationTypeList,

                          // ✅ MAP YOUR MODEL HERE
                          getId: (item) => item.dropID.toString(),
                          getName: (item) => item.name ?? "",

                          controller: provider.graduationTypeNameController,
                          idController: provider.graduationTypeIdController,
                          hintText: AppLocalizations.of(context)!.selOption,
                          // height: 50,
                          // color: Colors.transparent,
                          // borderRadius: BorderRadius.circular(8),
                          onChanged: (value) {
                            if (provider.educationLevelIdController.text == "9") {
                              final selectedItem = value; // ✅ already object

                              setState(() {
                                provider.graduationTypeIdController.text =
                                    selectedItem.dropID.toString();
                                provider.graduationTypeNameController.text =
                                    selectedItem.name ?? "";
                              });

                              provider.onSelectItiItem(context, selectedItem, 0);
                            } else {
                              setState(() {
                                provider.graduationStreamTypeNameController.clear();
                                provider.graduationStreamTypeIdController.clear();
                                provider.graduationStreamTypeList.clear();

                                String id = provider.graduationTypeIdController.text;
                                provider.graduationStreamTypeApi(context, id);
                              });
                            }
                          },
                        ),
                      ),
                    ),

                    if (provider.educationLevelIdController.text == "9" &&
                        provider.showItiChildDropdown) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: labelWithStar(AppLocalizations.of(context)!.ITISubTradeType, required: true),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        child: buildSearchableDropdown<GraduationTypeData>(
                          items: provider.itiChildList,
                          getId: (item) => item.dropID.toString(),
                          getName: (item) => item.name ?? "",
                          controller: provider.itiChildNameController,
                          idController: provider.itiChildIdController,
                          hintText: AppLocalizations.of(context)!.selOption,
                          onChanged: (value) {
                            provider.onSelectItiItem(context, value, 1);
                          },
                        ),
                      ),
                    ],

                    // if (provider.educationLevelIdController.text == "9" &&
                    //     provider.showItiSubChildDropdown) ...[
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //     child: labelWithStar('ITI Sub Trade Type', required: true),
                    //   ),
                    //   Padding(
                    //     padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    //     child: buildSearchableDropdown<GraduationTypeData>(
                    //       items: provider.itiSubChildList,
                    //       getId: (item) => item.dropID.toString(),
                    //       getName: (item) => item.name ?? "",
                    //       controller: provider.itiSubChildNameController,
                    //       idController: provider.itiSubChildIdController,
                    //       hintText: "--Select Option--",
                    //       onChanged: (value) {
                    //         provider.onSelectItiItem(context, value, 2);
                    //       },
                    //     ),
                    //   ),
                    // ],

                    (provider.educationLevelIdController.text == "5" &&
                                provider.graduationTypeIdController.text ==
                                    "31") ||
                            (provider.educationLevelIdController.text == "6" &&
                                provider.graduationTypeIdController.text ==
                                    "90") ||
                            (provider.educationLevelIdController.text == "8" &&
                                provider.graduationTypeIdController.text ==
                                    "127")
                        ? labelWithStar(AppLocalizations.of(context)!.otherGraType, required: true)
                        : SizedBox(),

                    /* (provider.educationLevelIdController.text == "5" &&  provider.graduationTypeIdController.text == "31" )  ||  (provider.educationLevelIdController.text == "6" &&  provider.graduationTypeIdController.text == "90")  || (provider.educationLevelIdController.text == "8" &&  provider.graduationTypeIdController.text == "127" )  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Other Graduation Type",
                            style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14)),
                      ),
                    ) : SizedBox(),*/

                    (provider.educationLevelIdController.text == "5" &&
                                provider.graduationTypeIdController.text ==
                                    "31") ||
                            (provider.educationLevelIdController.text == "6" &&
                                provider.graduationTypeIdController.text ==
                                    "90") ||
                            (provider.educationLevelIdController.text == "8" &&
                                provider.graduationTypeIdController.text ==
                                    "127")
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.otherGraduationTypeController,
                              AppLocalizations.of(context)!.enterOtherGraType,
                              MediaQuery.of(context).size.width,
                              50,
                              TextInputType.text,
                            ),
                          )
                        : SizedBox(),

                    // stream Type for under graduate/graduate/post graduation
                    provider.educationLevelIdController.text == "5" ||
                        provider.educationLevelIdController.text ==
                            "6" ||
                        provider.educationLevelIdController.text ==
                            "8" ||
                        provider.educationLevelIdController.text ==
                            "9"
                        ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: labelWithStar(AppLocalizations.of(context)!.streamType,
                          required: true),
                    )
                        : SizedBox(),

                    Visibility(
                      visible: provider.educationLevelIdController.text ==
                          "5" ||
                          provider.educationLevelIdController.text ==
                              "6" ||
                          provider.educationLevelIdController.text ==
                              "8" ||
                          provider.educationLevelIdController.text ==
                              "9"
                          ? true
                          : false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: buildSearchableDropdown<GraduationStreamTypeData>(
                          items: provider.graduationStreamTypeList,

                          // ✅ MAP YOUR MODEL HERE
                          getId: (item) => item.dropID.toString(),
                          getName: (item) => item.name ?? "",

                          controller:
                          provider.graduationStreamTypeNameController,
                          idController:
                          provider.graduationStreamTypeIdController,
                          hintText: AppLocalizations.of(context)!.selOption,
                          // height: 50,
                          // color: Colors.transparent,
                          // borderRadius: BorderRadius.circular(8),
                          onChanged: (value) {
                            setState(() {
                              provider.otherStreamController.clear();
                            });
                          },
                        ),
                      ),
                    ),
                    // stream Type for under graduate/graduate/post graduation

                    provider.graduationStreamTypeIdController.text == "-1"
                        ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: labelWithStar(AppLocalizations.of(context)!.otherStream,
                          required: true),
                    )
                        : SizedBox(),

                    provider.graduationStreamTypeIdController.text == "-1"
                        ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: buildTextWithBorderField(
                        provider.otherStreamController,
                        AppLocalizations.of(context)!.enterOtherStream,
                        MediaQuery.of(context).size.width,
                        50,
                        TextInputType.text,
                      ),
                    )
                        : SizedBox(),


                    provider.educationLevelIdController.text == "5" ||
                            provider.educationLevelIdController.text == "6" ||
                            provider.educationLevelIdController.text == "8"
                        ? labelWithStar(AppLocalizations.of(context)!.university, required: true)
                        : SizedBox(),

                    /* provider.educationLevelIdController.text == "5" ||  provider.educationLevelIdController.text == "6"  ||  provider.educationLevelIdController.text == "8" ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("University ",
                            style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14)),
                      ),
                    ) : SizedBox(),*/

                    Visibility(
                      visible: provider.educationLevelIdController.text ==
                                  "5" ||
                              provider.educationLevelIdController.text == "6" ||
                              provider.educationLevelIdController.text == "8"
                          ? true
                          : false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: buildDropdownWithBorderField(
                          items: provider.universityList,
                          controller: provider.universityNameController,
                          idController: provider.universityIdController,

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
                          onChanged: (value) {
                            setState(() {});
                          },
                        ),
                      ),
                    ),

                    provider.universityIdController.text == "-1"
                        ? labelWithStar(AppLocalizations.of(context)!.otherUni, required: true)
                        : SizedBox(),

                    /* provider.universityIdController.text == "3"  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Other University",
                            style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14)),
                      ),
                    ) : SizedBox(),
*/
                    provider.universityIdController.text == "-1"
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.otherEducationUniversity,
                              AppLocalizations.of(context)!.enterOtherUni,
                              MediaQuery.of(context).size.width,
                              50,
                              TextInputType.text,
                            ),
                          )
                        : SizedBox(),

                    provider.educationLevelIdController.text == "5" ||
                            provider.educationLevelIdController.text == "6" ||
                            provider.educationLevelIdController.text == "8"
                        ? labelWithStar(AppLocalizations.of(context)!.college, required: true)
                        : SizedBox(),

                    /*   provider.educationLevelIdController.text == "5" ||  provider.educationLevelIdController.text == "6"  ||  provider.educationLevelIdController.text == "8" ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("College",
                            style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14)),
                      ),
                    ) : SizedBox(),*/

                    provider.educationLevelIdController.text == "5" ||
                            provider.educationLevelIdController.text == "6" ||
                            provider.educationLevelIdController.text == "8"
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.collageNameController,
                              AppLocalizations.of(context)!.enterCollege,
                              MediaQuery.of(context).size.width,
                              50,
                              TextInputType.text,
                            ),
                          )
                        : SizedBox(),

                    // under graduate / graduate / post graduate.......////

                    provider.educationLevelIdController.text != "1"
                        ? labelWithStar(AppLocalizations.of(context)!.medEdu, required: true)
                        : SizedBox(),

                    /* Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Medium of Education",
                            style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14)),
                      ),
                    ),*/

                    provider.educationLevelIdController.text != "1"
                        ? IgnorePointer(
                            ignoring: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 5),
                              child: buildDropdownWithBorderField(
                                items: provider.mediumTypeList,
                                controller:
                                    provider.mediumEducationNameController,
                                idController:
                                    provider.mediumEducationIdController,

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
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                          )
                        : SizedBox(),

                    provider.mediumEducationIdController.text == "70"
                        ? labelWithStar(AppLocalizations.of(context)!.otherMedEdu,
                            required: true)
                        : SizedBox(),

                    /* provider.mediumEducationIdController.text == "70"  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Other Medium of Education",
                            style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14)),
                      ),
                    ) : SizedBox(),*/

                    provider.mediumEducationIdController.text == "70"
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.otherMediumEducationController,
                              AppLocalizations.of(context)!.otherMedEdu,
                              MediaQuery.of(context).size.width,
                              50,
                              TextInputType.text,
                            ),
                          )
                        : SizedBox(),

                    provider.educationLevelIdController.text != "1"
                        ? labelWithStar(AppLocalizations.of(context)!.natureCourse, required: true)
                        : SizedBox(),

                    /* Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Nature of Course",
                            style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14)),
                      ),
                    ),*/

                    provider.educationLevelIdController.text != "1"
                        ? IgnorePointer(
                            ignoring: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 5),
                              child: buildDropdownWithBorderField(
                                items: provider.courseNatureList,
                                controller:
                                    provider.natureOfCourseNameController,
                                idController:
                                    provider.natureOfCourseIdController,

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
                          )
                        : SizedBox(),

                    provider.educationLevelIdController.text != "1"
                        ? labelWithStar(AppLocalizations.of(context)!.passingYear, required: true)
                        : SizedBox(),
                    /*   Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("Year of Passing",
                            style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14)),
                      ),
                    ),*/

                    /* IgnorePointer(
                      ignoring: false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: buildDropdownWithBorderField(
                          items: provider.passingYearList,
                          controller: provider.yearOfPassingNameController,
                          idController: provider.yearOfPassingIdController,
                          hintText: "--Select Option--",
                          height: 50,
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          onChanged: (value) {},
                        ),
                      ),
                    ),*/
                    provider.educationLevelIdController.text != "1"
                        ? InkWell(
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());
                              showDatePickerYearMonthDialog(
                                context,
                                provider.yearOfPassingNameController,
                                DateTime.now(), // initialDate
                                DateTime(
                                    DateTime.now().year - 100), // firstDate
                                DateTime.now(), // lastDate
                              ).then((_) {
                                setState(() {});
                              }).catchError((error) {
                                setState(() {});
                              });
                            },
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 5),
                              child: buildTextWithBorderField(
                                provider.yearOfPassingNameController,
                                AppLocalizations.of(context)!.selOption,
                                MediaQuery.of(context).size.width,
                                50,
                                TextInputType.text,
                                isEnabled: false,
                              ),
                            ),
                          )
                        : SizedBox(),

                    provider.educationLevelIdController.text != "1"
                        ? labelWithStar(AppLocalizations.of(context)!.ncoCode, required: true)
                        : SizedBox(),

                    /*  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text("NCO Code",
                            style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14)),
                      ),
                    ),*/

                    provider.educationLevelIdController.text != "1"
                        ? IgnorePointer(
                            ignoring: false,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 5),
                              child: buildDropdownWithBorderField(
                                items: provider.ncoCodeList,
                                controller: provider.ncoCodeNameController,
                                idController: provider.ncoCodeIdController,

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
                          )
                        : SizedBox(),

                    hSpace(6),
                    provider.educationLevelIdController.text != "1"
                        ? Text(
                            AppLocalizations.of(context)!.plzSelNocURQuali,
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          )
                        : SizedBox(),

                    hSpace(18),

                    provider.educationLevelIdController.text != "1"
                        ? labelWithStar(AppLocalizations.of(context)!.resultType, required: true)
                        : SizedBox(),

                    // Result Type (radio inline)
                    /* Text('Result Type',
                        style: Styles.mediumTextStyle(
                            color: kBlackColor, size: 14)),*/
                    hSpace(5),

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
                                        provider.gradeTypeNameController.text =
                                            "";
                                        provider.gradeTypeIdController.text =
                                            "";
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    AppLocalizations.of(context)!.grade,
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
                                        provider.gradeTypeNameController.text =
                                            "";
                                        provider.gradeTypeIdController.text =
                                            "";
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    AppLocalizations.of(context)!.percent,
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
                                        provider.gradeTypeNameController.text =
                                            "";
                                        provider.gradeTypeIdController.text =
                                            "";
                                      });
                                    },
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    AppLocalizations.of(context)!.CGPA,
                                    style: Styles.mediumTextStyle(
                                        color: kBlackColor, size: 14),
                                  ),
                                ],
                              ),
                            ],
                          )
                        : SizedBox(),

                    hSpace(5),

                    // CGPA Field

                    provider.educationLevelIdController.text != "1"
                        ? labelWithStar(provider.resultType, required: true)
                        : SizedBox(),
                    /* Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 0, vertical: 0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(provider.resultType,
                            style: Styles.mediumTextStyle(
                                color: kBlackColor, size: 14)),
                      ),
                    ),*/
                    provider.educationLevelIdController.text != "1" &&
                            provider.resultType != "Grade"
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 0, vertical: 5),
                            child: buildTextWithBorderField(
                              provider.resultType == "Percentage"
                                  ? provider.percentageController
                                  : provider.cgpaController,
                              'Enter ${provider.resultType}',
                              MediaQuery.of(context).size.width,
                              50,
                              TextInputType.number,
                            )
                      ,
                          )
                        : SizedBox(),

                    Visibility(
                      visible: provider.resultType == "Grade" ? true : false,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 5),
                        child: buildDropdownWithBorderField(
                          items: provider.gradeTypeList,
                          controller: provider.gradeTypeNameController,
                          idController: provider.gradeTypeIdController,

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
                    ),

                    const SizedBox(height: 26),

                    // Add button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          if (validateEducationForm(context, provider)) {
                            confirmAlertDialog(
                              context,
                              AppLocalizations.of(context)!.alert,
                              AppLocalizations.of(context)!.areYouSureSubmitForm,
                              (value) {
                                if (value.toString() == "success") {
                                  provider.saveDataEducationDetailsApi(context);
                                }
                              },
                            );
                          }

                          // Example: simple form validation
                          // if (_formKey.currentState?.validate() ?? true) {
                          //   // handle save
                          //   ScaffoldMessenger.of(context).showSnackBar(
                          //     const SnackBar(content: Text('Saved (demo)')),
                          //   );
                          // }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: kPrimaryColor, // nicer blue
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          elevation: 0,
                        ),
                        child: Text(AppLocalizations.of(context)!.add,
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

  String getGraduationTypeLabel() {
    final provider = Provider.of<AddEducationalDetailProvider>(context, listen: false);
    switch (provider.educationLevelIdController.text) {
      case "5":
        return AppLocalizations.of(context)!.underGradType;

      case "6":
        return AppLocalizations.of(context)!.gradType;

      case "8":
        return AppLocalizations.of(context)!.postGradType;

      case "9":
        return AppLocalizations.of(context)!.ITITradeType;

      default:
        return AppLocalizations.of(context)!.gradType;
    }
  }

  bool validateEducationForm(BuildContext context, provider) {
    // ---------- EDUCATION LEVEL ----------
    if (provider.educationLevelIdController.text.trim().isEmpty) {
      showAlertError(AppLocalizations.of(context)!.plzSelEduLevel, context);
      return false;
    }

    String edu = provider.educationLevelIdController.text.trim();

    // ---------- BELOW 10 (ID = 2) ----------
    if (edu == "2") {
      if (provider.classIdController.text.trim().isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelClass, context);
        return false;
      }

      if (provider.schoolNameController.text.trim().isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzEnterSchName, context);
        return false;
      }
    }

    // ---------- 10th (ID = 3) ----------
    if (edu == "3") {
      if (provider.boardIdController.text.trim().isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelBoard, context);
        return false;
      }
      if (provider.schoolNameController.text.trim().isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzEnterSchName, context);
        return false;
      }
    }

    // ---------- 12th (ID = 4) ----------
    if (edu == "4") {
      if (provider.boardIdController.text.trim().isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelBoard, context);
        return false;
      }
      if (provider.streamIdController.text.trim().isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelStream, context);
        return false;
      }
      if (provider.schoolNameController.text.trim().isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzEnterSchName, context);
        return false;
      }
    }

    // ---------- UG / PG / Diploma (ID = 5,6,8) ----------
    if (edu == "5" || edu == "6" || edu == "8") {
      // Graduation Type
      if (provider.graduationTypeIdController.text.trim().isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelGraType, context);
        return false;
      }

      // "Other Graduation Type"
      if ((edu == "5" && provider.graduationTypeIdController.text == "31") ||
          (edu == "6" && provider.graduationTypeIdController.text == "90") ||
          (edu == "8" && provider.graduationTypeIdController.text == "127")) {
        if (provider.otherGraduationTypeController.text.trim().isEmpty) {
          showAlertError(AppLocalizations.of(context)!.plzEnterOtherGraType, context);
          return false;
        }
      }

      // University
      if (provider.universityIdController.text.trim().isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelUniv, context);
        return false;
      }

      if (provider.universityIdController.text == "3") {
        if (provider.otherEducationUniversity.text.trim().isEmpty) {
          showAlertError(AppLocalizations.of(context)!.plzEnterOtherUni, context);
          return false;
        }
      }

      // College Name
      if (provider.collageNameController.text.trim().isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzEnterClgName, context);
        return false;
      }
    }

    // ---------- MEDIUM OF EDUCATION (for all except ID = 1) ----------
    if (edu != "1") {
      if (provider.mediumEducationIdController.text.trim().isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelMedEdu, context);
        return false;
      }

      if (provider.mediumEducationIdController.text == "70") {
        if (provider.otherMediumEducationController.text.trim().isEmpty) {
          showAlertError(AppLocalizations.of(context)!.plzEnterOthMedEdu, context);
          return false;
        }
      }

      // ---------- NATURE OF COURSE ----------
      if (provider.natureOfCourseIdController.text.trim().isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelNatCourse, context);
        return false;
      }

      // ---------- YEAR OF PASSING ----------
      if (provider.yearOfPassingNameController.text.trim().isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelYearPass, context);
        return false;
      }

      // ---------- NCO CODE ----------
      if (provider.ncoCodeIdController.text.trim().isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelNcoCode, context);
        return false;
      }

      // ---------- RESULT TYPE ----------
      if (provider.resultType.trim().isEmpty) {
        showAlertError(AppLocalizations.of(context)!.plzSelResType, context);
        return false;
      }

      if (provider.resultType == "Percentage") {
        if (provider.percentageController.text.trim().isEmpty) {
          showAlertError(AppLocalizations.of(context)!.plzEnterPerc, context);
          return false;
        }
      }

      if (provider.resultType == "CGPA") {
        if (provider.cgpaController.text.trim().isEmpty) {
          showAlertError(AppLocalizations.of(context)!.plzEnterCGPA, context);
          return false;
        }
      }

      if (provider.resultType == "Grade") {
        if (provider.gradeTypeIdController.text.trim().isEmpty) {
          showAlertError(AppLocalizations.of(context)!.plzEnterGrade, context);
          return false;
        }
      }

      // // Result → Grade
      // if (provider.resultType == "Grade") {
      //   if (provider.gradeTypeIdController.text.trim().isEmpty) {
      //     showAlertError("Please select Grade", context);
      //     return false;
      //   }
      // }
      //
      // // Result → Percentage / CGPA
      // else {
      //   if (provider.gradeTypeNameController.text.trim().isEmpty) {
      //     showAlertError("Please enter ${provider.resultType}", context);
      //     return false;
      //   }
      // }
    }

    return true;
  }
}
