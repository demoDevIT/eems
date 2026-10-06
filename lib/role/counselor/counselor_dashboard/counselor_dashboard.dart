import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rajemployment/role/counselor/counselor_dashboard/provider/counselor_dash_provider.dart';
import 'package:rajemployment/role/counselor/create_session/screen/create_session_info.dart';
import 'package:rajemployment/role/job_seeker/loginscreen/provider/locale_provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repo/common_repo.dart';
import '../../../utils/app_shared_prefrence.dart';
import '../../../utils/global.dart';
import '../../../utils/right_to_left_route.dart';
import '../../../utils/size_config.dart';
import '../../../utils/user_new.dart';
import '../../employer/job_fair/job_fair.dart';
import '../../job_seeker/grievance/grievance_list.dart';
import '../../job_seeker/homescreen/home_screen.dart';
import '../../job_seeker/job_fair_event/job_fair_event_details.dart';
import '../../job_seeker/job_fair_event/modal/running_event_modal.dart';
import '../../job_seeker/jobs/jobs_list.dart';
import '../../job_seeker/loginscreen/screen/login_screen.dart';
import '../../job_seeker/profile/profile.dart';
import '../../notification/notification_list.dart';
import '../counselor_jobs/counselor_jobs_list.dart';
import '../counselor_profile/counselor_profile.dart';
import '../home/screen/counselor_home.dart';


class CounselorDashboard extends StatefulWidget {
  const CounselorDashboard({super.key});

  @override
  State<CounselorDashboard> createState() => _CounselorDashboard();
}

class _CounselorDashboard extends State<CounselorDashboard> {

  int _currentIndex = 0;

