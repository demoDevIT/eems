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
                        child: ElevatedButton(
                          onPressed: () {
                            provider.openRegSearch();
                          },
                          child: const Text("Search with Reg No."),
                        ),
                      ),

                      const SizedBox(width: 10),

                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              RightToLeftRoute(
                                page: const DeptQRScanPage(), // your new page
                                duration: const Duration(milliseconds: 500),
                                startOffset: const Offset(-1.0, 0.0),
                              ),
                            );
                          },
                          child: const Text("Search with QR Code"),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  /// Reg No Search Field
                  if (provider.showRegSearch) ...[
                    TextField(
                      controller: provider.regNoController,
                      decoration: const InputDecoration(
                        hintText: "Enter Registration Number",
                        border: OutlineInputBorder(),
                      ),
                    ),

                    const SizedBox(height: 10),

                    ElevatedButton(
                      onPressed: () {
                        provider.searchByRegistration(context);
                      },
                      child: const Text("Submit"),
                    ),
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
