import 'package:flutter/material.dart';

import '../../../../repo/common_repo.dart';
import '../modal/dept_join_attendance_modal.dart';

class DeptJoinAttendanceListProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  DeptJoinAttendanceListProvider({required this.commonRepo});

  /// 🔹 Temporary dummy data
  final List<DeptJoinAttendanceItem> attendanceList = [
    DeptJoinAttendanceItem(
      name: "Rahul Sharma",
      fatherName: "Ramesh Sharma",
      allotmentDate: "12-01-2024",
      exchangeName: "Jaipur Exchange",
    ),
    DeptJoinAttendanceItem(
      name: "Amit Verma",
      fatherName: "Suresh Verma",
      allotmentDate: "18-01-2024",
      exchangeName: "Jodhpur Exchange",
    ),
  ];

  void markAttendance(DeptJoinAttendanceItem item) {
    debugPrint("Mark attendance for: ${item.name}");
    // TODO: API call for marking attendance
  }

  Future<void> pickAttendanceDate(
      BuildContext context,
      DeptJoinAttendanceItem item,
      ) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      debugPrint(
        "Attendance marked for ${item.name} on ${pickedDate.toIso8601String()}",
      );
    }
  }

}
