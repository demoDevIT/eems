import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import '../../../../utils/global.dart';
import '../../../../utils/images.dart';
import '../../../../utils/size_config.dart';
import '../../../../utils/textstyles.dart';
import '../../../job_seeker/loginscreen/provider/locale_provider.dart';
import '../provider/counselor_provider.dart';

class CounselorHomeScreen extends StatefulWidget {
   CounselorHomeScreen({super.key});

  @override
  State<CounselorHomeScreen> createState() => _CounselorHomeScreenState();
}

class _CounselorHomeScreenState extends State<CounselorHomeScreen> {


  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(

       body: Consumer<CounselorProvider>(builder: (context, provider, child) {
         return Padding(
           padding: const EdgeInsets.all(12),
           child: ListView.builder(
             physics: const BouncingScrollPhysics(), // disable scroll inside scroll
             shrinkWrap: true, // make it take only the space needed
             itemCount: provider.dataList.length,
             itemBuilder: (context, index) {
               final edu = provider.dataList[index];
               final bgColor = provider.backgroundColors[index % provider.backgroundColors.length];
               final iconBgColor = provider.iconBgColors[index % provider.iconBgColors.length];


               return InkWell(
                 onTap: () {

                 },
                 child: Container(
                   margin: const EdgeInsets.only(bottom: 12),
                   decoration: BoxDecoration(
                     color: bgColor,
                     borderRadius: BorderRadius.circular(10),
                   ),
                   child: Padding(
                     padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 30),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         // Name & Type
                         Row(
                           crossAxisAlignment: CrossAxisAlignment.center,
                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
                           children: [
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   edu["name"]!,
                                   style: Styles.semiBoldTextStyle(size: 16),
                                 ),
                                 hSpace(SizeConfig.screenHeight! * 0.015),
                                 Text(
                                   edu["description"]!,
                                   style: Styles.semiBoldTextStyle(size: 25, color:kBlackColor),
                                 ),
                               ],
                             ),

                             Container(
                               width: 65,
                               height: 65,
                               padding: EdgeInsets.all(15),
                               decoration: BoxDecoration(
                                 color: iconBgColor,
                                 borderRadius: BorderRadius.circular(50),
                               ),
                               child: SvgPicture.asset(
                                 provider.dataList.length - 1 == index ? Images.job_recommended : Images.session,
                                 width: 20,
                                 height: 20,
                                 semanticsLabel: 'Location icon',
                                 fit: BoxFit.contain,
                               ),
                             )



                           ],
                         ),

                       ],
                     ),
                   ),
                 ),
               );
             },
           ),
         );

       }));


  }
}


