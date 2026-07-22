import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/role/job_seeker/mysy/payment_logs.dart';
import '../../../constants/constants.dart';
import 'allot_dept_mysy.dart';
import 'attendance_logs.dart';
import 'document_logs.dart';
import 'join_logs.dart';
import 'msg_logs.dart';
import 'provider/mysy_list_provider.dart';

class MysyListScreen extends StatefulWidget {
  const MysyListScreen({super.key});

  @override
  State<MysyListScreen> createState() => _MysyListScreenState();
}

class _MysyListScreenState extends State<MysyListScreen> {

  @override
  void initState() {
    Future.microtask(() {
      Provider.of<MysyListProvider>(context, listen: false)
          .getMysyListApi(context); // loggedInUserId
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MysyListProvider>(
      builder: (context, provider, _) {
        return Scaffold(
          backgroundColor: const Color(0xfff5f6fa),
          appBar: AppBar(
            title: const Text("MYSY List"),
            backgroundColor: Colors.white,
            elevation: 0,
            foregroundColor: Colors.black,
          ),
          body: provider.isLoading
              ? const Center(
            child: CircularProgressIndicator(),
          )
              : Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                /// ===========================
                /// HEADING WITH COUNT
                /// ===========================
                // Text(
                //   "MYSY Application List (${provider.mysyList.length})",
                //   style: const TextStyle(
                //       fontSize: 18,
                //       fontWeight: FontWeight.bold),
                // ),
                //
                // const SizedBox(height: 20),

                /// ===========================
                /// LIST VIEW
                /// ===========================
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.mysyList.length,
                    itemBuilder: (context, index) {
                      final item = provider.mysyList[index];
                      final info = item.applicationInfo!;

                      // return Container(
                      //   margin: const EdgeInsets.only(bottom: 12),
                      //   padding: const EdgeInsets.all(14),
                      //   decoration: BoxDecoration(
                      //     color: Colors.white,
                      //     borderRadius: BorderRadius.circular(12),
                      //     border: Border.all(color: Colors.grey.shade300),
                      //   ),
                      //   child: Column(
                      //     crossAxisAlignment:
                      //     CrossAxisAlignment.start,
                      //     children: [
                      //
                      //       _row("Applicant Name", info.fullName ?? ""),
                      //       _row("Father Name", info.fatherName ?? ""),
                      //       _row("Date of Birth", info.dob ?? ""),
                      //       _row("Mobile", info.mobileNo ?? ""),
                      //       _row("Registration Number", info.applicationNo ?? ""),
                      //       _row("RegistrationDate", info.regDate ?? ""),
                      //       _row("Gender", info.gender ?? ""),
                      //       _row("Category", info.category ?? ""),
                      //       _row("Scheme", info.schemeName ?? ""),
                      //       _row("Apply Date", info.applyDate ?? ""),
                      //       _row("Approve Date", info.approveDate ?? ""),
                      //       _row("Stopped Date", info.stopDate ?? ""),
                      //
                      //       const SizedBox(height: 8),
                      //
                      //       /// Status Badge
                      //       // Container(
                      //       //   padding: const EdgeInsets.symmetric(
                      //       //       horizontal: 10, vertical: 6),
                      //       //   decoration: BoxDecoration(
                      //       //     color: item.schemeStatus == "Approved"
                      //       //         ? Colors.green.shade100
                      //       //         : item.schemeStatus == "Hold"
                      //       //         ? Colors.orange.shade100
                      //       //         : Colors.blue.shade100,
                      //       //     borderRadius:
                      //       //     BorderRadius.circular(6),
                      //       //   ),
                      //       //   child: Text(
                      //       //     item.schemeStatus ?? "",
                      //       //     style: TextStyle(
                      //       //       color: item.schemeStatus == "Approved"
                      //       //           ? Colors.green
                      //       //           : item.schemeStatus == "Hold"
                      //       //           ? Colors.orange
                      //       //           : Colors.blue,
                      //       //       fontWeight:
                      //       //       FontWeight.w500,
                      //       //     ),
                      //       //   ),
                      //       // ),
                      //
                      //       const SizedBox(height: 15),
                      //
                      //   _buildButton(
                      //     "View Allotted Department",
                      //         () {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (_) => AllotDeptMysy(
                      //             data: item.allottedDepartments,
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      //
                      //   _buildButton(
                      //     "View Message Log",
                      //         () {
                      //       Navigator.push(
                      //         context,
                      //         MaterialPageRoute(
                      //           builder: (_) => MsgLogs(
                      //             data: item.messageLogs,
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                      //
                      //   _buildButton(
                      //   "View Joining Log",
                      //       () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (_) => JoinLogs(
                      //           data: item.joiningLogs,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                      //
                      // _buildButton(
                      //   "View Attendance Log",
                      //       () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (_) => AttendanceLogs(
                      //           data: item.attendanceLogs,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                      //
                      // _buildButton(
                      //   "View Document Log",
                      //       () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (_) => DocumentLogs(
                      //           data: item.documentLogs,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // ),
                      //
                      // _buildButton(
                      //   "View Payment Log",
                      //       () {
                      //     Navigator.push(
                      //       context,
                      //       MaterialPageRoute(
                      //         builder: (_) => PaymentLogs(
                      //           data: item.paymentLogs,
                      //         ),
                      //       ),
                      //     );
                      //   },
                      // )
                      //
                      //     ],
                      //   ),
                      // );

                      return Card(
                        elevation: 4,
                        margin: const EdgeInsets.only(bottom: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Column(
                          children: [

                            /// Header
                            Container(
                              padding: const EdgeInsets.all(16),
                              decoration: const BoxDecoration(
                                color: Color(0xff4F46E5),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(18),
                                  topRight: Radius.circular(18),
                                ),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.white,
                                    backgroundImage: (info.latestPhoto != null &&
                                        info.latestPhoto!.isNotEmpty)
                                        ? NetworkImage(
                                      Constants.showPdfUrl + info.latestPhoto!,
                                    )
                                        : null,
                                    child: (info.latestPhoto == null ||
                                        info.latestPhoto!.isEmpty)
                                        ? const Icon(
                                      Icons.person,
                                      color: Color(0xff4F46E5),
                                    )
                                        : null,
                                  ),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          info.fullName ?? "",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 17,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        Text(
                                          info.applicationNo ?? "",
                                          style: const TextStyle(
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [

                                  _row("Father Name",
                                      info.fatherName ?? ""),
                                  _row("Mobile",
                                      info.mobileNo ?? ""),
                                  _row("DOB", info.dob ?? ""),
                                  _row("Registration Date",
                                      info.regDate ?? ""),
                                  _row("Gender",
                                      info.gender ?? ""),
                                  _row("Category",
                                      info.category ?? ""),
                                  _row("Scheme",
                                      info.schemeName ?? ""),
                                  _row("Apply Date",
                                      info.applyDate ?? ""),
                                  _row("Approve Date",
                                      info.approveDate ?? ""),
                                  _row("Stopped Date",
                                      info.stopDate ?? ""),

                                  const SizedBox(height: 15),

                                  // Wrap(
                                  //   spacing: 8,
                                  //   children: [
                                  //     Chip(
                                  //       label:
                                  //       Text(info.gender ?? ""),
                                  //     ),
                                  //     Chip(
                                  //       label:
                                  //       Text(info.category ?? ""),
                                  //     ),
                                  //   ],
                                  // ),
                                  //
                                  // const SizedBox(height: 20),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: _actionButton(
                                          Icons.apartment,
                                          "Alloted Department",
                                              () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    AllotDeptMysy(
                                                      data: item
                                                          .allottedDepartments,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: _actionButton(
                                          Icons.message,
                                          "Message Logs",
                                              () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => MsgLogs(
                                                              data: item.messageLogs,
                                                            ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _actionButton(
                                          Icons.apartment,
                                          "Joining Logs",
                                              () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    JoinLogs(
                                                      data: item
                                                          .joiningLogs,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: _actionButton(
                                          Icons.message,
                                          "Attendance Log",
                                              () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => AttendanceLogs(
                                                  data: item.attendanceLogs,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _actionButton(
                                          Icons.apartment,
                                          "Document Log",
                                              () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) =>
                                                    DocumentLogs(
                                                      data: item
                                                          .documentLogs,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: _actionButton(
                                          Icons.message,
                                          "Payment Log",
                                              () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (_) => PaymentLogs(
                                                  data: item.paymentLogs,
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _actionButton(
      IconData icon,
      String title,
      VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
     // icon: Icon(icon, size: 18),
      label: Text(title),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius:
          BorderRadius.circular(12),
        ),
        padding:
        const EdgeInsets.symmetric(
          vertical: 14,
        ),
      ),
    );
  }

  Widget _buildButton(
      String title,
      VoidCallback onTap,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: onTap,
          child: Text(title),
        ),
      ),
    );
  }

  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              "$title:",
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style:
              const TextStyle(fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
