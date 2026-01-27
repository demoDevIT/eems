import 'package:flutter/material.dart';

import '../constants/colors.dart';

class DatePickerHelper {
  Future<DateTime?> showDatePickerDialog({
    required BuildContext context,
    DateTime? initialDate,
    DateTime? firstDate,
    DateTime? lastDate,
  }) async {
    initialDate ??= DateTime.now();
    firstDate ??= DateTime(1900);
    lastDate ??= DateTime.now().add(const Duration(days: 365 * 100));

    return await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kPrimaryDark,
              onPrimary: kTextColor1,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: kPrimaryDark,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
  }
}
