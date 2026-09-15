// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:home_keeps/controller/base_controller.dart';
// import 'package:home_keeps/data/response/api_response.dart';
// import 'package:home_keeps/repository/auth_repo.dart';
// import 'package:home_keeps/resources/local_storage.dart';
// import 'package:home_keeps/resources/local_storage_keys.dart';
// import 'package:home_keeps/utils/utils.dart';
// import 'package:home_keeps/views/auth/login_screen.dart';
// import 'package:image_picker/image_picker.dart';

// class AuthController extends BaseController {
//   final AuthRepo authRepo = AuthRepo();
//   // ProfileModel profileModel = ProfileModel();
//   // BuildProfileModel? buildProfileModel;
//   // OrganizerProfileModel organizerProfile = OrganizerProfileModel();
//   TextEditingController signUpEmail = TextEditingController();
//   TextEditingController signUpPassword = TextEditingController();
//   TextEditingController signUpConfirmPassword = TextEditingController();

//   TextEditingController fullName = TextEditingController();
//   TextEditingController loginPassword = TextEditingController();

//   TextEditingController loginEmail = TextEditingController();
//   TextEditingController forgotEmail = TextEditingController();
//   TextEditingController otpController = TextEditingController();
//   TextEditingController newPassword = TextEditingController();
//   TextEditingController currentPassword = TextEditingController();

//   TextEditingController changePasswordNew = TextEditingController();
//   TextEditingController changeConfirmPasswordNew = TextEditingController();

//   final fullNameController = TextEditingController();
//   final firstNameController = TextEditingController();
//   final lastNameController = TextEditingController();
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final confirmPasswordController = TextEditingController();
//   final phoneController = TextEditingController();
//   final businessNameController = TextEditingController();
//   final businessWebsiteController = TextEditingController();
//   final locationController = TextEditingController();
//   TextEditingController editFirstName = TextEditingController();
//   TextEditingController editLastName = TextEditingController();
//   TextEditingController editPhone = TextEditingController();
//   TextEditingController editEmail = TextEditingController();
//   final businessSummaryController = TextEditingController();
//   final servicesProvidedController = TextEditingController();
//   final areasCoveredController = TextEditingController();
//   final experienceController = TextEditingController();
//   final whyChooseYouController = TextEditingController();
//   final awardsQualificationsController = TextEditingController();
//   final serviceAreaController = TextEditingController();
//   final websiteController = TextEditingController();
//   final instagramController = TextEditingController();
//   final facebookController = TextEditingController();
//   final tiktokController = TextEditingController();
//   final youtubeController = TextEditingController();
//   final existingImagesController = TextEditingController();

//   List<String> selectedImages = [];
//   File? profileImageFile;

//   // Example services (multi-select)
//   List<String> selectedServices = [];
//   // List<ServiceCategoryModel> allServiceCategories = [];
//   List<String> selectedServiceCategories = [];
//   bool isFetchingServiceCategories = false;
//   bool isFetchingSupplierServicePreferences = false;
//   bool isUpdatingSupplierServicePreferences = false;

//   bool isLoggingOut = false;
//   bool isUpdatingCoverage = false;
//   bool isLoadingAvailability = false;
//   bool isUpdatingAvailability = false;
//   bool isSwitchingRole = false;
//   bool isUpdatingServicePreferences = false;

//   //Register
//   Future<void> registerSupplier({
//     bool agreeToTerms = false,
//     bool marketingOptIn = false,
//   }) async {
//     try {
//       if (!agreeToTerms) {
//         Utils.errorBar("Please agree to the Terms of Use and Privacy Policy");
//         return;
//       }

//       if (firstNameController.text.trim().isEmpty) {
//         Utils.errorBar("Please enter first name");
//         return;
//       }

//       if (lastNameController.text.trim().isEmpty) {
//         Utils.errorBar("Please enter last name");
//         return;
//       }

//       if (emailController.text.trim().isEmpty) {
//         Utils.errorBar("Please enter email");
//         return;
//       }

//       if (passwordController.text.isEmpty) {
//         Utils.errorBar("Please enter password");
//         return;
//       }

//       if (confirmPasswordController.text.isEmpty) {
//         Utils.errorBar("Please confirm password");
//         return;
//       }

//       if (passwordController.text != confirmPasswordController.text) {
//         Utils.errorBar("Passwords do not match");
//         return;
//       }
//       // String? fcmToken = await FCMService.getFCMToken();

//       setLoading();

