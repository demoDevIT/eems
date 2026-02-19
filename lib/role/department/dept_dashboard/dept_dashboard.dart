import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/department/register_form/register_form.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../api_service/datasource/remote/dio/dio_client.dart';
import '../../../repo/common_repo.dart';
import '../dept_join_attendance_list/dept_join_attendance_list.dart';
import '../dept_join_pending_list/dept_join_pending_list.dart';
import 'provider/dept_dashboard_provider.dart';

class DepartmentDashboardPage extends StatelessWidget {
  const DepartmentDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => DepartmentDashboardProvider(
        // commonRepo: CommonRepo(
        //   dioClient: DioClient("", "", Dio()), // ✅ REQUIRED
        // ), // ✅ PASS REQUIRED ARGUMENT
      ),
      child: Scaffold(
        backgroundColor: kWhite,
        appBar: AppBar(
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
        ),
        body: Consumer<DepartmentDashboardProvider>(
          builder: (context, provider, _) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _dashboardButton(
                    title: "Register yourself for MYSY",
                   // icon: Icons.app_registration_rounded,
                    onTap: () => {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const RegisterFormScreen()
                        ),
                      ),
                    },
                  ),

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
