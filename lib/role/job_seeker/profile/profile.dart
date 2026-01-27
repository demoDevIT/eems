import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/profile/provider/profile_provider.dart';
import 'package:rajemployment/utils/user_new.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/images.dart';
import '../../../utils/textstyles.dart';
import '../addressinfo/address_info.dart';
import '../basicdetails/basic_detail.dart';
import '../educationdetail/education_details.dart';
import '../jobpreference/job_preference.dart';
import '../languageandskill/language_and_skill.dart';
import '../physicalattribute/physicalattribute_screen.dart';
import '../share_feedback/share_feedback_details.dart';
import '../videoprofile/videoprofile_screen.dart';
import '../workexperience/work_experience.dart';

class ProfileScreen extends StatefulWidget {
   bool isAppBarHide;
   ProfileScreen({super.key, required this.isAppBarHide});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    print("LatestPhoto" + UserData().model.value.latestPhotoPath.toString());
    return Scaffold(
      appBar: widget.isAppBarHide ?  AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () {
            Navigator.pop(context); // go back to previous screen
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.compltprofle,
          style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ) : null,

        body: Consumer<ProfileProvider>(builder: (context, provider, child) {
          return   SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// Profile Section
            Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  clipBehavior: Clip.none,
                  children: [
                    Transform.rotate(
                      angle: 2.00,
                      child: SizedBox(
                        width: 90,
                        height: 90,
                        child: CircularProgressIndicator(
                          value: 0.7, // 70%
                          strokeWidth: 7,
                          backgroundColor: Colors.grey[300],
                          valueColor: const AlwaysStoppedAnimation<Color>(kViewAllColor),
                        ),
                      ),
                    ),
                    ClipOval(
                      child: Image.network(
                        UserData().model.value.latestPhotoPath.toString(),
                        width: MediaQuery.of(context).size.width * 0.18,
                        height: MediaQuery.of(context).size.width * 0.18,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            Images.placeholder,
                            width: MediaQuery.of(context).size.width * 0.19,
                            height: MediaQuery.of(context).size.width * 0.19,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    // ✅ Moved and adjusted this Positioned widget
                    Positioned(
                      right: -10, // half outside
                      top: 5, // vertically centered on right side
                      child: Container(
                        alignment: Alignment.center,
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: FFF2EDColor,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 2,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                        child: const Text(
                          "70%",
                          style: TextStyle(
                            color: kDarkOrangeColor,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        UserData().model.value.nAMEENG.toString(),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        UserData().model.value.eMAILID.toString(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

                /// Menu List
                buildMenuItem(context, "Basic Details", AppLocalizations.of(context)!.basicdetl),
                buildMenuItem(context, "Address Info", AppLocalizations.of(context)!.addinfo),
                buildMenuItem(context, "Education Details", AppLocalizations.of(context)!.edudetl),
                buildMenuItem(context, "Work experience", AppLocalizations.of(context)!.workexp),
                buildMenuItem(context, "Language/Skills", AppLocalizations.of(context)!.langskill),
                buildMenuItem(context, "Physical Attributes", AppLocalizations.of(context)!.physattri),
                buildMenuItem(context, "Job Preference", AppLocalizations.of(context)!.jobpref),
               // buildMenuItem(context, "Video Profile", AppLocalizations.of(context)!.videoprof),
              ],
            ),
          );
        }));

  }

  Widget buildMenuItem(BuildContext context, String title, titleLang) {

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ListTile(
        title: Text(titleLang, style: Styles.semiBoldTextStyle(size: 14,color: kBlackColor)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: kBlackColor),
        onTap: () {
          if (title == "Basic Details") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BasicDetailsScreen()),
            );
            /*Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShareFeedbackDetailsScreen()),
            );*/
          } else if (title == "Address Info") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddressInfoScreen()),
            );
          }
          else if (title == "Education Details") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => EducationalDetailsScreen()),
            );
          } else if (title == "Work experience") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WorkExperienceScreen()),
            );
          }
          else if (title == "Language/Skills") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LanguageAndSkillScreen()),
            );
          }
          else if (title == "Physical Attributes") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PhysicalattributeScreen()),
            );
          }
          else if (title == "Job Preference") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => JobPreferenceScreen()),
            );
          }


          else if (title == "Video Profile") {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => VideoprofileScreen()),
            );
          }
          // Add more conditions for other menu items as needed
        },
      ),
    );
  }
}
