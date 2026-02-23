import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../api_service/model/base/api_response.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../repo/common_repo.dart';
import '../../../../utils/global.dart';
import '../../../../utils/progress_dialog.dart';
import '../../../../utils/user_new.dart';
import '../../../../utils/utility_class.dart';
import '../modal/assessment_question.dart';
import '../modal/correct_save_answers_modal.dart';

class AssessmentTestProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  AssessmentTestProvider({required this.commonRepo});

  bool isLoading = false;

  List<AssessmentQuestion> questionList = [];
  Map<int, List<AssessmentQuestion>> questionsByCategory = {};

  int selectedCategoryId = 0;
  int currentQuestionIndex = 0;

  Map<int, int> selectedAnswers = {};
  // questionId -> optionId

  int totalMinutes = 0;
  int remainingSeconds = 0;

  Timer? timer;

  int getAttemptedCountForCategory(int categoryId) {
    if (!questionsByCategory.containsKey(categoryId)) {
      return 0;
    }

    int count = 0;

    for (var q in questionsByCategory[categoryId]!) {
      if (selectedAnswers.containsKey(q.id)) {
        count++;
      }
    }

    return count;
  }


  int getAttemptedCountForCurrentCategory() {
    return getAttemptedCountForCategory(selectedCategoryId);
  }

  AssessmentQuestion? getQuestionById(int questionId) {
    for (var list in questionsByCategory.values) {
      for (var q in list) {
        if (q.id == questionId) {
          return q;
        }
      }
    }
    return null;
  }

  int attemptId = 0;

  /// Store API result sections
  List<dynamic> resultData = [];

  Future<void> loadQuestions(int categoryId, int assessmentTypeId) async {
    try {
      selectedCategoryId = categoryId;
      currentQuestionIndex = 0;

      // If already loaded, don't call API again
      if (questionsByCategory.containsKey(categoryId)) {
        questionList = questionsByCategory[categoryId]!;
        notifyListeners();
        return;
      }

      questionList = [];
      notifyListeners();

      final apiResponse = await commonRepo.get(
          "Assessment/GetJobseekerAssessmentTestQuestion/$categoryId");

      if (apiResponse.response?.statusCode == 200) {
        dynamic data = apiResponse.response!.data;

        if (data is String) {
          data = jsonDecode(data);
        }

        List<AssessmentQuestion> loadedQuestions = [];

        if (data['Data'] != null) {
          for (var e in data['Data']) {
            AssessmentQuestion question =
            AssessmentQuestion.fromJson(e);

            question.sectionId = categoryId;
            question.assessmentTypeId = assessmentTypeId;  // ✅ FIXED

            loadedQuestions.add(question);
          }
        }

        questionsByCategory[categoryId] = loadedQuestions;
        questionList = loadedQuestions;
      }

    } catch (e) {
      print("LOAD ERROR: $e");
    }

    notifyListeners();
  }


  void selectAnswer(int questionId, int optionId) {
    selectedAnswers[questionId] = optionId;
    notifyListeners();
  }

  void nextQuestion() {
    if (currentQuestionIndex < questionList.length - 1) {
      currentQuestionIndex++;
      notifyListeners();
    }
  }

  void previousQuestion() {
    if (currentQuestionIndex > 0) {
      currentQuestionIndex--;
      notifyListeners();
    }
  }

  void startTimer(int minutes, VoidCallback onTimeOver) {
    totalMinutes = minutes;
    remainingSeconds = minutes * 60;

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        notifyListeners();
      } else {
        timer?.cancel();
        onTimeOver(); // 🔥 trigger from UI
      }
    });
  }

  int get attemptedCount =>
      selectedAnswers.length;

  void _showTimeOverDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                /// 🔴 TITLE
                const Text(
                  "Your time is over",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 20),

                /// CATEGORY DETAILS
                ...questionsByCategory.entries.map((entry) {
                  int categoryId = entry.key;
                  int attempted =
                  getAttemptedCountForCategory(categoryId);
                  int total = entry.value.length;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Category ID: $categoryId",
                          style: const TextStyle(
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Attempted: $attempted/$total",
                          style:
                          const TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                const SizedBox(height: 20),

                const Text(
                  "Please submit test",
                  style: TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 20),

                /// SUBMIT BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding:
                      const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(30)),
                    ),
                    child: const Text(
                      "Submit Now",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Future<bool> submitAssessment(
  //     Map<String, dynamic> body) async {
  //
  //   try {
  //
  //     final response = await apiService.post(
  //       'Assessment/CorrectSaveAnswers',
  //       body,
  //     );
  //
  //     resultData = response.data; // store result
  //
  //     notifyListeners();
  //
  //     return true;
  //
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<int?> insertUserAttemptApi(BuildContext context) async {
    try {
      String userId = UserData().model.value.userId.toString();

      String url = "Assessment/InsertUserAttempt/$userId";

      ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.post(url, {});

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response?.statusCode == 200) {
        var responseData = apiResponse.response?.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        if (responseData["State"] == 200 &&
            responseData["Data"] != null &&
            responseData["Data"].isNotEmpty) {

          int attemptId = responseData["Data"][0]["AttemptId"];

          this.attemptId = attemptId;   // ✅ SAVE ATTEMPT ID

          notifyListeners();

          return attemptId;
        }
      }

    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
    }

    return null;
  }

  Future<CorrectSaveAnswersModal?> correctSaveAnswersApi(
      BuildContext context,
      List<Map<String, dynamic>> answers) async {

    var isInternet =
    await UtilityClass.checkInternetConnectivity();

    if (isInternet) {
      try {

        String? ipAddress =
        await UtilityClass.getIpAddress();

        Map<String, dynamic> body = {
          "userId":
          UserData().model.value.userId,
         // "IPAddress": ipAddress,
          "answers": answers,
        };

        String url =
            "Assessment/CorrectSaveAnswers";

        ProgressDialog.showLoadingDialog(
            context);

        ApiResponse apiResponse =
        await commonRepo.post(url, body);

        ProgressDialog.closeLoadingDialog(
            context);

        if (apiResponse.response != null &&
            apiResponse.response?.statusCode ==
                200) {

          var responseData =
              apiResponse.response?.data;

          if (responseData is String) {
            responseData =
                jsonDecode(responseData);
          }

          final model =
          CorrectSaveAnswersModal.fromJson(responseData);

          if (model.state == 200) {

            resultData = model.data ?? [];
            notifyListeners();

            return model;
          } else {

            showAlertError(
                model.message ??
                    "Something went wrong",
                context);

            return model;
          }
        } else {

          return CorrectSaveAnswersModal(
            state: 0,
            message: "Something went wrong",
          );
        }

      } on Exception catch (err) {

        ProgressDialog.closeLoadingDialog(
            context);

        final model =
        CorrectSaveAnswersModal(
            state: 0,
            message: err.toString());

        showAlertError(
            model.message.toString(),
            context);

        return model;
      }

    } else {

      showAlertError(
          AppLocalizations.of(context)!
              .internet_connection,
          context);
    }
  }

  Future<List<dynamic>?> getAssessmentScoreApi(BuildContext context) async {
    try {
      String userId = UserData().model.value.userId.toString();

      String url = "Assessment/GetAssessmentScore/$userId";

      ProgressDialog.showLoadingDialog(context);

      ApiResponse apiResponse = await commonRepo.get(url);

      ProgressDialog.closeLoadingDialog(context);

      if (apiResponse.response?.statusCode == 200) {
        var responseData = apiResponse.response?.data;

        if (responseData is String) {
          responseData = jsonDecode(responseData);
        }

        if (responseData["State"] == 200 &&
            responseData["Data"] != null) {

          return responseData["Data"];
        }
      }

    } catch (e) {
      ProgressDialog.closeLoadingDialog(context);
      showAlertError(e.toString(), context);
    }

    return null;
  }

  void clearData() {
    /// stop timer
    timer?.cancel();
    timer = null;

    /// clear all data
    questionList.clear();
    questionsByCategory.clear();
    selectedAnswers.clear();
    resultData.clear();

    selectedCategoryId = 0;
    currentQuestionIndex = 0;
    attemptId = 0;
    remainingSeconds = 0;

    notifyListeners();
  }
}





