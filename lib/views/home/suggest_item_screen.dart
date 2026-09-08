import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/navigation_controller.dart';
import 'package:home_keeps/views/auth/navigator_screen.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class StoreItemModel {
  final String id;
  final String title;
  final String store;
  final String purchaseDate;
  final String statusText;
  final String icon;
  bool isSelected;

  StoreItemModel({
    required this.id,
    required this.title,
    required this.store,
    required this.purchaseDate,
    required this.statusText,
    required this.icon,
    this.isSelected = false,
  });
}

class SuggestedItemsScreen extends StatefulWidget {
  const SuggestedItemsScreen({super.key});

  @override
  State<SuggestedItemsScreen> createState() => _SuggestedItemsScreenState();
}

class _SuggestedItemsScreenState extends State<SuggestedItemsScreen> {
  final List<StoreItemModel> _items = [
    StoreItemModel(
      id: '1',
      title: 'Bosch dishwasher',
      store: 'Electra Home',
      purchaseDate: 'Oct 2024',
      statusText: 'In warranty',
      icon: "assets/images/q-washer.png",
      isSelected: true,
    ),
    StoreItemModel(
      id: '2',
      title: 'Samsung fridge',
      store: 'Electra Home',
      purchaseDate: 'Apr 2026',
      statusText: 'In warranty',
      icon: "assets/images/q-fridge.png",
      isSelected: true,
    ),
    StoreItemModel(
      id: '3',
      title: 'Sony television',
      store: 'KSP Online',
      purchaseDate: 'Aug 2026',
      statusText: 'not yours?',
      icon: "assets/images/q-tv.png",
      isSelected: false,
    ),
  ];

  int get _selectedCount => _items.where((e) => e.isSelected).length;

  void _onSave() {
    final navigationController = Get.find<NavigationController>();
    navigationController.selectIndex(0);
    Get.offAll(
      () => const NavigatorScreen(),
      transition: Transition.rightToLeft,
    );
  }

  void _onNoneOfThese() {
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leadingWidth: 90.w,
        leading: GestureDetector(
          onTap: () => Navigator.of(context).maybePop(),
          child: Padding(
            padding: EdgeInsets.only(left: 16.w),
            child: Row(
              children: [
                Icon(
                  Icons.arrow_back,
                  size: 20.sp,
                  color: Theme.of(context).colorScheme.onPrimaryFixed,
                ),
                SizedBox(width: 4.w),
                Text(
                  'Back',
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 15.sp,
                    color: Theme.of(context).colorScheme.onPrimaryFixed,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Screen Title
              Text(
                'These look like yours',
                style: AppTextStyles.semiBold.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              SizedBox(height: 8.h),

              // Description
              Text(
                'Bought from stores we work with, under your phone number. Tick the ones you still have.',
                style: AppTextStyles.small.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              SizedBox(height: 20.h),

              // Items List
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ..._items.map((item) => _buildItemCard(item)),
                    SizedBox(height: 8.h),

                    // Information Disclaimer Card
                    Container(
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onPrimary,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20.sp,
                            color: Theme.of(context).colorScheme.onPrimaryFixed,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              "Anything you leave unticked we simply won't offer again. Nothing to explain, no forms.",
                              style: AppTextStyles.small.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Action Buttons
              SizedBox(height: 12.h),
              PrimaryButton(
                onTap: _selectedCount > 0 ? _onSave : null,
                title: 'Add $_selectedCount to my wallet',
              ),
              SizedBox(height: 16.h),
              Center(
                child: GestureDetector(
                  onTap: _onNoneOfThese,
                  child: Text(
                    'None of these are mine',
                    style: AppTextStyles.semiBold.copyWith(
                      fontSize: 15.sp,
                      color: Theme.of(context).colorScheme.onPrimaryFixed,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemCard(StoreItemModel item) {
    final bool isSelected = item.isSelected;

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: GestureDetector(
        onTap: () {
          setState(() {
            item.isSelected = !item.isSelected;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onPrimary,
            borderRadius: BorderRadius.circular(22.r),
            border: Border.all(
              color: isSelected
                  ? Theme.of(
                      context,
                    ).colorScheme.onPrimaryFixed.withOpacity(0.15)
                  : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              // Checkbox Toggle
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 26.w,
                height: 26.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isSelected
                      ? Theme.of(context).colorScheme.onPrimaryFixed
                      : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.onPrimaryFixed
                        : Theme.of(context).colorScheme.onSecondary,
                    width: 1.8,
                  ),
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        size: 16.sp,
                        color: Theme.of(context).colorScheme.onPrimary,
                      )
                    : null,
              ),
              SizedBox(width: 14.w),

              // Appliance Image Container
              SizedBox(
                width: 48.w,
                height: 48.h,

                child: Image.asset(
                  item.icon,
                  // size: 28.sp,
                  // color: isSelected
                  //     ? const Color(0xFF3F468F)
                  //     : const Color(0xFFA5ADBA),
                ),
              ),
              SizedBox(width: 14.w),

              // Title and Meta Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTextStyles.semiBold.copyWith(
                        fontSize: 16.sp,

                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${item.store} · ${item.purchaseDate} · ${item.statusText}',
                      style: AppTextStyles.small.copyWith(
                        fontSize: 11.sp,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
