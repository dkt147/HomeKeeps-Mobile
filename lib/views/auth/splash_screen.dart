import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/views/auth/sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SignInPhoneScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),

              // Top thick line
              Container(
                width: 140,
                height: 3,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              SizedBox(height: 16.h),

              // Title
              Text(
                'HOMEKEEP',
                style: AppTextStyles.heading.copyWith(
                  letterSpacing: 4.0,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              const SizedBox(height: 12),

              // Middle thin line
              Container(
                width: 140,
                height: 1.5,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              SizedBox(height: 24.h),

              // Subtitle
              Text(
                'A smart wallet for everything in\nyour home.',
                style: AppTextStyles.body.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),

              const Spacer(),

              LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    children: [
                      // Light Grey Background Track
                      Container(
                        width: constraints.maxWidth,
                        height: 2.5,
                        color: const Color(0xFFE0E0E0),
                      ),
                      // Smooth Animating Blue Line
                      AnimatedBuilder(
                        animation: _animation,
                        builder: (context, child) {
                          return Container(
                            width: constraints.maxWidth * _animation.value,
                            height: 2.5,
                            color: Color(0xFF0088B0),
                          );
                        },
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