//       final result = await authRepo.supplierRegister(
//         email: emailController.text.trim().toLowerCase(),
//         password: passwordController.text,
//         firstName: firstNameController.text.trim(),
//         lastName: lastNameController.text.trim(),
//         phone: phoneController.text.trim(),
//         businessName: businessNameController.text.trim(),
//         businessWebsite: businessWebsiteController.text.trim(),
//         location: locationController.text.trim(),
//         services: selectedServices,
//         marketingOptIn: marketingOptIn,
//         termsAgreed: agreeToTerms,
//         deviceType: Platform.isIOS ? "ios" : "android",
//         // deviceToken: fcmToken ?? '123',
//       );

//       debugPrint("REGISTER RESPONSE => $result");

//       final data = result["data"];

//       if (data != null && data["access_token"] != null) {
//         await LocalStorage.saveAccessToken(
//            data["access_token"],
//         );
//         await LocalStorage.saveJson(
//           key: LocalStorageKeys.userId,
//           value: data['id'],
//         );

//         await LocalStorage.saveRefreshToken(
//           data["refresh_token"],
//         );
//         await LocalStorage.saveJson(
//           key: LocalStorageKeys.role,
//           value: "supplier",
//         );

//         Utils.logSuccess("Account created successfully");

//         handleSuccess(
//           "Account created successfully!",
//           showSuccessSnackBar: true,
//         );
//         Get.to(
//           () => BuildYourProfileScreen(),
//           transition: Transition.rightToLeft,
//         );
//       } else {
//         Utils.errorBar("Registration failed. Try again.");
//       }
//     } catch (e) {
//       handleError(e.toString());
//     } finally {
//       setApiResponse(ApiResponse.completed(null));
//       update();
//     }
//   }

//   Future<bool> supplierBusinessProfile({
//     String? businessSummary,
//     String? servicesProvided,
//     String? areasCovered,
//     String? experience,
//     String? whyChooseYou,
//     String? awardsQualifications,
//     String? serviceArea,
//     String? address,
//     String? lat,
//     String? lng,
//     String? radius,
//     String? website,
//     String? instagram,
//     String? facebook,
//     String? tiktok,
//     String? youtube,
//     String? existingImages,
//     List<File>? images,
//   }) async {
//     try {
//       setLoading();

//       final result = await authRepo.supplierBusinessProfile(
//         businessSummary: businessSummary,
//         servicesProvided: servicesProvided,
//         areasCovered: areasCovered,
//         experience: experience,
//         whyChooseYou: whyChooseYou,
//         awardsQualifications: awardsQualifications,
//         serviceArea: serviceArea,
//         address: address,
//         lat: lat,
//         lng: lng,
//         radius: radius,
//         website: website,
//         instagram: instagram,
//         facebook: facebook,
//         tiktok: tiktok,
//         youtube: youtube,
//         existingImages: existingImages,
//         images: images,
//       );

//       debugPrint("UPDATE SUPPLIER PROFILE RESPONSE => $result");

//       Utils.logSuccess("Profile updated successfully");

//       handleSuccess("Profile updated successfully!", showSuccessSnackBar: true);

//       update();
//       return true;
//     } catch (e) {
//       handleError(e.toString());
//       return false;
//     } finally {
//       setApiResponse(ApiResponse.completed(null));
//       update();
//     }
//   }

//   Future<void> getSupplierBusinessProfileData() async {
//     try {
//       setLoading();
//       final result = await authRepo.getSupplierBusinessProfile();
//       buildProfileModel = result;
//       setApiResponse(ApiResponse.completed(result));
//       handleSuccess('', showSuccessSnackBar: false);
//       update();
//     } catch (e) {
//       setApiResponse(ApiResponse.error(e.toString()));
//       handleError(e.toString());
//     }
//   }

//   Future<bool> updateSupplierBusinessProfile({
//     String? businessSummary,
//     String? servicesProvided,
//     String? areasCovered,
//     String? experience,
//     String? whyChooseYou,
//     String? awardsQualifications,
//     String? serviceArea,
//     String? address,
//     String? lat,
//     String? lng,
//     String? radius,
//     String? website,
//     String? instagram,
//     String? facebook,
//     String? tiktok,
//     String? youtube,
//     List<String>? existingImages,
//     List<File>? images,
//   }) async {
//     try {
//       setLoading();

//       final result = await authRepo.updateSupplierBusinessProfile(
//         businessSummary: businessSummary,
//         servicesProvided: servicesProvided,
//         areasCovered: areasCovered,
//         experience: experience,
//         whyChooseYou: whyChooseYou,
//         awardsQualifications: awardsQualifications,
//         serviceArea: serviceArea,
//         address: address,
//         lat: lat,
//         lng: lng,
//         radius: radius,
//         website: website,
//         instagram: instagram,
//         facebook: facebook,
//         tiktok: tiktok,
//         youtube: youtube,
//         existingImages: existingImages,
//         images: images,
//       );

