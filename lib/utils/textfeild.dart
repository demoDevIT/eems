import 'package:flutter/material.dart';
import 'package:rajemployment/constants/colors.dart';
import 'package:rajemployment/utils/textstyles.dart';


Widget buildTextWithBorderField(
    TextEditingController controller,
    String hintText,
    double width,
    double height,
    TextInputType keyboardType, {
      Widget? postfixIcon,
      Function(String)? fun,
      String? Function(String?)? validator,
      var inputFormatters,
      bool isObsecure = false,
      bool ishint = false,
      Widget? prefixIcon,
      bool isEnabled = true,
      int maxLine = 1,
      var align,
      Color? boxColor,
      Color? bodercolor,
      Color? txtColor,
      double? borderRadius,
      double? contentPadding,
      int? textLenght,
      TextStyle? txtStyle,
      bool uppercase = false,
      bool readData = false,
    }) {
  return Container(
    //Type TextField
    alignment: Alignment.center,
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: boxColor ?? kWhite,
      borderRadius: BorderRadius.circular(borderRadius ?? 10),
      border: Border.all(
        color:bodercolor ?? borderColor, // or any color you want
        width: 1, // you can change the width as needed
      ),
    ),
    child: TextFormField(
        inputFormatters: inputFormatters,
        maxLength: textLenght,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        textAlign: align ?? TextAlign.start,
        readOnly: readData,
        textCapitalization: TextCapitalization.none,
        enabled: isEnabled,
        controller: controller,
        obscuringCharacter: '*',
        obscureText: isObsecure,
        maxLines: maxLine,
        autofocus: false,
        validator: validator,
        // <--- Set this to false
        onChanged: (text) {
          fun?.call(text);
        },

        keyboardType: keyboardType,
        decoration: InputDecoration(
            fillColor: Colors.transparent,
            filled: true,
            counterText: '',
            suffixIcon: postfixIcon,
            prefixIcon: prefixIcon,
            /*contentPadding: EdgeInsets.all(contentPadding ?? 0),*/
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            hintText: hintText,
            // pass the hint text parameter here
            hintStyle: txtStyle ?? Styles.regularTextStyle(
                size: 14,
                color: txtColor ?? fontGrayColor)),
        style: txtStyle ?? Styles.regularTextStyle(size: 14, color: txtColor ?? kBlackColor)),
  );
}

Widget buildTextWithBorderWhiteBgField(
  TextEditingController controller,
  String hintText,
  double width,
  double height,
  TextInputType keyboardType, {
  Widget? postfixIcon,
  Function? fun,
  var inputFormatters,
  bool isObsecure = false,
  bool ishint = false,
  Widget? prefixIcon,
  bool isEnabled = true,
  int maxLine = 1,
  var align,
  Color? boxColor,
  Color? txtColor,
  int? textLenght,
  TextStyle? txtStyle,
  bool uppercase = false,
  bool readData = false,
}) {
  return Container(
    //Type TextField
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: boxColor ?? kWhite,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color:borderColor, width: 0.5),
    ),
    child: TextField(
        inputFormatters: inputFormatters,
        maxLength: textLenght,
        textAlign: align ?? TextAlign.start,
        readOnly: readData,
        textCapitalization: TextCapitalization.none,
        enabled: isEnabled,
        controller: controller,
        obscuringCharacter: '*',
        obscureText: isObsecure,
        maxLines: maxLine,
        autofocus: false,
        // <--- Set this to false
        onChanged: (text) {
          if (fun != null) {
            fun(text);
          }
        },
        keyboardType: keyboardType,
        decoration: InputDecoration(
            fillColor: Colors.transparent,
            filled: true,
            counterText: '',
            suffixIcon: postfixIcon,
            prefixIcon: prefixIcon,
            contentPadding: ishint == true
                ? const EdgeInsets.all(5.0)
                : const EdgeInsets.all(5.0),
            border: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            focusedBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            disabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25)),
              borderSide: BorderSide(color: Colors.transparent),
            ),
            hintText: hintText,
            // pass the hint text parameter here
            hintStyle: txtStyle ??
                Styles.mediumTextStyle(
                    size: 14,
                    color: txtColor ?? grayLightColor)),
        style: txtStyle ??
            Styles.mediumTextStyle(
                size: 14, color: txtColor ?? grayLightColor)),
  );
}

Widget labelWithStar(String text, {bool required = false,double size = 14,}) {
  return RichText(
    text: TextSpan(
      text: text,
      style: Styles.mediumTextStyle(
          color: kBlackColor, size: size),
      children: required
          ? const [TextSpan(text: ' *', style: TextStyle(color: Colors.red))]
          : const [],
    ),
  );
}
