import 'dart:convert';
import 'dart:io';

import 'package:get/state_manager.dart';
import 'package:home_keeps/resources/local_storage.dart';
import 'package:home_keeps/utils/utils.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;

class NetworkApiService extends GetxService {
  /// Retrieves the authorization token from secure storage.
  Future<String> _getToken() async {
    final token = await LocalStorage.getAccessToken();
    return "Bearer $token";
  }

  /// Default headers for all requests.
  Future<Map<String, String>> _defaultHeaders() async => {
    'Content-type': 'application/json',
    'Authorization': await _getToken(),
    'accept': 'application/json',
  };

  /// Logs detailed response information for debugging purposes.
  void _logResponse(http.Response response) {
    Utils.logSuccess(
      "[${response.request?.method}] Request URL: ${response.request?.url}",
      name: "APIX",
    );
    Utils.logInfo("Status Code: ${response.statusCode}", name: "APIX");
    Utils.logInfo("Response Headers: ${response.headers}", name: "APIX");
    Utils.logSuccess("Response Body: ${response.body}", name: "APIX");
  }

  String? _extractErrorMessage(dynamic responseJson) {
    if (responseJson is! Map) return null;

    final dynamic detail = responseJson['detail'];

    if (detail is List && detail.isNotEmpty) {
      final first = detail.first;
      if (first is Map && first['msg'] != null) {
        return first['msg'].toString();
      }
      return detail.first.toString();
    }

    if (detail is String && detail.isNotEmpty) return detail;

    return responseJson['message']?.toString() ??
        responseJson['error']?.toString() ??
        responseJson['errors']?.toString();
  }

  dynamic _processResponse(http.Response response) {
    final responseJson = jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
        return responseJson;
      case 400:
        throw Exception(_extractErrorMessage(responseJson) ?? "Bad Request");
      case 401:
        throw Exception(_extractErrorMessage(responseJson) ?? "Unauthorized");
      case 402:
        throw Exception(
          _extractErrorMessage(responseJson) ?? "Payment Required",
        );
      case 403:
        throw Exception(_extractErrorMessage(responseJson) ?? "Forbidden");
      case 404:
        throw Exception(_extractErrorMessage(responseJson) ?? "Not Found");
      case 409:
        throw Exception(_extractErrorMessage(responseJson) ?? "Conflict");
      case 422:
        throw Exception(
          _extractErrorMessage(responseJson) ?? "Validation Error",
        );
      case 429:
        throw Exception(
          _extractErrorMessage(responseJson) ?? "Too Many Requests",
        );
      case 500:
        throw Exception(
          _extractErrorMessage(responseJson) ?? "Internal Server Error",
        );
      case 503:
        throw Exception(
          _extractErrorMessage(responseJson) ?? "Service Unavailable",
        );
      default:
        throw Exception("Unhandled Status Code: ${response.statusCode}");
    }
  }

  Future<dynamic> _sendRequest(
    Future<http.Response> Function() requestFunc,
  ) async {
    try {
      final response = await requestFunc();
      _logResponse(response);
      return _processResponse(response);
    } on SocketException {
      Utils.logInfo("SocketException: No Internet Connection");
      throw const SocketException("No Internet Connection");
    } catch (e) {
      Utils.logInfo("Exception during request: $e");
      rethrow;
    }
  }

  /// Generic HTTP methods for GET, POST, PUT, DELETE requests.
  Future<dynamic> get(String url, {Map<String, dynamic>? params}) async {
    final uri = Uri.parse(url).replace(queryParameters: params);
    final headers = await _defaultHeaders();
    return _sendRequest(() => http.get(uri, headers: headers));
  }

  Future<dynamic> post(String url, dynamic data) async {
    Utils.logInfo("data $data");
    final headers = await _defaultHeaders();
    return _sendRequest(
      () => http.post(Uri.parse(url), headers: headers, body: jsonEncode(data)),
    );
  }

  Future<dynamic> put(String url, dynamic data) async {
    final headers = await _defaultHeaders();
    return _sendRequest(
      () => http.put(Uri.parse(url), headers: headers, body: jsonEncode(data)),
    );
  }

  Future<dynamic> patch(String url, dynamic data) async {
    final headers = await _defaultHeaders();
    return _sendRequest(
      () =>
          http.patch(Uri.parse(url), headers: headers, body: jsonEncode(data)),
    );
  }

  Future<dynamic> delete(String url) async {
    final headers = await _defaultHeaders();
    return _sendRequest(() => http.delete(Uri.parse(url), headers: headers));
  }

  /// Multipart POST request
  Future<dynamic> postMultipart({
    required String url,
    required Map<String, dynamic> fields,
    required Map<String, List<File>> files,
    Map<String, String>? headers,
  }) async {
    return sendMultipart('POST', url, fields, files);
  }

  Future<dynamic> putMultipart({
    required String url,
    required Map<String, dynamic> fields,
    required Map<String, List<File>> files,
    Map<String, String>? headers,
  }) async {
    return sendMultipart('PUT', url, fields, files);
  }

  Future<dynamic> patchMultipart({
    required String url,
    required Map<String, dynamic> fields,
    required Map<String, List<File>> files,
    Map<String, String>? headers,
  }) async {
    return sendMultipart('PATCH', url, fields, files);
  }

  /// Handles multipart requests for both POST and PUT methods.
  Future<dynamic> sendMultipart(
    String method,
    String url,
    Map<String, dynamic> fields,
    Map<String, List<File>> files,
  ) async {
    final headers = await _defaultHeaders();
    final request = http.MultipartRequest(method, Uri.parse(url))
      ..headers.addAll(headers);
    Utils.logInfo("fields $fields\nfiles $files");

    fields.forEach((key, value) {
      if (value is List && key.endsWith('[]')) {
        final newKey = key.replaceFirst('[]', '');
        for (var i = 0; i < value.length; i++) {
          request.fields["$newKey[$i]"] = value[i].toString();
        }
      } else {
        request.fields[key] = value.toString();
      }
    });

    for (var entry in files.entries) {
      for (var file in entry.value) {
        final fileStream = http.ByteStream(file.openRead());
        final length = await file.length();
        final contentType = _getContentType(file.path.split('.').last);
        final multipartFile = http.MultipartFile(
          entry.key,
          fileStream,
          length,
          filename: file.path.split('/').last,
          contentType: contentType,
        );
        request.files.add(multipartFile);
      }
    }

    return _sendRequest(() => request.send().then(http.Response.fromStream));
  }

  http_parser.MediaType _getContentType(String extension) {
    final mediaMap = {
      'video': ['mp4', 'mov', 'avi', 'wmv'],
      'image': ['jpg', 'jpeg', 'png', 'gif', 'bmp'],
    };

    for (var entry in mediaMap.entries) {
      if (entry.value.contains(extension.toLowerCase())) {
        return http_parser.MediaType(entry.key, extension);
      }
    }
    return http_parser.MediaType("application", "octet-stream");
  }
}
