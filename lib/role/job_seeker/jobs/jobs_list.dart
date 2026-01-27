import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/job_details/job_details.dart';
import 'package:rajemployment/role/job_seeker/jobs/provider/jobs_list_provider.dart';
import 'package:rajemployment/utils/images.dart';
import '../../../utils/right_to_left_route.dart';
import '../../../utils/textstyles.dart';

class JobsListScreen extends StatefulWidget {
   JobsListScreen({super.key});

  @override
  State<JobsListScreen> createState() => _JobsListScreenState();
}

class _JobsListScreenState extends State<JobsListScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final jobsListProvider = Provider.of<JobsListProvider>(context, listen: false);
      jobsListProvider.clearData();
      jobsListProvider.allJobMatchingListApi(context);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
       body: Consumer<JobsListProvider>(builder: (context, provider, child) {
            return   Column(
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
                            "Preferred Jobs",
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
                            "Applied Jobs",
                            style: Styles.semiBoldTextStyle(size: 15, color: provider.tab == false ? kWhite : kbuttonColor,),                       ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: provider.tab == true ? ListView.builder(
                    itemCount: provider.jobPostList.length,
                    itemBuilder: (context, index) {
                      final edu = provider.jobPostList[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            RightToLeftRoute(
                              page: JobDetailsScreen(),
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
                                        "Name",
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
                                            "Type",
                                            style:Styles.mediumTextStyle(size: 12,color: kJobFontColor ,)
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Text("Salary:""}",
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
                                           "college",
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
                                                "address",
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
                  ) : ListView.builder(
                    itemCount: provider.applyJobPostList.length,
                    itemBuilder: (context, index) {
                      final edu = provider.applyJobPostList[index];
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(
                            RightToLeftRoute(
                              page: JobDetailsScreen(),
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
                                        "Name",
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
                                            "Type",
                                            style:Styles.mediumTextStyle(size: 12,color: kJobFontColor ,)
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10,),
                                    Text("Salary:""}",
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
                                            "college",
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
                                                "address",
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
                ),
              ],
            );
          }));


  }
}


