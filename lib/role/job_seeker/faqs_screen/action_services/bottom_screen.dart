import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/faqs_screen/faqs_provider.dart';
import '../../../../utils/size_config.dart';
import '../chat_screen/chat_screen.dart';
import '../model/common_response_model.dart';
import '../model/faqs_assistance_model.dart';
import '../model/quick_service_model.dart';
import 'bottom_card_first_screen.dart';
import 'bottom_provider.dart';


class BottomScreen extends StatefulWidget {
  final QuickServiceModel? item;
  const BottomScreen({super.key,this.item});

  @override
  State<BottomScreen> createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<BottomProvider>(context, listen: false);
      provider.clearData();
      provider.getFaqs(context,widget.item?.fAQAssistanceId,"","1",widget.item);

    });

  }


  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Consumer<BottomProvider>(builder: (context, provider, child) => SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Drag Handle
                Container(
                  width: 45,
                  height: 5,
                  decoration: BoxDecoration(
                    color: kBlackColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(height: (SizeConfig.defaultSize ?? 10) * 2),
                SizedBox(
                  height: 50,
                  child: Consumer<BottomProvider>(
                    builder: (context, provider, child) {

                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: provider.faqListTitle.length,
                        itemBuilder: (context, index) {

                          final item = provider.faqListTitle[index];

                          final bool isSelected =
                              provider.selectedId == item.fAQAssistanceId;

                          Locale locale = Localizations.localeOf(context);

                          return GestureDetector(

                            onTap: () {
                              provider.faqListTitleUpdate(context, item);
                            },

                            child: AnimatedContainer(

                              duration: const Duration(milliseconds: 250),

                              margin: const EdgeInsets.only(right: 10),

                              padding: const EdgeInsets.symmetric(
                                  horizontal: 18, vertical: 10),

                              decoration: BoxDecoration(

                                color: isSelected
                                    ? kPrimaryColor
                                    : kPrimaryColor.withOpacity(0.08),

                                borderRadius: BorderRadius.circular(16),

                                border: Border.all(
                                  color: isSelected
                                      ? kPrimaryColor
                                      : kPrimaryColor.withOpacity(0.15),
                                  width: 1.5,
                                ),
                              ),

                              child: Center(
                                child: Text(

                                  locale.languageCode == 'en'
                                      ? item.faqAssistanceEng ?? ""
                                      : item.faqAssistanceHi ?? "",

                                  style: TextStyle(
                                    color:
                                    isSelected ? Colors.white : kPrimaryColor,
                                    fontSize: 13,
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                provider.originalStatusList.isNotEmpty
                    ? Column(
                  children: [
                    SizedBox(height: (SizeConfig.defaultSize ?? 10) * 2),
                    BottomCardFirstScreen(
                      icon: Icons.how_to_reg,
                      apiData: provider.originalStatusList,
                      onItemSelected: (ActionData? item) {
                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ChatScreen(item: item,status:"1"),
                                    ),
                                  );
                        //provider.getFaqs(context, item!.fAQAssistanceId, "", "3");
                      },
                    ),
                  ],
                )
                    : const SizedBox(),

                // if (provider.faqListSector.isNotEmpty)
                //   Column(
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       const Padding(
                //         padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                //         child: Text(
                //           "Select The Sector",
                //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                //         ),
                //       ),
                //       BottomCardFirstScreen(
                //         icon: Icons.business,
                //         apiData: provider.faqListSector,
                //         onItemSelected: (FaqsAssistanceData? item) {
                //           widget.item?.fAQAssistanceId = item?.fAQAssistanceId;
                //           Navigator.pop(context);
                //           Navigator.push(
                //             context,
                //             MaterialPageRoute(
                //               builder: (context) => ChatScreen(item: widget.item),
                //             ),
                //           );
                //         },
                //       ),
                //     ],
                //   )

              ],
            ),
          ),
      ),
      ),
    );
  }

}