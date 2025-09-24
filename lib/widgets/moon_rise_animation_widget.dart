import 'package:flutter/material.dart';

class MoonriseAnimation extends StatefulWidget {
  const MoonriseAnimation({super.key});

  @override
  State<MoonriseAnimation> createState() => _MoonriseAnimationState();
}

class _MoonriseAnimationState extends State<MoonriseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _moonRiseAnimation;
  late Animation<double> _glowAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..forward();

    _moonRiseAnimation = Tween<double>(
      begin: 300,
      end: 50,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _glowAnimation = Tween<double>(begin: 0.0, end: 15.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C2541), // 밤하늘 배경
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Stack(
            children: [
              // 달
              Positioned(
                left: MediaQuery.of(context).size.width / 2 - 40,
                bottom: _moonRiseAnimation.value,
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFFFFF5C2),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFFF5C2).withOpacity(0.6),
                        blurRadius: _glowAnimation.value,
                        spreadRadius: _glowAnimation.value / 2,
                      ),
                    ],
                  ),
                ),
              ),
              // 지평선 (밑에 어두운 영역)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.transparent, Color(0xFF0B132B)],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