//       debugPrint("UPDATE SUPPLIER PROFILE RESPONSE => $result");

//       Utils.logSuccess("Profile updated successfully");

//       handleSuccess("Profile updated successfully!", showSuccessSnackBar: true);

//       update();
//       return true;
//     } catch (e) {
//       handleError(e.toString());
//       return false;
//     } finally {
//       setApiResponse(ApiResponse.completed(null));
//       update();
//     }
//   }

//   //Login
//   Future<void> login() async {
//     try {
//       if (loginEmail.text.isEmpty) {
//         Utils.errorBar("Please enter Email");
//         return;
//       }

//       if (loginPassword.text.isEmpty) {
//         Utils.errorBar("Please enter Password");
//         return;
//       }

//       final String emailToPass = loginEmail.text.trim().toLowerCase();
//       // String? fcmToken = await FCMService.getFCMToken();

//       setLoading();

//       final result = await authRepo.login(
//         email: emailToPass,
//         password: loginPassword.text,
//         // deviceToken: fcmToken ?? '123',
//         deviceType: Platform.isIOS ? 'ios' : "android",
//       );

//       if (result["status"] == "success" && result["data"] != null) {
//         final data = result["data"];
//         final String userId = data["id"] ?? "";

//         final String accessToken = data["access_token"] ?? "";
//         final String refreshToken = data["refresh_token"] ?? "";
//         final String role = (data["role"] ?? "").toString().toLowerCase();
//         await LocalStorage.saveJson(
//           key: LocalStorageKeys.userId,
//           value: userId,
//         );

//         // Save tokens
//         await LocalStorage.saveAccessToken(
//           accessToken,
//         );

//         await LocalStorage.saveRefreshToken(
//       refreshToken,
//         );
//         await LocalStorage.saveJson(key: LocalStorageKeys.role, value: role);

//         handleSuccess(
//           result["message"] ?? "Login Successful!",
//           showSuccessSnackBar: true,
//         );

//         loginEmail.clear();
//         loginPassword.clear();

//         // Navigation based on role
//         switch (role.toLowerCase()) {
//           case "supplier":
//             Get.offAll(
//               () => SupplierNavigatorScreen(),
//               transition: Transition.rightToLeft,
//             );
//             break;

//           case "organizer":
//             Get.offAll(
//               () => OrganizationNavigatorScreen(initialIndex: 0),
//               transition: Transition.rightToLeft,
//             );
//             break;
//         }
//       } else {
//         handleError(result["message"] ?? "Login failed");
//       }
//     } catch (e) {
//       handleError(e.toString());
//     } finally {
//       setApiResponse(ApiResponse.completed(null));
//       update();
//     }
//   }

//   //forgot Password
//   Future<void> forgotPassword() async {
//     try {
//       String email = forgotEmail.text.trim().toLowerCase();

//       bool isValidEmail = RegExp(
//         r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$',
//       ).hasMatch(email);

//       if (email.isEmpty || !isValidEmail) {
//         Utils.errorBar("Please enter a valid email");
//         return;
//       }

//       setLoading();

//       final result = await authRepo.forgotPassword(email: email);

//       Utils.logSuccess("Forgot Password Response: $result");

//       if (result != null && result["status"] == "success") {
//         handleSuccess(
//           result["message"] ?? "OTP sent to your email",
//           showSuccessSnackBar: true,
//         );

//         // Get.to(
//         //   () => VerifyOtpScreen(email: email),
//         //   transition: Transition.rightToLeft,
//         // );
//       } else {
//         Utils.errorBar(
//           result?["message"] ?? "Something went wrong. Please try again.",
//         );
//       }
//     } catch (e) {
//       Utils.logError("Forgot Password Error: $e");
//       handleError(e.toString());
//     } finally {
//       setApiResponse(ApiResponse.completed(null));
//       update();
//     }
//   }

//   //Verify OTP
//   Future<void> verifyOTP() async {
//     try {
//       setLoading();

//       if (otpController.text.trim().isEmpty) {
//         Utils.errorBar("Please enter OTP");
//         return;
//       }

//       final result = await authRepo.verifyOTP(
//         otp: otpController.text.trim(),
//         email: forgotEmail.text.trim().toLowerCase(),
//       );

//       debugPrint("Verify OTP Response: $result");

//       if (result != null &&
//           result["status"] == "success" &&
//           result["data"] != null &&
//           result["data"]["reset_token"] != null) {
//         final resetToken = result["data"]["reset_token"];

//       await LocalStorage.saveResetToken(resetToken);