  final PageController _pageController =
  PageController(viewportFraction: 0.92);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CounselorDashProvider>(
        context,
        listen: false,
      ).getCurrentEvents(context);
    });
  }


  // final List<Widget> _pages = [
  //   CounselorHomeScreen(),
  //   CounselorJobsListScreen(),
  //   NotificationListScreen(),
  //   Center(child: Text("Settings Page")),
  //   ProfileScreen(isAppBarHide: false,),
  // ];

  // @override
  // Widget build(BuildContext context) {
  //   SizeConfig.init(context);
  //   final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
  //   return WillPopScope(
  //     onWillPop: () async {
  //       showExitDialog(
  //         context, "Are you sure you want to exit?",
  //             (value) => exitApp(context, value), // Pass context here
  //       );
  //       return true; // Allow back navigation
  //     },
  //     child: Scaffold(
  //       drawer: _buildSideDrawer(), // Left Drawer
  //       bottomNavigationBar: _buildBottomNavigationBar(),
  //       appBar: commonAppBar("Jobs", context,
  //         localeProvider.currentLanguage, "", false, "", onTapClick: () {
  //       localeProvider.toggleLocale();
  //     }),
  //       body:_pages[_currentIndex],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(),
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.counseDash,
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            _buildEventSlider(),

            const SizedBox(height: 15),

            _buildDashboardList(),
          ],
        ),
      ),
    );
  }

  /// Bottom Navigation Bar
  // Widget _buildBottomNavigationBar() {
  //   return BottomNavigationBar(
  //     currentIndex: _currentIndex,
  //     elevation: 10,
  //     selectedItemColor: kPrimaryColor,
  //     unselectedItemColor: Colors.grey,
  //     onTap: (index) {
  //       setState(() => _currentIndex = index);
  //     },
  //     items: [
  //       BottomNavigationBarItem(icon: Icon(Icons.home), label: AppLocalizations.of(context)!.home),
  //       BottomNavigationBarItem(icon: Icon(Icons.work), label: AppLocalizations.of(context)!.jobs),
  //       BottomNavigationBarItem(icon: Icon(Icons.notifications), label: AppLocalizations.of(context)!.notifications),
  //       BottomNavigationBarItem(icon: Icon(Icons.settings), label: AppLocalizations.of(context)!.settings),
  //       BottomNavigationBarItem(icon: Icon(Icons.person), label: AppLocalizations.of(context)!.profile),
  //     ],
  //   );
  // }

  /// ✅ Dashboard (ONLY 2 ITEMS)
  Widget _buildDashboardList() {
    return Column(
        children: [

          /// View Profile
          // _dashboardListTile(
          //   title: "View Profile",
          //   iconPath: "assets/images/profilee.svg",
          //   color: const Color(0xFF6C63FF),
          //   onTap: () {
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => CounselorProfileScreen(isAppBarHide: false),
          //       ),
          //     );
          //   },
          // ),

          /// Apply Job Fair (same as employer)
          _dashboardListTile(
            title: AppLocalizations.of(context)!.applyJobFair,
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
            title: AppLocalizations.of(context)!.grievfeedbak,
            iconPath: "assets/images/grievances.svg",
            color: const Color(0xFF2DBE8D),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => GrievanceScreen(),
                ),
              );
            },
          ),
        ],
      );
  }

  Widget _buildEventSlider() {
    return Consumer<CounselorDashProvider>(
      builder: (context, provider, child) {

        if (provider.currentEventList.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 230,
          child: PageView.builder(
            controller: _pageController,
            padEnds: false,
            itemCount: provider.currentEventList.length,
            itemBuilder: (context, index) {

              final event = provider.currentEventList[index];

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _eventCard(event),
              );
            },
          ),
        );
      },
    );
  }

  Widget _eventCard(RunningEventData event) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            decoration: const BoxDecoration(
              color: Color(0xFF0D8AA8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    event.eventNameENG ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9C1F1F),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    event.eventDescription ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF0D8AA8),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.venue ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Color(0xFF0D8AA8),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "${getFormattedDate(event.startDate ?? "")} - ${getFormattedDate(event.endDate ?? "")}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D8AA8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          RightToLeftRoute(
                            page: JobFairEventDetailsScreen(
                              runningEventData: event,
                            ),
                            duration: const Duration(milliseconds: 500),
                            startOffset: const Offset(-1.0, 0.0),
                          ),
                        );
                      },
                      child: Text(
                        AppLocalizations.of(context)!.applynow,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ SAME TILE DESIGN AS EMPLOYER
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
                Container(
                  height: 45,
                  width: 45,
                  child: Center(
                    child: SvgPicture.asset(
                      iconPath,
                      height: 42,
                      width: 42,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
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

  // ===============================================================
// COUNSELOR SIDE DRAWER - SCREENSHOT MATCHED UI
// ===============================================================
  Drawer _buildSideDrawer() {
    final user = UserData().model.value;

    String getInitials(String? name) {
      if (name == null || name.trim().isEmpty) {
        return "U";
      }

      final parts = name.trim().split(RegExp(r'\s+'));

      if (parts.length >= 2) {
        return "${parts.first[0]}${parts.last[0]}".toUpperCase();
      }

      return parts.first.substring(0, 1).toUpperCase();
    }

    final counselorName = user.firstName?.toString() ?? "";

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.74,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            // =========================================================
            // HEADER
            // =========================================================
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 12, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------------------------------------------
                  // LOGO
                  // ---------------------------------------------------
                  SizedBox(
                    width: 55,
                    height: 45,
                    child: Image.asset(
                      "assets/logos/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(width: 8),

                  // ---------------------------------------------------
                  // APPLICATION NAME
                  // ---------------------------------------------------
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Employment Exchange",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff152238),
                              height: 1.15,
                            ),
                          ),
                          Text(
                            "Management System",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff152238),
                              height: 1.15,
                            ),
                          ),
                          SizedBox(height: 3),
                          Text(
                            "(EEMS 2.0)",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff1683FF),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ---------------------------------------------------
                  // CLOSE BUTTON
                  // ---------------------------------------------------
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Color(0xffF2F5FA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 18,
                        color: Color(0xff667085),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // HEADER DIVIDER
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: const Color(0xffE5EAF2),
            ),

            // =========================================================
            // DRAWER CONTENT
            // =========================================================
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                children: [
                  // =====================================================
                  // COUNSELOR PROFILE CARD
                  // =====================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(
                      12,
                      14,
                      12,
                      14,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffF1F7FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // -------------------------------------------------
                        // PROFILE HEADER
                        // -------------------------------------------------
                        Row(
                          children: [
                            // Profile image
                            Container(
                              width: 42,
                              height: 42,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              clipBehavior: Clip.antiAlias,
                              child: user.latestPhotoPath != null &&
                                  user.latestPhotoPath
                                      .toString()
                                      .isNotEmpty &&
                                  user.latestPhotoPath.toString() !=
                                      "null"
                                  ? Image.network(
                                user.latestPhotoPath.toString(),
                                width: 42,
                                height: 42,
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      getInitials(counselorName),
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xff315BEA),
                                      ),
                                    ),
                                  );
                                },
                              )
                                  : Center(
                                child: Text(
                                  getInitials(counselorName),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff315BEA),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            // Counselor name
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    counselorName.toUpperCase(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff152238),
                                    ),
                                  ),

                                  const SizedBox(height: 3),

                                  // Update Profile
                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              CounselorProfileScreen(
                                                isAppBarHide: false,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .updateProfile,
                                          style: const TextStyle(
                                            fontSize: 10,
                                            color: Color(0xff1683FF),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        const Icon(
                                          Icons.north_east,
                                          size: 12,
                                          color: Color(0xff1683FF),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Dropdown arrow
                            const Icon(
                              Icons.keyboard_arrow_down,
                              size: 20,
                              color: Color(0xff1769E0),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // -------------------------------------------------
                        // COUNSELOR INFORMATION
                        // -------------------------------------------------
                        // _drawerInfoText(
                        //   label: "Counselor",
                        //   value: counselorName,
                        // ),
                        //
                        // const SizedBox(height: 12),
                        //
                        // _drawerInfoText(
                        //   label: "Employment Exchange",
                        //   value: user.exchangeName?.toString(),
                        // ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // =====================================================
                  // WORKSPACE
                  // =====================================================
                  const Padding(
                    padding: EdgeInsets.only(left: 2),
                    child: Text(
                      "WORKSPACE",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff667085),
                      ),
                    ),
                  ),

                  const SizedBox(height: 6),

                  // =====================================================
                  // DASHBOARD
                  // =====================================================
                  _drawerMenuItem(
                    icon: Icons.dashboard_outlined,
                    title: AppLocalizations.of(context)!.dashboard,
                    selected: _currentIndex == 0,
                    onTap: () {
                      setState(() {
                        _currentIndex = 0;
                      });

                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 6),

                  // =====================================================
                  // APPLY JOB FAIR
                  // =====================================================
                  _drawerMenuItem(
                    icon: Icons.event_outlined,
                    title: AppLocalizations.of(context)!.applyJobFair,
                    selected: _currentIndex == 1,
                    onTap: () {
                      setState(() {
                        _currentIndex = 1;
                      });

                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const JobFairScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 6),

                  // =====================================================
                  // GRIEVANCE / FEEDBACK
                  // =====================================================
                  _drawerMenuItem(
                    icon: Icons.chat_bubble_outline,
                    title: AppLocalizations.of(context)!.grievfeedbak,
                    selected: _currentIndex == 2,
                    onTap: () {
                      setState(() {
                        _currentIndex = 2;
                      });

                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GrievanceScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 6),

                  // =====================================================
                  // CREATE SESSION
                  // =====================================================
                  _drawerMenuItem(
                    icon: Icons.add_circle_outline,
                    title: "Create Session",
                    selected: _currentIndex == 3,
                    onTap: () {
                      setState(() {
                        _currentIndex = 3;
                      });

                      Navigator.pop(context);

                      Navigator.of(context).push(
                        RightToLeftRoute(
                          page: CreateSessionInfoScreen(),
                          duration:
                          const Duration(milliseconds: 500),
                          startOffset: const Offset(-1.0, 0.0),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 6),

                  // =====================================================
                  // VIEW PROFILE
                  // =====================================================
                  _drawerMenuItem(
                    icon: Icons.person_outline,
                    title: AppLocalizations.of(context)!.viewProfile,
                    selected: _currentIndex == 4,
                    onTap: () {
                      setState(() {
                        _currentIndex = 4;
                      });

                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => CounselorProfileScreen(
                            isAppBarHide: false,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // =========================================================
            // LOGOUT - FIXED AT BOTTOM
            // =========================================================
            Container(
              padding: const EdgeInsets.fromLTRB(
                16,
                8,
                16,
                10,
              ),
              decoration: const BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: Color(0xffE5EAF2),
                    width: 1,
                  ),
                ),
              ),
              child: _drawerMenuItem(
                icon: Icons.logout_outlined,
                title: AppLocalizations.of(context)!.logout,
                showArrow: false,
                onTap: () async {
                  Navigator.pop(context);

                  showLogoutDialog(
                    context,
                    AppLocalizations.of(context)!.logout,
                    AppLocalizations.of(context)!
                        .logoutConfirmMsg,
                    AppLocalizations.of(context)!
                        .logoutThankYouText,
                        (value) async {
                      if (value.toString() == "success") {
                        final pref = AppSharedPref();

                        // Clear login session
                        UserData().model.value.isLogin = false;
                        UserData().model.value.userId = null;

                        await pref.remove('UserData');

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const LoginScreen(),
                          ),
                              (route) => false,
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  // ===============================================================
// DRAWER INFO TEXT
// ===============================================================
  Widget _drawerInfoText({
    required String label,
    required String? value,
  }) {
    final displayValue =
    (value == null || value.trim().isEmpty)
        ? "-"
        : value.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            color: Color(0xff718096),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          displayValue,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: Color(0xff344054),
            height: 1.2,
          ),
        ),
      ],
    );
  }


// ===============================================================
// DRAWER MENU ITEM
// ===============================================================
  Widget _drawerMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool selected = false,
    bool showArrow = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 52,
          padding: const EdgeInsets.symmetric(
            horizontal: 14,
          ),
          decoration: BoxDecoration(
            color: selected
                ? const Color(0xffEAF1FF)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 21,
                color: selected
                    ? const Color(0xff315BEA)
                    : const Color(0xff344054),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: selected
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: selected
                        ? const Color(0xff315BEA)
                        : const Color(0xff152238),
                  ),
                ),
              ),

              if (showArrow)
                Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: selected
                      ? const Color(0xff315BEA)
                      : const Color(0xff718096),
                ),
            ],
          ),
        ),
      ),
    );
  }


  // ===============================================================
// DRAWER INFO TEXT
// ===============================================================
//   Widget _drawerInfoText({
//     required String label,
//     required String? value,
//   }) {
//     final displayValue =
//     (value == null || value.trim().isEmpty)
//         ? "-"
//         : value.trim();
//
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           label,
//           style: const TextStyle(
//             fontSize: 9,
//             fontWeight: FontWeight.w500,
//             color: Color(0xff718096),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           displayValue,
//           maxLines: 2,
//           overflow: TextOverflow.ellipsis,
//           style: const TextStyle(
//             fontSize: 12,
//             fontWeight: FontWeight.w700,
//             color: Color(0xff344054),
//             height: 1.2,
//           ),
//         ),
//       ],
//     );
//   }


// ===============================================================
// DRAWER MENU ITEM
// ===============================================================
//   Widget _drawerMenuItem({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//     bool selected = false,
//     bool showArrow = true,
//   }) {
//     return Material(
//       color: Colors.transparent,
//       child: InkWell(
//         onTap: onTap,
//         borderRadius: BorderRadius.circular(10),
//         child: Container(
//           height: 52,
//           padding: const EdgeInsets.symmetric(
//             horizontal: 14,
//           ),
//           decoration: BoxDecoration(
//             color: selected
//                 ? const Color(0xffEAF1FF)
//                 : Colors.transparent,
//             borderRadius: BorderRadius.circular(10),
//           ),
//           child: Row(
//             children: [
//               Icon(
//                 icon,
//                 size: 21,
//                 color: selected
//                     ? const Color(0xff315BEA)
//                     : const Color(0xff344054),
//               ),
//
//               const SizedBox(width: 12),
//
//               Expanded(
//                 child: Text(
//                   title,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: selected
//                         ? FontWeight.w600
//                         : FontWeight.w500,
//                     color: selected
//                         ? const Color(0xff315BEA)
//                         : const Color(0xff152238),
//                   ),
//                 ),
//               ),
//
//               if (showArrow)
//                 Icon(
//                   Icons.chevron_right,
//                   size: 20,
//                   color: selected
//                       ? const Color(0xff315BEA)
//                       : const Color(0xff718096),
//                 ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
  /// ✅ COPY SAME DRAWER (just change name fields)
  // Drawer _buildSideDrawer() {
  //   return Drawer(
  //     child: ListView(
  //       children: [
  //         // ===== Header =====
  //         Container(
  //           padding: const EdgeInsets.only(
  //             top: 40,
  //             left: 16,
  //             right: 16,
  //             bottom: 20,
  //           ),
  //           color: Colors.white,
  //           child: Stack(
  //             children: [
  //               Column(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   // =========================
  //                   // Application Logo
  //                   // =========================
  //                   Image.asset(
  //                     "assets/logos/logo.png",
  //                     height: 60,
  //                     fit: BoxFit.contain,
  //                   ),
  //
  //                   const SizedBox(height: 8),
  //
  //                   // =========================
  //                   // Application Name
  //                   // =========================
  //                   Padding(
  //                     padding: EdgeInsets.symmetric(horizontal: 8),
  //                     child: RichText(
  //                       textAlign: TextAlign.center,
  //                       text: TextSpan(
  //                         style: TextStyle(
  //                           fontSize: 15,
  //                           fontWeight: FontWeight.w700,
  //                           color: Color(0xff152238),
  //                           height: 1.3,
  //                           letterSpacing: 0.3,
  //                         ),
  //                         children: [
  //                           TextSpan(
  //                             text: "Employment Exchange Management System\n",
  //                             style: TextStyle(
  //                               fontWeight: FontWeight.w900,
  //                             ),
  //                           ),
  //                           TextSpan(
  //                             text: "(EEMS 2.0)",
  //                             style: TextStyle(
  //                               fontSize: 14,
  //                               fontWeight: FontWeight.w800,
  //                               color: Color(0xff1683FF),
  //                               letterSpacing: 0.8,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //                   ),
  //
  //                   const SizedBox(height: 20),
  //
  //                   // =========================
  //                   // Counselor Profile
  //                   // =========================
  //                   Row(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       ClipOval(
  //                         child: Image.network(
  //                           UserData().model.value.latestPhotoPath.toString(),
  //                           width: 60,
  //                           height: 60,
  //                           fit: BoxFit.cover,
  //                           errorBuilder: (_, __, ___) {
  //                             return Image.asset(
  //                               "assets/images/placeholder.png",
  //                               width: 60,
  //                               height: 60,
  //                               fit: BoxFit.cover,
  //                             );
  //                           },
  //                         ),
  //                       ),
  //
  //                       const SizedBox(width: 12),
  //
  //                       Expanded(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             Text(
  //                               UserData().model.value.firstName ?? "",
  //                               maxLines: 2,
  //                               overflow: TextOverflow.ellipsis,
  //                               style: const TextStyle(
  //                                 fontSize: 16,
  //                                 fontWeight: FontWeight.w800,
  //                                 color: Color(0xff152238),
  //                               ),
  //                             ),
  //
  //                             const SizedBox(height: 4),
  //
  //                             GestureDetector(
  //                               onTap: () {
  //                                 Navigator.pop(context);
  //
  //                                 // Uncomment if you want to open counselor profile
  //                                 // Navigator.push(
  //                                 //   context,
  //                                 //   MaterialPageRoute(
  //                                 //     builder: (context) =>
  //                                 //         CounselorProfileScreen(
  //                                 //           isAppBarHide: true,
  //                                 //         ),
  //                                 //   ),
  //                                 // );
  //                               },
  //                               child: Text(
  //                                 AppLocalizations.of(context)!.updateProfile,
  //                                 maxLines: 1,
  //                                 overflow: TextOverflow.ellipsis,
  //                                 style: const TextStyle(
  //                                   fontSize: 14,
  //                                   color: kViewAllColor,
  //                                   fontWeight: FontWeight.w600,
  //                                 ),
  //                               ),
  //                             ),
  //                           ],
  //                         ),
  //                       ),
  //                     ],
  //                   ),
  //                 ],
  //               ),
  //
  //               // =========================
  //               // Close Button
  //               // =========================
  //               Positioned(
  //                 top: 0,
  //                 right: 0,
  //                 child: InkWell(
  //                   onTap: () => Navigator.pop(context),
  //                   borderRadius: BorderRadius.circular(20),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(4),
  //                     child: SvgPicture.asset(
  //                       "assets/icons/close.svg",
  //                       width: 25,
  //                       height: 25,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //
  //         const Divider(),
  //
  //         // ListTile(
  //         //   leading: const Icon(Icons.dashboard),
  //         //   title: const Text("Dashboard"),
  //         //   onTap: () => Navigator.pop(context),
  //         // ),
  //         //
  //         // const Divider(),
  //         //
  //         // /// You can keep or remove extra menu items
  //         // ListTile(
  //         //   leading: const Icon(Icons.event),
  //         //   title: const Text("Job Fair"),
  //         //   onTap: () {
  //         //     Navigator.pop(context);
  //         //     Navigator.push(
  //         //       context,
  //         //       MaterialPageRoute(
  //         //         builder: (context) => const JobFairScreen(),
  //         //       ),
  //         //     );
  //         //   },
  //         // ),
  //         //
  //         // const Divider(),
  //
  //         /// Logout (same as employer)
  //         ListTile(
  //           leading: const Icon(Icons.logout),
  //           title: Text(AppLocalizations.of(context)!.logout),
  //           onTap: () async {
  //             Navigator.pop(context);
  //
  //             final pref = AppSharedPref();
  //             // final commonRepo = Provider.of<CommonRepo>(context, listen: false);
  //             // commonRepo.dioClient.clearAuthToken();
  //             UserData().model.value.isLogin = false;
  //             UserData().model.value.userId = null;
  //             await pref.remove('UserData');
  //
  //             Navigator.pushAndRemoveUntil(
  //               context,
  //               MaterialPageRoute(builder: (_) => const LoginScreen()),
  //                   (route) => false,
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  /// Side Drawer
  // Drawer _buildSideDrawer() {
  //   return Drawer(
  //     child: ListView(
  //       children: [
  //         Container(
  //           padding:
  //               const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 20),
  //           color: Colors.white,
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //             children: [
  //               Padding(
  //                 padding: const EdgeInsets.only(top: 10),
  //                 child: Row(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   mainAxisAlignment: MainAxisAlignment.center,
  //                   children: [
  //                     // Profile avatar + progress
  //                             Stack(
  //                             alignment: Alignment.center,
  //                               children: [
  //                 Transform.rotate(
  //                   angle: 2.00, // -90 degrees in radians (to shift start to right)
  //                   child: SizedBox(
  //                     width: 80,
  //                     height: 80,
  //                     child: CircularProgressIndicator(
  //                       value: 0.7, // 70%
  //                       strokeWidth: 7,
  //                       backgroundColor: Colors.grey[300],
  //                       valueColor: const AlwaysStoppedAnimation<Color>(kViewAllColor),
  //                     ),
  //                   ),
  //                 ),
  //
  //                 const CircleAvatar(
  //                   radius: 30,
  //                   backgroundImage: NetworkImage(
  //                     "https://randomuser.me/api/portraits/men/11.jpg",
  //                   ),
  //                 ),
  //                 Positioned(
  //                   right: 0,
  //                   top: 0,
  //                   left: 40,
  //                   child: Container(
  //                     padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
  //                     decoration: BoxDecoration(
  //                       color: Colors.orange[100],
  //                       borderRadius: BorderRadius.circular(8),
  //                     ),
  //                     child: const Text(
  //                       "70%",
  //                       style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold),
  //                     ),
  //                   ),
  //                 ),
  //                               ],
  //                             ),
  //                     const SizedBox(width: 12),
  //                     Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         const Text(
  //                           "Akshay",
  //                           style: TextStyle(
  //                             fontSize: 16,
  //                             fontWeight: FontWeight.bold,
  //                           ),
  //                         ),
  //                         const SizedBox(height: 4),
  //                         GestureDetector(
  //                           onTap: () {
  //                             Navigator.pop(context);
  //                             Navigator.push(
  //                               context,
  //                               MaterialPageRoute(builder: (context) =>  ProfileScreen(isAppBarHide: true,)),
  //                             );
  //                           },
  //                           child: Text(
  //                             AppLocalizations.of(context)!.updateprofile,
  //                             style: TextStyle(
  //                               fontSize: 14,
  //                               //color: Colors.blue,
  //                               color: kViewAllColor,
  //                               fontWeight: FontWeight.w600,
  //                               decoration: TextDecoration.none,
  //                             ),
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //               // Close button
  //               InkWell(
  //                 onTap: () => Navigator.pop(context),
  //                 child: SvgPicture.asset(
  //                   'assets/icons/close.svg',
  //                   width: 25,
  //                   height: 25,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         ListTile(
  //           leading: SvgPicture.asset('assets/icons/home.svg',
  //           width: 20, height: 20),
  //           title: Text(AppLocalizations.of(context)!.dashboard),
  //           onTap: () {
  //             setState(() => _currentIndex = 0);
  //             Navigator.pop(context);
  //           },
  //         ),
  //         ListTile(
  //           leading: SvgPicture.asset('assets/icons/user.svg',
  //               width: 20, height: 20),
  //           title: Text("Jobs Recommendation"),
  //           onTap: () {
  //             setState(() => _currentIndex = 1);
  //             Navigator.pop(context);
  //           },
  //         ),
  //         ListTile(
  //           leading: SvgPicture.asset(
  //             'assets/icons/language.svg',
  //             width: 20,
  //             height: 20,
  //             fit: BoxFit.cover,
  //           ),
  //           title: Text("Create Session"),
  //           onTap: () {
  //             Navigator.pop(context);
  //             Navigator.of(context).push(
  //               RightToLeftRoute(
  //                 page: CreateSessionInfoScreen(),
  //                 duration: const Duration(milliseconds: 500),
  //                 startOffset: const Offset(-1.0, 0.0),
  //               ),
  //             );
  //           },
  //         ),
  //
  //
  //         ListTile(
  //           leading: SvgPicture.asset(
  //             'assets/icons/calendarNew.svg',
  //             width: 20,
  //             height: 20,
  //             fit: BoxFit.cover,
  //           ),
  //           title: Text("Appointment Schedule"),
  //           onTap: () {
  //             setState(() => _currentIndex = 3);
  //             Navigator.pop(context);
  //           },
  //         ),
  //
  //         ListTile(
  //           leading: SvgPicture.asset(
  //             'assets/icons/star.svg',
  //             width: 20,
  //             height: 20,
  //             fit: BoxFit.cover,
  //           ),
  //           title: Text("Grievance/Feedback"),
  //           onTap: () {
  //             setState(() => _currentIndex = 3);
  //             Navigator.pop(context);
  //           },
  //         ),
  //         ListTile(
  //           leading: SvgPicture.asset(
  //             'assets/icons/language.svg',
  //             width: 20,
  //             height: 20,
  //             fit: BoxFit.cover,
  //           ),
  //           title: Text("Language"),
  //           onTap: () {
  //             setState(() => _currentIndex = 3);
  //             Navigator.pop(context);
  //           },
  //         ),
  //
  //         ListTile(
  //           leading: SvgPicture.asset(
  //             'assets/icons/setting.svg',
  //             width: 20,
  //             height: 20,
  //             fit: BoxFit.cover,
  //           ),
  //           title: Text(AppLocalizations.of(context)!.settings),
  //           onTap: () {
  //             setState(() => _currentIndex = 3);
  //             Navigator.pop(context);
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.logout),
  //           title: Text(AppLocalizations.of(context)!.logout),
  //           onTap: () {},
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
