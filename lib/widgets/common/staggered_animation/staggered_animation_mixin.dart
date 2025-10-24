import 'package:flutter/material.dart';

/// Sliver 위젯과 일반 위젯 모두에서 사용 가능한 순차적 애니메이션 Mixin
mixin StaggeredAnimationMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  late AnimationController animationController;

  // 커스터마이징 가능한 속성들
  Duration get animationDuration => const Duration(milliseconds: 1200);
  double get staggerDelay => 0.1; // 각 아이템 간 지연 시간 (초)
  double get itemAnimationDuration => 0.5; // 각 아이템의 애니메이션 길이 (초)
  Curve get animationCurve => Curves.easeOutCubic;
  Offset get slideOffset => const Offset(0, 30);

  void initStaggeredAnimation() {
    animationController = AnimationController(
      duration: animationDuration,
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      animationController.forward();
    });
  }

  void disposeStaggeredAnimation() {
    animationController.dispose();
  }

  /// 일반 위젯용 애니메이션
  Widget buildAnimatedItem({
    required int index,
    required Widget child,
    Offset? customSlideOffset,
    bool scaleAnimation = false,
  }) {
    final start = (index * staggerDelay).clamp(0.0, 1.0);
    final end = (start + itemAnimationDuration).clamp(0.0, 1.0);

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(start, end, curve: animationCurve),
      ),
    );

    final slideAnimation =
        Tween<Offset>(
          begin: customSlideOffset ?? slideOffset,
          end: Offset.zero,
        ).animate(
          CurvedAnimation(
            parent: animationController,
            curve: Interval(start, end, curve: animationCurve),
          ),
        );

    final scaleAnim = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(start, end, curve: Curves.easeOutBack),
      ),
    );

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        Widget result = child!;

        if (scaleAnimation) {
          result = Transform.scale(scale: scaleAnim.value, child: result);
        }

        result = Transform.translate(
          offset: slideAnimation.value,
          child: result,
        );

        result = Opacity(opacity: fadeAnimation.value, child: result);

        return result;
      },
      child: child,
    );
  }

  /// SliverList 아이템용 애니메이션 (일반 위젯 반환)
  Widget buildSliverAnimatedItem({
    required int index,
    required Widget child,
    Offset? customSlideOffset,
  }) {
    return buildAnimatedItem(
      index: index,
      child: child,
      customSlideOffset: customSlideOffset,
    );
  }

  /// SliverToBoxAdapter용 애니메이션
  SliverToBoxAdapter buildAnimatedSliverBox({
    required int index,
    required Widget child,
    Offset? customSlideOffset,
    bool scaleAnimation = false,
  }) {
    return SliverToBoxAdapter(
      child: buildAnimatedItem(
        index: index,
        child: child,
        customSlideOffset: customSlideOffset,
        scaleAnimation: scaleAnimation,
      ),
    );
  }

  /// 페이드만 적용하는 애니메이션
  Widget buildFadeItem({required int index, required Widget child}) {
    final start = (index * staggerDelay).clamp(0.0, 1.0);
    final end = (start + itemAnimationDuration).clamp(0.0, 1.0);

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(start, end, curve: animationCurve),
      ),
    );

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Opacity(opacity: fadeAnimation.value, child: child);
      },
      child: child,
    );
  }

  /// 스케일 애니메이션
  Widget buildScaleItem({required int index, required Widget child}) {
    final start = (index * staggerDelay).clamp(0.0, 1.0);
    final end = (start + itemAnimationDuration).clamp(0.0, 1.0);

    final scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(start, end, curve: Curves.easeOutBack),
      ),
    );

    final fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Interval(start, end, curve: animationCurve),
      ),
    );

    return AnimatedBuilder(
      animation: animationController,
      builder: (context, child) {
        return Opacity(
          opacity: fadeAnimation.value,
          child: Transform.scale(scale: scaleAnimation.value, child: child),
        );
      },
      child: child,
    );
  }
}
