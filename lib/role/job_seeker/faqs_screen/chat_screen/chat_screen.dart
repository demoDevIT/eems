import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/faqs_screen/chat_screen/chat_provider.dart';
import 'package:rajemployment/role/job_seeker/faqs_screen/faqs_screen.dart';

import '../../../../animatedList/animated_list_view.dart';
import '../../../../comonwidgets/common_widgets.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../utils/language_toggle_switch.dart';
import '../../jobseekerdashboard/job_seeker_dashboard.dart';
import '../model/quick_service_model.dart';
import 'chat_bubble_painter.dart';

class ChatScreen extends StatefulWidget {
  final dynamic item;
  final String? status;

  const ChatScreen({super.key, this.item, this.status});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<ChatProvider>(context, listen: false);
      provider.clearData();
      if(widget.status == "1"){
        provider.originalStatusList.add(widget.item);
      }else{
        provider.getStatus(context, widget.item);

      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: kWhite,
      appBar: CommonWidgets.AppBarFaqs(
        title: AppLocalizations.of(context)!.faqs,
        callback: () {
          Navigator.of(context).pop(false);

        },
        actions: [
          LanguageToggleSwitch(),
          const SizedBox(width: 10),
        ],
      ),
      body: Consumer<ChatProvider>(
        builder: (context, provider, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: provider.originalStatusList.isNotEmpty ?Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if(provider.originalStatusList.isNotEmpty)
                    AnimatedListView(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: provider.originalStatusList.length,
                      itemBuilder: (context, index) {
                        var item = provider.originalStatusList[index];
                        bool hasData(dynamic value) {
                          return value != null && value.toString().trim().isNotEmpty && value.toString() != "null";
                        }
                        String formatDate(String? dateStr) {
                          if (!hasData(dateStr)) return "";
                          return dateStr!.split('T')[0];
                        }

                        return Stack(
                          children: [
                            Positioned(
                              top: 0,
                              left: 20,
                              child: CustomPaint(
                                painter:
                                ChatBubblePainter(Colors.blueGrey.withOpacity(0.1)),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(bottom: 15),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEEEEEE),
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(5),
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 5,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header: Event Name & ID
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          hasData(item.actionNameHi) ? item.actionNameHi.toString() : (hasData(item.actionNameEn) ? item.actionNameEn.toString() : ""),
                                          style: const TextStyle(color: kBlackColor, fontWeight: FontWeight.bold, fontSize: 18),
                                        ),
                                      ),
                                      if (hasData(item.eventId))
                                        Container(
                                          padding: const EdgeInsets.all(5),
                                          decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(5)),
                                          child: Text(item.eventId.toString(), style: const TextStyle(color:kBlackColor, fontSize: 10)),
                                        ),
                                    ],
                                  ),
                                  const Divider(color: kGrayColor, height: 20),
                                  if (hasData(item.actionNameEn)) buildDataRow("Action", item.actionNameEn, Icons.pending_actions),
                                  if (hasData(item.officeName)) buildDataRow("Office Name", item.officeName, Icons.cabin),
                                  if (hasData(item.applicationNo)) buildDataRow("App No", item.applicationNo, Icons.assignment_ind),
                                  if (hasData(item.venue)) buildDataRow("Venue", item.venue, Icons.location_on),
                                  if (hasData(item.inchargeName)) buildDataRow("Incharge", item.inchargeName, Icons.person),
                                  if (hasData(item.contactNumber)) buildDataRow("Contact", item.contactNumber, Icons.phone),
                                  if (hasData(item.startDate) || hasData(item.endDate))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 8.0),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.calendar_month, size: 16, color:kBlackColor),
                                          const SizedBox(width: 8),
                                          Text(
                                            "${formatDate(item.startDate)} To ${formatDate(item.endDate)}",
                                            style: const TextStyle(color:kBlackColor, fontSize: 13),
                                          ),
                                        ],
                                      ),
                                    ),

                                  if (hasData(item.eventDescription))
                                    Padding(
                                      padding: const EdgeInsets.only(top: 10),
                                      child: Text(
                                        item.eventDescription.toString(),
                                        style: const TextStyle(color: Colors.white54, fontSize: 13),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                    if(provider.originalStatusList.isNotEmpty)
                    Column(
                      children: [
                        const SizedBox(height: 15),
                        const Text(
                          "Do you want more information?",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: modernActionButton(
                                context: context,
                                label: "Yes",
                                icon: CupertinoIcons.check_mark_circled_solid,
                                baseColor: kPrimaryColor,
                                isPrimary: true,
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const FaqsScreen()),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: modernActionButton(
                                context: context,
                                label: "No",
                                icon: CupertinoIcons.xmark_circle,
                                baseColor: Colors.blueGrey,
                                isPrimary: false,
                                onTap: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      behavior: SnackBarBehavior.floating,
                                      backgroundColor:
                                      Colors.blueGrey.shade900,
                                      content: const Text(
                                          "Thank you, Have a nice day."),
                                    ),
                                  );

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const FaqsScreen()),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ],
                ):  Center(
              child: const Text(
                "No Data Available",
                style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),

          );
        },
      ),
    );
  }
  Widget buildDataRow(String label, dynamic value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: kBlackColor),
          const SizedBox(width: 8),
          Text(
            "$label: ",
            style: const TextStyle(color: kBlackColor, fontSize: 13, fontWeight: FontWeight.w500),
          ),
          Expanded(
            child: Text(
              value.toString(),
              style: const TextStyle(color: kBlackColor, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget modernActionButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color baseColor,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isPrimary
                ? [baseColor, baseColor.withOpacity(0.8)]
                : [
              Colors.white.withOpacity(0.9),
              Colors.white.withOpacity(0.7)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: isPrimary
                  ? baseColor.withOpacity(0.4)
                  : Colors.black.withOpacity(0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color:
            isPrimary ? Colors.transparent : baseColor.withOpacity(0.2),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 18, color: isPrimary ? Colors.white : baseColor),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: isPrimary ? Colors.white : baseColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}