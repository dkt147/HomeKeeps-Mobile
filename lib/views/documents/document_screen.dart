import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class PaperworkDocItem {
  final IconData icon;
  final String title;
  final String meta;

  const PaperworkDocItem({
    required this.icon,
    required this.title,
    required this.meta,
  });
}

class ApplianceGroup {
  final String name;
  final int fileCount;
  final List<PaperworkDocItem> documents;

  const ApplianceGroup({
    required this.name,
    required this.fileCount,
    required this.documents,
  });
}

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  State<DocumentsScreen> createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  final _searchController = TextEditingController();

  final List<ApplianceGroup> _applianceGroups = const [
    ApplianceGroup(
      name: 'Bosch dishwasher',
      fileCount: 3,
      documents: [
        PaperworkDocItem(
          icon: Icons.receipt_long_outlined,
          title: 'Receipt',
          meta: 'PDF · 240 KB · Oct 2024',
        ),
        PaperworkDocItem(
          icon: Icons.assignment_outlined,
          title: 'Repair report · pump replaced',
          meta: 'Written by the technician · Feb 2026',
        ),
        PaperworkDocItem(
          icon: Icons.assignment_outlined,
          title: 'Repair report · door seal',
          meta: 'Written by the technician · Jun 2025',
        ),
      ],
    ),
    ApplianceGroup(
      name: 'Samsung fridge',
      fileCount: 2,
      documents: [
        PaperworkDocItem(
          icon: Icons.receipt_long_outlined,
          title: 'Receipt',
          meta: 'JPG · 1.2 MB · Apr 2026',
        ),
        PaperworkDocItem(
          icon: Icons.verified_user_outlined,
          title: 'Protection certificate',
          meta: 'PDF · 96 KB · Apr 2026',
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your\npaperwork',
                    style: AppTextStyles.semiBold.copyWith(
                      height: 1.1,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(
                      Icons.upload_outlined,
                      size: 16.sp,
                      color: Theme.of(context).colorScheme.onPrimaryFixed,
                    ),
                    label: Text(
                      'Export',
                      style: AppTextStyles.small.copyWith(
                        color: Theme.of(context).colorScheme.onPrimaryFixed,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.onPrimary,
                      elevation: 0,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 10.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                  ),
                ],
              ),
              10.verticalSpace,
              Container(
                height: 54.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onPrimary,
                  borderRadius: BorderRadius.circular(24.r),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.search,
                      size: 18.sp,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: TextField(
                        onTapOutside: (event) =>
                            FocusManager.instance.primaryFocus?.unfocus(),
                        controller: _searchController,
                        style: AppTextStyles.small.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          border: InputBorder.none,
                          hintText: 'Search receipts and reports',
                          hintStyle: AppTextStyles.small.copyWith(
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              20.verticalSpace,
              for (final group in _applianceGroups) ...[
                // Group Header
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: Row(
                    children: [
                      // Appliance Thumbnail Icon
                      SizedBox(
                        width: 28.w,
                        height: 36.h,

                        child: Image.asset(
                          "assets/images/q-washer.png",
                          // scale: 3.0,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Text(
                        group.name,
                        style: AppTextStyles.semiBold.copyWith(
                          fontSize: 15.sp,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${group.fileCount} files',
                        style: AppTextStyles.small.copyWith(
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8.h),

                // Document List Items for Group
                for (final doc in group.documents)
                  Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      borderRadius: BorderRadius.circular(24.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          doc.icon,
                          size: 20.sp,
                          color: Theme.of(context).colorScheme.onPrimaryFixed,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doc.title,
                                style: AppTextStyles.semiBold.copyWith(
                                  fontSize: 15.sp,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                doc.meta,
                                style: AppTextStyles.small.copyWith(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: Icon(
                            Icons.share_outlined,
                            size: 18.sp,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                SizedBox(height: 30.h),
              ],
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(
          right: 20.w,
          left: 20.w,
          bottom: 10.h,
          // top: 10.h,
        ),
        child: PrimaryButton(
          onTap: () {},
          title: "Add a receipt",
          prefixIcon: Icon(
            Icons.camera_alt_outlined,
            size: 18.sp,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
