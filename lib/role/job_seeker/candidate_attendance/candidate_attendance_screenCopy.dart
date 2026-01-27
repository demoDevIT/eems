
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
import '../../../utils/right_to_left_route.dart';
import '../../../utils/user_new.dart';
import '../homescreen/home_screen.dart';
import '../loginscreen/screen/login_screen.dart';
import '../profile/profile.dart';
import '../qr_scanner/qr_scanner_screen.dart';

class CandidateAttendanceScreen extends StatefulWidget {
  const CandidateAttendanceScreen({super.key});

  @override
  State<CandidateAttendanceScreen> createState() => _CandidateAttendanceScreenState();
}

class _CandidateAttendanceScreenState extends State<CandidateAttendanceScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        showExitDialog(
          context,
          "Are you sure you want to exit?",
              (value) => exitApp(context, value),
        );
        return false;
      },
      child: Scaffold(
        drawer: _buildSideDrawer(), // ✅ KEEP drawer

        appBar: AppBar(
          title: const Text(
            "Scan Candidate QR",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),
        ),

        body: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 52,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: kViewAllColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              onPressed: () async {

                Navigator.of(context).push(
                  RightToLeftRoute(
                    page: const QRScannerScreen(),
                    duration: const Duration(milliseconds: 500),
                    startOffset: const Offset(-1.0, 0.0),
                  ),
                );

                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (_) => const QRScannerScreen(),
                //   ),
                // );
                setState(() {
                });
              },
              child: const Text(
                "Scan QR",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
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
                              "Demo User",
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          // GestureDetector(
                          //   onTap: () {
                          //     Navigator.pop(context);
                          //     Navigator.push(
                          //       context,
                          //       MaterialPageRoute(builder: (context) =>  ProfileScreen(isAppBarHide: true,)),
                          //     );
                          //   },
                          //   child: Text(
                          //     AppLocalizations.of(context)!.updateprofile,
                          //     style: TextStyle(
                          //       fontSize: 14,
                          //       //color: Colors.blue,
                          //       color: kViewAllColor,
                          //       fontWeight: FontWeight.w600,
                          //       decoration: TextDecoration.none,
                          //     ),
                          //   ),
                          // ),
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