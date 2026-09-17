import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppSkeleton extends StatefulWidget {
  final double width;
  final double height;
  final double radius;

  const AppSkeleton({
    super.key,
    required this.width,
    required this.height,
    this.radius = 4,
  });

  @override
  State<AppSkeleton> createState() => _AppSkeletonState();
}

class _AppSkeletonState extends State<AppSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.radius.r),
            gradient: LinearGradient(
              begin: Alignment(-1.5 + (_controller.value * 3), 0),
              end: Alignment(-0.5 + (_controller.value * 3), 0),
              colors: const [
                Color(0xFFE8E8E8),
                Color(0xFFF7F7F7),
                Color(0xFFE8E8E8),
              ],
            ),
          ),
        );
      },
    );
  }
}
