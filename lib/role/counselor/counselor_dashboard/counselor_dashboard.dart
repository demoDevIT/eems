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

  //int _currentIndex = 0;

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
        title: const Text(
          "Counselor Dashboard",
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
                      child: const Text(
                        "Apply Now",
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

  /// ✅ COPY SAME DRAWER (just change name fields)
  Drawer _buildSideDrawer() {
    return Drawer(
      child: ListView(
        children: [
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
                        "https://randomuser.me/api/portraits/men/11.jpg",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(width: 12),

                    /// 👇 Dynamic name from UserData
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          UserData().model.value.firstName ?? "",
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
                            //     builder: (context) =>
                            //         ProfileScreen(isAppBarHide: true),
                            //   ),
                            // );
                          },
                          child: const Text(
                            "Update Profile",
                            style: TextStyle(
                              fontSize: 14,
                              color: kViewAllColor,
                              fontWeight: FontWeight.w600,
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

          // ListTile(
          //   leading: const Icon(Icons.dashboard),
          //   title: const Text("Dashboard"),
          //   onTap: () => Navigator.pop(context),
          // ),
          //
          // const Divider(),
          //
          // /// You can keep or remove extra menu items
          // ListTile(
          //   leading: const Icon(Icons.event),
          //   title: const Text("Job Fair"),
          //   onTap: () {
          //     Navigator.pop(context);
          //     Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //         builder: (context) => const JobFairScreen(),
          //       ),
          //     );
          //   },
          // ),
          //
          // const Divider(),

          /// Logout (same as employer)
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () async {
              Navigator.pop(context);

              final pref = AppSharedPref();
              // final commonRepo = Provider.of<CommonRepo>(context, listen: false);
              // commonRepo.dioClient.clearAuthToken();
              UserData().model.value.isLogin = false;
              UserData().model.value.userId = null;
              await pref.remove('UserData');

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  /// Side Drawer
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
