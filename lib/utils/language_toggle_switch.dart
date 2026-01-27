import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/role/job_seeker/loginscreen/provider/locale_provider.dart';
import 'package:toggle_switch/toggle_switch.dart';

class LanguageToggleSwitch extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(builder: (context,provider,child) => ToggleSwitch(
      minWidth: 40.0,
      minHeight: 25,
      cornerRadius: 20.0,
      borderColor: [kPrimaryColor],
      borderWidth: 1,
      activeBgColors: [
        [kPrimaryColor],
        [kPrimaryColor]
      ],
      activeFgColor: Colors.white,
      inactiveBgColor: Colors.transparent,
      inactiveFgColor: Colors.black,
      initialLabelIndex: provider.locale.languageCode == 'en' ? 1 : 0,
      totalSwitches: 2,
      labels: const ['Hi', 'En'],
      radiusStyle: true,
      onToggle:(index) {
        provider.toggleLocale();
      }

    )

    );
  }
}
