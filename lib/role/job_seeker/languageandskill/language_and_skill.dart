import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/languageandskill/provider/language_and_skill_provider.dart';
import 'package:rajemployment/utils/dot_border.dart';

import '../../../utils/global.dart';
import '../../../utils/textstyles.dart';
import '../add_language_skills/add_language_skills.dart';
import '../addjobpreference/add_job_preference.dart';
import '../loginscreen/provider/locale_provider.dart';

class LanguageAndSkillScreen extends StatefulWidget {
  const LanguageAndSkillScreen({super.key});

  @override
  State<LanguageAndSkillScreen> createState() => _LanguageAndSkillScreenState();
}

class _LanguageAndSkillScreenState extends State<LanguageAndSkillScreen> {




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider =
      Provider.of<LanguageAndSkillProvider>(context, listen: false);
     // provider.clearData();
      provider.profileLanguageInfoApi(context);
      provider.profileSkillInfoApi(context);
    });

  }


  @override
  Widget build(BuildContext context) {


    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2("Language & Skills", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),
        body: Consumer<LanguageAndSkillProvider>(builder: (context, provider, child) {
          return   Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // 🔹 FIXED HEADER (Not Scrollable)
               // const DottedBorder(),

                Row(
                  children: [
                    Expanded(
                      child: AddDottedCard(
                        icon: Icons.build,
                        title: "Add Skill",
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddLanguageSkillsScreen(
                                isUpdateSkill: false,
                                isUpdateLanguage: false,
                                profileSkillInfoData: null,
                                profileLanguageInfoData: null,
                                showSkillSection: true,
                                showLanguageSection: false,
                              ),
                            ),
                          );

                          if (result == "success") {
                            context.read<LanguageAndSkillProvider>()
                              ..profileSkillInfoApi(context)
                              ..profileLanguageInfoApi(context);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AddDottedCard(
                        icon: Icons.language,
                        title: "Add Language",
                        onTap: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddLanguageSkillsScreen(
                                isUpdateSkill: false,
                                isUpdateLanguage: false,
                                profileSkillInfoData: null,
                                profileLanguageInfoData: null,
                                showSkillSection: false,
                                showLanguageSection: true,
                              ),
                            ),
                          );

                          if (result == "success") {
                            context.read<LanguageAndSkillProvider>()
                              ..profileSkillInfoApi(context)
                              ..profileLanguageInfoApi(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),


                // Row(
                //   children: [
                //     Expanded(
                //       child: ElevatedButton.icon(
                //         icon: const Icon(Icons.add),
                //         label: const Text("Add / Update Skill"),
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: kPrimaryColor,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(12),
                //           ),
                //         ),
                //         onPressed: () async {
                //           final result = await Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => AddLanguageSkillsScreen(
                //                 isUpdateSkill: false,
                //                 isUpdateLanguage: false,
                //                 profileSkillInfoData: null,
                //                 profileLanguageInfoData: null,
                //                 showSkillSection: true,
                //                 showLanguageSection: false,
                //               ),
                //             ),
                //           );
                //
                //           if (result == "success") {
                //             Provider.of<LanguageAndSkillProvider>(context, listen: false)
                //               ..profileSkillInfoApi(context)
                //               ..profileLanguageInfoApi(context);
                //           }
                //         },
                //       ),
                //     ),
                //     const SizedBox(width: 12),
                //     Expanded(
                //       child: ElevatedButton.icon(
                //         icon: const Icon(Icons.language),
                //         label: const Text("Add / Update Language"),
                //         style: ElevatedButton.styleFrom(
                //           backgroundColor: Colors.green,
                //           shape: RoundedRectangleBorder(
                //             borderRadius: BorderRadius.circular(12),
                //           ),
                //         ),
                //         onPressed: () async {
                //           final result = await Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => AddLanguageSkillsScreen(
                //                 isUpdateSkill: false,
                //                 isUpdateLanguage: false,
                //                 profileSkillInfoData: null,
                //                 profileLanguageInfoData: null,
                //                 showSkillSection: false,
                //                 showLanguageSection: true,
                //               ),
                //             ),
                //           );
                //
                //           if (result == "success") {
                //             Provider.of<LanguageAndSkillProvider>(context, listen: false)
                //               ..profileSkillInfoApi(context)
                //               ..profileLanguageInfoApi(context);
                //           }
                //         },
                //       ),
                //     ),
                //   ],
                // ),


                const SizedBox(height: 25),

                // 🔹 SCROLLABLE CONTENT
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.zero,
                    physics: const BouncingScrollPhysics(),
                    children: [

                      // ---- Skill Summary Title ----
                      Text(
                        "Skill Summary",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // ---- Skill Summary List ----
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.skillList.length,
                        itemBuilder: (context, index) {
                          final data = provider.skillList[index];
                          // return EducationCard(
                          //   index: index,
                          //   skillDetailID: data.skillDetailID.toString(),
                          //   categoryName: data.categoryName.toString(),
                          //   subCategoryName:  data.subCategoryName.toString(),
                          //   ncoCode: data.nCOCode.toString(),
                          //   acquiredName: data.acquiredName,
                          //   //experience: data.experienceInYear.toString() + " -" + data.experienceInMonth.toString() ,
                          //   experience: "${data.experienceInYear ?? 0} - ${data.experienceInMonth ?? 0}",
                          // );
                          return EducationCard(
                            index: index,
                            skillDetailID: data.skillDetailID?.toString() ?? "",
                            categoryName: data.categoryName ?? "",
                            subCategoryName: data.subCategoryName ?? "",
                            ncoCode: data.nCOCode ?? "",
                            acquiredName: data.acquiredName ?? "",
                            experience: "${data.experienceInYear ?? 0} - ${data.experienceInMonth ?? 0}",
                          );

                        },
                      ),

                      // ---- Language Title ----
                      Text(
                        "Language Known",
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // ---- Language List ----
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: provider.languageList.length,
                        itemBuilder: (context, index) {
                          final lang = provider.languageList[index];
                          return LanguageCard(
                            index:index,
                            languageID:lang.languageDetailID?.toString() ?? "",
                            language:lang.languageName ?? "",
                            proficiencyName: lang.proficiencyName ?? "",
                            readStatus: lang.readStatus,
                            writeStatus: lang.writeStatus,
                            speakStatus: lang.speakStatus,
                          );
                        },
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );

        }));
       }
}

class AddDottedCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const AddDottedCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return DashedBorderContainer(
      color: const Color(0xFFF3E5F9),
      dash: 4,
      gap: 4,
      strokeWidth: 2,
      radius: "15",
      child: InkWell(
        borderRadius: BorderRadius.circular(15),
        onTap: onTap,
        child: SizedBox(
          height: 90,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Icon(icon, color: kPrimaryColor, size: 30),
                const Icon(
                  Icons.add_circle, // ✅ SAME PLUS ICON
                  color: kPrimaryColor,
                  size: 30,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(color: Colors.black54),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// 🔹 Dotted Border Widget
class DottedBorder extends StatelessWidget {
  const DottedBorder({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageAndSkillProvider>(context, listen: false);

    return DashedBorderContainer(
      color: const Color(0xFFF3E5F9),
      dash: 4,
      gap: 4,
      strokeWidth: 2,
      radius: "15",
      child: SizedBox(
        height: 80,
        child: InkWell(
          onTap: () {
            _showAddOptionSheet(context);
          },
          child: const Center(
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle, color: kPrimaryColor, size: 30),
                  SizedBox(width: 6, height: 8),
                  Text(
                    "Add Languages & Skills",
                    style: TextStyle(color: Colors.black54),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

void _showAddOptionSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.build, color: kPrimaryColor),
              title: const Text("Add Skill"),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddLanguageSkillsScreen(
                      isUpdateSkill: false,
                      isUpdateLanguage: false,
                      profileSkillInfoData: null,
                      profileLanguageInfoData: null,
                      showSkillSection: true,
                      showLanguageSection: false,
                    ),
                  ),
                );

                if (result == "success") {
                  final provider = context.read<LanguageAndSkillProvider>();
                  provider.profileSkillInfoApi(context);
                  provider.profileLanguageInfoApi(context);
                }

              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.language, color: Colors.green),
              title: const Text("Add Language"),
              onTap: () async {
                Navigator.pop(context);
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddLanguageSkillsScreen(
                      isUpdateSkill: false,
                      isUpdateLanguage: false,
                      profileSkillInfoData: null,
                      profileLanguageInfoData: null,
                      showSkillSection: false,
                      showLanguageSection: true,
                    ),
                  ),
                );

                if (result == "success") {
                  final provider = context.read<LanguageAndSkillProvider>();
                  provider.profileSkillInfoApi(context);
                  provider.profileLanguageInfoApi(context);
                }

              },
            ),
          ],
        ),
      );
    },
  );
}


