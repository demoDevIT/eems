import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/grievance/add_grievance_screen.dart';
import 'package:rajemployment/role/job_seeker/grievance/provider/grievance_list_provider.dart';
import 'package:rajemployment/role/job_seeker/job_details/job_details.dart';
import 'package:rajemployment/role/job_seeker/job_fair_event/provider/registered_event_list_provider.dart';
import 'package:rajemployment/role/job_seeker/jobpreference/provider/job_preference_provider.dart';
import 'package:rajemployment/role/job_seeker/jobs/provider/jobs_list_provider.dart';
import 'package:rajemployment/utils/dot_border.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/images.dart';

import '../../../utils/right_to_left_route.dart';
import '../../../utils/textstyles.dart';
import '../addjobpreference/add_job_preference.dart';
import '../loginscreen/provider/locale_provider.dart';

class RegisteredEventListScreen extends StatefulWidget {
   RegisteredEventListScreen({super.key});

  @override
  State<RegisteredEventListScreen> createState() => _RegisteredEventListScreenState();
}

class _RegisteredEventListScreenState extends State<RegisteredEventListScreen> {

  TextEditingController fromDateController = TextEditingController();
  TextEditingController toDateController = TextEditingController();

  DateTime? selectedFromDate;
  DateTime? selectedToDate;

