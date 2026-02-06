import 'package:flutter/material.dart';

import '../../../../repo/common_repo.dart';
import '../modal/dept_join_pending_modal.dart';

class DeptJoinPendingListProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  DeptJoinPendingListProvider({required this.commonRepo});

  /// 🔹 Temporary dummy data
  final List<DeptJoinPendingItem> pendingList = [
    DeptJoinPendingItem(
      name: "Rahul Sharma",
      fatherName: "Ramesh Sharma",
      allotmentDate: "12-01-2024",
      exchangeName: "Jaipur Exchange",
    ),
    DeptJoinPendingItem(
      name: "Amit Verma",
      fatherName: "Suresh Verma",
      allotmentDate: "18-01-2024",
      exchangeName: "Jodhpur Exchange",
    ),
  ];

  void onApproveJoining(BuildContext context, DeptJoinPendingItem item) {
    debugPrint(
      "Approve Joining clicked for ${item.name}",
    );

    // 🔜 Future API call
    // approveJoiningApi(item.id);
  }

  void onViewJoiningLetter(BuildContext context, DeptJoinPendingItem item) {
    debugPrint(
      "View Joining Letter for ${item.name}",
    );

    // 🔜 Future:
    // open PDF / WebView
  }

  void onESign(BuildContext context, DeptJoinPendingItem item) {
    debugPrint(
      "E-Sign clicked for ${item.name}",
    );

    // 🔜 Future:
    // redirect to e-sign flow
  }

}
