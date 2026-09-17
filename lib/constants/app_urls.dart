class AppUrl {
  static const String baseUrl = 'https://homekeep-backend-x07s.onrender.com/v1';

  static const String login = '$baseUrl/auth/otp/request';
  static const String verifyOtp = '$baseUrl/auth/otp/verify';
  static const String logout = '$baseUrl/auth/logout';
  static const String customerConsents = '$baseUrl/customers/me/consents';
  static const String customerMe = '$baseUrl/customers/me';
  static const String product = '$baseUrl/products';
}
