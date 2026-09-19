class AppUrl {
  static const String baseUrl = 'https://homekeep-backend-x07s.onrender.com/v1';

  static const String login = '$baseUrl/auth/otp/request';
  static const String refresh = "$baseUrl/auth/refresh";
  static const String verifyOtp = '$baseUrl/auth/otp/verify';
  static const String logout = '$baseUrl/auth/logout';
  static const String deleteAccount = '$baseUrl/privacy/deletion';
  static const String customerConsents = '$baseUrl/customers/me/consents';
  static const String customerMe = '$baseUrl/customers/me';
  static const String product = '$baseUrl/products';
  static const String homeSummary = '$baseUrl/home/summary';
  static const String warrrantyCase = '$baseUrl/next-best-action';
  static const String productDetail = '$baseUrl/products/';
  static const String serviceCase = "$baseUrl/service-cases/";
  static const String serviceCases = "$baseUrl/service-cases";
  static const String documents = "$baseUrl/documents";
  static const String manufactures = '$baseUrl/products/manufacturers';
}
