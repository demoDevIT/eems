import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/faqs_screen/stat_card.dart';
import '../../../comonwidgets/common_widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/language_toggle_switch.dart';
import '../../../utils/right_to_left_route.dart';
import '../jobseekerdashboard/job_seeker_dashboard.dart';
import 'action_services/bottom_provider.dart';
import 'action_services/bottom_screen.dart';
import 'chat_screen/chat_screen.dart';
import 'faqs_provider.dart';

class FaqsScreen extends StatefulWidget {
  const FaqsScreen({super.key});

  @override
  State<FaqsScreen> createState() => _FaqsScreenState();
}

class _FaqsScreenState extends State<FaqsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<FaqsProvider>(context, listen: false);
      provider.clearData();
     provider.getFaqs(context);

    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey ,
      backgroundColor: Colors.grey.shade50,
        appBar: CommonWidgets.AppBarFaqs(
          title: AppLocalizations.of(context)!.faqs,
          callback: () {
            Navigator.pushAndRemoveUntil<dynamic>(context,
                MaterialPageRoute<dynamic>(builder: (BuildContext context) => const JobSeekerDashboard()),
                    (route) => false);
          },
          actions: [
            LanguageToggleSwitch(),
            const SizedBox(width: 10),
          ],
        ),
      body: SafeArea(
        child: Consumer<FaqsProvider>(builder: (context, provider, child) =>
        SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: provider.faqList(context).length,
                  itemBuilder: (context, index) {
                    var item= provider.faqList(context)[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          )
                        ],
                      ),
                      child: Theme(
                        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
                        child: ExpansionTile(
                          iconColor: Colors.blueAccent,
                          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                          title: Text(
                            item['question']!,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                          ),
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                              child: Text(
                                item['answer']!,
                                style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.5),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),

                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(AppLocalizations.of(context)!.quickServices,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(left: 16.0,right: 16.0),
                  shrinkWrap: true,
                  itemCount: provider.quickServicesList.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.3,
                  ),
                  itemBuilder: (context, index) {
                    final item = provider.quickServicesList[index];

                    String title =
                    AppLocalizations.of(context)!.localeName == 'en'
                        ? item.faqAssistanceEng
                        : item.faqAssistanceHi;

                    return StatCard(
                      title: title,
                      accentColor: item.color,
                      icon: item.icon,
                      isSelected: provider.selectedIndex == index,
                      onTap: () {
                        provider.updateSelectedIndex(context,index,item);
                      },
                    );
                  },
                )
              ],
            ),
          ))));

  }

}