  String? fromDateApi;
  String? toDateApi;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<RegisteredEventListProvider>(context, listen: false);
      provider.clearData();
      provider.allJobMatchingListApi(context);



    });
  }


  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2("Registered Events", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),

      body: Consumer<RegisteredEventListProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [

                /// 🔹 FILTER CARD
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [

                        Row(
                          children: [
                            Expanded(
                              child: _buildDateField(
                                title: "From Date",
                                controller: fromDateController,
                                onTap: () => _selectDate(context, true),
                              ),
                            ),
                            SizedBox(width: 12),
                            Expanded(
                              child: _buildDateField(
                                title: "End Date",
                                controller: toDateController,
                                onTap: () => _selectDate(context, false),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 10),

                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {

                                  if (selectedFromDate != null &&
                                      selectedToDate != null &&
                                      selectedFromDate!
                                          .isAfter(selectedToDate!)) {
                                    showAlertError(
                                        "From Date cannot be greater than End Date",
                                        context);
                                    return;
                                  }

                                  provider.allJobMatchingListApi(
                                    context,
                                    fromDate: fromDateApi,
                                    endDate: toDateApi,
                                  );
                                },
                                child: Text("Apply Filter"),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () {
                                  setState(() {
                                    fromDateController.clear();
                                    toDateController.clear();
                                    fromDateApi = null;
                                    toDateApi = null;
                                    selectedFromDate = null;
                                    selectedToDate = null;
                                  });

                                  provider.allJobMatchingListApi(context);
                                },
                                child: Text("Clear"),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 15),

                /// 🔹 EVENT LIST
                Expanded(
                  child: ListView.builder(
                    itemCount: provider.registeredEventListList.length,
                    itemBuilder: (context, index) {
                      final data = provider.registeredEventListList[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          gradient: LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.blue.shade50,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            )
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              /// 🔹 Header
                              Row(
                                children: [
                                  Icon(Icons.event, color: Colors.blue),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      data.eventNameENG ?? "",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              Divider(height: 20, thickness: 1),

                              _buildRow("Event ID", data.eventId.toString(), Icons.badge),
                              //_buildRow("Event Description", data.eventDescription.toString(), Icons.badge),
                              _buildRow("Start Date",
                                  getFormattedDate(data.startDate.toString()),
                                  Icons.calendar_today),
                              _buildRow("End Date",
                                  getFormattedDate(data.endDate.toString()),
                                  Icons.calendar_today_outlined),
                              _buildRow("Level", data.levelNameEnglish.toString(), Icons.badge),
                              _buildRow("Venue", data.venue ?? "", Icons.location_on),

                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),


      // body: Consumer<RegisteredEventListProvider>(builder: (context, provider, child) {
       //      return   Padding(
       //        padding: const EdgeInsets.all(10),
       //        child:  ListView.builder(
       //          itemCount: provider.registeredEventListList.length,
       //          itemBuilder: (context, index) {
       //            final data = provider.registeredEventListList[index];
       //            return InkWell(
       //              onTap: () {
       //
       //              },
       //              child: Container(
       //                margin: const EdgeInsets.only(bottom: 12),
       //                decoration: BoxDecoration(
       //                  gradient: index % 2 == 0 ? kWhitedGradient : jobsCardGradient,
       //                  border: Border.all(color: Colors.grey.shade300),
       //                  borderRadius: BorderRadius.circular(12),
       //                ),
       //
       //               // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
       //                child: Column(
       //                  crossAxisAlignment: CrossAxisAlignment.start,
       //                  children: [
       //
       //                    hSpace(5),
       //                    Row(
       //                      crossAxisAlignment:
       //                      CrossAxisAlignment.start,
       //                      mainAxisAlignment:
       //                      MainAxisAlignment.spaceBetween,
       //                      children: [
       //                        Container(
       //                          padding: EdgeInsets.symmetric(
       //                              horizontal: 10,
       //                              vertical: 5),
       //                          width: MediaQuery.of(context)
       //                              .size
       //                              .width *
       //                              0.40,
       //                          child: RichText(
       //                            text: TextSpan(
       //                              style:
       //                              Styles.mediumTextStyle(
       //                                size: 12,
       //                                color: kBlackColor, // Default text color
       //                              ),
       //                              children: [
       //                                TextSpan(
       //                                  text:"Event Id",
       //                                  // Normal text
       //                                  style: Styles
       //                                      .mediumTextStyle(
       //                                      size: 12,
       //                                      color: kBlackColor),
       //                                ),
       //                                TextSpan(
       //                                  text: ' :-',
       //                                  // Asterisk text
       //                                  style: Styles
       //                                      .mediumTextStyle(
       //                                      size: 12,
       //                                      color: kBlackColor),
       //                                ),
       //                              ],
       //                            ),
       //                            textAlign: TextAlign
       //                                .start, // Align text to the start
       //                          ),
       //                        ),
       //                        Container(
       //                          alignment:
       //                          Alignment.centerRight,
       //                          padding: EdgeInsets.symmetric(
       //                              horizontal: 10,
       //                              vertical: 5),
       //                          width: MediaQuery.of(context)
       //                              .size
       //                              .width *
       //                              0.45,
       //                          child: RichText(
       //                              text: TextSpan(
       //                                style: Styles
       //                                    .mediumTextStyle(
       //                                  size: 12,
       //                                  color: kBlackColor, // Default text color
       //                                ),
       //                                children: [
       //                                  TextSpan(
       //                                    text:
       //                                    provider.registeredEventListList[index].eventId.toString(),
       //                                    style: Styles
       //                                        .regularTextStyle(
       //                                        size: 12,
       //                                        color: kBlackColor),
       //                                  ),
       //                                ],
       //                              ),
       //                              textAlign: TextAlign
       //                                  .end // Align text to the start
       //                          ),
       //                        ),
       //                      ],
       //                    ),
       //                    hSpace(5),
       //                    Divider(
       //                      color: dividerColor,
       //                      height: 2,
       //                    ),
       //
       //
       //                    hSpace(5),
       //                    Row(
       //                      crossAxisAlignment:
       //                      CrossAxisAlignment.start,
       //                      mainAxisAlignment:
       //                      MainAxisAlignment.spaceBetween,
       //                      children: [
       //                        Container(
       //                          padding: EdgeInsets.symmetric(
       //                              horizontal: 10,
       //                              vertical: 5),
       //                          width: MediaQuery.of(context)
       //                              .size
       //                              .width *
       //                              0.40,
       //                          child: RichText(
       //                            text: TextSpan(
       //                              style:
       //                              Styles.mediumTextStyle(
       //                                size: 12,
       //                                color: kBlackColor, // Default text color
       //                              ),
       //                              children: [
       //                                TextSpan(
       //                                  text:"Event Name",
       //                                  // Normal text
       //                                  style: Styles
       //                                      .mediumTextStyle(
       //                                      size: 12,
       //                                      color: kBlackColor),
       //                                ),
       //                                TextSpan(
       //                                  text: ' :-',
       //                                  // Asterisk text
       //                                  style: Styles
       //                                      .mediumTextStyle(
       //                                      size: 12,
       //                                      color: kBlackColor),
       //                                ),
       //                              ],
       //                            ),
       //                            textAlign: TextAlign
       //                                .start, // Align text to the start
       //                          ),
       //                        ),
       //                        Container(
       //                          alignment:
       //                          Alignment.centerRight,
       //                          padding: EdgeInsets.symmetric(
       //                              horizontal: 10,
       //                              vertical: 5),
       //                          width: MediaQuery.of(context)
       //                              .size
       //                              .width *
       //                              0.45,
       //                          child: RichText(
       //                              text: TextSpan(
       //                                style: Styles
       //                                    .mediumTextStyle(
       //                                  size: 12,
       //                                  color: kBlackColor, // Default text color
       //                                ),
       //                                children: [
       //                                  TextSpan(
       //                                    text:
       //                                    localeProvider.currentLanguage == "en" ? provider.registeredEventListList[index].eventNameENG.toString() : provider.registeredEventListList[index].eventNameHI.toString(),
       //                                    style: Styles
       //                                        .regularTextStyle(
       //                                        size: 12,
       //                                        color: kBlackColor),
       //                                  ),
       //                                ],
       //                              ),
       //                              textAlign: TextAlign
       //                                  .end // Align text to the start
       //                          ),
       //                        ),
       //                      ],
       //                    ),
       //                    hSpace(5),
       //                    Divider(
       //                      color: dividerColor,
       //                      height: 2,
       //                    ),
       //
       //                    hSpace(5),
       //                    Row(
       //                      crossAxisAlignment:
       //                      CrossAxisAlignment.start,
       //                      mainAxisAlignment:
       //                      MainAxisAlignment.spaceBetween,
       //                      children: [
       //                        Container(
       //                          padding: EdgeInsets.symmetric(
       //                              horizontal: 10,
       //                              vertical: 5),
       //                          width: MediaQuery.of(context)
       //                              .size
       //                              .width *
       //                              0.40,
       //                          child: RichText(
       //                            text: TextSpan(
       //                              style:
       //                              Styles.mediumTextStyle(
       //                                size: 12,
       //                                color: kBlackColor, // Default text color
       //                              ),
       //                              children: [
       //                                TextSpan(
       //                                  text:"Event Description",
       //                                  // Normal text
       //                                  style: Styles
       //                                      .mediumTextStyle(
       //                                      size: 12,
       //                                      color: kBlackColor),
       //                                ),
       //                                TextSpan(
       //                                  text: ' :-',
       //                                  // Asterisk text
       //                                  style: Styles
       //                                      .mediumTextStyle(
       //                                      size: 12,
       //                                      color: kBlackColor),
       //                                ),
       //                              ],
       //                            ),
       //                            textAlign: TextAlign
       //                                .start, // Align text to the start
       //                          ),
       //                        ),
       //                        Container(
       //                          alignment:
       //                          Alignment.centerRight,
       //                          padding: EdgeInsets.symmetric(
       //                              horizontal: 10,
       //                              vertical: 5),
       //                          width: MediaQuery.of(context)
       //                              .size
       //                              .width *
       //                              0.45,
       //                          child: RichText(
       //                              text: TextSpan(
       //                                style: Styles
       //                                    .mediumTextStyle(
       //                                  size: 12,
       //                                  color: kBlackColor, // Default text color
       //                                ),
       //                                children: [
       //                                  TextSpan(
       //                                    text:
       //                                    provider.registeredEventListList[index].eventDescription.toString(),
       //                                    style: Styles
       //                                        .regularTextStyle(
       //                                        size: 12,
       //                                        color: kBlackColor),
       //                                  ),
       //                                ],
       //                              ),
       //                              textAlign: TextAlign
       //                                  .end // Align text to the start
       //                          ),
       //                        ),
       //                      ],
       //                    ),
       //                    hSpace(5),
       //                    Divider(
       //                      color: dividerColor,
       //                      height: 2,
       //                    ),
       //
       //                    hSpace(5),
       //                    Row(
       //                      crossAxisAlignment:
       //                      CrossAxisAlignment.start,
       //                      mainAxisAlignment:
       //                      MainAxisAlignment.spaceBetween,
       //                      children: [
       //                        Container(
       //                          padding: EdgeInsets.symmetric(
       //                              horizontal: 10,
       //                              vertical: 5),
       //                          width: MediaQuery.of(context)
       //                              .size
       //                              .width *
       //                              0.40,
       //                          child: RichText(
       //                            text: TextSpan(
       //                              style:
       //                              Styles.mediumTextStyle(
       //                                size: 12,
       //                                color: kBlackColor, // Default text color
       //                              ),
       //                              children: [
       //                                TextSpan(
       //                                  text:"Start Date",
       //                                  // Normal text
       //                                  style: Styles
       //                                      .mediumTextStyle(
       //                                      size: 12,
       //                                      color: kBlackColor),
       //                                ),
       //                                TextSpan(
       //                                  text: ' :-',
       //                                  // Asterisk text
       //                                  style: Styles
       //                                      .mediumTextStyle(
       //                                      size: 12,
       //                                      color: kBlackColor),
       //                                ),
       //                              ],
       //                            ),
       //                            textAlign: TextAlign
       //                                .start, // Align text to the start
       //                          ),
       //                        ),
       //                        Container(
       //                          alignment:
       //                          Alignment.centerRight,
       //                          padding: EdgeInsets.symmetric(
       //                              horizontal: 10,
       //                              vertical: 5),
       //                          width: MediaQuery.of(context)
       //                              .size
       //                              .width *
       //                              0.45,
       //                          child: RichText(
       //                              text: TextSpan(
       //                                style: Styles
       //                                    .mediumTextStyle(
       //                                  size: 12,
       //                                  color: kBlackColor, // Default text color
       //                                ),
       //                                children: [
       //                                  TextSpan(
       //                                    text:getFormattedDate(provider.registeredEventListList[index].startDate.toString()),
       //                                    style: Styles
       //                                        .regularTextStyle(
       //                                        size: 12,
       //                                        color: kBlackColor),
       //                                  ),
       //                                ],
       //                              ),
       //                              textAlign: TextAlign
       //                                  .end // Align text to the start
       //                          ),
       //                        ),
       //                      ],
       //                    ),
       //                    hSpace(5),
       //                    Divider(
       //                      color: dividerColor,
       //                      height: 2,
       //                    ),
       //
       //                    hSpace(5),
       //                    Row(
       //                      crossAxisAlignment:
       //                      CrossAxisAlignment.start,
       //                      mainAxisAlignment:
       //                      MainAxisAlignment.spaceBetween,
       //                      children: [
       //                        Container(
       //                          padding: EdgeInsets.symmetric(
       //                              horizontal: 10,
       //                              vertical: 5),
       //                          width: MediaQuery.of(context)
       //                              .size
       //                              .width *
       //                              0.40,
       //                          child: RichText(
       //                            text: TextSpan(
       //                              style:
       //                              Styles.mediumTextStyle(
       //                                size: 12,
       //                                color: kBlackColor, // Default text color
       //                              ),
       //                              children: [
       //                                TextSpan(
       //                                  text:"End Date",
       //                                  // Normal text
       //                                  style: Styles
       //                                      .mediumTextStyle(
       //                                      size: 12,
       //                                      color: kBlackColor),
       //                                ),
       //                                TextSpan(
       //                                  text: ' :-',
       //                                  // Asterisk text
       //                                  style: Styles
       //                                      .mediumTextStyle(
       //                                      size: 12,
       //                                      color: kBlackColor),
       //                                ),
       //                              ],
       //                            ),
       //                            textAlign: TextAlign
       //                                .start, // Align text to the start
       //                          ),
       //                        ),
       //                        Container(
       //                          alignment:
       //                          Alignment.centerRight,
       //                          padding: EdgeInsets.symmetric(
       //                              horizontal: 10,
       //                              vertical: 5),
       //                          width: MediaQuery.of(context)
       //                              .size
       //                              .width *
       //                              0.45,
       //                          child: RichText(
       //                              text: TextSpan(
       //                                style: Styles
       //                                    .mediumTextStyle(
       //                                  size: 12,
       //                                  color: kBlackColor, // Default text color
       //                                ),
       //                                children: [
       //                                  TextSpan(
       //                                    text:getFormattedDate(provider.registeredEventListList[index].endDate.toString()),
       //                                    style: Styles
       //                                        .regularTextStyle(
       //                                        size: 12,
       //                                        color: kBlackColor),
       //                                  ),
       //                                ],
       //                              ),
       //                              textAlign: TextAlign
       //                                  .end // Align text to the start
       //                          ),
       //                        ),
       //                      ],
       //                    ),
       //                    hSpace(5),
       //                    Divider(
       //                      color: dividerColor,
       //                      height: 2,
       //                    ),
       //
       //                    hSpace(5),
       //                    Row(
       //                      crossAxisAlignment:
       //                      CrossAxisAlignment.start,
       //                      mainAxisAlignment:
       //                      MainAxisAlignment.spaceBetween,
       //                      children: [
       //                        Container(
       //                          padding: EdgeInsets.symmetric(
       //                              horizontal: 10,
       //                              vertical: 5),
       //                          width: MediaQuery.of(context)
       //                              .size
       //                              .width *
       //                              0.40,
       //                          child: RichText(
       //                            text: TextSpan(
       //                              style:
       //                              Styles.mediumTextStyle(
       //                                size: 12,
       //                                color: kBlackColor, // Default text color
       //                              ),
       //                              children: [
       //                                TextSpan(
       //                                  text:"Level",
       //                                  // Normal text
       //                                  style: Styles
       //                                      .mediumTextStyle(
       //                                      size: 12,
       //                                      color: kBlackColor),
       //                                ),
       //                                TextSpan(
       //                                  text: ' :-',
       //                                  // Asterisk text
       //                                  style: Styles
       //                                      .mediumTextStyle(
       //                                      size: 12,
       //                                      color: kBlackColor),
       //                                ),
       //                              ],
       //                            ),
       //                            textAlign: TextAlign
       //                                .start, // Align text to the start
       //                          ),
       //                        ),
       //                        Container(
       //                          alignment:
       //                          Alignment.centerRight,
       //                          padding: EdgeInsets.symmetric(
       //                              horizontal: 10,
       //                              vertical: 5),
       //                          width: MediaQuery.of(context)
       //                              .size
       //                              .width *
       //                              0.45,
       //                          child: RichText(
       //                              text: TextSpan(
       //                                style: Styles
       //                                    .mediumTextStyle(
       //                                  size: 12,
       //                                  color: kBlackColor, // Default text color
       //                                ),
       //                                children: [
       //                                  TextSpan(
       //                                    text:
       //                                    provider.registeredEventListList[index].levelNameEnglish.toString(),
       //                                    style: Styles
       //                                        .regularTextStyle(
       //                                        size: 12,
       //                                        color: kBlackColor),
       //                                  ),
       //                                ],
       //                              ),
       //                              textAlign: TextAlign
       //                                  .end // Align text to the start
       //                          ),
       //                        ),
       //                      ],
       //                    ),
       //                    hSpace(5),
       //                    Divider(
       //                      color: dividerColor,
       //                      height: 2,
       //                    ),
       //
       //                    hSpace(5),
       //                    Row(
       //                      crossAxisAlignment:
       //                      CrossAxisAlignment.start,
       //                      mainAxisAlignment:
       //                      MainAxisAlignment.spaceBetween,
       //                      children: [
       //                        Container(
       //                          padding: EdgeInsets.symmetric(
       //                              horizontal: 10,
       //                              vertical: 5),
       //                          width: MediaQuery.of(context)
       //                              .size
       //                              .width *
       //                              0.40,
       //                          child: RichText(
       //                            text: TextSpan(
       //                              style:
       //                              Styles.mediumTextStyle(
       //                                size: 12,
       //                                color: kBlackColor, // Default text color
       //                              ),
       //                              children: [
       //                                TextSpan(
       //                                  text:"Venue",
       //                                  // Normal text
       //                                  style: Styles
       //                                      .mediumTextStyle(
       //                                      size: 12,
       //                                      color: kBlackColor),
       //                                ),
       //                                TextSpan(
       //                                  text: ' :-',
       //                                  // Asterisk text
       //                                  style: Styles
       //                                      .mediumTextStyle(
       //                                      size: 12,
       //                                      color: kBlackColor),
       //                                ),
       //                              ],
       //                            ),
       //                            textAlign: TextAlign
       //                                .start, // Align text to the start
       //                          ),
       //                        ),
       //                        Container(
       //                          alignment:
       //                          Alignment.centerRight,
       //                          padding: EdgeInsets.symmetric(
       //                              horizontal: 10,
       //                              vertical: 5),
       //                          width: MediaQuery.of(context)
       //                              .size
       //                              .width *
       //                              0.45,
       //                          child: RichText(
       //                              text: TextSpan(
       //                                style: Styles
       //                                    .mediumTextStyle(
       //                                  size: 12,
       //                                  color: kBlackColor, // Default text color
       //                                ),
       //                                children: [
       //                                  TextSpan(
       //                                    text:
       //                                    provider.registeredEventListList[index].venue.toString(),
       //                                    style: Styles
       //                                        .regularTextStyle(
       //                                        size: 12,
       //                                        color: kBlackColor),
       //                                  ),
       //                                ],
       //                              ),
       //                              textAlign: TextAlign
       //                                  .end // Align text to the start
       //                          ),
       //                        ),
       //                      ],
       //                    ),
       //                    hSpace(5),
       //                    Divider(
       //                      color: dividerColor,
       //                      height: 2,
       //                    ),
       //
       //                    hSpace(5),
       //                    Row(
       //                      crossAxisAlignment:
       //                      CrossAxisAlignment.start,
       //                      mainAxisAlignment:
       //                      MainAxisAlignment.spaceBetween,
       //                      children: [
       //                        Container(
       //                          padding: EdgeInsets.symmetric(
       //                              horizontal: 10,
       //                              vertical: 5),
       //                          width: MediaQuery.of(context)
       //                              .size
       //                              .width *
       //                              0.40,
       //                          child: RichText(
       //                            text: TextSpan(
       //                              style:
       //                              Styles.mediumTextStyle(
       //                                size: 12,
       //                                color: kBlackColor, // Default text color
       //                              ),
       //                              children: [
       //                                TextSpan(
       //                                  text:"Get Pass",
       //                                  // Normal text
       //                                  style: Styles
       //                                      .mediumTextStyle(
       //                                      size: 12,
       //                                      color: kBlackColor),
       //                                ),
       //                                TextSpan(
       //                                  text: ' :-',
       //                                  // Asterisk text
       //                                  style: Styles
       //                                      .mediumTextStyle(
       //                                      size: 12,
       //                                      color: kBlackColor),
       //                                ),
       //                              ],
       //                            ),
       //                            textAlign: TextAlign
       //                                .start, // Align text to the start
       //                          ),
       //                        ),
       //                        Container(
       //                          alignment:
       //                          Alignment.centerRight,
       //                          padding: EdgeInsets.symmetric(
       //                              horizontal: 10,
       //                              vertical: 5),
       //                          width: MediaQuery.of(context)
       //                              .size
       //                              .width *
       //                              0.45,
       //                          child: Icon(Icons.visibility,color: kbuttonColor,)
       //                        ),
       //                      ],
       //                    ),
       //                    hSpace(5),
       //                    Divider(
       //                      color: dividerColor,
       //                      height: 2,
       //                    ),
       //
       //
       //
       //                  ],
       //                ),
       //              ),
       //            );
       //          },
       //        ),
       //      );
       //    })

    );

    //147664


    //pending//62664


  }

  Widget _buildDateField({
    required String title,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.blue.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.calendar_today,
                size: 16,
                color: Colors.blue.shade700,
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueGrey,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    controller.text.isEmpty
                        ? "Select Date"
                        : controller.text,
                    style: TextStyle(
                      fontSize: 13,
                      color: controller.text.isEmpty
                          ? Colors.grey
                          : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.blueGrey),
          SizedBox(width: 8),
          Expanded(
            flex: 4,
            child: Text(
              "$label :",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            flex: 6,
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13,
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    DateTime initialDate = DateTime.now();

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        String formattedDisplay = DateFormat("dd-MM-yyyy").format(picked);
        String formattedApi = DateFormat("yyyy-MM-dd").format(picked);

        if (isFromDate) {
          selectedFromDate = picked;
          fromDateController.text = formattedDisplay;
          fromDateApi = formattedApi;
        } else {
          selectedToDate = picked;
          toDateController.text = formattedDisplay;
          toDateApi = formattedApi;
        }
      });
    }
  }

}


