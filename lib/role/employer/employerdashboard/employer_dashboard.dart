import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_shared_prefrence.dart';
import '../../../utils/global.dart';
import '../../../utils/textstyles.dart';
import '../../../utils/user_new.dart';
import '../../job_seeker/grievance/grievance_list.dart';
import '../../job_seeker/loginscreen/screen/login_screen.dart';
import '../emp_profile/profile_screen.dart';
import '../job_application/job_application.dart';
import '../job_fair/job_fair.dart';
import '../job_post/job_post.dart';

class EmployerDashboard extends StatefulWidget {
  const EmployerDashboard({super.key});

  @override
  State<EmployerDashboard> createState() => _EmployerDashboardState();
}

class _EmployerDashboardState extends State<EmployerDashboard> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(),
      appBar: AppBar(
        title: const Text(
          "Employee Dashboard",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      backgroundColor: const Color(0xFFF2F4F8),
      body: _buildDashboardGrid(),
    );
  }


  Widget _buildDashboardGrid() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          _dashboardListTile(
            title: "View Profile",
            iconPath: "assets/images/profilee.svg",
            color: const Color(0xFF6C63FF),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmployerProfileScreen(),
                ),
              );
            },
          ),

          _dashboardListTile(
            title: "Post Job in Job Fair",
            iconPath: "assets/images/postJob.svg",
            color: const Color(0xFFFF7A59),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JobPostScreen(),
                ),
              );
            },
          ),

          _dashboardListTile(
            title: "Apply for Job Fair",
            iconPath: "assets/images/aplyjobfair.svg",
            color: const Color(0xFF2DBE8D),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JobFairScreen(),
                ),
              );
            },
          ),

          _dashboardListTile(
            title: "Job Fair Job Applications",
            iconPath: "assets/images/jobapp.svg",
            color: const Color(0xFF6C63FF),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const JobApplicationScreen(),
                ),
              );
            },
          ),

          _dashboardListTile(
            title: "Grievances",
            iconPath: "assets/images/grievances.svg",
            color: const Color(0xFFFF7A59),
            onTap: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GrievanceScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _dashboardListTile({
    required String title,
    required String iconPath,
    required Color color,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      child: Material(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
            child: Row(
              children: [
                // SVG Icon box
                Container(
                  height: 45,
                  width: 45,
                  // decoration: BoxDecoration(
                  //   color: color.withOpacity(0.15),
                  //   borderRadius: BorderRadius.circular(12),
                  // ),
                  child: Center(
                    child: SvgPicture.asset(
                      iconPath,
                      height: 42,
                      width: 42,
                      //color: color, // applies tint to SVG
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                // Title
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                // Arrow
                Container(
                  height: 28,
                  width: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.white,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _dashboardTile({
    required String title,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }



  /// Side Drawer
  Drawer _buildSideDrawer() {
    return Drawer(
      child: ListView(
        children: [
          // ===== Header =====
          Container(
            padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        UserData().model.value.latestPhotoPath.toString(),
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/placeholder.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          UserData().model.value.branchName.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => const ProfileScreen(isAppBarHide: true),
                            //   ),
                            // );
                          },
                          child: const Text(
                            "Update Profile",
                            style: TextStyle(
                              fontSize: 14,
                              color: kViewAllColor,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: SvgPicture.asset(
                    'assets/icons/close.svg',
                    width: 25,
                    height: 25,
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard", style: TextStyle(fontSize: 14)),
            onTap: () {
              Navigator.pop(context); // Already on dashboard
            },
          ),
          const Divider(),
          // ===== Job Fair Events =====
          ExpansionTile(
            leading: SvgPicture.asset(
              'assets/icons/calendarNew.svg',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            title: Text(
              AppLocalizations.of(context)!.jobfairevents,
              style: Styles.mediumTextStyle(size: 14),
            ),
            children: [
              ListTile(
                title: Text("Events", style: Styles.mediumTextStyle(size: 14)),
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => JobsFairEventScreen()),
                  // );
                },
              ),
              ListTile(
                title: Text("Registered Event", style: Styles.mediumTextStyle(size: 14)),
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => RegisteredEventListScreen()),
                  // );
                },
              ),
              ListTile(
                title: Text("Job Apply", style: Styles.mediumTextStyle(size: 14)),
                onTap: () {
                  Navigator.pop(context);
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(builder: (context) => SelectCompanyPage()),
                  // );
                },
              ),
            ],
          ),

          // ===== Divider before Logout =====
          Container(
            margin: const EdgeInsets.only(left: 50),
            child: const Divider(height: 1, color: E3E5F9Color),
          ),

          // ===== Logout =====
          ListTile(
            leading: SvgPicture.asset(
              'assets/icons/logout.svg',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            title: Text(
              AppLocalizations.of(context)!.logout,
              style: Styles.mediumTextStyle(size: 14),
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              showLogoutDialog(context, "Logout","Are you sure want to Logout ?", "Thank you and see you again!", (value) {
                if (value.toString() == "success") {
                  final pref = AppSharedPref();
                  pref.save('UserData', '');
                  pref.remove('UserData');
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (BuildContext context) =>
                      const LoginScreen(),
                    ),
                  );
                }
              },
              );
            },
          ),
        ],
      ),
    );
  }
}
