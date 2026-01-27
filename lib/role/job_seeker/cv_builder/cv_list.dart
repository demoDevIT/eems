import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/cv_builder/provider/cv_list_provider.dart';
import 'package:rajemployment/role/job_seeker/grievance/add_grievance_screen.dart';
import 'package:rajemployment/role/job_seeker/grievance/provider/grievance_list_provider.dart';
import 'package:rajemployment/role/job_seeker/job_details/job_details.dart';
import 'package:rajemployment/role/job_seeker/jobpreference/provider/job_preference_provider.dart';
import 'package:rajemployment/role/job_seeker/jobs/provider/jobs_list_provider.dart';
import 'package:rajemployment/utils/dot_border.dart';
import 'package:rajemployment/utils/global.dart';
import 'package:rajemployment/utils/images.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../utils/right_to_left_route.dart';
import '../../../utils/textstyles.dart';
import '../addjobpreference/add_job_preference.dart';
import '../loginscreen/provider/locale_provider.dart';

class CvListScreen extends StatefulWidget {
   CvListScreen({super.key});

  @override
  State<CvListScreen> createState() => _CvListScreenState();
}

class _CvListScreenState extends State<CvListScreen> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<CvListProvider>(context, listen: false);
      provider.clearData();

    });
  }


  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
      appBar: commonAppBar2(
        "CV Builder",
        context,
        localeProvider.currentLanguage,
        "",
        false,
        "",
        onTapClick: () {
          localeProvider.toggleLocale();
        },
      ),
      body: Consumer<CvListProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                /// DOWNLOAD BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    onPressed: provider.isLoading
                        ? null
                        : () {
                      provider.downloadCvByUserId(context);
                    },
                    child: provider.isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Download CV",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                /// MESSAGE BELOW BUTTON
                if (provider.apiMessage.isNotEmpty)
                  Text(
                    provider.apiMessage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }




}


