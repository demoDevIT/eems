import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rajemployment/role/job_seeker/cv_builder/cv_list.dart';
import 'package:rajemployment/role/job_seeker/grievance/add_grievance_screen.dart';
import 'package:rajemployment/role/job_seeker/loginscreen/provider/locale_provider.dart';
import 'package:rajemployment/role/job_seeker/mysy/mysy_list.dart';
import 'package:rajemployment/role/job_seeker/self_assessment/self_assessment.dart';
import 'package:rajemployment/role/job_seeker/settings/job_settings_screen.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../api_service/datasource/remote/dio/dio_client.dart';
import '../../../api_service/model/base/api_response.dart';
import '../../../constants/constants.dart';
import '../../../constants/static_variables.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repo/common_repo.dart';
import '../../../utils/app_shared_prefrence.dart';
import '../../../utils/global.dart';
import '../../../utils/images.dart';
import '../../../utils/user_new.dart';
import '../../notification/notification_list.dart';
import '../applied_jobs/applied_jobs.dart';
import '../departmental_schemes/mysy_pending_list.dart';
import '../grievance/grievance_list.dart';
import '../homescreen/home_screen.dart';
import '../job_fair_event/job_apply_list.dart';
import '../job_fair_event/jobs_fair_event.dart';
import '../job_fair_event/registered_event_list.dart';
import '../jobs/jobs_list.dart';
import '../loginscreen/screen/login_screen.dart';
import '../mysy/provider/mysy_list_provider.dart';
import '../preferred_jobs/preferred_jobs.dart';
import '../profile/profile.dart';
import '../qr_scanner/qr_scanner_screen.dart';
import '../registration_card/registration_card.dart';
import '../select_company/select_company_page.dart';
import '../videoprofile/videoprofile_screen.dart';

class JobSeekerDashboard extends StatefulWidget {
  const JobSeekerDashboard({super.key});

  @override
  State<JobSeekerDashboard> createState() => _JobSeekerDashboard();
}

class _JobSeekerDashboard extends State<JobSeekerDashboard> {
  int _currentIndex = 0;
  double profilePercentage = 0.0;


  final List<Widget> _pages = [
    HomeScreen(),
    JobsListScreen(),
    NotificationListScreen(),
    JobSettingsScreen(),

  ];

  late CommonRepo commonRepo;

  @override
  void initState() {
    super.initState();
    print("StaticVariables authtoken -> ${StaticVariables.authToken}");

    final dio = Dio();

    final dioClient = DioClient(
      Constants.baseurl, // ✅ your base URL
      // UserData().model.value.token, // ✅ if token exists, else pass null
      null,
      dio,
    );

    commonRepo = CommonRepo(dioClient: dioClient);

    Future.microtask(() => getProfilePercentageApi(context));
  }

