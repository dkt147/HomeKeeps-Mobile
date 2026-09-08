import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/widgets/primary_button.dart';

class OpenCaseExistsScreen extends StatefulWidget {
  final String caseNumber; // "#4471"
  final String issueTitle; // "Water isn't draining"
  final String
  caseStatusLine; // "Opened 24.08.2026 · technician scheduled Thursday"
  final ValueChanged<String>? onAddComment;
  final VoidCallback? onShowCase;

  const OpenCaseExistsScreen({
    super.key,
    required this.caseNumber,
    required this.issueTitle,
    required this.caseStatusLine,
    this.onAddComment,
    this.onShowCase,
  });

  @override
  State<OpenCaseExistsScreen> createState() => _OpenCaseExistsScreenState();
}

class _OpenCaseExistsScreenState extends State<OpenCaseExistsScreen> {
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _commentController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  bool get _canSubmit => _commentController.text.trim().isNotEmpty;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hintColor = theme.colorScheme.onPrimaryFixed;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.chat_bubble_outline,
                size: 30.sp,
                color: theme.colorScheme.primary,
              ),
              SizedBox(height: 16.h),

              Text(
                'You already have a request open on this appliance',
                style: AppTextStyles.screenTitle.copyWith(
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 12.h),

              Text(
                "Rather than start a second one, add what's changed to the "
                "request that's already moving.",
                style: AppTextStyles.body.copyWith(color: hintColor),
              ),
              SizedBox(height: 20.h),

              // Existing case card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(2.r),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CASE ${widget.caseNumber}',
                      style: AppTextStyles.kicker.copyWith(color: hintColor),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      widget.issueTitle,
                      style: AppTextStyles.listItemTitle.copyWith(
                        fontSize: 17.sp,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      widget.caseStatusLine,
                      style: AppTextStyles.metaCaption.copyWith(
                        color: hintColor,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 24.h),

              Text(
                'ADD A COMMENT',
                style: AppTextStyles.fieldLabel.copyWith(color: hintColor),
              ),
              SizedBox(height: 8.h),
              Container(
                height: 88.h,
                width: double.infinity,
                padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(2.r),
                ),
                child: TextField(
                  controller: _commentController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  style: AppTextStyles.body.copyWith(
                    color: theme.colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: "It's making a noise now as well...",
                    hintStyle: AppTextStyles.body.copyWith(color: hintColor),
                  ),
                ),
              ),
              SizedBox(height: 24.h),

              Opacity(
                opacity: _canSubmit ? 1 : 0.45,
                child: PrimaryButton(
                  onTap: _canSubmit
                      ? () => widget.onAddComment?.call(
                          _commentController.text.trim(),
                        )
                      : null,
                  title: 'Add to case ${widget.caseNumber}',
                ),
              ),
              SizedBox(height: 16.h),

              Center(
                child: GestureDetector(
                  onTap: widget.onShowCase,
                  child: Text(
                    'Just show me the case',
                    style: AppTextStyles.buttonLabel.copyWith(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.secondary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