//         Utils.logSuccess("Reset token saved successfully");

//         otpController.clear();

//         // Get.to(() => ResetPasswordScreen(), transition: Transition.rightToLeft);
//       } else {
//         Utils.errorBar(result?["message"] ?? "Invalid OTP response");
//       }
//     } catch (e) {
//       Utils.logError("Verify OTP Error: $e");
//       handleError(e.toString());
//     } finally {
//       setApiResponse(ApiResponse.completed(null));
//       update();
//     }
//   }

//   //Reset Password
//   Future<void> resetPassword() async {
//     try {
//       if (newPassword.text.trim().isEmpty) {
//         Utils.errorBar("Please enter new password");
//         return;
//       }

//      final resetToken = await LocalStorage.getResetToken();

//       if (resetToken == null || resetToken.toString().isEmpty) {
//         Utils.errorBar(
//           "Reset token not found. Please start forgot password process again.",
//         );
//         return;
//       }

//       setLoading();

//       final result = await authRepo.resetPassword(
//         newPassword: newPassword.text.trim(),
//         resetToken: resetToken.toString(),
//       );

//       debugPrint("Reset Password Response: $result");

//       if (result != null &&
//           result["status"]?.toString().toLowerCase() == "success") {
//         forgotEmail.clear();
//         otpController.clear();
//         newPassword.clear();

//        await LocalStorage.deleteResetToken();

//         handleSuccess(
//           result["message"] ?? "Password reset successfully",
//           showSuccessSnackBar: true,
//         );

//         Get.offAll(() => LoginScreen(), transition: Transition.leftToRight);
//       } else {
//         Utils.errorBar(result?["message"] ?? "Password reset failed");
//       }
//     } catch (e) {
//       handleError(e.toString());
//     } finally {
//       setApiResponse(ApiResponse.completed(null));
//       update();
//     }
//   }

//   //Change Password
//   Future<void> changePassword() async {
//     try {
//       setLoading();
//       if (currentPassword.text.trim().isEmpty) {
//         Utils.errorBar("Please enter current password");
//         return;
//       }
//       if (changePasswordNew.text.trim().isEmpty) {
//         Utils.errorBar("Please enter new password");
//         return;
//       }
//       if (changeConfirmPasswordNew.text.trim().isEmpty) {
//         Utils.errorBar('Please enter confirm password');
//         return;
//       }

//       if (changePasswordNew.text.trim() !=
//           changeConfirmPasswordNew.text.trim()) {
//         Utils.errorBar('The new passwords do not match.');
//         return;
//       }

//       final result = await authRepo.changePassword(
//         newPassword: changePasswordNew.text.trim(),
//         currentPassword: currentPassword.text.trim(),
//       );

//       debugPrint("Change Password Response: $result");

//       if (result["status"] == true || result["message"] != null) {
//         // Clear all forgot password data
//         changePasswordNew.clear();
//         currentPassword.clear();
//         changeConfirmPasswordNew.clear();

//         handleSuccess(
//           result["message"] ?? "Password changed successfully",
//           showSuccessSnackBar: true,
//         );

//         Get.back();
//       }
//     } catch (e) {
//       handleError(e.toString());
//     } finally {
//       setApiResponse(ApiResponse.completed(null));
//       update();
//     }
//   }

//   // Delete User
//   Future<void> deleteUser() async {
//     try {
//       setLoading();
//       var result = await authRepo.deleteUser();
//       if (result["status"] == "success") {
//         handleSuccess(result["message"], showSuccessSnackBar: true);
//         LocalStorage.deleteJson(key: LocalStorageKeys.accessToken);
//         LocalStorage.deleteJson(key: LocalStorageKeys.userId);
//         Get.offAll(() => LoginScreen(), transition: Transition.leftToRight);
//       }
//     } catch (e) {
//       handleError(e.toString());
//     } finally {
//       setApiResponse(ApiResponse.completed(null));
//       update();
//     }
//   }

//   Future<void> switchRole(String targetRole) async {
//     try {
//       isSwitchingRole = true;
//       update();

//       final result = await authRepo.switchRole(role: targetRole);

//       if (result["status"] == "success" && result["data"] != null) {
//         final data = result["data"];
//         final String role = (data["role"] ?? targetRole)
//             .toString()
//             .toLowerCase();
//         final bool needsOnboarding = data["needs_onboarding"] == true;

//         await LocalStorage.saveJson(key: LocalStorageKeys.role, value: role);

//         handleSuccess(
//           result["message"] ?? "Role switched successfully",
//           showSuccessSnackBar: true,
//         );

