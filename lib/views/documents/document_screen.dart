import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:home_keeps/constants/text_styles.dart';
import 'package:home_keeps/controller/product_controller.dart';
import 'package:home_keeps/models/document_model.dart';
import 'package:home_keeps/widgets/app_skeleton.dart';
import 'package:home_keeps/widgets/primary_button.dart';
import 'package:file_picker/file_picker.dart';

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
  late final ProductController productController;
  final _searchController = TextEditingController();

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  @override
  void initState() {
    super.initState();
    productController = Get.isRegistered<ProductController>()
        ? Get.find<ProductController>()
        : Get.put(ProductController());

    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _load({bool silent = false}) {
    return productController.getDocuments(silent: silent);
  }

  // ---------------- Helpers ----------------

  String get _query => _searchController.text.trim().toLowerCase();

  // not_started -> Not started
  String _pretty(String? value) {
    if (value == null || value.isEmpty) return '';
    final s = value.replaceAll('_', ' ');
    return s[0].toUpperCase() + s.substring(1);
  }

  // Document type ka naam. Naye types yahan add kar sakte hain.
  String _typeLabel(String? type) {
    switch (type) {
      case 'invoice':
        return 'Receipt';
      case 'label':
        return 'Label';
      default:
        final p = _pretty(type);
        return p.isEmpty ? 'Document' : p;
    }
  }

  IconData _iconFor(String? type) {
    switch (type) {
      case 'invoice':
        return Icons.receipt_long_outlined;
      case 'label':
        return Icons.label_outline;
      default:
        return Icons.description_outlined;
    }
  }

  // application/pdf -> PDF, image/jpeg -> JPG
  String _ext(String? mime) {
    if (mime == null || mime.isEmpty) return '';
    if (mime == 'application/pdf') return 'PDF';
    final sub = mime.split('/').last.toLowerCase();
    if (sub == 'jpeg') return 'JPG';
    return sub.toUpperCase();
  }

  // 7863142 -> 7.5 MB
  String _fmtSize(int? bytes) {
    if (bytes == null) return '';
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).round()} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // Sep 2026
  String _monthYear(String? iso) {
    final d = DateTime.tryParse(iso ?? '')?.toLocal();
    if (d == null) return '';
    return '${_months[d.month - 1]} ${d.year}';
  }

  // Search: appliance ka naam, type, filename aur file type par
  bool _matches(AppDocument d, String q) {
    if (q.isEmpty) return true;
    final haystack = [
      d.productName,
      d.type,
      _typeLabel(d.type),
      d.originalFilename,
      _ext(d.mime),
    ].whereType<String>().join(' ').toLowerCase();
    return haystack.contains(q);
  }

  PaperworkDocItem _toItem(AppDocument d) {
    final meta = [
      _ext(d.mime),
      _fmtSize(d.sizeBytes),
      _monthYear(d.createdAt),
    ].where((e) => e.isNotEmpty).join(' · ');

    return PaperworkDocItem(
      icon: _iconFor(d.type),
      title: _typeLabel(d.type),
      meta: meta,
    );
  }

  // Appliance ke hisaab se group (pehli baar aane ke tarteeb mein)
  List<ApplianceGroup> _buildGroups(List<AppDocument> docs) {
    final byProduct = <String, List<AppDocument>>{};
    final names = <String, String>{};

    for (final d in docs) {
      final key = d.productId ?? 'other';
      byProduct.putIfAbsent(key, () => []).add(d);
      names.putIfAbsent(key, () => d.productName ?? 'Other');
    }

    return byProduct.entries
        .map(
          (e) => ApplianceGroup(
            name: names[e.key] ?? 'Other',
            fileCount: e.value.length,
            documents: e.value.map(_toItem).toList(),
          ),
        )
        .toList();
  }

  // ---------------- Build ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => _load(silent: true),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your\npaperwork',
                      style: AppTextStyles.semiBold.copyWith(
                        height: 1.1,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                10.verticalSpace,

                // Search
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
                          onChanged: (_) => setState(() {}),
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
                      if (_searchController.text.isNotEmpty)
                        GestureDetector(
                          onTap: () {
                            _searchController.clear();
                            setState(() {});
                          },
                          child: Icon(
                            Icons.close,
                            size: 18.sp,
                            color: Theme.of(context).colorScheme.onSecondary,
                          ),
                        ),
                    ],
                  ),
                ),
                20.verticalSpace,

                GetBuilder<ProductController>(
                  builder: (controller) {
                    if (controller.isDocumentsLoading) {
                      return _buildSkeleton();
                    }

                    if (controller.documentsError) {
                      return _buildError();
                    }

                    if (controller.documents.isEmpty) {
                      return _emptyText('No documents yet');
                    }

                    final filtered = controller.documents
                        .where((d) => _matches(d, _query))
                        .toList();

                    if (filtered.isEmpty) {
                      return _emptyText(
                        'Nothing matches "${_searchController.text.trim()}"',
                      );
                    }

                    final groups = _buildGroups(filtered);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (final group in groups) _buildGroup(group),
                        // Floating button ke neeche last item na chhupe
                        SizedBox(height: 70.h),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
        padding: EdgeInsets.only(right: 20.w, left: 20.w, bottom: 10.h),
        child: PrimaryButton(
          onTap: () => _openAddDocumentDialog(context),
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

  void _openAddDocumentDialog(BuildContext context) {
    String? selectedType;
    String? selectedProductId;
    PlatformFile? pickedFile;
    bool isLoadingProducts = productController.productModel?.data == null;
    bool isSubmitting = false;
    void Function(void Function())? setStateDialog;

    if (isLoadingProducts) {
      productController.getProduct().whenComplete(() {
        isLoadingProducts = false;
        setStateDialog?.call(() {});
      });
    }

    Get.dialog(
      StatefulBuilder(
        builder: (context, setState) {
          setStateDialog = setState;

          final products = productController.productModel?.data ?? [];

          Future<void> pickFile() async {
            final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
            );
            if (result != null && result.files.isNotEmpty) {
              setState(() => pickedFile = result.files.first);
            }
          }

          Future<void> submit() async {
            if (selectedType == null ||
                selectedProductId == null ||
                pickedFile?.path == null) {
              Get.snackbar(
                'Missing info',
                'Type, appliance aur file select karein',
              );
              return;
            }

            setState(() => isSubmitting = true);

            final ok = await productController.uploadDocument(
              productId: selectedProductId!,
              type: selectedType!,
              file: File(pickedFile!.path!),
            );

            if (ok) {
              Get.back();
            } else {
              setState(() => isSubmitting = false);
            }
          }

          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: AlertDialog(
              insetPadding: EdgeInsets.symmetric(horizontal: 15.w),
              backgroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.r),
              ),
              title: Text(
                "Add a document",
                style: AppTextStyles.dialogTitle.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      decoration: InputDecoration(
                        labelText: 'Document type',
                        labelStyle: AppTextStyles.body.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                      style: AppTextStyles.body.copyWith(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: 'invoice',
                          child: Text('Invoice'),
                        ),
                        DropdownMenuItem(value: 'label', child: Text('Label')),
                        DropdownMenuItem(
                          value: 'warranty_certificate',
                          child: Text('Warranty certificate'),
                        ),
                        DropdownMenuItem(value: 'other', child: Text('Other')),
                      ],
                      onChanged: (v) => setState(() => selectedType = v),
                    ),
                    SizedBox(height: 12.h),
                    isLoadingProducts
                        ? const Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          )
                        : DropdownButtonFormField<String>(
                            value: selectedProductId,
                            decoration: InputDecoration(
                              labelText: 'Appliance',
                              labelStyle: AppTextStyles.body.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                            ),
                            style: AppTextStyles.body.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            ),
                            items: products
                                .map<DropdownMenuItem<String>>(
                                  (p) => DropdownMenuItem(
                                    value:
                                        p.id, // <- adjust field name if needed
                                    child: Text(
                                      p.name ?? 'Unnamed',
                                    ), // <- adjust
                                  ),
                                )
                                .toList(),
                            onChanged: (v) =>
                                setState(() => selectedProductId = v),
                          ),
                    SizedBox(height: 12.h),
                    OutlinedButton.icon(
                      onPressed: pickFile,
                      icon: Icon(Icons.attach_file, size: 18.sp),
                      label: Text(
                        pickedFile?.name ?? 'Choose file',
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.body.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: isSubmitting
                      ? null
                      : () => Navigator.of(context).pop(),
                  child: Text(
                    "Cancel",
                    style: AppTextStyles.body.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: isSubmitting ? null : submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: isSubmitting
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Text(
                          "Upload",
                          style: AppTextStyles.buttonLabel.copyWith(
                            color: Theme.of(
                              context,
                            ).colorScheme.onInverseSurface,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                ),
              ],
            ),
          );
        },
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.35),
    );
  }

  // ---------------- Pieces ----------------

  Widget _emptyText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: AppTextStyles.small.copyWith(
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildError() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
      child: Center(
        child: Column(
          children: [
            Text(
              "Couldn't load your documents",
              style: AppTextStyles.small.copyWith(
                color: Theme.of(context).colorScheme.onSecondary,
              ),
            ),
            TextButton(onPressed: _load, child: const Text('Try again')),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (int g = 0; g < 2; g++) ...[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 5.h),
            child: Row(
              children: [
                AppSkeleton(width: 28.w, height: 36.h),
                SizedBox(width: 12.w),
                AppSkeleton(width: 150.w, height: 16.h),
                const Spacer(),
                AppSkeleton(width: 50.w, height: 12.h),
              ],
            ),
          ),
          SizedBox(height: 8.h),
          for (int i = 0; i < 2; i++)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: AppSkeleton(
                width: double.infinity,
                height: 64.h,
                radius: 24,
              ),
            ),
          SizedBox(height: 22.h),
        ],
      ],
    );
  }

  Widget _buildGroup(ApplianceGroup group) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Group Header
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Row(
            children: [
              // Appliance Thumbnail Icon
              SizedBox(
                width: 28.w,
                height: 36.h,
                child: Image.asset("assets/images/q-washer.png"),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  group.name,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.semiBold.copyWith(
                    fontSize: 15.sp,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Text(
                '${group.fileCount} ${group.fileCount == 1 ? 'file' : 'files'}',
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
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
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
                          color: Theme.of(context).colorScheme.onSecondary,
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
        SizedBox(height: 22.h),
      ],
    );
  }
}

class _AddDocumentDialog extends StatefulWidget {
  final ProductController controller;
  const _AddDocumentDialog({required this.controller});

  @override
  State<_AddDocumentDialog> createState() => _AddDocumentDialogState();
}

class _AddDocumentDialogState extends State<_AddDocumentDialog> {
  static const _typeOptions = [
    {'value': 'invoice', 'label': 'Invoice'},
    {'value': 'label', 'label': 'Label'},
    {'value': 'warranty_certificate', 'label': 'Warranty certificate'},
    {'value': 'other', 'label': 'Other'},
  ];

  String? _selectedType;
  String? _selectedProductId;
  PlatformFile? _pickedFile;
  bool _loadingProducts = false;

  @override
  void initState() {
    super.initState();
    if (widget.controller.productModel?.data == null) {
      _loadingProducts = true;
      widget.controller.getProduct().whenComplete(() {
        if (mounted) setState(() => _loadingProducts = false);
      });
    }
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() => _pickedFile = result.files.first);
    }
  }

  Future<void> _submit() async {
    if (_selectedType == null ||
        _selectedProductId == null ||
        _pickedFile?.path == null) {
      Get.snackbar('Missing info', 'Type, appliance aur file select karein');
      return;
    }

    final ok = await widget.controller.uploadDocument(
      productId: _selectedProductId!,
      type: _selectedType!,
      file: File(_pickedFile!.path!),
    );

    if (ok && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    // NOTE: `p.id` / `p.name` ko apne asal ProductModel field names se match karein
    final products = widget.controller.productModel?.data ?? [];

    return AlertDialog(
      title: const Text('Add a document'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DropdownButtonFormField<String>(
              value: _selectedType,
              decoration: const InputDecoration(labelText: 'Document type'),
              items: _typeOptions
                  .map(
                    (e) => DropdownMenuItem(
                      value: e['value'],
                      child: Text(e['label']!),
                    ),
                  )
                  .toList(),
              onChanged: (v) => setState(() => _selectedType = v),
            ),
            SizedBox(height: 12.h),
            _loadingProducts
                ? const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : DropdownButtonFormField<String>(
                    value: _selectedProductId,
                    decoration: const InputDecoration(labelText: 'Appliance'),
                    items: products
                        .map<DropdownMenuItem<String>>(
                          (p) => DropdownMenuItem(
                            value: p.id, // <- adjust
                            child: Text(p.name ?? 'Unnamed'), // <- adjust
                          ),
                        )
                        .toList(),
                    onChanged: (v) => setState(() => _selectedProductId = v),
                  ),
            SizedBox(height: 12.h),
            OutlinedButton.icon(
              onPressed: _pickFile,
              icon: const Icon(Icons.attach_file),
              label: Text(_pickedFile?.name ?? 'Choose file'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        GetBuilder<ProductController>(
          builder: (c) => ElevatedButton(
            onPressed: c.isUploadingDocument ? null : _submit,
            child: c.isUploadingDocument
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Upload'),
          ),
        ),
      ],
    );
  }
}
