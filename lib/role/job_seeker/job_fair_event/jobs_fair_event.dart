import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/job_fair_event/provider/jobs_fair_event_provider.dart';
import '../../../utils/global.dart';
import '../../../utils/right_to_left_route.dart';
import '../../../utils/textstyles.dart';
import '../loginscreen/provider/locale_provider.dart';
import 'job_fair_event_details.dart';

class JobsFairEventScreen extends StatefulWidget {
   JobsFairEventScreen({super.key});

  @override
  State<JobsFairEventScreen> createState() => _JobsFairEventScreenState();
}

class _JobsFairEventScreenState extends State<JobsFairEventScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final jobsFairEventProvider = Provider.of<JobsFairEventProvider>(context, listen: false);
    jobsFairEventProvider.allJobMatchingListApi(context);

  }


  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2("Jobs Fair Event", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),
       body: Consumer<JobsFairEventProvider>(builder: (context, provider, child) {
         return Column(
           children: [
             // Top two-tab style header
             Container(
               height: 60,
               width: MediaQuery.of(context).size.width ,
               color: kJobCardColor,
               child: Row(
                 crossAxisAlignment: CrossAxisAlignment.center,
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                   InkWell(
                     onTap: () {
                       setState(() {
                         provider.tab = true;
                         provider.allJobMatchingListApi(context);
                       });
                     },
                     child: Container(
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(5),
                         color: provider.tab == true ? kbuttonColor : kLightGrayColor,
                       ),
                       width: MediaQuery.of(context).size.width * 0.90  / 2,
                       height: 40,

                       alignment: Alignment.center,
                       child: Text(
                         "Current Events",
                         style: Styles.semiBoldTextStyle(size: 15, color: provider.tab == true ? kWhite : kbuttonColor,),
                       ),
                     ),
                   ),
                   InkWell(
                     onTap: () {
                       setState(() {
                         provider.tab = false;
                         provider.allJobMatchingListApi(context);
                       });
                     },
                     child: Container(
                       height: 40,
                       width: MediaQuery.of(context).size.width * 0.90  / 2,
                       decoration: BoxDecoration(
                         borderRadius: BorderRadius.circular(5),
                         color: provider.tab == false ? kbuttonColor : kLightGrayColor,
                       ),
                       alignment: Alignment.center,
                       child: Text(
                         "Upcoming Events",
                         style: Styles.semiBoldTextStyle(size: 15, color: provider.tab == false ? kWhite : kbuttonColor,),                       ),
                     ),
                   ),
                 ],
               ),
             ),

             // List section
             Expanded(
               child: Padding(
                 padding: const EdgeInsets.all(16.0),
                 child:provider.tab == true ? ListView.builder(
                   physics: const BouncingScrollPhysics(), // disable scroll inside scroll
                   shrinkWrap: true, // make it take only the space needed
                   itemCount: provider.currentEventList.length,
                   itemBuilder: (context, index) {
                     final data = provider.currentEventList[index];

                     return InkWell(
                       onTap: () {
                         Navigator.of(context).push(
                           RightToLeftRoute(
                             page: JobFairEventDetailsScreen(runningEventData: data,),
                             duration: const Duration(milliseconds: 500),
                             startOffset: const Offset(-1.0, 0.0),
                           ),
                         );
                       },
                       child: Container(
                         margin: const EdgeInsets.only(bottom: 12),
                         padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                         decoration: BoxDecoration(
                           gradient: index.isEven ? kWhitedGradient : jobsCardGradient,
                           border: Border.all(color: green46A500),
                           borderRadius: BorderRadius.circular(12),
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             // Name & Type
                             hSpace(5),

                             Row(
                               crossAxisAlignment:
                               CrossAxisAlignment.start,
                               mainAxisAlignment:
                               MainAxisAlignment.spaceBetween,
                               children: [
                                 Container(
                                   padding: EdgeInsets.symmetric(
                                       horizontal: 0,
                                       vertical: 5),
                                   width: MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.70,
                                   child: RichText(
                                     text: TextSpan(
                                       style:
                                       Styles.regularTextStyle(
                                         size: 12,
                                         color: kBlackColor, // Default text color
                                       ),
                                       children: [
                                         TextSpan(
                                           text:localeProvider.currentLanguage == "en" ?  data.eventNameENG.toString() : data.eventNameHI.toString(),
                                           // Normal text
                                           style: Styles
                                               .semiBoldTextStyle(
                                               size: 14,
                                               color: kBlackColor),
                                         ),
                                         TextSpan(
                                           text: '',
                                           // Asterisk text
                                           style: Styles
                                               .semiBoldTextStyle(
                                               size: 14,
                                               color: kBlackColor),
                                         ),
                                       ],
                                     ),
                                     textAlign: TextAlign
                                         .start, // Align text to the start
                                   ),
                                 ),
                                 Container(
                                   alignment:
                                   Alignment.center,
                                   padding: EdgeInsets.symmetric(
                                       horizontal: 0,
                                       vertical: 5),
                                   width: MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.15,
                                   decoration: BoxDecoration(
                                     color: kJobFlotBackColor,
                                     borderRadius: BorderRadius.circular(5),
                                   ),
                                   child: RichText(
                                       text: TextSpan(
                                         style: Styles
                                             .regularTextStyle(
                                           size: 12,
                                           color: kBlackColor, // Default text color
                                         ),
                                         children: [
                                           TextSpan(
                                             text:"Current",
                                             style: Styles
                                                 .regularTextStyle(
                                                 size: 12,
                                                 color: kJobFontColor),
                                           ),
                                         ],
                                       ),
                                       textAlign: TextAlign
                                           .end // Align text to the start
                                   ),
                                 ),
                               ],
                             ),

                             Row(
                               crossAxisAlignment:
                               CrossAxisAlignment.start,
                               mainAxisAlignment:
                               MainAxisAlignment.spaceBetween,
                               children: [
                                 Container(
                                   padding: EdgeInsets.symmetric(
                                       horizontal: 0,
                                       vertical: 5),
                                   width: MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.85,
                                   child: RichText(
                                     text: TextSpan(
                                       style:
                                       Styles.regularTextStyle(
                                         size: 12,
                                         color: fontGrayColor, // Default text color
                                       ),
                                       children: [
                                         TextSpan(
                                           text: data.eventDescription.toString(),
                                           // Normal text
                                           style: Styles
                                               .regularTextStyle(
                                               size: 12,
                                               color: fontGrayColor),
                                         ),
                                         TextSpan(
                                           text: '',
                                           // Asterisk text
                                           style: Styles
                                               .regularTextStyle(
                                               size: 12,
                                               color: fontGrayColor),
                                         ),
                                       ],
                                     ),
                                     textAlign: TextAlign
                                         .start, // Align text to the start
                                   ),
                                 ),

                               ],
                             ),

                             Row(
                               crossAxisAlignment:
                               CrossAxisAlignment.start,
                               mainAxisAlignment:
                               MainAxisAlignment.spaceBetween,
                               children: [
                                 Container(
                                   padding: EdgeInsets.symmetric(
                                       horizontal: 0,
                                       vertical: 5),
                                   width: MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.40,
                                   child: RichText(
                                     text: TextSpan(
                                       style:
                                       Styles.regularTextStyle(
                                         size: 12,
                                         color: kBlackColor, // Default text color
                                       ),
                                       children: [
                                         TextSpan(
                                           text:"In charge Name",
                                           // Normal text
                                           style: Styles
                                               .regularTextStyle(
                                               size: 12,
                                               color: fontGrayColor),
                                         ),
                                         TextSpan(
                                           text: ' : ',
                                           // Asterisk text
                                           style: Styles
                                               .regularTextStyle(
                                               size: 12,
                                               color: fontGrayColor),
                                         ),
                                       ],
                                     ),
                                     textAlign: TextAlign
                                         .start, // Align text to the start
                                   ),
                                 ),
                                 Container(
                                   alignment:
                                   Alignment.centerRight,
                                   padding: EdgeInsets.symmetric(
                                       horizontal: 0,
                                       vertical: 5),
                                   width: MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.45,
                                   child: RichText(
                                       text: TextSpan(
                                         style: Styles
                                             .regularTextStyle(
                                           size: 12,
                                           color: kBlackColor, // Default text color
                                         ),
                                         children: [
                                           TextSpan(
                                             text:
                                             data.inchargeName.toString(),
                                             style: Styles
                                                 .regularTextStyle(
                                                 size: 12,
                                                 color: fontGrayColor),
                                           ),
                                         ],
                                       ),
                                       textAlign: TextAlign
                                           .end // Align text to the start
                                   ),
                                 ),
                               ],
                             ),

                             Row(
                               crossAxisAlignment:
                               CrossAxisAlignment.start,
                               mainAxisAlignment:
                               MainAxisAlignment.spaceBetween,
                               children: [
                                 Container(
                                   padding: EdgeInsets.symmetric(
                                       horizontal: 0,
                                       vertical: 5),
                                   width: MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.40,
                                   child: RichText(
                                     text: TextSpan(
                                       style:
                                       Styles.mediumTextStyle(
                                         size: 12,
                                         color: kBlackColor, // Default text color
                                       ),
                                       children: [
                                         TextSpan(
                                           text:getFormattedDate(data.startDate.toString()),
                                           // Normal text
                                           style: Styles
                                               .regularTextStyle(
                                               size: 13,
                                               color: kRedColor),
                                         ),
                                         TextSpan(
                                           text: '',
                                           // Asterisk text
                                           style: Styles
                                               .regularTextStyle(
                                               size: 12,
                                               color: fontGrayColor),
                                         ),
                                       ],
                                     ),
                                     textAlign: TextAlign
                                         .start, // Align text to the start
                                   ),
                                 ),
                                 Container(
                                   alignment:
                                   Alignment.centerRight,
                                   padding: EdgeInsets.symmetric(
                                       horizontal: 0,
                                       vertical: 5),
                                   width: MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.45,
                                   child: RichText(
                                       text: TextSpan(
                                         style: Styles
                                             .regularTextStyle(
                                           size: 12,
                                           color: kBlackColor, // Default text color
                                         ),
                                         children: [
                                           TextSpan(
                                             text:
                                             getFormattedDate(data.endDate.toString()),
                                             style: Styles
                                                 .regularTextStyle(
                                                 size: 13,
                                                 color: kRedColor),
                                           ),
                                         ],
                                       ),
                                       textAlign: TextAlign
                                           .end // Align text to the start
                                   ),
                                 ),
                               ],
                             ),




                           ],
                         ),
                       ),
                     );
                   },
                 ) :  ListView.builder(
                   physics: const BouncingScrollPhysics(), // disable scroll inside scroll
                   shrinkWrap: true, // make it take only the space needed
                   itemCount: provider.upcomingList.length,
                   itemBuilder: (context, index) {
                     final data = provider.upcomingList[index];

                     return InkWell(
                       onTap: () {
                         Navigator.of(context).push(
                           RightToLeftRoute(
                             page: JobFairEventDetailsScreen(runningEventData: data,),
                             duration: const Duration(milliseconds: 500),
                             startOffset: const Offset(-1.0, 0.0),
                           ),
                         );
                       },
                       child: Container(
                         margin: const EdgeInsets.only(bottom: 12),
                         padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                         decoration: BoxDecoration(
                           gradient: index.isEven ? kWhitedGradient : jobsCardGradient,
                           border: Border.all(color: green46A500),
                           borderRadius: BorderRadius.circular(12),
                         ),
                         child: Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             // Name & Type
                             hSpace(5),

                             Row(
                               crossAxisAlignment:
                               CrossAxisAlignment.start,
                               mainAxisAlignment:
                               MainAxisAlignment.spaceBetween,
                               children: [
                                 Container(
                                   padding: EdgeInsets.symmetric(
                                       horizontal: 0,
                                       vertical: 5),
                                   width: MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.70,
                                   child: RichText(
                                     text: TextSpan(
                                       style:
                                       Styles.regularTextStyle(
                                         size: 12,
                                         color: kBlackColor, // Default text color
                                       ),
                                       children: [
                                         TextSpan(
                                           text:localeProvider.currentLanguage == "en" ?  data.eventNameENG.toString() : data.eventNameHI.toString(),
                                           // Normal text
                                           style: Styles
                                               .semiBoldTextStyle(
                                               size: 14,
                                               color: kBlackColor),
                                         ),
                                         TextSpan(
                                           text: '',
                                           // Asterisk text
                                           style: Styles
                                               .semiBoldTextStyle(
                                               size: 14,
                                               color: kBlackColor),
                                         ),
                                       ],
                                     ),
                                     textAlign: TextAlign
                                         .start, // Align text to the start
                                   ),
                                 ),
                                 Container(
                                   alignment:
                                   Alignment.center,
                                   padding: EdgeInsets.symmetric(
                                       horizontal: 0,
                                       vertical: 5),
                                   width: MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.15,
                                   decoration: BoxDecoration(
                                     color: kJobFlotBackColor,
                                     borderRadius: BorderRadius.circular(5),
                                   ),
                                   child: RichText(
                                       text: TextSpan(
                                         style: Styles
                                             .regularTextStyle(
                                           size: 12,
                                           color: kBlackColor, // Default text color
                                         ),
                                         children: [
                                           TextSpan(
                                             text:"Current",
                                             style: Styles
                                                 .regularTextStyle(
                                                 size: 12,
                                                 color: kJobFontColor),
                                           ),
                                         ],
                                       ),
                                       textAlign: TextAlign
                                           .end // Align text to the start
                                   ),
                                 ),
                               ],
                             ),

                             Row(
                               crossAxisAlignment:
                               CrossAxisAlignment.start,
                               mainAxisAlignment:
                               MainAxisAlignment.spaceBetween,
                               children: [
                                 Container(
                                   padding: EdgeInsets.symmetric(
                                       horizontal: 0,
                                       vertical: 5),
                                   width: MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.85,
                                   child: RichText(
                                     text: TextSpan(
                                       style:
                                       Styles.regularTextStyle(
                                         size: 12,
                                         color: fontGrayColor, // Default text color
                                       ),
                                       children: [
                                         TextSpan(
                                           text: data.eventDescription.toString(),
                                           // Normal text
                                           style: Styles
                                               .regularTextStyle(
                                               size: 12,
                                               color: fontGrayColor),
                                         ),
                                         TextSpan(
                                           text: '',
                                           // Asterisk text
                                           style: Styles
                                               .regularTextStyle(
                                               size: 12,
                                               color: fontGrayColor),
                                         ),
                                       ],
                                     ),
                                     textAlign: TextAlign
                                         .start, // Align text to the start
                                   ),
                                 ),

                               ],
                             ),

                             Row(
                               crossAxisAlignment:
                               CrossAxisAlignment.start,
                               mainAxisAlignment:
                               MainAxisAlignment.spaceBetween,
                               children: [
                                 Container(
                                   padding: EdgeInsets.symmetric(
                                       horizontal: 0,
                                       vertical: 5),
                                   width: MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.40,
                                   child: RichText(
                                     text: TextSpan(
                                       style:
                                       Styles.regularTextStyle(
                                         size: 12,
                                         color: kBlackColor, // Default text color
                                       ),
                                       children: [
                                         TextSpan(
                                           text:"In charge Name",
                                           // Normal text
                                           style: Styles
                                               .regularTextStyle(
                                               size: 12,
                                               color: fontGrayColor),
                                         ),
                                         TextSpan(
                                           text: ' : ',
                                           // Asterisk text
                                           style: Styles
                                               .regularTextStyle(
                                               size: 12,
                                               color: fontGrayColor),
                                         ),
                                       ],
                                     ),
                                     textAlign: TextAlign
                                         .start, // Align text to the start
                                   ),
                                 ),
                                 Container(
                                   alignment:
                                   Alignment.centerRight,
                                   padding: EdgeInsets.symmetric(
                                       horizontal: 0,
                                       vertical: 5),
                                   width: MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.45,
                                   child: RichText(
                                       text: TextSpan(
                                         style: Styles
                                             .regularTextStyle(
                                           size: 12,
                                           color: kBlackColor, // Default text color
                                         ),
                                         children: [
                                           TextSpan(
                                             text:
                                             data.inchargeName.toString(),
                                             style: Styles
                                                 .regularTextStyle(
                                                 size: 12,
                                                 color: fontGrayColor),
                                           ),
                                         ],
                                       ),
                                       textAlign: TextAlign
                                           .end // Align text to the start
                                   ),
                                 ),
                               ],
                             ),

                             Row(
                               crossAxisAlignment:
                               CrossAxisAlignment.start,
                               mainAxisAlignment:
                               MainAxisAlignment.spaceBetween,
                               children: [
                                 Container(
                                   padding: EdgeInsets.symmetric(
                                       horizontal: 0,
                                       vertical: 5),
                                   width: MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.40,
                                   child: RichText(
                                     text: TextSpan(
                                       style:
                                       Styles.mediumTextStyle(
                                         size: 12,
                                         color: kBlackColor, // Default text color
                                       ),
                                       children: [
                                         TextSpan(
                                           text:getFormattedDate(data.startDate.toString()),
                                           // Normal text
                                           style: Styles
                                               .regularTextStyle(
                                               size: 13,
                                               color: kRedColor),
                                         ),
                                         TextSpan(
                                           text: '',
                                           // Asterisk text
                                           style: Styles
                                               .regularTextStyle(
                                               size: 12,
                                               color: fontGrayColor),
                                         ),
                                       ],
                                     ),
                                     textAlign: TextAlign
                                         .start, // Align text to the start
                                   ),
                                 ),
                                 Container(
                                   alignment:
                                   Alignment.centerRight,
                                   padding: EdgeInsets.symmetric(
                                       horizontal: 0,
                                       vertical: 5),
                                   width: MediaQuery.of(context)
                                       .size
                                       .width *
                                       0.45,
                                   child: RichText(
                                       text: TextSpan(
                                         style: Styles
                                             .regularTextStyle(
                                           size: 12,
                                           color: kBlackColor, // Default text color
                                         ),
                                         children: [
                                           TextSpan(
                                             text:
                                             getFormattedDate(data.endDate.toString()),
                                             style: Styles
                                                 .regularTextStyle(
                                                 size: 13,
                                                 color: kRedColor),
                                           ),
                                         ],
                                       ),
                                       textAlign: TextAlign
                                           .end // Align text to the start
                                   ),
                                 ),
                               ],
                             ),




                           ],
                         ),
                       ),
                     );
                   },
                 ),
               ),
             ),
           ],
         );

       }));


  }
}


