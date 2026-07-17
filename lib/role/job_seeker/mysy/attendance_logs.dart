import 'package:flutter/material.dart';
import 'package:rajemployment/role/job_seeker/mysy/provider/attendance_log_provider.dart';

import '../../../constants/constants.dart';
import 'modal/mysy_list_model.dart';
import 'package:provider/provider.dart';

class AttendanceLogs extends StatelessWidget {
  final List<AttendanceLog> data;

  const AttendanceLogs({
    super.key,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AttendanceLogProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("Attendance Logs"),
            ),
            body: data.isEmpty
                ? const Center(
              child: Text(
                "No Data Found",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          : ListView.builder(
        padding: const EdgeInsets.all(15),
        itemCount: data.length,
        itemBuilder: (_, index) {
          final item = data[index];

          return Card(
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  _row("Sr. No.", "${index + 1}"),
                  _row(
                    "Joining Date",
                    item.joiningDate ?? "",
                  ),
                  _row(
                    "Attendance Status",
                    item.currentStatus ?? "",
                  ),
                  _row(
                    "Attendance Month/Year",
                    item.attendanceMonthYear ?? "",
                  ),
                  _row(
                    "Remarks",
                    item.remarks ?? "",
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 150,
                          child: Text(
                            "Last Uploaded Letter :",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: (item.lastUploadedLetter != null &&
                                item.lastUploadedLetter!.isNotEmpty)
                                ? Colors.blue
                                : Colors.grey,
                          ),
                          onPressed: (item.lastUploadedLetter != null &&
                              item.lastUploadedLetter!.isNotEmpty)
                              ? () {
                            provider.downloadAndOpenPdf(
                              Constants.showPdfUrl +
                                  item.lastUploadedLetter!,
                            );
                          }
                              : null,
                        ),
                      ],
                    ),
                  ),
                  _row(
                    "Attendance Action Date & Time",
                    item.actionDate ?? "",
                  ),
                ],
              ),
            ),
          );
        },
      ),
          );
        },
    );
  }
  Widget _row(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(
              "$title :",
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }
}