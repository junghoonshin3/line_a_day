import 'package:flutter/material.dart';

class StaggeredAnimationWrapper extends StatefulWidget {
  final List<Widget> children;
  final Duration duration;
  final double staggerDelay; // 각 아이템 간 지연 (0.0 ~ 1.0)
  final double fadeDelay; // 페이드 인 시간 (0.0 ~ 1.0)
  final Curve curve;
  final Offset slideOffset; // 슬라이드 시작 오프셋
  final bool autoStart; // 자동 시작 여부

  const StaggeredAnimationWrapper({
    super.key,
    required this.children,
    this.duration = const Duration(milliseconds: 1200),
    this.staggerDelay = 0.15,
    this.fadeDelay = 0.4,
    this.curve = Curves.easeOutCubic,
    this.slideOffset = const Offset(0, 0.3),
    this.autoStart = true,
  });

  @override
  State<StaggeredAnimationWrapper> createState() =>
      _StaggeredAnimationWrapperState();
}

class _StaggeredAnimationWrapperState extends State<StaggeredAnimationWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _fadeAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(duration: widget.duration, vsync: this);

    _fadeAnimations = List.generate(widget.children.length, (index) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * widget.staggerDelay,
            (index * widget.staggerDelay) + widget.fadeDelay,
            curve: widget.curve,
          ),
        ),
      );
    });

    _slideAnimations = List.generate(widget.children.length, (index) {
      return Tween<Offset>(begin: widget.slideOffset, end: Offset.zero).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            index * widget.staggerDelay,
            (index * widget.staggerDelay) + widget.fadeDelay,
            curve: widget.curve,
          ),
        ),
      );
    });

    if (widget.autoStart) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _controller.forward();
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.children.length,
        (index) => AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FadeTransition(
              opacity: _fadeAnimations[index],
              child: SlideTransition(
                position: _slideAnimations[index],
                child: child,
              ),
            );
          },
          child: widget.children[index],
        ),
      ),
    );
  }
}