  Future<void> getProfilePercentageApi(BuildContext context) async {
    try {
      String userId = UserData().model.value.userId.toString();

      String url = "Jobseeker/GetProfileStatusPrecentage/$userId";

      // Optional loader (use if you want)
      // ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.post(url, {});

      // ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response?.statusCode == 200) {
        var responseData = apiResponse.response?.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        if (responseData["State"] == 200 &&
            responseData["Data"] != null &&
            responseData["Data"].isNotEmpty) {

          double percent =
          (responseData["Data"][0]["CompletionPercentage"] ?? 0).toDouble();

          setState(() {
            profilePercentage = percent / 100; // IMPORTANT
          });
        }
      }

    } catch (e) {
      // ProgressDialog.closeLoadingDialog(context);
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        showExitDialog(
          context, "Are you sure you want to exit?",
              (value) => exitApp(context, value), // Pass context here
        );
        return true; // Allow back navigation
      },
      child: Scaffold(
        drawer: _buildSideDrawer(), // Left Drawer
        bottomNavigationBar: _buildBottomNavigationBar(),
        appBar: commonAppBar(AppLocalizations.of(context)!.jobs, context,
          localeProvider.currentLanguage, "", false, "", onTapClick: () {
        localeProvider.toggleLocale();
      }),
        body:_pages[_currentIndex],

      ),
    );
  }

  /// Bottom Navigation Bar
  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      elevation: 10,
      selectedItemColor: kPrimaryColor,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() => _currentIndex = index);
      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: AppLocalizations.of(context)!.home),
        BottomNavigationBarItem(icon: Icon(Icons.work), label: AppLocalizations.of(context)!.jobs),
        BottomNavigationBarItem(icon: Icon(Icons.notifications), label: AppLocalizations.of(context)!.notifications),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: AppLocalizations.of(context)!.settings),
      ],
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

            // Header divider
            Container(
              height: 1,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              color: const Color(0xffE5EAF2),
            ),

            // =========================================================
            // CONTENT
            // =========================================================
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                children: [
                  // =====================================================
                  // PROFILE CARD
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
                            // Avatar
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
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (context, error, stackTrace) {
                                  return Center(
                                    child: Text(
                                      getInitials(user.nAMEENG),
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
                                  getInitials(user.nAMEENG),
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff315BEA),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(width: 10),

                            // Name + View Profile
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    user.nAMEENG
                                        ?.toString()
                                        .toUpperCase() ??
                                        "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xff152238),
                                    ),
                                  ),

                                  const SizedBox(height: 3),

                                  GestureDetector(
                                    onTap: () {
                                      Navigator.pop(context);

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ProfileScreen(
                                                isAppBarHide: true,
                                              ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .viewProfile,
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

                        // -------------------------------------------------
                        // PROFILE COMPLETION
                        // -------------------------------------------------
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Profile Completion",
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w500,
                                color: Color(0xff718096),
                              ),
                            ),

                            const SizedBox(height: 6),

                            Row(
                              children: [
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    child: LinearProgressIndicator(
                                      value: profilePercentage,
                                      minHeight: 6,
                                      backgroundColor:
                                      const Color(0xffDCE6F5),
                                      valueColor:
                                      const AlwaysStoppedAnimation<
                                          Color>(
                                        Color(0xff315BEA),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 8),

                                Text(
                                  "${(profilePercentage * 100).round()}%",
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xff315BEA),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
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
                  // JOBS
                  // =====================================================
                  _drawerMenuItem(
                    icon: Icons.work_outline,
                    title: AppLocalizations.of(context)!.jobs,
                    selected: _currentIndex == 1,
                    onTap: () {
                      setState(() {
                        _currentIndex = 1;
                      });

                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 6),

                  // =====================================================
                  // NOTIFICATIONS
                  // =====================================================
                  _drawerMenuItem(
                    icon: Icons.notifications_none_outlined,
                    title:
                    AppLocalizations.of(context)!.notifications,
                    selected: _currentIndex == 2,
                    onTap: () {
                      setState(() {
                        _currentIndex = 2;
                      });

                      Navigator.pop(context);
                    },
                  ),

                  const SizedBox(height: 6),

                  // =====================================================
                  // SETTINGS
                  // =====================================================
                  _drawerMenuItem(
                    icon: Icons.settings_outlined,
                    title: AppLocalizations.of(context)!.settings,
                    selected: _currentIndex == 3,
                    onTap: () {
                      setState(() {
                        _currentIndex = 3;
                      });

                      Navigator.pop(context);
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
                    AppLocalizations.of(context)!.areYouSureLogOut,
                    AppLocalizations.of(context)!.logoutThankYouText,
                        (value) async {
                      if (value.toString() == "success") {
                        final pref = AppSharedPref();

                        // Clear login session
                        UserData().model.value.isLogin = false;
                        UserData().model.value.userId = null;

                        // Clear stored user data
                        await pref.remove('UserData');

                        // Go to login and remove all previous routes
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
  //   final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
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
  //                   // Application Logo
  //                   Image.asset(
  //                     "assets/logos/logo.png",
  //                     height: 60,
  //                     fit: BoxFit.contain,
  //                   ),
  //
  //                   const SizedBox(height: 8),
  //
  //                   // Application Name
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
  //                   // Profile + Completion Percentage
  //                   Row(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       Stack(
  //                         alignment: Alignment.center,
  //                         clipBehavior: Clip.none,
  //                         children: [
  //                           // Progress Ring
  //                           Transform.rotate(
  //                             angle: 2.00,
  //                             child: SizedBox(
  //                               width: 90,
  //                               height: 90,
  //                               child: CircularProgressIndicator(
  //                                 value: profilePercentage,
  //                                 strokeWidth: 7,
  //                                 backgroundColor: Colors.grey[300],
  //                                 valueColor:
  //                                 const AlwaysStoppedAnimation<Color>(
  //                                   kViewAllColor,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //
  //                           // Profile Image
  //                           ClipOval(
  //                             child: Image.network(
  //                               UserData()
  //                                   .model
  //                                   .value
  //                                   .latestPhotoPath
  //                                   .toString(),
  //                               width: 65,
  //                               height: 65,
  //                               fit: BoxFit.cover,
  //                               errorBuilder: (context, error, stackTrace) {
  //                                 return Image.asset(
  //                                   Images.placeholder,
  //                                   width: 65,
  //                                   height: 65,
  //                                   fit: BoxFit.cover,
  //                                 );
  //                               },
  //                             ),
  //                           ),
  //
  //                           // Profile Completion %
  //                           Positioned(
  //                             right: -10,
  //                             top: 5,
  //                             child: Container(
  //                               alignment: Alignment.center,
  //                               padding: const EdgeInsets.symmetric(
  //                                 horizontal: 6,
  //                                 vertical: 3,
  //                               ),
  //                               decoration: BoxDecoration(
  //                                 color: FFF2EDColor,
  //                                 borderRadius: BorderRadius.circular(8),
  //                                 boxShadow: const [
  //                                   BoxShadow(
  //                                     color: Colors.black12,
  //                                     blurRadius: 2,
  //                                     offset: Offset(1, 1),
  //                                   ),
  //                                 ],
  //                               ),
  //                               child: Text(
  //                                 "${(profilePercentage * 100)}%",
  //                                 style: const TextStyle(
  //                                   color: kDarkOrangeColor,
  //                                   fontSize: 12,
  //                                   fontWeight: FontWeight.bold,
  //                                 ),
  //                               ),
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //
  //                       const SizedBox(width: 12),
  //
  //                       // Name + View Profile
  //                       Expanded(
  //                         child: Column(
  //                           crossAxisAlignment: CrossAxisAlignment.start,
  //                           mainAxisSize: MainAxisSize.min,
  //                           children: [
  //                             Text(
  //                               UserData().model.value.nAMEENG.toString(),
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
  //                                 Navigator.push(
  //                                   context,
  //                                   MaterialPageRoute(
  //                                     builder: (context) => ProfileScreen(
  //                                       isAppBarHide: true,
  //                                     ),
  //                                   ),
  //                                 );
  //                               },
  //                               child: Text(
  //                                 AppLocalizations.of(context)!.viewProfile,
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
  //               // Close Button
  //               Positioned(
  //                 top: 0,
  //                 right: 0,
  //                 child: InkWell(
  //                   onTap: () => Navigator.pop(context),
  //                   borderRadius: BorderRadius.circular(20),
  //                   child: Padding(
  //                     padding: const EdgeInsets.all(4),
  //                     child: SvgPicture.asset(
  //                       'assets/icons/close.svg',
  //                       width: 25,
  //                       height: 25,
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //         Container(
  //             margin: EdgeInsets.only(left: 50),
  //             child: Divider(height: 1,color: E3E5F9Color,)),
  //         ListTile(
  //           leading: SvgPicture.asset('assets/icons/home.svg',color: grayLightColor,
  //               width: 20, height: 20),
  //           title: Text(AppLocalizations.of(context)!.dashboard,style: Styles.mediumTextStyle(size: 14),),
  //           onTap: () {
  //             setState(() => _currentIndex = 0);
  //             Navigator.pop(context);
  //           },
  //         ),
  //         // Container(
  //         //     margin: EdgeInsets.only(left: 50),
  //         //     child: Divider(height: 1,color: E3E5F9Color,)),
  //         // ListTile(
  //         //   leading: SvgPicture.asset('assets/icons/user.svg',
  //         //       width: 20, height: 20),
  //         //   title: Text(AppLocalizations.of(context)!.jobs,style: Styles.mediumTextStyle(size: 14),),
  //         //   onTap: () {
  //         //     setState(() => _currentIndex = 1);
  //         //     Navigator.pop(context);
  //         //   },
  //         // ),
  //         // Container(
  //         //     margin: EdgeInsets.only(left: 50),
  //         //     child: Divider(height: 1,color: E3E5F9Color,)),
  //         // ListTile(
  //         //   leading: SvgPicture.asset(
  //         //     'assets/icons/calendar.svg',
  //         //     width: 20,
  //         //     height: 20,
  //         //     fit: BoxFit.cover,
  //         //   ),
  //         //   title: Text(AppLocalizations.of(context)!.scheduledinterviews,style: Styles.mediumTextStyle(size: 14),),
  //         //   onTap: () {
  //         //     setState(() => _currentIndex = 3);
  //         //     Navigator.pop(context);
  //         //   },
  //         // ),
  //         // Container(
  //         //     margin: EdgeInsets.only(left: 50),
  //         //     child: Divider(height: 1,color: E3E5F9Color,)),
  //         // ListTile(
  //         //   leading: SvgPicture.asset(
  //         //     'assets/icons/briefcase.svg',
  //         //     width: 20,
  //         //     height: 20,
  //         //     fit: BoxFit.cover,
  //         //   ),
  //         //   title: Text(AppLocalizations.of(context)!.cvbuilder,style: Styles.mediumTextStyle(size: 14),),
  //         //   onTap: () {
  //         //     Navigator.pop(context);
  //         //     Navigator.push(
  //         //       context,
  //         //       MaterialPageRoute(builder: (context) => CvListScreen()),
  //         //     );
  //         //   },
  //         // ),
  //         // ExpansionTile(
  //         //   leading: SvgPicture.asset(
  //         //     'assets/icons/calendarNew.svg',
  //         //     width: 20,
  //         //     height: 20,
  //         //     fit: BoxFit.cover,
  //         //   ),
  //         //   title: Text(AppLocalizations.of(context)!.searchJobApply,style: Styles.mediumTextStyle(size: 14),),
  //         //
  //         //   children: [
  //         //
  //         //     // 1️⃣ Preferred/Recommended Jobs
  //         //     ListTile(
  //         //       title: Text("Preferred/Recommended Jobs",style: Styles.mediumTextStyle(size: 14),),
  //         //       onTap: () {
  //         //         Navigator.pop(context);
  //         //         Navigator.push(
  //         //           context,
  //         //           MaterialPageRoute(builder: (context) => PreferredJobsScreen()),
  //         //         );
  //         //       },
  //         //     ),
  //         //
  //         //     // 2️⃣ Applied Jobs
  //         //     ListTile(
  //         //       title: Text("Applied Jobs",style: Styles.mediumTextStyle(size: 14),),
  //         //       onTap: () {
  //         //         Navigator.pop(context);
  //         //         Navigator.push(
  //         //           context,
  //         //           MaterialPageRoute(builder: (context) => AppliedJobsScreen()),
  //         //         );
  //         //       },
  //         //     ),
  //         //
  //         //   ],
  //         // ),
  //         // Container(
  //         //     margin: EdgeInsets.only(left: 50),
  //         //     child: Divider(height: 1,color: E3E5F9Color,)),
  //         // ListTile(
  //         //   leading: SvgPicture.asset(
  //         //     'assets/icons/search-zoom-in.svg',
  //         //     width: 20,
  //         //     height: 20,
  //         //     fit: BoxFit.cover,
  //         //   ),
  //         //   title: Text(AppLocalizations.of(context)!.searchcounselor,style: Styles.mediumTextStyle(size: 14),),
  //         //   onTap: () {
  //         //     setState(() => _currentIndex = 3);
  //         //     Navigator.pop(context);
  //         //   },
  //         // ),
  //   //       Container(
  //   //           margin: EdgeInsets.only(left: 50),
  //   //           child: Divider(height: 1,color: E3E5F9Color,)),
  //   //
  //   //           ListTile(
  //   // leading: SvgPicture.asset(
  //   //     'assets/icons/calendarNew.svg',
  //   //     width: 20,
  //   //     height: 20,
  //   //     fit: BoxFit.cover,
  //   //   ),
  //   //         title: Text("Job Apply",style: Styles.mediumTextStyle(size: 14),),
  //   //         onTap: () {
  //   //           Navigator.pop(context);
  //   //           Navigator.push(
  //   //             context,
  //   //             // MaterialPageRoute(builder: (context) => JobApplyListScreen()),
  //   //             MaterialPageRoute(builder: (context) => SelectCompanyPage()),
  //   //
  //   //           );
  //   //         },
  //   //       ),
  //   //       ExpansionTile(
  //   //         leading: SvgPicture.asset(
  //   //           'assets/icons/calendarNew.svg',
  //   //           width: 20,
  //   //           height: 20,
  //   //           fit: BoxFit.cover,
  //   //         ),
  //   //         title: Text(AppLocalizations.of(context)!.jobfairevents,style: Styles.mediumTextStyle(size: 14),),
  //   //
  //   //         children: [
  //   //
  //   //           // 1️⃣ Events
  //   //           ListTile(
  //   //             title: Text("Events",style: Styles.mediumTextStyle(size: 14),),
  //   //             onTap: () {
  //   //               Navigator.pop(context);
  //   //               Navigator.push(
  //   //                 context,
  //   //                 MaterialPageRoute(builder: (context) => JobsFairEventScreen()),
  //   //               );
  //   //             },
  //   //           ),
  //   //
  //   //           // 2️⃣ Registered Event
  //   //           ListTile(
  //   //             title: Text("Registered Event",style: Styles.mediumTextStyle(size: 14),),
  //   //             onTap: () {
  //   //               Navigator.pop(context);
  //   //               Navigator.push(
  //   //                 context,
  //   //                 MaterialPageRoute(builder: (context) => RegisteredEventListScreen()),
  //   //               );
  //   //             },
  //   //           ),
  //   //
  //   //        //   3️⃣ Job Apply // hide as of now as discussed with pankaj sir
  //   //           ListTile(
  //   //             title: Text("Job Apply",style: Styles.mediumTextStyle(size: 14),),
  //   //             onTap: () {
  //   //               Navigator.pop(context);
  //   //                Navigator.push(
  //   //                  context,
  //   //                  // MaterialPageRoute(builder: (context) => JobApplyListScreen()),
  //   //                  MaterialPageRoute(builder: (context) => SelectCompanyPage()),
  //   //
  //   //                );
  //   //             },
  //   //           ),
  //   //         ],
  //   //       ),
  //   //       Container(
  //   //           margin: EdgeInsets.only(left: 50),
  //   //           child: Divider(height: 1,color: E3E5F9Color,)),
  //   //       ListTile(
  //   //         leading: SvgPicture.asset(
  //   //           'assets/icons/import.svg',
  //   //           width: 20,
  //   //           height: 20,
  //   //           fit: BoxFit.cover,
  //   //         ),
  //   //         title: Text(AppLocalizations.of(context)!.downldregiscard,style: Styles.mediumTextStyle(size: 14),),
  //   //         onTap: () {
  //   //           Navigator.pop(context);
  //   //           Navigator.push(
  //   //             context,
  //   //             MaterialPageRoute(builder: (context) => RegistrationCardScreen()),
  //   //           );
  //   //
  //   //
  //   //         },
  //   //       ),
  //   //       Container(
  //   //           margin: EdgeInsets.only(left: 50),
  //   //           child: Divider(height: 1,color: E3E5F9Color,)),
  //   //       ExpansionTile(
  //   //         leading: SvgPicture.asset(
  //   //           'assets/icons/calendarNew.svg',
  //   //           width: 20,
  //   //           height: 20,
  //   //           fit: BoxFit.cover,
  //   //         ),
  //   //         title: Text("Departmental Schemes",style: Styles.mediumTextStyle(size: 14),),
  //   //
  //   //         children: [
  //   //
  //   //
  //   //           // ListTile(
  //   //           //   title: Text("MYRPY",style: Styles.mediumTextStyle(size: 14),),
  //   //           //   onTap: () {
  //   //           //     Navigator.pop(context);
  //   //           //
  //   //           //   },
  //   //           // ),
  //   //
  //   //
  //   //           ListTile(
  //   //             title: Text("MYSY Pending List",style: Styles.mediumTextStyle(size: 14),),
  //   //             onTap: () {
  //   //               Navigator.pop(context);
  //   //               Navigator.push(
  //   //                 context,
  //   //                 MaterialPageRoute(builder: (context) => MysyListScreen()),
  //   //               );
  //   //             },
  //   //           ),
  //   //
  //   //
  //   //
  //   //
  //   //         ],
  //   //       ),
  //         Container(
  //             margin: EdgeInsets.only(left: 50),
  //             child: Divider(height: 1,color: E3E5F9Color,)),
  //
  //         // ListTile(
  //         //   leading: SvgPicture.asset(
  //         //     'assets/icons/star.svg',
  //         //     width: 20,
  //         //     height: 20,
  //         //     fit: BoxFit.cover,
  //         //   ),
  //         //   title: Text(AppLocalizations.of(context)!.grievfeedbak,style: Styles.mediumTextStyle(size: 14),),
  //         //   onTap: () async {
  //         //     final result = await  Navigator.push(
  //         //       context,
  //         //       MaterialPageRoute(
  //         //         builder: (context) =>  GrievanceScreen(),
  //         //       ),
  //         //     );
  //         //     if (result != null) {
  //         //
  //         //     }
  //         //     Navigator.pop(context);
  //         //   },
  //         // ),
  //         // Container(
  //         //     margin: EdgeInsets.only(left: 50),
  //         //     child: Divider(height: 1,color: E3E5F9Color,)),
  //         //
  //         // ListTile(
  //         //   leading: SvgPicture.asset(
  //         //     'assets/icons/star.svg',
  //         //     width: 20,
  //         //     height: 20,
  //         //     fit: BoxFit.cover,
  //         //   ),
  //         //   title: Text(AppLocalizations.of(context)!.videoprof,style: Styles.mediumTextStyle(size: 14),),
  //         //   onTap: () async {
  //         //     final result = await  Navigator.push(
  //         //       context,
  //         //       MaterialPageRoute(
  //         //         builder: (context) =>  VideoprofileScreen(),
  //         //       ),
  //         //     );
  //         //     if (result != null) {
  //         //
  //         //     }
  //         //     Navigator.pop(context);
  //         //   },
  //         // ),
  //         // Container(
  //         //     margin: EdgeInsets.only(left: 50),
  //         //     child: Divider(height: 1,color: E3E5F9Color,)),
  //         // ListTile(
  //         //   leading: SvgPicture.asset(
  //         //     'assets/icons/receipt-edit.svg',
  //         //     width: 20,
  //         //     height: 20,
  //         //     fit: BoxFit.cover,
  //         //   ),
  //         //   title: Text(AppLocalizations.of(context)!.selfassess,style: Styles.mediumTextStyle(size: 14),),
  //         //   // onTap: () {
  //         //   //   setState(() => _currentIndex = 3);
  //         //   //   Navigator.pop(context);
  //         //   // },
  //         //   onTap: () async {
  //         //     final result = await  Navigator.push(
  //         //       context,
  //         //       MaterialPageRoute(
  //         //         builder: (context) =>  SelfAssessmentScreen(),
  //         //       ),
  //         //     );
  //         //     if (result != null) {
  //         //
  //         //     }
  //         //     Navigator.pop(context);
  //         //   },
  //         // ),
  //         // Container(
  //         //     margin: EdgeInsets.only(left: 50),
  //         //     child: Divider(height: 1,color: E3E5F9Color,)),
  //         // ListTile(
  //         //   leading: SvgPicture.asset(
  //         //     'assets/icons/econometrics.svg',
  //         //     width: 20,
  //         //     height: 20,
  //         //     fit: BoxFit.cover,
  //         //   ),
  //         //   title: Text(AppLocalizations.of(context)!.appntmntschdl,style: Styles.mediumTextStyle(size: 14),),
  //         //   onTap: () {
  //         //     setState(() => _currentIndex = 3);
  //         //     Navigator.pop(context);
  //         //   },
  //         // ),
  //         Container(
  //             margin: EdgeInsets.only(left: 50),
  //             child: Divider(height: 1,color: E3E5F9Color,)),
  //         ListTile(
  //           leading: SvgPicture.asset(
  //             'assets/icons/setting.svg',
  //             width: 20,
  //             height: 20,
  //             fit: BoxFit.cover,
  //           ),
  //           title: Text(AppLocalizations.of(context)!.settings,style: Styles.mediumTextStyle(size: 14),),
  //           onTap: () {
  //             setState(() => _currentIndex = 3);
  //             Navigator.pop(context);
  //           },
  //         ),
  //         Container(
  //             margin: EdgeInsets.only(left: 50),
  //             child: Divider(height: 1,color: E3E5F9Color,)),
  //         ListTile(
  //           leading: SvgPicture.asset(
  //             'assets/icons/logout.svg',
  //             width: 20,
  //             height: 20,
  //             fit: BoxFit.cover,
  //           ),
  //           title: Text(AppLocalizations.of(context)!.logout,style: Styles.mediumTextStyle(size: 14),),
  //           onTap: () async {
  //             Navigator.pop(context); // Close the drawer
  //             showLogoutDialog(context, AppLocalizations.of(context)!.logout,AppLocalizations.of(context)!.areYouSureLogOut, AppLocalizations.of(context)!.logoutThankYouText, (value) async {
  //                 if (value.toString() == "success") {
  //                   // earlier working code, before remember me
  //                   // final pref = AppSharedPref();
  //                   // pref.save('UserData', '');
  //                   // pref.remove('UserData');
  //
  //                   // changes for remember me
  //
  //                   final pref = AppSharedPref();
  //
  //                   // final commonRepo = Provider.of<CommonRepo>(context, listen: false);
  //                   // commonRepo.dioClient.clearAuthToken();
  //
  //                   // Clear login session only
  //                   UserData().model.value.isLogin = false;
  //                   UserData().model.value.userId = null;
  //
  //                 // ✅ Clear SharedPreferences
  //                   await pref.remove('UserData');
  //
  //                 // ✅ Clear in-memory user data
  //                 //   UserData().model.value.isLogin = false;
  //                 //   UserData().model.value.username = "";
  //                 //   UserData().model.value.password = "";
  //                 //   UserData().model.value.userId = null;
  //
  //                 // ✅ Navigate cleanly (remove all previous screens)
  //                   Navigator.pushAndRemoveUntil(
  //                     context,
  //                     MaterialPageRoute(builder: (_) => const LoginScreen()),
  //                         (route) => false,
  //                   );
  //
  //                   // Navigator.of(context).push(
  //                   //   MaterialPageRoute(
  //                   //     builder: (BuildContext context) =>
  //                   //     const LoginScreen(),
  //                   //   ),
  //                   // );
  //                 }
  //               },
  //             );
  //           },
  //         ),
  //         Container(
  //             margin: EdgeInsets.only(left: 50),
  //             child: Divider(height: 1,color: E3E5F9Color,)),
  //       ],
  //     ),
  //   );
  // }
}
