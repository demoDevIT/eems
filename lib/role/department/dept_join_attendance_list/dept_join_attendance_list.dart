import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'modal/dept_join_attendance_modal.dart';
import 'provider/dept_join_attendance_list_provider.dart';
import '../../../../constants/colors.dart';
import '../../../../utils/textstyles.dart';

class DeptJoinAttendanceListScreen extends StatelessWidget {
  const DeptJoinAttendanceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      appBar: AppBar(
        title: const Text(
          "Attendance List for Department Joining",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Consumer<DeptJoinAttendanceListProvider>(
        builder: (context, provider, _) {
          if (provider.attendanceList.isEmpty) {
            return const Center(child: Text("No pending records"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: provider.attendanceList.length,
            itemBuilder: (context, index) {
              final item = provider.attendanceList[index];
              return _pendingCard(context, provider, item);
            },
          );
        },
      ),
    );
  }

  Widget _pendingCard(
      BuildContext context,
      DeptJoinAttendanceListProvider provider,
      DeptJoinAttendanceItem item,
      ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _row("Name", item.name),
            _row("Father Name", item.fatherName),
            _row("Date of Allotment", item.allotmentDate),
            _row("Exchange Name", item.exchangeName),

            const Divider(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // ElevatedButton.icon(
                //   onPressed: () =>
                //       provider.pickAttendanceDate(context, item),
                //   icon: const Icon(Icons.calendar_month),
                //   label: const Text("Mark Attendance"),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: Colors.green,
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                // ),

                OutlinedButton(
                  onPressed: () =>
                      provider.pickAttendanceDate(context, item),
                  child: const Text("Mark Attendance"),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              "$label:",
              style: Styles.mediumTextStyle(
                size: 14,
                color: kBlackColor,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Styles.regularTextStyle(
                size: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _iconBtn({
  //   required IconData icon,
  //   required Color color,
  //   required VoidCallback onTap,
  // }) {
  //   return IconButton(
  //     icon: Icon(icon, color: color),
  //     onPressed: onTap,
  //   );
  // }
}
