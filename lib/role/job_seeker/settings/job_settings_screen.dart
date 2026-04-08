import 'package:flutter/material.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/size_config.dart';

import '../../../utils/right_to_left_route.dart';
import '../faqs_screen/faqs_screen.dart';

class JobSettingsScreen extends StatefulWidget {
  const JobSettingsScreen({super.key});

  @override
  State<JobSettingsScreen> createState() => _JobSettingsPageState();
}

class _JobSettingsPageState extends State<JobSettingsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool jobAlert = true;
  bool emailNotification = false;
  bool darkMode = false;
  bool profileVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey.shade100,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// Profile Card
            // Container(
            //   padding: const EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: kViewAllColor,
            //     borderRadius: BorderRadius.circular(20),
            //   ),
            //   child: Row(
            //     children: const [
            //       CircleAvatar(
            //         radius: 35,
            //         backgroundImage: NetworkImage(
            //             "https://i.pravatar.cc/150?img=3"),
            //       ),
            //       SizedBox(width: 15),
            //       Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           Text("Mohammad ",
            //               style: TextStyle(
            //                   color: Colors.white,
            //                   fontSize: 18,
            //                   fontWeight: FontWeight.bold)),
            //           SizedBox(height: 5),
            //           Text("Flutter Developer",
            //               style: TextStyle(color: Colors.white70)),
            //         ],
            //       )
            //     ],
            //   ),
            // ),
            SizedBox(height: SizeConfig.defaultSize! * 2),
            buildSectionTitle("Job Preferences"),
            buildSwitchTile(
              icon: Icons.work_outline,
              title: "Job Alerts",
              value: jobAlert,
              onChanged: (val) {
                setState(() {
                  jobAlert = val;
                });
              },
            ),
            // buildSwitchTile(
            //   icon: Icons.email_outlined,
            //   title: "Email Notifications",
            //   value: emailNotification,
            //   onChanged: (val) {
            //     setState(() {
            //       emailNotification = val;
            //     });
            //   },
            // ),
            SizedBox(height: SizeConfig.defaultSize! ),
            buildSectionTitle("Privacy"),
            buildSwitchTile(
              icon: Icons.visibility_outlined,
              title: "Profile Visible to Recruiters",
              value: profileVisible,
              onChanged: (val) {
                setState(() {
                  profileVisible = val;
                });
              },
            ),
            // SizedBox(height: SizeConfig.defaultSize! ),
            // buildSectionTitle("App Settings"),
            // buildSwitchTile(
            //   icon: Icons.dark_mode_outlined,
            //   title: "Dark Mode",
            //   value: darkMode,
            //   onChanged: (val) {
            //     setState(() {
            //       darkMode = val;
            //     });
            //   },
            // ),
            SizedBox(height: SizeConfig.defaultSize! ),
            buildSectionTitle("Support"),
            buildNavigationTile(
              icon: Icons.help_outline,
              title: "FAQs",
              onTap: () {
                Navigator.of(_scaffoldKey.currentContext!)
                    .push(
                  RightToLeftRoute(
                    page:  FaqsScreen(),
                    duration: const Duration(milliseconds: 500),
                    startOffset: const Offset(-1.0, 0.0),
                  ),
                );
              },
            ),

            // buildNavigationTile(
            //   icon: Icons.privacy_tip_outlined,
            //   title: "Privacy Policy",
            //   onTap: () {},
            // ),

            buildNavigationTile(
              icon: Icons.info_outline,
              title: "About App",
              onTap: () {},
            ),
            SizedBox(height: SizeConfig.defaultSize! * 4 ),

            // SizedBox(
            //   width: double.infinity,
            //   child: ElevatedButton(
            //     style: ElevatedButton.styleFrom(
            //       backgroundColor: Colors.red,
            //       padding: const EdgeInsets.symmetric(vertical: 14),
            //       shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(14)),
            //     ),
            //     onPressed: () {},
            //     child: const Text(
            //       "Logout",
            //       style: TextStyle(fontSize: 16),
            //     ),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
  Widget buildNavigationTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 5,
              spreadRadius: 2)
        ],
      ),
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
  Widget buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          title,
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget buildSwitchTile({
    required IconData icon,
    required String title,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 5,
              spreadRadius: 2)
        ],
      ),
      child: SwitchListTile(
        secondary: Icon(icon),
        title: Text(title),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
