import 'dart:async';
import 'dart:io';

import 'package:home_keeps/controller/base_controller.dart';
import 'package:home_keeps/data/response/api_response.dart';
import 'package:home_keeps/models/ocr_model.dart';
import 'package:home_keeps/repository/ocr_repo.dart';

class OcrController extends BaseController {
  final OcrRepo ocrRepo = OcrRepo();

  bool isUploading = false;
  bool isPolling = false;
  bool isSaving = false;
  String? jobId;
  OcrJobModel? job;

  Timer? _pollTimer;
  int _pollAttempts = 0;
  static const int _maxPollAttempts = 20; // ~40s total at 2s interval
  static const Duration _pollInterval = Duration(seconds: 2);

  /// Step 1: upload the captured image + chosen document type.
  /// Step 2 (internally): poll the status endpoint until it's ready.
  Future<bool> submitForOcr({
    required File imageFile,
    required String documentType,
  }) async {
    bool success = false;
    try {
      isUploading = true;
      update();

      final result = await ocrRepo.createOcrJob(
        file: imageFile,
        type: documentType,
      );

      final data = result["data"];
      if (data != null && data["job_id"] != null) {
        jobId = data["job_id"];
        job = OcrJobModel.fromJson(data);
        isUploading = false;
        update();

        await _pollUntilDone(jobId!);
        success = job?.isReadyForReview == true;
      } else {
        handleError(
          result["message"] ?? "Couldn't upload the photo. Try again.",
        );
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      isUploading = false;
      setApiResponse(ApiResponse.completed(null));
      update();
    }
    return success;
  }

  Future<void> _pollUntilDone(String jobId) async {
    isPolling = true;
    _pollAttempts = 0;
    update();

    final completer = Completer<void>();

    _pollTimer = Timer.periodic(_pollInterval, (timer) async {
      _pollAttempts++;
      try {
        final result = await ocrRepo.getOcrJobStatus(jobId);
        final data = result["data"];
        if (data != null) {
          job = OcrJobModel.fromJson(data);
          update();

          if (job!.isReadyForReview || job!.isFailed) {
            timer.cancel();
            isPolling = false;
            if (job!.isFailed) {
              handleError(
                job!.errorMessage ?? "Couldn't read the photo. Try again.",
              );
            }
            setApiResponse(ApiResponse.completed(null));
            update();
            if (!completer.isCompleted) completer.complete();
          }
        }
      } catch (e) {
        // transient network hiccup while polling - keep trying till the cap,
        // don't surface every failed poll as a user-facing error
      }

      if (_pollAttempts >= _maxPollAttempts && timer.isActive) {
        timer.cancel();
        isPolling = false;
        handleError("This is taking longer than expected. Please try again.");
        setApiResponse(ApiResponse.completed(null));
        update();
        if (!completer.isCompleted) completer.complete();
      }
    });

    return completer.future;
  }

  /// Step 3: user reviewed / edited the extracted fields and tapped confirm.
  Future<bool> confirmJob({
    required String categoryId,
    String? manufacturerId,
    String? model,
    String? serialNumber,
    double? purchasePrice,
    String? purchaseDate,
    String? deliveryDate,
    String? storeId,
  }) async {
    if (jobId == null) {
      handleError("We couldn't find this scan. Please retake the photo.");
      return false;
    }

    bool success = false;
    try {
      isSaving = true;
      update();

      final result = await ocrRepo.confirmOcrJob(
        jobId: jobId!,
        data: {
          "category_id": categoryId,
          "manufacturer_id": manufacturerId ?? "",
          "model": model ?? "",
          "serial_number": serialNumber ?? "",
          "purchase_price": purchasePrice,
          "purchase_date": purchaseDate ?? "",
          "delivery_date": deliveryDate ?? "",
          "store_id": storeId ?? "",
        },
      );

      if (result["data"] != null || result["success"] == true) {
        handleSuccess(
          result["message"] ??
              "Your product has been confirmed and added to your wallet.",
          showSuccessSnackBar: true,
        );
        success = true;
      } else {
        handleError(result["message"] ?? "Couldn't save the item.");
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      isSaving = false;
      setApiResponse(ApiResponse.completed(null));
      update();
    }
    return success;
  }

  void reset() {
    _pollTimer?.cancel();
    isUploading = false;
    isPolling = false;
    isSaving = false;
    jobId = null;
    job = null;
    update();
  }

  @override
  void onClose() {
    _pollTimer?.cancel();
    super.onClose();
  }
}
