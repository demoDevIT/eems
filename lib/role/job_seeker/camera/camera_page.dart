import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/size_config.dart';
import 'package:rajemployment/utils/utility_class.dart';

import '../../../l10n/app_localizations.dart';
import '../../../utils/global.dart';
import '../loginscreen/provider/locale_provider.dart';
import 'provider/comera_provider.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {

 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider  = Provider.of<CameraProvider>(context, listen: false);
      provider.clearData();
    });


  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    return Scaffold(
        appBar: commonAppBar2(AppLocalizations.of(context)!.videoprof, context,
            localeProvider.currentLanguage, "", false, "", onTapClick: () {
              localeProvider.toggleLocale();
            }),
      body: Consumer<CameraProvider>(
        builder: (BuildContext context, CameraProvider Provider, Widget? child) => Column(
          children: [
            Expanded(
              flex: 4,
              child: Center(
                child: Provider.isMerging
                    ? Container(
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  color: Colors.black,child: Text(AppLocalizations.of(context)!.loadVideo,style: TextStyle(color: Colors.white),),
                ) : ( Provider.chewieController != null &&
                    Provider.videoPlayerController != null &&
                    Provider.videoPlayerController!.value.isInitialized)
                    ? Container(
                  color: Colors.black,
                  child: Chewie(

                      controller: Provider.chewieController!),
                )
                    : Container(
                  height: double.infinity,
                  width: double.infinity,
                  alignment: Alignment.center,
                  color: Colors.black,child: Text(AppLocalizations.of(context)!.noVideo,style: TextStyle(color: Colors.white),),
                ),),
            ),
            Expanded(
              flex: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: SizeConfig.defaultSize,),
                    Text(AppLocalizations.of(context)!.recordLiveIntroVideo,style: UtilityClass.poppins(fontSize: 15, fontWeight: FontWeight.w700, color: kBlackColor),),SizedBox(height: SizeConfig.defaultSize,),
                    SizedBox(height: SizeConfig.defaultSize! * 0.05),
                    Text(AppLocalizations.of(context)!.recordVideoProfile3Step,style: UtilityClass.poppins(fontSize: 15, fontWeight: FontWeight.w300, color: kDartGrayColor),),SizedBox(height: SizeConfig.defaultSize,),
                    SizedBox(height: SizeConfig.defaultSize!  * 0.05),
                    SizedBox(
                      height: SizeConfig.screenHeight! * 0.45,
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: [
                          Provider.buildStepCard(1, AppLocalizations.of(context)!.yourBriefIntro,context),
                          Provider.buildStepCard(2, AppLocalizations.of(context)!.expertKeySkill,context),
                          Provider.buildStepCard(3, AppLocalizations.of(context)!.workExpDescribe,context),
                          Provider.buildUpload(context),],

                      ),
                    ),
                  ],
                ),
              ),
            ),

          ],

        ),
      ));
  }
}
