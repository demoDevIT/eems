import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xff0914BF);
 const kPrimaryDark = Color(0xff0914BF);
 const kbuttonColor = Color(0xFF4D81E7);
const kIconsColor = Color(0xFF5D5fEf);
const kIconsBackColor = Color(0xFFDfDffc);
const kJobCardColor = Color(0xFFF5F6FC);
const kJobFlotBackColor = Color(0xFFE7F6EA);
const kJobFontColor = Color(0xFF0ba02c);
const kJobEventBackColor = Color(0xFFE3E5F9);
const kSchemesBackColor = Color(0xFF616bfa);
const kViewAllColor = Color(0xFF265df5);
const kHeaderBackground = Color(0xFFF1F4FE);
const Color grayLightColor = Color(0xff808080);
const klebleColor = Color(0xff03A3D3);
const fontGrayColor = Color(0xff767F8C);
const E1E1E1Color = Color(0xffE1E1E1);
const fafafaColor = Color(0xfffafafa);
// const kPrimaryDark = Color(0xFFD6AA83);
const kBlackColor = Color(0xFF000000);
const kWhite = Color(0xFFffffff);
const cardColor = Color(0xFFF6F4FF);
const Color borderColor = Color(0xffD7D7D7);
const kBluelogoColor = Color(0xFF1A213A);
// const kGreyColor = Color(0xFFd1d1d1);
const kGrayColor = Color(0xFFd1d1d1);
const kLightGrayColor = Color(0xFFD2F5F4F4);
const kDartGrayColor = Color(0xFF6C7278);
const kLightBlackColor = Color(0xFF232323);
const kDarkOrangeColor = Color(0xFFFF4500);
const kRedColor = Color(0xFFb60a15);
const kYellowColor = Color(0xFFdd870d);
const kTextColor = Color(0xFF9FA4FA);
const kTextColor1 = Color(0xFFffffff);
const kHintColor = Color(0xFFaad2fc);
const kGreenColor = Color(0xFF7cb044);
const kGreenLightColor = Color(0xFF43A047);
const kHoloBlueColor = Color(0xFF459fed);
const kSFColor = Color(0xFF72ceff);
const kSDFColor = Color(0xFF2ba3fc);
const kButtonColor = Color(0xFF6600cc);
const kBkgColor = Color(0xFFeb8807);
const kBkgColor2 = Color(0xFFf2bf5e);
const kyellowDarkColor = Color(0xE8E37D29);
const kCircleColor = Color(0xFF4BC493);
const backcolor = Color(0xFFEDF4FC);
const kyellowDarkColor2 = Color(0xFF91DEBC);
const kCircleColor2 = Color(0xFFEFE1CF);
const kthemecolor = Color(0xff0D0D0D);
const kthemecolornew = Color(0xAFCBCF);
const kthemecolortop = Color(0xFFEFD8B8);
const kthemecolorbottom = Color(0xFFD2C5F9);
const orange = Color(0xFFF93A0B2B);
const blue3066CDColor = Color(0xFFF3066CD);
const purpal455CDCColor = Color(0xFF455CDC);
const green46A500 = Color(0xFF46A500);
const grayBorderColor = Color(0xFFCCCCCC);
const green00C324 = Color(0xFF00C324);
const dividerColor = Color(0xFFFFF2ED);
const FFF2EDColor = Color(0xFFFFF2ED);
const B3362FFColor = Color(0xFF0B3362);
const E3E5F9Color = Color(0xFFE3E5F9);

/*const backgroundGradient = LinearGradient(
  colors: [kthemecolortop, kthemecolorbottom],
  begin: Alignment.topCenter,
  end: Alignment.bottomCenter,
);*/
LinearGradient backgroundGradient = LinearGradient(
  colors: [
    Color(0xFFEFD8B8), // top 80% opacity
    Color(0xFFD2C5F9), // bottom 80% opacity
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0.2, 1.0], // 20% peach, 80% lavender
);

LinearGradient backgroundGradient2 = LinearGradient(
  colors: [

    Color(0xFFD2C5F9), // bottom 80% opacity
    Color(0xFFFFFFFF), // top 80% opacity
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0.1, 1.0], // 20% peach, 80% lavender
);


LinearGradient kWhitedGradient = LinearGradient(
  colors: [
    kWhite, // top 80% opacity
    kWhite, // top
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0.2, 1.0], // 20% peach, 80% lavender
);

const backgroundGradient1 = LinearGradient(
  colors: [kPrimaryColor, kPrimaryDark],
  begin: Alignment.centerLeft,
  end: Alignment.centerRight,
);

LinearGradient jobsCardGradient = LinearGradient(
  colors: [
    Color.fromRGBO(249, 58, 11, 0.17), // rgba(249, 58, 11, 0.17)
    Color.fromRGBO(255, 255, 255, 0),  // rgba(255, 255, 255, 0)
    // top 80% opacityColor(0xFFD2C5F9), // bottom 80% opacity
    // top 80% opacityColor(0xFFD2C5F9), // bottom 80% opacity
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0.2, 1.0], // 20% peach, 80% lavender
);

LinearGradient backgroundGradient5 = LinearGradient(
  colors: [
    Color(0xFFEFD8B8), // top 80% opacity
    Color(0xFFD2C5F9), // bottom 80% opacity
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0.2, 1.0], // 20% peach, 80% lavender
);

const kLogoGradient = LinearGradient(
  colors: [
    Color(0xFF00B0F0), // Blue
    Color(0xFFFFB900), // Orange
    Color(0xFFB146C2), // Purple
    Color(0xFFE91E63), // Pink
  ],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  stops: [0.0, 0.33, 0.66, 1.0],
);


const MaterialColor kPrimarySwatchColor = const MaterialColor(
  0xE8E37D29,
  const <int, Color>{
    50: const Color(0xFF03A3D3),
    100: const Color(0xFF03A3D3),
    200: const Color(0xFF03A3D3),
    300: const Color(0xFF03A3D3),
    400: const Color(0xFF03A3D3),
    500: const Color(0xFF03A3D3),
    600: const Color(0xFF03A3D3),
    700: const Color(0xFF03A3D3),
    800: const Color(0xFF03A3D3),
    900: const Color(0xFF03A3D3),
  },
);