// 🔹 Education Card
class EducationCard extends StatelessWidget {
  final int index;
  final String skillDetailID;
  final String categoryName;
  final String subCategoryName;
  final String ncoCode;
  final String acquiredName;
  final String experience;

  const EducationCard({
    super.key,
    required this.index,
    required this.skillDetailID,
    required this.categoryName,
    required this.subCategoryName,
    required this.ncoCode,
    required this.acquiredName,
    required this.experience,
  });

  @override
  Widget build(BuildContext context) {
    final provider =
    Provider.of<LanguageAndSkillProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: Text(
                    checkNullValue(categoryName),
                    style:
                    Styles.semiBoldTextStyle(size: 14, color: kBlackColor),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.2,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: kJobFlotBackColor,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Center(
                    child: Text(
                      textAlign: TextAlign.center,
                      checkNullValue(acquiredName),
                      style: TextStyle(color: kJobFontColor, fontSize: 12),
                    ),
                  ),
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap:() async {
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AddLanguageSkillsScreen(
                                  isUpdateSkill: true,
                                  isUpdateLanguage: false,
                                  profileSkillInfoData:provider.skillList[index],
                                  profileLanguageInfoData: null,
                                  showSkillSection: true,
                                  showLanguageSection: false,
                                ),
                              ),
                            );

                            // if (result != null) {
                            //   provider.profileLanguageInfoApi(context);
                            // }
                            if (result == "success") {
                              provider.profileSkillInfoApi(context);
                              provider.profileLanguageInfoApi(context);
                            }
                          },
                          child: SvgPicture.asset(
                            'assets/icons/edit.svg',
                            height: 20,
                          ),
                        ),
                        SizedBox(width: 10),
                        InkWell(
                          onTap: () {
                            confirmAlertDialog(context, "Alert","Are you sure want to delete ?", (value) {
                              if (value.toString() == "success") {
                                provider.deleteSkillsDetailProfileApi(context,skillDetailID);

                              }
                            },
                            );
                          },
                          child: SvgPicture.asset(
                            'assets/icons/trash.svg',
                            height: 20,
                          ),
                        ),
                      ],
                    )),
              ],
            ),
            Container(
                child: Text(
                  checkNullValue(subCategoryName),
                  overflow: TextOverflow.ellipsis,
                  style: Styles.mediumTextStyle(size: 14, color: fontGrayColor),
                )),
            const SizedBox(height: 6),
            Divider(color: dividerColor),
            Container(
                alignment: Alignment.topLeft,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Text(
                  "NCO Code: ${checkNullValue(ncoCode)}",
                  style:
                  Styles.regularTextStyle(size: 13, color: fontGrayColor),
                )),
            Divider(color: dividerColor),
            Row(
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    width: MediaQuery.of(context).size.width * 0.42,
                    child: Text(
                      "Acquired Through: ${checkNullValue(acquiredName)}",
                      style: Styles.regularTextStyle(
                          size: 13, color: fontGrayColor),
                    )),
                Container(
                    alignment: Alignment.topRight,
                    width: MediaQuery.of(context).size.width * 0.42,
                    child: Text(
                      "${checkNullValue(experience)}",
                      style: Styles.regularTextStyle(
                          size: 13, color: fontGrayColor),
                    )),
              ],
            ),
            Divider(color: dividerColor),

            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

