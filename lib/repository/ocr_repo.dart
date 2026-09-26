import 'dart:io';

import 'package:home_keeps/constants/app_urls.dart';
import 'package:home_keeps/data/network/network_api_service.dart';

class OcrRepo {
  final NetworkApiService _apiService = NetworkApiService();

  Future createOcrJob({
    required File file,
    required String type,
    String language = 'auto',
  }) async {
    final response = await _apiService.postMultipart(
      url: AppUrl.ocrJobs,
      fields: {'type': type, 'language': language},
      files: {
        'file': [file],
      },
    );

    return response;
  }

  Future getOcrJobStatus(String jobId) async {
    final response = await _apiService.get('${AppUrl.ocrJobStatus}/$jobId');
    return response;
  }

  Future confirmOcrJob({
    required String jobId,
    required Map<String, dynamic> data,
  }) async {
    final response = await _apiService.post(
      '${AppUrl.ocrJobConfirm}/$jobId/confirm',
      data,
    );
    return response;
  }
}
