import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../utils/global.dart';
import '../../../utils/user_new.dart';
import 'modal/self_assessment_modal.dart';
import 'provider/assessment_test_provider.dart';

class AssessmentTestScreen extends StatefulWidget {
  final List<AssessmentData> selectedCategories;
  final int totalDuration;

  const AssessmentTestScreen({
    super.key,
    required this.selectedCategories,
    required this.totalDuration,
  });

  @override
  State<AssessmentTestScreen> createState() =>
      _AssessmentTestScreenState();
}

class _AssessmentTestScreenState
    extends State<AssessmentTestScreen> {

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      final provider =
      context.read<AssessmentTestProvider>();

      provider.clearData();
      // Load first category automatically
      provider.loadQuestions(
          widget.selectedCategories.first.id!);

      // Start timer
      provider.startTimer(widget.totalDuration, () {
        _showTimeOverPopup(context, provider);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AssessmentTestProvider>();

    return Scaffold(
      backgroundColor: const Color(0xffF3F4F6),

      /// ✅ APP BAR ADDED
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Self Assessment",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// ============================
            /// CATEGORY SLIDER
            /// ============================
            _categorySlider(provider),

            const SizedBox(height: 20),

            /// ============================
            /// QUESTION SECTION
            /// ============================
            Expanded(
              child: _questionSection(provider),
            ),
          ],
        ),
      ),
    );
  }

  void _showTimeOverPopup(
      BuildContext context,
      AssessmentTestProvider provider) {

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

                /// CATEGORY LIST (Same like Review Popup)
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: widget.selectedCategories.map((cat) {

                    int attempted =
                    provider.getAttemptedCountForCategory(cat.id!);

                    return Container(
                      width: 220,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Text(
                            cat.name ?? "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Attempted: $attempted/${cat.minQuestions}",
                            style:
                            const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 25),

                const Text(
                  "Please submit test",
                  style: TextStyle(fontSize: 14),
                ),

                const SizedBox(height: 20),

                /// SUBMIT BUTTON
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await _submitAssessment(context, provider);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
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

  Widget _categorySlider(AssessmentTestProvider provider) {
    int currentIndex = widget.selectedCategories
        .indexWhere((e) => e.id == provider.selectedCategoryId);

    var currentCategory = widget.selectedCategories[currentIndex];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [

          /// LEFT ARROW
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: currentIndex > 0
                ? () {
              provider.loadQuestions(
                  widget.selectedCategories[currentIndex - 1].id!);
            }
                : null,
          ),

          /// CATEGORY INFO
          Expanded(
            child: Column(
              children: [
                Text(
                  currentCategory.name ?? "",
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${provider.getAttemptedCountForCurrentCategory()}/${provider.questionList.length} Attempt",
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          /// RIGHT ARROW
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: currentIndex <
                widget.selectedCategories.length - 1
                ? () {
              provider.loadQuestions(
                  widget.selectedCategories[currentIndex + 1].id!);
            }
                : null,
          ),
        ],
      ),
    );
  }

  Widget _questionSection(AssessmentTestProvider provider) {
    if (provider.questionList.isEmpty ||
        provider.currentQuestionIndex >= provider.questionList.length) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    var question =
    provider.questionList[provider.currentQuestionIndex];

    int totalQuestions = provider.questionList.length;
    int currentIndex = provider.currentQuestionIndex + 1;

    double progress = currentIndex / totalQuestions;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          /// QUESTION HEADER + TIMER
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Question"),
                  const SizedBox(height: 4),
                  Text(
                    "${currentIndex.toString().padLeft(2, '0')}/$totalQuestions",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),

              /// TIMER CIRCLE
              Container(
                height: 60,
                width: 60,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xffE0E7FF),
                ),
                alignment: Alignment.center,
                child: Text(
                  "${provider.remainingSeconds ~/ 60}:${(provider.remainingSeconds % 60).toString().padLeft(2, '0')}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Colors.blue,
                  ),
                ),
              )
            ],
          ),

          const SizedBox(height: 10),

          /// PROGRESS BAR
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Colors.grey.shade300,
              valueColor:
              const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
          ),

          const SizedBox(height: 20),

          /// QUESTION BOX
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xffFCE7F3),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.purple),
            ),
            child: Text(
              question.question ?? "",
              style: const TextStyle(fontSize: 15),
            ),
          ),

          const SizedBox(height: 20),

          /// OPTIONS
          Expanded(
            child: ListView.builder(
              itemCount: question.options.length,
              itemBuilder: (context, index) {

                bool isSelected =
                    provider.selectedAnswers[question.id] ==
                        question.optionIds[index];

                return GestureDetector(
                  onTap: () {
                    provider.selectAnswer(
                        question.id!,
                        question.optionIds[index]);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xffE0E7FF)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color:
                        isSelected ? Colors.blue : Colors.transparent,
                      ),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: isSelected
                              ? Colors.blue
                              : Colors.grey.shade400,
                          child: Text(
                            String.fromCharCode(97 + index),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(child: Text(question.options[index])),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          /// BUTTONS
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: provider.previousQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade300,
                    foregroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Previews"),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: provider.nextQuestion,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                  ),
                  child: const Text("Next"),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showReviewPopup(context, provider);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff1E3A8A),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text("Submit Test"),
            ),
          )
        ],
      ),
    );
  }

  void _showReviewPopup(
      BuildContext context,
      AssessmentTestProvider provider) {

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

                const Text(
                  "Review Your Test",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 20),

                /// CATEGORY LIST
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children:
                  widget.selectedCategories.map((cat) {

                    int attempted =
                    provider.getAttemptedCountForCategory(cat.id!);

                    return Container(
                      width: 220,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius:
                        BorderRadius.circular(14),
                      ),
                      child: Column(
                        children: [
                          Text(
                            cat.name ?? "",
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                                fontWeight:
                                FontWeight.w600),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "Attempted: $attempted/${cat.minQuestions}",
                            style: const TextStyle(
                                color: Colors.grey),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 25),

                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.end,
                  children: [

                    /// REVIEW BUTTON
                    OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Review"),
                    ),

                    const SizedBox(width: 12),

                    /// FINAL SUBMIT BUTTON
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(context);
                        await _submitAssessment(
                            context, provider);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor:
                          Colors.teal),
                      child: const Text(
                        "Submit",
                        style:
                        TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _submitAssessment(
      BuildContext context,
      AssessmentTestProvider provider) async {

    List<Map<String, dynamic>> answers = [];

    provider.selectedAnswers
        .forEach((questionId, answerId) {

      var question =
      provider.getQuestionById(questionId);

      if (question != null) {

        answers.add({
          "SectionId": question.sectionId,
          "QuestionId": question.id,
          "AnswerId": answerId,
          "AssessmentTypeId":
          question.assessmentTypeId,
          "UserId":
          UserData().model.value.userId,
          "AttemptId":
          provider.attemptId,
        });
      }
    });

    if (answers.isEmpty) {
      showAlertError(
          "Please attempt at least one question",
          context);
      return;
    }

    var response =
    await provider.correctSaveAnswersApi(
        context, answers);

    if (response != null &&
        response.state == 200) {

      _showResultPopup(context, provider);
    }
  }

  void _showResultPopup(
      BuildContext context,
      AssessmentTestProvider provider) {

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return Dialog(
          insetPadding:
          const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(20)),
          child: Padding(
            padding:
            const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                children: [

                  const Text(
                    "Assessment Result",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight:
                        FontWeight.bold),
                  ),

                  const SizedBox(height: 20),

                  ...provider.resultData
                      .map<Widget>((section) {

                    return Container(
                      margin:
                      const EdgeInsets.only(
                          bottom: 20),
                      padding:
                      const EdgeInsets.all(
                          16),
                      decoration: BoxDecoration(
                        color:
                        Colors.deepPurple
                            .shade50,
                        borderRadius:
                        BorderRadius.circular(
                            16),
                      ),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                        children: [

                          Text(
                            section["sectionName"],
                            style: const TextStyle(
                                fontWeight:
                                FontWeight
                                    .bold),
                          ),

                          const SizedBox(
                              height: 10),

                          LinearProgressIndicator(
                            value: section[
                            "accuracy"] /
                                100,
                          ),

                          const SizedBox(
                              height: 10),

                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                            children: [
                              Text(
                                  "Questions: ${section["total"]}"),
                              Text(
                                  "Correct: ${section["correct"]}"),
                              Text(
                                  "Incorrect: ${section["incorrect"]}"),
                            ],
                          )
                        ],
                      ),
                    );
                  }).toList(),

                  const SizedBox(height: 20),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () =>
                            Navigator.pop(
                                context),
                        child:
                        const Text("Close"),
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                        child:
                        const Text("Submit"),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}
