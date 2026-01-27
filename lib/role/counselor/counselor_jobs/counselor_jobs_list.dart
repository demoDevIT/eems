import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/counselor/counselor_job_details/counselor_job_details.dart';
import 'package:rajemployment/role/counselor/counselor_jobs/provider/counselor_jobs_list_provider.dart';
import 'package:rajemployment/role/job_seeker/job_details/job_details.dart';
import 'package:rajemployment/role/job_seeker/jobs/provider/jobs_list_provider.dart';
import 'package:rajemployment/utils/images.dart';
import '../../../utils/right_to_left_route.dart';
import '../../../utils/textstyles.dart';

class CounselorJobsListScreen extends StatefulWidget {
   CounselorJobsListScreen({super.key});

  @override
  State<CounselorJobsListScreen> createState() => _CounselorJobsListScreenState();
}

class _CounselorJobsListScreenState extends State<CounselorJobsListScreen> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Consumer<CounselorJobsListProvider>(builder: (context, provider, child) {
            return   Padding(
              padding: const EdgeInsets.all(16.0),
              child:  ListView.builder(
                itemCount: provider.educationList.length,
                itemBuilder: (context, index) {
                  final edu = provider.educationList[index];
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        RightToLeftRoute(
                          page: CounselorJobDetailsScreen(),
                          duration: const Duration(milliseconds: 500),
                          startOffset: const Offset(-1.0, 0.0),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        gradient: index % 2 == 0 ? kWhitedGradient:jobsCardGradient  ,
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),

                      // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Expanded(child: Text(
                                    edu["name"]!,
                                    style: Styles.semiBoldTextStyle(size: 15)
                                ),),

                                Icon(Icons.check_box_outline_blank,color: kRedColor,)


                              ],
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                Container(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: kJobFlotBackColor,
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child:  Text(
                                        edu["type"]!,
                                        style:Styles.mediumTextStyle(size: 12,color: kJobFontColor ,)

                                    ),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Text("Salary: ${edu["salary"]!}",
                                    style: Styles.regularTextStyle(size: 12,color: fontGrayColor )
                                )

                              ],
                            ),
                            SizedBox(height: 20,),
                            Row(
                              children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  child:Image(image:  AssetImage(index % 2 == 0 ? Images.job1 : Images.job2),width: 40,height: 40,),
                                ),
                                SizedBox(width: 10,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                        edu["collage"]!,
                                        style: Styles.mediumTextStyle(size: 15,color: kBlackColor)
                                    ),
                                    SizedBox(height: 5,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Icon(Icons.location_on_outlined,color: fontGrayColor,size: 12,),
                                        SizedBox(width: 5,),
                                        Container(
                                          width: MediaQuery.of(context).size.width * 0.68,
                                          child:  Text(
                                            overflow: TextOverflow.ellipsis,
                                            edu["address"]!,
                                            style: Styles.regularTextStyle(size: 12,color: fontGrayColor,),

                                          ) ,
                                        ),


                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 10,),


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


