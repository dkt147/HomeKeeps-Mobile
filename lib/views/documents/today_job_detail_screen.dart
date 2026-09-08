import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/views/documents/closing_onsite_screen.dart';

class TodaysJobDetailScreen extends StatelessWidget {
  final VoidCallback? onBackTap;
  final VoidCallback? onNavigateTap;
  final VoidCallback? onCallTap;
  final VoidCallback? onOnMyWayTap;
  final VoidCallback? onCloseJobTap;

  const TodaysJobDetailScreen({
    super.key,
    this.onBackTap,
    this.onNavigateTap,
    this.onCallTap,
    this.onOnMyWayTap,
    this.onCloseJobTap,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F0F8),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Navigation Back Button
                    GestureDetector(
                      onTap:
                          onBackTap ?? () => Navigator.of(context).maybePop(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.arrow_back,
                            size: 16.sp,
                            color: const Color(0xFF703CA1),
                          ),
                          SizedBox(width: 6.w),
                          Text(
                            "Today's jobs",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF703CA1),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Appliance Header Section
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 54.w,
                          height: 64.h,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.04),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Icon(
                              Icons.kitchen_outlined,
                              size: 36.sp,
                              color: const Color(0xFF281E4B).withOpacity(0.3),
                            ),
                          ),
                        ),
                        SizedBox(width: 14.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'CASE 24-10583 · TODAY 14:00–16:00',
                                style: TextStyle(
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xFF8A84A6),
                                  letterSpacing: 0.6,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'Bosch dishwasher',
                                style: TextStyle(
                                  fontSize: 22.sp,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF281E4B),
                                  height: 1.1,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'SMV4HVX00E · FD9902 004417',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: const Color(0xFF8A84A6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 18.h),

                    // "WHO PAYS" Dark Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF23143B),
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WHO PAYS',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF988FB6),
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            "Maker's warranty — Bosch",
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Take no payment on site. Parts and labour are billed to BSH, not the customer.',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFFBDB8D6),
                              height: 1.35,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // "WHERE" Location & Contact Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WHERE',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF8A84A6),
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'Herzl 12, apt 7, Ramat Gan',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF281E4B),
                            ),
                          ),
                          SizedBox(height: 2.h),
                          Text(
                            'Entry code 4471 · second floor, no lift',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: const Color(0xFF8A84A6),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Row(
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 42.h,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF703CA1),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          21.r,
                                        ),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: onNavigateTap ?? () {},
                                    icon: Icon(
                                      Icons.near_me_outlined,
                                      size: 16.sp,
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'Navigate',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: SizedBox(
                                  height: 42.h,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFEDE6F5),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          21.r,
                                        ),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: onCallTap ?? () {},
                                    icon: Icon(
                                      Icons.call_outlined,
                                      size: 16.sp,
                                      color: const Color(0xFF703CA1),
                                    ),
                                    label: Text(
                                      'Call Dana',
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF703CA1),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // "WHAT SHE REPORTED" Issue Details Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'WHAT SHE REPORTED',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF8A84A6),
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            'The water won\'t drain',
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF281E4B),
                            ),
                          ),
                          SizedBox(height: 6.h),
                          Text(
                            '“Started two days ago. There\'s water sitting at the bottom after every cycle and it smells.”',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontStyle: FontStyle.italic,
                              color: const Color(0xFF5E5873),
                              height: 1.35,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Row(
                            children: [
                              _photoThumbnail(),
                              SizedBox(width: 10.w),
                              _photoThumbnail(),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 14.h),

                    // "BEEN HERE BEFORE" History Log Card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(18.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'BEEN HERE BEFORE',
                            style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF8A84A6),
                              letterSpacing: 0.8,
                            ),
                          ),
                          SizedBox(height: 10.h),
                          _historyRow('Pump replaced', 'Feb 2026'),
                          SizedBox(height: 8.h),
                          _historyRow('Door seal replaced', 'Jun 2025'),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                ),
              ),
            ),

            // Bottom Action Buttons Area
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
              child: Column(
                children: [
                  // Secondary Action: Tell Her I'm On My Way
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFE2D8ED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        elevation: 0,
                      ),
                      onPressed: onOnMyWayTap ?? () {},
                      icon: Icon(
                        Icons.near_me_outlined,
                        size: 18.sp,
                        color: const Color(0xFF703CA1),
                      ),
                      label: Text(
                        "Tell her I'm on my way",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF703CA1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),

                  // Primary Action: Close the Job
                  SizedBox(
                    width: double.infinity,
                    height: 50.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF703CA1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25.r),
                        ),
                        elevation: 0,
                      ),
                      onPressed:
                          onCloseJobTap ??
                          () {
                            Get.to(
                              () => ClosingOnSiteScreen(),
                              transition: Transition.rightToLeft,
                            );
                          },
                      child: Text(
                        'Close the job',
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Photo Thumbnail Placeholder Card Widget
  Widget _photoThumbnail() {
    return Container(
      width: 64.w,
      height: 64.h,
      decoration: BoxDecoration(
        color: const Color(0xFF23143B),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: EdgeInsets.all(8.w),
            child: Icon(
              Icons.grid_on_rounded,
              size: 28.sp,
              color: Colors.white.withOpacity(0.3),
            ),
          ),
          Container(
            height: 20.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF4370AC).withOpacity(0.8),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(12.r),
                bottomRight: Radius.circular(12.r),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Service History Detail Row
  Widget _historyRow(String task, String date) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          task,
          style: TextStyle(
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF281E4B),
          ),
        ),
        Text(
          date,
          style: TextStyle(fontSize: 12.sp, color: const Color(0xFF8A84A6)),
        ),
      ],
    );
  }
}
