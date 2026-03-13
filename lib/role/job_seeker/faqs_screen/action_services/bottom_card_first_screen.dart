import 'package:flutter/material.dart';
import 'package:rajemployment/constants/colors.dart';

import '../model/common_response_model.dart';
import '../model/faqs_assistance_model.dart';

class BottomCardFirstScreen extends StatefulWidget {
  final List<ActionData> apiData;
  final ValueChanged<ActionData?>? onItemSelected;
  final IconData? icon;

  const BottomCardFirstScreen({
    super.key,
    required this.apiData,
    this.onItemSelected,
    this.icon,
  });

  @override
  State<BottomCardFirstScreen> createState() =>
      _BottomCardFirstScreenState();
}

class _BottomCardFirstScreenState
    extends State<BottomCardFirstScreen> {
  int selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.apiData.isEmpty) return const SizedBox.shrink();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.apiData.length,
      gridDelegate:
      const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3, // 👈 3 items per row
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 0.9, // 👈 adjust height here if needed
      ),
      itemBuilder: (context, index) {
        final data = widget.apiData[index];
        final bool isSelected = selectedIndex == index;
        Locale locale = Localizations.localeOf(context);

        return GestureDetector(
          onTap: () {
            setState(() {
              selectedIndex = index;
            });

            widget.onItemSelected?.call(data);
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(
                horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected
                  ? kPrimaryDark
                  : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected
                    ? kPrimaryDark
                    : Colors.grey.shade300,
              ),
              boxShadow: isSelected
                  ? [
                BoxShadow(
                  color: kPrimaryDark
                      .withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                )
              ]
                  : [],
            ),
            child: Center(
              child: Text(
                locale.languageCode == 'en' ? data.eventNameENG ?? "" : data.eventNameHI ?? "",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? Colors.white
                      : Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
