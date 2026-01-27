import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/departmental_schemes/provider/mysy_pending_list_provider.dart';
import '../../../utils/global.dart';
import '../../../utils/textstyles.dart';
import '../loginscreen/provider/locale_provider.dart';


class MysyPendingListScreen extends StatefulWidget {
   MysyPendingListScreen({super.key});

  @override
  State<MysyPendingListScreen> createState() => _MysyPendingListScreenState();
}

class _MysyPendingListScreenState extends State<MysyPendingListScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<MysyPendingListProvider>(context, listen: false);
      provider.clearData();
      provider.fetchSambalApplicatoinListApi(context,provider.page.toString(),provider.pageValue.toString());
    });



  }


  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2("MYSY Pending List", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),
       body: Consumer<MysyPendingListProvider>(builder: (context, provider, child) {
         return  Padding(
           padding: const EdgeInsets.all(10),
           child: ListView.builder(
             physics: const BouncingScrollPhysics(), // disable scroll inside scroll
             shrinkWrap: true, // make it take only the space needed
             itemCount: provider.pendingList.length,
             itemBuilder: (context, index) {
               final data = provider.pendingList[index];

               return InkWell(
                 onTap: () {

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
                                 0.50,
                             child: RichText(
                               text: TextSpan(
                                 style:
                                 Styles.regularTextStyle(
                                   size: 12,
                                   color: kBlackColor, // Default text color
                                 ),
                                 children: [
                                   TextSpan(
                                     text:data.fullName.toString(),
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
                                 0.35,
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
                                       text:provider.pendingList[index].schemeStatus.toString(),
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
                       hSpace(5),
                       Divider(
                         color: dividerColor,
                         height: 2,
                       ),





                       hSpace(5),
                       Row(
                         crossAxisAlignment:
                         CrossAxisAlignment.start,
                         mainAxisAlignment:
                         MainAxisAlignment.spaceBetween,
                         children: [
                           Container(
                             padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                             width: MediaQuery.of(context).size.width * 0.40,
                             child: RichText(
                               text: TextSpan(
                                 style:
                                 Styles.regularTextStyle(
                                   size: 12,
                                   color: kBlackColor, // Default text color
                                 ),
                                 children: [
                                   TextSpan(
                                     text:"Father's Name",
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
                                       text: provider.pendingList[index].fatherName.toString(),
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
                       hSpace(5),
                       Divider(
                         color: dividerColor,
                         height: 2,
                       ),


                       hSpace(5),
                       Row(
                         crossAxisAlignment:
                         CrossAxisAlignment.start,
                         mainAxisAlignment:
                         MainAxisAlignment.spaceBetween,
                         children: [
                           Container(
                             padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                             width: MediaQuery.of(context).size.width * 0.40,
                             child: RichText(
                               text: TextSpan(
                                 style:
                                 Styles.regularTextStyle(
                                   size: 12,
                                   color: kBlackColor, // Default text color
                                 ),
                                 children: [
                                   TextSpan(
                                     text:"SchemeName",
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
                                       text: provider.pendingList[index].schemeName.toString(),
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
                       hSpace(5),
                       Divider(
                         color: dividerColor,
                         height: 2,
                       ),

                       hSpace(5),
                       Row(
                         crossAxisAlignment:
                         CrossAxisAlignment.start,
                         mainAxisAlignment:
                         MainAxisAlignment.spaceBetween,
                         children: [
                           Container(
                             padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                             width: MediaQuery.of(context).size.width * 0.40,
                             child: RichText(
                               text: TextSpan(
                                 style:
                                 Styles.regularTextStyle(
                                   size: 12,
                                   color: kBlackColor, // Default text color
                                 ),
                                 children: [
                                   TextSpan(
                                     text:"AadharNo",
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
                                       text: provider.pendingList[index].aadharNo.toString(),
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
                       hSpace(5),
                       Divider(
                         color: dividerColor,
                         height: 2,
                       ),


                       hSpace(5),
                       Row(
                         crossAxisAlignment:
                         CrossAxisAlignment.start,
                         mainAxisAlignment:
                         MainAxisAlignment.spaceBetween,
                         children: [
                           Container(
                             padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                             width: MediaQuery.of(context).size.width * 0.40,
                             child: RichText(
                               text: TextSpan(
                                 style:
                                 Styles.regularTextStyle(
                                   size: 12,
                                   color: kBlackColor, // Default text color
                                 ),
                                 children: [
                                   TextSpan(
                                     text:"Gender",
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
                                       text: provider.pendingList[index].gender.toString(),
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
                       hSpace(5),
                       Divider(
                         color: dividerColor,
                         height: 2,
                       ),


                       hSpace(5),
                       Row(
                         crossAxisAlignment:
                         CrossAxisAlignment.start,
                         mainAxisAlignment:
                         MainAxisAlignment.spaceBetween,
                         children: [
                           Container(
                             padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                             width: MediaQuery.of(context).size.width * 0.40,
                             child: RichText(
                               text: TextSpan(
                                 style:
                                 Styles.regularTextStyle(
                                   size: 12,
                                   color: kBlackColor, // Default text color
                                 ),
                                 children: [
                                   TextSpan(
                                     text:"Category",
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
                                       text: provider.pendingList[index].category.toString(),
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
                       hSpace(5),
                       Divider(
                         color: dividerColor,
                         height: 2,
                       ),


                       hSpace(5),
                       Row(
                         crossAxisAlignment:
                         CrossAxisAlignment.start,
                         mainAxisAlignment:
                         MainAxisAlignment.spaceBetween,
                         children: [
                           Container(
                             padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                             width: MediaQuery.of(context).size.width * 0.40,
                             child: RichText(
                               text: TextSpan(
                                 style:
                                 Styles.regularTextStyle(
                                   size: 12,
                                   color: kBlackColor, // Default text color
                                 ),
                                 children: [
                                   TextSpan(
                                     text:"DOB",
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
                                       text: provider.pendingList[index].dOB.toString(),
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
                       hSpace(5),
                       Divider(
                         color: dividerColor,
                         height: 2,
                       ),


                       hSpace(5),
                       Row(
                         crossAxisAlignment:
                         CrossAxisAlignment.start,
                         mainAxisAlignment:
                         MainAxisAlignment.spaceBetween,
                         children: [
                           Container(
                             padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                             width: MediaQuery.of(context).size.width * 0.40,
                             child: RichText(
                               text: TextSpan(
                                 style:
                                 Styles.regularTextStyle(
                                   size: 12,
                                   color: kBlackColor, // Default text color
                                 ),
                                 children: [
                                   TextSpan(
                                     text:"Receiving Date",
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
                                       text: provider.pendingList[index].createdOn.toString(),
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
                       hSpace(5),




                     ],
                   ),
                 ),
               );
             },
           ),
         );

       }));


  }
}