// 🔹 Language Card (Updated Design)
class LanguageCard extends StatelessWidget {
  final int index;
  final String languageID;
  final String language;
  final String proficiencyName;
  final String? readStatus;
  final String? writeStatus;
  final String? speakStatus;

  const LanguageCard({
    super.key,
    required this.index,
    required this.languageID,
    required this.language,
    required this.proficiencyName,
    required this.readStatus,
    required this.writeStatus,
    required this.speakStatus,
  });

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<LanguageAndSkillProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Left Side (Language + Ability)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(checkNullValue(language),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 15)),
                const SizedBox(height: 4),
                Text(checkNullValue(proficiencyName),
                    style: const TextStyle(color: Colors.black54, fontSize: 13)),
              ],
            ),

            // Right Side (Level Tag)
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    getLanguageStatus(readStatus,writeStatus,speakStatus),
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                ),
                hSpace(5),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [

                    Container(
                        width: MediaQuery.of(context).size.width * 0.2,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap:() async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddLanguageSkillsScreen(
                                      isUpdateSkill: false,
                                      isUpdateLanguage: true,
                                      profileSkillInfoData: null,
                                      profileLanguageInfoData:  provider.languageList[index],
                                      showSkillSection: false,
                                      showLanguageSection: true,
                                    ),
                                  ),
                                );

                                // if (result != null) {
                                //   provider.profileLanguageInfoApi(context);
                                // }

                                if (result == "success") {
                                  provider.profileSkillInfoApi(context);
                                  provider.profileLanguageInfoApi(context);
                                }
                              },
                              child: SvgPicture.asset(
                                'assets/icons/edit.svg',
                                height: 20,
                              ),
                            ),
                            SizedBox(width: 10),
                            InkWell(
                              onTap: () {
                                confirmAlertDialog(context, "Alert","Are you sure want to delete ?", (value) {
                                  if (value.toString() == "success") {
                                    provider.deleteDetailProfileApi(context,languageID);

                                  }
                                },
                                );
                              },
                              child: SvgPicture.asset(
                                'assets/icons/trash.svg',
                                height: 20,
                              ),
                            ),
                          ],
                        )),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String getLanguageStatus(String? readStatus, String? writeStatus, String? speakStatus) {
    bool r = readStatus == "1";
    bool w = writeStatus == "1";
    bool s = speakStatus == "1";

    if (r && w && s) {
      return "Read, Write, Speak";
    } else if (r && w) {
      return "Read, Write";
    } else if (r && s) {
      return "Read, Speak";
    } else if (w && s) {
      return "Write, Speak";
    } else if (r) {
      return "Read";
    } else if (w) {
      return "Write";
    } else if (s) {
      return "Speak";
    } else {
      return "-";
    }
  }

}
