import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/department/register_form/register_form.dart';
import 'package:rajemployment/utils/textstyles.dart';
import '../../../api_service/datasource/remote/dio/dio_client.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repo/common_repo.dart';
import '../../../utils/app_shared_prefrence.dart';
import '../../../utils/global.dart';
import '../../../utils/language_toggle_switch.dart';
import '../../../utils/right_to_left_route.dart';
import '../../../utils/user_new.dart';
import '../../job_seeker/loginscreen/screen/login_screen.dart';
import '../dept_QR_scan/dept_QR_scan.dart';
import '../dept_join_attendance_list/dept_join_attendance_list.dart';
import '../dept_join_pending_list/dept_join_pending_list.dart';
import '../dept_profile/dept_profile.dart';
import '../request_map/request_map.dart';
import 'modal/role_modal.dart';
import 'provider/dept_dashboard_provider.dart';

class DepartmentDashboardPage extends StatefulWidget {
  const DepartmentDashboardPage({super.key});

  @override
  State<DepartmentDashboardPage> createState() =>
      _DepartmentDashboardPageState();
}

class _DepartmentDashboardPageState extends State<DepartmentDashboardPage> {
  //const DepartmentDashboardPage({super.key});

  int _selectedOverviewTab = 0;

  @override
  void initState() {
    super.initState();

    print("========== deptttt DASHBOARD USER DATA ==========");
    print(const JsonEncoder.withIndent('  ')
        .convert(UserData().model.value.toJson()));
    print("========================================");

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // context.read<DepartmentDashboardProvider>().getRoleApi(context, "");
      final provider = context.read<DepartmentDashboardProvider>();
      provider.getRoleApi(context, "");
      provider.clearData();

      provider.getJoiningOverview(context);

      // provider.getJoiningOverview(context);
      // provider.getAttendanceOverview(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildSideDrawer(),
      backgroundColor: kWhite,
      appBar: AppBar(
        //automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          AppLocalizations.of(context)!.dashboard, //"Dashboard",
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Consumer<DepartmentDashboardProvider>(
            builder: (context, provider, _) {
              return PopupMenuButton<RoleData>(
                offset: const Offset(0, 10),
                // opens below button
                position: PopupMenuPosition.under,
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width * 0.95,
                  maxWidth: MediaQuery.of(context).size.width * 0.95,
                ),
                child: Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
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
                      SizedBox(width: 6),
                      Text(
                        AppLocalizations.of(context)!.role, //"Role",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 4),
                      Icon(Icons.keyboard_arrow_down, color: Colors.white),
                    ],
                  ),
                ),
                onSelected: (RoleData role) async {
                  provider.selectedRole = role;

                  provider.roleNameController.text = role.roleName ?? "";
                  provider.roleIdController.text =
                      role.roleID?.toString() ?? "";

                  provider.notifyListeners();

                  print("dept dashboard Selected Role : ${role.roleName}");
                  print("Role Id : ${role.roleID}");

                  final roleID = role.roleID;
                  final officeID = role.officeID;
                  final internDeptTypeID = role.internshipDeptTypeID;
                  final internDeptID = role.internshipDeptID;

                  await provider.GetSSOUserDetail(
                    context,
                    switchRoleID: roleID!,
                    switchOfficeID: officeID!,
                    // use your actual field name
                    intDeptTypeID: internDeptTypeID!,
                    // use your actual field name
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
                            role.internshipDeptID ==
                                UserData().model.value.internshipDeptID;

                    return PopupMenuItem<RoleData>(
                      value: role,
                      padding: EdgeInsets.zero,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected ? Colors.blue.shade50 : Colors.white,
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
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 15,
                                    ),
                                  ),
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
            padding: const EdgeInsets.only(right: 8),
            child: SizedBox(
              width: 80,
              child: LanguageToggleSwitch(),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(right: 8),
          //   child: _languageButton(context),
          // ),
        ],
      ),
      body: Consumer<DepartmentDashboardProvider>(
        builder: (context, provider, _) {
          return SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildRoleSection(),

                  const SizedBox(height: 18),

                  /// Search Buttons
                  Row(
                    children: [
                      Expanded(
                        child: _actionButton(
                          title: AppLocalizations.of(context)!.searchRegNo,
                          //"Search with Reg No.",
                          icon: Icons.search,
                          onTap: () {
                            provider.openRegSearch();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _actionButton(
                          title: AppLocalizations.of(context)!.scanQRCode,
                          //"Scan QR Code",
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
                          hintText: AppLocalizations.of(context)!.enterRegNo,
                          //"Enter Registration Number",
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
                        label: Text(
                          AppLocalizations.of(context)!.submit,
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

                  // const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: _dashboardCard(
                          title: AppLocalizations.of(context)!.internJoin,
                          iconPath: "assets/images/internshipImg.png",
                          borderColor: const Color(0xff7B61FF),
                          bgColor: const Color(0xffF5F3FF),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const DeptJoinPendingListScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: _dashboardCard(
                          title: AppLocalizations.of(context)!.internAttend,
                          iconPath: "assets/images/attendanceImg.png",
                          borderColor: const Color(0xff22C55E),
                          bgColor: const Color(0xffECFDF5),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    const DeptJoinAttendanceListScreen(),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),


                  const SizedBox(height: 16),
                  _buildJoiningAttendanceOverview(),
                  const SizedBox(height: 20),

                  // const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.orange,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      AppLocalizations.of(context)!.forAnyQuery,
                      //"For any queries related to Internship Joining, Attendance, or E-Sign, please contact your concerned District Employment Officer for assistance.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildJoiningAttendanceOverview() {
    return Column(
      children: [
        _buildOverviewTabs(),
        const SizedBox(height: 18),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: _selectedOverviewTab == 0
              ? _buildJoiningOverview()
              : _buildAttendanceOverview(),
        ),
      ],
    );
  }

  Widget _buildOverviewTabs() {
    return Container(
      height: 50,
      // padding: const EdgeInsets.all(5),
      padding: const EdgeInsets.symmetric(
        horizontal: 2,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: const Color(0xffF5F7FC),
        borderRadius: BorderRadius.circular(7),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildOverviewTab(
              title: "Joining",
              icon: Icons.person_outline,
              index: 0,
            ),
          ),
          Expanded(
            child: _buildOverviewTab(
              title: "Attendance",
              icon: Icons.verified_user_outlined,
              index: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewTab({
    required String title,
    required IconData icon,
    required int index,
  }) {
    final bool selected = _selectedOverviewTab == index;

    return GestureDetector(
      onTap: () async {
        if (_selectedOverviewTab == index) {
          return;
        }

        setState(() {
          _selectedOverviewTab = index;
        });

        final provider = context.read<DepartmentDashboardProvider>();

        if (index == 0) {
          // Joining tab
          await provider.getJoiningOverview(context);
        } else if (index == 1) {
          // Attendance tab
          await provider.getAttendanceOverview(context);
        }
      },
      // child: AnimatedContainer(
      child: Container(
      // duration: const Duration(milliseconds: 200),
         width: double.infinity,
         height: double.infinity,
        // alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xff4A5BE8) : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? Colors.white : const Color(0xff4A5BE8),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                color: selected ? Colors.white : const Color(0xff4A5BE8),
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJoiningOverview() {
    return Consumer<DepartmentDashboardProvider>(
      builder: (context, provider, _) {
        if (provider.isJoiningOverviewLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final total = provider.joiningTotal;
        final completed = provider.joiningCompleted;
        final pending = provider.joiningPending;

        final percentage = provider.joiningCompletionPercentageText;

        return Column(
          key: const ValueKey("joining"),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xffE2F0FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.badge_outlined,
                    color: Color(0xff1683FF),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Joining Overview",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff152238),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Internship Joining",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff718096),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),

            _buildJoiningMainCard(),

            const SizedBox(height: 14),

            _buildStatusCard(
              icon: Icons.check,
              iconBackground: const Color(0xffD5F7E1),
              iconColor: const Color(0xff00A65A),
              title: "JOINING COMPLETED",
              value: completed.toString(),
              subtitle: "Applications successfully joined",
              percentage: percentage,
              percentageColor: const Color(0xff00A65A),
            ),

            const SizedBox(height: 12),

            _buildStatusCard(
              icon: Icons.access_time,
              iconBackground: const Color(0xfffff0ce),
              iconColor: const Color(0xffff9800),
              title: "JOINING PENDING",
              value: pending.toString(),
              subtitle: "Applications waiting for joining",
              percentage: total == 0
                  ? "0%"
                  : "${((pending / total) * 100).round()}%",
              percentageColor: const Color(0xffff9800),
            ),

            const SizedBox(height: 14),

            _buildOverallCompletion(),
          ],
        );
      },
    );
  }

  Widget _buildJoiningMainCard() {
    return Consumer<DepartmentDashboardProvider>(
      builder: (context, provider, _) {
        final total = provider.joiningTotal;
        final completed = provider.joiningCompleted;
        final pending = provider.joiningPending;

        final completion = provider.joiningCompletionPercentage;
        final percentage = provider.joiningCompletionPercentageText;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: const Color(0xffD7E1F0),
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 145,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 115,
                      height: 115,
                      child: CircularProgressIndicator(
                        value: completion,
                        strokeWidth: 13,
                        backgroundColor: const Color(0xffF0F3FA),
                        valueColor:
                        const AlwaysStoppedAnimation<Color>(
                          Color(0xff00A65A),
                        ),
                      ),
                    ),

                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Total",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xff718096),
                          ),
                        ),

                        Text(
                          total.toString(),
                          style: const TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff152238),
                          ),
                        ),

                        const Text(
                          "Applications",
                          style: TextStyle(
                            fontSize: 11,
                            color: Color(0xff718096),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xffD5F7E1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "✓ $percentage Completed",
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff00A65A),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _buildJoiningSummaryBox(
                      title: "COMPLETED",
                      value: completed.toString(),
                      percentage: total == 0
                          ? "0%"
                          : "${((completed / total) * 100).round()}%",
                      backgroundColor:
                      const Color(0xffD5F7E1),
                      percentageColor:
                      const Color(0xff00A65A),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: _buildJoiningSummaryBox(
                      title: "PENDING",
                      value: pending.toString(),
                      percentage: total == 0
                          ? "0%"
                          : "${((pending / total) * 100).round()}%",
                      backgroundColor:
                      const Color(0xfffff0ce),
                      percentageColor:
                      const Color(0xffff9800),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildJoiningSummaryBox({
    required String title,
    required String value,
    required String percentage,
    required Color backgroundColor,
    required Color percentageColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xff667085),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff152238),
                ),
              ),
              Text(
                percentage,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: percentageColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required Color iconBackground,
    required Color iconColor,
    required String title,
    required String value,
    required String subtitle,
    required String percentage,
    required Color percentageColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xffD7E1F0),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: iconBackground,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff667085),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff152238),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          subtitle,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Color(0xff718096),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            percentage,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: percentageColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallCompletion() {
    return Consumer<DepartmentDashboardProvider>(
      builder: (context, provider, _) {
        final completed = provider.joiningCompleted;
        final pending = provider.joiningPending;
        final percentage = provider.joiningCompletionPercentage;
        final percentageText =
            provider.joiningCompletionPercentageText;

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xffDCEEFF),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color(0xffA8D1FF),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "OVERALL COMPLETION",
                          style: TextStyle(
                            fontSize: 10,
                            color: Color(0xff667085),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          percentageText,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff1683FF),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 42,
                    height: 42,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.trending_up,
                      color: Color(0xff1683FF),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: percentage,
                  minHeight: 8,
                  backgroundColor:
                  const Color(0xffC6DDF5),
                  valueColor:
                  const AlwaysStoppedAnimation<Color>(
                    Color(0xff1683FF),
                  ),
                ),
              ),

              const SizedBox(height: 8),

              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.circle,
                        size: 8,
                        color: Color(0xff00A65A),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "$completed Completed",
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xff667085),
                        ),
                      ),
                    ],
                  ),

                  Text(
                    "$pending Pending",
                    style: const TextStyle(
                      fontSize: 10,
                      color: Color(0xff667085),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildAttendanceOverview() {
    return Consumer<DepartmentDashboardProvider>(
      builder: (context, provider, _) {
        if (provider.isAttendanceOverviewLoading) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(30),
              child: CircularProgressIndicator(),
            ),
          );
        }

        final verified = provider.attendanceVerified;
        final submitted = provider.attendanceSubmitted;
        final sendback = provider.attendanceSendback;
        final pending = provider.attendancePending;
        final total = provider.attendanceTotalApplications;

        return Column(
          key: const ValueKey("attendance"),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    color: Color(0xffE2F0FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.badge_outlined,
                    color: Color(0xff1683FF),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: const [
                    Text(
                      "Attendance Overview",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xff152238),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Monthly attendance completion & pending progress",
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xff718096),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 18),

            /// YEAR + MONTH
            Row(
              children: [
                Expanded(
                  child: _buildDropdownBox(
                    title: "YEAR",
                    value: "2026",
                    onTap: () {
                      // Year selection can be implemented later.
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildAttendanceMonthDropdown(
                    provider,
                    context,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// VERIFIED + SUBMITTED
            Row(
              children: [
                Expanded(
                  child: _buildAttendanceCountCard(
                    title: "Verified",
                    value: verified.toString(),
                    icon: Icons.badge_outlined,
                    backgroundColor:
                    const Color(0xffDDF2FF),
                    color: const Color(0xff1683FF),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildAttendanceCountCard(
                    title: "Submitted",
                    value: submitted.toString(),
                    icon: Icons.check,
                    backgroundColor:
                    const Color(0xffD7F7E2),
                    color: const Color(0xff00A65A),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            /// SENDBACK + PENDING
            Row(
              children: [
                Expanded(
                  child: _buildAttendanceCountCard(
                    title: "Sendback",
                    value: sendback.toString(),
                    icon: Icons.undo,
                    backgroundColor:
                    const Color(0xffF0E5FF),
                    color: const Color(0xff8B5CF6),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _buildAttendanceCountCard(
                    title: "Pending",
                    value: pending.toString(),
                    icon: Icons.access_time,
                    backgroundColor:
                    const Color(0xfffff0ce),
                    color: const Color(0xffff9800),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            /// TOTAL APPLICATIONS
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 16,
                horizontal: 14,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xffD7E1F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.03),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xffE2F0FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: Color(0xff1683FF),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _AttendanceBottomValue(
                      value: total.toString(),
                      label: "Total Applications",
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

  Widget _buildAttendanceMonthDropdown(
      DepartmentDashboardProvider provider,
      BuildContext context,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "MONTH",
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Color(0xff667085),
          ),
        ),
        const SizedBox(height: 6),

        Container(
          height: 44,
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: const Color(0xffD7E1F0),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              isExpanded: true,
              value: provider.selectedAttendanceMonth,
              icon: const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Color(0xff667085),
              ),
              items: provider.attendanceMonths
                  .map(
                    (month) => DropdownMenuItem<String>(
                  value: month,
                  child: Text(
                    month,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff152238),
                    ),
                  ),
                ),
              )
                  .toList(),
              onChanged: (value) async {
                if (value == null) return;

                await provider.selectAttendanceMonth(
                  context,
                  value,
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDropdownBox({
    required String title,
    required String value,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: Color(0xff667085),
          ),
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xffD7E1F0),
              ),
            ),
            child: Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff152238),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  size: 20,
                  color: Color(0xff667085),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAttendanceCountCard({
    required String title,
    required String value,
    required IconData icon,
    required Color backgroundColor,
    required Color color,
  }) {
    return Container(
      height: 90,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: color.withOpacity(0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
                color: color,
              ),
              const SizedBox(width: 7),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xff152238),
            ),
          ),
        ],
      ),
    );
  }

  Widget _languageButton(BuildContext context) {
    final isHindi = Localizations.localeOf(context).languageCode == 'hi';

    return InkWell(
      onTap: () {
        // Call your existing language change logic here
      },
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.blue,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'A',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: !isHindi ? Colors.blue : Colors.grey,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                '/',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),
            Text(
              'अ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: isHindi ? Colors.blue : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleSection() {
    return Consumer<DepartmentDashboardProvider>(
      builder: (context, provider, _) {
        final officeName = UserData().model.value.roleId == 22
            ? "${UserData().model.value.office ?? ""} "
                "${UserData().model.value.deptNameEn ?? ""}"
            : (UserData().model.value.exchangeName ?? "");
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //
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
                            AppLocalizations.of(context)!.role + " :-",
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
                            AppLocalizations.of(context)!.officeName + " :-",
                            //"Office Name :-",
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Color(0xff344054),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 5,
                            child: Text(
                              officeName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            )),
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
    return Drawer(
      child: ListView(
        children: [
          // ===== Header =====
          Container(
            padding:
                const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 20),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    ClipOval(
                      child: Image.network(
                        UserData().model.value.latestPhotoPath.toString(),
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/placeholder.png',
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          );
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          UserData().model.value.name.toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DeptProfileScreen(isAppBarHide: true),
                              ),
                            );
                          },
                          child: Text(
                            AppLocalizations.of(context)!.updateProfile,
                            //"Update Profile",
                            style: TextStyle(
                              fontSize: 14,
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
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: Text(AppLocalizations.of(context)!.dashboard,
                style: TextStyle(fontSize: 14)),
            onTap: () {
              Navigator.pop(context); // Already on dashboard
            },
          ),
          ListTile(
            leading: const Icon(Icons.request_page),
            title: Text(AppLocalizations.of(context)!.requestDMap,
                style: TextStyle(fontSize: 14)),
            // onTap: () {
            //   Navigator.pop(context); // Already on dashboard
            // },
            onTap: () async {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RequestMapScreen(),
                ),
              );
            },
          ),
          Container(
            margin: const EdgeInsets.only(left: 50),
            child: const Divider(height: 1, color: E3E5F9Color),
          ),

          // ===== Logout =====
          ListTile(
            leading: SvgPicture.asset(
              'assets/icons/logout.svg',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
            title: Text(
              AppLocalizations.of(context)!.logout,
              style: Styles.mediumTextStyle(size: 14),
            ),
            onTap: () async {
              Navigator.pop(context); // Close the drawer
              showLogoutDialog(
                context,
                AppLocalizations.of(context)!.logout,
                AppLocalizations.of(context)!.logoutConfirmMsg,
                AppLocalizations.of(context)!.logoutThankYouText,
                (value) async {
                  if (value.toString() == "success") {
                    final pref = AppSharedPref();

                    // final commonRepo = Provider.of<CommonRepo>(context, listen: false);
                    // commonRepo.dioClient.clearAuthToken();

                    // Clear login session only
                    UserData().model.value.isLogin = false;
                    UserData().model.value.userId = null;
                    // UserData().model.value.postalAddress = null;
                    // UserData().model.value.empNumber = null;
                    await pref.remove('UserData');
                    print(
                        "========== AFTER LOGOUT COMPLETE USER MODEL ==========");
                    print(
                      const JsonEncoder.withIndent('  ')
                          .convert(UserData().model.value.toJson()),
                    );
                    print("=========================================");

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
        ],
      ),
    );
  }

  Widget _dashboardCard({
    required String title,
    required String iconPath,
    required Color borderColor,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        height: 170,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: borderColor,
            width: 1.3,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconPath,
              width: 70,
              height: 70,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
                height: 1.3,
              ),
            ),
          ],
        ),
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

class _AttendanceBottomValue extends StatelessWidget {
  final String value;
  final String label;

  const _AttendanceBottomValue({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xff152238),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              color: Color(0xff718096),
            ),
          ),
        ],
      ),
    );
  }
}
