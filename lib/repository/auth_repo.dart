import 'package:home_keeps/constants/app_urls.dart';
import 'package:home_keeps/data/network/network_api_service.dart';

class AuthRepo {
  final NetworkApiService _apiService = NetworkApiService();

  //Login
  Future login({required String phone}) async {
    final response = await _apiService.post(AppUrl.login, {"phone": phone});

    return response;
  }

  Future verifyOtp({required String phone, required String code}) async {
    final response = await _apiService.post(AppUrl.verifyOtp, {
      "phone": phone,
      "code": code,
    });

    return response;
  }

  Future logout({required String refreshToken}) async {
    final response = await _apiService.post(AppUrl.logout, {
      "refresh_token": refreshToken,
    });

    return response;
  }

  Future updateConsents({required bool consentMarketing}) async {
    final response = await _apiService.patch(AppUrl.customerConsents, {
      "consent_marketing": consentMarketing,
    });

    return response;
  }

  Future getProfile() async {
    final response = await _apiService.get(AppUrl.customerMe);

    return response;
  }

  Future<dynamic> deleteAccount({String? reason}) async {
    final data = <String, dynamic>{};

    if (reason != null && reason.trim().isNotEmpty) {
      data['reason'] = reason.trim();
    }

    final response = await _apiService.post(AppUrl.deleteAccount, data);

    return response;
  }
}
