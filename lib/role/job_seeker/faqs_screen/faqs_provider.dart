import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../constants/colors.dart';
import '../../../constants/constants.dart';
import '../../../l10n/app_localizations.dart';
import '../../../repo/common_repo.dart';
import '../../../services/HttpService.dart';
import '../../../utils/right_to_left_route.dart';
import '../../../utils/utility_class.dart';
import 'action_services/bottom_provider.dart';
import 'action_services/bottom_screen.dart';
import 'chat_screen/chat_screen.dart';
import 'model/faqs_assistance_model.dart';
import 'model/quick_service_model.dart';

class FaqsProvider with ChangeNotifier {
  int _selectedIndex = 0;

  final CommonRepo commonRepo;

  String selectedChip = "";
  String selectedJobSub = "";
  int get selectedIndex => _selectedIndex;
  List<QuickServiceModel> quickServicesList = [];
  List<FaqsAssistanceData> originalFaqList = [];

  int? selectedYear;
  int? selectedMonth;

  FaqsProvider({required this.commonRepo});


  List<Map<String, String>> faqList(BuildContext context) {
    return [
      {
        "question": AppLocalizations.of(context)!.faqWelcomeQuestion,
        "answer": AppLocalizations.of(context)!.faqWelcomeAnswer,
      },
    ];
  }

  Color getDynamicColor(int index) {
    final colors = [
      const Color(0xFF4A90E2),
      const Color(0xFF50C878),
      const Color(0xFFFF8C42),
      const Color(0xFF9B59B6),
      const Color(0xFF00B8D9),
      const Color(0xFFFF4D6D),
      const Color(0xFF2ECC71),
      const Color(0xFF1ABC9C),
      const Color(0xFFE67E22),
      const Color(0xFF34495E),
    ];
    return colors[index % colors.length];
  }

  IconData getAutoIcon(int index) {
    final icons = [
      Icons.info_outline,
      Icons.work_outline,
      Icons.app_registration,
      Icons.payments_outlined,
      Icons.business_center,
      Icons.help_outline,
      Icons.chat_bubble_outline,
      Icons.assignment,
      Icons.settings,
      Icons.support_agent,
    ];
    return icons[index % icons.length];
  }

    Future<void> getFaqs(BuildContext context) async {
      originalFaqList.clear();
      try {
        HttpService http = HttpService(context, Constants.baseurl);
        Map<String, dynamic> body = {
          'ParentId': 0,
          'FAQAssistanceId': "",
        };
        Response response =
        await http.postRequest(Constants.getFAQAssistanceQuestions, body);
        FaqsAssistanceModel responseData = FaqsAssistanceModel.fromJson(response.data);
        if (responseData.status == true && responseData.dataFaqs != null && responseData.state == 200) {
          originalFaqList = responseData.dataFaqs ?? [];
          quickServicesList = originalFaqList.asMap().entries.map((entry) {
            int index = entry.key;
            FaqsAssistanceData item = entry.value;
            return QuickServiceModel(
              fAQAssistanceId: item.fAQAssistanceId.toString(),
              parentID: item.parentID.toString(),
              faqAssistanceHi: item.faqAssistanceHi ?? "Service ${index + 1}",
              faqAssistanceEng: item.faqAssistanceEng ?? "Service ${index + 1}",
              enumName: item.enumName.toString(),
              color: getDynamicColor(index),
              // icon: getAutoIcon(index),
              iconPath: getIconPath(item.faqAssistanceEng ?? ""),
              originalData: item,
            );
          }).toList();
          notifyListeners();
        }
        else {
         await UtilityClass.askForInput("Alert", responseData.message ?? 'Unable to load data', "Okay", "Okay", true,);
        }
      }
      catch (e) {
       await  UtilityClass.askForInput("Alert", 'Unable to load data. Check your connection and try again.', "Okay", "Okay", true,);
      }
    }

  String getIconPath(String title) {
    print("titleeeee-->$title");
    final aa = title.toLowerCase();
    print("titleeeee lowerletter -->$aa");

    switch (title.toLowerCase()) {
      case "mysy-2021 application status":
        return "assets/images/FAQmysy.svg";

      case "job fair":
      case "नौकरी मेला":
        return "assets/images/FAQJobFair.svg";

      case "registration procedure":
      case "पंजीकरण प्रक्रिया":
        return "assets/images/FAQRegPro.svg";

      case "scheme information":
      case "योजना जानकारी":
        return "assets/images/FAQSchmInfo.svg";

      case "payment status":
      case "भुगतान स्थिति":
        return "assets/images/FAQPaySta.svg";

      case "employment exchange office":
      case "रोजगार कार्यालय":
        return "assets/images/FAQEmpExOffice.svg";

      case "feedback & suggestions":
      case "प्रतिक्रिया सुझाव":
        return "assets/images/FAQFeedbkSugges.svg";

      default:
        return "assets/images/FAQmysy.svg"; // fallback
    }
  }

