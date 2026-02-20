import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../repo/common_repo.dart';
import '../modal/self_assessment_modal.dart';

class SelfAssessmentProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  SelfAssessmentProvider({required this.commonRepo});

  bool isAssessmentLoading = false;

  List<AssessmentData> selfAssessmentList = [];
  List<AssessmentData> psychometricList = [];

  Future<void> getAssessmentListApi(BuildContext context, int jobSeekerId) async {
    isAssessmentLoading = true;
    notifyListeners();

    try {
      final apiResponse = await commonRepo
          .get("Assessment/GetAssessmentListJobSeeker/$jobSeekerId");

      if (apiResponse.response?.statusCode == 200) {
        dynamic responseData = apiResponse.response!.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        AssessmentListModal modal =
        AssessmentListModal.fromJson(responseData);

        selfAssessmentList.clear();
        psychometricList.clear();

        if (modal.data != null) {
          for (var item in modal.data!) {
            if (item.assessmentTypeId == 1) {
              selfAssessmentList.add(item);
            } else if (item.assessmentTypeId == 2) {
              psychometricList.add(item);
            }
          }
        }
      }
    } catch (e) {
      selfAssessmentList.clear();
      psychometricList.clear();
    }

    isAssessmentLoading = false;
    notifyListeners();
  }

  void clearData() {

    notifyListeners();
  }

}
