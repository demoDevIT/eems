import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_shared_prefrence.dart';
import '../../../utils/global.dart';
import '../../../utils/textstyles.dart';
import '../../../utils/user_new.dart';
import '../../job_seeker/loginscreen/screen/login_screen.dart';
import '../emp_profile/profile_screen.dart';

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
          "Dashboard",
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
      child: GridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.1,
        children: [
          _dashboardTile(
            title: "View Profile",
            color: const Color(0xFF4A76C9),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const EmployerProfileScreen(),
                ),
              );
            },
          ),

          _dashboardTile(
            title: "Search Job\nSeekers Near Me",
            color: const Color(0xFF4A76C9),
          ),
          _dashboardTile(
            title: "Post Job",
            color: const Color(0xFF4A76C9),
          ),
          _dashboardTile(
            title: "Search Job\nSeeker By Skills",
            color: const Color(0xFF4A76C9),
          ),
          _dashboardTile(
            title: "Search Job\nSeeker By Qualification",
            color: const Color(0xFF4A76C9),
          ),
          _dashboardTile(
            title: "Search Job\nSeeker By Experience",
            color: const Color(0xFF4A76C9),
          ),
          _dashboardTile(
            title: "Apply for\nJob Fair",
            color: const Color(0xFF4A76C9),
          ),
          _dashboardTile(
            title: "Feedback/\nRating",
            color: const Color(0xFF4A76C9),
          ),
        ],
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