  Future<void> updateSelectedIndex(
      BuildContext context,
      int index,
      QuickServiceModel item,
      ) async {
    _selectedIndex = index;

    final String title =
    AppLocalizations.of(context)!.localeName == 'en'
        ? item.faqAssistanceEng
        : item.faqAssistanceHi;

    // ============================================================
    // PAYMENT STATUS
    // ============================================================
    if (title == "Payment Status" || title == "भुगतान स्थिति") {
      final result = await _showMonthYearDialog(context);

      // User pressed Cancel / closed dialog
      if (result == null) {
        _selectedIndex = 0;
        notifyListeners();
        return;
      }

      final int selectedYear = result['year']!;
      final int selectedMonth = result['month']!;

      Navigator.of(context).push(
        RightToLeftRoute(
          page: ChatScreen(
            item: item,
            submittedYear: selectedYear,
            submittedMonth: selectedMonth,
          ),
          duration: const Duration(milliseconds: 500),
          startOffset: const Offset(-1.0, 0.0),
        ),
      );

      notifyListeners();
      return;
    }

    // ============================================================
    // JOB FAIR
    // ============================================================
    if (title == "Job Fair" || title == "नौकरी मेला") {
      Provider.of<BottomProvider>(
        context,
        listen: false,
      ).clearData();

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          final screenHeight = MediaQuery.of(context).size.height;

          return Stack(
            children: [
              Container(
                height: screenHeight * 0.66,
                margin: const EdgeInsets.only(top: 20),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: BottomScreen(item: item),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: kPrimaryDark,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );

      notifyListeners();
      return;
    }

    // ============================================================
    // OTHER FAQ SERVICES
    // ============================================================
    Navigator.of(context).push(
      RightToLeftRoute(
        page: ChatScreen(item: item),
        duration: const Duration(milliseconds: 500),
        startOffset: const Offset(-1.0, 0.0),
      ),
    );

    notifyListeners();
  }

  Future<Map<String, int>?> _showMonthYearDialog(
      BuildContext context,
      ) async {
    int? selectedYear;
    int? selectedMonth;

    return showDialog<Map<String, int>>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            final bool isValid =
                selectedYear != null && selectedMonth != null;

            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),

              title: const Text(
                "Select Month & Year",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  // ==========================
                  // YEAR DROPDOWN
                  // ==========================
                  DropdownButtonFormField<int>(
                    value: selectedYear,

                    decoration: InputDecoration(
                      labelText: "Year *",
                      prefixIcon: const Icon(
                        Icons.calendar_today_outlined,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    hint: const Text("Select Year"),

                    items: List.generate(
                      DateTime.now().year - 2000 + 1,
                          (index) {
                        final int year = 2000 + index;

                        return DropdownMenuItem<int>(
                          value: year,
                          child: Text(year.toString()),
                        );
                      },
                    ),

                    onChanged: (value) {
                      setState(() {
                        selectedYear = value;
                      });
                    },
                  ),

                  const SizedBox(height: 16),

                  // ==========================
                  // MONTH DROPDOWN
                  // ==========================
                  DropdownButtonFormField<int>(
                    value: selectedMonth,

                    decoration: InputDecoration(
                      labelText: "Month *",
                      prefixIcon: const Icon(
                        Icons.date_range_outlined,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    hint: const Text("Select Month"),

                    items: const [
                      DropdownMenuItem(
                        value: 1,
                        child: Text("January"),
                      ),
                      DropdownMenuItem(
                        value: 2,
                        child: Text("February"),
                      ),
                      DropdownMenuItem(
                        value: 3,
                        child: Text("March"),
                      ),
                      DropdownMenuItem(
                        value: 4,
                        child: Text("April"),
                      ),
                      DropdownMenuItem(
                        value: 5,
                        child: Text("May"),
                      ),
                      DropdownMenuItem(
                        value: 6,
                        child: Text("June"),
                      ),
                      DropdownMenuItem(
                        value: 7,
                        child: Text("July"),
                      ),
                      DropdownMenuItem(
                        value: 8,
                        child: Text("August"),
                      ),
                      DropdownMenuItem(
                        value: 9,
                        child: Text("September"),
                      ),
                      DropdownMenuItem(
                        value: 10,
                        child: Text("October"),
                      ),
                      DropdownMenuItem(
                        value: 11,
                        child: Text("November"),
                      ),
                      DropdownMenuItem(
                        value: 12,
                        child: Text("December"),
                      ),
                    ],

                    onChanged: (value) {
                      setState(() {
                        selectedMonth = value;
                      });
                    },
                  ),

                  const SizedBox(height: 8),

                  // Mandatory message
                  if (!isValid)
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Text(
                          "* Month and Year are required",
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
              ),

              actions: [

                // ==========================
                // CANCEL
                // ==========================
                TextButton(
                  onPressed: () {
                    Navigator.pop(dialogContext);
                  },
                  child: const Text("Cancel"),
                ),

                // ==========================
                // OK
                // ==========================
                ElevatedButton(
                  onPressed: isValid
                      ? () {
                    Navigator.pop(
                      dialogContext,
                      {
                        'year': selectedYear!,
                        'month': selectedMonth!,
                      },
                    );
                  }
                      : null,
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void clearData(){
    selectedChip = "";
    selectedJobSub = "";
    _selectedIndex = 0;
  }

}