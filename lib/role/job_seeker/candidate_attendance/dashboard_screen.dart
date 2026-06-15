
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
import '../../../utils/right_to_left_route.dart';
import '../../../utils/user_new.dart';
import '../../department/dept_dashboard/modal/role_modal.dart';
import '../loginscreen/screen/login_screen.dart';
import '../qr_scanner/qr_scanner_screen.dart';
import 'candidate_attendance_screen.dart';
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
          title: const Text(
            "Dashboard",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.black),

          actions: [
            Consumer<DashboardProvider>(
              builder: (context, provider, _) {
                return PopupMenuButton<RoleData>(
                  icon: const Icon(
                    Icons.more_vert,
                    color: Colors.black,
                  ),
                  onSelected: (RoleData role) async {
                    provider.selectedRole = role;

                    provider.roleNameController.text = role.roleName ?? "";
                    provider.roleIdController.text = role.roleID?.toString() ?? "";

                    provider.notifyListeners();

                    print("Selected Role : ${role.roleName}");
                    print("Role Id : ${role.roleID}");

                    final roleID = role.roleID;
                    final officeID = role.officeID;

                    await provider.GetSSOUserDetail(
                      context,
                       switchRoleID: roleID!,
                       switchOfficeID: officeID!, // use your actual field name
                    );
                  },
                  itemBuilder: (context) {
                    return provider.roleList.asMap().entries.map((entry) {
                      final index = entry.key;
                      final role = entry.value;

                      return PopupMenuItem<RoleData>(
                        value: role,
                        padding: EdgeInsets.zero,
                        child: Column(
                          children: [
                            ListTile(
                              dense: true,
                              leading: const Icon(
                                Icons.work_outline,
                                color: Colors.blue,
                              ),
                              title: Text(
                                role.roleName ?? "",
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              // subtitle: Text(
                              //   role.officeNameEn ?? "",
                              //   maxLines: 1,
                              //   overflow: TextOverflow.ellipsis,
                              // ),
                            ),
                            if (index != provider.roleList.length - 1)
                              const Divider(height: 1),
                          ],
                        ),
                      );
                    }).toList();
                  },
                );
              },
            ),
          ],
        ),

        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                /// TOP WELCOME CARD
                _welcomeCard(),
                const SizedBox(height: 18),

                _buildRoleSection(),

                const SizedBox(height: 18),

                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    "QUICK ACTIONS",
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
                  title: "Scan QR",
                  subTitle: "Scan your event QR code for instant check-in",
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
                  title: "Event Reg. No.",
                  subTitle: "Enter your registration number to find details",
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
                  iconPath: "assets/images/mobSvg.svg",
                  title: "Mobile Number",
                  subTitle: "Look up your event pass using phone number",
                  iconBg: const Color(0xff19B9D8),
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

            /// Select Role Label
            const Padding(
              padding: EdgeInsets.only(left: 4),
              child: Text(
                "SELECT ROLE",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff7B849B),
                  letterSpacing: 0.5,
                ),
              ),
            ),

            const SizedBox(height: 10),

            /// Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xffE7EBF3)),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<RoleData>(
                  isExpanded: true,
                  value: provider.selectedRole,
                  hint: const Text(
                    "Select Role",
                    style: TextStyle(fontSize: 15),
                  ),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  items: provider.roleList.map((role) {
                    return DropdownMenuItem<RoleData>(
                      value: role,
                      child: Text(
                        role.roleName ?? "",
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (role) async {

                    if (role == null) return;

                    provider.selectedRole = role;
                    provider.notifyListeners();

                    if (role.roleID != null && role.officeID != null) {
                      await provider.GetSSOUserDetail(
                        context,
                        switchRoleID: role.roleID!,
                        switchOfficeID: role.officeID!,
                      );
                    }
                  },
                ),
              ),
            ),

            const SizedBox(height: 14),

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
                        const Expanded(
                          flex: 3,
                          child: Text(
                            "Department Name :-",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xff344054),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            UserData().model.value.departmentName ?? "",
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
                        const Expanded(
                          flex: 3,
                          child: Text(
                            "Office Name :-",
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
              showLogoutDialog(context, "Logout","Are you sure want to Logout ?", "Thank you and see you again!", (value) async {
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
              children: const [
                Text(
                  "Hello there 👋",
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff7C849B),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Welcome Back!",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: Color(0xff111827),
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Manage your events, scan QR codes,\nand stay connected.",
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

