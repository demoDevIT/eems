import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/role/employer/employerdashboard/provider/employer_dash_provider.dart';
import '../../../constants/colors.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repo/common_repo.dart';
import '../../../utils/app_shared_prefrence.dart';
import '../../../utils/global.dart';
import '../../../utils/language_toggle_switch.dart';
import '../../../utils/right_to_left_route.dart';
import '../../../utils/textstyles.dart';
import '../../../utils/user_new.dart';
import '../../job_seeker/grievance/grievance_list.dart';
import '../../job_seeker/job_fair_event/job_fair_event_details.dart';
import '../../job_seeker/job_fair_event/modal/running_event_modal.dart';
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

  final PageController _pageController = PageController(
    viewportFraction: 0.92,
  );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<EmployerDashProvider>(context, listen: false)
          .getCurrentEvents(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(),
      appBar: AppBar(
        title: Text(
          //"Employer Dashboard",
          AppLocalizations.of(context)!.empDash,
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 80,
              child: LanguageToggleSwitch(),
            ),
          ),
        ],
      ),

      backgroundColor: const Color(0xFFF2F4F8),
      body: _buildDashboardGrid(),
    );
  }

  // Widget _buildDashboardGrid() {
  //   return Padding(
  //     padding: const EdgeInsets.all(16),
  //     child: Column(
  //       children: [
  //         _dashboardListTile(
  //           title: "View Profile",
  //           iconPath: "assets/images/profilee.svg",
  //           color: const Color(0xFF6C63FF),
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => const EmployerProfileScreen(),
  //               ),
  //             );
  //           },
  //         ),
  //
  //         _dashboardListTile(
  //           title: "Job Fair Registration",
  //           iconPath: "assets/images/aplyjobfair.svg",
  //           color: const Color(0xFF2DBE8D),
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => const JobFairScreen(),
  //               ),
  //             );
  //           },
  //         ),
  //
  //         _dashboardListTile(
  //           title: "Post Jobs in Job Fair",
  //           iconPath: "assets/images/postJob.svg",
  //           color: const Color(0xFFFF7A59),
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => const JobPostScreen(),
  //               ),
  //             );
  //           },
  //         ),
  //
  //
  //
  //         _dashboardListTile(
  //           title: "Job Fair Applications",
  //           iconPath: "assets/images/jobapp.svg",
  //           color: const Color(0xFF6C63FF),
  //           onTap: () {
  //             Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => const JobApplicationScreen(),
  //               ),
  //             );
  //           },
  //         ),
  //
  //         _dashboardListTile(
  //           title: "Grievances",
  //           iconPath: "assets/images/grievances.svg",
  //           color: const Color(0xFFFF7A59),
  //           onTap: () async {
  //             await Navigator.push(
  //               context,
  //               MaterialPageRoute(
  //                 builder: (context) => GrievanceScreen(),
  //               ),
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildDashboardGrid() {
    final items = [
      _DashboardItem(
        title: AppLocalizations.of(context)!.viewProfile,
        iconPath: "assets/images/profilee.svg",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const EmployerProfileScreen(),
            ),
          );
        },
      ),

      _DashboardItem(
        title: AppLocalizations.of(context)!.jobFair,
        iconPath: "assets/images/aplyjobfair.svg",
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const JobFairScreen(),
            ),
          );
        },
      ),

      // _DashboardItem(
      //   title: "Post Jobs in Job Fair",
      //   iconPath: "assets/images/postJob.svg",
      //   onTap: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (_) => const JobPostScreen(),
      //       ),
      //     );
      //   },
      // ),
      //
      // _DashboardItem(
      //   title: "Job Fair Applications",
      //   iconPath: "assets/images/jobapp.svg",
      //   onTap: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(
      //         builder: (_) => const JobApplicationScreen(),
      //       ),
      //     );
      //   },
      // ),

      _DashboardItem(
        title: AppLocalizations.of(context)!.grievances,
        iconPath: "assets/images/grievances.svg",
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GrievanceScreen(),
            ),
          );
        },
      ),
    ];

    // return Padding(
    //   padding: const EdgeInsets.all(12),
    //   child: GridView.builder(
    //     shrinkWrap: true,
    //     physics: const NeverScrollableScrollPhysics(),
    //     itemCount: items.length,
    //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //       crossAxisCount: 2,
    //       mainAxisSpacing: 10,
    //       crossAxisSpacing: 10,
    //       childAspectRatio: 1.38,
    //     ),
    //     itemBuilder: (context, index) {
    //       final item = items[index];
    //
    //       return GestureDetector(
    //         onTap: item.onTap,
    //         child: Container(
    //           padding: const EdgeInsets.symmetric(
    //             vertical: 12,
    //             horizontal: 8,
    //           ),
    //           decoration: BoxDecoration(
    //             color: Colors.white,
    //             borderRadius: BorderRadius.circular(16),
    //             boxShadow: [
    //               BoxShadow(
    //                 color: Colors.black.withOpacity(0.05),
    //                 blurRadius: 6,
    //                 offset: const Offset(0, 2),
    //               ),
    //             ],
    //           ),
    //           child: Column(
    //             mainAxisAlignment: MainAxisAlignment.center,
    //             children: [
    //               SvgPicture.asset(
    //                 item.iconPath,
    //                 width: 50,
    //                 height: 50,
    //               ),
    //               const SizedBox(height: 10),
    //               Text(
    //                 item.title,
    //                 textAlign: TextAlign.center,
    //                 style: const TextStyle(
    //                   fontSize: 13.5,
    //                   fontWeight: FontWeight.w500,
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       );
    //     },
    //   ),
    // );

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [

          _buildEventSlider(),

          const SizedBox(height: 15),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.38,
            ),
            itemBuilder: (context, index) {
              final item = items[index];

              return GestureDetector(
                onTap: item.onTap,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        item.iconPath,
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        item.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEventSlider() {
    return Consumer<EmployerDashProvider>(
      builder: (context, provider, child) {

        // if (provider.currentEventList.isEmpty) {
        //   return const SizedBox(
        //     height: 200,
        //     child: Center(
        //       child: Text("No Running Events"),
        //     ),
        //   );
        // }

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

  // ===============================================================
// SIDE DRAWER - Screenshot matched UI
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
                  // Logo
                  SizedBox(
                    width: 55,
                    height: 45,
                    child: Image.asset(
                      "assets/logos/logo.png",
                      fit: BoxFit.contain,
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Application title
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

                  // Close button
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

            // Divider
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
                  // EMPLOYER PROFILE CARD
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
                        // Profile Header
                        // -------------------------------------------------
                        Row(
                          children: [
                            // Employer photo / initials
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
                                      getInitials(
                                        user.branchName,
                                      ),
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
                                  getInitials(
                                    user.branchName,
                                  ),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff315BEA),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            // Employer name
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.branchName
                                        ?.toString()
                                        .toUpperCase() ??
                                        "",
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
                                          const EmployerProfileScreen(),
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

                            const Icon(
                              Icons.keyboard_arrow_down,
                              size: 20,
                              color: Color(0xff1769E0),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // =================================================
                        // COMPANY / BRANCH
                        // =================================================
                        // _drawerInfoText(
                        //   label: "Employer",
                        //   value: user.branchName,
                        // ),
                        //
                        // const SizedBox(height: 12),
                        //
                        // // =================================================
                        // // OFFICE / EXCHANGE
                        // // =================================================
                        // _drawerInfoText(
                        //   label: "Employment Exchange",
                        //   value: user.exchangeName,
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
                  // JOB FAIR
                  // =====================================================
                  _drawerMenuItem(
                    icon: Icons.event_outlined,
                    title: AppLocalizations.of(context)!.jobFair,
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
                  // GRIEVANCES
                  // =====================================================
                  _drawerMenuItem(
                    icon: Icons.chat_bubble_outline,
                    title: AppLocalizations.of(context)!.grievances,
                    selected: _currentIndex == 2,
                    onTap: () async {
                      setState(() {
                        _currentIndex = 2;
                      });

                      Navigator.pop(context);

                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => GrievanceScreen(),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 6),

                  // =====================================================
                  // PROFILE
                  // =====================================================
                  _drawerMenuItem(
                    icon: Icons.person_outline,
                    title: AppLocalizations.of(context)!.viewProfile,
                    selected: _currentIndex == 3,
                    onTap: () {
                      setState(() {
                        _currentIndex = 3;
                      });

                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                          const EmployerProfileScreen(),
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
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
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

                        // Clear stored user data
                        await pref.remove('UserData');

                        // Navigate to login
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
          padding: const EdgeInsets.symmetric(horizontal: 14),
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

  /// Side Drawer
  // Drawer _buildSideDrawer() {
  //   return Drawer(
  //     child: ListView(
  //       children: [
  //         // ===== Header =====
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
  //                   // Employer Profile
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
  //                               UserData().model.value.branchName.toString(),
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
  //         const Divider(),
  //         ListTile(
  //           leading: const Icon(Icons.dashboard),
  //           title: Text(AppLocalizations.of(context)!.dashboard, style: TextStyle(fontSize: 14)),
  //           onTap: () {
  //             Navigator.pop(context); // Already on dashboard
  //           },
  //         ),
  //         const Divider(),
  //         // ===== Job Fair Events =====
  //         ExpansionTile(
  //           leading: SvgPicture.asset(
  //             'assets/icons/calendarNew.svg',
  //             width: 20,
  //             height: 20,
  //             fit: BoxFit.cover,
  //           ),
  //           title: Text(
  //             AppLocalizations.of(context)!.jobfairevents,
  //             style: Styles.mediumTextStyle(size: 14),
  //           ),
  //           children: [
  //             ListTile(
  //               title: Text(AppLocalizations.of(context)!.events, style: Styles.mediumTextStyle(size: 14)),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 // Navigator.push(
  //                 //   context,
  //                 //   MaterialPageRoute(builder: (context) => JobsFairEventScreen()),
  //                 // );
  //               },
  //             ),
  //             ListTile(
  //               title: Text(AppLocalizations.of(context)!.regEvents, style: Styles.mediumTextStyle(size: 14)),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 // Navigator.push(
  //                 //   context,
  //                 //   MaterialPageRoute(builder: (context) => RegisteredEventListScreen()),
  //                 // );
  //               },
  //             ),
  //             ListTile(
  //               title: Text(AppLocalizations.of(context)!.jobApply, style: Styles.mediumTextStyle(size: 14)),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 // Navigator.push(
  //                 //   context,
  //                 //   MaterialPageRoute(builder: (context) => SelectCompanyPage()),
  //                 // );
  //               },
  //             ),
  //           ],
  //         ),
  //
  //         // ===== Divider before Logout =====
  //         Container(
  //           margin: const EdgeInsets.only(left: 50),
  //           child: const Divider(height: 1, color: E3E5F9Color),
  //         ),
  //
  //         // ===== Logout =====
  //         ListTile(
  //           leading: SvgPicture.asset(
  //             'assets/icons/logout.svg',
  //             width: 20,
  //             height: 20,
  //             fit: BoxFit.cover,
  //           ),
  //           title: Text(
  //             AppLocalizations.of(context)!.logout,
  //             style: Styles.mediumTextStyle(size: 14),
  //           ),
  //           onTap: () async {
  //             Navigator.pop(context); // Close the drawer
  //             showLogoutDialog(context, AppLocalizations.of(context)!.logout,AppLocalizations.of(context)!.logoutConfirmMsg, AppLocalizations.of(context)!.logoutThankYouText, (value) async {
  //               if (value.toString() == "success") {
  //                 final pref = AppSharedPref();
  //
  //                 // final commonRepo = Provider.of<CommonRepo>(context, listen: false);
  //                 // commonRepo.dioClient.clearAuthToken();
  //
  //                 // Clear login session only
  //                 UserData().model.value.isLogin = false;
  //                 UserData().model.value.userId = null;
  //                 await pref.remove('UserData');
  //
  //                 Navigator.pushAndRemoveUntil(
  //                   context,
  //                   MaterialPageRoute(builder: (_) => const LoginScreen()),
  //                       (route) => false,
  //                 );
  //
  //                 // Navigator.of(context).push(
  //                 //   MaterialPageRoute(
  //                 //     builder: (BuildContext context) =>
  //                 //     const LoginScreen(),
  //                 //   ),
  //                 // );
  //               }
  //             },
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
class _DashboardItem {
  final String title;
  final String iconPath;
  final VoidCallback onTap;

  _DashboardItem({
    required this.title,
    required this.iconPath,
    required this.onTap,
  });
}