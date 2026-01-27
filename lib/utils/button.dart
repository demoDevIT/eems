import 'package:flutter/material.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/textstyles.dart';


Widget customButton(
  Function onPressed,
  String buttonText,
  String icon,
  BuildContext context, {
  Color? color,
  double? radius,
  Color? txtColor,
  Color? iconColor,
  Color? borderColor,
  double? height,
  double? width,
  double? fontSize,
}) {
  return InkWell(
    onTap: () {
      onPressed();
    },
    child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 10),
            gradient: LinearGradient(
              colors: [
                color ?? kBlackColor,
                color ?? kBlackColor
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
        height: height ?? 40,
        width: width ?? MediaQuery.of(context).size.width * 0.70,
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: Styles.semiBoldTextStyle(
              size: fontSize ?? 16,
              color: txtColor ?? kWhite),
        )),
  );
}

Widget customButton2(
  Function onPressed,
  String buttonText,
  String icon,
  BuildContext context, {
  Color? color,
  double? radius,
  Color? txtColor,
  Color? iconColor,
  Color? borderColor,
  double? height,
  double? width,
  double? fontSize,
}) {
  return InkWell(
    onTap: () {
      onPressed();
    },
    child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius ?? 10),
            border: Border.all(color: borderColor ?? kBlackColor)
            /*gradient:  LinearGradient(
              colors:  [color ?? ColorResources.appColor,color ?? ColorResources.appColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )*/
            ),
        height: height ?? 40,
        width: width ?? MediaQuery.of(context).size.width * 0.70,
        alignment: Alignment.center,
        child: Text(
          buttonText,
          style: Styles.semiBoldTextStyle(
              size: fontSize ?? 16, color: txtColor ??kBlackColor),
        )),
  );
}
