import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../constants/colors.dart';
import 'assessment_test.dart';
import 'modal/self_assessment_modal.dart';
import 'provider/self_assessment_provider.dart';

class SelfAssessmentScreen extends StatefulWidget {
  const SelfAssessmentScreen({super.key});

  @override
  State<SelfAssessmentScreen> createState() =>
      _SelfAssessmentScreenState();
}

class _SelfAssessmentScreenState
    extends State<SelfAssessmentScreen> {

  bool showCategorySelection = false;


  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      context
          .read<SelfAssessmentProvider>()
          .getAssessmentListApi(context, 2234); // pass dynamic jobSeekerId
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF3F4F6),
      appBar: AppBar(
        title: const Text(
          "Self-Assessment Test",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 10,
              )
            ],
          ),
          child: showCategorySelection
              ? _buildCategoryCard()
              : _buildOverviewCard(),
        ),
      ),
    );
  }

  /// ===================================================
  /// FIRST CARD  (OVERVIEW - YOUR ORIGINAL STRUCTURE)
  /// ===================================================
  Widget _buildOverviewCard() {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Overview",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),
                Text(
                  "The Self-Assessment Test is designed to help individuals understand their skills, interests, and career preferences. It serves as a diagnostic tool that enables job seekers or students to identify their strengths and areas for improvement, assisting them in making informed career choices. By analyzing the responses, the system provides insights into personality traits, aptitude levels, and potential job roles aligned with the user’s profile.",
                  style: TextStyle(height: 1.6),
                ),
                SizedBox(height: 20),

                Text(
                  "Key Features",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),

                FeatureItem(
                    text:
                    "Comprehensive Skill Evaluation including logical reasoning, verbal ability, numerical aptitude."),
                FeatureItem(
                    text:
                    "Personality and Interest Mapping aligned with suitable career paths."),
                FeatureItem(
                    text:
                    "Instant Feedback and Insights after completing the test."),
                FeatureItem(
                    text:
                    "User-Friendly Interface with easy navigation."),
                FeatureItem(
                    text:
                    "Confidential and Secure data handling."),
                FeatureItem(
                    text:
                    "Guided Career Recommendations."),
                FeatureItem(
                    text:
                    "Reattempt Option to track improvement."),

                SizedBox(height: 20),

                Text(
                  "Benefits",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 12),

                Text(
                  "• Helps in self-discovery\n"
                      "• Scientific basis for career decisions\n"
                      "• Pre-screening tool\n"
                      "• Encourages continuous learning",
                  style: TextStyle(height: 1.6),
                ),
              ],
            ),
          ),
        ),

        /// Bottom Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Go To Dashboard"),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  showCategorySelection = true;
                });
              },
              child: const Text("Continue"),
            ),
          ],
        )
      ],
    );
  }

  /// ===================================================
  /// SECOND CARD (CATEGORY SELECTION)
  /// ===================================================
  Set<AssessmentData> selectedCategories = {};

  // final List<String> selfAssessmentList = [
  //   "General Awareness",
  //   "Logical Reasoning",
  //   "Verbal Ability",
  //   "Numerical Reasoning",
  //   "Communication Skills",
  //   "Behavioral / Situational Judgement",
  // ];
  //
  // final List<String> psychometricList = [
  //   "Psychometric Questions"
  // ];

  Widget _buildCategoryCard() {
    final provider = Provider.of<SelfAssessmentProvider>(context, listen: false);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Select at least 1 category(s) for Assessment",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 24),

        const Text("Self Assessment",
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),

        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: provider.selfAssessmentList
              .map((item) => _selectableChip(item))
              .toList(),
        ),


        const SizedBox(height: 30),

        const Text("Psychometric",
            style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 12),

        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: provider.psychometricList
              .map((item) => _selectableChip(item))
              .toList(),
        ),


        const Spacer(),

        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: () {
                setState(() {
                  showCategorySelection = false;
                  selectedCategories.clear();
                });
              },
              child: const Text("Cancel"),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: selectedCategories.isEmpty
                  ? null
                  : () {
                _showInstructionPopup();
              },
              child: const Text("Start Test"),
            ),
          ],
        )
      ],
    );
  }

  Widget _selectableChip(AssessmentData item) {
    final bool isSelected = selectedCategories.contains(item);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedCategories.remove(item);
          } else {
            selectedCategories.add(item);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? kPrimaryColor : const Color(0xffF2F2F2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          item.name ?? "",
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }


  void _showInstructionPopup() {
    final provider = Provider.of<SelfAssessmentProvider>(context, listen: false);

    bool hasSelfAssessment =
    selectedCategories.any((item) => item.assessmentTypeId == 1);

    bool hasPsychometric =
    selectedCategories.any((item) => item.assessmentTypeId == 2);

    // ✅ Dynamic total questions
    int totalQuestions = selectedCategories.fold(
        0, (sum, item) => sum + (item.minQuestions ?? 0));

    // ✅ Dynamic total duration
    int totalDuration = selectedCategories.fold(
        0, (sum, item) => sum + (item.durationMinutes ?? 0));

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Center(
                    child: Text(
                      "Assessment Instructions",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),

                  /// Always show
                  const Text("General Instructions",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),

                  _bullet("Selected Categories: ${selectedCategories.length}"),
                  _bullet("Total Questions: $totalQuestions"),
                  _bullet("Total Duration: $totalDuration minutes"),
                  _bullet("Do not refresh the page during the test."),
                  _bullet("Each question must be answered before proceeding."),
                  _bullet("Once submitted, answers cannot be changed."),

                  /// Self Assessment Condition
                  if (hasSelfAssessment) ...[
                    const SizedBox(height: 20),
                    const Text("Self Assessment Instructions",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    _bullet("There is only one correct answer per question."),
                    _bullet("Each correct answer carries marks."),
                    _bullet("Attempt all questions carefully."),
                  ],

                  /// Psychometric Condition
                  if (hasPsychometric) ...[
                    const SizedBox(height: 20),
                    const Text("Psychometric Instructions",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold)),
                    const SizedBox(height: 10),
                    _bullet("No answers are right or wrong."),
                    _bullet("Answer honestly based on your behaviour."),
                    _bullet("Do not overthink your responses."),
                  ],

                  const SizedBox(height: 30),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("Cancel"),
                      ),
                      const SizedBox(width: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _startCountdown(totalDuration);

                          // TODO: Navigate to test page
                        },
                        child: const Text("Start Test"),
                      ),
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

  void _startCountdown(int totalDuration) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _CountdownOverlay(
        selectedCategories: selectedCategories.toList(),
        totalDuration: totalDuration,
      ),

    );
  }



  Widget _bullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle,
              size: 18, color: Colors.indigo),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

}

/// ===================================================
/// FEATURE ITEM
/// ===================================================
class FeatureItem extends StatelessWidget {
  final String text;
  const FeatureItem({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle,
              size: 18, color: Colors.indigo),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

/// ===================================================
/// CATEGORY CHIP
/// ===================================================
class CategoryChip extends StatelessWidget {
  final String title;
  const CategoryChip(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xffF2F2F2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(title),
    );
  }
}

class _CountdownOverlay extends StatefulWidget {
  final List<AssessmentData> selectedCategories;
  final int totalDuration;

  const _CountdownOverlay({
    required this.selectedCategories,
    required this.totalDuration,
  });

  @override
  State<_CountdownOverlay> createState() =>
      _CountdownOverlayState();
}


class _CountdownOverlayState extends State<_CountdownOverlay> {
  int count = 3;

  @override
  void initState() {
    super.initState();
    _start();
  }

  void _start() async {
    for (int i = 3; i > 0; i--) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => count = i - 1);
    }

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => AssessmentTestScreen(
          selectedCategories: widget.selectedCategories,
          totalDuration: widget.totalDuration,
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.8),
      body: Center(
        child: Text(
          count == 0 ? "Go!" : "$count",
          style: const TextStyle(
            fontSize: 80,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