//         switch (role) {
//           case "supplier":
//             if (needsOnboarding) {
//               Get.offAll(
//                 () => SupplierBusinessProfile(),
//                 transition: Transition.rightToLeft,
//               );
//             } else {
//               Get.offAll(
//                 () => SupplierNavigatorScreen(),
//                 transition: Transition.rightToLeft,
//               );
//             }
//             break;

//           case "organizer":
//             Get.offAll(
//               () => OrganizationNavigatorScreen(),
//               transition: Transition.rightToLeft,
//             );
//             break;
//         }
//       } else {
//         Utils.errorBar(result["message"] ?? "Failed to switch role");
//       }
//     } catch (e) {
//       handleError(e.toString());
//     } finally {
//       isSwitchingRole = false;
//       update();
//     }
//   }

//   Future logout() async {
//     try {
//       isLoggingOut = true;
//       update();

//       final refreshToken = await LocalStorage.getRefreshToken();
// final deviceToken = await LocalStorage.getDeviceToken();

//       await authRepo.logout(
//         refreshToken: refreshToken.toString(),
//         deviceToken: deviceToken.toString(),
//       );

//       // 1. Clear storage FIRST
//     await LocalStorage.deleteAccessToken();
// await LocalStorage.deleteRefreshToken();
//       await LocalStorage.deleteJson(key: LocalStorageKeys.deviceToken);
//       await LocalStorage.deleteJson(key: LocalStorageKeys.userId);
//       await LocalStorage.deleteJson(key: LocalStorageKeys.role);

//       // 2. Delete all controllers BEFORE navigating
//       if (Get.isRegistered<OrganizerQuotesController>()) {
//         Get.delete<OrganizerQuotesController>(force: true);
//       }
//       if (Get.isRegistered<NavigationController>()) {
//         Get.delete<NavigationController>(force: true);
//       }

//       // 3. Navigate last
//       Get.offAll(() => LoginScreen(), transition: Transition.leftToRight);
//     } catch (e) {
//       await LocalStorage.deleteJson(key: LocalStorageKeys.accessToken);
//       await LocalStorage.deleteJson(key: LocalStorageKeys.refreshToken);
//       await LocalStorage.deleteJson(key: LocalStorageKeys.deviceToken);
//       await LocalStorage.deleteJson(key: LocalStorageKeys.userId);
//       await LocalStorage.deleteJson(key: LocalStorageKeys.role);

//       if (Get.isRegistered<OrganizerQuotesController>()) {
//         Get.delete<OrganizerQuotesController>(force: true);
//       }
//       if (Get.isRegistered<NavigationController>()) {
//         Get.delete<NavigationController>(force: true);
//       }

//       Get.offAll(() => LoginScreen(), transition: Transition.leftToRight);
//     } finally {
//       isLoggingOut = false;
//     }
//   }

//   Future<void> getProfile() async {
//     try {
//       setLoading();

//       final result = await authRepo.getProfile();

//       profileModel = result;

//       setApiResponse(ApiResponse.completed(result));

//       handleSuccess('', showSuccessSnackBar: false);

//       update();
//     } catch (e) {
//       setApiResponse(ApiResponse.error(e.toString()));

//       handleError(e.toString());
//     }
//   }

//   Future<void> organizerFetchProfile() async {
//     final token = LocalStorage.readJson(key: LocalStorageKeys.accessToken);
//     if (token == null || token.toString().isEmpty) return;

//     try {
//       setLoading();
//       final result = await authRepo.organizerFetchProfile();
//       organizerProfile = result;
//       setApiResponse(ApiResponse.completed(result));
//       handleSuccess('', showSuccessSnackBar: false);
//       update();
//     } catch (e) {
//       setApiResponse(ApiResponse.error(e.toString()));
//       handleError(e.toString());
//     }
//   }

//   //Update Profile
//   Future<void> updateProfile() async {
//     try {
//       if (editFirstName.text.trim().isEmpty) {
//         Utils.errorBar("Please enter first name");
//         return;
//       }

//       if (editLastName.text.trim().isEmpty) {
//         Utils.errorBar("Please enter last name");
//         return;
//       }

//       setLoading();

//       final result = await authRepo.updateProfile(
//         firstName: editFirstName.text.trim(),
//         lastName: editLastName.text.trim(),
//         phone: editPhone.text.trim(),
//         profileImage: profileImageFile,
//         email: editEmail.text.trim(),
//       );

//       debugPrint("UPDATE PROFILE RESPONSE => $result");

//       if (result["status"] == "success") {
//         await getProfile();
//         await organizerFetchProfile();

//         handleSuccess(
//           result["message"] ?? "Profile updated successfully",
//           showSuccessSnackBar: true,
//         );

