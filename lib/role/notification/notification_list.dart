import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/job_details/job_details.dart';
import 'package:rajemployment/role/job_seeker/jobs/provider/jobs_list_provider.dart';
import 'package:rajemployment/role/notification/provider/notification_list_provider.dart';
import 'package:rajemployment/utils/images.dart';

import '../../../utils/right_to_left_route.dart';
import '../../../utils/textstyles.dart';

class NotificationListScreen extends StatefulWidget {
   NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Consumer<NotificationListProvider>(builder: (context, provider, child) {
            return   ListView.builder(
              itemCount: provider.educationList.length,
              itemBuilder: (context, index) {
                final edu = provider.educationList[index];
                return InkWell(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      RightToLeftRoute(
                        page: JobDetailsScreen(),
                        duration: const Duration(milliseconds: 500),
                        startOffset: const Offset(-1.0, 0.0),
                      ),
                    );
                  },
                  child: Container(
                    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 10,) ,
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            SvgPicture.asset(
                              Images.bell,
                              width: 35,
                              height: 35,
                              semanticsLabel: 'bell icon',
                              fit: BoxFit.contain,
                            ),
                            SizedBox(width: 10,),
                            Text(edu["collage"]!,style: Styles.mediumTextStyle(size: 12,color: kBlackColor)
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        provider.educationList.length - 1 == index ?  SizedBox() : Divider(color: E1E1E1Color,height: 2,)


                      ],
                    ),
                  ),
                );
              },
            );
          }));


  }
}


