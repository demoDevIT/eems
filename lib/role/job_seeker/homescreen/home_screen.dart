
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/homescreen/provider/home_screen_provider.dart';
import 'package:rajemployment/role/job_seeker/job_fair_event/jobs_fair_event.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/utility_class.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/textstyles.dart';
import '../jobseekerdashboard/job_based_profile.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

 class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      final provider = Provider.of<HomeScreenProvider>(context, listen: false);
      provider.clearData();
      provider.getAllJobFairEventsListApi(context);
      provider.jobListApi(context);
      provider.companyListApi(context);
    /*
      */
    });

  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return SafeArea(
        top: false,
        child: Scaffold(
            //floatingActionButton: _attendanceFab(context),
            body: Consumer<HomeScreenProvider>(
                builder: (context, provider, child) {

                  return   SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// Schemes
                    /// Attendance Icon + Schemes
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          /// Attendance Button
                          Align(
                            alignment: Alignment.centerRight,
                            child: InkWell(
                              onTap: () {
                                // Navigator.push(
                                //   context,
                                //   MaterialPageRoute(
                                //     builder: (context) => const AttendanceScreen(),
                                //   ),
                                // );
                              },
                              borderRadius: BorderRadius.circular(20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: kPrimaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: kPrimaryColor),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: const [
                                    Icon(
                                      Icons.add_circle,
                                      size: 18,
                                      color: kPrimaryColor,
                                    ),
                                    SizedBox(width: 6),
                                    Text(
                                      "Mark Attendance",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: kPrimaryColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// Schemes Heading
                          sectionHeader(
                            AppLocalizations.of(context)!.schemes,
                            context,
                            showViewAll: false,
                          ),

                          SizedBox(height: SizeConfig.defaultSize! * 1),

                          Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 8.0),
                                  child: schemeCard(
                                    "मुख्यमंत्री युवा रोजगार प्रोत्साहन योजना 2025",
                                    context,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),


                    provider.jobEventList.isNotEmpty ? Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          SizedBox(height: SizeConfig.defaultSize! * 1),
                          _buildSectionHeader(AppLocalizations.of(context)!.jobevents, () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => JobsFairEventScreen()),
                            );
                          }, context),
                          SizedBox(height: SizeConfig.defaultSize! * 0.3),
                          Wrap(
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: provider.jobEventList.asMap().entries.map((entry) {
                                    final index = entry.key;
                                    final event = entry.value;
                                    return Stack(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: _buildJobEventCard(
                                            event.eventNameENG,
                                              event.eventDescription,
                                          ),
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 30,
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: kJobFlotBackColor,
                                              borderRadius: BorderRadius.circular(16),
                                            ),
                                            child: Text(
                                              event.levelNameEnglish,
                                              style: const TextStyle(color: kJobFontColor, fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    );
                                  }).toList(),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ) : SizedBox(),
                    provider.jobEventList.isNotEmpty ? SizedBox(height: SizeConfig.defaultSize! * 1) : SizedBox(height: 0,),
                    /// Jobs based on Profile
                    provider.jobBasedList.isNotEmpty ?  Container(
                        decoration: BoxDecoration(
                          color:kJobCardColor,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              SizedBox(height: SizeConfig.defaultSize! * 1),
                              sectionHeader(AppLocalizations.of(context)!.jobsbasedprofile, context, showViewAll: true),
                              //sectionHeader("Jobs based on your profile", context),
                              SizedBox(height: SizeConfig.defaultSize! * 1),
                              SizedBox(
                                height: 170,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: provider.jobBasedList.length,
                                  itemBuilder: (context, index) {
                                    final jobsData = provider.jobBasedList[index];
                                    return SizedBox(
                                        width: 372,
                                        child: JobBasedProfile(jobsData:jobsData));
                                  },
                                ),
                              ),
                            ],
                          ),
                        )
                    ) : SizedBox(),
                    provider.jobBasedList.isNotEmpty ? SizedBox(height: SizeConfig.screenHeight! * 0.010) : SizedBox(),
                    /// Featured Companies
                    provider.companyList.isNotEmpty ?   Padding(
                      padding: const EdgeInsets.only(left: 8.0,right: 8.0),
                      child: Column(
                        children: [
                          SizedBox(height: SizeConfig.defaultSize! * 1),

                          sectionHeader(AppLocalizations.of(context)!.featurcompany, context, showViewAll: true),
                          SizedBox(height: SizeConfig.defaultSize! * 0.09),

                          SizedBox(
                            height: 90,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: provider.companyList.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 370,
                                  child:Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 10),child: companyCard( provider.companyList[index].comapnyname.toString(), provider.companyList[index].headLocality.toString()),),
                                      Positioned(
                                        top: 0,
                                        right: 20,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                          decoration: BoxDecoration(
                                            color:kIconsBackColor,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text("${checkNullValue(provider.companyList[index].totalVacany.toString())} Vacancy",
                                              style: const TextStyle(
                                                  color: kIconsColor, fontWeight: FontWeight.bold,fontSize: 8)),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),

                          ),
                        ],
                      ),
                    ) : SizedBox(),

                  ],
                ),
              ),
            );
          })));


  }

   // Widget _attendanceFab(BuildContext context) {
   //   return FloatingActionButton(
   //     backgroundColor: kPrimaryColor,
   //     child: const Icon(Icons.access_time, color: Colors.white),
   //     onPressed: () {
   //       // Navigator.push(
   //       //   context,
   //       //   MaterialPageRoute(
   //       //     builder: (context) => const AttendanceScreen(),
   //       //   ),
   //       // );
   //     },
   //   );
   // }

   /// Section Header
  Widget sectionHeader(String title, context, {
    bool showViewAll = true,
  }) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
            style:UtilityClass.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: kBlackColor
            ),
          ),
          if (showViewAll)
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
            AppLocalizations.of(context)!.viewall,
              style: UtilityClass.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: kViewAllColor,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_forward,
              size: 13,
              color: kViewAllColor,
            ),
          ],
        ),
        ],
      ),
    );
  }

  /// Scheme Card
  Widget schemeCard(String title, context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Image.asset("assets/logos/schemeIcons.png", width: 40,height: 40, color: Colors.orange),
          const SizedBox(height: 8),
          Text(title,
              style:UtilityClass.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: kBlackColor
              ),),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                AppLocalizations.of(context)!.applynow,
                style: UtilityClass.poppins(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: kSchemesBackColor,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_forward,
                size: 13,
                color: kSchemesBackColor,
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback onTap, context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style:UtilityClass.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: kBlackColor
            ),
          ),
          GestureDetector(
            onTap: onTap,
            child:  Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  AppLocalizations.of(context)!.viewall,
                  style: UtilityClass.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kViewAllColor,
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.arrow_forward,
                  size: 13,
                  color: kViewAllColor,
                ),
              ],
            )
          ),
        ],
      ),
    );
  }

  /// Event Card
  Widget _buildJobEventCard(String title, String subtitle) {
    return Container(
      width: 300,
      margin: EdgeInsets.only(left: 4,right: 4),// Fixed width for each card
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFffffff), Color(0xFFf2fdff)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child:  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style:Styles.semiBoldTextStyle(size: 12,color: kBlackColor)
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
              overflow: TextOverflow.ellipsis,
              style:Styles.regularTextStyle(size: 11,color: kDartGrayColor)
          ),
        ],
      ),
    );
  }

  /// Job Card
  /// Company Card
  Widget companyCard(String company, String location) {
    return Container(
      margin:  EdgeInsets.only(left: 4,right: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.coffee, size: 36, color: Colors.brown),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(company,
                      style:Styles.semiBoldTextStyle(color: kBlackColor,size: 13)

                  ),
                  Text(location, style:Styles.regularTextStyle(color: kBlackColor,size: 13)
                  ),
                ],
              ),
            ],
          ),

        ],
      ),
    );
  }
}