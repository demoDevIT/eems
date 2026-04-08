import 'package:flutter/cupertino.dart';
import 'package:rajemployment/constants/colors.dart';

import '../../../utils/size_config.dart';
import 'package:flutter_svg/flutter_svg.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color accentColor;
  // final IconData icon;
  final String iconPath;
  final VoidCallback? onTap;
  final bool isSelected;

  const StatCard({
    super.key,
    required this.title,
    this.value = "",
    required this.accentColor,
    // required this.icon,
    required this.iconPath,
    this.onTap,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: AnimatedContainer( // Add 'Animated' here
          duration: const Duration(milliseconds: 300), // Smooth 0.3s transition
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: isSelected ? accentColor : accentColor.withOpacity(0.1),
              width: isSelected ? 2.5 : 2,
            ),),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Stack(
            children: [
              // Subtle Watermark Icon
              // Positioned(
              //   right: -10,
              //   top: -10,
              //   child: Icon(
              //       icon,
              //       size: 70,
              //       color: accentColor.withOpacity(0.07)
              //   ),
              // ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SvgPicture.asset(
                      iconPath,
                      width: 50,
                      height: 50,
                    ),
                    // Icon circle pod
                    // Container(
                    //   padding: const EdgeInsets.all(10),
                    //   decoration: BoxDecoration(
                    //     color: accentColor.withOpacity(0.1),
                    //     shape: BoxShape.circle,
                    //   ),
                    //   // child: Icon(icon, color: accentColor, size: 24),
                    //   child: SvgPicture.asset(
                    //     iconPath,
                    //     width: 30,
                    //     height: 30,
                    //   ),
                    // ),

                    // Responsive Spacing
                    SizedBox(height: (SizeConfig.defaultSize ?? 10) * 2),

                    // Title Text
                    SizedBox(
                      width: double.infinity, // 👈 IMPORTANT
                      child: Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: kBlackColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          height: 1.2,
                        ),
                      ),
                    ),

                    if (value.isNotEmpty) ...[
                      SizedBox(height: (SizeConfig.defaultSize ?? 10) * 0.4),
                      Text(
                        value,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}