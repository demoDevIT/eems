import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../api_service/model/base/api_response.dart';
import '../../../../repo/common_repo.dart';
import '../modal/applied_job_modal.dart';

class AppliedJobsProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  AppliedJobsProvider({required this.commonRepo});

  bool isLoading = false;

  List<AppliedJobItem> appliedJobs = [];

  Future<void> getAppliedJobsApi(BuildContext context) async {
    try {
      Map<String, dynamic> body = {
        "ActionName": "",
        "Id": 0,
        "UserId": 6995,
        "JobSectorId": 0,
        "Location": "",
        "Title": ""
      };

      isLoading = true;
      notifyListeners();

      ApiResponse apiResponse = await commonRepo.post(
        "JobPost/GetAllApplyJobMatchingList",
        body,
      );

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;

        final model = AppliedJobModal.fromJson(responseData);

        appliedJobs.clear();

        if (model.state == 200 && model.data != null) {
          appliedJobs.addAll(model.data!);
        }

        isLoading = false;
        notifyListeners();
      } else {
        isLoading = false;
        notifyListeners();
      }
    } catch (e) {
      isLoading = false;
      notifyListeners();
    }
  }
}
