import 'package:flutter/material.dart';
import 'package:rajemployment/utils/textstyles.dart';

import '../constants/colors.dart';




Widget buildDropdownField(
    String label,
    String hint, {
      required String? value,
      required List<String> items,
      required ValueChanged<String?> onChanged,
    }) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [

        //Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
        DropdownButtonFormField<String>(
          isExpanded: true,
          value: value,
          decoration: InputDecoration(

            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),

            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(
                color: borderColor, // 👉 Default border color
                width: 0.5,          // 👉 Default border width
              ),
            ),

            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: borderColor, // 👉 Default border color
        width: 0.5,          // 👉 Default border width
      ),
    ),
          ),


          hint: Text(hint),
          items: items
              .map((e) => DropdownMenuItem(value: e, child: Text(e)))
              .toList(),
          onChanged: onChanged,
        ),
      ],
    ),
  );
}

Widget buildDropdownWithBorderField({
  required List<dynamic> items,
  required TextEditingController controller,
  required TextEditingController idController,
  String? hintText,
  double? width,
  double? height,
  String? type,
  Color? color,
  Widget? postfixIcon,
  bool isEnable = true,
  Function(String?)? onChanged,
  BorderRadius? borderRadius,
}) {
  String? selectedValue =
  items.any((item) => item.name.toString() == controller.text)
      ? controller.text
      : null;
  return StatefulBuilder(
    builder: (BuildContext context, StateSetter setState) {
      return  Container(
        width: width ?? double.infinity,
        height: height ?? 50.0,
        decoration: BoxDecoration(
          color: color ?? kWhite,
          borderRadius: borderRadius ?? BorderRadius.circular(10),
          border: Border.all(color: borderColor, width: 0.5),
        ),
        child: Center(
          child: DropdownButton<String>(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            dropdownColor:kWhite,
            value: selectedValue,
            // Ensured valid
            isExpanded: true,
            hint: Text(
              hintText ?? 'Select an option',
              style: Styles.regularTextStyle(
                  size: 14, color:fontGrayColor),
            ),
            icon: postfixIcon ?? const Icon(Icons.arrow_drop_down, color: fontGrayColor),
            style: Styles.regularTextStyle(
                size: 14, color: kBlackColor),
            underline: const SizedBox(),
            // Removes the default underline
            items: items.map((dynamic item) {
              return DropdownMenuItem<String>(
                value: item.name.toString() ?? "Unknown",
                // Ensure it's not null
                child: Text(item.name.toString() ?? "Unknown"),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue;
                final selectedItem = items.firstWhere((item) => item.name.toString() == newValue);
                controller.text = newValue ?? '';
                idController.text = selectedItem.dropID.toString();
                if (onChanged != null) {
                  onChanged(newValue);
                }
              });
            },
          ),
        ) ,
      ) ;
    },
  );
}
