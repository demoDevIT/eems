import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rajemployment/role/job_seeker/cv_builder/cv_list.dart';
import 'package:rajemployment/role/job_seeker/grievance/add_grievance_screen.dart';
import 'package:rajemployment/role/job_seeker/loginscreen/provider/locale_provider.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/app_shared_prefrence.dart';
import '../../../utils/global.dart';
import '../../../utils/images.dart';
import '../../../utils/user_new.dart';
import '../../notification/notification_list.dart';
import '../departmental_schemes/mysy_pending_list.dart';
import '../grievance/grievance_list.dart';
import '../homescreen/home_screen.dart';
import '../job_fair_event/job_apply_list.dart';
import '../job_fair_event/jobs_fair_event.dart';
import '../job_fair_event/registered_event_list.dart';
import '../jobs/jobs_list.dart';
import '../loginscreen/screen/login_screen.dart';
import '../profile/profile.dart';
import '../qr_scanner/qr_scanner_screen.dart';
import '../registration_card/registration_card.dart';
import '../select_company/select_company_page.dart';

class JobSeekerDashboard extends StatefulWidget {
  const JobSeekerDashboard({super.key});

  @override
  State<JobSeekerDashboard> createState() => _JobSeekerDashboard();
}

class _JobSeekerDashboard extends State<JobSeekerDashboard> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    JobsListScreen(),
    NotificationListScreen(),
    Center(child: Text("Settings Page")),
    ProfileScreen(isAppBarHide: false,),
  ];

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
        appBar: commonAppBar("Jobs", context,
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
        BottomNavigationBarItem(icon: Icon(Icons.person), label: AppLocalizations.of(context)!.profile),
      ],
    );
  }

  /// Side Drawer
  /// Side Drawer
  Drawer _buildSideDrawer() {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    return Drawer(
      child: ListView(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 20),
            color: Colors.white,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Profile avatar + progress
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
                                  width: MediaQuery.of(context).size.width * 0.18,
                                  height: MediaQuery.of(context).size.width * 0.18,
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
                  const SizedBox(width: 12),
                  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width :MediaQuery.of(context).size.width * 0.20,
                            child:  Text(
                              UserData().model.value.nAMEENG.toString(),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>  ProfileScreen(isAppBarHide: true,)),
                              );
                            },
                            child: Text(
                              AppLocalizations.of(context)!.updateprofile,
                              style: TextStyle(
                                fontSize: 14,
                                //color: Colors.blue,
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
                ),
                // Close button
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
          Container(
              margin: EdgeInsets.only(left: 50),
              child: Divider(height: 1,color: E3E5F9Color,)),
          ListTile(
            leading: SvgPicture.asset('assets/icons/home.svg',color: grayLightColor,
                width: 20, height: 20),
            title: Text(AppLocalizations.of(context)!.dashboard,style: Styles.mediumTextStyle(size: 14),),
            onTap: () {
              setState(() => _currentIndex = 0);
              Navigator.pop(context);
            },
          ),
          // Container(
          //     margin: EdgeInsets.only(left: 50),
          //     child: Divider(height: 1,color: E3E5F9Color,)),
          // ListTile(
          //   leading: SvgPicture.asset('assets/icons/user.svg',
          //       width: 20, height: 20),
          //   title: Text(AppLocalizations.of(context)!.jobs,style: Styles.mediumTextStyle(size: 14),),
          //   onTap: () {
          //     setState(() => _currentIndex = 1);
          //     Navigator.pop(context);
          //   },
          // ),
          Container(
              margin: EdgeInsets.only(left: 50),
              child: Divider(height: 1,color: E3E5F9Color,)),
          ListTile(
            leading: SvgPicture.asset(
              'assets/icons/calendar.svg',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            title: Text(AppLocalizations.of(context)!.scheduledinterviews,style: Styles.mediumTextStyle(size: 14),),
            onTap: () {
              setState(() => _currentIndex = 3);
              Navigator.pop(context);
            },
          ),
          Container(
              margin: EdgeInsets.only(left: 50),
              child: Divider(height: 1,color: E3E5F9Color,)),
          ListTile(
            leading: SvgPicture.asset(
              'assets/icons/briefcase.svg',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            title: Text(AppLocalizations.of(context)!.cvbuilder,style: Styles.mediumTextStyle(size: 14),),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CvListScreen()),
              );
            },
          ),
          Container(
              margin: EdgeInsets.only(left: 50),
              child: Divider(height: 1,color: E3E5F9Color,)),
          ListTile(
            leading: SvgPicture.asset(
              'assets/icons/search-zoom-in.svg',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            title: Text(AppLocalizations.of(context)!.searchcounselor,style: Styles.mediumTextStyle(size: 14),),
            onTap: () {
              setState(() => _currentIndex = 3);
              Navigator.pop(context);
            },
          ),
          Container(
              margin: EdgeInsets.only(left: 50),
              child: Divider(height: 1,color: E3E5F9Color,)),

              ListTile(
    leading: SvgPicture.asset(
        'assets/icons/calendarNew.svg',
        width: 20,
        height: 20,
        fit: BoxFit.cover,
      ),
            title: Text("Job Apply",style: Styles.mediumTextStyle(size: 14),),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                // MaterialPageRoute(builder: (context) => JobApplyListScreen()),
                MaterialPageRoute(builder: (context) => SelectCompanyPage()),

              );
            },
          ),
          ExpansionTile(
            leading: SvgPicture.asset(
              'assets/icons/calendarNew.svg',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            title: Text(AppLocalizations.of(context)!.jobfairevents,style: Styles.mediumTextStyle(size: 14),),

            children: [

              // 1️⃣ Events
              ListTile(
                title: Text("Events",style: Styles.mediumTextStyle(size: 14),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => JobsFairEventScreen()),
                  );
                },
              ),

              // 2️⃣ Registered Event
              ListTile(
                title: Text("Registered Event",style: Styles.mediumTextStyle(size: 14),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisteredEventListScreen()),
                  );
                },
              ),

              // 3️⃣ Job Apply
              ListTile(
                title: Text("Job Apply",style: Styles.mediumTextStyle(size: 14),),
                onTap: () {
                  Navigator.pop(context);
                   Navigator.push(
                     context,
                     // MaterialPageRoute(builder: (context) => JobApplyListScreen()),
                     MaterialPageRoute(builder: (context) => SelectCompanyPage()),
          
                   );
                },
              ),
            ],
          ),
          Container(
              margin: EdgeInsets.only(left: 50),
              child: Divider(height: 1,color: E3E5F9Color,)),
          ListTile(
            leading: SvgPicture.asset(
              'assets/icons/import.svg',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            title: Text(AppLocalizations.of(context)!.downldregiscard,style: Styles.mediumTextStyle(size: 14),),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => RegistrationCardScreen()),
              );


            },
          ),
          Container(
              margin: EdgeInsets.only(left: 50),
              child: Divider(height: 1,color: E3E5F9Color,)),
          ExpansionTile(
            leading: SvgPicture.asset(
              'assets/icons/calendarNew.svg',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            title: Text("Departmental Schemes",style: Styles.mediumTextStyle(size: 14),),

            children: [


              ListTile(
                title: Text("MYRPY",style: Styles.mediumTextStyle(size: 14),),
                onTap: () {
                  Navigator.pop(context);

                },
              ),


              ListTile(
                title: Text("MYSY Pending List",style: Styles.mediumTextStyle(size: 14),),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MysyPendingListScreen()),
                  );
                },
              ),



            ],
          ),
          Container(
              margin: EdgeInsets.only(left: 50),
              child: Divider(height: 1,color: E3E5F9Color,)),

          ListTile(
            leading: SvgPicture.asset(
              'assets/icons/star.svg',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            title: Text(AppLocalizations.of(context)!.grievfeedbak,style: Styles.mediumTextStyle(size: 14),),
            onTap: () async {
              final result = await  Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>  GrievanceScreen(),
                ),
              );
              if (result != null) {

              }
              Navigator.pop(context);
            },
          ),
          Container(
              margin: EdgeInsets.only(left: 50),
              child: Divider(height: 1,color: E3E5F9Color,)),
          ListTile(
            leading: SvgPicture.asset(
              'assets/icons/receipt-edit.svg',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            title: Text(AppLocalizations.of(context)!.selfassess,style: Styles.mediumTextStyle(size: 14),),
            onTap: () {
              setState(() => _currentIndex = 3);
              Navigator.pop(context);
            },
          ),
          Container(
              margin: EdgeInsets.only(left: 50),
              child: Divider(height: 1,color: E3E5F9Color,)),
          ListTile(
            leading: SvgPicture.asset(
              'assets/icons/econometrics.svg',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            title: Text(AppLocalizations.of(context)!.appntmntschdl,style: Styles.mediumTextStyle(size: 14),),
            onTap: () {
              setState(() => _currentIndex = 3);
              Navigator.pop(context);
            },
          ),
          Container(
              margin: EdgeInsets.only(left: 50),
              child: Divider(height: 1,color: E3E5F9Color,)),
          ListTile(
            leading: SvgPicture.asset(
              'assets/icons/setting.svg',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            title: Text(AppLocalizations.of(context)!.settings,style: Styles.mediumTextStyle(size: 14),),
            onTap: () {
              setState(() => _currentIndex = 3);
              Navigator.pop(context);
            },
          ),
          Container(
              margin: EdgeInsets.only(left: 50),
              child: Divider(height: 1,color: E3E5F9Color,)),
          ListTile(
            leading: SvgPicture.asset(
              'assets/icons/logout.svg',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            title: Text(AppLocalizations.of(context)!.logout,style: Styles.mediumTextStyle(size: 14),),
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
          Container(
              margin: EdgeInsets.only(left: 50),
              child: Divider(height: 1,color: E3E5F9Color,)),
        ],
      ),
    );
  }
}
