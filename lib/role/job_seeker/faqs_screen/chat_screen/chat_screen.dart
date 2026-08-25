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
                        final item = provider.originalStatusList[index];

                        bool hasData(dynamic value) {
                          return value != null &&
                              value.toString().trim().isNotEmpty &&
                              value.toString() != "null";
                        }

                        final List<Color> accentColors = [
                          const Color(0xFFFF7A00),
                          const Color(0xFFFF6845),
                          const Color(0xFFFFB000),
                          const Color(0xFF7CB342),
                          const Color(0xFF9575CD),
                        ];

                        final List<IconData> icons = [
                          Icons.person_add_alt_1_outlined,
                          Icons.assignment_outlined,
                          Icons.description_outlined,
                          Icons.verified_user_outlined,
                          Icons.edit_document,
                        ];

                        final Color accentColor =
                        accentColors[index % accentColors.length];

                        final IconData cardIcon =
                        icons[index % icons.length];

                        final String title = hasData(item.actionNameHi)
                            ? item.actionNameHi.toString()
                            : hasData(item.actionNameEn)
                            ? item.actionNameEn.toString()
                            : "";

                        return _buildFaqCard(
                          title: title,
                          action: hasData(item.actionNameEn)
                              ? item.actionNameEn.toString()
                              : "",
                          officeName: hasData(item.officeName)
                              ? item.officeName.toString()
                              : "",
                          applicationNo: hasData(item.applicationNo)
                              ? item.applicationNo.toString()
                              : "",
                          venue: hasData(item.venue)
                              ? item.venue.toString()
                              : "",
                          inchargeName: hasData(item.inchargeName)
                              ? item.inchargeName.toString()
                              : "",
                          contactNumber: hasData(item.contactNumber)
                              ? item.contactNumber.toString()
                              : "",
                          startDate: hasData(item.startDate)
                              ? item.startDate.toString()
                              : "",
                          endDate: hasData(item.endDate)
                              ? item.endDate.toString()
                              : "",
                          eventDescription: hasData(item.eventDescription)
                              ? item.eventDescription.toString()
                              : "",
                          eventId: hasData(item.eventId)
                              ? item.eventId.toString()
                              : "",
                          accentColor: accentColor,
                          icon: cardIcon,
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

  Widget _buildFaqCard({
    required String title,
    required String action,
    required String officeName,
    required String applicationNo,
    required String venue,
    required String inchargeName,
    required String contactNumber,
    required String startDate,
    required String endDate,
    required String eventDescription,
    required String eventId,
    required Color accentColor,
    required IconData icon,
  }) {
    String formatDate(String date) {
      if (date.trim().isEmpty || date == "null") {
        return "";
      }

      try {
        return date.split('T')[0];
      } catch (_) {
        return date;
      }
    }

    final String formattedStartDate = formatDate(startDate);
    final String formattedEndDate = formatDate(endDate);

    final bool hasDate =
        formattedStartDate.isNotEmpty || formattedEndDate.isNotEmpty;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.07),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // LEFT COLORED STRIP
              Container(
                width: 5,
                color: accentColor,
              ),

              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // =========================
                      // TITLE + EVENT ID
                      // =========================
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: accentColor.withOpacity(0.10),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              icon,
                              size: 26,
                              color: accentColor,
                            ),
                          ),

                          const SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: Color(0xFF292929),
                                fontSize: 16,
                                height: 1.25,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),

                          if (eventId.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 7,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: accentColor.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                eventId,
                                style: TextStyle(
                                  color: accentColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 10),

                      // DIVIDER
                      Container(
                        height: 1,
                        color: const Color(0xFFEAEAEA),
                      ),

                      const SizedBox(height: 8),

                      // =========================
                      // ACTION
                      // =========================
                      if (action.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.touch_app_outlined,
                          label: "Action",
                          value: action,
                          iconColor: accentColor,
                        ),

                      // =========================
                      // OFFICE NAME
                      // =========================
                      if (officeName.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.business_outlined,
                          label: "Office Name",
                          value: officeName,
                          iconColor: accentColor,
                        ),

                      // =========================
                      // APPLICATION NUMBER
                      // =========================
                      if (applicationNo.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.assignment_ind_outlined,
                          label: "App No",
                          value: applicationNo,
                          iconColor: accentColor,
                        ),

                      // =========================
                      // VENUE
                      // =========================
                      if (venue.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.location_on_outlined,
                          label: "Venue",
                          value: venue,
                          iconColor: accentColor,
                        ),

                      // =========================
                      // INCHARGE
                      // =========================
                      if (inchargeName.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.person_outline,
                          label: "Incharge",
                          value: inchargeName,
                          iconColor: accentColor,
                        ),

                      // =========================
                      // CONTACT
                      // =========================
                      if (contactNumber.isNotEmpty)
                        _buildInfoRow(
                          icon: Icons.phone_outlined,
                          label: "Contact",
                          value: contactNumber,
                          iconColor: accentColor,
                        ),

                      // =========================
                      // DATE
                      // =========================
                      if (hasDate)
                        _buildInfoRow(
                          icon: Icons.calendar_month_outlined,
                          label: "Date",
                          value: hasDate
                              ? "${formattedStartDate.isNotEmpty ? formattedStartDate : "-"}"
                              " To "
                              "${formattedEndDate.isNotEmpty ? formattedEndDate : "-"}"
                              : "",
                          iconColor: accentColor,
                        ),

                      // =========================
                      // DESCRIPTION
                      // =========================
                      if (eventDescription.isNotEmpty) ...[
                        const SizedBox(height: 6),

                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF8F8F8),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 16,
                                color: accentColor,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  eventDescription,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Color(0xFF555555),
                                    fontSize: 12,
                                    height: 1.35,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
    required Color iconColor,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: iconColor,
          ),

          const SizedBox(width: 8),

          Text(
            "$label: ",
            style: const TextStyle(
              color: Color(0xFF4A4A4A),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF4A4A4A),
                fontSize: 11.5,
                fontWeight: FontWeight.w400,
                height: 1.3,
              ),
            ),
          ),
        ],
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