import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/views/payment/warranty_purchase_screen.dart';
import 'package:home_keeps/widgets/app_form_field.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final _cardNumberController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  final _idNumberController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _idNumberController.dispose();
    super.dispose();
  }

  void _pay() {
    Get.to(
      () => WarrantyPurchaseSuccessScreen(
        applianceName: 'dishwasher',
        coverageEndDate: '12.10.2029',
        amountPaid: '₪690',
        certificateFileName: 'Warranty certificate',
        certificateMeta: 'PDF · HK-2026-004471',
        sentToPhoneNumber: '+972 50-712-4488',
      ),
      transition: Transition.rightToLeft,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = theme.colorScheme.onSurfaceVariant;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              30.verticalSpace,
              Row(
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 16.sp,
                    color: theme.colorScheme.secondary,
                  ),
                  SizedBox(width: 6.w),
                  Expanded(
                    child: Text(
                      'Secure payment page · pay.homekeep.co.il',
                      style: AppTextStyles.metaCaption.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 40.h),

              Text(
                'Paying ₪690',
                style: AppTextStyles.screenTitle.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 13.h),
              Text(
                'Extended warranty · Bosch dishwasher · 36 months',
                style: AppTextStyles.body.copyWith(color: hintColor),
              ),
              SizedBox(height: 33.h),

              // Card number
              AppFormField(
                label: 'CARD NUMBER',
                hint: '1234 5678 9012 3456',
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                trailing: Icon(
                  Icons.credit_card,
                  size: 18.sp,
                  color: hintColor,
                ),
              ),
              SizedBox(height: 20.h),

              // Expiry + CVV
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: AppFormField(
                      label: 'EXPIRY',
                      hint: 'MM / YY',
                      controller: _expiryController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: AppFormField(
                      label: 'CVV',
                      hint: '•••',
                      controller: _cvvController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20.h),

              // ID number
              AppFormField(
                label: 'ID NUMBER',
                hint: 'National ID',
                controller: _idNumberController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 28.h),

              PrimaryButton(onTap: _pay, title: 'Pay ₪690'),
              SizedBox(height: 16.h),

              // Trust note
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.shield_outlined,
                    size: 16.sp,
                    color: theme.colorScheme.secondary,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Card details are handled by the payment provider. '
                      'HomeKeep never sees or stores them.',
                      style: AppTextStyles.metaCaption.copyWith(
                        color: hintColor,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
