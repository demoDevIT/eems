import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

      // Load first category automatically
      provider.loadQuestions(
          widget.selectedCategories.first.id!);

      // Start timer
      provider.startTimer(widget.totalDuration);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider =
    context.watch<AssessmentTestProvider>();

    return Scaffold(
      backgroundColor: const Color(0xffF3F4F6),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [

          /// ================================
          /// TOP SECTION (CATEGORIES + TIMER)
          /// ================================
          Container(
            padding: const EdgeInsets.all(20),
            color: Colors.white,
            child: Row(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                /// CATEGORY BOXES
                Expanded(
                  child: Wrap(
                    spacing: 20,
                    runSpacing: 20,
                    children: widget.selectedCategories
                        .map((cat) {
                      bool isSelected =
                          provider.selectedCategoryId ==
                              cat.id;

                      return GestureDetector(
                        onTap: () {
                          provider.loadQuestions(
                              cat.id!);
                        },
                        child: Container(
                          width: 260,
                          padding:
                          const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue
                                .withOpacity(0.1)
                                : Colors.grey
                                .shade200,
                            borderRadius:
                            BorderRadius
                                .circular(12),
                            border: Border.all(
                              color: isSelected
                                  ? Colors.blue
                                  : Colors
                                  .transparent,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                            children: [
                              Text(
                                cat.name ?? "",
                                style:
                                const TextStyle(
                                  fontWeight:
                                  FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                  height: 5),
                              Text(
                                "${provider.attemptedCount}/${cat.minQuestions} attempted",
                                style:
                                const TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                /// TIMER + SUBMIT
                Column(
                  children: [
                    Text(
                      "${provider.remainingSeconds ~/ 60}",
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight:
                        FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const Text("Minutes"),
                    const SizedBox(height: 10),
                    Text(
                      "${(provider.remainingSeconds % 60).toString().padLeft(2, '0')}",
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight:
                        FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    const Text("Seconds"),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        // Submit logic
                      },
                      child:
                      const Text("Submit Test"),
                    )
                  ],
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// ================================
          /// QUESTION NAVIGATION
          /// ================================
          Container(
            margin: const EdgeInsets.symmetric(
                horizontal: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
              BorderRadius.circular(12),
            ),
            child: Wrap(
              spacing: 10,
              runSpacing: 10,
              children: List.generate(
                provider.questionList.length,
                    (index) {
                  bool isSelected =
                      provider.currentQuestionIndex ==
                          index;

                  return GestureDetector(
                    onTap: () {
                      provider.currentQuestionIndex =
                          index;
                      provider.notifyListeners();
                    },
                    child: CircleAvatar(
                      backgroundColor:
                      isSelected
                          ? Colors.blue
                          : Colors.grey
                          .shade300,
                      child: Text(
                        "${index + 1}",
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SizedBox(height: 20),

          /// ================================
          /// QUESTION SECTION
          /// ================================
          Expanded(
            child: Container(
              margin:
              const EdgeInsets.symmetric(
                  horizontal: 20),
              padding:
              const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                BorderRadius.circular(12),
              ),
              child: provider
                  .questionList.isEmpty
                  ? const Center(
                  child: Text(
                      "No Questions Available"))
                  : _questionSection(provider),
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _questionSection(
      AssessmentTestProvider provider) {
    var question =
    provider.questionList[
    provider.currentQuestionIndex];

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [

        Text(
          "Q${provider.currentQuestionIndex + 1}. ${question.question}",
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),

        const SizedBox(height: 20),

        ...List.generate(question.options.length,
                (i) {
              return RadioListTile<int>(
                value: question.optionIds[i],
                groupValue: provider
                    .selectedAnswers[question.id],
                onChanged: (val) {
                  provider.selectAnswer(
                      question.id!, val!);
                },
                title: Text(question.options[i]),
              );
            }),

        const Spacer(),

        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [
            OutlinedButton(
              onPressed: provider.previousQuestion,
              child: const Text("Previous"),
            ),
            ElevatedButton(
              onPressed: provider.nextQuestion,
              child: const Text("Next"),
            ),
          ],
        )
      ],
    );
  }
}
