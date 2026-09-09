
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/homescreen/provider/home_screen_provider.dart';
import 'package:rajemployment/role/job_seeker/job_fair_event/jobs_fair_event.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/utility_class.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/right_to_left_route.dart';
import '../../../utils/textstyles.dart';
import '../../../utils/user_new.dart';
import '../applied_jobs/applied_jobs.dart';
import '../cv_builder/cv_list.dart';
import '../grievance/grievance_list.dart';
import '../job_fair_event/job_fair_event_details.dart';
import '../job_fair_event/modal/running_event_modal.dart';
import '../job_fair_event/registered_event_list.dart';
import '../jobs/jobs_list.dart';
import '../jobseekerdashboard/job_based_profile.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../mysy/mysy_list.dart';
import '../preferred_jobs/preferred_jobs.dart';
import '../registration_card/registration_card.dart';
import '../select_company/select_company_page.dart';
import '../self_assessment/self_assessment.dart';
import '../settings/job_settings_screen.dart';
import '../videoprofile/videoprofile_screen.dart';


 class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final PageController _pageController =
  PageController(viewportFraction: 0.92);

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;
      final provider = Provider.of<HomeScreenProvider>(context, listen: false);
      provider.clearData();
      provider.getCurrentEvents(context);
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

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        children: [

                          /// 🔹 Greeting Card
                          _buildGreetingCard(),

                          const SizedBox(height: 16),
                          _buildEventSlider(),

                          const SizedBox(height: 16),
                          /// 🔹 Grid Menu
                          _buildDashboardGrid(),

                          const SizedBox(height: 16),

                          /// 🔹 KEEP YOUR EXISTING SECTIONS BELOW (NO CHANGE)
                        //  _existingSections(provider),
                        ],
                      ),
                    ),
                  );
          })));


  }

  Widget _eventCard(RunningEventData event) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 5,
            decoration: const BoxDecoration(
              color: Color(0xFF0D8AA8),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    event.eventNameENG ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF9C1F1F),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    event.eventDescription ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.location_on_outlined,
                        color: Color(0xFF0D8AA8),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          event.venue ?? "",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today_outlined,
                        color: Color(0xFF0D8AA8),
                        size: 18,
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "${getFormattedDate(event.startDate ?? "")} - ${getFormattedDate(event.endDate ?? "")}",
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const Spacer(),

                  SizedBox(
                    height: 36,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0D8AA8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          RightToLeftRoute(
                            page: JobFairEventDetailsScreen(
                              runningEventData: event,
                            ),
                            duration: const Duration(milliseconds: 500),
                            startOffset: const Offset(-1.0, 0.0),
                          ),
                        );
                      },
                      child: const Text(
                        "Apply Now",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventSlider() {
    return Consumer<HomeScreenProvider>(
      builder: (context, provider, child) {

        if (provider.currentEventList.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: 230,
          child: PageView.builder(
            controller: _pageController,
            padEnds: false,
            itemCount: provider.currentEventList.length,
            itemBuilder: (context, index) {
              final event = provider.currentEventList[index];

              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: _eventCard(event),
              );
            },
          ),
        );
      },
    );
  }

   Widget _buildGreetingCard() {
     return Container(
       width: double.infinity,
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(16),
         gradient: LinearGradient(
           colors: [Color(0xFFE8ECFF), Color(0xFFF7F8FF)],
         ),
       ),
       child: Row(
         children: [
           CircleAvatar(
             radius: 28,
             backgroundImage: NetworkImage(
               UserData().model.value.latestPhotoPath.toString(),
             ),
           ),
           const SizedBox(width: 12),
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               // Text("Good morning",
               //     style: TextStyle(color: Colors.grey)),
               Text(
                 "${UserData().model.value.nAMEENG}",
                 style: TextStyle(
                   fontWeight: FontWeight.bold,
                   fontSize: 16,
                 ),
               ),
             ],
           )
         ],
       ),
     );
   }

   Widget _buildDashboardGrid() {
     final items = [
       // _DashboardItem(
       //   title: "Scheduled Interviews",
       //   iconPath: "assets/images/scheduleInterview.svg",
       //   onTap: () {},
       // ),
       _DashboardItem(
         title: AppLocalizations.of(context)!.cvbuilder,
         iconPath: "assets/images/cvBuilder.svg",
         onTap: () {
           Navigator.push(context,
               MaterialPageRoute(builder: (_) => CvListScreen()));
         },
       ),
       _DashboardItem(
         title: AppLocalizations.of(context)!.searchJobApply, //"Search Job/Apply",
         iconPath: "assets/images/searchJobApply.svg",
         showArrow: true,
         onTap: () => _showSearchJobPopup(),
       ),
       // _DashboardItem(
       //   title: "Search Counselor",
       //   iconPath: "assets/images/searchCounsellor.svg",
       //   onTap: () {},
       // ),
       _DashboardItem(
         title: AppLocalizations.of(context)!.jobfairevents, //"Job Fair Events",
         iconPath: "assets/images/jobFairEvent.svg",
         showArrow: true,
         onTap: () => _showJobFairPopup(),
       ),
       _DashboardItem(
         title: AppLocalizations.of(context)!.downldregiscard, //"Download Registration Card",
         iconPath: "assets/images/downloadRegCard.svg",
         onTap: () {
           Navigator.push(context,
               MaterialPageRoute(builder: (_) => RegistrationCardScreen()));
         },
       ),
       _DashboardItem(
         title: AppLocalizations.of(context)!.mysyStatus, //"MYSY Status", //"Departmental Schemes",
         iconPath: "assets/images/deptScheme.svg",
         showArrow: true,
         // onTap: () => _showDepartmentSchemePopup(),
         onTap: () {
           Navigator.push(
             context,
             MaterialPageRoute(builder: (_) => MysyListScreen()),
           );
         }
       ),
       _DashboardItem(
         title: AppLocalizations.of(context)!.grievfeedbak, //"Grievance/Feedback",
         iconPath: "assets/images/grievances.svg",
         onTap: () {
           Navigator.push(context,
               MaterialPageRoute(builder: (_) => GrievanceScreen()));
         },
       ),
       // _DashboardItem(
       //   title: "Video Profile",
       //   iconPath: "assets/images/videoProfile.svg",
       //   onTap: () {
       //     Navigator.push(context,
       //         MaterialPageRoute(builder: (_) => VideoprofileScreen()));
       //   },
       // ),
       _DashboardItem(
         title: AppLocalizations.of(context)!.selfassess, //"Self Assessment",
         iconPath: "assets/images/selfAssessment.svg",
         onTap: () {
           Navigator.push(context,
               MaterialPageRoute(builder: (_) => SelfAssessmentScreen()));
         },
       ),
       // _DashboardItem(
       //   title: "Settings",
       //   iconPath: "assets/images/settings.svg",
       //   onTap: () {
       //     Navigator.push(
       //       context,
       //       MaterialPageRoute(builder: (_) => JobSettingsScreen()),
       //     );
       //   },
       // ),
       // _DashboardItem(
       //   title: "Appointment Schedule",
       //   iconPath: "assets/images/appointmentSchedule.svg",
       //   onTap: () {},
       // ),
     ];

     return Container(
       color: const Color(0xFFF5F6FA), // 🔹 light background like screenshot
       padding: const EdgeInsets.all(10), // less outer padding
       child: GridView.builder(
         shrinkWrap: true,
         physics: NeverScrollableScrollPhysics(),
         itemCount: items.length,
         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
           crossAxisCount: 2,
           mainAxisSpacing: 10, // 🔹 reduced spacing
           crossAxisSpacing: 10,
           childAspectRatio: 1.38, // 🔹 tighter height
         ),
         itemBuilder: (context, index) {
           final item = items[index];

           return GestureDetector(
             onTap: item.onTap,
             child: Container(
               padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8), // 🔹 less padding
               decoration: BoxDecoration(
                 color: Colors.white, // 🔹 white cards
                 borderRadius: BorderRadius.circular(16),
                 boxShadow: [
                   BoxShadow(
                     color: Colors.black.withOpacity(0.05), // lighter shadow
                     blurRadius: 6,
                     offset: Offset(0, 2),
                   )
                 ],
               ),
               child: Column(
                 mainAxisAlignment: MainAxisAlignment.center,
                 children: [

                   /// 🔹 Bigger Icon Circle
                   // Container(
                   //   padding: const EdgeInsets.all(12),
                   //   decoration: BoxDecoration(
                   //     shape: BoxShape.circle,
                   //     color: Color(0xFFEDE7F6),
                   //   ),
                   //   child: SvgPicture.asset(
                   //     item.iconPath,
                   //     width: 26, // 🔥 bigger icon
                   //     height: 26,
                   //   ),
                   // ),

                  SvgPicture.asset(
                    item.iconPath,
                    width: 50, // 🔥 bigger icon
                    height: 50,
                  ),

                  const SizedBox(height: 10),

                   /// 🔹 Bigger Text + Arrow
                   Row(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       Flexible(
                         child: Text(
                           item.title,
                           textAlign: TextAlign.center,
                         //  style: TextStyle(fontSize: 12),
                           style: const TextStyle(
                             fontSize: 13.5, // 🔥 slightly bigger
                             fontWeight: FontWeight.w500,
                           ),
                         ),
                       ),
                       if (item.showArrow)
                         Padding(
                           padding: const EdgeInsets.only(left: 4),
                           child: Icon(Icons.arrow_forward_ios, size: 12),
                           // child: SvgPicture.asset(
                           //   "assets/images/arrow.svg",
                           //   width: 12,
                           // ),
                         )
                     ],
                   ),
                 ],
               ),
             ),
           );
         },
       ),
     );
   }

   void _showDepartmentSchemePopup() {
     showDialog(
       context: context,
       barrierDismissible: true,
       builder: (context) {
         return Dialog(
           backgroundColor: Colors.transparent,
           child: _centerPopupContainer(
             title: "Departmental Scheme",
             children: [

               _popupRow(
                 title: "MYSY Status",
                 iconPath: "assets/images/mysyPendingList.svg", // temp icon
                 onTap: () {
                   Navigator.pop(context);
                   Navigator.push(
                     context,
                     MaterialPageRoute(builder: (_) => MysyListScreen()),
                   );
                 },
               ),

             ],
           ),
         );
       },
     );
   }

   // ********* search job apply *********
   void _showSearchJobPopup() {
     showDialog(
       context: context,
       barrierDismissible: true,
       builder: (context) {
         return Dialog(
           backgroundColor: Colors.transparent,
           child: _centerPopupContainer(
             title: AppLocalizations.of(context)!.searchJobApply,
             children: [

               _popupRow(
                 title: AppLocalizations.of(context)!.prefRecomJobs,
                 iconPath: "assets/images/prefRecomJob.svg",
                 onTap: () {
                   Navigator.pop(context);
                   Navigator.push(context,
                       MaterialPageRoute(builder: (_) => PreferredJobsScreen()));
                 },
               ),

               Divider(
                 color: Colors.grey.withOpacity(0.2), // lighter
                 thickness: 0.8,
                 height: 16,
               ),

               _popupRow(
                 title: AppLocalizations.of(context)!.appJobs,
                 iconPath: "assets/images/appliedJobs.svg",
                 onTap: () {
                   Navigator.pop(context);
                   Navigator.push(context,
                       MaterialPageRoute(builder: (_) => AppliedJobsScreen()));
                 },
               ),
             ],
           ),
         );
       },
     );
   }

   // ********* search job apply *********
   Widget _centerPopupContainer({
     required String title,
     required List<Widget> children,
   }) {
     return Container(
       padding: const EdgeInsets.all(16),
       decoration: BoxDecoration(
         color: Colors.white,
         borderRadius: BorderRadius.circular(20),
       ),
       child: Column(
         mainAxisSize: MainAxisSize.min,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [

           /// Title
           Text(
             title,
             style: TextStyle(
               fontSize: 16,
               fontWeight: FontWeight.w600,
             ),
           ),

           const SizedBox(height: 10),

           Divider(),

           const SizedBox(height: 6),

           /// Items
           ...children,
         ],
       ),
     );
   }

   // ********* search job apply *********
   Widget _popupRow({
     required String title,
     required String iconPath,
     required VoidCallback onTap,
   }) {
     return InkWell(
       onTap: onTap,
       child: Padding(
         padding: const EdgeInsets.symmetric(vertical: 12),
         child: Row(
           children: [

             /// Left Icon
             // Container(
             //   padding: const EdgeInsets.all(10),
             //   decoration: BoxDecoration(
             //     shape: BoxShape.circle,
             //     color: Color(0xFFEDE7F6),
             //   ),
             //   child: SvgPicture.asset(
             //     iconPath,
             //     width: 18,
             //     height: 18,
             //   ),
             // ),

             SvgPicture.asset(
               iconPath,
               width: 25,
               height: 25,
             ),
             const SizedBox(width: 12),

             /// Title
             Expanded(
               child: Text(
                 title,
                 style: TextStyle(fontSize: 14),
               ),
             ),

             /// Right Arrow Circle
             Container(
               padding: const EdgeInsets.all(6),
               decoration: BoxDecoration(
                 shape: BoxShape.circle,
                 border: Border.all(color: Colors.grey.shade300),
               ),
               child: Icon(
                 Icons.arrow_forward_ios,
                 size: 12,
               ),
             ),
           ],
         ),
       ),
     );
   }


   void _showJobFairPopup() {
     showDialog(
       context: context,
       barrierDismissible: true,
       builder: (context) {
         return Dialog(
           backgroundColor: Colors.transparent,
           child: _centerPopupContainer(
             title: AppLocalizations.of(context)!.jobfairevents,
             children: [

               _popupRow(
                 title: AppLocalizations.of(context)!.events,
                 iconPath: "assets/images/events.svg",
                 onTap: () {
                   Navigator.pop(context);
                   Navigator.push(context,
                       MaterialPageRoute(builder: (_) => JobsFairEventScreen()));
                 },
               ),

               Divider(
                 color: Colors.grey.withOpacity(0.2),
                 thickness: 0.8,
                 height: 16,
               ),

               _popupRow(
                 title: AppLocalizations.of(context)!.regEvents,
                 iconPath: "assets/images/regEvents.svg",
                 onTap: () {
                   Navigator.pop(context);
                   Navigator.push(context,
                       MaterialPageRoute(builder: (_) => RegisteredEventListScreen()));
                 },
               ),

               Divider(
                 color: Colors.grey.withOpacity(0.2),
                 thickness: 0.8,
                 height: 16,
               ),

               // _popupRow(
               //   title: "Job Apply",
               //   iconPath: "assets/images/jobApply.svg",
               //   onTap: () {
               //     Navigator.pop(context);
               //     Navigator.push(context,
               //         MaterialPageRoute(builder: (_) => SelectCompanyPage()));
               //   },
               // ),
             ],
           ),
         );
       },
     );
   }

   Widget _popupContainer({required String title, required List<Widget> children}) {
     return Padding(
       padding: const EdgeInsets.all(16),
       child: Column(
         mainAxisSize: MainAxisSize.min,
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
           Divider(),
           ...children
         ],
       ),
     );
   }

   Widget _popupItem(String title, VoidCallback onTap) {
     return ListTile(
       title: Text(title),
       trailing: Icon(Icons.arrow_forward_ios, size: 16),
       onTap: onTap,
     );
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
class _DashboardItem {
  final String title;
  final String iconPath;
  final VoidCallback onTap;
  final bool showArrow;

  _DashboardItem({
    required this.title,
    required this.iconPath,
    required this.onTap,
    this.showArrow = false,
  });
}
