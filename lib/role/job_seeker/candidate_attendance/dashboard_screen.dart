
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rajemployment/role/job_seeker/loginscreen/provider/locale_provider.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repo/common_repo.dart';
import '../../../utils/app_shared_prefrence.dart';
import '../../../utils/global.dart';
import '../../../utils/images.dart';
import '../../../utils/language_toggle_switch.dart';
import '../../../utils/right_to_left_route.dart';
import '../../../utils/user_new.dart';
import '../../department/dept_dashboard/modal/role_modal.dart';
import '../loginscreen/screen/login_screen.dart';
import '../qr_scanner/qr_scanner_screen.dart';
import 'candidate_attendance_screen.dart';
import 'job_fair_registration.dart';
import 'provider/dashboard_provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardProvider>().getRoleApi(context, "");

      // Provider.of<DashboardProvider>(
      //   context,
      //   listen: false,
      // ).getEventList(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool hideRoleSection =
        UserData().model.value.sso == "EEMSJobFairEvent";

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
        backgroundColor: const Color(0xffF4F6FB),
        drawer: _buildSideDrawer(), // ✅ KEEP drawer

        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.dashboard,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          //iconTheme: const IconThemeData(color: Colors.black),

          actions: [
            if (!hideRoleSection)
              Consumer<DashboardProvider>(
              builder: (context, provider, _) {
                return PopupMenuButton<RoleData>(
                  offset: const Offset(0, 10), // opens below button
                  position: PopupMenuPosition.under,
                  // constraints: BoxConstraints(
                  //   minWidth: MediaQuery.of(context).size.width * 0.95,
                  //   maxWidth: MediaQuery.of(context).size.width * 0.95,
                  // ),

                  // Don't use 95% screen width here
                  constraints: BoxConstraints(
                    minWidth: 220,
                    maxWidth: MediaQuery.of(context).size.width * 0.75,
                  ),
                  child: Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.manage_accounts,
                            color: Colors.white, size: 18),
                        SizedBox(width: 4),
                        Text(
                          AppLocalizations.of(context)!.role,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(width: 2),
                        Icon(Icons.keyboard_arrow_down,
                            color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                  onSelected: (RoleData role) async {
                    provider.selectedRole = role;

                    provider.roleNameController.text = role.roleName ?? "";
                    provider.roleIdController.text = role.roleID?.toString() ?? "";

                    provider.notifyListeners();

                    print("dashboard Selected Role : ${role.roleName}");
                    print("Role Id : ${role.roleID}");

                    final roleID = role.roleID;
                    final officeID = role.officeID;
                    final internDeptTypeID = role.internshipDeptTypeID;
                    final internDeptID = role.internshipDeptID;


                    await provider.GetSSOUserDetail(
                      context,
                       switchRoleID: roleID!,
                       switchOfficeID: officeID!, // use your actual field name
                      intDeptTypeID: internDeptTypeID!, // use your actual field name
                      intDeptID: internDeptID!, // use your actual field name
                    );
                  },
                  itemBuilder: (context) {
                    return provider.roleList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final role = entry.value;

                      final bool isSelected =
                          role.roleID == UserData().model.value.roleId &&
                              role.officeID == UserData().model.value.officeID &&
                              role.internshipDeptID == UserData().model.value.internshipDeptID;

                      return PopupMenuItem<RoleData>(
                        value: role,
                        padding: EdgeInsets.zero,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? Colors.blue.shade50 : Colors.white,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(
                                Icons.work_outline,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      //role.roleName ?? "",
                                      Localizations.localeOf(context)
                                          .languageCode ==
                                          'hi'
                                          ? (role.roleNameHi ??
                                          role.roleName ??
                                          "")
                                          : (role.roleName ?? ""),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                      ),
                                    ),

                                    // Text(
                                    //   role.roleName ?? "",
                                    //   style: const TextStyle(
                                    //     fontWeight: FontWeight.w600,
                                    //     fontSize: 15,
                                    //   ),
                                    // ),

                                    // const SizedBox(height: 4),
                                    // Text(
                                    //   role.officeNameEn ?? "",
                                    //   style: TextStyle(
                                    //     color: Colors.grey.shade600,
                                    //     fontSize: 12,
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList();
                  },
                );
              },
            ),
            Padding(
              //padding: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.only(
                left: 2,
                right: 6,
              ),
              child: SizedBox(
                width: 80,
                child: LanguageToggleSwitch(),
              ),
            ),
          ],
        ),

        // body: SingleChildScrollView(
        //   child: Padding(
        //     padding: const EdgeInsets.all(14),
        //     child: Column(
        //       children: [
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(14, 14, 14, 40),
            child: Column(
              children: [
                /// TOP WELCOME CARD
                _welcomeCard(),
                const SizedBox(height: 18),

                if (!hideRoleSection) ...[
                  _buildRoleSection(),
                  const SizedBox(height: 18),
                ],

                const SizedBox(height: 18),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.quickActs,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff6B7898),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                /// ACTION CARDS
                _actionCard(
                  iconPath: "assets/images/QRsvg.svg",
                  title: AppLocalizations.of(context)!.scanQR,
                  subTitle: AppLocalizations.of(context)!.scanQRInstantCheckIn,
                  iconBg: const Color(0xff5B5CEB),
                  onTap: () {
                    Navigator.of(context).push(
                      RightToLeftRoute(
                        page: const QRScannerScreen(),
                        duration: const Duration(milliseconds: 500),
                        startOffset: const Offset(-1.0, 0.0),
                      ),
                    );
                  },
                ),


                const SizedBox(height: 14),

                _actionCard(
                  iconPath: "assets/images/eventRegsvg.svg",
                  title: AppLocalizations.of(context)!.eventRegNoMobNo,
                  subTitle: AppLocalizations.of(context)!.enterRegNoMobile,
                  iconBg: const Color(0xff8D4AF2),
                  onTap: () {
                    Navigator.of(context).push(
                      RightToLeftRoute(
                        page: const CandidateAttendanceScreen(),
                        duration: const Duration(milliseconds: 500),
                        startOffset: const Offset(-1.0, 0.0),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 14),

                _actionCard(
                  iconPath: "assets/images/BackgroundPlus.svg",
                  // title: AppLocalizations.of(context)!.newReg,
                  title: AppLocalizations.of(context)!.jobFairReg,
                  subTitle: AppLocalizations.of(context)!.regNewForEvent,
                  iconBg: const Color(0xff8D4AF2),
                  onTap: () {
                    Navigator.of(context).push(
                      RightToLeftRoute(
                        page: const JobFairRegistrationScreen(),
                        duration: const Duration(milliseconds: 500),
                        startOffset: const Offset(-1.0, 0.0),
                      ),
                    );
                  },
                ),

                // const SizedBox(height: 14),
                //
                // _actionCard(
                //   iconPath: "assets/images/mobSvg.svg",
                //   title: "Mobile Number",
                //   subTitle: "Look up your event pass using phone number",
                //   iconBg: const Color(0xff19B9D8),
                //   onTap: () {
                //     Navigator.of(context).push(
                //       RightToLeftRoute(
                //         page: const CandidateAttendanceScreen(),
                //         duration: const Duration(milliseconds: 500),
                //         startOffset: const Offset(-1.0, 0.0),
                //       ),
                //     );
                //   },
                // ),

                const SizedBox(height: 40),

              ],
            ),
          ),
        ),

      ),
    );
  }

  Widget _buildRoleSection() {
    return Consumer<DashboardProvider>(
      builder: (context, provider, _) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // /// Select Role Label
            // const Padding(
            //   padding: EdgeInsets.only(left: 4),
            //   child: Text(
            //     "SELECT ROLE",
            //     style: TextStyle(
            //       fontSize: 13,
            //       fontWeight: FontWeight.w700,
            //       color: Color(0xff7B849B),
            //       letterSpacing: 0.5,
            //     ),
            //   ),
            // ),
            //
            // const SizedBox(height: 10),
            //
            // /// Dropdown
            // Container(
            //   padding: const EdgeInsets.symmetric(horizontal: 14),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(14),
            //     border: Border.all(color: const Color(0xffE7EBF3)),
            //   ),
            //   child: DropdownButtonHideUnderline(
            //     child: DropdownButton<RoleData>(
            //       isExpanded: true,
            //       value: provider.selectedRole,
            //       hint: const Text(
            //         "Select Role",
            //         style: TextStyle(fontSize: 15),
            //       ),
            //       icon: const Icon(Icons.keyboard_arrow_down_rounded),
            //       items: provider.roleList.map((role) {
            //         return DropdownMenuItem<RoleData>(
            //           value: role,
            //           child: Text(
            //             role.roleName ?? "",
            //             overflow: TextOverflow.ellipsis,
            //           ),
            //         );
            //       }).toList(),
            //       onChanged: (role) async {
            //
            //         if (role == null) return;
            //
            //         provider.selectedRole = role;
            //         provider.notifyListeners();
            //
            //         if (role.roleID != null && role.officeID != null) {
            //           await provider.GetSSOUserDetail(
            //             context,
            //             switchRoleID: role.roleID!,
            //             switchOfficeID: role.officeID!,
            //           );
            //         }
            //       },
            //     ),
            //   ),
            // ),
            //
            // const SizedBox(height: 14),

            /// Department & Office Card
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xffE7EBF3),
                ),
              ),
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            AppLocalizations.of(context)!.roleName,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xff344054),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            UserData().model.value.roleName ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            // AppLocalizations.of(context)!.ofcName,
                            AppLocalizations.of(context)!.empExchange + ":-",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xff344054),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            UserData().model.value.office ?? "",
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  /// Side Drawer
  Drawer _buildSideDrawer() {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);
    return Drawer(
      child: ListView(
        children: [
          // ===== Header =====
          Container(
            padding: const EdgeInsets.only(
              top: 40,
              left: 16,
              right: 16,
              bottom: 20,
            ),
            color: Colors.white,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // =========================
                    // Application Logo
                    // =========================
                    Image.asset(
                      "assets/logos/logo.png",
                      height: 60,
                      fit: BoxFit.contain,
                    ),

                    const SizedBox(height: 8),

                    // =========================
                    // Application Name
                    // =========================
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff152238),
                            height: 1.3,
                            letterSpacing: 0.3,
                          ),
                          children: [
                            TextSpan(
                              text: "Employment Exchange Management System\n",
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            TextSpan(
                              text: "(EEMS 2.0)",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: Color(0xff1683FF),
                                letterSpacing: 0.8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =========================
                    // Profile + User Name
                    // =========================
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                          child: Image.network(
                            UserData().model.value.latestPhotoPath.toString(),
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                Images.placeholder,
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              );
                            },
                          ),
                        ),

                        const SizedBox(width: 12),

                        Expanded(
                          child: Text(
                            UserData().model.value.displayName ?? "",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xff152238),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // =========================
                // Close Button
                // =========================
                Positioned(
                  top: 0,
                  right: 0,
                  child: InkWell(
                    onTap: () => Navigator.pop(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.all(4),
                      child: SvgPicture.asset(
                        'assets/icons/close.svg',
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 50),
              child: Divider(height: 1,color: E3E5F9Color,)),

          // ===== Exchange Details =====
          Container(
            margin: const EdgeInsets.fromLTRB(12, 12, 12, 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xffF7F9FC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: const Color(0xffE4E9F2),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                // Row(
                //   children: [
                //     Container(
                //       width: 34,
                //       height: 34,
                //       decoration: BoxDecoration(
                //         color: const Color(0xffE8F2FF),
                //         borderRadius: BorderRadius.circular(10),
                //       ),
                //       child: const Icon(
                //         Icons.business_outlined,
                //         size: 19,
                //         color: Color(0xff1683FF),
                //       ),
                //     ),
                //     const SizedBox(width: 10),
                //     Expanded(
                //       child: Text(
                //         AppLocalizations.of(context)!.empExchange,
                //         style: const TextStyle(
                //           fontSize: 14,
                //           fontWeight: FontWeight.w700,
                //           color: Color(0xff152238),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),

               // const SizedBox(height: 14),

                // Exchange Name
                _drawerInfoRow(
                  icon: Icons.account_balance_outlined,
                  label: AppLocalizations.of(context)!.empExchange,
                  value: UserData().model.value.office,
                ),
              ],
            ),
          ),

          ListTile(
            leading: SvgPicture.asset('assets/icons/home.svg',color: grayLightColor,
                width: 20, height: 20),
            title: Text(AppLocalizations.of(context)!.dashboard,style: Styles.mediumTextStyle(size: 14),),
            onTap: () {
             // setState(() => _currentIndex = 0);
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
            onTap: () async {
              Navigator.pop(context); // Close the drawer
              showLogoutDialog(context, AppLocalizations.of(context)!.logout,AppLocalizations.of(context)!.logoutConfirmMsg, AppLocalizations.of(context)!.logoutThankYouText, (value) async {
                if (value.toString() == "success") {
                  final pref = AppSharedPref();
                  // Clear login session only
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

                  // Navigator.of(context).push(
                  //   MaterialPageRoute(
                  //     builder: (BuildContext context) =>
                  //     const LoginScreen(),
                  //   ),
                  // );
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

  Widget _drawerInfoRow({
    required IconData icon,
    required String label,
    required String? value,
  }) {
    final displayValue =
    (value == null || value.trim().isEmpty) ? "-" : value.trim();

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            size: 17,
            color: const Color(0xff667085),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff667085),
                  letterSpacing: 0.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                displayValue,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff344054),
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  //============================================================
  // WELCOME CARD
  //============================================================
  Widget _welcomeCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white70,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.helloThere,
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff7C849B),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  AppLocalizations.of(context)!.welcomeBack,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff111827),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context)!.manageEventsScanQR,
                  style: TextStyle(
                    fontSize: 13,
                    height: 1.5,
                    color: Color(0xff6B7280),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 10),

          Image.asset(
            "assets/images/canDashUserImg.png",
            height: 85,
          ),
        ],
      ),
    );
  }

  //============================================================
  // ACTION CARD
  //============================================================
  Widget _actionCard({
    required String iconPath,
    required String title,
    required String subTitle,
    required Color iconBg,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 70,
              width: 70,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                //color: iconBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: SvgPicture.asset(
                iconPath,
                height: 40,
                width: 40,
                // color: Colors.white,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              title,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Color(0xff111827),
              ),
            ),

            const SizedBox(height: 6),

            Text(
              subTitle,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xff7A8095),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }



}

