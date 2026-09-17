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

  //   Future forgotPassword({required String email}) async {
  //     var response = await _apiService.post(AppUrl.forgotPassword, {
  //       "email": email,
  //     });
  //     return response;
  //   }

  //   //Verify OTP
  //   Future verifyOTP({required String otp, required String email}) async {
  //     var response = await _apiService.post(AppUrl.verifyOtp, {
  //       "email": email,

  //       "otp": otp,
  //     });
  //     return response;
  //   }

  //   Future resetPassword({
  //     required String newPassword,
  //     required String resetToken,
  //   }) async {
  //     var response = await _apiService.post(AppUrl.resetPassword, {
  //       "password": newPassword,

  //       "resetToken": resetToken,
  //     });
  //     return response;
  //   }

  //   Future changePassword({
  //     required String currentPassword,
  //     required String newPassword,
  //   }) async {
  //     var response = await _apiService.post(AppUrl.changePassword, {
  //       "currentPassword": currentPassword,

  //       "newPassword": newPassword,
  //     });
  //     return response;
  //   }

  //   Future signup({
  //     required String email,
  //     required String password,
  //     required String fullName,

  //     String? phone,
  //   }) async {
  //     final Map<String, dynamic> data = {
  //       "email": email,
  //       "password": password,
  //       "name": fullName,
  //     };

  //     if (phone != null && phone.trim().isNotEmpty) {
  //       data["phone"] = phone.trim();
  //     }

  //     final response = await _apiService.post(AppUrl.signup, data);

  //     return response;
  //   }

  //   Future allowNotifications({
  //     bool? enabled,
  //     bool? gameInvites,
  //     bool? dailySpinReminder,
  //     bool? newVendorsNearby,
  //   }) async {
  //     final Map<String, dynamic> data = {};

  //     if (enabled != null) data["notificationsEnabled"] = enabled;
  //     if (gameInvites != null) data["gameInvites"] = gameInvites;
  //     if (dailySpinReminder != null)
  //       data["dailySpinReminder"] = dailySpinReminder;
  //     if (newVendorsNearby != null) data["newVendorsNearby"] = newVendorsNearby;

  //     final response = await _apiService.post(AppUrl.notifications, data);
  //     return response;
  //   }

  //   Future submitOnboarding({
  //     required String foodPersonality,
  //     required List<String> cuisines,
  //   }) async {
  //     final response = await _apiService.post(AppUrl.onboarding, {
  //       "foodPersonality": foodPersonality,
  //       "cuisines": cuisines,
  //     });
  //     return response;
  //   }

  //   Future<ProfileModel> getProfile() async {
  //     final response = await _apiService.get(AppUrl.getProfile);
  //     return ProfileModel.fromJson(response);
  //   }

  //   Future<Map<String, dynamic>> logout({
  //     required String refreshToken,
  //     required String deviceToken,
  //   }) async {
  //     final response = await _apiService.post(AppUrl.logout, {});
  //     return response;
  //   }

  //   Future<Map<String, dynamic>> updateSecuritySettings({
  //     bool? faceLockEnabled,
  //     bool? biometricEnabled,
  //   }) async {
  //     final Map<String, dynamic> data = {};
  //     if (faceLockEnabled != null) data["faceLockEnabled"] = faceLockEnabled;
  //     if (biometricEnabled != null) data["biometricEnabled"] = biometricEnabled;

  //     final response = await _apiService.post(AppUrl.security, data);
  //     return response;
  //   }

  //   Future<dynamic> updateProfile({
  //     String? name,
  //     String? email,
  //     File? avatar,
  //   }) async {
  //     final fields = <String, dynamic>{
  //       if (name != null && name.isNotEmpty) "name": name,
  //       if (email != null && email.isNotEmpty) "email": email,
  //     };

  //     final files = <String, List<File>>{
  //       if (avatar != null) "avatar": [avatar],
  //     };

  //     return await _apiService.patchMultipart(
  //       url: AppUrl.getProfile,
  //       fields: fields,
  //       files: files,
  //     );
  //   }
}