//         Get.close(1);
//       } else {
//         Utils.errorBar(result["message"] ?? "Failed to update profile");
//       }
//     } catch (e) {
//       handleError(e.toString());
//     } finally {
//       setApiResponse(ApiResponse.completed(null));
//       update();
//     }
//   }

//   Future<bool> updateCoverageArea({
//     required String location,
//     required int distanceMiles,
//     required bool blockRequestsWithoutPhone,
//   }) async {
//     final coverageArea = CoverageArea(
//       location: location,
//       distanceMiles: distanceMiles,
//       blockRequestsWithoutPhone: blockRequestsWithoutPhone,
//     );

//     try {
//       isUpdatingCoverage = true;
//       update();

//       final result = await authRepo.updateCoverageArea(coverageArea);
//       final isSuccess = result['status'] == 'success';

//       if (isSuccess) {
//         final data = result['data'] as Map<String, dynamic>?;
//         final updatedCoverage = data != null
//             ? CoverageArea.fromJson(data)
//             : coverageArea;

//         profileModel = ProfileModel(
//           email: profileModel.email,
//           firstName: profileModel.firstName,
//           lastName: profileModel.lastName,
//           phone: profileModel.phone,
//           role: profileModel.role,
//           profilePhotoUrl: profileModel.profilePhotoUrl,
//           supplierProfile: profileModel.supplierProfile,
//           notificationPreferences: profileModel.notificationPreferences,
//           isDeactivated: profileModel.isDeactivated,
//           createdAt: profileModel.createdAt,
//           id: profileModel.id,
//           coverageArea: updatedCoverage,
//           availability: profileModel.availability,
//           servicePreferences: profileModel.servicePreferences,
//         );

//         handleSuccess(
//           result['message'] ?? 'Coverage area updated',
//           showSuccessSnackBar: true,
//         );
//       } else {
//         handleError(result['message'] ?? 'Failed to update coverage area');
//       }

//       return isSuccess;
//     } catch (e) {
//       handleError(e.toString());
//       return false;
//     } finally {
//       isUpdatingCoverage = false;
//       update();
//     }
//   }

//   Future<void> fetchAvailability({bool forceRefresh = false}) async {
//     if (profileModel.availability != null && !forceRefresh) return;

//     try {
//       isLoadingAvailability = true;
//       update();

//       final result = await authRepo.fetchAvailability();
//       if (result['status'] == 'success' && result['data'] != null) {
//         _patchProfileAvailability(Availability.fromJson(result['data']));
//       }
//     } catch (e) {
//       handleError(e.toString());
//     } finally {
//       isLoadingAvailability = false;
//       update();
//     }
//   }

//   Future<bool> updateAvailability({
//     required List<String> blockedDates,
//     required List<String> workingDays,
//     required String? workingHoursStart,
//     required String? workingHoursEnd,
//   }) async {
//     final availability = Availability(
//       blockedDates: blockedDates,
//       workingDays: workingDays,
//       workingHoursStart: workingHoursStart,
//       workingHoursEnd: workingHoursEnd,
//     );

//     try {
//       isUpdatingAvailability = true;
//       update();

//       final result = await authRepo.updateAvailability(availability);

//       debugPrint("UPDATE AVAILABILITY RESPONSE => $result");

//       if (result["status"] == "success") {
//         if (result["data"] != null) {
//           _patchProfileAvailability(Availability.fromJson(result["data"]));
//         }

//         handleSuccess(
//           result["message"] ?? "Availability updated successfully",
//           showSuccessSnackBar: true,
//         );

//         update();
//         return true;
//       } else {
//         Utils.errorBar(result["message"] ?? "Failed to update availability");
//         return false;
//       }
//     } catch (e) {
//       handleError(e.toString());
//       return false;
//     } finally {
//       isUpdatingAvailability = false;
//       setApiResponse(ApiResponse.completed(null));
//       update();
//     }
//   }

//   void _patchProfileAvailability(Availability availability) {
//     profileModel = ProfileModel(
//       email: profileModel.email,
//       firstName: profileModel.firstName,
//       lastName: profileModel.lastName,
//       phone: profileModel.phone,
//       role: profileModel.role,
//       profilePhotoUrl: profileModel.profilePhotoUrl,
//       supplierProfile: profileModel.supplierProfile,
//       notificationPreferences: profileModel.notificationPreferences,
//       isDeactivated: profileModel.isDeactivated,
//       createdAt: profileModel.createdAt,
//       id: profileModel.id,
//       coverageArea: profileModel.coverageArea,
//       availability: availability,
//       servicePreferences: profileModel.servicePreferences,
//     );
//   }

