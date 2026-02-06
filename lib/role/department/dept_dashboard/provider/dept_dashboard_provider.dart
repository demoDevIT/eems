import 'package:flutter/material.dart';

import '../../../../repo/common_repo.dart';

class DepartmentDashboardProvider extends ChangeNotifier {
  // final CommonRepo commonRepo;
  // DepartmentDashboardProvider({required this.commonRepo});
  /// Future use:
  /// - API calls
  /// - Navigation logic
  /// - Badge counts (pending list count)

  void onRegisterMYSY(BuildContext context) {
    debugPrint("Register yourself for MYSY clicked");
    // TODO: Navigate to MYSY registration page
  }

  void onPendingDepartmentJoining(BuildContext context) {
    debugPrint("Pending list for department joining clicked");
    // TODO: Navigate to pending list page
  }
}
