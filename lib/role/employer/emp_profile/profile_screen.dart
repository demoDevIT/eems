import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../l10n/app_localizations.dart';
import '../../../utils/user_new.dart';
import '../../../constants/colors.dart';
import '../../../utils/textstyles.dart';
import 'contact_person_detail.dart';
import 'emp_basic_detail.dart';
import 'branch_office_detail.dart';
import 'head_office_detail.dart';
import 'head_office_applicant_detail.dart';
import 'exchange_name_detail.dart';
import 'exchange_market_info_program.dart';
import 'uploaded_documents.dart';

class EmployerProfileScreen extends StatelessWidget {
  const EmployerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppLocalizations.of(context)!.compltprofle,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF2F4F8),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ===== Profile Header =====
            Row(
              children: [
                // Stack(
                //   alignment: Alignment.center,
                //   children: [
                //     SizedBox(
                //       width: 90,
                //       height: 90,
                //       child: CircularProgressIndicator(
                //         value: 0.7,
                //         strokeWidth: 7,
                //         backgroundColor: Colors.grey[300],
                //         valueColor: const AlwaysStoppedAnimation(kViewAllColor),
                //       ),
                //     ),
                //     ClipOval(
                //       child: Image.network(
                //         UserData().model.value.latestPhotoPath.toString(),
                //         width: 65,
                //         height: 65,
                //         fit: BoxFit.cover,
                //         errorBuilder: (_, __, ___) {
                //           return Image.asset(
                //             'assets/images/placeholder.png',
                //             width: 65,
                //             height: 65,
                //           );
                //         },
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        UserData().model.value.branchName.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        UserData().model.value.branchEmail.toString(),
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 24),

            /// ===== Menu Items =====
            _menuTile(context, "Basic Details"),
            _menuTile(context, "Branch Office Details"),
            _menuTile(context, "Head Office Details"),
            _menuTile(context, "Head Office Applicant Details"),
            _menuTile(context, "Contact person Details"),
            _menuTile(context, "Exchange Name / District Employment Office"),
            _menuTile(context, "Exchange Market Information Program"),
            _menuTile(context, "Upload Organization/Company Documents"),
          ],
        ),
      ),
    );
  }

  Widget _menuTile(BuildContext context, String title) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: ListTile(
        title: Text(
          title,
          style: Styles.semiBoldTextStyle(size: 14, color: kBlackColor),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          if (title == "Basic Details") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const EmpBasicDetailScreen(),
              ),
            );
          }
          else if (title == "Branch Office Details") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const BranchOfficeDetailScreen(),
              ),
            );
          }
          else if (title == "Head Office Details") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HeadOfficeDetailScreen(),
              ),
            );
          }
          else if (title == "Head Office Applicant Details") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const HeadOfficeApplicantDetailScreen(),
              ),
            );
          }
          else if (title == "Contact person Details") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ContactPersonDetail(),
              ),
            );
          }
          else if (title == "Exchange Name / District Employment Office") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ExchangeNameDetail(),
              ),
            );
          }
          else if (title == "Exchange Market Information Program") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ExchangeMarketInformationProgram(),
              ),
            );
          }
          else if (title == "Upload Organization/Company Documents") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const UploadOrganizationDocuments(),
              ),
            );
          }
        },
      ),
    );
  }

  // for UI change of this page *********** same UI code same like employee dashboard
  // Widget _menuTile(BuildContext context, String title, String iconPath, Color color) {
  //   return Container(
  //     margin: const EdgeInsets.only(bottom: 14),
  //     child: Material(
  //       borderRadius: BorderRadius.circular(16),
  //       color: Colors.white,
  //       child: InkWell(
  //         borderRadius: BorderRadius.circular(16),
  //         onTap: () {
  //           _handleNavigation(context, title);
  //         },
  //         child: Padding(
  //           padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
  //           child: Row(
  //             children: [
  //               /// Icon (same as dashboard)
  //               Container(
  //                 height: 45,
  //                 width: 45,
  //                 child: Center(
  //                   child: Image.asset(
  //                     iconPath,
  //                     height: 42,
  //                     width: 42,
  //                   ),
  //                 ),
  //               ),
  //
  //               const SizedBox(width: 14),
  //
  //               /// Title
  //               Expanded(
  //                 child: Text(
  //                   title,
  //                   style: const TextStyle(
  //                     fontSize: 14,
  //                     fontWeight: FontWeight.w500,
  //                   ),
  //                 ),
  //               ),
  //
  //               /// Rounded Arrow (same as dashboard fix)
  //               Container(
  //                 height: 28,
  //                 width: 28,
  //                 decoration: BoxDecoration(
  //                   shape: BoxShape.circle,
  //                   color: Colors.grey.shade100,
  //                   border: Border.all(color: Colors.grey.shade200),
  //                 ),
  //                 child: const Center(
  //                   child: Icon(
  //                     Icons.arrow_forward_ios,
  //                     size: 14,
  //                     color: Colors.grey,
  //                   ),
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  //
  // void _handleNavigation(BuildContext context, String title) {
  //   if (title == "Basic Details") {
  //     Navigator.push(context, MaterialPageRoute(builder: (_) => const EmpBasicDetailScreen()));
  //   } else if (title == "Branch Office Details") {
  //     Navigator.push(context, MaterialPageRoute(builder: (_) => const BranchOfficeDetailScreen()));
  //   } else if (title == "Head Office Details") {
  //     Navigator.push(context, MaterialPageRoute(builder: (_) => const HeadOfficeDetailScreen()));
  //   } else if (title == "Head Office Applicant Details") {
  //     Navigator.push(context, MaterialPageRoute(builder: (_) => const HeadOfficeApplicantDetailScreen()));
  //   } else if (title == "Contact person Details") {
  //     Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactPersonDetail()));
  //   } else if (title == "Exchange Name / District Employment Office") {
  //     Navigator.push(context, MaterialPageRoute(builder: (_) => const ExchangeNameDetail()));
  //   } else if (title == "Exchange Market Information Program") {
  //     Navigator.push(context, MaterialPageRoute(builder: (_) => const ExchangeMarketInformationProgram()));
  //   } else if (title == "Upload Organization/Company Documents") {
  //     Navigator.push(context, MaterialPageRoute(builder: (_) => const UploadOrganizationDocuments()));
  //   }
  // }
}
