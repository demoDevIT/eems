import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/global.dart';
import '../../../utils/textstyles.dart';
import '../loginscreen/provider/locale_provider.dart';
import 'provider/about_app_provider.dart';

class AboutAppScreen extends StatefulWidget {
  AboutAppScreen({super.key});

  @override
  State<AboutAppScreen> createState() => _AboutAppScreenState();
}

class _AboutAppScreenState extends State<AboutAppScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = Provider.of<AboutAppProvider>(context, listen: false);
      provider.clearData();
      provider.getAboutAppApi(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2("About App", context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),

        body: Consumer<AboutAppProvider>(builder: (context, provider, child) {
          /// ✅ STEP 1: ADD THIS HERE
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                color: kButtonColor,
              ),
            );
          }

          /// ✅ STEP 2: Optional (empty state)
          if (provider.aboutAppData.isEmpty) {
            return Center(
              child: Text("No Data Found"),
            );
          }
          return   Padding(
            padding: const EdgeInsets.all(10),
            child:  ListView.builder(
              itemCount: provider.aboutAppData.length,
              itemBuilder: (context, index) {
                final data = provider.aboutAppData[index];
                return InkWell(
                  onTap: () {},
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: index % 2 == 0 ? kWhitedGradient : jobsCardGradient,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Html(
                      data: data.htmlEng ?? "",
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


