import 'package:flutter/material.dart';
import 'animated_configurations.dart'; // Your animation helper classes

class AnimatedGridView extends StatelessWidget {
  final int? columnCount; // optional: if null, calculated from screen width
  final int itemCount;
  final double childAspectRatio;
  final double spacing;
  final Widget Function(BuildContext, int) itemBuilder;

  // Animation settings
  final ListAnimationType listAnimationType;
  final SlideConfiguration? slideConfiguration;
  final FadeInConfiguration? fadeInConfiguration;
  final ScaleConfiguration? scaleConfiguration;
  final FlipConfiguration? flipConfiguration;

  const AnimatedGridView({
    Key? key,
    this.columnCount,
    required this.itemCount,
    required this.itemBuilder,
    this.childAspectRatio = 1.2,
    this.spacing = 5.0,
    this.listAnimationType = ListAnimationType.Slide,
    this.slideConfiguration,
    this.fadeInConfiguration,
    this.scaleConfiguration,
    this.flipConfiguration,
  }) : super(key: key);

  /// This replicates your function exactly
  int getCrossAxisCount(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    if (screenWidth >= 600) {
      return 3;
    } else {
      return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final columns = columnCount ?? getCrossAxisCount(context);

    return AnimationLimiterWidget(
      child: GridView.count(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
        physics: const BouncingScrollPhysics(),
        children: List.generate(itemCount, (index) {
          return AnimationConfigurationClass.staggeredGrid(
            position: index,
            columnCount: columns,
            child: AnimatedItemWidget(
              listAnimationType: listAnimationType,
              fadeInConfiguration: fadeInConfiguration,
              scaleConfiguration: scaleConfiguration,
              slideConfiguration: slideConfiguration,
              flipConfiguration: flipConfiguration,
              child: itemBuilder(context, index),
            ),
          );
        }),
      ),
    );
  }
}
