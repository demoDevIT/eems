import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/department/register_form/register_form.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../api_service/datasource/remote/dio/dio_client.dart';
import '../../../repo/common_repo.dart';
import '../../../utils/app_shared_prefrence.dart';
import '../../../utils/global.dart';
import '../../../utils/right_to_left_route.dart';
import '../../job_seeker/loginscreen/screen/login_screen.dart';
import '../dept_QR_scan/dept_QR_scan.dart';
import '../dept_join_attendance_list/dept_join_attendance_list.dart';
import '../dept_join_pending_list/dept_join_pending_list.dart';
import 'provider/dept_dashboard_provider.dart';

class DepartmentDashboardPage extends StatefulWidget {
  const DepartmentDashboardPage({super.key});

  @override
  State<DepartmentDashboardPage> createState() => _DepartmentDashboardPageState();
}

class _DepartmentDashboardPageState extends State<DepartmentDashboardPage> {
  //const DepartmentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Department Dashboard",
            style: TextStyle(
              color: Colors.black,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.black),
              onPressed: () {
                showLogoutDialog(
                  context,
                  "Logout",
                  "Are you sure want to Logout ?",
                  "Thank you and see you again!",
                      (value) {
                    if (value.toString() == "success") {
                      Provider.of<DepartmentDashboardProvider>(context, listen: false).reset();

                      final pref = AppSharedPref();
                      pref.save('UserData', '');
                      pref.remove('UserData');

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                          const LoginScreen(),
                        ),
                            (route) => false, // Clears all previous routes
                      );
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: Consumer<DepartmentDashboardProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// Search Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          title: "Search with Reg No.",
                          icon: Icons.search,
                          onTap: () {
                            provider.openRegSearch();
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: _actionButton(
                          title: "Scan QR Code",
                          icon: Icons.qr_code_scanner,
                          onTap: () {
                            Navigator.of(context).push(
                              RightToLeftRoute(
                                page: const DeptQRScanPage(),
                                duration: const Duration(milliseconds: 500),
                                startOffset: const Offset(-1.0, 0.0),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Reg No Search Field
                  if (provider.showRegSearch) ...[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: provider.regNoController,
                        keyboardType: TextInputType.text,
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: "Enter Registration Number",
                          prefixIcon: const Icon(Icons.badge_outlined),
                          filled: true,
                          fillColor: Colors.white,

                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 12,
                          ),

                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide.none,
                          ),

                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),

                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color: Colors.blue.shade600,
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          provider.searchByRegistration(context);
                        },
                        icon: const Icon(Icons.send, size: 18),
                        label: const Text(
                          "Submit",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade600,
                          foregroundColor: Colors.white,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    )
                  ],

                  const SizedBox(height: 20),

                  /// Result Card (Static)
                  if (provider.showResult) _resultCard(),

                  const SizedBox(height: 20),
                  // _dashboardButton(
                  //   title: "Register yourself for MYSY",
                  //  // icon: Icons.app_registration_rounded,
                  //   onTap: () => {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder: (_) => const RegisterFormScreen()
                  //       ),
                  //     ),
                  //   },
                  // ),

                  const SizedBox(height: 16),

                  _dashboardButton(
                    title: "Pending List for Department Joining",
                    // icon: Icons.pending_actions_rounded,
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DeptJoinPendingListScreen()
                        ),
                      ),
                    },
                  ),

                  const SizedBox(height: 16),

                  _dashboardButton(
                    // title: "Attendance List for Department Joining",
                    title: "Pending Attendance list for Approval",
                    // icon: Icons.pending_actions_rounded,
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const DeptJoinAttendanceListScreen()
                        ),
                      ),
                    },
                  ),
                ],
              ),
            );
          },
        ),
      );
  }

  Widget _actionButton({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        height: 55,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            colors: [
              Colors.blue.shade500,
              Colors.blue.shade700,
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _resultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: [
              Container(
                height: 50,
                width: 50,
                color: Colors.grey.shade300,
                child: const Icon(Icons.person),
              ),

              const SizedBox(width: 10),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "SHRAWAN KUMAR",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("Reg No: 22122174752"),
                  Text("Mobile: -"),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          const Text("Father Name: JEEYA RAM"),
          const Text("Designation: -"),
          const Text("Department: Revenue Department"),
          const Text("Reg No.: 22122174752"),
          const Text("Approval Date: 2025-09-19"),

          const SizedBox(height: 12),

          Row(
            children: [

              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  child: const Text("View Joining Letter"),
                ),
              ),

              const SizedBox(width: 10),

              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text("Approve Joining"),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  /// ===== Reusable Button =====
  Widget _dashboardButton({
    required String title,
   // required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        height: 60,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 0.6),
        ),
        child: Row(
          children: [
           // Icon(icon, color: kPrimaryColor),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: Styles.mediumTextStyle(
                  size: 15,
                  color: kBlackColor,
                ),
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
