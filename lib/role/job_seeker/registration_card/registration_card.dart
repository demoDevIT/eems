import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/basicdetails/provider/basic_details_provider.dart';
import 'package:rajemployment/role/job_seeker/registration_card/provider/registration_card_provider.dart';
import 'package:rajemployment/utils/dot_border.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/user_new.dart';
import '../../../utils/dropdown.dart';
import '../../../utils/global.dart';
import '../../../utils/images.dart';
import '../../../utils/textfeild.dart';
import '../../../utils/textstyles.dart';
import '../loginscreen/provider/locale_provider.dart';
import 'modal/reg_card.dart';

class RegistrationCardScreen extends StatefulWidget {
  const RegistrationCardScreen({super.key});

  @override
  State<RegistrationCardScreen> createState() => _RegistrationCardScreenState();
}

class _RegistrationCardScreenState extends State<RegistrationCardScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<RegistrationCardProvider>(context, listen: false);
      provider.clearData();
      provider.regCardDetailData(context);

    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2("Download Registration Card", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
          localeProvider.toggleLocale();
        }),
        body: Consumer<RegistrationCardProvider>(
            builder: (context, provider, child) {
              final cardData = provider.regCardList.isNotEmpty
                  ? provider.regCardList[0]
                  : null;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              color: kWhite,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  jobSeekerCard(cardData!),
                  const SizedBox(height: 16),
                  addressCard(cardData!),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12, top: 0, bottom: 10),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          confirmAlertDialog(context, "Alert","Are you sure want to Download ?", (value) {
                            if (value.toString() == "success") {
                              provider.pdfDownloadApi(context);
                            }
                          },
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF265DF5),
                          minimumSize: const Size(double.infinity, 48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          "Download Registration Card",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),

                 ],
              ),
            ),
          );
        }));
  }

  Widget cardHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: const BoxDecoration(
        color: Color(0xFF0B2E59),
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Center(
        // children: [
        //   Image.asset(Images.logoRegCard, width: 40),
        //   const SizedBox(width: 12),
        //   Column(
        //     crossAxisAlignment: CrossAxisAlignment.start,
        //     children: const [
        //       Text("Government of Rajasthan",
        //           style: TextStyle(color: Colors.white, fontSize: 12)),
        //       Text("Department of Skill, Employment and Entrepreneurship",
        //           style: TextStyle(color: Colors.white, fontSize: 10)),
        //       Text("(Employment Wing)",
        //           style: TextStyle(color: Colors.white, fontSize: 10)),
        //     ],
        //   ),
        // ],
        child: SvgPicture.asset(
          Images.logoRegCard,
          width: 180,
          fit: BoxFit.contain,
        ),


      ),
    );
  }

  // Widget infoRow(String label, String value) {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 2),
  //     child: RichText(
  //       text: TextSpan(
  //         style: const TextStyle(fontSize: 11, color: Colors.black),
  //         children: [
  //           TextSpan(text: "$label:- "),
  //           TextSpan(
  //             text: value,
  //             style: const TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        maxLines: 1, // 👈 prevents wrapping
        overflow: TextOverflow.ellipsis, // 👈 safety
        text: TextSpan(
          style: const TextStyle(fontSize: 11, color: Colors.black),
          children: [
            TextSpan(text: "$label:- "),
            TextSpan(
              text: value,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }



  Widget jobSeekerCard(RegCardInfoData cardData) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        children: [
          cardHeader(),

          const SizedBox(height: 6),
          const Text(
            "Job Seeker Registration Card",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF052654), // same as header blue
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Reg No.: ${cardData.regNo ?? ""}",
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
                Text(
                  "Reg Date: ${cardData.registrationDate ?? ""}",
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),

              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Photo
                Column(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                      ),
                      child: Image.network(
                        cardData.userImageUrl ?? "",
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Image.asset(
                          Images.placeholder,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    const SizedBox(height: 4),
                    Text("NCO Code",
                        style: TextStyle(fontSize: 10, color: Colors.grey)),
                    Text(
                      cardData.NCOCode ?? "",
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                    ),

                  ],
                ),

                const SizedBox(width: 10),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      infoRow("Name",
                          "${cardData.firstName ?? ""} ${cardData.lastName ?? ""}"),
                      infoRow("Father Name", cardData.fatherName ?? ""),
                      // infoRow("DOB", cardData.dOB ?? ""),
                      // infoRow("Gender", cardData.gender ?? ""),
                      // infoRow("Caste", cardData.casteCategory ?? "NA"),
                      // infoRow("Disability",
                      //     cardData.isDisablity == "1" ? "Yes" : "No"),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            // flex: 3, // 👈 more space for DOB
                            child: infoRow("DOB", cardData.dOB ?? ""),
                          ),
                          // const SizedBox(width: 4), // 👈 tiny shift right
                          Expanded(
                            // flex: 2,
                            child: infoRow("Caste", cardData.casteCategory ?? ""),
                          ),
                        ],
                      ),



                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: infoRow("Gender", cardData.gender ?? ""),
                          ),
                          Expanded(
                            child: infoRow("Disability", cardData.isDisablity ?? ""),
                          ),
                        ],
                      ),

                      infoRow("Exchange Name", cardData.exchangeName ?? ""),
                      infoRow("Highest Qualification", cardData.highQuali ?? ""),
                    ],
                  ),
                ),

                // QR
                Image.asset(Images.qr_code, width: 80),
              ],
            ),
          ),

        ],
      ),
    );
  }

  Widget addressCard(RegCardInfoData cardData) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Column(
        children: [
          cardHeader(),

          Padding(
            padding: const EdgeInsets.all(12),
            child: Column( // 👈 CHANGED: Row → Column
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Permanent Address:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            cardData.perAddress ?? "",
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "Communication Address:",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "Ground & 3rd Floor, SM Tower, Ajmer Rd,\n"
                                "Teachers Colony, DCM, Jaipur, Rajasthan 302021",
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // 🔽 ADD THIS PART (Website Row)
                const SizedBox(height: 12),

                Row(
                  children: [
                    SvgPicture.asset(
                      Images.sendImg,
                      width: 14,
                      height: 14,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      "rajemployment.rajasthan.gov.in",
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


}
