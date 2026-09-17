import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:home_keeps/controller/base_controller.dart';
import 'package:home_keeps/data/response/api_response.dart';
import 'package:home_keeps/models/profile_model.dart';

import 'package:home_keeps/repository/auth_repo.dart';
import 'package:home_keeps/resources/local_storage.dart';
import 'package:home_keeps/resources/local_storage_keys.dart';

import 'package:home_keeps/views/auth/navigator_screen.dart';
import 'package:home_keeps/views/auth/otp_verification_screen.dart';

class AuthController extends BaseController {
  final AuthRepo authRepo = AuthRepo();
  ProfileModel? profile;

  TextEditingController phoneController = TextEditingController();

  bool isSendingOtp = false;
  bool isVerifyingOtp = false;
  bool isLoggingOut = false;
  bool isUpdatingConsent = false;
  bool isLoadingProfile = false;

  String _phone = '';
  String get phone => _phone;

  Future<bool> login({
    required String phone,
    bool navigateOnSuccess = true,
  }) async {
    bool success = false;
    try {
      isSendingOtp = true;
      update();

      _phone = phone;

      final result = await authRepo.login(phone: phone);

      if (result["data"] != null) {
        final data = result["data"];

        handleSuccess(
          data["message"] ?? "OTP sent successfully!",
          showSuccessSnackBar: true,
        );

        success = true;

        if (navigateOnSuccess) {
          Get.to(() => OtpVerificationScreen(phoneNumber: phone));
        }
      } else {
        handleError(result["message"] ?? "Failed to send OTP");
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      isSendingOtp = false;
      setApiResponse(ApiResponse.completed(null));
      update();
    }
    return success;
  }

  Future<bool> verifyOtp({required String phone, required String code}) async {
    bool success = false;
    try {
      isVerifyingOtp = true;
      update();

      final result = await authRepo.verifyOtp(phone: phone, code: code);

      if (result["data"] != null &&
          (result["data"]["access_token"] ?? "").toString().isNotEmpty) {
        final data = result["data"];

        final String customerId = data["customer_id"] ?? "";
        final String accessToken = data["access_token"] ?? "";
        final String refreshToken = data["refresh_token"] ?? "";

        await LocalStorage.saveJson(
          key: LocalStorageKeys.userId,
          value: customerId,
        );

        await LocalStorage.saveAccessToken(accessToken);
        await LocalStorage.saveRefreshToken(refreshToken);

        handleSuccess("Verified successfully!", showSuccessSnackBar: true);

        success = true;

        Get.offAll(() => NavigatorScreen(), transition: Transition.rightToLeft);
      } else {
        handleError(result["message"] ?? "That code is not correct.");
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      isVerifyingOtp = false;
      setApiResponse(ApiResponse.completed(null));
      update();
    }
    return success;
  }

  Future<bool> logout() async {
    try {
      isLoggingOut = true;
      update();

      try {
        final String refreshToken = await LocalStorage.getRefreshToken();

        if (refreshToken.isNotEmpty) {
          await authRepo.logout(refreshToken: refreshToken);
        }
      } catch (_) {}

      await LocalStorage.clearCredentials();
      await LocalStorage.saveUserId('');
      await LocalStorage.saveRole('');

      return true;
    } catch (e) {
      handleError(e.toString());
      return false;
    } finally {
      isLoggingOut = false;
      setApiResponse(ApiResponse.completed(null));
      update();
    }
  }

  Future<bool> updateMarketingConsent(bool value) async {
    bool success = false;
    try {
      isUpdatingConsent = true;
      update();
      setLoading();

      final result = await authRepo.updateConsents(consentMarketing: value);

      if (result["data"] != null) {
        // Cache locally so re-opening this screen shows the real state
        // instead of resetting to a hardcoded default.
        await LocalStorage.saveJson(key: _consentMarketingKey, value: value);

        handleSuccess(
          value
              ? "You'll now receive reminders and offers."
              : "You won't receive reminders and offers.",
          showSuccessSnackBar: true,
        );
        success = true;
      } else {
        handleError(result["message"] ?? "Could not update your preference");
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      isUpdatingConsent = false;
      setApiResponse(ApiResponse.completed(null));
      update();
    }
    return success;
  }

  static const _consentMarketingKey = 'consent_marketing_reminders';

  bool getCachedMarketingConsent({bool fallback = true}) {
    final val = LocalStorage.readJson(key: _consentMarketingKey);
    if (val == null) return fallback;
    return val == true;
  }

  Future<bool> fetchProfile() async {
    bool success = false;
    try {
      isLoadingProfile = true;
      update();

      final result = await authRepo.getProfile();

      if (result["data"] != null) {
        profile = ProfileModel.fromJson(result["data"]);

        final consent = profile?.customer?.consentMarketing;
        if (consent != null) {
          await LocalStorage.saveJson(
            key: _consentMarketingKey,
            value: consent,
          );
        }

        success = true;
      } else {
        handleError(result["message"] ?? "Could not load your profile");
      }
    } catch (e) {
      handleError(e.toString());
    } finally {
      isLoadingProfile = false;
      setApiResponse(ApiResponse.completed(null));
      update();
    }
    return success;
  }
}