//   Future<bool> updateServicePreferences({
//     required List<String> preferredCategories,
//     // required int minBudget,
//     // required int maxBudget,
//     // required int minGuests,
//     // required int maxGuests,
//   }) async {
//     try {
//       isUpdatingServicePreferences = true;
//       update();

//       await authRepo.updateServicePreferences(
//         preferredCategories: preferredCategories,
//         // minBudget: minBudget,
//         // maxBudget: maxBudget,
//         // minGuests: minGuests,
//         // maxGuests: maxGuests,
//       );

//       profileModel = ProfileModel(
//         id: profileModel.id,
//         email: profileModel.email,
//         firstName: profileModel.firstName,
//         lastName: profileModel.lastName,
//         phone: profileModel.phone,
//         role: profileModel.role,
//         profilePhotoUrl: profileModel.profilePhotoUrl,
//         supplierProfile: profileModel.supplierProfile,
//         notificationPreferences: profileModel.notificationPreferences,
//         isDeactivated: profileModel.isDeactivated,
//         createdAt: profileModel.createdAt,
//         coverageArea: profileModel.coverageArea,
//         availability: profileModel.availability,
//         businessPhotos: profileModel.businessPhotos,
//         businessLogoUrl: profileModel.businessLogoUrl,
//         businessVideoUrl: profileModel.businessVideoUrl,
//         businessVideoDescription: profileModel.businessVideoDescription,
//         badges: profileModel.badges,
//         avgRating: profileModel.avgRating,
//         reviewCount: profileModel.reviewCount,
//         servicePreferences: ServicePreferences(
//           preferredCategories: preferredCategories,
//           // minBudget: minBudget,
//           // maxBudget: maxBudget,
//           // minGuests: minGuests,
//           // maxGuests: maxGuests,
//         ),
//       );

//       handleSuccess('Service preferences updated successfully.');

//       update();
//       return true;
//     } catch (e) {
//       setApiResponse(ApiResponse.error(e.toString()));
//       handleError(e.toString());
//       return false;
//     } finally {
//       isUpdatingServicePreferences = false;
//       update();
//     }
//   }

//   Future<void> uploadBusinessPhotos(List<XFile> photos) async {
//     try {
//       setLoading();

//       await authRepo.uploadBusinessPhotos(photos);

//       await getProfile();

//       handleSuccess('Photos uploaded successfully.');

//       update();
//     } catch (e) {
//       setApiResponse(ApiResponse.error(e.toString()));
//       handleError(e.toString());
//     }
//   }

//   Future<void> uploadBusinessLogo(XFile logo) async {
//     try {
//       setLoading();

//       await authRepo.uploadBusinessLogo(logo);

//       await getProfile();

//       handleSuccess('Logo uploaded successfully.');

//       update();
//     } catch (e) {
//       setApiResponse(ApiResponse.error(e.toString()));
//       handleError(e.toString());
//     }
//   }

//   Future<void> deleteBusinessPhoto(String url) async {
//     try {
//       setLoading();

//       await authRepo.deleteBusinessPhoto(url);

//       final updatedPhotos = List<String>.from(profileModel.businessPhotos ?? [])
//         ..remove(url);

//       profileModel = ProfileModel(
//         id: profileModel.id,
//         email: profileModel.email,
//         firstName: profileModel.firstName,
//         lastName: profileModel.lastName,
//         phone: profileModel.phone,
//         role: profileModel.role,
//         profilePhotoUrl: profileModel.profilePhotoUrl,
//         supplierProfile: profileModel.supplierProfile,
//         notificationPreferences: profileModel.notificationPreferences,
//         isDeactivated: profileModel.isDeactivated,
//         createdAt: profileModel.createdAt,
//         coverageArea: profileModel.coverageArea,
//         availability: profileModel.availability,
//         servicePreferences: profileModel.servicePreferences,
//         businessPhotos: updatedPhotos,
//         businessLogoUrl: profileModel.businessLogoUrl,
//         businessVideoUrl: profileModel.businessVideoUrl,
//         businessVideoDescription: profileModel.businessVideoDescription,
//         badges: profileModel.badges,
//         avgRating: profileModel.avgRating,
//         reviewCount: profileModel.reviewCount,
//       );

//       handleSuccess('Photo deleted successfully.');

//       update();
//     } catch (e) {
//       setApiResponse(ApiResponse.error(e.toString()));
//       handleError(e.toString());
//     }
//   }

//   Future<void> updateBusinessVideo({
//     required String videoUrl,
//     required String description,
//   }) async {
//     try {
//       setLoading();

//       await authRepo.updateBusinessVideo(
//         videoUrl: videoUrl,
//         description: description,
//       );

