import 'package:flutter/material.dart';
import 'animated_configurations.dart';

class AnimatedSeparatedListView extends StatelessWidget {
  /// Required: number of items
  final int itemCount;

  /// Required: itemBuilder (animated)
  final IndexedWidgetBuilder itemBuilder;

  /// Required: separatorBuilder (non-animated)
  final IndexedWidgetBuilder separatorBuilder;

  /// Optional: Scroll behavior
  final ScrollController? controller;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final bool reverse;
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// Animation Configuration
  final ListAnimationType listAnimationType;
  final SlideConfiguration? slideConfiguration;
  final FadeInConfiguration? fadeInConfiguration;
  final ScaleConfiguration? scaleConfiguration;
  final FlipConfiguration? flipConfiguration;

  const AnimatedSeparatedListView({
    Key? key,
    required this.itemCount,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.controller,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
    this.reverse = false,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.listAnimationType = ListAnimationType.Slide,
    this.slideConfiguration,
    this.fadeInConfiguration,
    this.scaleConfiguration,
    this.flipConfiguration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimationLimiterWidget(
      child: ListView.separated(
        itemCount: itemCount,
        controller: controller,
        padding: padding,
        physics: physics,
        shrinkWrap: shrinkWrap,
        reverse: reverse,
        keyboardDismissBehavior: keyboardDismissBehavior,
        itemBuilder: (context, index) {
          return AnimationConfigurationClass.staggeredList(
            position: index,
            child: AnimatedItemWidget(
              listAnimationType: listAnimationType,
              fadeInConfiguration: fadeInConfiguration,
              scaleConfiguration: scaleConfiguration,
              slideConfiguration: slideConfiguration,
              flipConfiguration: flipConfiguration,
              child: itemBuilder(context, index),
            ),
          );
        },
        separatorBuilder: separatorBuilder,
      ),
    );
  }
}
