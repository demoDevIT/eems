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
              icon: getAutoIcon(index),
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

  void updateSelectedIndex(BuildContext context,int index,QuickServiceModel item) {
    _selectedIndex = index;
    String title =
    AppLocalizations.of(context)!.localeName == 'en'
        ? item.faqAssistanceEng
        : item.faqAssistanceHi;
    if (title == "Job Fair" || title == "नौकरी मेला") {
      Provider.of<BottomProvider>(context, listen: false).clearData();
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) {
          // Provider.of<FaqsProvider>(context, listen: false).clearData();
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
                        )
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

    } else {
      Navigator.of(context)
          .push(
        RightToLeftRoute(
          page:  ChatScreen( item: item,),
          duration: const Duration(milliseconds: 500),
          startOffset: const Offset(-1.0, 0.0),
        ),
      );

    }
    notifyListeners();
  }

  void clearData(){
    selectedChip = "";
    selectedJobSub = "";
    _selectedIndex = 0;
  }

}