import 'package:flutter/material.dart';

mixin StaggeredAnimationMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  late AnimationController animationController;
  late List<Animation<double>> fadeAnimations;
  late List<Animation<Offset>> slideAnimations;

  // 커스터마이징 가능한 속성들
  Duration get animationDuration => const Duration(milliseconds: 1200);
  int get itemCount => 5;
  double get staggerDelay => 0.15;
  double get fadeDelay => 0.4;
  Curve get animationCurve => Curves.easeOutCubic;
  Offset get slideOffset => const Offset(0, 0.3);

  void initStaggeredAnimation() {
    animationController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    fadeAnimations = List.generate(itemCount, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Interval(
            index * staggerDelay,
            (index * staggerDelay) + fadeDelay,
            curve: animationCurve,
          ),
        ),
      );
    });

    slideAnimations = List.generate(itemCount, (index) {
      return Tween<Offset>(begin: slideOffset, end: Offset.zero).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Interval(
            index * staggerDelay,
            (index * staggerDelay) + fadeDelay,
            curve: animationCurve,
          ),
        ),
      );
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController.forward();
    });
  }

  void disposeStaggeredAnimation() {
    animationController.dispose();
  }

  Widget buildAnimatedItem({required int index, required Widget child}) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: fadeAnimations[index],
          child: SlideTransition(
            position: slideAnimations[index],
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
