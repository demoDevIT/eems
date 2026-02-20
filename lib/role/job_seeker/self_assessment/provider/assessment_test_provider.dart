import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../repo/common_repo.dart';
import '../modal/assessment_question.dart';

class AssessmentTestProvider extends ChangeNotifier {
  final CommonRepo commonRepo;

  AssessmentTestProvider({required this.commonRepo});

  bool isLoading = false;

  List<AssessmentQuestion> questionList = [];

  int selectedCategoryId = 0;
  int currentQuestionIndex = 0;

  Map<int, int> selectedAnswers = {};
  // questionId -> optionId

  int totalMinutes = 0;
  int remainingSeconds = 0;

  Timer? timer;

  Future<void> loadQuestions(int categoryId) async {
    try {
    //  isLoading = true;
      selectedCategoryId = categoryId;
      questionList.clear();
      currentQuestionIndex = 0;
      notifyListeners();

      final apiResponse = await commonRepo.get(
          "Assessment/GetJobseekerAssessmentTestQuestion/$categoryId");

      if (apiResponse.response?.statusCode == 200) {
        dynamic data = apiResponse.response!.data;

        if (data is String) {
          data = jsonDecode(data);
        }

        questionList.clear();

        if (data['Data'] != null) {
          for (var e in data['Data']) {
            questionList.add(AssessmentQuestion.fromJson(e));
          }
        }
      }
    } catch (e) {
      print("LOAD ERROR: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
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

  void startTimer(int minutes) {
    totalMinutes = minutes;
    remainingSeconds = minutes * 60;

    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (remainingSeconds > 0) {
        remainingSeconds--;
        notifyListeners();
      } else {
        timer?.cancel();
      }
    });
  }

  int get attemptedCount =>
      selectedAnswers.length;
}





