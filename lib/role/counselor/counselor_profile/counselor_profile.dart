// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:rajemployment/constants/colors.dart';
// //import 'package:rajemployment/role/job_seeker/profile/provider/profile_provider.dart';
// import 'package:rajemployment/utils/user_new.dart';
// import '../../../l10n/app_localizations.dart';
// import '../../../utils/images.dart';
// import '../../../utils/textstyles.dart';
//
//
// class CounselorProfileScreen extends StatefulWidget {
//   bool isAppBarHide;
//   CounselorProfileScreen({super.key, required this.isAppBarHide});
//
//   @override
//   State<CounselorProfileScreen> createState() => _CounselorProfileScreenState();
// }
//
// class _CounselorProfileScreenState extends State<CounselorProfileScreen> {
//   @override
//   Widget build(BuildContext context) {
//     print("LatestPhoto" + UserData().model.value.latestPhotoPath.toString());
//     return Scaffold(
//         appBar: widget.isAppBarHide ?  AppBar(
//           backgroundColor: Colors.white,
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
//             onPressed: () {
//               Navigator.pop(context); // go back to previous screen
//             },
//           ),
//           title: Text(
//             AppLocalizations.of(context)!.compltprofle,
//             style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
//           ),
//           centerTitle: true,
//         ) : null,
//
//         body: Consumer<ProfileProvider>(builder: (context, provider, child) {
//           return   SingleChildScrollView(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 /// Profile Section
//                 Padding(
//                   padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 16.0),
//                   child: Row(
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: [
//                       Stack(
//                         alignment: Alignment.center,
//                         clipBehavior: Clip.none,
//                         children: [
//                           Transform.rotate(
//                             angle: 2.00,
//                             child: SizedBox(
//                               width: 90,
//                               height: 90,
//                               child: CircularProgressIndicator(
//                                 value: 0.7, // 70%
//                                 strokeWidth: 7,
//                                 backgroundColor: Colors.grey[300],
//                                 valueColor: const AlwaysStoppedAnimation<Color>(kViewAllColor),
//                               ),
//                             ),
//                           ),
//                           ClipOval(
//                             child: Image.network(
//                               UserData().model.value.latestPhotoPath.toString(),
//                               width: MediaQuery.of(context).size.width * 0.18,
//                               height: MediaQuery.of(context).size.width * 0.18,
//                               fit: BoxFit.cover,
//                               errorBuilder: (context, error, stackTrace) {
//                                 return Image.asset(
//                                   Images.placeholder,
//                                   width: MediaQuery.of(context).size.width * 0.19,
//                                   height: MediaQuery.of(context).size.width * 0.19,
//                                   fit: BoxFit.cover,
//                                 );
//                               },
//                             ),
//                           ),
//                           // ✅ Moved and adjusted this Positioned widget
//                           Positioned(
//                             right: -10, // half outside
//                             top: 5, // vertically centered on right side
//                             child: Container(
//                               alignment: Alignment.center,
//                               padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
//                               decoration: BoxDecoration(
//                                 color: FFF2EDColor,
//                                 borderRadius: BorderRadius.circular(8),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black12,
//                                     blurRadius: 2,
//                                     offset: Offset(1, 1),
//                                   ),
//                                 ],
//                               ),
//                               child: const Text(
//                                 "70%",
//                                 style: TextStyle(
//                                   color: kDarkOrangeColor,
//                                   fontSize: 12,
//                                   fontWeight: FontWeight.bold,
//                                 ),
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               UserData().model.value.nAMEENG.toString(),
//                               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                             const SizedBox(height: 4),
//                             Text(
//                               UserData().model.value.eMAILID.toString(),
//                               style: const TextStyle(color: Colors.grey),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 /// Menu List
//                 buildMenuItem(context, "Basic Details", AppLocalizations.of(context)!.basicdetl),
//                 buildMenuItem(context, "Highest Education Details", AppLocalizations.of(context)!.addinfo),
//                 buildMenuItem(context, "Skill Set / Domain Expertise", AppLocalizations.of(context)!.edudetl),
//                 buildMenuItem(context, "Additional Details (Optional)", AppLocalizations.of(context)!.workexp),
//               ],
//             ),
//           );
//         }));
//
//   }
//
//   Widget buildMenuItem(BuildContext context, String title, titleLang) {
//
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(color: Colors.grey[300]!),
//       ),
//       child: ListTile(
//         title: Text(titleLang, style: Styles.semiBoldTextStyle(size: 14,color: kBlackColor)),
//         trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: kBlackColor),
//         onTap: () {
//           if (title == "Basic Details") {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => CounselorBasicDetailsScreen()),
//             );
//           } else if (title == "Address Info") {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => CounselorHighestEduScreen()),
//             );
//           }
//           else if (title == "Education Details") {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => SkillSetDomainScreen()),
//             );
//           } else if (title == "Work experience") {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => AdditionalDetailScreen()),
//             );
//           }
//           // Add more conditions for other menu items as needed
//         },
//       ),
//     );
//   }
// }
