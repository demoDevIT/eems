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
     // provider.getAllCVTemplateListApi(context);
     // provider.getColorCodeListApi(context);



    });
  }


  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2("CV Builder", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),
        body: Consumer<CvListProvider>(builder: (context, provider, child) {
          return   Padding(
            padding: const EdgeInsets.all(10),
            child:  ListView.builder(
              itemCount: provider.allCvList.length,
              itemBuilder: (context, index) {
                final oldColorCode = provider.allCvList[index].colourCode;


                return InkWell(
                  onTap: () {

                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    margin: const EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      gradient: index % 2 == 0 ? kWhitedGradient:kWhitedGradient  ,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      children: [
                        Expanded(
                          child: WebViewWidget(
                            controller: WebViewController()
                              ..setJavaScriptMode(JavaScriptMode.unrestricted)
                              ..loadHtmlString(provider.allCvList[index].templateHtml),),
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 80, // MUST give height
                          child: ListView.builder(
                            itemCount: provider.colorCodeList.length,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, i) {
                              final colourCode = provider.colorCodeList[i].colourCode.toString().replaceAll("#", "");
                              return InkWell(
                                onTap: () {
                                 // provider.updateTemplate(index,  provider.allCvList[index].colourCode, provider.colorCodeList[i].colourCode.toString().replaceAll("", ""));

                                },
                                child: Column(
                                  children: [

                                    Stack(
                                      alignment: Alignment.center,
                                      clipBehavior: Clip.none,
                                      children: [
                                        Transform.rotate(
                                          angle: 2.00,
                                          child: SizedBox(
                                            width: 60,
                                            height: 60,
                                            child: CircularProgressIndicator(
                                              value: 1, // 70%
                                              strokeWidth: 5,
                                              backgroundColor: Colors.grey[300],
                                              valueColor: AlwaysStoppedAnimation<Color>(
                                                Color(int.parse("0xFF$colourCode")),
                                              ),                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 50,
                                          width: 50,
                                          margin: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                            color: Color(int.parse("0xFF$colourCode")),
                                            borderRadius: BorderRadius.circular(100),
                                          ),

                                        ),
                                      ],
                                    ),



                                  ],
                                ),
                              );
                            },
                          ),
                        ),

                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 60,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor:kPrimaryColor,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18),
                              ),
                            ),
                            onPressed: ()  async {
                              String vase64 = await provider.htmlToBase64(provider.allCvList[index].templateHtml);
                             // provider.saveAndOpenPdf(context, vase64, "fileName${provider.allCvList[index].templateId}.Pdf");
                              provider.openHtmlAsPdf(provider.allCvList[index].templateHtml);
                             // provider.openHtmlAsPdf(provider.allCvList[index].templateHtml);
                              },
                            child:  Text(
                              "Download" ,
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                );
              },
            ),
          );
        }));

    //147664


    //pending//62664


  }



}


