import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/widgets/primary_button.dart';
import 'package:home_keeps/widgets/wallet_component.dart';

class WalletEmptyScreen extends StatelessWidget {
  const WalletEmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'YOUR WALLET',
                      style: AppTextStyles.kicker.copyWith(
                        color: theme.colorScheme.onPrimaryFixed,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Text(
                      'Nothing here yet',
                      style: AppTextStyles.screenTitle.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Text(
                      'Add your first appliance and HomeKeep keeps its '
                      'warranty, invoice and service history in one place. '
                      'Start with whatever is easiest.',
                      style: AppTextStyles.body.copyWith(
                        color: theme.colorScheme.onPrimaryFixed,
                      ),
                    ),
                    SizedBox(height: 30.h),

                    AddPathRow(
                      icon: Icons.chat_bubble_outline,
                      title: 'Photograph the invoice',
                      subtitle: 'Fastest — we read the details for you',
                      onTap: () {
                        // TODO: navigate to invoice capture
                      },
                    ),
                    AddPathRow(
                      icon: Icons.crop_free,
                      title: 'Photograph the label',
                      subtitle: 'The sticker with the model and serial',
                      onTap: () {
                        // TODO: navigate to label capture
                      },
                    ),
                    AddPathRow(
                      icon: Icons.edit_outlined,
                      title: 'Enter it manually',
                      subtitle: 'Category is all we need to begin',
                      onTap: () {
                        // TODO: navigate to manual entry
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Sticky bottom CTA
            Padding(
              padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 20.h),
              child: PrimaryButton(
                onTap: () {
                  // TODO: navigate to the default add-appliance flow
                },
                title: 'Add an appliance',
                prefixIcon: Icon(
                  Icons.add,
                  size: 20.sp,
                  color: theme.colorScheme.onInverseSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