//       profileModel = ProfileModel(
//         id: profileModel.id,
//         email: profileModel.email,
//         firstName: profileModel.firstName,
//         lastName: profileModel.lastName,
//         phone: profileModel.phone,
//         role: profileModel.role,
//         profilePhotoUrl: profileModel.profilePhotoUrl,
//         supplierProfile: profileModel.supplierProfile,
//         notificationPreferences: profileModel.notificationPreferences,
//         isDeactivated: profileModel.isDeactivated,
//         createdAt: profileModel.createdAt,
//         coverageArea: profileModel.coverageArea,
//         availability: profileModel.availability,
//         servicePreferences: profileModel.servicePreferences,
//         businessPhotos: profileModel.businessPhotos,
//         businessLogoUrl: profileModel.businessLogoUrl,
//         businessVideoUrl: videoUrl,
//         businessVideoDescription: description,
//         badges: profileModel.badges,
//         avgRating: profileModel.avgRating,
//         reviewCount: profileModel.reviewCount,
//       );

//       handleSuccess('Video updated successfully.');

//       update();
//     } catch (e) {
//       setApiResponse(ApiResponse.error(e.toString()));
//       handleError(e.toString());
//     }
//   }

//   Future<void> updateSupplierProfile(Map<String, dynamic> data) async {
//     try {
//       setLoading();

//       await authRepo.updateSupplierProfile(data);

//       final updatedSupplier = SupplierProfile(
//         businessName: data['business_name'],
//         businessWebsite: data['business_website'],
//         location: data['location'],
//         services: (data['services'] as List?)?.cast<String>(),
//         firstName: data['first_name'],
//         lastName: data['last_name'],
//         phone: data['phone'],
//         email: data['email'],
//         marketingOptIn: data['marketing_opt_in'],
//         termsAgreed: data['terms_agreed'],
//         companyDescription: data['company_description'],
//         portfolioUrls: (data['portfolio_urls'] as List?)?.cast<String>(),
//         facebookUrl: data['facebook_url'],
//         twitterUrl: data['twitter_url'],
//         instagramUrl: data['instagram_url'],
//         tiktokUrl: data['tiktok_url'],
//         paymentMethod: data['payment_method'],
//       );

//       profileModel = ProfileModel(
//         id: profileModel.id,
//         email: profileModel.email,
//         firstName: profileModel.firstName,
//         lastName: profileModel.lastName,
//         phone: profileModel.phone,
//         role: profileModel.role,
//         profilePhotoUrl: profileModel.profilePhotoUrl,
//         supplierProfile: updatedSupplier,
//         notificationPreferences: profileModel.notificationPreferences,
//         isDeactivated: profileModel.isDeactivated,
//         createdAt: profileModel.createdAt,
//         coverageArea: profileModel.coverageArea,
//         availability: profileModel.availability,
//         servicePreferences: profileModel.servicePreferences,
//         businessPhotos: profileModel.businessPhotos,
//         businessLogoUrl: profileModel.businessLogoUrl,
//         businessVideoUrl: profileModel.businessVideoUrl,
//         businessVideoDescription: profileModel.businessVideoDescription,
//         badges: profileModel.badges,
//         avgRating: profileModel.avgRating,
//         reviewCount: profileModel.reviewCount,
//       );

//       handleSuccess('Business profile updated successfully.');

//       update();
//       Get.close(1);
//     } catch (e) {
//       setApiResponse(ApiResponse.error(e.toString()));
//       handleError(e.toString());
//     }
//   }

//   Future<void> fetchServiceCategories({bool forceRefresh = false}) async {
//     if (allServiceCategories.isNotEmpty && !forceRefresh) return;
//     try {
//       isFetchingServiceCategories = true;
//       update();
//       allServiceCategories = await authRepo.getServiceCategories();
//     } catch (e) {
//       handleError(e.toString());
//     } finally {
//       isFetchingServiceCategories = false;
//       update();
//     }
//   }

//   // ── UPDATED — no separate GET call, reuse existing getProfile() ──────────
//   Future<void> fetchSupplierServicePreferences({
//     bool forceRefresh = false,
//   }) async {
//     try {
//       isFetchingSupplierServicePreferences = true;
//       update();

//       if (profileModel.supplierProfile?.services == null || forceRefresh) {
//         await getProfile();
//       }

//       selectedServiceCategories = (profileModel.supplierProfile?.services ?? [])
//           .toSet()
//           .toList();
//     } catch (e) {
//       handleError(e.toString());
//     } finally {
//       isFetchingSupplierServicePreferences = false;
//       update();
//     }
//   }
// }
