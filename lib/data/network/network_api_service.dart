import 'dart:convert';
import 'dart:io';

import 'package:get/state_manager.dart';
import 'package:home_keeps/constants/app_urls.dart';
import 'package:home_keeps/resources/local_storage.dart';
import 'package:home_keeps/utils/utils.dart';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart' as http_parser;

class NetworkApiService extends GetxService {
  /// Prevents multiple refresh requests at the same time.
  Future<bool>? _refreshFuture;

  /// Retrieves the authorization token from secure storage.
  Future<String> _getToken() async {
    final token = await LocalStorage.getAccessToken();

    if (token == null || token.isEmpty) {
      return '';
    }

    return "Bearer $token";
  }

  /// Default headers for all requests.
  Future<Map<String, String>> _defaultHeaders() async {
    final token = await _getToken();

    return {
      'Content-type': 'application/json',
      if (token.isNotEmpty) 'Authorization': token,
      'accept': 'application/json',
    };
  }

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

    if (detail is String && detail.isNotEmpty) {
      return detail;
    }

    return responseJson['message']?.toString() ??
        responseJson['error']?.toString() ??
        responseJson['errors']?.toString();
  }

  dynamic _processResponse(http.Response response) {
    final dynamic responseJson = response.body.trim().isEmpty
        ? null
        : jsonDecode(response.body);

    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
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

  /// Refreshes the access token using the stored refresh token.
  ///
  /// If multiple API calls receive 401 at the same time,
  /// they will all wait for the same refresh request.
  Future<bool> _refreshAccessToken() async {
    if (_refreshFuture != null) {
      return _refreshFuture!;
    }

    _refreshFuture = _performRefresh();

    try {
      return await _refreshFuture!;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<bool> _performRefresh() async {
    try {
      final refreshToken = await LocalStorage.getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        Utils.logInfo("Refresh token not found", name: "AUTH");

        return false;
      }

      Utils.logInfo("Access token expired. Refreshing token...", name: "AUTH");

      final response = await http.post(
        Uri.parse(AppUrl.refresh),
        headers: {
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: jsonEncode({"refresh_token": refreshToken}),
      );

      _logResponse(response);

      if (response.statusCode != 200) {
        Utils.logInfo("Token refresh failed", name: "AUTH");

        return false;
      }

      final responseJson = jsonDecode(response.body);

      final data = responseJson['data'];

      if (data is! Map) {
        Utils.logInfo("Invalid refresh response", name: "AUTH");

        return false;
      }

      final newAccessToken = data['access_token']?.toString();
      final newRefreshToken = data['refresh_token']?.toString();

      if (newAccessToken == null || newAccessToken.isEmpty) {
        Utils.logInfo("New access token not found", name: "AUTH");

        return false;
      }

      await LocalStorage.saveAccessToken(newAccessToken);

      if (newRefreshToken != null && newRefreshToken.isNotEmpty) {
        await LocalStorage.saveRefreshToken(newRefreshToken);
      }

      Utils.logSuccess("Access token refreshed successfully", name: "AUTH");

      return true;
    } on SocketException {
      Utils.logInfo("SocketException while refreshing token", name: "AUTH");

      return false;
    } catch (e) {
      Utils.logInfo("Token refresh error: $e", name: "AUTH");

      return false;
    }
  }

  /// Sends request and automatically refreshes the access token
  /// once if the server returns 401.
  Future<dynamic> _sendRequest(
    Future<http.Response> Function() requestFunc, {
    bool isRetry = false,
  }) async {
    try {
      final response = await requestFunc();

      _logResponse(response);

      if (response.statusCode == 401 && !isRetry) {
        Utils.logInfo(
          "401 received. Trying to refresh access token...",
          name: "AUTH",
        );

        final refreshed = await _refreshAccessToken();

        if (refreshed) {
          Utils.logInfo(
            "Retrying original request with new access token...",
            name: "AUTH",
          );

          return _sendRequest(requestFunc, isRetry: true);
        }

        Utils.logInfo("Refresh failed. Clearing credentials...", name: "AUTH");

        await LocalStorage.clearCredentials();
      }

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

    return _sendRequest(() async {
      final headers = await _defaultHeaders();

      return http.get(uri, headers: headers);
    });
  }

  Future<dynamic> post(String url, dynamic data) async {
    Utils.logInfo("data $data");

    return _sendRequest(() async {
      final headers = await _defaultHeaders();

      return http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );
    });
  }

  Future<dynamic> put(String url, dynamic data) async {
    return _sendRequest(() async {
      final headers = await _defaultHeaders();

      return http.put(Uri.parse(url), headers: headers, body: jsonEncode(data));
    });
  }

  Future<dynamic> patch(String url, dynamic data) async {
    return _sendRequest(() async {
      final headers = await _defaultHeaders();

      return http.patch(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(data),
      );
    });
  }

  Future<dynamic> delete(String url) async {
    return _sendRequest(() async {
      final headers = await _defaultHeaders();

      return http.delete(Uri.parse(url), headers: headers);
    });
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

  /// Multipart PUT request
  Future<dynamic> putMultipart({
    required String url,
    required Map<String, dynamic> fields,
    required Map<String, List<File>> files,
    Map<String, String>? headers,
  }) async {
    return sendMultipart('PUT', url, fields, files);
  }

  /// Multipart PATCH request
  Future<dynamic> patchMultipart({
    required String url,
    required Map<String, dynamic> fields,
    required Map<String, List<File>> files,
    Map<String, String>? headers,
  }) async {
    return sendMultipart('PATCH', url, fields, files);
  }

  /// Handles multipart requests for POST, PUT and PATCH.
  Future<dynamic> sendMultipart(
    String method,
    String url,
    Map<String, dynamic> fields,
    Map<String, List<File>> files,
  ) async {
    return _sendRequest(() async {
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

      return request.send().then(http.Response.fromStream);
    });
  }

  http_parser.MediaType _getContentType(String extension) {
    final ext = extension.toLowerCase();

    switch (ext) {
      case 'jpg':
      case 'jpeg':
        return http_parser.MediaType('image', 'jpeg');
      case 'png':
        return http_parser.MediaType('image', 'png');
      case 'gif':
        return http_parser.MediaType('image', 'gif');
      case 'bmp':
        return http_parser.MediaType('image', 'bmp');
      case 'heic':
        return http_parser.MediaType('image', 'heic');
      case 'pdf':
        return http_parser.MediaType('application', 'pdf');
      case 'mp4':
      case 'mov':
      case 'avi':
      case 'wmv':
        return http_parser.MediaType('video', ext);
      default:
        return http_parser.MediaType("application", "octet-stream");
    }
  }
}
